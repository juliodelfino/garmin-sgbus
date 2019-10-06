using Toybox.WatchUi;
using Toybox.System;

class SgBusSaveMenuDelegate extends WatchUi.Menu2InputDelegate {

	hidden var _busStop;
    function initialize(busStop) {
    	_busStop = { "id" => busStop["id"], "name" => busStop["name"] };
        Menu2InputDelegate.initialize();
    }
    
    function onSelect(item) {
    	var bookmarks = Util.getValue("bookmarks");
    	if (bookmarks == null) {
    		bookmarks = {};
    	}
    	if (bookmarks[_busStop["id"]] == null) {
    		bookmarks[_busStop["id"]] = _busStop;
    	}
    	if (_busStop["savedBuses"] == null) {
    		_busStop["savedBuses"] = [];
		}
		var savedBuses = bookmarks[_busStop["id"]]["savedBuses"];
		if (savedBuses.indexOf(item.getId()) < 0) { 
    		savedBuses.add(item.getId());
		}
    	Util.setValue("bookmarks", bookmarks);
    }
}