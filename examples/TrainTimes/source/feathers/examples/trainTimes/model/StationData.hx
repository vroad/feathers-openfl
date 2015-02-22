package feathers.examples.trainTimes.model;
class StationData
{
	public function new(name:String)
	{
		this.name = name;
	}

	public var name:String;
	public var isDepartingFromHere:Bool = false;
}
