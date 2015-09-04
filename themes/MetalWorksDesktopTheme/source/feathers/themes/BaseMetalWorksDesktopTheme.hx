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
import feathers.controls.Alert;
import feathers.controls.Button;
import feathers.controls.ButtonGroup;
import feathers.controls.Callout;
import feathers.controls.Check;
import feathers.controls.Drawers;
import feathers.controls.GroupedList;
import feathers.controls.Header;
import feathers.controls.ImageLoader;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.NumericStepper;
import feathers.controls.PageIndicator;
import feathers.controls.Panel;
import feathers.controls.PanelScreen;
import feathers.controls.PickerList;
import feathers.controls.ProgressBar;
import feathers.controls.Radio;
import feathers.controls.ScrollBar;
import feathers.controls.ScrollContainer;
import feathers.controls.ScrollScreen;
import feathers.controls.ScrollText;
import feathers.controls.Scroller;
import feathers.controls.SimpleScrollBar;
import feathers.controls.Slider;
import feathers.controls.TabBar;
import feathers.controls.TextArea;
import feathers.controls.TextInput;
import feathers.controls.ToggleButton;
import feathers.controls.ToggleSwitch;
import feathers.controls.popups.DropDownPopUpContentManager;
import feathers.controls.renderers.BaseDefaultItemRenderer;
import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
import feathers.controls.renderers.DefaultGroupedListItemRenderer;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.text.BitmapFontTextEditor;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.controls.text.TextBlockTextEditor;
import feathers.controls.text.TextBlockTextRenderer;
import feathers.controls.text.TextFieldTextEditor;
import feathers.controls.text.TextFieldTextRenderer;
import feathers.core.FeathersControl;
import feathers.core.FocusManager;
import feathers.core.PopUpManager;
import feathers.display.Scale3Image;
import feathers.display.Scale9Image;
import feathers.display.TiledImage;
import feathers.layout.HorizontalLayout;
import feathers.skins.SmartDisplayObjectStateValueSelector;
import feathers.skins.StandardIcons;
import feathers.text.BitmapFontTextFormat;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;
import openfl.Assets;
import openfl.text.Font;

import openfl.geom.Rectangle;
import openfl.text.TextFormat;
#if flash
import openfl.text.engine.CFFHinting;
import openfl.text.engine.ElementFormat;
import openfl.text.engine.FontDescription;
import openfl.text.engine.FontLookup;
import openfl.text.engine.FontPosture;
import openfl.text.engine.FontWeight;
import openfl.text.engine.RenderingMode;
#end

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/**
 * The base class for the "Metal Works" theme for desktop Feathers apps.
 * Handles everything except asset loading, which is left to subclasses.
 *
 * @see MetalWorksDesktopTheme
 * @see MetalWorksDesktopThemeWithAssetManager
 */
class BaseMetalWorksDesktopTheme extends StyleNameFunctionTheme
{
	//[Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf",fontFamily="SourceSansPro",fontWeight="normal",mimeType="application/x-font",embedAsCFF="true")]
	//inline private static var SOURCE_SANS_PRO_REGULAR:Class<Dynamic>;
	inline private static var SOURCE_SANS_PRO_REGULAR_FILE_NAME = "assets/fonts/SourceSansPro-Regular.ttf";

	//[Embed(source="/../assets/fonts/SourceSansPro-Semibold.ttf",fontFamily="SourceSansPro",fontWeight="bold",mimeType="application/x-font",embedAsCFF="true")]
	//inline private static var SOURCE_SANS_PRO_SEMIBOLD:Class<Dynamic>;
	inline private static var SOURCE_SANS_PRO_SEMIBOLD_FILE_NAME = "assets/fonts/SourceSansPro-Semibold.ttf";

	/**
	 * The name of the embedded font used by controls in this theme. Comes
	 * in normal and bold weights.
	 */
	inline public static var FONT_NAME:String = "SourceSansPro";
	inline private static var ELEMENT_FORMAT_STR:String = #if flash "elementFormat" #else "textFormat" #end;
	inline private static var DISABLED_ELEMENT_FORMAT_STR:String = #if flash "disabledElementFormat" #else "disabledTextFormat" #end;

	inline private static var PRIMARY_BACKGROUND_COLOR:UInt = 0x4a4137;
	inline private static var LIGHT_TEXT_COLOR:UInt = 0xe5e5e5;
	inline private static var DARK_TEXT_COLOR:UInt = 0x1a1816;
	inline private static var SELECTED_TEXT_COLOR:UInt = 0xff9900;
	inline private static var DISABLED_TEXT_COLOR:UInt = 0x8a8a8a;
	inline private static var DARK_DISABLED_TEXT_COLOR:UInt = 0x383430;
	inline private static var LIST_BACKGROUND_COLOR:UInt = 0x36322e;
	inline private static var LIST_BACKGROUND_HOVER_COLOR:UInt = 0xff7700;
	inline private static var GROUPED_LIST_HEADER_BACKGROUND_COLOR:UInt = 0x292523;
	inline private static var GROUPED_LIST_FOOTER_BACKGROUND_COLOR:UInt = 0x292523;
	inline private static var SCROLL_BAR_TRACK_COLOR:UInt = 0x1a1816;
	inline private static var SCROLL_BAR_TRACK_DOWN_COLOR:UInt = 0xff7700;
	inline private static var TEXT_SELECTION_BACKGROUND_COLOR:UInt = 0x574f46;
	inline private static var MODAL_OVERLAY_COLOR:UInt = 0x29241e;
	inline private static var MODAL_OVERLAY_ALPHA:Float = 0.8;
	inline private static var DRAWER_OVERLAY_COLOR:UInt = 0x29241e;
	inline private static var DRAWER_OVERLAY_ALPHA:Float = 0.4;

