using Toybox.WatchUi;
using Toybox.Graphics;

class FavoritesViewModel {

	hidden var LINE_COUNT;
	hidden var _view;
	hidden var _lines;
	hidden var _cnt = 0;
	hidden var _busTimes = {};
	hidden var visible = false;
	
	function initialize(view) {
		_view = view;
		LINE_COUNT = SdkFix.conf["favoritesLineCount"];
	}
    
    function timerCallback() {
        if (_cnt >= 15) {
	    	var bookmarks = Util.getValue("bookmarks");
	    	if (bookmarks != null) {
	    	    var ids = "";
		    	var busStops = bookmarks.values();
	    		for (var i = 0; i < busStops.size(); i++) {
	    		
	    			var bs = busStops[i];
	    			for (var j = 0; j < bs["savedBuses"].size(); j++) {
				        ids += bs["id"] + "_" + bs["savedBuses"][j] + ",";
	    			}
	    		}
    			WebRequestHandler.makeRequestForMixedBuses(ids, method(:onReceiveMixedBuses));
			}
	    	_cnt = 0;
    	}
    	_cnt += 1;
	    WatchUi.requestUpdate();
    }
    
    function invokeWebRequestNow() {
    	_cnt = 15;
    }
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
	function onShow() {
    	refreshData(_busTimes);
    	visible = true;
	}
	
	function onHide() {
		visible = false;
	}
    
    function onReceiveMixedBuses(responseCode, data) {
       if (visible) {
	       if (responseCode == 200) {
	           refreshData(data);
	       }
	       _view.onReceiveMixedBuses(responseCode, data);
       }
    }
    
    function refreshData(busTimesData) {
    	_busTimes = busTimesData;
		_lines = [];
    	var bookmarks = Util.getValue("bookmarks");
    	if (bookmarks != null) {
    		var busStops = bookmarks.values();
    		for (var i = 0; i < busStops.size(); i++) {
    		
    			var bs = busStops[i];
    			_lines.add(bs["id"] + " " + bs["name"]);
    			for (var j = 0; j < bs["savedBuses"].size(); j++) {
    			    var busNo = bs["savedBuses"][j];
    			    var busInfo = busTimesData[bs["id"] + "_" + busNo];
    			    if (busInfo != null) {
    			    	busInfo["no"] = busNo;
    			    	busInfo = Util.getMinifiedBusStringInfo(busInfo);
    			    } else {
    			    	busInfo = busNo + "";
    			    }
	    			_lines.add("• " + busInfo);
    			}
    		}
    	}
    	if (_lines.size() == 0) {
    		_lines.addAll(["No saved buses yet.", "Press START to search", "for nearby buses", "and save them."]);
    	}
    	for (var i = _lines.size(); i < LINE_COUNT; i++) {
    		_lines.add("");
    	} 
    	
    	_view.refreshViewData(_lines);
    }
}