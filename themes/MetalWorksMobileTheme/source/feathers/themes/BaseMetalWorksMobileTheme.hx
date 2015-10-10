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
import feathers.controls.Alert;
import feathers.controls.Button;
import feathers.controls.text.TextFieldTextEditor;
import feathers.controls.text.TextFieldTextRenderer;
import feathers.core.ITextEditor;
import feathers.core.ITextRenderer;
import feathers.utils.type.SafeCast.safe_cast;
import openfl.Assets;
import openfl.text.Font;
import feathers.controls.ButtonGroup;
import feathers.controls.Callout;
import feathers.controls.Check;
import feathers.controls.Drawers;
import feathers.controls.GroupedList;
import feathers.controls.Header;
import feathers.controls.ImageLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.List;
import feathers.controls.NumericStepper;
import feathers.controls.PageIndicator;
import feathers.controls.Panel;
import feathers.controls.PanelScreen;
import feathers.controls.PickerList;
import feathers.controls.ProgressBar;
import feathers.controls.Radio;
import feathers.controls.ScrollContainer;
import feathers.controls.ScrollScreen;
import feathers.controls.ScrollText;
import feathers.controls.Scroller;
import feathers.controls.SimpleScrollBar;
import feathers.controls.Slider;
import feathers.controls.SpinnerList;
import feathers.controls.TabBar;
import feathers.controls.TextArea;
import feathers.controls.TextInput;
import feathers.controls.ToggleButton;
import feathers.controls.ToggleSwitch;
import feathers.controls.popups.CalloutPopUpContentManager;
import feathers.controls.popups.VerticalCenteredPopUpContentManager;
import feathers.controls.renderers.BaseDefaultItemRenderer;
import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
import feathers.controls.renderers.DefaultGroupedListItemRenderer;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.text.StageTextTextEditor;
#if flash
import feathers.controls.text.TextBlockTextEditor;
import feathers.controls.text.TextBlockTextRenderer;
#end
import feathers.core.FeathersControl;
import feathers.core.PopUpManager;
import feathers.display.Scale3Image;
import feathers.display.Scale9Image;
import feathers.display.TiledImage;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import feathers.media.FullScreenToggleButton;
import feathers.media.MuteToggleButton;
import feathers.media.PlayPauseToggleButton;
import feathers.media.SeekSlider;
import feathers.media.VolumeSlider;
import feathers.skins.SmartDisplayObjectStateValueSelector;
import feathers.skins.StandardIcons;
import feathers.system.DeviceCapabilities;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;
import openfl.text.TextFormatAlign;

import openfl.geom.Rectangle;
import openfl.text.TextFormat;
#if flash
import flash.text.engine.CFFHinting;
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.FontLookup;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
import flash.text.engine.RenderingMode;
#end

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/**
 * The base class for the "Metal Works" theme for mobile Feathers apps.
 * Handles everything except asset loading, which is left to subclasses.
 *
 * @see MetalWorksMobileTheme
 * @see MetalWorksMobileThemeWithAssetManager
 */
class BaseMetalWorksMobileTheme extends StyleNameFunctionTheme
{
	//[Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf",fontFamily="SourceSansPro",fontWeight="normal",mimeType="application/x-font",embedAsCFF="true")]
	private static var SOURCE_SANS_PRO_REGULAR:Class<Dynamic>;

	//[Embed(source="/../assets/fonts/SourceSansPro-Semibold.ttf",fontFamily="SourceSansPro",fontWeight="bold",mimeType="application/x-font",embedAsCFF="true")]
	private static var SOURCE_SANS_PRO_SEMIBOLD:Class<Dynamic>;

	/**
	 * The name of the embedded font used by controls in this theme. Comes
	 * in normal and bold weights.
	 */
	inline public static var FONT_NAME:String = "SourceSansPro";
	inline private static var FONT_FILE_NAME:String = "assets/fonts/SourceSansPro-Regular.ttf";
	inline private static var BOLD_FONT_FILE_NAME:String = "assets/fonts/SourceSansPro-Semibold.ttf";
	inline private static var ELEMENT_FORMAT_STR:String = #if flash "elementFormat" #else "textFormat" #end;
	inline private static var DISABLED_ELEMENT_FORMAT_STR:String = #if flash "disabledElementFormat" #else "disabledTextFormat" #end;

	inline private static var PRIMARY_BACKGROUND_COLOR:UInt = 0x4a4137;
	inline private static var LIGHT_TEXT_COLOR:UInt = 0xe5e5e5;
	inline private static var DARK_TEXT_COLOR:UInt = 0x1a1816;
	inline private static var SELECTED_TEXT_COLOR:UInt = 0xff9900;
	inline private static var DISABLED_TEXT_COLOR:UInt = 0x8a8a8a;
	inline private static var DARK_DISABLED_TEXT_COLOR:UInt = 0x383430;
	inline private static var LIST_BACKGROUND_COLOR:UInt = 0x383430;
	inline private static var TAB_BACKGROUND_COLOR:UInt = 0x1a1816;
	inline private static var TAB_DISABLED_BACKGROUND_COLOR:UInt = 0x292624;
	inline private static var GROUPED_LIST_HEADER_BACKGROUND_COLOR:UInt = 0x2e2a26;
	inline private static var GROUPED_LIST_FOOTER_BACKGROUND_COLOR:UInt = 0x2e2a26;
	inline private static var MODAL_OVERLAY_COLOR:UInt = 0x29241e;
	inline private static var MODAL_OVERLAY_ALPHA:Float = 0.8;
	inline private static var DRAWER_OVERLAY_COLOR:UInt = 0x29241e;
	inline private static var DRAWER_OVERLAY_ALPHA:Float = 0.4;
	inline private static var VIDEO_OVERLAY_COLOR:UInt = 0x1a1816;
	inline private static var VIDEO_OVERLAY_ALPHA:Float = 0.2;

	/**
	 * The screen density of an iPhone with Retina display. The textures
	 * used by this theme are designed for this density and scale for other
	 * densities.
	 */
	inline private static var ORIGINAL_DPI_IPHONE_RETINA:Int = 326;

	/**
	 * The screen density of an iPad with Retina display. The textures used
	 * by this theme are designed for this density and scale for other
	 * densities.
	 */
	inline private static var ORIGINAL_DPI_IPAD_RETINA:Int = 264;