	private static var DEFAULT_SCALE9_GRID:Rectangle = new Rectangle(3, 3, 1, 1);
	private static var SIMPLE_SCALE9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
	private static var BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3, 3, 1, 16);
	private static var BUTTON_SELECTED_SCALE9_GRID:Rectangle = new Rectangle(4, 4, 1, 14);
	private static var SCROLL_BAR_STEP_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3, 3, 1, 7);
	inline private static var BACK_BUTTON_SCALE3_REGION1:Float = 13;
	inline private static var BACK_BUTTON_SCALE3_REGION2:Float = 1;
	inline private static var FORWARD_BUTTON_SCALE3_REGION1:Float = 3;
	inline private static var FORWARD_BUTTON_SCALE3_REGION2:Float = 1;
	private static var FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
	private static var TAB_SCALE9_GRID:Rectangle = new Rectangle(7, 7, 1, 11);
	inline private static var SCROLL_BAR_THUMB_REGION1:Int = 5;
	inline private static var SCROLL_BAR_THUMB_REGION2:Int = 14;

	/**
	 * @private
	 * The theme's custom style name for the increment button of a horizontal ScrollBar.
	 */
	inline private static var THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "metalworks-desktop-horizontal-scroll-bar-increment-button";

	/**
	 * @private
	 * The theme's custom style name for the decrement button of a horizontal ScrollBar.
	 */
	inline private static var THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "metalworks-desktop-horizontal-scroll-bar-decrement-button";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a horizontal ScrollBar.
	 */
	inline private static var THEME_NAME_HORIZONTAL_SCROLL_BAR_THUMB:String = "metalworks-desktop-horizontal-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a horizontal ScrollBar.
	 */
	inline private static var THEME_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK:String = "metalworks-desktop-horizontal-scroll-bar-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a horizontal ScrollBar.
	 */
	inline private static var THEME_NAME_HORIZONTAL_SCROLL_BAR_MAXIMUM_TRACK:String = "metalworks-desktop-horizontal-scroll-bar-maximum-track";

	/**
	 * @private
	 * The theme's custom style name for the increment button of a vertical ScrollBar.
	 */
	inline private static var THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "metalworks-desktop-vertical-scroll-bar-increment-button";

	/**
	 * @private
	 * The theme's custom style name for the decrement button of a vertical ScrollBar.
	 */
	inline private static var THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "metalworks-desktop-vertical-scroll-bar-decrement-button";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a vertical ScrollBar.
	 */
	inline private static var THEME_NAME_VERTICAL_SCROLL_BAR_THUMB:String = "metalworks-desktop-vertical-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a vertical ScrollBar.
	 */
	inline private static var THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK:String = "metalworks-desktop-vertical-scroll-bar-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a vertical ScrollBar.
	 */
	inline private static var THEME_NAME_VERTICAL_SCROLL_BAR_MAXIMUM_TRACK:String = "metalworks-desktop-vertical-scroll-bar-maximum-track";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a horizontal SimpleScrollBar.
	 */
	inline private static var THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "metalworks-desktop-horizontal-simple-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a vertical SimpleScrollBar.
	 */
	inline private static var THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "metalworks-desktop-vertical-simple-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a horizontal slider.
	 */
	inline private static var THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "metalworks-desktop-horizontal-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a horizontal slider.
	 */
	inline private static var THEME_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK:String = "metalworks-desktop-horizontal-slider-maximum-track";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a vertical slider.
	 */
	inline private static var THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "metalworks-desktop-vertical-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a vertical slider.
	 */
	inline private static var THEME_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK:String = "metalworks-desktop-vertical-slider-maximum-track";

	/**
	 * The default global text renderer factory for this theme creates a
	 * TextBlockTextRenderer.
	 */
	private static function textRendererFactory():#if flash TextBlockTextRenderer #elseif html5 TextFieldTextRenderer #else BitmapFontTextRenderer #end
	{
		return new #if flash TextBlockTextRenderer #elseif html5 TextFieldTextRenderer #else BitmapFontTextRenderer #end ();
	}

	/**
	 * The default global text editor factory for this theme creates a
	 * TextBlockTextEditor.
	 */
	private static function textEditorFactory():#if flash TextBlockTextEditor #elseif html5 TextFieldTextEditor #else BitmapFontTextEditor #end
	{
		return new #if flash TextBlockTextEditor #elseif html5 TextFieldTextEditor #else BitmapFontTextEditor #end ();
	}

	/**
	 * This theme's scroll bar type is ScrollBar.
	 */
	private static function scrollBarFactory():ScrollBar
	{
		return new ScrollBar();
	}

	private static function popUpOverlayFactory():DisplayObject
	{
		var quad:Quad = new Quad(100, 100, MODAL_OVERLAY_COLOR);
		quad.alpha = MODAL_OVERLAY_ALPHA;
		return quad;
	}

	private static function pickerListButtonFactory():ToggleButton
	{
		return new ToggleButton();
	}

	/**
	 * SmartDisplayObjectValueSelectors will use ImageLoader instead of
	 * Image so that we can use extra features like pixel snapping.
	 */
	private static function textureValueTypeHandler(value:Texture, oldDisplayObject:DisplayObject = null):DisplayObject
	{
		var displayObject:ImageLoader = cast(oldDisplayObject, ImageLoader);
		if(displayObject == null)
		{
			displayObject = new ImageLoader();
		}
		displayObject.source = value;
		return displayObject;
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * Skins are scaled by a value based on the content scale factor.
	 */
	private var scale:Float = 1;

	/**
	 * A smaller font size for details.
	 */
	private var smallFontSize:Int;

	/**
	 * A normal font size.
	 */
	private var regularFontSize:Int;

	/**
	 * A larger font size for headers.
	 */
	private var largeFontSize:Int;

	/**
	 * The size, in pixels, of major regions in the grid. Used for sizing
	 * containers and larger UI controls.
	 */
	private var gridSize:Int;

	/**
	 * The size, in pixels, of minor regions in the grid. Used for larger
	 * padding and gaps.
	 */
	private var gutterSize:Int;

	/**
	 * The size, in pixels, of smaller padding and gaps within the major
	 * regions in the grid.
	 */
	private var smallGutterSize:Int;

	/**
	 * The size, in pixels, of very smaller padding and gaps.
	 */
	private var extraSmallGutterSize:Int;

	/**
	 * The minimum width, in pixels, of some types of buttons.
	 */
	private var buttonMinWidth:Int;

	/**
	 * The width, in pixels, of UI controls that span across multiple grid regions.
	 */
	private var wideControlSize:Int;

	/**
	 * The size, in pixels, of a typical UI control.
	 */
	private var controlSize:Int;

	/**
	 * The size, in pixels, of smaller UI controls.
	 */
	private var smallControlSize:Int;

	/**
	 * The size, in pixels, of a border around any control.
	 */
	private var borderSize:Int;

	/**
	 * The size, in pixels, of the focus indicator skin's padding.
	 */
	private var focusPaddingSize:Int;

	private var calloutArrowOverlapGap:Int;
	private var calloutBackgroundMinSize:Int;
	private var progressBarFillMinSize:Int;
	private var scrollBarGutterSize:Int;
	private var popUpSize:Int;

	#if flash
	/**
	 * The FTE FontDescription used for text of a normal weight.
	 */
	private var regularFontDescription:FontDescription;

	/**
	 * The FTE FontDescription used for text of a bold weight.
	 */
	private var boldFontDescription:FontDescription;
	#end

	/**
	 * ScrollText uses TextField instead of FTE, so it has a separate TextFormat.
	 */
	private var scrollTextTextFormat:TextFormat;

	/**
	 * ScrollText uses TextField instead of FTE, so it has a separate disabled TextFormat.
	 */
	private var scrollTextDisabledTextFormat:TextFormat;

	#if flash
	/**
	 * An ElementFormat with a dark tint used for UI controls.
	 */
	private var darkUIElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint used for UI controls.
	 */
	private var lightUIElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a highlighted tint used for selected UI controls.
	 */
	private var selectedUIElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint used for disabled UI controls.
	 */
	private var lightUIDisabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a dark tint used for disabled UI controls.
	 */
	private var darkUIDisabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a dark tint used for larger UI controls.
	 */
	private var largeDarkElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint used for larger UI controls.
	 */
	private var largeLightElementFormat:ElementFormat;

	/**
	 * An ElementFormat used for larger, disabled UI controls.
	 */
	private var largeDisabledElementFormat:ElementFormat;


	/**
	 * An ElementFormat with a dark tint used for text.
	 */
	private var darkElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint used for text.
	 */
	private var lightElementFormat:ElementFormat;

	/**
	 * An ElementFormat used for disabled text.
	 */
	private var disabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint used for smaller text.
	 */
	private var smallLightElementFormat:ElementFormat;

	/**
	 * An ElementFormat used for smaller, disabled text.
	 */
	private var smallDisabledElementFormat:ElementFormat;
	#elseif html5
	private var darkUIElementFormat:TextFormat;
	private var lightUIElementFormat:TextFormat;
	private var selectedUIElementFormat:TextFormat;
	private var lightUIDisabledElementFormat:TextFormat;
	private var darkUIDisabledElementFormat:TextFormat;
	private var largeDarkElementFormat:TextFormat;
	private var largeLightElementFormat:TextFormat;
	private var largeDisabledElementFormat:TextFormat;
	private var darkElementFormat:TextFormat;
	private var lightElementFormat:TextFormat;
	private var disabledElementFormat:TextFormat;
	private var smallLightElementFormat:TextFormat;
	private var smallDisabledElementFormat:TextFormat;
	#else
	private var darkUIElementFormat:BitmapFontTextFormat;
	private var lightUIElementFormat:BitmapFontTextFormat;
	private var selectedUIElementFormat:BitmapFontTextFormat;
	private var lightUIDisabledElementFormat:BitmapFontTextFormat;
	private var darkUIDisabledElementFormat:BitmapFontTextFormat;
	private var largeDarkElementFormat:BitmapFontTextFormat;
	private var largeLightElementFormat:BitmapFontTextFormat;
	private var largeDisabledElementFormat:BitmapFontTextFormat;
	private var darkElementFormat:BitmapFontTextFormat;
	private var lightElementFormat:BitmapFontTextFormat;
	private var disabledElementFormat:BitmapFontTextFormat;
	private var smallLightElementFormat:BitmapFontTextFormat;
	private var smallDisabledElementFormat:BitmapFontTextFormat;
	#end

	/**
	 * The texture atlas that contains skins for this theme. This base class
	 * does not initialize this member variable. Subclasses are expected to
	 * load the assets somehow and set the <code>atlas</code> member
	 * variable before calling <code>initialize()</code>.
	 */
	private var atlas:TextureAtlas;

	private var focusIndicatorSkinTextures:Scale9Textures;
	private var headerBackgroundSkinTexture:Texture;
	private var headerPopupBackgroundSkinTexture:Texture;
	private var backgroundSkinTextures:Scale9Textures;
	private var backgroundDisabledSkinTextures:Scale9Textures;
	private var backgroundFocusedSkinTextures:Scale9Textures;
	private var listBackgroundSkinTextures:Scale9Textures;
	private var buttonUpSkinTextures:Scale9Textures;
	private var buttonDownSkinTextures:Scale9Textures;
	private var buttonDisabledSkinTextures:Scale9Textures;
	private var buttonSelectedUpSkinTextures:Scale9Textures;
	private var buttonSelectedDisabledSkinTextures:Scale9Textures;
	private var buttonQuietHoverSkinTextures:Scale9Textures;
	private var buttonCallToActionUpSkinTextures:Scale9Textures;
	private var buttonCallToActionDownSkinTextures:Scale9Textures;
	private var buttonDangerUpSkinTextures:Scale9Textures;
	private var buttonDangerDownSkinTextures:Scale9Textures;
	private var buttonBackUpSkinTextures:Scale3Textures;
	private var buttonBackDownSkinTextures:Scale3Textures;
	private var buttonBackDisabledSkinTextures:Scale3Textures;
	private var buttonForwardUpSkinTextures:Scale3Textures;
	private var buttonForwardDownSkinTextures:Scale3Textures;
	private var buttonForwardDisabledSkinTextures:Scale3Textures;
	private var pickerListButtonIconTexture:Texture;
	private var pickerListButtonIconSelectedTexture:Texture;
	private var pickerListButtonIconDisabledTexture:Texture;
	private var tabUpSkinTextures:Scale9Textures;
	private var tabDownSkinTextures:Scale9Textures;
	private var tabDisabledSkinTextures:Scale9Textures;
	private var tabSelectedSkinTextures:Scale9Textures;
	private var tabSelectedDisabledSkinTextures:Scale9Textures;
	private var radioUpIconTexture:Texture;
	private var radioDownIconTexture:Texture;
	private var radioDisabledIconTexture:Texture;
	private var radioSelectedUpIconTexture:Texture;
	private var radioSelectedDownIconTexture:Texture;
	private var radioSelectedDisabledIconTexture:Texture;
	private var checkUpIconTexture:Texture;
	private var checkDownIconTexture:Texture;
	private var checkDisabledIconTexture:Texture;
	private var checkSelectedUpIconTexture:Texture;
	private var checkSelectedDownIconTexture:Texture;
	private var checkSelectedDisabledIconTexture:Texture;
	private var pageIndicatorNormalSkinTexture:Texture;
	private var pageIndicatorSelectedSkinTexture:Texture;
	private var itemRendererSelectedSkinTexture:Texture;
	private var backgroundPopUpSkinTextures:Scale9Textures;
	private var calloutTopArrowSkinTexture:Texture;
	private var calloutRightArrowSkinTexture:Texture;
	private var calloutBottomArrowSkinTexture:Texture;
	private var calloutLeftArrowSkinTexture:Texture;
	private var horizontalSimpleScrollBarThumbSkinTextures:Scale3Textures;
	private var horizontalScrollBarDecrementButtonIconTexture:Texture;
	private var horizontalScrollBarDecrementButtonDisabledIconTexture:Texture;
	private var horizontalScrollBarDecrementButtonUpSkinTextures:Scale9Textures;
	private var horizontalScrollBarDecrementButtonDownSkinTextures:Scale9Textures;
	private var horizontalScrollBarDecrementButtonDisabledSkinTextures:Scale9Textures;
	private var horizontalScrollBarIncrementButtonIconTexture:Texture;
	private var horizontalScrollBarIncrementButtonDisabledIconTexture:Texture;
	private var horizontalScrollBarIncrementButtonUpSkinTextures:Scale9Textures;
	private var horizontalScrollBarIncrementButtonDownSkinTextures:Scale9Textures;
	private var horizontalScrollBarIncrementButtonDisabledSkinTextures:Scale9Textures;
	private var verticalSimpleScrollBarThumbSkinTextures:Scale3Textures;
	private var verticalScrollBarDecrementButtonIconTexture:Texture;
	private var verticalScrollBarDecrementButtonDisabledIconTexture:Texture;
	private var verticalScrollBarDecrementButtonUpSkinTextures:Scale9Textures;
	private var verticalScrollBarDecrementButtonDownSkinTextures:Scale9Textures;
	private var verticalScrollBarDecrementButtonDisabledSkinTextures:Scale9Textures;
	private var verticalScrollBarIncrementButtonIconTexture:Texture;
	private var verticalScrollBarIncrementButtonDisabledIconTexture:Texture;
	private var verticalScrollBarIncrementButtonUpSkinTextures:Scale9Textures;
	private var verticalScrollBarIncrementButtonDownSkinTextures:Scale9Textures;
	private var verticalScrollBarIncrementButtonDisabledSkinTextures:Scale9Textures;
	private var searchIconTexture:Texture;
	private var searchIconDisabledTexture:Texture;

	/**
	 * Disposes the texture atlas before calling super.dispose()
	 */
	override public function dispose():Void
	{
		if(this.atlas != null)
		{
			this.atlas.dispose();
			this.atlas = null;
		}

		//don't forget to call super.dispose()!
		super.dispose();
	}

	/**
	 * Initializes the theme. Expected to be called by subclasses after the
	 * assets have been loaded and the skin texture atlas has been created.
	 */
	private function initialize():Void
	{
		this.initializeScale();
		this.initializeDimensions();
		this.initializeFonts();
		this.initializeTextures();
		this.initializeGlobals();
		this.initializeStage();
		this.initializeStyleProviders();
	}

	/**
	 * Sets the stage background color.
	 */
	private function initializeStage():Void
	{
		Starling.current.stage.color = PRIMARY_BACKGROUND_COLOR;
		Starling.current.nativeStage.color = PRIMARY_BACKGROUND_COLOR;
	}

	/**
	 * Initializes global variables (not including global style providers).
	 */
	private function initializeGlobals():Void
	{
		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		FeathersControl.defaultTextEditorFactory = textEditorFactory;

		PopUpManager.overlayFactory = popUpOverlayFactory;
		Callout.stagePadding = this.smallGutterSize;

		FocusManager.setEnabledForStage(Starling.current.stage, true);
	}

	/**
	 * Initializes the value used for scaling things like textures and font
	 * sizes.
	 */
	private function initializeScale():Void
	{
		//Starling automatically accounts for the contentScaleFactor on Mac
		//HiDPI screens, and converts pixels to points, so we don't need to
		//do any scaling for that.
		this.scale = 1;
	}

	/**
	 * Initializes common values used for setting the dimensions of components.
	 */
	private function initializeDimensions():Void
	{
		this.gridSize = Math.round(30 * this.scale);
		this.extraSmallGutterSize = Math.round(2 * this.scale);
		this.smallGutterSize = Math.round(4 * this.scale);
		this.gutterSize = Math.round(8 * this.scale);
		this.borderSize = Std.Int(Math.max(1, Math.round(1 * this.scale)));
		this.controlSize = Math.round(22 * this.scale);
		this.smallControlSize = Math.round(12 * this.scale);
		this.calloutBackgroundMinSize = Math.round(5 * this.scale);
		this.progressBarFillMinSize = Math.round(7 * this.scale);
		this.scrollBarGutterSize = Math.round(4 * this.scale);
		this.calloutArrowOverlapGap = Std.Int(Math.min(-1, Math.round(-1 * this.scale)));
		this.focusPaddingSize = Std.Int(Math.min(-1, Math.round(-2 * this.scale)));
		this.buttonMinWidth = this.gridSize * 2 + this.gutterSize;
		this.wideControlSize = this.gridSize * 4 + this.gutterSize * 3;
		this.popUpSize = this.gridSize * 10 + this.smallGutterSize * 9;
	}

	/**
	 * Initializes font sizes and formats.
	 */
	private function initializeFonts():Void
	{
		this.smallFontSize = Math.round(11 * this.scale);
		this.regularFontSize = Math.round(13 * this.scale);
		this.largeFontSize = Math.round(15 * this.scale);

		//these are for components that don't use FTE
		this.scrollTextTextFormat = new TextFormat("_sans", this.regularFontSize, LIGHT_TEXT_COLOR);
		this.scrollTextDisabledTextFormat = new TextFormat("_sans", this.regularFontSize, DISABLED_TEXT_COLOR);

		#if flash
		this.regularFontDescription = new FontDescription(FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
		this.boldFontDescription = new FontDescription(FONT_NAME, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);

		this.darkUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.selectedUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, SELECTED_TEXT_COLOR);
		this.lightUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);
		this.darkUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_DISABLED_TEXT_COLOR);

		this.darkElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.disabledElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);

		this.smallLightElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, LIGHT_TEXT_COLOR);
		this.smallDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, DISABLED_TEXT_COLOR);

		this.largeDarkElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, DARK_TEXT_COLOR);
		this.largeLightElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, LIGHT_TEXT_COLOR);
		this.largeDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, DISABLED_TEXT_COLOR);
		#elseif html5
		var regularFont:Font = Assets.getFont(SOURCE_SANS_PRO_REGULAR_FILE_NAME);
		var boldFont:Font = Assets.getFont(SOURCE_SANS_PRO_SEMIBOLD_FILE_NAME);
		
		this.darkUIElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightUIElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.selectedUIElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, SELECTED_TEXT_COLOR);
		this.lightUIDisabledElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, DISABLED_TEXT_COLOR);
		this.darkUIDisabledElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, DARK_DISABLED_TEXT_COLOR);

		this.darkElementFormat = new TextFormat(regularFont.fontName, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightElementFormat = new TextFormat(regularFont.fontName, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.disabledElementFormat = new TextFormat(regularFont.fontName, this.regularFontSize, DISABLED_TEXT_COLOR);

		this.smallLightElementFormat = new TextFormat(regularFont.fontName, this.smallFontSize, LIGHT_TEXT_COLOR);
		this.smallDisabledElementFormat = new TextFormat(regularFont.fontName, this.smallFontSize, DISABLED_TEXT_COLOR);

		this.largeDarkElementFormat = new TextFormat(regularFont.fontName, this.largeFontSize, DARK_TEXT_COLOR);
		this.largeLightElementFormat = new TextFormat(regularFont.fontName, this.largeFontSize, LIGHT_TEXT_COLOR);
		this.largeDisabledElementFormat = new TextFormat(regularFont.fontName, this.largeFontSize, DISABLED_TEXT_COLOR);
		#else
		var regularFont:Font = Assets.getFont(SOURCE_SANS_PRO_REGULAR_FILE_NAME);
		var boldFont:Font = Assets.getFont(SOURCE_SANS_PRO_SEMIBOLD_FILE_NAME);
		
		this.darkUIElementFormat = new BitmapFontTextFormat(boldFont.fontName, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightUIElementFormat = new BitmapFontTextFormat(boldFont.fontName, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.selectedUIElementFormat = new BitmapFontTextFormat(boldFont.fontName, this.regularFontSize, SELECTED_TEXT_COLOR);
		this.lightUIDisabledElementFormat = new BitmapFontTextFormat(boldFont.fontName, this.regularFontSize, DISABLED_TEXT_COLOR);
		this.darkUIDisabledElementFormat = new BitmapFontTextFormat(boldFont.fontName, this.regularFontSize, DARK_DISABLED_TEXT_COLOR);

		this.darkElementFormat = new BitmapFontTextFormat(regularFont.fontName, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightElementFormat = new BitmapFontTextFormat(regularFont.fontName, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.disabledElementFormat = new BitmapFontTextFormat(regularFont.fontName, this.regularFontSize, DISABLED_TEXT_COLOR);

		this.smallLightElementFormat = new BitmapFontTextFormat(regularFont.fontName, this.smallFontSize, LIGHT_TEXT_COLOR);
		this.smallDisabledElementFormat = new BitmapFontTextFormat(regularFont.fontName, this.smallFontSize, DISABLED_TEXT_COLOR);

		this.largeDarkElementFormat = new BitmapFontTextFormat(regularFont.fontName, this.largeFontSize, DARK_TEXT_COLOR);
		this.largeLightElementFormat = new BitmapFontTextFormat(regularFont.fontName, this.largeFontSize, LIGHT_TEXT_COLOR);
		this.largeDisabledElementFormat = new BitmapFontTextFormat(regularFont.fontName, this.largeFontSize, DISABLED_TEXT_COLOR);
		#end
	}

	/**
	 * Initializes the textures by extracting them from the atlas and
	 * setting up any scaling grids that are needed.
	 */
	private function initializeTextures():Void
	{
		var backgroundSkinTexture:Texture = this.atlas.getTexture("background-skin");
		var backgroundInsetSkinTexture:Texture = this.atlas.getTexture("background-inset-skin");
		var backgroundDisabledSkinTexture:Texture = this.atlas.getTexture("background-disabled-skin");
		var backgroundFocusedSkinTexture:Texture = this.atlas.getTexture("background-focused-skin");
		var backgroundPopUpSkinTexture:Texture = this.atlas.getTexture("background-popup-skin");

		var checkUpIconTexture:Texture = this.atlas.getTexture("check-up-icon");
		var checkDownIconTexture:Texture = this.atlas.getTexture("check-down-icon");
		var checkDisabledIconTexture:Texture = this.atlas.getTexture("check-disabled-icon");

		this.focusIndicatorSkinTextures = new Scale9Textures(this.atlas.getTexture("focus-indicator-skin"), FOCUS_INDICATOR_SCALE_9_GRID);

		this.backgroundSkinTextures = new Scale9Textures(backgroundSkinTexture, DEFAULT_SCALE9_GRID);
		this.backgroundDisabledSkinTextures = new Scale9Textures(backgroundDisabledSkinTexture, DEFAULT_SCALE9_GRID);
		this.backgroundFocusedSkinTextures = new Scale9Textures(backgroundFocusedSkinTexture, DEFAULT_SCALE9_GRID);
		this.backgroundPopUpSkinTextures = new Scale9Textures(backgroundPopUpSkinTexture, SIMPLE_SCALE9_GRID);
		this.listBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("list-background-skin"), DEFAULT_SCALE9_GRID);

		this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE9_GRID);
		this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_SCALE9_GRID);
		this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE9_GRID);
		this.buttonSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-up-skin"), BUTTON_SELECTED_SCALE9_GRID);
		this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), BUTTON_SELECTED_SCALE9_GRID);
		this.buttonQuietHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("button-quiet-hover-skin"), BUTTON_SCALE9_GRID);
		this.buttonCallToActionUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-call-to-action-up-skin"), BUTTON_SCALE9_GRID);
		this.buttonCallToActionDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-call-to-action-down-skin"), BUTTON_SCALE9_GRID);
		this.buttonDangerUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-up-skin"), BUTTON_SCALE9_GRID);
		this.buttonDangerDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-down-skin"), BUTTON_SCALE9_GRID);
		this.buttonBackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-up-skin"), BACK_BUTTON_SCALE3_REGION1, BACK_BUTTON_SCALE3_REGION2);
		this.buttonBackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-down-skin"), BACK_BUTTON_SCALE3_REGION1, BACK_BUTTON_SCALE3_REGION2);
		this.buttonBackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-disabled-skin"), BACK_BUTTON_SCALE3_REGION1, BACK_BUTTON_SCALE3_REGION2);
		this.buttonForwardUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-up-skin"), FORWARD_BUTTON_SCALE3_REGION1, FORWARD_BUTTON_SCALE3_REGION2);
		this.buttonForwardDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-down-skin"), FORWARD_BUTTON_SCALE3_REGION1, FORWARD_BUTTON_SCALE3_REGION2);
		this.buttonForwardDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-disabled-skin"), FORWARD_BUTTON_SCALE3_REGION1, FORWARD_BUTTON_SCALE3_REGION2);

		this.tabUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-up-skin"), TAB_SCALE9_GRID);
		this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE9_GRID);
		this.tabDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-disabled-skin"), TAB_SCALE9_GRID);
		this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"), TAB_SCALE9_GRID);
		this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE9_GRID);

		this.pickerListButtonIconTexture = this.atlas.getTexture("picker-list-icon");
		this.pickerListButtonIconSelectedTexture = this.atlas.getTexture("picker-list-icon-selected");
		this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-icon-disabled");

		this.radioUpIconTexture = checkUpIconTexture;
		this.radioDownIconTexture = checkDownIconTexture;
		this.radioDisabledIconTexture = checkDisabledIconTexture;
		this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon");
		this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon");
		this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

		this.checkUpIconTexture = checkUpIconTexture;
		this.checkDownIconTexture = checkDownIconTexture;
		this.checkDisabledIconTexture = checkDisabledIconTexture;
		this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon");
		this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon");
		this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

		this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");
		this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");

		this.searchIconTexture = this.atlas.getTexture("search-icon");
		this.searchIconDisabledTexture = this.atlas.getTexture("search-icon-disabled");

		this.itemRendererSelectedSkinTexture = this.atlas.getTexture("item-renderer-selected-background-skin");

		this.headerBackgroundSkinTexture = this.atlas.getTexture("header-background-skin");
		this.headerPopupBackgroundSkinTexture = this.atlas.getTexture("header-popup-background-skin");

		this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top-skin");
		this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right-skin");
		this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom-skin");
		this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left-skin");

		this.horizontalSimpleScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("horizontal-simple-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.horizontalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon");
		this.horizontalScrollBarDecrementButtonDisabledIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-disabled-icon");
		this.horizontalScrollBarDecrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-decrement-button-up-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.horizontalScrollBarDecrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-decrement-button-down-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.horizontalScrollBarDecrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-decrement-button-disabled-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.horizontalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon");
		this.horizontalScrollBarIncrementButtonDisabledIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-disabled-icon");
		this.horizontalScrollBarIncrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-increment-button-up-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.horizontalScrollBarIncrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-increment-button-down-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.horizontalScrollBarIncrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-increment-button-disabled-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);

		this.verticalSimpleScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("vertical-simple-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_VERTICAL);
		this.verticalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon");
		this.verticalScrollBarDecrementButtonDisabledIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-disabled-icon");
		this.verticalScrollBarDecrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-decrement-button-up-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.verticalScrollBarDecrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-decrement-button-down-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.verticalScrollBarDecrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-decrement-button-disabled-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.verticalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon");
		this.verticalScrollBarIncrementButtonDisabledIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-disabled-icon");
		this.verticalScrollBarIncrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-increment-button-up-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.verticalScrollBarIncrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-increment-button-down-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);
		this.verticalScrollBarIncrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-increment-button-disabled-skin"), SCROLL_BAR_STEP_BUTTON_SCALE9_GRID);

		StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");
	}

	/**
	 * Sets global style providers for all components.
	 */
	private function initializeStyleProviders():Void
	{
		//alert
		this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_HEADER, this.setPopupHeaderStyles);
		this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
		#if flash
		this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);
		#elseif html5
		this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);
		#else
		this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);
		#end

		//button
		this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_BACK_BUTTON, this.setBackButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

		//button group
		this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;

		//callout
		this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

		//check
		this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

		//drawers
		this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

		//grouped list (see also: item renderers)
		this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;

		//header
		this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

		//header and footer renderers for grouped list
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_NAME_FOOTER_RENDERER, this.setGroupedListFooterRendererStyles);

		//item renderers for lists
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(#if flash TextBlockTextRenderer #elseif html5 TextFieldTextRenderer #else BitmapFontTextRenderer #end).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelRendererStyles);
		this.getStyleProviderForClass(#if flash TextBlockTextRenderer #elseif html5 TextFieldTextRenderer #else BitmapFontTextRenderer #end).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

		//labels
		this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_HEADING, this.setHeadingLabelStyles);
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_DETAIL, this.setDetailLabelStyles);

		//list (see also: item renderers)
		this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

		//numeric stepper
		this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
		this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_DECREMENT_BUTTON, this.setNumericStepperDecrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_INCREMENT_BUTTON, this.setNumericStepperIncrementButtonStyles);

		//page indicator
		this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

		//panel
		this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_NAME_HEADER, this.setPopupHeaderStyles);

		//panel screen
		this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setScrollerStyles;
		this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_NAME_HEADER, this.setPanelScreenHeaderStyles);

		//picker list (see also: list and item renderers)
		this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_BUTTON, this.setPickerListButtonStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_BUTTON, this.setPickerListButtonStyles);
		this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_LIST, this.setPickerListListStyles);

		//progress bar
		this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

		//radio
		this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

		//scroll bar
		this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalScrollBarStyles);
		this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR, this.setVerticalScrollBarStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON, this.setHorizontalScrollBarIncrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON, this.setHorizontalScrollBarDecrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_THUMB, this.setHorizontalScrollBarThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK, this.setHorizontalScrollBarMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SCROLL_BAR_MAXIMUM_TRACK, this.setHorizontalScrollBarMaximumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_THUMB, this.setVerticalScrollBarThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK, this.setVerticalScrollBarMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_MAXIMUM_TRACK, this.setVerticalScrollBarMaximumTrackStyles);

		//scroll container
		this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
		this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

		//scroll screen
		this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollerStyles;

		//scroll text
		this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

		//simple scroll bar
		this.getStyleProviderForClass(SimpleScrollBar).defaultStyleFunction = this.setSimpleScrollBarStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);

		//slider
		this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_NAME_THUMB, this.setSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK, this.setHorizontalSliderMaximumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK, this.setVerticalSliderMaximumTrackStyles);

		//tab bar
		this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_NAME_TAB, this.setTabStyles);

		//text input
		this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
		this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

		//text area
		this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

		//toggle button
		this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

		//toggle switch
		this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_THUMB, this.setToggleSwitchThumbStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_THUMB, this.setToggleSwitchThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK, this.setToggleSwitchTrackStyles);
		//we don't need a style function for the off track in this theme
		//the toggle switch layout uses a single track
	}

	private function pageIndicatorNormalSymbolFactory():DisplayObject
	{
		var symbol:ImageLoader = new ImageLoader();
		symbol.source = this.pageIndicatorNormalSkinTexture;
		symbol.textureScale = this.scale;
		return symbol;
	}

	private function pageIndicatorSelectedSymbolFactory():DisplayObject
	{
		var symbol:ImageLoader = new ImageLoader();
		symbol.source = this.pageIndicatorSelectedSkinTexture;
		symbol.textureScale = this.scale;
		return symbol;
	}

	private function imageLoaderFactory():ImageLoader
	{
		var image:ImageLoader = new ImageLoader();
		image.textureScale = this.scale;
		return image;
	}

