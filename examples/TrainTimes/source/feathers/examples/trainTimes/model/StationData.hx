package feathers.examples.trainTimes.model;
class StationData
{
	public function StationData(name:String)
	{
		this.name = name;
	}

	public var name:String;
	public var isDepartingFromHere:Boolean = false;
}
