package feathers.examples.componentsExplorer.data;
import openfl.Assets;
import starling.textures.Texture;

class EmbeddedAssets
{
	//[Embed(source="/../assets/images/skull.png")]
	//inline private static var SKULL_ICON_DARK_EMBEDDED:Class<Dynamic>;
	inline private static var SKULL_ICON_DARK_EMBEDDED_FILE_NAME:String = "assets/images/skull.png";

	//[Embed(source="/../assets/images/skull-white.png")]
	//inline private static var SKULL_ICON_LIGHT_EMBEDDED:Class<Dynamic>;
	inline private static var SKULL_ICON_LIGHT_EMBEDDED_FILE_NAME:String = "assets/images/skull-white.png";

	public static var SKULL_ICON_DARK:Texture;

	public static var SKULL_ICON_LIGHT:Texture;
	
	public static function initialize():Void
	{
		//we can't create these textures until Starling is ready
		SKULL_ICON_DARK = Texture.fromBitmapData(Assets.getBitmapData(SKULL_ICON_DARK_EMBEDDED_FILE_NAME), false);
		SKULL_ICON_LIGHT = Texture.fromBitmapData(Assets.getBitmapData(SKULL_ICON_LIGHT_EMBEDDED_FILE_NAME), false);
	}
}