//-------------------------
// Shared
//-------------------------

	private function setScrollerStyles(scroller:Scroller):Void
	{
		scroller.horizontalScrollBarFactory = scrollBarFactory;
		scroller.verticalScrollBarFactory = scrollBarFactory;
		scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
		scroller.interactionMode = Scroller.INTERACTION_MODE_MOUSE;
	}

//-------------------------
// Alert
//-------------------------

	private function setAlertStyles(alert:Alert):Void
	{
		this.setScrollerStyles(alert);

		var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
		alert.backgroundSkin = backgroundSkin;

		alert.paddingTop = this.gutterSize;
		alert.paddingRight = this.gutterSize;
		alert.paddingBottom = this.smallGutterSize;
		alert.paddingLeft = this.gutterSize;
		alert.outerPadding = this.borderSize;
		alert.gap = this.smallGutterSize;
		alert.maxWidth = this.popUpSize;
		alert.maxHeight = this.popUpSize;
	}

	//see Panel section for Header styles

	private function setAlertButtonGroupStyles(group:ButtonGroup):Void
	{
		group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
		group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
		group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
		group.distributeButtonSizes = false;
		group.gap = this.smallGutterSize;
		group.padding = this.smallGutterSize;
	}

	private function setAlertMessageTextRendererStyles(renderer:#if flash TextBlockTextRenderer #elseif html5 TextFieldTextRenderer #else BitmapFontTextRenderer #end):Void
	{
		renderer.wordWrap = true;
		#if flash
		renderer.elementFormat = this.lightElementFormat;
		#else
		renderer.textFormat = this.lightElementFormat;
		#end
	}

//-------------------------
// Button
//-------------------------

	private function setBaseButtonStyles(button:Button):Void
	{
		button.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIElementFormat);
		button.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIDisabledElementFormat);
		if(Std.is(button, ToggleButton))
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			cast(button, ToggleButton).selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIDisabledElementFormat);
		}

		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		button.focusPadding = this.focusPaddingSize;

		button.paddingTop = this.smallGutterSize;
		button.paddingBottom = this.smallGutterSize;
		button.paddingLeft = this.gutterSize;
		button.paddingRight = this.gutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.smallControlSize;
		button.minHeight = this.smallControlSize;
	}

	private function setButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		if(Std.is(button, ToggleButton))
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		}
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.minWidth = this.buttonMinWidth;
		button.minHeight = this.controlSize;
	}

	private function setCallToActionButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonCallToActionUpSkinTextures;
		skinSelector.setValueForState(this.buttonCallToActionDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.minWidth = this.buttonMinWidth;
		button.minHeight = this.controlSize;
	}

	private function setQuietButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.buttonQuietHoverSkinTextures, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(null, Button.STATE_DISABLED, false);
		if(Std.is(button, ToggleButton))
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, false);
		}
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		button.focusPadding = this.focusPaddingSize;

		button.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		button.downLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIElementFormat);
		button.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		if(Std.is(button, ToggleButton))
		{
			var toggleButton:ToggleButton = cast(button, ToggleButton);
			toggleButton.defaultSelectedLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIElementFormat);
			toggleButton.selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIDisabledElementFormat);
		}

		button.paddingTop = this.smallGutterSize;
		button.paddingBottom = this.smallGutterSize;
		button.paddingLeft = this.gutterSize;
		button.paddingRight = this.gutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

	private function setDangerButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonDangerUpSkinTextures;
		skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.minWidth = this.buttonMinWidth;
		button.minHeight = this.controlSize;
	}

	private function setBackButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonBackUpSkinTextures;
		skinSelector.setValueForState(this.buttonBackDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonBackDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.paddingLeft = 2 * this.gutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

	private function setForwardButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonForwardUpSkinTextures;
		skinSelector.setValueForState(this.buttonForwardDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonForwardDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.paddingRight = 2 * this.gutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

//-------------------------
// ButtonGroup
//-------------------------

	private function setButtonGroupStyles(group:ButtonGroup):Void
	{
		group.minWidth = this.wideControlSize;
		group.gap = this.smallGutterSize;
	}

//-------------------------
// Callout
//-------------------------

	private function setCalloutStyles(callout:Callout):Void
	{
		var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
		backgroundSkin.width = this.calloutBackgroundMinSize;
		backgroundSkin.height = this.calloutBackgroundMinSize;
		callout.backgroundSkin = backgroundSkin;

		var topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
		topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
		callout.topArrowSkin = topArrowSkin;
		callout.topArrowGap = this.calloutArrowOverlapGap;

		var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
		rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
		callout.rightArrowSkin = rightArrowSkin;
		callout.rightArrowGap = this.calloutArrowOverlapGap;

		var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
		bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
		callout.bottomArrowSkin = bottomArrowSkin;
		callout.bottomArrowGap = this.calloutArrowOverlapGap;

		var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
		leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
		callout.leftArrowSkin = leftArrowSkin;
		callout.leftArrowGap = this.calloutArrowOverlapGap;

		callout.padding = this.gutterSize;
	}

//-------------------------
// Check
//-------------------------

	private function setCheckStyles(check:Check):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.defaultValue = this.checkUpIconTexture;
		iconSelector.defaultSelectedValue = this.checkSelectedUpIconTexture;
		iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
		iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_DOWN, true);
		iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
		iconSelector.displayObjectProperties.storage =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		check.stateToIconFunction = iconSelector.updateValue;

		check.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		check.focusPaddingLeft = this.focusPaddingSize;
		check.focusPaddingRight = this.focusPaddingSize;

		check.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		check.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		check.selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);

		check.gap = this.smallGutterSize;
		check.minWidth = this.controlSize;
		check.minHeight = this.controlSize;
	}

