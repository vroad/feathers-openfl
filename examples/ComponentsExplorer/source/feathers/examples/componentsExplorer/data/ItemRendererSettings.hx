package feathers.examples.componentsExplorer.data;
import feathers.controls.Button;
import feathers.controls.renderers.BaseDefaultItemRenderer;

class ItemRendererSettings
{
	inline public static var ICON_ACCESSORY_TYPE_DISPLAY_OBJECT:String = "Display Object";
	inline public static var ICON_ACCESSORY_TYPE_TEXTURE:String = "Texture";
	inline public static var ICON_ACCESSORY_TYPE_LABEL:String = "Label";

	public function ItemRendererSettings()
	{
	}

	public var hasIcon:Bool = true;
	public var hasAccessory:Bool = true;
	public var layoutOrder:String = BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ICON_ACCESSORY;
	public var iconType:String = ICON_ACCESSORY_TYPE_TEXTURE;
	public var iconPosition:String = Button.ICON_POSITION_LEFT;
	public var useInfiniteGap:Bool = false;
	public var accessoryPosition:String = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
	public var accessoryType:String = ICON_ACCESSORY_TYPE_DISPLAY_OBJECT;
	public var useInfiniteAccessoryGap:Bool = true;
	public var horizontalAlign:String = Button.HORIZONTAL_ALIGN_LEFT;
	public var verticalAlign:String = Button.VERTICAL_ALIGN_MIDDLE;
}
