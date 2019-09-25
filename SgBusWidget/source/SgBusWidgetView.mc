using Toybox.WatchUi;
using Toybox.Graphics;

class SgBusWidgetView extends WatchUi.View {

	hidden var _delegate;
	hidden var uiModel = ["","","Searching for GPS...","","","","", "", ""];
	hidden var _sgBusModel;

	hidden var _cnt = 0;
	
	hidden var _busStops;
	
	function initialize(delegate) {
		View.initialize();
		_delegate = delegate;
		_sgBusModel = delegate.getModel();
	}
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
	function onShow() {
	
		_delegate.onShow(self);
        _delegate.registerTimerEvent(method(:timerCallback));
        if (_sgBusModel.gpsPosition == null) {
        
			Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        } else if (_sgBusModel.nearBusStops == null) {
        	onPosition(_sgBusModel.gpsPosition);
        }
	}
	
	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
	function onHide() {
		_delegate.onHide(self);
        _delegate.resetTimerEvent();
		_sgBusModel.currBusStop = null;
		_sgBusModel.nearBusStops = null;
	}

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }
    
    function timerCallback() {
        if (_cnt >= 15 && _sgBusModel.currBusStop != null) {
    	    showBusStopDetails(_sgBusModel.currBusStop);
	    	_cnt = 0;
    	}
    	_cnt += 1;
	    WatchUi.requestUpdate();
    }
	
    // Update the view
    function onUpdate(dc) {
           
        var timeNow = View.findDrawableById("timenow");
        timeNow.setText(Util.getFormattedTimeNow());
    
    	for( var i = 0; i < uiModel.size(); i++ ) {
	    	var view = View.findDrawableById("line" + i);
		    view.setText(uiModel[i]);
		}
    	View.onUpdate(dc);
    }  
        
    function onPosition(info) {
      
		Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
		
		_sgBusModel.gpsPosition = info;
    	var loc = _sgBusModel.gpsPosition.position.toDegrees();
    	
	    uiModel[2] = "Getting bus stops...";
    	WebRequestHandler.makeRequestForBusStops(loc, method(:onReceiveBusStops));

	    WatchUi.requestUpdate();
	}
  
    function onReceiveBusStops(responseCode, data) {
       if (responseCode == 200) {
       		_sgBusModel.nearBusStops = data;
       		showBusStopDetails(data[0]);
       }
       else {
           uiModel[2] = "HTTP error [" + responseCode + "]";
       }
	   WatchUi.requestUpdate();
	   
    }
    
    function showBusStopDetails(busStop) {
    	_sgBusModel.currBusStop = busStop;
    	var bsId = busStop["id"];
    	var bsName = busStop["name"];
	    WebRequestHandler.makeRequestForBuses(bsId, method(:onReceiveBuses));
	    uiModel = ["","","","","","","", "", ""];
	    uiModel[0] = bsId + "";
	    uiModel[1] = bsName;
	    uiModel[2] = "Getting buses for " + bsId + "..."; 
    }
  
    function onReceiveBuses(responseCode, data) {
       if (responseCode == 200) {
           var buses = data["services"];
           _sgBusModel.currBusStop["buses"] = buses;
       	   for (var i = 0; i < buses.size() && i < uiModel.size() - 2; i++) {
       	      var bus = buses[i];
       	   	  uiModel[i+2] = Util.getBusStringInfo(bus);
       	   }
       }
       else {
           uiModel[2] = "HTTP error [" + responseCode + "]";
       }
	   WatchUi.requestUpdate();
    }
    
}
