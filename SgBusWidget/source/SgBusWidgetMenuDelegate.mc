using Toybox.WatchUi;
using Toybox.System;

class SgBusWidgetMenuDelegate extends WatchUi.Menu2InputDelegate {

    hidden var _mainDelegate;
    hidden var _busStopDelegate;
    
    function initialize(mainDelegate) {
    	_mainDelegate = mainDelegate;
    	_busStopDelegate = new SgBusStopDelegate(mainDelegate);
        Menu2InputDelegate.initialize();
    }
    
    function onSelect(item) {
    	var busStop = { "id" => item.getId(), "name" => item.getSubLabel(), "buses" => [] };
    	_busStopDelegate.setBusStop(busStop);
        WatchUi.pushView(_busStopDelegate.getCurrentView(), _busStopDelegate, WatchUi.SLIDE_LEFT);
    }


}