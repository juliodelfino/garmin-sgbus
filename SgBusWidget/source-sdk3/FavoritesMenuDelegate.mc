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
		else if (id.equals(:search)) {
			var picker = new StringPicker(Rez.Strings.stringPickerTitle, 
				StringPicker.ALPHANUM, method(:onInputSearchAccepted));
			WatchUi.popView(WatchUi.SLIDE_LEFT);
            WatchUi.pushView(picker, new StringPickerDelegate(picker), WatchUi.SLIDE_LEFT);
		}
		else if (id.equals(:radius)) {
			
			var picker = new StringPicker("Current: " + Util.getRadius() + "m", 
				StringPicker.NUM, method(:onSearchRadiusAccepted));
			WatchUi.popView(WatchUi.SLIDE_LEFT);
            WatchUi.pushView(picker, new StringPickerDelegate(picker), WatchUi.SLIDE_LEFT);
		}
	}
	
	function showManageFavoritesMenu() {
    	var bookmarks = Util.getValue("bookmarks");
    	if (bookmarks != null && bookmarks.size() > 0) {
    	
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
    		WatchUi.popView(WatchUi.SLIDE_LEFT);
        	WatchUi.pushView(menu, delegate, WatchUi.SLIDE_LEFT);
    	}
	}
	
	function onInputSearchAccepted(text) {
		_mainDelegate.searchBusStopsByKeyword(text);
	}
	
	function onSearchRadiusAccepted(text) {
		var radius = text.toNumber();
		if (radius >= 10 && radius <= 1000) {
			Util.setRadius(radius);
		} else {
			var dialog = new Confirmation("Radius should be between 10m and 1000m.");
			WatchUi.pushView(dialog, new ConfirmationDelegate(), WatchUi.SLIDE_IMMEDIATE);
		}
	}
}