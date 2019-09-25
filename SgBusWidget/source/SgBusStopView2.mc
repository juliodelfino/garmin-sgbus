using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class SgBusStopView2 extends WatchUi.View {

	hidden var _delegate;
	hidden var _viewIdx;
	
	function initialize(delegate, viewIdx) {
		View.initialize();
		_delegate = delegate;
		_viewIdx = viewIdx;
	}
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
	function onShow() {
		_delegate.onShow();
	}
	
	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
	function onHide() {
		_delegate.onHide();
	}

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.BusStopLayout2(dc));
    }
    
    function onUpdate(dc) {
    	refreshBusData();
       	View.onUpdate(dc);
    }
    
    function refreshBusData() {
    	clear();
    	var busStop = _delegate._busStop;
    	var buses = _delegate._buses;
    	var busStartIdx = (_viewIdx - 1) * 8;
        for (var i = 4 + busStartIdx, j = 0; i < buses.size() && j < 8; i++, j++) {
        	View.findDrawableById("bus"+j).setText(buses[i]);
       	}
    }
    
    function clear() {
        for (var i = 0; i < 8; i++) {
        	View.findDrawableById("bus"+i).setText("");
       	}
    }
}