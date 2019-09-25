using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time;

class FavoritesView extends WatchUi.View {

	hidden var _mainDelegate;
	hidden var _lines;
	hidden var _cnt = 0;
	
	function initialize(mainDelegate) {
		_mainDelegate = mainDelegate;
		View.initialize();	
	}
    
    function timerCallback() {
        if (_cnt >= 15) {
        	var app = Application.getApp();
	    	var bookmarks = app.getProperty("bookmarks");
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
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
	function onShow() {
		_mainDelegate.registerTimerEvent(method(:timerCallback));	
    	refreshData();
	}
	
	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
	function onHide() {
		_mainDelegate.resetTimerEvent();
	}

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.FavoritesLayout(dc));
    }
    
    function onReceiveMixedBuses(responseCode, data) {
       if (responseCode == 200) {
           //TODO: fix this part
       }
       else {
           View.findDrawableById("fave1").setText("HTTP error [" + responseCode + "]");
       }
	   WatchUi.requestUpdate();
    }
    
    function refreshData() {
		_lines = [];	
		
    	var app = Application.getApp();
    	var bookmarks = app.getProperty("bookmarks");
    	if (bookmarks != null) {
    		var busStops = bookmarks.values();
    		for (var i = 0; i < busStops.size(); i++) {
    		
    			var bs = busStops[i];
    			_lines.add(bs["id"] + " " + bs["name"]);
    			for (var j = 0; j < bs["savedBuses"].size(); j++) {
	    			_lines.add("• " + bs["savedBuses"][j]);
    			}
    		}
    	}
    	if (_lines.size() == 0) {
    		_lines.add("No saved buses yet");
    	}
    	for (var i = _lines.size(); i < 5; i++) {
    		_lines.add("");
    	} 	
        
        for (var i = 0; i < _lines.size() && i < 5; i++) {   	    
        	View.findDrawableById("fave"+i).setText(_lines[i]);
       	}
    }
    
    function onUpdate(dc) {
	
        var timeNow = View.findDrawableById("timenow");
        timeNow.setText(Util.getFormattedTimeNow());
        
       	View.onUpdate(dc);
    }
}