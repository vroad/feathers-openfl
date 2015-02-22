package feathers.examples.youtube.models;
class VideoFeed
{
	public function new(name:String = null, url:String = null)
	{
		this.name = name;
		this.url = url;
	}

	public var name:String;
	public var url:String;
}
