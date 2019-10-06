using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class FavoritesManageMenuDelegate extends WatchUi.MenuInputDelegate {

	hidden var _itemsToRemove;
    function initialize() {
        MenuInputDelegate.initialize();
        _itemsToRemove = {};
	}
	
	function onMenuItem(item) {

    	var bookmarks = Util.getValue("bookmarks");

		var stopId = item.substring(0, 5);
		var busNo = item.substring(6, item.length());

		bookmarks[stopId]["savedBuses"].remove(busNo);
		if (bookmarks[stopId]["savedBuses"].size() == 0) {
			bookmarks.remove(stopId);
		}
			
		Util.setValue("bookmarks", bookmarks);
	}
}