//-------------------------
// Drawers
//-------------------------

	private function setDrawersStyles(drawers:Drawers):Void
	{
		var overlaySkin:Quad = new Quad(1, 1, DRAWER_OVERLAY_COLOR);
		overlaySkin.alpha = DRAWER_OVERLAY_ALPHA;
		drawers.overlaySkin = overlaySkin;
	}

//-------------------------
// GroupedList
//-------------------------

	private function setGroupedListStyles(list:GroupedList):Void
	{
		this.setScrollerStyles(list);

		list.padding = this.borderSize;
		list.backgroundSkin = new Scale9Image(this.listBackgroundSkinTextures, this.scale);
		list.backgroundDisabledSkin = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);

		list.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);

		list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
	}

	//see List section for item renderer styles

	private function setGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.backgroundSkin = new Quad(this.controlSize, this.controlSize, GROUPED_LIST_HEADER_BACKGROUND_COLOR);

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
		renderer.contentLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		renderer.contentLabelProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);

		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;

		renderer.contentLoaderFactory = this.imageLoaderFactory;
	}

	private function setGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.backgroundSkin = new Quad(this.controlSize, this.controlSize, GROUPED_LIST_FOOTER_BACKGROUND_COLOR);

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
		renderer.contentLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
		renderer.contentLabelProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);

		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.minWidth = renderer.minHeight = this.controlSize;

		renderer.contentLoaderFactory = this.imageLoaderFactory;
	}

