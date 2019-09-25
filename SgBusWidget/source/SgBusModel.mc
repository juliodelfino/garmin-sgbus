class SgBusModel {

	public var currBusStop = { "id" => null, "name" => null };
	public var nearBusStops;
	public var gpsPosition;
	
	function dispose() {
		currBusStop = null;
		nearBusStops = null;
		gpsPosition = null;
	}

}