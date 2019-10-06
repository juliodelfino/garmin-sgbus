using Toybox.WatchUi;

class SgBusWidgetDelegate extends WatchUi.BehaviorDelegate {

	hidden var _timer;
	hidden var _model;
	hidden var _defaultMenu;
	hidden var _defaultMenuDelegate;
	hidden var _busStopsMenuDelegate;
	public var favoritesViewModel;
	public var nearbyViewModel;
	public var currentViewModel;
	
    function initialize(model) {
        BehaviorDelegate.initialize();
		_model = model;
		_timer = new Timer.Timer();

		_defaultMenu = new Rez.Menus.MainMenu();	
    	_defaultMenuDelegate = new FavoritesMenuDelegate(self);
    }
    
    function onShow(view) {
    }
    
    function onHide(view) {
    }
    
	function getModel() {
		return _model;
	}
	
	function setNearbyViewModelAsCurrent() {
		currentViewModel = nearbyViewModel;
	}
	
	function setFavoritesViewModelAsCurrent() {
		currentViewModel = favoritesViewModel;
	}

    function onSelect() {
    
    	var stops = _model.nearBusStops;
    	if (stops == null) {
    		showDefaultMenu();
    	} else {
    		showBusStopsMenu(stops);
    	}
        return true;
    }
    
    function showDefaultMenu() {
	
        WatchUi.pushView(_defaultMenu, _defaultMenuDelegate, WatchUi.SLIDE_LEFT);
    }
    
    function showBusStopsMenu(stops) {
    	var menu = SdkFix.createBusStopsMenu(stops);
    	if (_busStopsMenuDelegate == null) {
    		_busStopsMenuDelegate = new BusStopsMenuDelegate(self);
		}
        _busStopsMenuDelegate.setBusMap(Util.convertToBusMap(stops));
        WatchUi.pushView(menu, _busStopsMenuDelegate, WatchUi.SLIDE_LEFT);
    }
    
    function searchBusStopsByKeyword(text) {
    	setNearbyViewModelAsCurrent();
    	nearbyViewModel.searchBusStopsByKeyword(text);
    }
    
    function registerTimerEvent(callback) {
    	_timer.start(callback, 1000, true);
    }
    
    function resetTimerEvent() {
    	_timer.stop();
    }
    
    function dispose() {
    	_timer.stop();
    	_model.dispose();
    }
}