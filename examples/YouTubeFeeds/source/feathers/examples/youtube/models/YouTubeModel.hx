package feathers.examples.youtube.models;
import feathers.data.ListCollection;
class YouTubeModel
{
	public var selectedList:VideoFeed;
	public var selectedVideo:VideoDetails;
	public var cachedLists:Map<String, ListCollection> = new Map();
}
