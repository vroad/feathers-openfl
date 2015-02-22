package feathers.examples.layoutExplorer.data;
import feathers.layout.TiledRowsLayout;

class TiledRowsLayoutSettings
{
	public function new()
	{
	}

	public var paging:String = TiledRowsLayout.PAGING_NONE;
	public var itemCount:Int = 75;
	public var horizontalAlign:String = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
	public var verticalAlign:String = TiledRowsLayout.VERTICAL_ALIGN_TOP;
	public var tileHorizontalAlign:String = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
	public var tileVerticalAlign:String = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
	public var horizontalGap:Float = 2;
	public var verticalGap:Float = 2;
	public var paddingTop:Float = 0;
	public var paddingRight:Float = 0;
	public var paddingBottom:Float = 0;
	public var paddingLeft:Float = 0;
}
