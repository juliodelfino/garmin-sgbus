using Toybox.WatchUi;
using Toybox.System;

class BusStopsMenuDelegate extends WatchUi.MenuInputDelegate {

    hidden var _mainDelegate;
    hidden var _busStopDelegate;
    hidden var _busMap;
    
    function initialize(mainDelegate) {
    	_mainDelegate = mainDelegate;
    	_busStopDelegate = new SgBusStopDelegate(mainDelegate);
        MenuInputDelegate.initialize();
    }
    
    function setBusMap(busMap) {
    	_busMap = busMap;
    }
    
    function onMenuItem(item) {
    	var busStop = { "id" => item, "name" => _busMap[item], "buses" => [] };
        WatchUi.pushView(_busStopDelegate.getCurrentView(), _busStopDelegate, WatchUi.SLIDE_LEFT);
    	_busStopDelegate.setBusStop(busStop);
    }


}