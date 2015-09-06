/*
Copyright 2012-2015 Bowler Hat LLC

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
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;

import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/**
 * The "Metal Works" theme for mobile Feathers apps.
 *
 * <p>This version of the theme embeds its assets. To load assets at
 * runtime, see <code>MetalWorksMobileThemeWithAssetManager</code> instead.</p>
 *
 * @see http://feathersui.com/help/theme-assets.html
 */
class MetalWorksMobileTheme extends BaseMetalWorksMobileTheme
{
	/**
	 * @private
	 */
	//[Embed(source="/../assets/images/metalworks_mobile.xml",mimeType="application/octet-stream")]
	//private static var ATLAS_XML:Class<Dynamic>;
	inline private static var ATLAS_XML_NAME = "assets/images/metalworks_mobile.xml";

	/**
	 * @private
	 */
	//[Embed(source="/../assets/images/metalworks_mobile.png")]
	//private static var ATLAS_BITMAP:Class<Dynamic>;
	inline private static var ATLAS_BITMAP_NAME = "assets/images/metalworks_mobile.png";

	/**
	 * Constructor.
	 */
	public function new(scaleToDPI:Bool = true)
	{
		super(scaleToDPI);
		this.initialize();
		this.dispatchEventWith(Event.COMPLETE);
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this.initializeTextureAtlas();
		super.initialize();
	}

	/**
	 * @private
	 */
	private function initializeTextureAtlas():Void
	{
		var atlasBitmapData:BitmapData = Assets.getBitmapData(ATLAS_BITMAP_NAME);
		var atlasTexture:Texture = Texture.fromBitmapData(atlasBitmapData, false);
		atlasTexture.root.onRestore = this.atlasTexture_onRestore;
		atlasBitmapData.dispose();
		this.atlas = new TextureAtlas(atlasTexture, Xml.parse(Assets.getText(ATLAS_XML_NAME)).firstElement());
	}

	/**
	 * @private
	 */
	private function atlasTexture_onRestore():Void
	{
		var atlasBitmapData:BitmapData = Assets.getBitmapData(ATLAS_BITMAP_NAME);
		this.atlas.texture.root.uploadBitmapData(atlasBitmapData);
		atlasBitmapData.dispose();
	}
}