//-------------------------
// Header
//-------------------------

	private function setHeaderStyles(header:Header):Void
	{
		header.minWidth = this.gridSize;
		header.minHeight = this.gridSize;
		header.paddingTop = this.smallGutterSize;
		header.paddingBottom = this.smallGutterSize;
		header.paddingRight = this.gutterSize;
		header.paddingLeft = this.gutterSize;
		header.gap = this.smallGutterSize;
		header.titleGap = this.smallGutterSize;

		var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
		backgroundSkin.width = backgroundSkin.height = this.controlSize;
		header.backgroundSkin = backgroundSkin;
		header.titleProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
	}

//-------------------------
// Label
//-------------------------

	private function setLabelStyles(label:Label):Void
	{
		label.textRendererProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
		label.textRendererProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.disabledElementFormat);
	}

	private function setHeadingLabelStyles(label:Label):Void
	{
		label.textRendererProperties.setProperty(ELEMENT_FORMAT_STR, this.largeLightElementFormat);
		label.textRendererProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.largeDisabledElementFormat);
	}

	private function setDetailLabelStyles(label:Label):Void
	{
		label.textRendererProperties.setProperty(ELEMENT_FORMAT_STR, this.smallLightElementFormat);
		label.textRendererProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.smallDisabledElementFormat);
	}

