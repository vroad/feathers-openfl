package feathers.examples.trainTimes.model;
class TimeData
{
	public function new(trainNumber:Int, departureTime:Date, arrivalTime:Date)
	{
		this.trainNumber = trainNumber;
		this.departureTime = departureTime;
		this.arrivalTime = arrivalTime;
	}

	public var trainNumber:Int;
	public var departureTime:Date;
	public var arrivalTime:Date;
}
