package feathers.examples.componentsExplorer.data;
class GroupedListSettings
{
	inline public static var STYLE_NORMAL:String = "normal";
	inline public static var STYLE_INSET:String = "inset";

	public function GroupedListSettings()
	{
	}

	public var isSelectable:Bool = true;
	public var hasElasticEdges:Bool = true;
	public var style:String = STYLE_NORMAL;
}
