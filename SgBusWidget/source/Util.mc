using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

class Util {

    static function getBusStringInfo(bus) {
        var next = bus["next"] != null ? computeArrivalMins(bus["next"]["duration_ms"]) : null;
        var next2 = bus["next2"] != null ? computeArrivalMins(bus["next2"]["duration_ms"]) : null;
    	return bus["no"] + " in " + next + (next2 != null ? ", " + next2 : "") + " min";
    }
    
    static function getMinifiedBusStringInfo(bus) {
        var next = bus["n1"] != null && bus["n1"] < 1 ? "Arr" : bus["n1"];
        var next2 = bus["n2"] != null && bus["n2"] < 1 ? "Arr" : bus["n2"];
        var phrase = (next == null && next2 == null) ? " -- NA -- " :
        	(" in " + next + (next2 != null ? ", " + next2 : "") + " min");
    	return bus["no"] + phrase;
    }
    
    static function computeArrivalMins(durationMs) {
    	if (durationMs == null || durationMs == "") {
    		return null;
    	}
    	var mins = durationMs/60000;
    	if (mins < 1) {
    		mins = "Arr";
		}
    	return mins;
    }

	static function getFormattedTimeNow() { 
	
		var clockTime = System.getClockTime(); 
		var hour, min, ampm, result; 
		
		hour = clockTime.hour; 
		min = clockTime.min.format("%02d"); 
		
		ampm = (hour > 11) ? "PM" : "AM"; 
		hour = hour % 12; 
		hour = (hour == 0) ? "12" : hour.format("%02d"); 
		
		return Lang.format("$1$:$2$ $3$", [hour, min, ampm]); 
	}
	
	public static var conf = WatchUi.loadResource(Rez.JsonData.jsonConf);
}