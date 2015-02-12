package feathers.examples.componentsExplorer.data;
import starling.textures.Texture;

class EmbeddedAssets
{
	[Embed(source="/../assets/images/skull.png")]
	inline private static var SKULL_ICON_DARK_EMBEDDED:Class<Dynamic>;

	[Embed(source="/../assets/images/skull-white.png")]
	inline private static var SKULL_ICON_LIGHT_EMBEDDED:Class<Dynamic>;

	public static var SKULL_ICON_DARK:Texture;

	public static var SKULL_ICON_LIGHT:Texture;
	
	public static function initialize():Void
	{
		//we can't create these textures until Starling is ready
		SKULL_ICON_DARK = Texture.fromBitmap(new SKULL_ICON_DARK_EMBEDDED());
		SKULL_ICON_LIGHT = Texture.fromBitmap(new SKULL_ICON_LIGHT_EMBEDDED());
	}
}
