using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class FavoritesMenuDelegate extends WatchUi.MenuInputDelegate {

	hidden var _mainDelegate;
	
    function initialize(mainDelegate) {	
		_mainDelegate = mainDelegate;
        MenuInputDelegate.initialize();
	}
	
	function onMenuItem(item) {	
	
		if (item == :manage) {
			showManageFavoritesMenu();
		}
		else if (item == :favorites) {
			_mainDelegate.setFavoritesViewModelAsCurrent();
		}
		else if (item == :nearby) {
			_mainDelegate.setNearbyViewModelAsCurrent();
		}
		else if (item == :search) {

			if (supportsPicker()) {
				var picker = new StringPicker(Rez.Strings.stringPickerTitle, 
					StringPicker.ALPHANUM, method(:onInputSearchAccepted));
				WatchUi.popView(WatchUi.SLIDE_LEFT);
	            WatchUi.pushView(picker, new StringPickerDelegate(picker), WatchUi.SLIDE_LEFT);
            }
		}
		else if (item == :radius) {
		
			if (supportsPicker()) {
				var picker = new StringPicker("Current: " + Util.getRadius() + "m", 
					StringPicker.NUM, method(:onSearchRadiusAccepted));
				WatchUi.popView(WatchUi.SLIDE_LEFT);
	            WatchUi.pushView(picker, new StringPickerDelegate(picker), WatchUi.SLIDE_LEFT);
            }
		}
	}
	
	//Device approachs60 doesn't support Picker
	function supportsPicker() {
	
		var isPickerSupported = (Toybox.WatchUi has :Picker);
 		if (!isPickerSupported) {
			var dialog = new Confirmation("Function not yet supported on your device.");	
			WatchUi.popView(WatchUi.SLIDE_LEFT);
			WatchUi.pushView(dialog, new ConfirmationDelegate(), WatchUi.SLIDE_IMMEDIATE);
        
        }
        return isPickerSupported;
	}
	
	function showManageFavoritesMenu() {
    	var bookmarks = Util.getValue("bookmarks");
    	if (bookmarks != null && bookmarks.size() > 0) {
    	
	    	var menu = new WatchUi.Menu();
	    	menu.setTitle("Remove Favorites");
	    	var delegate = new FavoritesManageMenuDelegate();
	    	
    		var busStops = bookmarks.values();
    		for (var i = 0; i < busStops.size(); i++) {
    		
    			var bs = busStops[i];
    			for (var j = 0; j < bs["savedBuses"].size(); j++) {

			        menu.addItem("Bus " + bs["savedBuses"][j] + " at Stop " + bs["id"],
			                bs["id"] + "-" + bs["savedBuses"][j]);
    			}
    		}
    		WatchUi.popView(WatchUi.SLIDE_LEFT); //pop the main menu
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