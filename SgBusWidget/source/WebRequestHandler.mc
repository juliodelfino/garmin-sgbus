using Toybox.Communications;

class WebRequestHandler {

	static function makeRequestForBusStops(loc, onReceiveBusStops) {
       var url = "https://sagabus.herokuapp.com/busstop";                         // set the url

       var params = {                                              // set the parameters
              "lat" => loc[0], 
              "long" => loc[1],
         	  "radius" => 3.5,
              "minify" => true
              
       };
       makeBusApiRequest(url, params, onReceiveBusStops);
    }
     
    static function makeRequestForBuses(stopId, onReceiveBuses) {
  	   var url = "https://sagabus.herokuapp.com/bus";                      
       var params = {                                              
              "id" => stopId,
              "minify" => true
       };
       makeBusApiRequest(url, params, onReceiveBuses);
    }
    
         
    static function makeRequestForMixedBuses(ids, onReceiveMixedBuses) {
  	   var url = "https://sagabus.herokuapp.com/busmixed";                      
       var params = {                                              
              "ids" => ids,
              "minify" => true
       };
       makeBusApiRequest(url, params, onReceiveMixedBuses);
    }
    
    static function makeBusApiRequest(url, params, onReceive) {

       var options = {                                             // set the options
           :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
           :headers => {                                           // set headers
                   "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
                                                                   // set response type
           :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };

       Communications.makeWebRequest(url, params, options, onReceive);
    }
    
}