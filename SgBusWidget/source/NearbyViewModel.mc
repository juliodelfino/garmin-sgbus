using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Attention;

class NearbyViewModel {

	const LINE_COUNT = 6;
	hidden var _view;
	hidden var _lines;
	hidden var _gpsPosition;
	hidden var visible = false;
	hidden var _searchKeyword;
	
	function initialize(view) {
		_view = view;
	}
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
	function onShow() {
	    visible = true;
	    if (_searchKeyword != null) {
	    	visible = false;
		    refreshData(["Getting bus stops", "with keyword: ", "" + _searchKeyword ]);
	    	WebRequestHandler.makeRequestForBusStops([0,0], _searchKeyword, method(:onReceiveBusStops));
	    	  	
	    } else if (_gpsPosition == null) {
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
    		var radius = Util.getRadius();
		    refreshData(["Getting bus stops", "within " + radius + "m radius..." ]);
	    	WebRequestHandler.makeRequestForBusStops(loc, "", method(:onReceiveBusStops));
	    	visible = false;
    	}
	}
	
	function searchBusStopsByKeyword(text) {
		_searchKeyword = text;
	}
	
	function onReceiveBusStops(responseCode, data) {
       	_view.onReceiveNearbyBusStops(responseCode, data); 
   		_searchKeyword = null;
   		if (responseCode == 200) {
			if (Attention has :backlight) {
			    Attention.backlight(true);
			} 
			if (Attention has :vibrate) {
	            var vibrateData = [new Attention.VibeProfile(  25, 100 )];
	            Attention.vibrate(vibrateData);
	        }
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