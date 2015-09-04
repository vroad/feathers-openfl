package feathers.examples.displayObjects.themes;
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.examples.displayObjects.screens.Scale3ImageScreen;
import feathers.examples.displayObjects.screens.Scale9ImageScreen;
import feathers.examples.displayObjects.screens.TiledImageScreen;
import feathers.themes.MetalWorksMobileTheme;
import openfl.Assets;

import starling.display.Image;
import starling.textures.Texture;

class DisplayObjectExplorerTheme extends MetalWorksMobileTheme
{
	//[Embed(source="/../assets/images/horizontal-grip.png")]
	//inline private static var HORIZONTAL_GRIP:Class<Dynamic>;
	inline private static var HORIZONTAL_GRIP_FILE_NAME = "assets/images/horizontal-grip.png";

	//[Embed(source="/../assets/images/vertical-grip.png")]
	//inline private static var VERTICAL_GRIP:Class<Dynamic>;
	inline private static var VERTICAL_GRIP_FILE_NAME = "assets/images/vertical-grip.png";

	inline public static var THEME_NAME_RIGHT_GRIP:String = "right-grip";
	inline public static var THEME_NAME_BOTTOM_GRIP:String = "bottom-grip";

	public function new()
	{
		super(false);
	}

	private var _rightGripTexture:Texture;
	private var _bottomGripTexture:Texture;

	override private function initializeTextures():Void
	{
		super.initializeTextures();
		this._rightGripTexture = Texture.fromBitmapData(Assets.getBitmapData(VERTICAL_GRIP_FILE_NAME), false);
		this._bottomGripTexture = Texture.fromBitmapData(Assets.getBitmapData(HORIZONTAL_GRIP_FILE_NAME), false);
	}

	override private function initializeStyleProviders():Void
	{
		super.initializeStyleProviders();
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_RIGHT_GRIP, setRightGripStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_BOTTOM_GRIP, setBottomGripStyles);
		this.getStyleProviderForClass(Scale9ImageScreen).defaultStyleFunction = setScale9ImageScreenStyles;
		this.getStyleProviderForClass(Scale3ImageScreen).defaultStyleFunction = setScale3ImageScreenStyles;
		this.getStyleProviderForClass(TiledImageScreen).defaultStyleFunction = setTiledImageScreenStyles;
	}

	private function setRightGripStyles(button:Button):Void
	{
		var rightSkin:Image = new Image(this._rightGripTexture);
		rightSkin.scaleX = rightSkin.scaleY = this.scale;
		button.defaultSkin = rightSkin;
	}

	private function setBottomGripStyles(button:Button):Void
	{
		var bottomSkin:Image = new Image(this._bottomGripTexture);
		bottomSkin.scaleX = bottomSkin.scaleY = this.scale;
		button.defaultSkin = bottomSkin;
	}

	private function setScale9ImageScreenStyles(screen:Scale9ImageScreen):Void
	{
		//don't forget to set styles from the super class, if required
		this.setPanelScreenStyles(screen);
		
		screen.horizontalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
		screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
		screen.padding = 30 * this.scale;
	}

	private function setScale3ImageScreenStyles(screen:Scale3ImageScreen):Void
	{
		//don't forget to set styles from the super class, if required
		this.setPanelScreenStyles(screen);
		
		screen.horizontalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
		screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
		screen.padding = 30 * this.scale;
	}

	private function setTiledImageScreenStyles(screen:TiledImageScreen):Void
	{
		//don't forget to set styles from the super class, if required
		this.setPanelScreenStyles(screen);
		
		screen.horizontalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
		screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
		screen.padding = 30 * this.scale;
	}
}