	private static var DEFAULT_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 22, 22);
	private static var BUTTON_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 50, 50);
	private static var BUTTON_SELECTED_SCALE9_GRID:Rectangle = new Rectangle(8, 8, 44, 44);
	inline private static var BACK_BUTTON_SCALE3_REGION1:Float = 24;
	inline private static var BACK_BUTTON_SCALE3_REGION2:Float = 6;
	inline private static var FORWARD_BUTTON_SCALE3_REGION1:Float = 6;
	inline private static var FORWARD_BUTTON_SCALE3_REGION2:Float = 6;
	private static var ITEM_RENDERER_SCALE9_GRID:Rectangle = new Rectangle(3, 0, 2, 82);
	private static var INSET_ITEM_RENDERER_FIRST_SCALE9_GRID:Rectangle = new Rectangle(13, 13, 3, 70);
	private static var INSET_ITEM_RENDERER_LAST_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 3, 75);
	private static var INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID:Rectangle = new Rectangle(13, 13, 3, 62);
	private static var TAB_SCALE9_GRID:Rectangle = new Rectangle(19, 19, 50, 50);
	private static var SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle(3, 9, 1, 70);
	inline private static var SCROLL_BAR_THUMB_REGION1:Int = 5;
	inline private static var SCROLL_BAR_THUMB_REGION2:Int = 14;

	/**
	 * @private
	 * The theme's custom style name for item renderers in a PickerList.
	 */
	inline private static var THEME_STYLE_NAME_PICKER_LIST_ITEM_RENDERER:String = "metal-works-mobile-picker-list-item-renderer";

	/**
	 * @private
	 * The theme's custom style name for item renderers in a SpinnerList.
	 */
	inline private static var THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER:String = "metal-works-mobile-spinner-list-item-renderer";

	/**
	 * @private
	 * The theme's custom style name for buttons in an Alert's button group.
	 */
	inline private static var THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON:String = "metal-works-mobile-alert-button-group-button";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a horizontal SimpleScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "metal-works-mobile-horizontal-simple-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a vertical SimpleScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "metal-works-mobile-vertical-simple-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a horizontal slider.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "metal-works-mobile-horizontal-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a horizontal slider.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK:String = "metal-works-mobile-horizontal-slider-maximum-track";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a vertical slider.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "metal-works-mobile-vertical-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a vertical slider.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK:String = "metal-works-mobile-vertical-slider-maximum-track";

	/**
	 * The default global text renderer factory for this theme creates a
	 * TextBlockTextRenderer.
	 */
	private static function textRendererFactory():#if flash ITextRenderer #else TextFieldTextRenderer #end
	{
		#if flash
		return new TextBlockTextRenderer();
		#else
		return new TextFieldTextRenderer();
		#end
	}

	/**
	 * The default global text editor factory for this theme creates a
	 * StageTextTextEditor.
	 */
	private static function textEditorFactory():StageTextTextEditor
	{
		return new StageTextTextEditor();
	}

	/**
	 * The text editor factory for a NumericStepper creates a
	 * TextBlockTextEditor.
	 */
	private static function stepperTextEditorFactory():ITextEditor
	{
		#if flash
		//we're only using this text editor in the NumericStepper because
		//isEditable is false on the TextInput. this text editor is not
		//suitable for mobile use if the TextInput needs to be editable
		//because it can't use the soft keyboard or other mobile-friendly UI
		return new TextBlockTextEditor();
		#else
		return new TextFieldTextEditor();
		#end
	}

	/**
	 * This theme's scroll bar type is SimpleScrollBar.
	 */

	private static function scrollBarFactory():SimpleScrollBar
	{
		return new SimpleScrollBar();
	}

	private static function popUpOverlayFactory():DisplayObject
	{
		var quad:Quad = new Quad(100, 100, MODAL_OVERLAY_COLOR);
		quad.alpha = MODAL_OVERLAY_ALPHA;
		return quad;
	}

	/**
	 * SmartDisplayObjectValueSelectors will use ImageLoader instead of
	 * Image so that we can use extra features like pixel snapping.
	 */
	private static function textureValueTypeHandler(value:Texture, oldDisplayObject:DisplayObject = null):DisplayObject
	{
		var displayObject:ImageLoader = safe_cast(oldDisplayObject, ImageLoader);
		if(displayObject == null)
		{
			displayObject = new ImageLoader();
		}
		displayObject.source = value;
		return displayObject;
	}

	/**
	 * Constructor.
	 *
	 * @param scaleToDPI Determines if the theme's skins will be scaled based on the screen density and content scale factor.
	 */
	public function new(scaleToDPI:Bool = true)
	{
		super();
		this._scaleToDPI = scaleToDPI;
	}

	/**
	 * @private
	 */
	private var _originalDPI:Int;

	/**
	 * The original screen density used for scaling.
	 */
	public var originalDPI(get, never):Int;
	public function get_originalDPI():Int
	{
		return this._originalDPI;
	}

	/**
	 * @private
	 */
	private var _scaleToDPI:Bool;

	/**
	 * Indicates if the theme scales skins to match the screen density of
	 * the device.
	 */
	public var scaleToDPI(get, never):Bool;
	public function get_scaleToDPI():Bool
	{
		return this._scaleToDPI;
	}

	/**
	 * Skins are scaled by a value based on the screen density on the
	 * content scale factor.
	 */
	private var scale:Float = 1;
	
	/**
	 * StageText scales strangely when contentsScaleFactor > 1, so we need
	 * to account for that.
	 */
	private var stageTextScale:Float = 1;

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
	 * An extra large font size.
	 */
	private var extraLargeFontSize:Int;
	
	/**
	 * The font size used for text inputs that use StageText.
	 * 
	 * @see #stageTextScale
	 */
	private var inputFontSize:Int;

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

	private var popUpFillSize:Int;
	private var calloutBackgroundMinSize:Int;
	private var scrollBarGutterSize:Int;

	/**
	 * The FTE FontDescription used for text of a normal weight.
	 */
#if flash
	private var regularFontDescription:FontDescription;
#end
	/**
	 * The FTE FontDescription used for text of a bold weight.
	 */
#if flash
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
	 * An ElementFormat used for Header components.
	 */
	private var headerElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a dark tint meant for UI controls.
	 */
	private var darkUIElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint meant for UI controls.
	 */
	private var lightUIElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a highlighted tint meant for selected UI controls.
	 */
	private var selectedUIElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint meant for disabled UI controls.
	 */
	private var lightUIDisabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a dark tint meant for disabled UI controls.
	 */
	private var darkUIDisabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a dark tint meant for larger UI controls.
	 */
	private var largeUIDarkElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint meant for larger UI controls.
	 */
	private var largeUILightElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a highlighted tint meant for larger UI controls.
	 */
	private var largeUISelectedElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a dark tint meant for larger disabled UI controls.
	 */
	private var largeUIDarkDisabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint meant for larger disabled UI controls.
	 */
	private var largeUILightDisabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a dark tint meant for larger text.
	 */
	private var largeDarkElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint meant for larger text.
	 */
	private var largeLightElementFormat:ElementFormat;

	/**
	 * An ElementFormat meant for larger disabled text.
	 */
	private var largeDisabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a dark tint meant for regular text.
	 */
	private var darkElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint meant for regular text.
	 */
	private var lightElementFormat:ElementFormat;

	/**
	 * An ElementFormat meant for regular, disabled text.
	 */
	private var disabledElementFormat:ElementFormat;

	/**
	 * An ElementFormat with a light tint meant for smaller text.
	 */
	private var smallLightElementFormat:ElementFormat;

	/**
	 * An ElementFormat meant for smaller, disabled text.
	 */
	private var smallDisabledElementFormat:ElementFormat;
#else
	private var headerElementFormat:TextFormat;
	private var darkUIElementFormat:TextFormat;
	private var lightUIElementFormat:TextFormat;
	private var selectedUIElementFormat:TextFormat;
	private var lightUIDisabledElementFormat:TextFormat;
	private var darkUIDisabledElementFormat:TextFormat;
	private var largeUIDarkElementFormat:TextFormat;
	private var largeUILightElementFormat:TextFormat;
	private var largeUISelectedElementFormat:TextFormat;
	private var largeUIDarkDisabledElementFormat:TextFormat;
	private var largeUILightDisabledElementFormat:TextFormat;
	private var largeDarkElementFormat:TextFormat;
	private var largeLightElementFormat:TextFormat;
	private var largeDisabledElementFormat:TextFormat;
	private var darkElementFormat:TextFormat;
	private var lightElementFormat:TextFormat;
	private var disabledElementFormat:TextFormat;
	private var smallLightElementFormat:TextFormat;
	private var smallDisabledElementFormat:TextFormat;

	private var lightUICenterElementFormat:TextFormat;
	private var lightUICenterDisabledElementFormat:TextFormat;
