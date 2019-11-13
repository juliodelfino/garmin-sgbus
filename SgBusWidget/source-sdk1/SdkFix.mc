using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

class SdkFix {

	public static var conf = {"favoritesLineCount" => 6, "fontBusStop" => 1, "fontBus"=> 2, "busStopLineCount" => 5};
	
    static function createBusesMenu(busStop) {
		var menu = new WatchUi.Menu();
    	menu.setTitle("Buses in " + busStop["id"]);
    	var buses = busStop["buses"];
    	for (var i = 0; i < buses.size(); i++) {
    	    var busNo = buses[i]["no"].toString();
	        menu.addItem("Bus " + busNo + ": Save this", busNo);
        }
        return menu;
    }
    
    static function createBusStopsMenu(stops) {
    	var menu = new WatchUi.Menu();
    	menu.setTitle("Bus Stops");
    	for (var i = 0; i < stops.size(); i++) {
    		var busId = stops[i]["id"];
    		var busName = stops[i]["name"];
	        menu.addItem(busId + " | " + busName, busId);
        }
        return menu;
    }

}