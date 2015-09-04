package feathers.examples.layoutExplorer.data;
import feathers.layout.TiledColumnsLayout;

class TiledColumnsLayoutSettings
{
	public function new()
	{
	}

	public var itemCount:Int = 75;
	public var requestedRowCount:Int = 0;
	public var paging:String = TiledColumnsLayout.PAGING_NONE;
	public var horizontalAlign:String = TiledColumnsLayout.HORIZONTAL_ALIGN_LEFT;
	public var verticalAlign:String = TiledColumnsLayout.VERTICAL_ALIGN_TOP;
	public var tileHorizontalAlign:String = TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
	public var tileVerticalAlign:String = TiledColumnsLayout.TILE_VERTICAL_ALIGN_TOP;
	public var horizontalGap:Float = 2;
	public var verticalGap:Float = 2;
	public var paddingTop:Float = 0;
	public var paddingRight:Float = 0;
	public var paddingBottom:Float = 0;
	public var paddingLeft:Float = 0;
}
