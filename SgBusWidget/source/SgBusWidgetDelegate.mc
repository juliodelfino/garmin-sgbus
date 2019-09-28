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
    	var menu = new WatchUi.Menu2({:title=>"Bus Stops"});
    	if (_busStopsMenuDelegate == null) {
    		_busStopsMenuDelegate = new BusStopsMenuDelegate(self);
		}
    	for (var i = 0; i < stops.size(); i++) {
	        menu.addItem(
	            new MenuItem(
	                stops[i]["id"].toString(),
	                stops[i]["name"].toString(),
	                stops[i]["id"].toString(),
	                {}
	            )
	        );
        }
        WatchUi.pushView(menu, _busStopsMenuDelegate, WatchUi.SLIDE_LEFT);
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