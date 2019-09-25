using Toybox.Lang;
using Toybox.System;

class Util {

    static function getBusStringInfo(bus) {
        var next = computeArrivalMins(bus["next"]["duration_ms"]);
        var next2 = computeArrivalMins(bus["next2"]["duration_ms"]);
    	return bus["no"] + " in " + next + (next2 != null ? ", " + next2 : "") + " min";
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
}