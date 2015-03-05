/*
 Copyright (c) 2014 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.themes;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/**
 * The "Metal Works" theme for desktop Feathers apps.
 *
 * <p>This version of the theme embeds its assets. To load assets at
 * runtime, see <code>MetalWorksDesktopThemeWithAssetManager</code> instead.</p>
 *
 * @see http://wiki.starling-framework.org/feathers/theme-assets
 */
class MetalWorksDesktopTheme extends BaseMetalWorksDesktopTheme
{
	/**
	 * @private
	 */
	//[Embed(source="/../assets/images/metalworks_desktop.xml",mimeType="application/octet-stream")]
	//private static const ATLAS_XML:Class<Dynamic>;
	inline private static var ATLAS_XML_FILE_NAME = "assets/images/metalworks_desktop.xml";

	/**
	 * @private
	 */
	//[Embed(source="/../assets/images/metalworks_desktop.png")]
	//private static const ATLAS_BITMAP:Class<Dynamic>;
	inline private static var ATLAS_BITMAP_FILE_NAME = "assets/images/metalworks_desktop.png";

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.initialize();
		this.dispatchEventWith(Event.COMPLETE);
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		var atlasBitmapData:BitmapData = Assets.getBitmapData(ATLAS_BITMAP_FILE_NAME);
		var atlasTexture:Texture = Texture.fromBitmapData(atlasBitmapData, false, false, 1);
		atlasTexture.root.onRestore = this.atlasTexture_onRestore;
		atlasBitmapData.dispose();
		this.atlas = new TextureAtlas(atlasTexture, Xml.parse(Assets.getText(ATLAS_XML_FILE_NAME)).firstElement());

		super.initialize();
	}

	/**
	 * @private
	 */
	private function atlasTexture_onRestore():Void
	{
		var atlasBitmapData:BitmapData = Assets.getBitmapData(ATLAS_BITMAP_FILE_NAME);
		this.atlas.texture.root.uploadBitmapData(atlasBitmapData);
		atlasBitmapData.dispose();
	}
}
