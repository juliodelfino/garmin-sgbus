using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class SgBusStopDelegate extends WatchUi.BehaviorDelegate {

	public var LINE_COUNT;
	hidden var _idx = 0;
	hidden var _viewCount = 1;
	hidden var _views;
	hidden var _cnt = 0;
	hidden var timerStarted = false;
	public var _busStop;
	public var _buses = ["","","",""];
	public var _mainDelegate;
	
    function initialize(mainDelegate) {
        BehaviorDelegate.initialize();
        _mainDelegate = mainDelegate;
        _views = [new SgBusStopView(self)];
		LINE_COUNT = Util.conf["busStopLineCount"];
	}
	
	function onShow() {
		if (!timerStarted) {
			_mainDelegate.registerTimerEvent(method(:timerCallback));	
			timerStarted = true;
		}
	}
	
	function onHide() {
		_mainDelegate.resetTimerEvent();	
		timerStarted = false;
	}
	
	function setBusStop(busStop) {
		_busStop = busStop;       
	    WebRequestHandler.makeRequestForBuses(busStop["id"], method(:onReceiveBuses));
	}
	
	function timerCallback() {
        if (_cnt >= 15) {
	    	WebRequestHandler.makeRequestForBuses(_busStop["id"], method(:onReceiveBuses));
	    	_cnt = 0;
    	}
    	_cnt += 1;
    	WatchUi.requestUpdate();
	}
	
	function onReceiveBuses(responseCode, data) {
       if (responseCode == 200) {
            var tmpBuses = data["services"];
            _busStop["buses"] = tmpBuses;
            _buses = [];
			var busCount = tmpBuses.size();
            for (var i = 0; i < busCount; i++) {
           		_buses.add(Util.getMinifiedBusStringInfo(tmpBuses[i]));
            }
			_viewCount = ((busCount - 1) / LINE_COUNT) + 1;
       }
       else {
           _buses = ["", "", "HTTP error [" + responseCode + "]"];
       }
	   WatchUi.requestUpdate();
    }
	
	function getCurrentView() {
		return _views[_idx];
	}
	
	function onNextPage() {
		_idx += 1;
		if (_idx >= _viewCount) {
			_idx = 0;
		}
    	_views[0].refreshBusList(_idx);
        return true;
	}
	
	function onPreviousPage() {
		_idx -= 1;
		if (_idx < 0) {
			_idx = _viewCount - 1;
		}
    	_views[0].refreshBusList(_idx);
        return true;
	}
	
	function onSelect() {
		
    	var menu = new WatchUi.CheckboxMenu({:title=>"Buses in " + _busStop["id"]});
    	var delegate = new SgBusSaveMenuDelegate(_busStop);
    	var buses = _busStop["buses"];
    	for (var i = 0; i < buses.size(); i++) {
    	    var busNo = buses[i]["no"].toString();
	        menu.addItem(
	            new CheckboxMenuItem(
	                "Bus " + busNo, "Favorite this bus",
	                busNo,
	                false,
	                {}
	            )
	        );
        }
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_UP);
	}
	
	function onBack() {
		_idx = 0;
		_viewCount = 1;
		_buses = ["","","",""];
	}
}