//-------------------------
// List
//-------------------------

	private function setListStyles(list:List):Void
	{
		this.setScrollerStyles(list);

		list.padding = this.borderSize;
		list.backgroundSkin = new Scale9Image(this.listBackgroundSkinTextures, this.scale);
		list.backgroundDisabledSkin = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);

		list.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);

		list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
	}

	private function setItemRendererStyles(renderer:BaseDefaultItemRenderer):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = LIST_BACKGROUND_COLOR;
		skinSelector.defaultSelectedValue = this.itemRendererSelectedSkinTexture;
		skinSelector.setValueForState(LIST_BACKGROUND_HOVER_COLOR, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.itemRendererSelectedSkinTexture, Button.STATE_DOWN, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		renderer.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
		renderer.hoverLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkElementFormat);
		renderer.downLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkElementFormat);
		renderer.defaultSelectedLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkElementFormat);
		renderer.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.disabledElementFormat);

		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.gap = this.smallGutterSize;
		renderer.minGap = this.smallGutterSize;
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.smallGutterSize;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;

		renderer.useStateDelayTimer = false;

		renderer.accessoryLoaderFactory = this.imageLoaderFactory;
		renderer.iconLoaderFactory = this.imageLoaderFactory;
	}

	private function setItemRendererAccessoryLabelRendererStyles(renderer:#if flash TextBlockTextRenderer #elseif html5 TextFieldTextRenderer #else BitmapFontTextRenderer #end):Void
	{
		#if flash
		renderer.elementFormat = this.lightElementFormat;
		#else
		renderer.textFormat = this.lightElementFormat;
		#end
	}

	private function setItemRendererIconLabelStyles(renderer:#if flash TextBlockTextRenderer #elseif html5 TextFieldTextRenderer #else BitmapFontTextRenderer #end):Void
	{
		#if flash
		renderer.elementFormat = this.lightElementFormat;
		#else
		renderer.textFormat = this.lightElementFormat;
		#end
	}

//-------------------------
// NumericStepper
//-------------------------

	private function setNumericStepperStyles(stepper:NumericStepper):Void
	{
		stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;

		stepper.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		stepper.focusPadding = this.focusPaddingSize;
	}

	private function setNumericStepperTextInputStyles(input:TextInput):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
		skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextInput.STATE_FOCUSED);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.gridSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		input.stateToSkinFunction = skinSelector.updateValue;

		input.minWidth = this.gridSize;
		input.minHeight = this.controlSize;
		input.gap = this.smallGutterSize;
		input.paddingTop = this.smallGutterSize;
		input.paddingBottom = this.smallGutterSize;
		input.paddingLeft = this.gutterSize;
		input.paddingRight = this.gutterSize;

		input.textEditorProperties.setProperty("cursorSkin", new Quad(1, 1, LIGHT_TEXT_COLOR));
		input.textEditorProperties.setProperty("selectionSkin", new Quad(1, 1, TEXT_SELECTION_BACKGROUND_COLOR));
		input.textEditorProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		input.textEditorProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		#if flash
		input.textEditorProperties.setProperty("textAlign", TextBlockTextEditor.TEXT_ALIGN_CENTER);
		#end
	}

	private function setNumericStepperDecrementButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.verticalScrollBarIncrementButtonUpSkinTextures;
		skinSelector.setValueForState(this.verticalScrollBarIncrementButtonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.verticalScrollBarIncrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.defaultIcon = new Image(this.verticalScrollBarIncrementButtonIconTexture);
		button.disabledIcon = new Image(this.verticalScrollBarIncrementButtonDisabledIconTexture);

		var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
		incrementButtonDisabledIcon.alpha = 0;
		button.disabledIcon = incrementButtonDisabledIcon;

		button.keepDownStateOnRollOut = true;
		button.hasLabelTextRenderer = false;
	}

	private function setNumericStepperIncrementButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.verticalScrollBarDecrementButtonUpSkinTextures;
		skinSelector.setValueForState(this.verticalScrollBarDecrementButtonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.verticalScrollBarDecrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.defaultIcon = new Image(this.verticalScrollBarDecrementButtonIconTexture);
		button.disabledIcon = new Image(this.verticalScrollBarDecrementButtonDisabledIconTexture);

		var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
		incrementButtonDisabledIcon.alpha = 0;
		button.disabledIcon = incrementButtonDisabledIcon;

		button.keepDownStateOnRollOut = true;
		button.hasLabelTextRenderer = false;
	}

//-------------------------
// PageIndicator
//-------------------------

	private function setPageIndicatorStyles(pageIndicator:PageIndicator):Void
	{
		pageIndicator.interactionMode = PageIndicator.INTERACTION_MODE_PRECISE;

		pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
		pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;

		pageIndicator.gap = this.gutterSize;
		pageIndicator.padding = this.smallGutterSize;
		pageIndicator.minWidth = this.controlSize;
		pageIndicator.minHeight = this.controlSize;
	}

//-------------------------
// Panel
//-------------------------

	private function setPanelStyles(panel:Panel):Void
	{
		this.setScrollerStyles(panel);

		var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
		panel.backgroundSkin = backgroundSkin;
		panel.padding = this.gutterSize;
		panel.outerPadding = this.borderSize;
	}

	private function setPopupHeaderStyles(header:Header):Void
	{
		header.minWidth = this.gridSize;
		header.minHeight = this.gridSize;
		header.paddingTop = this.smallGutterSize;
		header.paddingBottom = this.smallGutterSize;
		header.paddingRight = this.gutterSize;
		header.paddingLeft = this.gutterSize;
		header.gap = this.smallGutterSize;
		header.titleGap = this.smallGutterSize;

		var backgroundSkin:TiledImage = new TiledImage(this.headerPopupBackgroundSkinTexture, this.scale);
		backgroundSkin.width = backgroundSkin.height = this.controlSize;
		header.backgroundSkin = backgroundSkin;
		header.titleProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
	}