#end

	/**
	 * The texture atlas that contains skins for this theme. This base class
	 * does not initialize this member variable. Subclasses are expected to
	 * load the assets somehow and set the <code>atlas</code> member
	 * variable before calling <code>initialize()</code>.
	 */
	private var atlas:TextureAtlas;

	private var headerBackgroundSkinTexture:Texture;
	private var backgroundSkinTextures:Scale9Textures;
	private var backgroundInsetSkinTextures:Scale9Textures;
	private var backgroundDisabledSkinTextures:Scale9Textures;
	private var backgroundFocusedSkinTextures:Scale9Textures;
	private var buttonUpSkinTextures:Scale9Textures;
	private var buttonDownSkinTextures:Scale9Textures;
	private var buttonDisabledSkinTextures:Scale9Textures;
	private var buttonSelectedUpSkinTextures:Scale9Textures;
	private var buttonSelectedDisabledSkinTextures:Scale9Textures;
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
	private var pickerListButtonIconDisabledTexture:Texture;
	private var tabDownSkinTextures:Scale9Textures;
	private var tabSelectedSkinTextures:Scale9Textures;
	private var tabSelectedDisabledSkinTextures:Scale9Textures;
	private var pickerListItemSelectedIconTexture:Texture;
	private var spinnerListSelectionOverlaySkinTextures:Scale9Textures;
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
	private var itemRendererUpSkinTextures:Scale9Textures;
	private var itemRendererSelectedSkinTextures:Scale9Textures;
	private var insetItemRendererFirstUpSkinTextures:Scale9Textures;
	private var insetItemRendererFirstSelectedSkinTextures:Scale9Textures;
	private var insetItemRendererLastUpSkinTextures:Scale9Textures;
	private var insetItemRendererLastSelectedSkinTextures:Scale9Textures;
	private var insetItemRendererSingleUpSkinTextures:Scale9Textures;
	private var insetItemRendererSingleSelectedSkinTextures:Scale9Textures;
	private var backgroundPopUpSkinTextures:Scale9Textures;
	private var calloutTopArrowSkinTexture:Texture;
	private var calloutRightArrowSkinTexture:Texture;
	private var calloutBottomArrowSkinTexture:Texture;
	private var calloutLeftArrowSkinTexture:Texture;
	private var verticalScrollBarThumbSkinTextures:Scale3Textures;
	private var horizontalScrollBarThumbSkinTextures:Scale3Textures;
	private var searchIconTexture:Texture;
	private var searchIconDisabledTexture:Texture;
		
	//media textures
	private var playPauseButtonPlayUpIconTexture:Texture;
	private var playPauseButtonPlayDownIconTexture:Texture;
	private var playPauseButtonPauseUpIconTexture:Texture;
	private var playPauseButtonPauseDownIconTexture:Texture;
	private var overlayPlayPauseButtonPlayUpIconTexture:Texture;
	private var overlayPlayPauseButtonPlayDownIconTexture:Texture;
	private var fullScreenToggleButtonEnterUpIconTexture:Texture;
	private var fullScreenToggleButtonEnterDownIconTexture:Texture;
	private var fullScreenToggleButtonExitUpIconTexture:Texture;
	private var fullScreenToggleButtonExitDownIconTexture:Texture;
	private var muteToggleButtonLoudUpIconTexture:Texture;
	private var muteToggleButtonLoudDownIconTexture:Texture;
	private var muteToggleButtonMutedUpIconTexture:Texture;
	private var muteToggleButtonMutedDownIconTexture:Texture;
	private var volumeSliderMinimumTrackSkinTexture:Texture;
	private var volumeSliderMaximumTrackSkinTexture:Texture;

	/**
	 * Disposes the atlas before calling super.dispose()
	 */
	override public function dispose():Void
	{
		if(this.atlas != null)
		{
			//these are saved globally, so we want to clear them out
			if(StandardIcons.listDrillDownAccessoryTexture.root == this.atlas.texture.root)
			{
				StandardIcons.listDrillDownAccessoryTexture = null;
			}
			
			//if anything is keeping a reference to the texture, we don't
			//want it to keep a reference to the theme too.
			this.atlas.texture.root.onRestore = null;
			
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
	}

	/**
	 * Initializes the scale value based on the screen density and content
	 * scale factor.
	 */
	private function initializeScale():Void
	{
		var starling:Starling = Starling.current;
		var nativeScaleFactor:Float = 1;
		#if flash
		if(starling.supportHighResolutions)
		{
			nativeScaleFactor = starling.nativeStage.contentsScaleFactor; 
		}
		#end
		var scaledDPI:Int = Std.int(DeviceCapabilities.dpi / (starling.contentScaleFactor / nativeScaleFactor));
		this._originalDPI = scaledDPI;
		if(this._scaleToDPI)
		{
			if(DeviceCapabilities.isTablet(starling.nativeStage))
			{
				this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
			}
			else
			{
				this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
			}
		}
		this.scale = scaledDPI / this._originalDPI;
		this.stageTextScale = this.scale / nativeScaleFactor;
	}

	/**
	 * Initializes common values used for setting the dimensions of components.
	 */
	private function initializeDimensions():Void
	{
		this.gridSize = Math.round(88 * this.scale);
		this.smallGutterSize = Math.round(11 * this.scale);
		this.gutterSize = Math.round(22 * this.scale);
		this.controlSize = Math.round(58 * this.scale);
		this.smallControlSize = Math.round(22 * this.scale);
		this.popUpFillSize = Math.round(552 * this.scale);
		this.calloutBackgroundMinSize = Math.round(11 * this.scale);
		this.scrollBarGutterSize = Math.round(4 * this.scale);
		this.wideControlSize = this.gridSize * 3 + this.gutterSize * 2;
	}

	/**
	 * Initializes font sizes and formats.
	 */
	private function initializeFonts():Void
	{
		this.smallFontSize = Math.round(18 * this.scale);
		this.regularFontSize = Math.round(24 * this.scale);
		this.largeFontSize = Math.round(28 * this.scale);
		this.extraLargeFontSize = Math.round(36 * this.scale);
		this.inputFontSize = Math.round(24 * this.stageTextScale);
		
		var font:Font = Assets.getFont(FONT_FILE_NAME);
		var boldFont:Font = Assets.getFont(BOLD_FONT_FILE_NAME);

		//these are for components that don't use FTE
		this.scrollTextTextFormat = new TextFormat(#if flash "_sans" #else font.fontName #end, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.scrollTextDisabledTextFormat = new TextFormat(#if flash "_sans" #else font.fontName #end, this.regularFontSize, DISABLED_TEXT_COLOR);
#if flash
		this.regularFontDescription = new FontDescription(FONT_NAME, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
		this.boldFontDescription = new FontDescription(FONT_NAME, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);

		this.headerElementFormat = new ElementFormat(this.boldFontDescription, this.extraLargeFontSize, LIGHT_TEXT_COLOR);

		this.darkUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.selectedUIElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, SELECTED_TEXT_COLOR);
		this.lightUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);
		this.darkUIDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.regularFontSize, DARK_DISABLED_TEXT_COLOR);

		this.largeUIDarkElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DARK_TEXT_COLOR);
		this.largeUILightElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, LIGHT_TEXT_COLOR);
		this.largeUISelectedElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, SELECTED_TEXT_COLOR);
		this.largeUIDarkDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DARK_DISABLED_TEXT_COLOR);
		this.largeUILightDisabledElementFormat = new ElementFormat(this.boldFontDescription, this.largeFontSize, DISABLED_TEXT_COLOR);

		this.darkElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.disabledElementFormat = new ElementFormat(this.regularFontDescription, this.regularFontSize, DISABLED_TEXT_COLOR);

		this.smallLightElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, LIGHT_TEXT_COLOR);
		this.smallDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.smallFontSize, DISABLED_TEXT_COLOR);

		this.largeDarkElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, DARK_TEXT_COLOR);
		this.largeLightElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, LIGHT_TEXT_COLOR);
		this.largeDisabledElementFormat = new ElementFormat(this.regularFontDescription, this.largeFontSize, DISABLED_TEXT_COLOR);
