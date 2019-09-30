using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class FavoritesMenuDelegate extends WatchUi.Menu2InputDelegate {

	hidden var _mainDelegate;
	
    function initialize(mainDelegate) {	
		_mainDelegate = mainDelegate;
        Menu2InputDelegate.initialize();
	}
	
	function onSelect(item) {	
	
		var id = item.getId();
		if (id.equals(:manage)) {
			showManageFavoritesMenu();
		}
		else if (id.equals(:favorites)) {
			_mainDelegate.setFavoritesViewModelAsCurrent();
			WatchUi.popView(WatchUi.SLIDE_LEFT);
		}
		else if (id.equals(:nearby)) {
			_mainDelegate.setNearbyViewModelAsCurrent();
			WatchUi.popView(WatchUi.SLIDE_LEFT);
		}
	}
	
	function showManageFavoritesMenu() {
    	var app = Application.getApp();
    	var bookmarks = app.getProperty("bookmarks");
    	if (bookmarks != null) {
    	
	    	var menu = new WatchUi.CheckboxMenu({:title=>"Manage Favorites"});
	    	var delegate = new FavoritesManageMenuDelegate();
	    	
    		var busStops = bookmarks.values();
    		for (var i = 0; i < busStops.size(); i++) {
    		
    			var bs = busStops[i];
    			for (var j = 0; j < bs["savedBuses"].size(); j++) {

			        menu.addItem(
			            new CheckboxMenuItem(
			                "Bus " + bs["savedBuses"][j], 
			                bs["id"] + " " + bs["name"],
			                bs["id"] + "-" + bs["savedBuses"][j],
			                true,
			                {}
			            )
			        );
    			}
    		}
    		WatchUi.popView(WatchUi.SLIDE_LEFT); //pop the main menu
        	WatchUi.pushView(menu, delegate, WatchUi.SLIDE_LEFT);
    	}
	}
}