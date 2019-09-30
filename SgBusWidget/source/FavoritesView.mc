using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;

(:glance)
class FavoritesView extends WatchUi.View {

	hidden var LINE_COUNT;
	hidden var _mainDelegate;
	hidden var _lines;
	hidden var pinLocX = 20;
	
	function initialize(mainDelegate) {
		_mainDelegate = mainDelegate;
		View.initialize();	
		_mainDelegate.favoritesViewModel = new FavoritesViewModel(self);
		_mainDelegate.nearbyViewModel = new NearbyViewModel(self);
		_mainDelegate.currentViewModel = _mainDelegate.favoritesViewModel;
		
		LINE_COUNT = Util.conf["favoritesLineCount"];
	}
	
	function getViewModel() {
		return _mainDelegate.currentViewModel;
	}
	
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
	function onShow() {
		if (getViewModel() == _mainDelegate.favoritesViewModel) {
			_mainDelegate.registerTimerEvent(method(:timerCallback));
			getViewModel().invokeWebRequestNow();
		}
		getViewModel().onShow();
	}
	
	function timerCallback() {
		getViewModel().timerCallback();
	}
	
	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
	function onHide() {
		if (getViewModel() == _mainDelegate.favoritesViewModel) {
			_mainDelegate.resetTimerEvent();
		}
		getViewModel().onHide();
	}

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.FavoritesLayout(dc));
    }
    
    function onReceiveMixedBuses(responseCode, data) {
       if (responseCode != 200) {
           View.findDrawableById("fave1").setText("HTTP error [" + responseCode + "]");
       }
	   WatchUi.requestUpdate();
    }
    
    function refreshViewData(lines) {
        
        for (var i = 0; i < lines.size() && i < LINE_COUNT; i++) {
        	var busStopNo = lines[i].toNumber();
			var isBusNo = busStopNo != null && busStopNo > 1000;
			var pin = View.findDrawableById("pin"+i);
        	pin.setLocation(isBusNo ? pinLocX : -20, pin.locY);
        	var field = View.findDrawableById("fave"+i);
        	field.setText(lines[i]);
        	field.setFont(isBusNo ? Util.conf["fontBusStop"] : Util.conf["fontBus"]);
       	}
    }
    
	function onReceiveNearbyBusStops(responseCode, data) {
       if (responseCode == 200) {
       		_mainDelegate.showBusStopsMenu(data);
		    _mainDelegate.currentViewModel = _mainDelegate.favoritesViewModel;	
       }
       else {
           getViewModel().refreshData("HTTP error [" + responseCode + "]");
       }
	   WatchUi.requestUpdate();
	   
    }
    
    function onUpdate(dc) {
	
        var timeNow = View.findDrawableById("timenow");
        timeNow.setText(Util.getFormattedTimeNow());
        
       	View.onUpdate(dc);
    }
}