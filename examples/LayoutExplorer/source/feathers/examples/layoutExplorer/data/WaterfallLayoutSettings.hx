package feathers.examples.layoutExplorer.data;
import feathers.layout.WaterfallLayout;

class WaterfallLayoutSettings
{
	public function new()
	{
	}

	public var itemCount:Int = 75;
	public var requestedColumnCount:Int = 0;
	public var horizontalAlign:String = WaterfallLayout.HORIZONTAL_ALIGN_CENTER;
	public var horizontalGap:Float = 2;
	public var verticalGap:Float = 2;
	public var paddingTop:Float = 0;
	public var paddingRight:Float = 0;
	public var paddingBottom:Float = 0;
	public var paddingLeft:Float = 0;
}