//-------------------------
// PanelScreen
//-------------------------

	private function setPanelScreenHeaderStyles(header:Header):Void
	{
		this.setHeaderStyles(header);
		header.useExtraPaddingForOSStatusBar = true;
	}

//-------------------------
// PickerList
//-------------------------

	private function setPickerListStyles(list:PickerList):Void
	{
		list.popUpContentManager = new DropDownPopUpContentManager();
		list.toggleButtonOnOpenAndClose = true;
		list.buttonFactory = pickerListButtonFactory;
	}

	private function setPickerListListStyles(list:List):Void
	{
		this.setListStyles(list);
		list.maxHeight = this.wideControlSize;
	}

	private function setPickerListButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.pickerListButtonIconTexture;
		iconSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, false);
		if(Std.is(button, ToggleButton))
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			iconSelector.defaultSelectedValue = this.pickerListButtonIconSelectedTexture;
			iconSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, true);
		}
		iconSelector.displayObjectProperties.storage =
		{
			snapToPixels: true,
			textureScale: this.scale
		}
		button.stateToIconFunction = iconSelector.updateValue;

		this.setBaseButtonStyles(button);

		button.gap = Math.POSITIVE_INFINITY; //fill as completely as possible
		button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		button.iconPosition = Button.ICON_POSITION_RIGHT;
		button.minWidth = this.buttonMinWidth;
		button.minHeight = this.controlSize;
	}

//-------------------------
// ProgressBar
//-------------------------

	private function setProgressBarStyles(progress:ProgressBar):Void
	{
		var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
		if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
		{
			backgroundSkin.width = this.smallControlSize;
			backgroundSkin.height = this.wideControlSize;
		}
		else
		{
			backgroundSkin.width = this.wideControlSize;
			backgroundSkin.height = this.smallControlSize;
		}
		progress.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
		if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
		{
			backgroundDisabledSkin.width = this.smallControlSize;
			backgroundDisabledSkin.height = this.wideControlSize;
		}
		else
		{
			backgroundDisabledSkin.width = this.wideControlSize;
			backgroundDisabledSkin.height = this.smallControlSize;
		}
		progress.backgroundDisabledSkin = backgroundDisabledSkin;

		var fillSkin:Scale9Image = new Scale9Image(this.buttonUpSkinTextures, this.scale);
		if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
		{
			fillSkin.width = this.smallControlSize;
			fillSkin.height = this.progressBarFillMinSize;
		}
		else
		{
			fillSkin.width = this.progressBarFillMinSize;
			fillSkin.height = this.smallControlSize;
		}
		progress.fillSkin = fillSkin;

		var fillDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);
		if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
		{
			fillDisabledSkin.width = this.smallControlSize;
			fillDisabledSkin.height = this.progressBarFillMinSize;
		}
		else
		{
			fillDisabledSkin.width = this.progressBarFillMinSize;
			fillDisabledSkin.height = this.smallControlSize;
		}
		progress.fillDisabledSkin = fillDisabledSkin;
	}

//-------------------------
// Radio
//-------------------------

	private function setRadioStyles(radio:Radio):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.defaultValue = this.radioUpIconTexture;
		iconSelector.defaultSelectedValue = this.radioSelectedUpIconTexture;
		iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
		iconSelector.setValueForState(this.radioSelectedDownIconTexture, Button.STATE_DOWN, true);
		iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
		iconSelector.displayObjectProperties.storage =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		radio.stateToIconFunction = iconSelector.updateValue;

		radio.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		radio.focusPaddingLeft = this.focusPaddingSize;
		radio.focusPaddingRight = this.focusPaddingSize;

		radio.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		radio.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		radio.selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);

		radio.gap = this.smallGutterSize;
		radio.minWidth = this.controlSize;
		radio.minHeight = this.controlSize;
	}

//-------------------------
// ScrollBar
//-------------------------

	private function setHorizontalScrollBarStyles(scrollBar:ScrollBar):Void
	{
		scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
		scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

		scrollBar.customIncrementButtonName = THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
		scrollBar.customDecrementButtonName = THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
		scrollBar.customThumbName = THEME_NAME_HORIZONTAL_SCROLL_BAR_THUMB;
		scrollBar.customMinimumTrackName = THEME_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK;
	}

	private function setVerticalScrollBarStyles(scrollBar:ScrollBar):Void
	{
		scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
		scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX;

		scrollBar.customIncrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
		scrollBar.customDecrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
		scrollBar.customThumbName = THEME_NAME_VERTICAL_SCROLL_BAR_THUMB;
		scrollBar.customMinimumTrackName = THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK;
		scrollBar.customMaximumTrackName = THEME_NAME_VERTICAL_SCROLL_BAR_MAXIMUM_TRACK;
	}

	private function setHorizontalScrollBarIncrementButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.horizontalScrollBarIncrementButtonUpSkinTextures;
		skinSelector.setValueForState(this.horizontalScrollBarIncrementButtonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.horizontalScrollBarIncrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
		button.stateToSkinFunction = skinSelector.updateValue;
		skinSelector.displayObjectProperties.storage =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};

		button.defaultIcon = new Image(this.horizontalScrollBarIncrementButtonIconTexture);
		button.disabledIcon = new Image(this.horizontalScrollBarIncrementButtonDisabledIconTexture);

		var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
		incrementButtonDisabledIcon.alpha = 0;
		button.disabledIcon = incrementButtonDisabledIcon;

		button.hasLabelTextRenderer = false;
	}

	private function setHorizontalScrollBarDecrementButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.horizontalScrollBarDecrementButtonUpSkinTextures;
		skinSelector.setValueForState(this.horizontalScrollBarDecrementButtonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.horizontalScrollBarDecrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};

		button.stateToSkinFunction = skinSelector.updateValue;

		button.defaultIcon = new Image(this.horizontalScrollBarDecrementButtonIconTexture);
		button.disabledIcon = new Image(this.horizontalScrollBarDecrementButtonDisabledIconTexture);

		var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
		decrementButtonDisabledIcon.alpha = 0;
		button.disabledIcon = decrementButtonDisabledIcon;

		button.hasLabelTextRenderer = false;
	}

	private function setHorizontalScrollBarThumbStyles(thumb:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		thumb.stateToSkinFunction = skinSelector.updateValue;

		thumb.hasLabelTextRenderer = false;
	}

	private function setHorizontalScrollBarMinimumTrackStyles(track:Button):Void
	{
		track.defaultSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_COLOR);
		track.downSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_DOWN_COLOR);

		track.hasLabelTextRenderer = false;
	}

	private function setHorizontalScrollBarMaximumTrackStyles(track:Button):Void
	{
		track.defaultSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_COLOR);
		track.downSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_DOWN_COLOR);

		track.hasLabelTextRenderer = false;
	}

	private function setVerticalScrollBarIncrementButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.verticalScrollBarIncrementButtonUpSkinTextures;
		skinSelector.setValueForState(this.verticalScrollBarIncrementButtonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.verticalScrollBarIncrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.defaultIcon = new Image(this.verticalScrollBarIncrementButtonIconTexture);
		button.disabledIcon = new Image(this.verticalScrollBarIncrementButtonDisabledIconTexture);

		var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
		incrementButtonDisabledIcon.alpha = 0;
		button.disabledIcon = incrementButtonDisabledIcon;

		button.hasLabelTextRenderer = false;
	}

	private function setVerticalScrollBarDecrementButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.verticalScrollBarDecrementButtonUpSkinTextures;
		skinSelector.setValueForState(this.verticalScrollBarDecrementButtonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.verticalScrollBarDecrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.defaultIcon = new Image(this.verticalScrollBarDecrementButtonIconTexture);
		button.disabledIcon = new Image(this.verticalScrollBarDecrementButtonDisabledIconTexture);

		var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
		decrementButtonDisabledIcon.alpha = 0;
		button.disabledIcon = decrementButtonDisabledIcon;

		button.hasLabelTextRenderer = false;
	}

	private function setVerticalScrollBarThumbStyles(thumb:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		thumb.stateToSkinFunction = skinSelector.updateValue;

		thumb.hasLabelTextRenderer = false;
	}

	private function setVerticalScrollBarMinimumTrackStyles(track:Button):Void
	{
		track.defaultSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_COLOR);
		track.downSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_DOWN_COLOR);

		track.hasLabelTextRenderer = false;
	}

	private function setVerticalScrollBarMaximumTrackStyles(track:Button):Void
	{
		track.defaultSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_COLOR);
		track.downSkin = new Quad(this.smallControlSize, this.smallControlSize, SCROLL_BAR_TRACK_DOWN_COLOR);

		track.hasLabelTextRenderer = false;
	}

