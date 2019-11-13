using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class SgBusStopView extends WatchUi.View {

	hidden var _delegate;
	hidden var _idxStart = 0;
	
	function initialize(delegate) {
		View.initialize();
		_delegate = delegate;
	}
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
	function onShow() {
		_delegate.onShow();
		refreshBusData();
	}
	
	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
	function onHide() {
		_delegate.onHide();
		_idxStart = 0;	
	}

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.BusStopLayout(dc));
    }
    
    function onUpdate(dc) {
	
        var timeNow = View.findDrawableById("timenow");
        timeNow.setText(Util.getFormattedTimeNow());
        refreshBusData();
       	View.onUpdate(dc);
    }
    
    function refreshBusData() {
    	clear();
    	var busStop = _delegate._busStop;
    	var buses = _delegate._buses;
        View.findDrawableById("busId").setText(busStop["id"] + "");
        View.findDrawableById("busName").setText(busStop["name"] + "");
        var busIdx = _idxStart * _delegate.LINE_COUNT;
        for (var i = busIdx, v = 0; v < _delegate.LINE_COUNT; i++, v++) {
            var vBus = View.findDrawableById("bus"+v);
        	vBus.setText(i < buses.size() ? buses[i] : "");
        	vBus.setFont(SdkFix.conf["fontBus"]);
       	}
    }
    
    function refreshBusList(idxStart) {
    	_idxStart = idxStart;
    	refreshBusData();
    	WatchUi.requestUpdate();
    }
    
    function clear() {
        for (var i = 0; i < _delegate.LINE_COUNT; i++) {
        	View.findDrawableById("bus"+i).setText("");
       	}
    }
}