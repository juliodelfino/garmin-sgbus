using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

class SdkFix {

	public static var conf = WatchUi.loadResource(Rez.JsonData.jsonConf);
	
    static function createBusesMenu(busStop) {
    	var menu = new WatchUi.CheckboxMenu({:title=>"Buses in " + busStop["id"]});
    	var buses = busStop["buses"];
    	for (var i = 0; i < buses.size(); i++) {
    	    var busNo = buses[i]["no"].toString();
	        menu.addItem(
	            new WatchUi.CheckboxMenuItem(
	                "Bus " + busNo, "Favorite this bus",
	                busNo,
	                false,
	                {}
	            )
	        );
        }
        return menu;
    }
    
    static function createBusStopsMenu(stops) {
    	var menu = new WatchUi.Menu2({:title=>"Bus Stops"});
    	for (var i = 0; i < stops.size(); i++) {
	        menu.addItem(
	            new WatchUi.MenuItem(
	                stops[i]["id"].toString(),
	                stops[i]["name"].toString(),
	                stops[i]["id"].toString(),
	                {}
	            )
	        );
        }
        return menu;
    }
    
}