#else

		this.headerElementFormat = new TextFormat(boldFont.fontName, this.extraLargeFontSize, LIGHT_TEXT_COLOR, null, null, null);

		this.darkUIElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightUIElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.selectedUIElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, SELECTED_TEXT_COLOR);
		this.lightUIDisabledElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, DISABLED_TEXT_COLOR);
		this.darkUIDisabledElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, DARK_DISABLED_TEXT_COLOR);

		this.largeUIDarkElementFormat = new TextFormat(boldFont.fontName, this.largeFontSize, DARK_TEXT_COLOR);
		this.largeUILightElementFormat = new TextFormat(boldFont.fontName, this.largeFontSize, LIGHT_TEXT_COLOR);
		this.largeUISelectedElementFormat = new TextFormat(boldFont.fontName, this.largeFontSize, SELECTED_TEXT_COLOR);
		this.largeUIDarkDisabledElementFormat = new TextFormat(boldFont.fontName, this.largeFontSize, DARK_DISABLED_TEXT_COLOR);
		this.largeUILightDisabledElementFormat = new TextFormat(boldFont.fontName, this.largeFontSize, DISABLED_TEXT_COLOR);

		this.darkElementFormat = new TextFormat(font.fontName, this.regularFontSize, DARK_TEXT_COLOR);
		this.lightElementFormat = new TextFormat(font.fontName, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.disabledElementFormat = new TextFormat(font.fontName, this.regularFontSize, DISABLED_TEXT_COLOR);

		this.smallLightElementFormat = new TextFormat(font.fontName, this.smallFontSize, LIGHT_TEXT_COLOR);
		this.smallDisabledElementFormat = new TextFormat(font.fontName, this.smallFontSize, DISABLED_TEXT_COLOR);

		this.largeDarkElementFormat = new TextFormat(font.fontName, this.largeFontSize, DARK_TEXT_COLOR);
		this.largeLightElementFormat = new TextFormat(font.fontName, this.largeFontSize, LIGHT_TEXT_COLOR);
		this.largeDisabledElementFormat = new TextFormat(font.fontName, this.largeFontSize, DISABLED_TEXT_COLOR);
		
		this.lightUICenterElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, LIGHT_TEXT_COLOR);
		this.lightUICenterElementFormat.align = TextFormatAlign.CENTER;
		this.lightUICenterDisabledElementFormat = new TextFormat(boldFont.fontName, this.regularFontSize, DISABLED_TEXT_COLOR);
		this.lightUICenterDisabledElementFormat.align = TextFormatAlign.CENTER;
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
		var backgroundDownSkinTexture:Texture = this.atlas.getTexture("background-down-skin");
		var backgroundDisabledSkinTexture:Texture = this.atlas.getTexture("background-disabled-skin");
		var backgroundFocusedSkinTexture:Texture = this.atlas.getTexture("background-focused-skin");
		var backgroundPopUpSkinTexture:Texture = this.atlas.getTexture("background-popup-skin");

		this.backgroundSkinTextures = new Scale9Textures(backgroundSkinTexture, DEFAULT_SCALE9_GRID);
		this.backgroundInsetSkinTextures = new Scale9Textures(backgroundInsetSkinTexture, DEFAULT_SCALE9_GRID);
		this.backgroundDisabledSkinTextures = new Scale9Textures(backgroundDisabledSkinTexture, DEFAULT_SCALE9_GRID);
		this.backgroundFocusedSkinTextures = new Scale9Textures(backgroundFocusedSkinTexture, DEFAULT_SCALE9_GRID);
		this.backgroundPopUpSkinTextures = new Scale9Textures(backgroundPopUpSkinTexture, DEFAULT_SCALE9_GRID);

		this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE9_GRID);
		this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_SCALE9_GRID);
		this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE9_GRID);
		this.buttonSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-up-skin"), BUTTON_SELECTED_SCALE9_GRID);
		this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), BUTTON_SELECTED_SCALE9_GRID);
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

		this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE9_GRID);
		this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"), TAB_SCALE9_GRID);
		this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE9_GRID);

		this.pickerListButtonIconTexture = this.atlas.getTexture("picker-list-icon");
		this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-icon-disabled");
		this.pickerListItemSelectedIconTexture = this.atlas.getTexture("picker-list-item-selected-icon");

		this.spinnerListSelectionOverlaySkinTextures = new Scale9Textures(this.atlas.getTexture("spinner-list-selection-overlay-skin"), SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID);

		this.radioUpIconTexture = backgroundSkinTexture;
		this.radioDownIconTexture = backgroundDownSkinTexture;
		this.radioDisabledIconTexture = backgroundDisabledSkinTexture;
		this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon");
		this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon");
		this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

		this.checkUpIconTexture = backgroundSkinTexture;
		this.checkDownIconTexture = backgroundDownSkinTexture;
		this.checkDisabledIconTexture = backgroundDisabledSkinTexture;
		this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon");
		this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon");
		this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

		this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");
		this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");

		this.searchIconTexture = this.atlas.getTexture("search-icon");
		this.searchIconDisabledTexture = this.atlas.getTexture("search-icon-disabled");

		this.itemRendererUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-item-up-skin"), ITEM_RENDERER_SCALE9_GRID);
		this.itemRendererSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-item-selected-skin"), ITEM_RENDERER_SCALE9_GRID);
		this.insetItemRendererFirstUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-first-up-skin"), INSET_ITEM_RENDERER_FIRST_SCALE9_GRID);
		this.insetItemRendererFirstSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-first-selected-skin"), INSET_ITEM_RENDERER_FIRST_SCALE9_GRID);
		this.insetItemRendererLastUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-last-up-skin"), INSET_ITEM_RENDERER_LAST_SCALE9_GRID);
		this.insetItemRendererLastSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-last-selected-skin"), INSET_ITEM_RENDERER_LAST_SCALE9_GRID);
		this.insetItemRendererSingleUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-single-up-skin"), INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID);
		this.insetItemRendererSingleSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-single-selected-skin"), INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID);

		this.headerBackgroundSkinTexture = this.atlas.getTexture("header-background-skin");

		this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top-skin");
		this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right-skin");
		this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom-skin");
		this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left-skin");

		this.horizontalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.verticalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_VERTICAL);

		StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");

		this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon");
		this.playPauseButtonPlayDownIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-down-icon");
		this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon");
		this.playPauseButtonPauseDownIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-down-icon");
		this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon");
		this.overlayPlayPauseButtonPlayDownIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-down-icon");
		this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon");
		this.fullScreenToggleButtonEnterDownIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-down-icon");
		this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon");
		this.fullScreenToggleButtonExitDownIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-down-icon");
		this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon");
		this.muteToggleButtonMutedDownIconTexture = this.atlas.getTexture("mute-toggle-button-muted-down-icon");
		this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon");
		this.muteToggleButtonLoudDownIconTexture = this.atlas.getTexture("mute-toggle-button-loud-down-icon");
		this.volumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("volume-slider-minimum-track-skin");
		this.volumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("volume-slider-maximum-track-skin");
	}

	/**
	 * Sets global style providers for all components.
	 */
	private function initializeStyleProviders():Void
	{
		//alert
		this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
		this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON, this.setAlertButtonGroupButtonStyles);
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setHeaderWithoutBackgroundStyles);
		#if flash
		this.getStyleProviderForClass(TextBlockTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);
		#else
		this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);
		#end

		//button
		this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, this.setBackButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

		//button group
		this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setButtonGroupButtonStyles);

		//callout
		this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

		//check
		this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

		//drawers
		this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

		//grouped list (see also: item renderers)
		this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
		this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

		//header
		this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

		//header and footer renderers for grouped list
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER, this.setGroupedListFooterRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListFooterRendererStyles);

		//item renderers for lists
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		//the picker list has a custom item renderer name defined by the theme
		this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_PICKER_LIST_ITEM_RENDERER, this.setPickerListItemRendererStyles);
		//the spinner list has a custom item renderer name defined by the theme
		this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER, this.setSpinnerListItemRendererStyles);
		this.getStyleProviderForClass(#if flash TextBlockTextRenderer #else TextFieldTextRenderer #end).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelRendererStyles);
		this.getStyleProviderForClass(#if flash TextBlockTextRenderer #else TextFieldTextRenderer #end).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER, this.setInsetGroupedListMiddleItemRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER, this.setInsetGroupedListFirstItemRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER, this.setInsetGroupedListLastItemRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER, this.setInsetGroupedListSingleItemRendererStyles);

		//labels
		this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);

		//layout group
		this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, setToolbarLayoutGroupStyles);

		//list (see also: item renderers)
		this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

		//numeric stepper
		this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
		this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);

		//page indicator
		this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

		//panel
		this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setHeaderWithoutBackgroundStyles);

		//panel screen
		this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
		this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelScreenHeaderStyles);

		//picker list (see also: list and item renderers)
		this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);

		//progress bar
		this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

		//radio
		this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

		//scroll container
		this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
		this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);
		
		//scroll screen
		this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

		//scroll text
		this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

		//simple scroll bar
		this.getStyleProviderForClass(SimpleScrollBar).defaultStyleFunction = this.setSimpleScrollBarStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);

		//slider
		this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK, this.setHorizontalSliderMaximumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK, this.setVerticalSliderMaximumTrackStyles);

		//spinner list
		this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;

		//tab bar
		this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

		//text input
		this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
		this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

		//text area
		this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

		//toggle button
		this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

		//toggle switch
		this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleButtonStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchTrackStyles);
		//we don't need a style function for the off track in this theme
		//the toggle switch layout uses a single track
		
		//media controls
		
		//play/pause toggle button
		this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
		this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON, this.setOverlayPlayPauseToggleButtonStyles);

		//full screen toggle button
		this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;

		//mute toggle button
		this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;

		//seek slider
		this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSeekSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setSeekSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setSeekSliderMaximumTrackStyles);

		//volume slider
		this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setVolumeSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setVolumeSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setVolumeSliderMaximumTrackStyles);
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
	}

	private function setSimpleButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			//textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		button.hasLabelTextRenderer = false;

		button.minWidth = button.minHeight = this.controlSize;
		button.minTouchWidth = button.minTouchHeight = this.gridSize;
	}

