using Toybox.WatchUi;
using Toybox.Graphics;

class NearbyViewModel {

	const LINE_COUNT = 6;
	hidden var _view;
	hidden var _lines;
	hidden var _gpsPosition;
	hidden var visible = false;
	
	function initialize(view) {
		_view = view;
	}
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
	function onShow() {
	    visible = true;
		if (_gpsPosition == null) {
			Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    		refreshData(["Searching for GPS...", "Try going outdoors."]);
		} else {
			onPosition(Position.getInfo());
		}
	}
	
	function onHide() {
		visible = false;
	}
    
    function onPosition(info) {
		_gpsPosition = info;
    	if (visible) {
    		var loc = info.position.toDegrees();
		    refreshData(["Getting bus stops..."]);
	    	WebRequestHandler.makeRequestForBusStops(loc, method(:onReceiveBusStops));
	    	visible = false;
    	}
	}
	
	function onReceiveBusStops(responseCode, data) {
		if (data instanceof Toybox.Lang.Array && data.size() > 0) {
       		_view.onReceiveNearbyBusStops(responseCode, data); 
   		} else {
   			refreshData(["No nearby bus stops."]);
   		}  
    }
    
    function refreshData(messages) {
		_lines = [];
		_lines.addAll(messages);
    	for (var i = _lines.size(); i < LINE_COUNT; i++) {
    		_lines.add("");
    	} 
    	
    	_view.refreshViewData(_lines);
	    WatchUi.requestUpdate();
    }
}