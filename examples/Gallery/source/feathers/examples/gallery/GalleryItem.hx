package feathers.examples.gallery;
class GalleryItem
{
	public function new(title:String, url:String, thumbURL:String)
	{
		this.title = title;
		this.url = url;
		this.thumbURL = thumbURL;
	}

	public var title:String;
	public var url:String;
	public var thumbURL:String;
}