//-------------------------
// ScrollContainer
//-------------------------

	private function setScrollContainerStyles(container:ScrollContainer):Void
	{
		this.setScrollerStyles(container);
	}

	private function setToolbarScrollContainerStyles(container:ScrollContainer):Void
	{
		this.setScrollerStyles(container);
		if(container.layout == null)
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.padding = this.gutterSize;
			layout.gap = this.smallGutterSize;
			container.layout = layout;
		}
		container.minWidth = this.gridSize;
		container.minHeight = this.gridSize;

		var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
		backgroundSkin.width = backgroundSkin.height = this.gridSize;
		container.backgroundSkin = backgroundSkin;
	}

//-------------------------
// ScrollText
//-------------------------

	private function setScrollTextStyles(text:ScrollText):Void
	{
		this.setScrollerStyles(text);

		text.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);

		text.textFormat = this.scrollTextTextFormat;
		text.disabledTextFormat = this.scrollTextDisabledTextFormat;
		text.padding = this.gutterSize;
	}

//-------------------------
// SimpleScrollBar
//-------------------------

	private function setSimpleScrollBarStyles(scrollBar:SimpleScrollBar):Void
	{
		if(scrollBar.direction == SimpleScrollBar.DIRECTION_HORIZONTAL)
		{
			scrollBar.paddingRight = this.scrollBarGutterSize;
			scrollBar.paddingBottom = this.scrollBarGutterSize;
			scrollBar.paddingLeft = this.scrollBarGutterSize;
			scrollBar.customThumbName = THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
		}
		else
		{
			scrollBar.paddingTop = this.scrollBarGutterSize;
			scrollBar.paddingRight = this.scrollBarGutterSize;
			scrollBar.paddingBottom = this.scrollBarGutterSize;
			scrollBar.customThumbName = THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
		}
	}

	private function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):Void
	{
		var defaultSkin:Scale3Image = new Scale3Image(this.horizontalSimpleScrollBarThumbSkinTextures, this.scale);
		defaultSkin.width = this.smallControlSize;
		thumb.defaultSkin = defaultSkin;

		thumb.hasLabelTextRenderer = false;
	}

	private function setVerticalSimpleScrollBarThumbStyles(thumb:Button):Void
	{
		var defaultSkin:Scale3Image = new Scale3Image(this.verticalSimpleScrollBarThumbSkinTextures, this.scale);
		defaultSkin.height = this.smallControlSize;
		thumb.defaultSkin = defaultSkin;

		thumb.hasLabelTextRenderer = false;
	}

//-------------------------
// Slider
//-------------------------

	private function setSliderStyles(slider:Slider):Void
	{
		slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
		if(slider.direction == Slider.DIRECTION_VERTICAL)
		{
			slider.customMinimumTrackName = THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
			slider.customMaximumTrackName = THEME_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK;
		}
		else
		{
			slider.customMinimumTrackName = THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
			slider.customMaximumTrackName = THEME_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK;
		}
		slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		slider.focusPadding = this.focusPaddingSize;
	}

	private function setSliderThumbStyles(thumb:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		thumb.stateToSkinFunction = skinSelector.updateValue;

		thumb.minWidth = this.smallControlSize;
		thumb.minHeight = this.smallControlSize;

		thumb.hasLabelTextRenderer = false;
	}

	private function setHorizontalSliderMinimumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			textureScale: this.scale
		};
		skinSelector.displayObjectProperties.setProperty("width", this.wideControlSize);
		skinSelector.displayObjectProperties.setProperty("height", this.smallControlSize);
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

	private function setHorizontalSliderMaximumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			textureScale: this.scale
		};
		skinSelector.displayObjectProperties.setProperty("width", this.wideControlSize);
		skinSelector.displayObjectProperties.setProperty("height", this.smallControlSize);
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

	private function setVerticalSliderMinimumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			textureScale: this.scale
		};
		skinSelector.displayObjectProperties.setProperty("width", this.smallControlSize);
		skinSelector.displayObjectProperties.setProperty("height", this.wideControlSize);
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

	private function setVerticalSliderMaximumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			textureScale: this.scale
		};
		skinSelector.displayObjectProperties.setProperty("width", this.smallControlSize);
		skinSelector.displayObjectProperties.setProperty("height", this.wideControlSize);
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

//-------------------------
// TabBar
//-------------------------

	private function setTabBarStyles(tabBar:TabBar):Void
	{
		tabBar.distributeTabSizes = false;
		tabBar.horizontalAlign = TabBar.HORIZONTAL_ALIGN_LEFT;
		tabBar.verticalAlign = TabBar.VERTICAL_ALIGN_JUSTIFY;
	}

	private function setTabStyles(tab:ToggleButton):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.tabUpSkinTextures;
		skinSelector.defaultSelectedValue = this.tabSelectedSkinTextures;
		skinSelector.setValueForState(this.tabDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.tabDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		tab.stateToSkinFunction = skinSelector.updateValue;

		tab.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		tab.focusPadding = this.focusPaddingSize;

		tab.defaultLabelProperties.setProperty("elementFormat", this.lightUIElementFormat);
		tab.downLabelProperties.setProperty("elementFormat", this.darkUIElementFormat);
		tab.defaultSelectedLabelProperties.setProperty("elementFormat", this.darkUIElementFormat);
		tab.disabledLabelProperties.setProperty("elementFormat", this.lightUIDisabledElementFormat);
		tab.selectedDisabledLabelProperties.setProperty("elementFormat", this.darkUIDisabledElementFormat);

		tab.paddingTop = this.smallGutterSize;
		tab.paddingBottom = this.smallGutterSize;
		tab.paddingLeft = this.gutterSize;
		tab.paddingRight = this.gutterSize;
		tab.gap = this.smallGutterSize;
		tab.minWidth = this.controlSize;
		tab.minHeight = this.controlSize;
	}

//-------------------------
// TextArea
//-------------------------

	private function setTextAreaStyles(textArea:TextArea):Void
	{
		this.setScrollerStyles(textArea);

		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextArea.STATE_DISABLED);
		skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextArea.STATE_FOCUSED);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.wideControlSize * 2,
			height: this.wideControlSize,
			textureScale: this.scale
		};
		textArea.stateToSkinFunction = skinSelector.updateValue;

		textArea.padding = this.gutterSize;

		textArea.textEditorProperties.setProperty(ELEMENT_FORMAT_STR, this.scrollTextTextFormat);
		textArea.textEditorProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.scrollTextDisabledTextFormat);
	}

//-------------------------
// TextInput
//-------------------------

	private function setBaseTextInputStyles(input:TextInput):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
		skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextInput.STATE_FOCUSED);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.wideControlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		input.stateToSkinFunction = skinSelector.updateValue;

		//input.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		//input.focusPadding = -1;

		input.minWidth = this.controlSize;
		input.minHeight = this.controlSize;
		input.gap = this.smallGutterSize;
		input.paddingTop = this.smallGutterSize;
		input.paddingBottom = this.smallGutterSize;
		input.paddingLeft = this.gutterSize;
		input.paddingRight = this.gutterSize;

		input.textEditorProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
		input.textEditorProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.disabledElementFormat);
		input.textEditorProperties.setProperty("cursorSkin", new Quad(1, 1, LIGHT_TEXT_COLOR));
		input.textEditorProperties.setProperty("selectionSkin", new Quad(1, 1, TEXT_SELECTION_BACKGROUND_COLOR));

		input.promptProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
		input.promptProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.disabledElementFormat);
	}

	private function setTextInputStyles(input:TextInput):Void
	{
		this.setBaseTextInputStyles(input);
	}

	private function setSearchTextInputStyles(input:TextInput):Void
	{
		this.setBaseTextInputStyles(input);

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.searchIconTexture;
		iconSelector.setValueForState(this.searchIconDisabledTexture, TextInput.STATE_DISABLED, false);
		iconSelector.displayObjectProperties.storage =
		{
			snapToPixels: true,
			textureScale: this.scale
		}
		input.stateToIconFunction = iconSelector.updateValue;
	}

//-------------------------
// ToggleSwitch
//-------------------------

	private function setToggleSwitchStyles(toggle:ToggleSwitch):Void
	{
		toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

		toggle.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		toggle.focusPadding = this.focusPaddingSize;

		toggle.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		toggle.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		toggle.onLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.selectedUIElementFormat);
	}

	private function setToggleSwitchThumbStyles(thumb:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		thumb.stateToSkinFunction = skinSelector.updateValue;

		thumb.minWidth = this.controlSize;
		thumb.minHeight = this.controlSize;

		thumb.hasLabelTextRenderer = false;
	}

	private function setToggleSwitchTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: Math.round(this.controlSize * 2.5),
			height: this.controlSize,
			textureScale: this.scale
		};
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

}