//-------------------------
// Alert
//-------------------------
	private function setAlertStyles(alert:Alert):Void
	{
		this.setScrollerStyles(alert);

		var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);
		alert.backgroundSkin = backgroundSkin;

		alert.paddingTop = 0;
		alert.paddingRight = this.gutterSize;
		alert.paddingBottom = this.smallGutterSize;
		alert.paddingLeft = this.gutterSize;
		alert.gap = this.smallGutterSize;
		alert.maxWidth = this.popUpFillSize;
		alert.maxHeight = this.popUpFillSize;
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
		group.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
	}

	private function setAlertButtonGroupButtonStyles(button:Button):Void
	{
		this.setButtonStyles(button);
		button.minWidth = 2 * this.controlSize;
	}

	private function setAlertMessageTextRendererStyles(renderer:#if flash TextBlockTextRenderer #else TextFieldTextRenderer #end):Void
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
		button.paddingTop = this.smallGutterSize;
		button.paddingBottom = this.smallGutterSize;
		button.paddingLeft = this.gutterSize;
		button.paddingRight = this.gutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = button.minHeight = this.controlSize;
		button.minTouchWidth = this.gridSize;
		button.minTouchHeight = this.gridSize;
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
			//textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
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
			//textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
	}

	private function setQuietButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
 
		if(Std.is(button, ToggleButton))
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
		}
		skinSelector.displayObjectProperties.storage =
		{
			width: this.controlSize,
			height: this.controlSize,
			//textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		button.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		button.downLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIElementFormat);
		button.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);

		if(Std.is(button, ToggleButton))
		{
			var toggleButton:ToggleButton = cast(button, ToggleButton);
			toggleButton.defaultSelectedLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIElementFormat);
			toggleButton.selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIDisabledElementFormat);
		}
		button.paddingTop = button.paddingBottom = this.smallGutterSize;
		button.paddingLeft = button.paddingRight = this.gutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = button.minHeight = this.controlSize;
		button.minTouchWidth = button.minTouchHeight = this.gridSize;
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
			//textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
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
			//textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.paddingLeft = this.gutterSize + this.smallGutterSize;
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
			//textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.paddingRight = this.gutterSize + this.smallGutterSize;
	}

//-------------------------
// ButtonGroup
//-------------------------

	private function setButtonGroupStyles(group:ButtonGroup):Void
	{
		group.minWidth = this.popUpFillSize;
		group.gap = this.smallGutterSize;
	}
	private function setButtonGroupButtonStyles(button:Button):Void
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
			width: this.gridSize,
			height: this.gridSize,
			//textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		button.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeUIDarkElementFormat);
		button.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeUIDarkDisabledElementFormat);

		if(Std.is(button, ToggleButton))
		{
			cast(button, ToggleButton).selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeUIDarkDisabledElementFormat);
		}
		button.paddingTop = this.smallGutterSize;
		button.paddingBottom = this.smallGutterSize;
		button.paddingLeft = this.gutterSize;
		button.paddingRight = this.gutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.gridSize;
		button.minHeight = this.gridSize;
		button.minTouchWidth = this.gridSize;
		button.minTouchHeight = this.gridSize;
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

		var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
		rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
		callout.rightArrowSkin = rightArrowSkin;

		var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
		bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
		callout.bottomArrowSkin = bottomArrowSkin;

		var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
		leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
		callout.leftArrowSkin = leftArrowSkin;

		callout.padding = this.smallGutterSize;
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

		check.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		check.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		check.selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);

		check.horizontalAlign = Check.HORIZONTAL_ALIGN_LEFT;
		check.gap = this.smallGutterSize;
		check.minWidth = this.controlSize;
		check.minHeight = this.controlSize;
		check.minTouchWidth = this.gridSize;
		check.minTouchHeight = this.gridSize;
	}
//-------------------------
// Drawers
//-------------------------

	private function setDrawersStyles(drawers:Drawers):Void
	{
		var overlaySkin:Quad = new Quad(10, 10, DRAWER_OVERLAY_COLOR);
		overlaySkin.alpha = DRAWER_OVERLAY_ALPHA;
		drawers.overlaySkin = overlaySkin;
	}
//-------------------------
// GroupedList
//-------------------------

	private function setGroupedListStyles(list:GroupedList):Void
	{
		this.setScrollerStyles(list);
		var backgroundSkin:Quad = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
		list.backgroundSkin = backgroundSkin;
	}

	//see List section for item renderer styles

	private function setGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.backgroundSkin = new Quad(1, 1, GROUPED_LIST_HEADER_BACKGROUND_COLOR);

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
		renderer.contentLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		renderer.contentLabelProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.smallGutterSize + this.gutterSize;
		renderer.paddingRight = this.gutterSize;

		renderer.contentLoaderFactory = this.imageLoaderFactory;
	}

	private function setGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.backgroundSkin = new Quad(1, 1, GROUPED_LIST_FOOTER_BACKGROUND_COLOR);

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
		renderer.contentLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
		renderer.contentLabelProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.disabledElementFormat);
		renderer.paddingTop = renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.smallGutterSize + this.gutterSize;
		renderer.paddingRight = this.gutterSize;

		renderer.contentLoaderFactory = this.imageLoaderFactory;
	}

	private function setInsetGroupedListStyles(list:GroupedList):Void
	{
		list.customItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER;
		list.customFirstItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER;
		list.customLastItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER;
		list.customSingleItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER;
		list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
		list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;

		var layout:VerticalLayout = new VerticalLayout();
		layout.useVirtualLayout = true;
		layout.padding = this.smallGutterSize;
		layout.gap = 0;
		layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
		layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
		list.layout = layout;
	}

	private function setInsetGroupedListItemRendererStyles(renderer:DefaultGroupedListItemRenderer, defaultSkinTextures:Scale9Textures, selectedAndDownSkinTextures:Scale9Textures):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = defaultSkinTextures;
		skinSelector.defaultSelectedValue = selectedAndDownSkinTextures;
		skinSelector.setValueForState(selectedAndDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.gridSize,
			height: this.gridSize,
			//textureScale: this.scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		renderer.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeLightElementFormat);
		renderer.downLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDarkElementFormat);
		renderer.defaultSelectedLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDarkElementFormat);
		renderer.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDisabledElementFormat);

		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize + this.smallGutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.gap = this.gutterSize;
		renderer.minGap = this.gutterSize;
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.gutterSize;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		renderer.minWidth = renderer.minHeight = this.gridSize;
		renderer.minTouchWidth = renderer.minTouchHeight = this.gridSize;

		renderer.accessoryLoaderFactory = this.imageLoaderFactory;
		renderer.iconLoaderFactory = this.imageLoaderFactory;
	}

	private function setInsetGroupedListMiddleItemRendererStyles(renderer:DefaultGroupedListItemRenderer):Void
	{
		this.setInsetGroupedListItemRendererStyles(renderer, this.itemRendererUpSkinTextures, this.itemRendererSelectedSkinTextures);
	}

	private function setInsetGroupedListFirstItemRendererStyles(renderer:DefaultGroupedListItemRenderer):Void
	{
		this.setInsetGroupedListItemRendererStyles(renderer, this.insetItemRendererFirstUpSkinTextures, this.insetItemRendererFirstSelectedSkinTextures);
	}

	private function setInsetGroupedListLastItemRendererStyles(renderer:DefaultGroupedListItemRenderer):Void
	{
		this.setInsetGroupedListItemRendererStyles(renderer, this.insetItemRendererLastUpSkinTextures, this.insetItemRendererLastSelectedSkinTextures);
	}

	private function setInsetGroupedListSingleItemRendererStyles(renderer:DefaultGroupedListItemRenderer):Void
	{
		this.setInsetGroupedListItemRendererStyles(renderer, this.insetItemRendererSingleUpSkinTextures, this.insetItemRendererSingleSelectedSkinTextures);
	}

	private function setInsetGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		var defaultSkin:Quad = new Quad(1, 1, 0xff00ff);
		defaultSkin.alpha = 0;
		renderer.backgroundSkin = defaultSkin;

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
		renderer.contentLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		renderer.contentLabelProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize + this.smallGutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;

		renderer.contentLoaderFactory = this.imageLoaderFactory;
	}

	private function setInsetGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		var defaultSkin:Quad = new Quad(1, 1, 0xff00ff);
		defaultSkin.alpha = 0;
		renderer.backgroundSkin = defaultSkin;

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
		renderer.contentLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightElementFormat);
		renderer.contentLabelProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.disabledElementFormat);
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize + this.smallGutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;

		renderer.contentLoaderFactory = this.imageLoaderFactory;
	}
