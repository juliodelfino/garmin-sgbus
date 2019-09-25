using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class SgBusStopView extends WatchUi.View {

	hidden var _delegate;
	
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
        for (var i = 0; i < buses.size() && i < 4; i++) {   	    
        	View.findDrawableById("bus"+i).setText(buses[i]);
       	}
    }
    
    function clear() {
        for (var i = 0; i < 4; i++) {
        	View.findDrawableById("bus"+i).setText("");
       	}
    }
}