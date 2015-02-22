package feathers.examples.youtube.models;
class VideoDetails
{
	public function new(title:String = null, author:String = null, url:String = null, description:String = null)
	{
		this.title = title;
		this.author = author;
		this.url = url;
		this.description = description;
	}

	public var title:String;
	public var author:String;
	public var url:String;
	public var description:String;
}