//-------------------------
// Header
//-------------------------

	private function setHeaderStyles(header:Header):Void
	{
		header.minWidth = this.gridSize;
		header.minHeight = this.gridSize;
		header.padding = this.smallGutterSize;
		header.gap = this.smallGutterSize;
		header.titleGap = this.smallGutterSize;

		var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
		header.backgroundSkin = backgroundSkin;
		header.titleProperties.setProperty(ELEMENT_FORMAT_STR, this.headerElementFormat);
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
// LayoutGroup
//-------------------------

	private function setToolbarLayoutGroupStyles(group:LayoutGroup):Void
	{
		if(group.layout == null)
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.padding = this.smallGutterSize;
			layout.gap = this.smallGutterSize;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			group.layout = layout;
		}
		group.minWidth = this.gridSize;
		group.minHeight = this.gridSize;

		var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
		backgroundSkin.width = backgroundSkin.height = this.gridSize;
		group.backgroundSkin = backgroundSkin;
	}

//-------------------------
// List
//-------------------------

	private function setListStyles(list:List):Void
	{
		this.setScrollerStyles(list);
		var backgroundSkin:Quad = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
		list.backgroundSkin = backgroundSkin;
	}

	private function setItemRendererStyles(renderer:BaseDefaultItemRenderer):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.itemRendererUpSkinTextures;
		skinSelector.defaultSelectedValue = this.itemRendererSelectedSkinTextures;
		skinSelector.setValueForState(this.itemRendererSelectedSkinTextures, Button.STATE_DOWN, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.gridSize,
			height: this.gridSize,
			//textureScale: this.scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		renderer.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeLightElementFormat);
		renderer.downLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDarkElementFormat);
		renderer.defaultSelectedLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDarkElementFormat);
		renderer.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDisabledElementFormat);

		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.gap = this.gutterSize;
		renderer.minGap = this.gutterSize;
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.gutterSize;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		renderer.minWidth = this.gridSize;
		renderer.minHeight = this.gridSize;
		renderer.minTouchWidth = this.gridSize;
		renderer.minTouchHeight = this.gridSize;

		renderer.accessoryLoaderFactory = this.imageLoaderFactory;
		renderer.iconLoaderFactory = this.imageLoaderFactory;
	}

	private function setItemRendererAccessoryLabelRendererStyles(renderer:#if flash TextBlockTextRenderer #else TextFieldTextRenderer #end):Void
	{
		#if flash
		renderer.elementFormat = this.lightElementFormat;
		#else
		renderer.textFormat = this.lightElementFormat;
		#end
	}

	private function setItemRendererIconLabelStyles(renderer:#if flash TextBlockTextRenderer #else TextFieldTextRenderer #end):Void
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
		stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL;
		stepper.incrementButtonLabel = "+";
		stepper.decrementButtonLabel = "-";
	}

	private function setNumericStepperTextInputStyles(input:TextInput):Void
	{
		var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
		backgroundSkin.width = this.controlSize;
		backgroundSkin.height = this.controlSize;
		input.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
		backgroundDisabledSkin.width = this.controlSize;
		backgroundDisabledSkin.height = this.controlSize;
		input.backgroundDisabledSkin = backgroundDisabledSkin;

		var backgroundFocusedSkin:Scale9Image = new Scale9Image(this.backgroundFocusedSkinTextures, this.scale);
		backgroundFocusedSkin.width = this.controlSize;
		backgroundFocusedSkin.height = this.controlSize;
		input.backgroundFocusedSkin = backgroundFocusedSkin;

		input.minWidth = input.minHeight = this.controlSize;
		input.minTouchWidth = input.minTouchHeight = this.gridSize;
		input.gap = this.smallGutterSize;
		input.padding = this.smallGutterSize;
		input.isEditable = false;
		input.textEditorFactory = stepperTextEditorFactory;
		#if flash
		input.textEditorProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		input.textEditorProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		#else
		input.textEditorProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUICenterElementFormat);
		input.textEditorProperties.setProperty(DISABLED_ELEMENT_FORMAT_STR, this.lightUICenterDisabledElementFormat);
		#end
		#if flash
		input.textEditorProperties.setProperty("textAlign", TextBlockTextEditor.TEXT_ALIGN_CENTER);
		#end
	}
	private function setNumericStepperButtonStyles(button:Button):Void
	{
		this.setButtonStyles(button);
		button.keepDownStateOnRollOut = true;
	}

//-------------------------
// PageIndicator
//-------------------------

	private function setPageIndicatorStyles(pageIndicator:PageIndicator):Void
	{
		pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
		pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
		pageIndicator.gap = this.smallGutterSize;
		pageIndicator.padding = this.smallGutterSize;
		pageIndicator.minTouchWidth = this.smallControlSize * 2;
		pageIndicator.minTouchHeight = this.smallControlSize * 2;
	}
//-------------------------
// Panel
//-------------------------

	private function setPanelStyles(panel:Panel):Void
	{
		this.setScrollerStyles(panel);

		panel.backgroundSkin = new Scale9Image(this.backgroundPopUpSkinTextures, this.scale);

		panel.paddingTop = 0;
		panel.paddingRight = this.smallGutterSize;
		panel.paddingBottom = this.smallGutterSize;
		panel.paddingLeft = this.smallGutterSize;
	}

	private function setHeaderWithoutBackgroundStyles(header:Header):Void
	{
		header.minWidth = this.gridSize;
		header.minHeight = this.gridSize;
		header.padding = this.smallGutterSize;
		header.gap = this.smallGutterSize;
		header.titleGap = this.smallGutterSize;

		header.titleProperties.setProperty(ELEMENT_FORMAT_STR, this.headerElementFormat);
	}

