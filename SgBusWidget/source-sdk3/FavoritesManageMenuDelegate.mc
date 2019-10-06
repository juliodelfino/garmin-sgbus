using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class FavoritesManageMenuDelegate extends WatchUi.Menu2InputDelegate {

	hidden var _itemsToRemove;
    function initialize() {
        Menu2InputDelegate.initialize();
        _itemsToRemove = {};
	}
	
	function onSelect(item) {

		_itemsToRemove[item.getId()] = item.isChecked();
	}
	
	function onDone() {
	
    	var bookmarks = Util.getValue("bookmarks");
		var keys = _itemsToRemove.keys();
		for (var i = 0; i < keys.size(); i++) {
		
			var stopId = keys[i].substring(0, 5);
			var busNo = keys[i].substring(6, keys[i].length());
			var retain = _itemsToRemove[keys[i]];
			if (!retain) {
				bookmarks[stopId]["savedBuses"].remove(busNo);
				if (bookmarks[stopId]["savedBuses"].size() == 0) {
					bookmarks.remove(stopId);
				}
			}
		}
		Util.setValue("bookmarks", bookmarks);
		Menu2InputDelegate.onDone();
	}
}