//-------------------------
// PanelScreen
//-------------------------
	
	private function setPanelScreenStyles(screen:PanelScreen):Void
	{
		this.setScrollerStyles(screen);
	}

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
		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			list.popUpContentManager = new CalloutPopUpContentManager();
		}
		else
		{
			var centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
			centerStage.marginTop = centerStage.marginRight = centerStage.marginBottom =
				centerStage.marginLeft = this.gutterSize;
			list.popUpContentManager = centerStage;
		}

		var layout:VerticalLayout = new VerticalLayout();
		layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
		layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
		layout.useVirtualLayout = true;
		layout.gap = 0;
		layout.padding = 0;
		list.listProperties.setProperty("layout", layout);
		list.listProperties.setProperty("verticalScrollPolicy", List.SCROLL_POLICY_ON);

		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			list.listProperties.setProperty("minWidth", this.popUpFillSize);
			list.listProperties.setProperty("maxHeight", this.popUpFillSize);
		}
		else
		{
			var backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			list.listProperties.setProperty("backgroundSkin", backgroundSkin);
			list.listProperties.setProperty("padding", this.smallGutterSize);
		}

		list.listProperties.setProperty("customItemRendererStyleName", THEME_STYLE_NAME_PICKER_LIST_ITEM_RENDERER);
	}

	private function setPickerListButtonStyles(button:Button):Void
	{
		this.setButtonStyles(button);

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.pickerListButtonIconTexture;
		iconSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, false);
		iconSelector.displayObjectProperties.storage =
		{
			textureScale: this.scale,
			snapToPixels: true
		}
		button.stateToIconFunction = iconSelector.updateValue;

		button.gap = Math.POSITIVE_INFINITY;
		button.minGap = this.gutterSize;
		button.iconPosition = Button.ICON_POSITION_RIGHT;
	}

	private function setPickerListItemRendererStyles(renderer:BaseDefaultItemRenderer):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.itemRendererUpSkinTextures;
		skinSelector.setValueForState(this.itemRendererSelectedSkinTextures, Button.STATE_DOWN, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.gridSize,
			height: this.gridSize,
			//textureScale: this.scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		var defaultSelectedIcon:Image = new Image(this.pickerListItemSelectedIconTexture);
		defaultSelectedIcon.scaleX = defaultSelectedIcon.scaleY = this.scale;
		renderer.defaultSelectedIcon = defaultSelectedIcon;

		var defaultIcon:Quad = new Quad(defaultSelectedIcon.width, defaultSelectedIcon.height, 0xff00ff);
		defaultIcon.alpha = 0;
		renderer.defaultIcon = defaultIcon;

		renderer.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeLightElementFormat);
		renderer.downLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDarkElementFormat);
		renderer.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDisabledElementFormat);

		renderer.itemHasIcon = false;
		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.gap = Math.POSITIVE_INFINITY;
		renderer.minGap = this.gutterSize;
		renderer.iconPosition = Button.ICON_POSITION_RIGHT;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.gutterSize;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		renderer.minWidth = this.gridSize;
		renderer.minHeight = this.gridSize;
		renderer.minTouchWidth = this.gridSize;
		renderer.minTouchHeight = this.gridSize;
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
			fillSkin.height = this.smallControlSize;
		}
		else
		{
			fillSkin.width = this.smallControlSize;
			fillSkin.height = this.smallControlSize;
		}
		progress.fillSkin = fillSkin;

		var fillDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);
		if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
		{
			fillDisabledSkin.width = this.smallControlSize;
			fillDisabledSkin.height = this.smallControlSize;
		}
		else
		{
			fillDisabledSkin.width = this.smallControlSize;
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

		radio.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		radio.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		radio.selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);

		radio.horizontalAlign = Radio.HORIZONTAL_ALIGN_LEFT;
		radio.gap = this.smallGutterSize;
		radio.minWidth = this.controlSize;
		radio.minHeight = this.controlSize;
		radio.minTouchWidth = this.gridSize;
		radio.minTouchHeight = this.gridSize;
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
			layout.padding = this.smallGutterSize;
			layout.gap = this.smallGutterSize;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			container.layout = layout;
		}
		container.minWidth = this.gridSize;
		container.minHeight = this.gridSize;

		var backgroundSkin:TiledImage = new TiledImage(this.headerBackgroundSkinTexture, this.scale);
		backgroundSkin.width = backgroundSkin.height = this.gridSize;
		container.backgroundSkin = backgroundSkin;
	}

//-------------------------
// ScrollScreen
//-------------------------

	private function setScrollScreenStyles(screen:ScrollScreen):Void
	{
		this.setScrollerStyles(screen);
	}

//-------------------------
// ScrollText
//-------------------------

	private function setScrollTextStyles(text:ScrollText):Void
	{
		this.setScrollerStyles(text);

		text.textFormat = this.scrollTextTextFormat;
		text.disabledTextFormat = this.scrollTextDisabledTextFormat;
		text.padding = this.gutterSize;
		text.paddingRight = this.gutterSize + this.smallGutterSize;
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
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
		}
		else
		{
			scrollBar.paddingTop = this.scrollBarGutterSize;
			scrollBar.paddingRight = this.scrollBarGutterSize;
			scrollBar.paddingBottom = this.scrollBarGutterSize;
			scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
		}
	}
	private function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):Void
	{
		var defaultSkin:Scale3Image = new Scale3Image(this.horizontalScrollBarThumbSkinTextures, this.scale);
		defaultSkin.width = this.smallGutterSize;
		thumb.defaultSkin = defaultSkin;
		thumb.hasLabelTextRenderer = false;
	}

	private function setVerticalSimpleScrollBarThumbStyles(thumb:Button):Void
	{
		var defaultSkin:Scale3Image = new Scale3Image(this.verticalScrollBarThumbSkinTextures, this.scale);
		defaultSkin.height = this.smallGutterSize;
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
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
			slider.customMaximumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK;
			slider.minWidth = this.controlSize;
		}
		else //horizontal
		{
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
			slider.customMaximumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK;
			slider.minHeight = this.controlSize;
		}
	}

	private function setHorizontalSliderMinimumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			//textureScale: this.scale
		};
		skinSelector.displayObjectProperties.storage.width = this.wideControlSize;
		skinSelector.displayObjectProperties.storage.height = this.controlSize;
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
			//textureScale: this.scale
		};
		skinSelector.displayObjectProperties.storage.width = this.wideControlSize;
		skinSelector.displayObjectProperties.storage.height = this.controlSize;
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
			//textureScale: this.scale
		};
		skinSelector.displayObjectProperties.storage.width = this.controlSize;
		skinSelector.displayObjectProperties.storage.height = this.wideControlSize;
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
			//textureScale: this.scale
		};
		skinSelector.displayObjectProperties.storage.width = this.controlSize;
		skinSelector.displayObjectProperties.storage.height = this.wideControlSize;
		track.stateToSkinFunction = skinSelector.updateValue;
		track.hasLabelTextRenderer = false;
	}
	
//-------------------------
// SpinnerList
//-------------------------

	private function setSpinnerListStyles(list:SpinnerList):Void
	{
		this.setListStyles(list);
		list.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;
		list.selectionOverlaySkin = new Scale9Image(this.spinnerListSelectionOverlaySkinTextures, this.scale);
	}

	private function setSpinnerListItemRendererStyles(renderer:DefaultListItemRenderer):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.itemRendererUpSkinTextures;
		skinSelector.displayObjectProperties.storage =
		{
			width: this.gridSize,
			height: this.gridSize,
			textureScale: this.scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		renderer.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeLightElementFormat);
		renderer.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.largeDisabledElementFormat);

		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.gap = this.gutterSize;
		renderer.minGap = this.gutterSize;
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.gutterSize;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		renderer.minWidth = this.gridSize;
		renderer.minHeight = this.gridSize;
		renderer.minTouchWidth = this.gridSize;
		renderer.minTouchHeight = this.gridSize;

		renderer.accessoryLoaderFactory = this.imageLoaderFactory;
		renderer.iconLoaderFactory = this.imageLoaderFactory;
	}

//-------------------------
// TabBar
//-------------------------

	private function setTabBarStyles(tabBar:TabBar):Void
	{
		tabBar.distributeTabSizes = true;
	}

	private function setTabStyles(tab:ToggleButton):Void
	{
		var defaultSkin:Quad = new Quad(this.gridSize, this.gridSize, TAB_BACKGROUND_COLOR);
		tab.defaultSkin = defaultSkin;

		var downSkin:Scale9Image = new Scale9Image(this.tabDownSkinTextures, this.scale);
		tab.downSkin = downSkin;

		var defaultSelectedSkin:Scale9Image = new Scale9Image(this.tabSelectedSkinTextures, this.scale);
		tab.defaultSelectedSkin = defaultSelectedSkin;

		var disabledSkin:Quad = new Quad(this.gridSize, this.gridSize, TAB_DISABLED_BACKGROUND_COLOR);
		tab.disabledSkin = disabledSkin;

		var selectedDisabledSkin:Scale9Image = new Scale9Image(this.tabSelectedDisabledSkinTextures, this.scale);
		tab.selectedDisabledSkin = selectedDisabledSkin;

		tab.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		tab.defaultSelectedLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIElementFormat);
		tab.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
		tab.selectedDisabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.darkUIDisabledElementFormat);

		tab.paddingTop = this.smallGutterSize;
		tab.paddingBottom = this.smallGutterSize;
		tab.paddingLeft = this.gutterSize;
		tab.paddingRight = this.gutterSize;
		tab.gap = this.smallGutterSize;
		tab.minGap = this.smallGutterSize;
		tab.minWidth = tab.minHeight = this.gridSize;
		tab.minTouchWidth = tab.minTouchHeight = this.gridSize;
	}
//-------------------------
// TextArea
//-------------------------

	private function setTextAreaStyles(textArea:TextArea):Void
	{
		this.setScrollerStyles(textArea);

		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundInsetSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextArea.STATE_DISABLED);
		skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextArea.STATE_FOCUSED);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.wideControlSize,
			height: this.wideControlSize,
			//textureScale: this.scale
		};
		textArea.stateToSkinFunction = skinSelector.updateValue;

		textArea.textEditorProperties.setProperty("textFormat", this.scrollTextTextFormat);
		textArea.textEditorProperties.setProperty("disabledTextFormat", this.scrollTextDisabledTextFormat);
		textArea.textEditorProperties.setProperty("padding", this.smallGutterSize);
	}
	
//-------------------------
// TextInput
//-------------------------

	private function setBaseTextInputStyles(input:TextInput):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundInsetSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
		skinSelector.setValueForState(this.backgroundFocusedSkinTextures, TextInput.STATE_FOCUSED);
		skinSelector.displayObjectProperties.storage =
		{
			width: this.wideControlSize,
			height: this.controlSize,
			//textureScale: this.scale
		};
		input.stateToSkinFunction = skinSelector.updateValue;

		input.minWidth = this.controlSize;
		input.minHeight = this.controlSize;
		input.minTouchWidth = this.gridSize;
		input.minTouchHeight = this.gridSize;
		input.gap = this.smallGutterSize;
		input.padding = this.smallGutterSize;

		input.textEditorProperties.setProperty("fontFamily", "Helvetica");
		input.textEditorProperties.setProperty("fontSize", this.inputFontSize);
		input.textEditorProperties.setProperty("color", LIGHT_TEXT_COLOR);
		input.textEditorProperties.setProperty("disabledColor", DISABLED_TEXT_COLOR);

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
			//textureScale: this.scale,
			snapToPixels: true
		}
		input.stateToIconFunction = iconSelector.updateValue;
	}
//-------------------------
// ToggleSwitch
//-------------------------

	private function setToggleSwitchStyles(toggle:ToggleSwitch):Void
	{
		toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

		toggle.defaultLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIElementFormat);
		toggle.onLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.selectedUIElementFormat);
		toggle.disabledLabelProperties.setProperty(ELEMENT_FORMAT_STR, this.lightUIDisabledElementFormat);
	}
	//see Shared section for thumb styles

	private function setToggleSwitchTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.backgroundSkinTextures;
		skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties.storage =
		{
			width: Math.round(this.controlSize * 2.5),
			height: this.controlSize,
			//textureScale: this.scale
		};
		track.stateToSkinFunction = skinSelector.updateValue;
		track.hasLabelTextRenderer = false;
	}
	
//-------------------------
// PlayPauseToggleButton
//-------------------------
	
	private function setPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.defaultValue = this.playPauseButtonPlayUpIconTexture;
		iconSelector.defaultSelectedValue = this.playPauseButtonPauseUpIconTexture;
		iconSelector.setValueForState(this.playPauseButtonPlayDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.setValueForState(this.playPauseButtonPauseDownIconTexture, Button.STATE_DOWN, true);
		iconSelector.displayObjectProperties.storage =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.hasLabelTextRenderer = false;

		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
		button.minTouchWidth = this.gridSize;
		button.minTouchHeight = this.gridSize;
	}

	private function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayUpIconTexture, Button.STATE_UP, false);
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayUpIconTexture, Button.STATE_HOVER, false);
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.displayObjectProperties.storage =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.hasLabelTextRenderer = false;
		
		var overlaySkin:Quad = new Quad(1, 1, VIDEO_OVERLAY_COLOR);
		overlaySkin.alpha = VIDEO_OVERLAY_ALPHA;
		button.upSkin = overlaySkin;
		button.hoverSkin = overlaySkin;
	}

//-------------------------
// FullScreenToggleButton
//-------------------------

	private function setFullScreenToggleButtonStyles(button:FullScreenToggleButton):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.defaultValue = this.fullScreenToggleButtonEnterUpIconTexture;
		iconSelector.defaultSelectedValue = this.fullScreenToggleButtonExitUpIconTexture;
		iconSelector.setValueForState(this.fullScreenToggleButtonEnterDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.setValueForState(this.fullScreenToggleButtonExitDownIconTexture, Button.STATE_DOWN, true);
		iconSelector.displayObjectProperties.storage =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.hasLabelTextRenderer = false;

		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
		button.minTouchWidth = this.gridSize;
		button.minTouchHeight = this.gridSize;
	}

//-------------------------
// MuteToggleButton
//-------------------------

	private function setMuteToggleButtonStyles(button:MuteToggleButton):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.defaultValue = this.muteToggleButtonLoudUpIconTexture;
		iconSelector.defaultSelectedValue = this.muteToggleButtonMutedUpIconTexture;
		iconSelector.setValueForState(this.muteToggleButtonLoudDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.setValueForState(this.muteToggleButtonMutedDownIconTexture, Button.STATE_DOWN, true);
		iconSelector.displayObjectProperties.storage =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.hasLabelTextRenderer = false;
		button.showVolumeSliderOnHover = false;

		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
		button.minTouchWidth = this.gridSize;
		button.minTouchHeight = this.gridSize;
	}

//-------------------------
// SeekSlider
//-------------------------

	private function setSeekSliderStyles(slider:SeekSlider):Void
	{
		slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
		slider.showThumb = false;
		if(slider.direction == SeekSlider.DIRECTION_VERTICAL)
		{
			slider.minWidth = this.smallControlSize;
			slider.minHeight = this.controlSize;
		}
		else //horizontal
		{
			slider.minWidth = this.controlSize;
			slider.minHeight = this.smallControlSize;
		}
	}

	private function setSeekSliderThumbStyles(thumb:Button):Void
	{
		var thumbSize:Float = 6 * this.scale;
		thumb.defaultSkin = new Quad(thumbSize, thumbSize);
		thumb.hasLabelTextRenderer = false;
		thumb.minTouchWidth = this.gridSize;
		thumb.minTouchHeight = this.gridSize;
	}

	private function setSeekSliderMinimumTrackStyles(track:Button):Void
	{
		var defaultSkin:Scale9Image = new Scale9Image(this.buttonUpSkinTextures, this.scale);
		defaultSkin.width = this.wideControlSize;
		defaultSkin.height = this.smallControlSize;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
		track.minTouchHeight = this.gridSize;
	}

	private function setSeekSliderMaximumTrackStyles(track:Button):Void
	{
		var defaultSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
		defaultSkin.width = this.wideControlSize;
		defaultSkin.height = this.smallControlSize;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
		track.minTouchHeight = this.gridSize;
	}

//-------------------------
// VolumeSlider
//-------------------------

	private function setVolumeSliderStyles(slider:VolumeSlider):Void
	{
		slider.direction = VolumeSlider.DIRECTION_HORIZONTAL;
		slider.trackLayoutMode = VolumeSlider.TRACK_LAYOUT_MODE_MIN_MAX;
		slider.showThumb = false;
		slider.minWidth = this.volumeSliderMinimumTrackSkinTexture.width;
		slider.minHeight = this.volumeSliderMinimumTrackSkinTexture.height;
	}

	private function setVolumeSliderThumbStyles(thumb:Button):Void
	{
		var thumbSize:Float = 6 * this.scale;
		var defaultSkin:Quad = new Quad(thumbSize, thumbSize);
		defaultSkin.width = 0;
		defaultSkin.height = 0;
		thumb.defaultSkin = defaultSkin;
		thumb.hasLabelTextRenderer = false;
	}

	private function setVolumeSliderMinimumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.source = this.volumeSliderMinimumTrackSkinTexture;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
	}

	private function setVolumeSliderMaximumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.horizontalAlign = ImageLoader.HORIZONTAL_ALIGN_RIGHT;
		defaultSkin.source = this.volumeSliderMaximumTrackSkinTexture;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
	}

}
