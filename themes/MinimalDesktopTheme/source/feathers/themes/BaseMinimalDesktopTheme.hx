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
package feathers.themes
{
import feathers.controls.Alert;
import feathers.controls.AutoComplete;
import feathers.controls.Button;
import feathers.controls.ButtonGroup;
import feathers.controls.Callout;
import feathers.controls.Check;
import feathers.controls.Drawers;
import feathers.controls.GroupedList;
import feathers.controls.Header;
import feathers.controls.IScrollBar;
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
import feathers.core.FeathersControl;
import feathers.core.FocusManager;
import feathers.core.PopUpManager;
import feathers.display.Scale9Image;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import feathers.media.FullScreenToggleButton;
import feathers.media.MuteToggleButton;
import feathers.media.PlayPauseToggleButton;
import feathers.media.SeekSlider;
import feathers.media.VideoPlayer;
import feathers.media.VolumeSlider;
import feathers.skins.SmartDisplayObjectStateValueSelector;
import feathers.skins.StandardIcons;
import feathers.text.BitmapFontTextFormat;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;
import feathers.textures.Scale9Textures;
import feathers.utils.math.roundToNearest;

import flash.geom.Rectangle;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.textures.TextureSmoothing;

/**
 * The base class for the "Minimal" theme for desktop Feathers apps. Handles
 * everything except asset loading, which is left to subclasses.
 *
 * @see MinimalDesktopTheme
 * @see MinimalDesktopThemeWithAssetManager
 */
public class BaseMinimalDesktopTheme extends StyleNameFunctionTheme
{
	/**
	 * The name of the embedded bitmap font used by controls in this theme.
	 */
	public static const FONT_NAME:String = "PF Ronda Seven";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a horizontal slider.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-horizontal-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a vertical slider.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-vertical-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the decrement button of a horizontal scroll bar.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "minimal-desktop-horizontal-scroll-bar-decrement-button";

	/**
	 * @private
	 * The theme's custom style name for the increment button of a horizontal scroll bar.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "minimal-desktop-horizontal-scroll-bar-increment-button";

	/**
	 * @private
	 * The theme's custom style name for the decrement button of a horizontal scroll bar.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "minimal-desktop-vertical-scroll-bar-decrement-button";

	/**
	 * @private
	 * The theme's custom style name for the increment button of a vertical scroll bar.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "minimal-desktop-vertical-scroll-bar-increment-button";

	/**
	 * @private
	 */
	inline private static var THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB:String = "minimal-desktop-pop-up-volume-slider-thumb";

	/**
	 * @private
	 */
	inline private static var THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK:String = "minimal-desktop-pop-up-volume-slider-minimum-track";

	inline private static var FONT_TEXTURE_NAME:String = "pf-ronda-seven-font";
	
	inline private static var ATLAS_SCALE_FACTOR:Float = 2;

	inline private static var DEFAULT_SCALE_9_GRID:Rectangle = new Rectangle(3, 3, 1, 1);
	inline private static var SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
	inline private static var TAB_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 1, 1);
	inline private static var HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 2, 3, 1);
	inline private static var VOLUME_SLIDER_TRACK_SCALE9_GRID:Rectangle = new Rectangle(18, 13, 1, 1);
	inline private static var BACK_BUTTON_SCALE_REGION1:Int = 11;
	inline private static var BACK_BUTTON_SCALE_REGION2:Int = 1;
	inline private static var FORWARD_BUTTON_SCALE_REGION1:Int = 1;
	inline private static var FORWARD_BUTTON_SCALE_REGION2:Int = 1;

	inline private static var BACKGROUND_COLOR:UInt = 0xf3f3f3;
	inline private static var LIST_BACKGROUND_COLOR:UInt = 0xffffff;
	inline private static var LIST_SELECTED_BACKGROUND_COLOR:UInt = 0xdddddd;
	inline private static var LIST_HOVER_BACKGROUND_COLOR:UInt = 0xeeeeee;
	inline private static var LIST_HEADER_BACKGROUND_COLOR:UInt = 0xf8f8f8;
	inline private static var PRIMARY_TEXT_COLOR:UInt = 0x666666;
	inline private static var DISABLED_TEXT_COLOR:UInt = 0x999999;
	inline private static var MODAL_OVERLAY_COLOR:UInt = 0xcccccc;
	inline private static var MODAL_OVERLAY_ALPHA:Float = 0.4;
	inline private static var VIDEO_OVERLAY_COLOR:UInt = 0xcccccc;
	inline private static var VIDEO_OVERLAY_ALPHA:Float = 0.2;

	/**
	 * The default global text renderer factory for this theme creates a
	 * BitmapFontTextRenderer.
	 */
	private static function textRendererFactory():BitmapFontTextRenderer
	{
		var renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
		//since it's a pixel font, we don't want to smooth it.
		renderer.smoothing = TextureSmoothing.NONE;
		return renderer;
	}

	/**
	 * The default global text editor factory for this theme creates a
	 * BitmapFontTextEditor.
	 */
	private static function textEditorFactory():BitmapFontTextEditor
	{
		return new BitmapFontTextEditor();
	}

	/**
	 * This theme's scroll bar type is ScrollBar.
	 */
	private static function scrollBarFactory():IScrollBar
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
		var displayObject:ImageLoader = oldDisplayObject as ImageLoader;
		if(!displayObject)
		{
			displayObject = new ImageLoader();
		}
		displayObject.source = value;
		return displayObject;
	}

	/**
	 * Constructor.
	 */
	public function BaseMinimalDesktopTheme()
	{
	}

	/**
	 * Skins are scaled by a value based on the content scale factor.
	 */
	private var scale:Float = 1;

	/**
	 * A normal font size.
	 */
	private var fontSize:Int;

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
	 * The width, in pixels, of UI controls that span across multiple grid regions.
	 */
	private var wideControlSize:Int;

	/**
	 * The minimum width, in pixels, of some types of buttons.
	 */
	private var buttonMinWidth:Int;

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
	 * The size, in pixels, of a drop shadow on a control's bottom right.
	 */
	private var dropShadowSize:Int;

	private var calloutBackgroundMinSize:Int;
	private var calloutTopLeftArrowOverlapGapSize:Int;
	private var calloutBottomRightArrowOverlapGapSize:Int;
	private var progressBarFillMinSize:Int;
	private var popUpSize:Int;
	private var dropDownGapSize:Int;
	private var focusPaddingSize:Int;
	private var popUpVolumeSliderPaddingTopLeft:Int;
	private var popUpVolumeSliderPaddingBottomRight:Int;

	/**
	 * The texture atlas that contains skins for this theme. This base class
	 * does not initialize this member variable. Subclasses are expected to
	 * load the assets somehow and set the <code>atlas</code> member
	 * variable before calling <code>initialize()</code>.
	 */
	private var atlas:TextureAtlas;

	private var focusIndicatorSkinTextures:Scale9Textures;

	private var buttonUpSkinTextures:Scale9Textures;
	private var buttonDownSkinTextures:Scale9Textures;
	private var buttonDisabledSkinTextures:Scale9Textures;
	private var buttonSelectedSkinTextures:Scale9Textures;
	private var buttonSelectedDisabledSkinTextures:Scale9Textures;
	private var buttonCallToActionUpSkinTextures:Scale9Textures;
	private var buttonDangerUpSkinTextures:Scale9Textures;
	private var buttonDangerDownSkinTextures:Scale9Textures;
	private var buttonBackUpSkinTextures:Scale9Textures;
	private var buttonBackDownSkinTextures:Scale9Textures;
	private var buttonBackDisabledSkinTextures:Scale9Textures;
	private var buttonForwardUpSkinTextures:Scale3Textures;
	private var buttonForwardDownSkinTextures:Scale3Textures;
	private var buttonForwardDisabledSkinTextures:Scale3Textures;

	private var tabSkinTextures:Scale9Textures;
	private var tabDisabledSkinTextures:Scale9Textures;
	private var tabSelectedSkinTextures:Scale9Textures;
	private var tabSelectedDisabledSkinTextures:Scale9Textures;

	private var thumbSkinTextures:Scale9Textures;
	private var thumbDisabledSkinTextures:Scale9Textures;

	private var simpleScrollBarThumbSkinTextures:Scale9Textures;

	private var insetBackgroundSkinTextures:Scale9Textures;
	private var insetBackgroundDisabledSkinTextures:Scale9Textures;
	private var insetBackgroundFocusedSkinTextures:Scale9Textures;

	private var pickerListButtonIconUpTexture:Texture;
	private var pickerListButtonIconSelectedTexture:Texture;
	private var pickerListButtonIconDisabledTexture:Texture;
	private var searchIconTexture:Texture;
	private var searchIconDisabledTexture:Texture;
	private var verticalScrollBarDecrementButtonIconTexture:Texture;
	private var verticalScrollBarIncrementButtonIconTexture:Texture;
	private var horizontalScrollBarIncrementButtonIconTexture:Texture;
	private var horizontalScrollBarDecrementButtonIconTexture:Texture;

	private var headerSkinTextures:Scale9Textures;
	private var panelHeaderSkinTextures:Scale9Textures;

	private var panelBackgroundSkinTextures:Scale9Textures;
	private var popUpBackgroundSkinTextures:Scale9Textures;
	
	private var calloutTopArrowSkinTexture:Texture;
	private var calloutBottomArrowSkinTexture:Texture;
	private var calloutLeftArrowSkinTexture:Texture;
	private var calloutRightArrowSkinTexture:Texture;

	private var checkIconTexture:Texture;
	private var checkDisabledIconTexture:Texture;
	private var checkSelectedIconTexture:Texture;
	private var checkSelectedDisabledIconTexture:Texture;

	private var radioIconTexture:Texture;
	private var radioDisabledIconTexture:Texture;
	private var radioSelectedIconTexture:Texture;
	private var radioSelectedDisabledIconTexture:Texture;

	private var pageIndicatorSymbolTexture:Texture;
	private var pageIndicatorSelectedSymbolTexture:Texture;

	private var listBackgroundSkinTextures:Scale9Textures;
	private var listInsetBackgroundSkinTextures:Scale9Textures;

	//media textures
	private var playPauseButtonPlayUpIconTexture:Texture;
	private var playPauseButtonPauseUpIconTexture:Texture;
	private var overlayPlayPauseButtonPlayUpIconTexture:Texture;
	private var overlayPlayPauseButtonPlayDownIconTexture:Texture;
	private var fullScreenToggleButtonEnterUpIconTexture:Texture;
	private var fullScreenToggleButtonExitUpIconTexture:Texture;
	private var muteToggleButtonLoudUpIconTexture:Texture;
	private var muteToggleButtonMutedUpIconTexture:Texture;
	private var volumeSliderMinimumTrackSkinTexture:Texture;
	private var volumeSliderMaximumTrackSkinTexture:Texture;
	private var popUpVolumeSliderTrackSkinTextures:Scale9Textures;

	private var primaryTextFormat:BitmapFontTextFormat;
	private var disabledTextFormat:BitmapFontTextFormat;
	private var headingTextFormat:BitmapFontTextFormat;
	private var headingDisabledTextFormat:BitmapFontTextFormat;
	private var centeredTextFormat:BitmapFontTextFormat;
	private var centeredDisabledTextFormat:BitmapFontTextFormat;

	private var scrollTextTextFormat:TextFormat;
	private var scrollTextDisabledTextFormat:TextFormat;

	/**
	 * Disposes the texture atlas and bitmap font before calling
	 * super.dispose().
	 */
	override public function dispose():Void
	{
		if(this.atlas)
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
		TextField.unregisterBitmapFont(FONT_NAME);

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
		this.borderSize = Math.max(1, Math.round(1 * this.scale));
		this.dropShadowSize = Math.round(4 * this.scale);
		this.controlSize = Math.round(20 * this.scale);
		this.smallControlSize = Math.round(12 * this.scale);
		this.calloutTopLeftArrowOverlapGapSize = Math.round(-2 * this.scale);
		this.calloutBottomRightArrowOverlapGapSize = Math.round(-6 * this.scale);
		this.calloutBackgroundMinSize = Math.round(5 * this.scale);
		this.progressBarFillMinSize = Math.round(7 * this.scale);
		this.buttonMinWidth = this.gridSize * 2 + this.smallGutterSize * 1;
		this.wideControlSize = this.gridSize * 3 + this.smallGutterSize * 2;
		this.popUpSize = this.gridSize * 10 + this.smallGutterSize * 9;
		this.dropDownGapSize = Math.min(-1, Math.round(-1 * this.scale));
		this.focusPaddingSize = Math.min(-1, Math.round(-2 * this.scale));
		this.popUpVolumeSliderPaddingTopLeft = Math.round(9 * this.scale);
		this.popUpVolumeSliderPaddingBottomRight = this.popUpVolumeSliderPaddingTopLeft + this.dropShadowSize;
	}

	/**
	 * Sets the stage background color.
	 */
	private function initializeStage():Void
	{
		Starling.current.stage.color = BACKGROUND_COLOR;
		Starling.current.nativeStage.color = BACKGROUND_COLOR;
	}

	/**
	 * Initializes global variables (not including global style providers).
	 */
	private function initializeGlobals():Void
	{
		FocusManager.setEnabledForStage(Starling.current.stage, true);

		PopUpManager.overlayFactory = popUpOverlayFactory;
		Callout.stagePadding = this.smallGutterSize;

		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		FeathersControl.defaultTextEditorFactory = textEditorFactory;
	}

	/**
	 * Initializes the textures by extracting them from the atlas and
	 * setting up any scaling grids that are needed.
	 */
	private function initializeTextures():Void
	{
		this.focusIndicatorSkinTextures = new Scale9Textures(this.atlas.getTexture("focus-indicator-skin"), DEFAULT_SCALE_9_GRID);

		this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), DEFAULT_SCALE_9_GRID);
		this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), DEFAULT_SCALE_9_GRID);
		this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), DEFAULT_SCALE_9_GRID);
		this.buttonSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-enabled-skin"), DEFAULT_SCALE_9_GRID);
		this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-disabled-skin"), DEFAULT_SCALE_9_GRID);
		this.buttonCallToActionUpSkinTextures = new Scale9Textures(this.atlas.getTexture("call-to-action-button-up-skin"), DEFAULT_SCALE_9_GRID);
		this.buttonDangerUpSkinTextures = new Scale9Textures(this.atlas.getTexture("danger-button-up-skin"), DEFAULT_SCALE_9_GRID);
		this.buttonDangerDownSkinTextures = new Scale9Textures(this.atlas.getTexture("danger-button-down-skin"), DEFAULT_SCALE_9_GRID);
		this.buttonBackUpSkinTextures = new Scale9Textures(this.atlas.getTexture("back-button-up-skin"), new Rectangle(11, 0, 1, 20));//BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonBackDownSkinTextures = new Scale9Textures(this.atlas.getTexture("back-button-down-skin"), new Rectangle(11, 0, 1, 20));//BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonBackDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("back-button-disabled-skin"), new Rectangle(11, 0, 1, 20));//BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonForwardUpSkinTextures = new Scale3Textures(this.atlas.getTexture("forward-button-up-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonForwardDownSkinTextures = new Scale3Textures(this.atlas.getTexture("forward-button-down-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonForwardDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("forward-button-disabled-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);

		this.tabSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-up-skin"), TAB_SCALE_9_GRID);
		this.tabDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-disabled-skin"), TAB_SCALE_9_GRID);
		this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-up-skin"), TAB_SCALE_9_GRID);
		this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE_9_GRID);

		this.thumbSkinTextures = new Scale9Textures(this.atlas.getTexture("face-up-skin"), DEFAULT_SCALE_9_GRID);
		this.thumbDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("face-disabled-skin"), DEFAULT_SCALE_9_GRID);

		this.simpleScrollBarThumbSkinTextures = new Scale9Textures(this.atlas.getTexture("simple-scroll-bar-thumb-skin"), SCROLLBAR_THUMB_SCALE_9_GRID);

		this.listBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("list-background-skin"), DEFAULT_SCALE_9_GRID);
		this.listInsetBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-background-skin"), DEFAULT_SCALE_9_GRID);

		this.insetBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-enabled-skin"), DEFAULT_SCALE_9_GRID);
		this.insetBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-disabled-skin"), DEFAULT_SCALE_9_GRID);
		this.insetBackgroundFocusedSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-focused-skin"), DEFAULT_SCALE_9_GRID);

		this.pickerListButtonIconUpTexture = this.atlas.getTexture("picker-list-icon");
		this.pickerListButtonIconSelectedTexture = this.atlas.getTexture("picker-list-selected-icon");
		this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-disabled-icon");
		this.searchIconTexture = this.atlas.getTexture("search-enabled-icon");
		this.searchIconDisabledTexture = this.atlas.getTexture("search-disabled-icon");
		this.verticalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon");
		this.verticalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon");
		this.horizontalScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon");
		this.horizontalScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon");

		this.headerSkinTextures = new Scale9Textures(this.atlas.getTexture("header-background-skin"), HEADER_SCALE_9_GRID);
		this.panelHeaderSkinTextures = new Scale9Textures(this.atlas.getTexture("panel-header-background-skin"), HEADER_SCALE_9_GRID);

		this.popUpBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("pop-up-background-skin"), DEFAULT_SCALE_9_GRID);
		this.panelBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("panel-background-skin"), DEFAULT_SCALE_9_GRID);
		this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-top-arrow-skin");
		this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-bottom-arrow-skin");
		this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-left-arrow-skin");
		this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-right-arrow-skin");

		this.checkIconTexture = this.atlas.getTexture("check-up-icon");
		this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon");
		this.checkSelectedIconTexture = this.atlas.getTexture("check-selected-up-icon");
		this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

		this.radioIconTexture = this.atlas.getTexture("radio-up-icon");
		this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon");
		this.radioSelectedIconTexture = this.atlas.getTexture("radio-selected-up-icon");
		this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

		this.pageIndicatorSymbolTexture = this.atlas.getTexture("page-indicator-symbol");
		this.pageIndicatorSelectedSymbolTexture = this.atlas.getTexture("page-indicator-selected-symbol");

		this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon");
		this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon");
		this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon");
		this.overlayPlayPauseButtonPlayDownIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-down-icon");
		this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon");
		this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon");
		this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon");
		this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon");
		this.volumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("volume-slider-minimum-track-skin");
		this.volumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("volume-slider-maximum-track-skin");
		this.popUpVolumeSliderTrackSkinTextures = new Scale9Textures(this.atlas.getTexture("pop-up-volume-slider-track-skin"), VOLUME_SLIDER_TRACK_SCALE9_GRID);

		StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");
	}

	/**
	 * Initializes font sizes and formats.
	 */
	private function initializeFonts():Void
	{
		//since it's a pixel font, we want a multiple of the original size,
		//which, in this case, is 8.
		this.fontSize = Math.max(8, roundToNearest(8 * this.scale, 8));
		this.largeFontSize = Math.max(8, roundToNearest(16 * this.scale, 8));

		this.primaryTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR);
		this.disabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR);
		this.headingTextFormat = new BitmapFontTextFormat(FONT_NAME, this.largeFontSize, PRIMARY_TEXT_COLOR);
		this.headingDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.largeFontSize, DISABLED_TEXT_COLOR);
		this.centeredTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR, TextFormatAlign.CENTER);
		this.centeredDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR, TextFormatAlign.CENTER);

		var scrollTextFontList:String = "PF Ronda Seven,Roboto,Helvetica,Arial,_sans";
		this.scrollTextTextFormat = new TextFormat(scrollTextFontList, this.fontSize, PRIMARY_TEXT_COLOR);
		this.scrollTextDisabledTextFormat = new TextFormat(scrollTextFontList, this.fontSize, DISABLED_TEXT_COLOR);
	}

	/**
	 * Sets global style providers for all components.
	 */
	private function initializeStyleProviders():Void
	{
		//alert
		this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelHeaderStyles);
		this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
		this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

		//autocomplete
		this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
		this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

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

		//check
		this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

		//grouped list (see also: item renderers)
		this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
		this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

		//header
		this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

		//item renderers for lists
		this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
		this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

		//header and footer renderers for grouped list
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);

		//label
		this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
		//no detail label because the font size would be too small

		//layout group
		this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarLayoutGroupStyles);

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
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelHeaderStyles);

		//panel screen
		this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;

		//picker list (see also: item renderers)
		this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
		this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

		//progress bar
		this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

		//radio
		this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

		//scroll bar
		this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalScrollBarStyles);
		this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR, this.setVerticalScrollBarStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setScrollBarThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ScrollBar.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setScrollBarMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON, this.setHorizontalScrollBarDecrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON, this.setHorizontalScrollBarIncrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);

		//scroll container
		this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
		this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

		//scroll screen
		this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

		//scroll text
		this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

		//simple scroll bar
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SimpleScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSimpleScrollBarThumbStyles);

		//slider
		this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);

		//tab bar
		this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_NAME_TAB, this.setTabStyles);

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
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
		
		//media controls
		this.getStyleProviderForClass(VideoPlayer).defaultStyleFunction = this.setVideoPlayerStyles;

		//play/pause toggle button
		this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
		this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON, this.setOverlayPlayPauseToggleButtonStyles);

		//full screen toggle button
		this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;

		//mute toggle button
		this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;
		this.getStyleProviderForClass(VolumeSlider).setFunctionForStyleName(MuteToggleButton.DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER, this.setPopUpVolumeSliderStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB, this.setSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK, this.setPopUpVolumeSliderTrackStyles);

		//seek slider
		this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);

		//volume slider
		this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setVolumeSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setVolumeSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setVolumeSliderMaximumTrackStyles);
	}

	private function pageIndicatorNormalSymbolFactory():DisplayObject
	{
		var symbol:ImageLoader = new ImageLoader();
		symbol.source = this.pageIndicatorSymbolTexture;
		symbol.textureScale = this.scale;
		symbol.snapToPixels = true;
		return symbol;
	}

	private function pageIndicatorSelectedSymbolFactory():DisplayObject
	{
		var symbol:ImageLoader = new ImageLoader();
		symbol.source = this.pageIndicatorSelectedSymbolTexture;
		symbol.textureScale = this.scale;
		symbol.snapToPixels = true;
		return symbol;
	}

	private function imageLoaderFactory():ImageLoader
	{
		var image:ImageLoader = new ImageLoader();
		image.textureScale = this.scale;
		image.snapToPixels = true;
		return image;
	}

//-------------------------
// Shared
//-------------------------

	private function setScrollerStyles(scroller:Scroller):Void
	{
		scroller.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
		scroller.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
		scroller.horizontalScrollBarFactory = scrollBarFactory;
		scroller.verticalScrollBarFactory = scrollBarFactory;

		scroller.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		scroller.focusPadding = 0;
	}

	private function setDropDownListStyles(list:List):Void
	{
		this.setListStyles(list);
		list.maxHeight = this.wideControlSize;
	}

//-------------------------
// Alert
//-------------------------

	private function setAlertStyles(alert:Alert):Void
	{
		this.setScrollerStyles(alert);

		var backgroundSkin:Scale9Image = new Scale9Image(this.popUpBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.controlSize;
		backgroundSkin.height = this.controlSize;
		alert.backgroundSkin = backgroundSkin;

		alert.paddingTop = this.gutterSize;
		alert.paddingRight = this.gutterSize;
		alert.paddingBottom = this.smallGutterSize;
		alert.paddingLeft = this.gutterSize;
		alert.outerPadding = this.borderSize;
		alert.outerPaddingBottom = this.borderSize + this.dropShadowSize;
		alert.outerPaddingRight = this.borderSize + this.dropShadowSize;
		alert.gap = this.smallGutterSize;
		alert.maxWidth = this.popUpSize;
		alert.maxHeight = this.popUpSize;
	}

	private function setAlertButtonGroupStyles(group:ButtonGroup):Void
	{
		group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
		group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
		group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
		group.distributeButtonSizes = false;
		group.gap = this.smallGutterSize;
		group.padding = this.smallGutterSize;
	}

	private function setAlertMessageTextRendererStyles(renderer:BitmapFontTextRenderer):Void
	{
		renderer.wordWrap = true;
		renderer.textFormat = this.primaryTextFormat;
	}

//-------------------------
// Button
//-------------------------

	private function setBaseButtonStyles(button:Button):Void
	{
		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		button.focusPadding = this.focusPaddingSize;

		button.defaultLabelProperties.textFormat = this.primaryTextFormat;
		button.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

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
		if(button is ToggleButton)
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		}
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.minWidth = this.buttonMinWidth;
	}

	private function setCallToActionButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonCallToActionUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
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
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(null, Button.STATE_DISABLED, false);
		if(button is ToggleButton)
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		}
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

	private function setDangerButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonDangerUpSkinTextures;
		skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
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
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			smoothing: TextureSmoothing.NONE,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.minWidth = this.controlSize;
		button.height = this.controlSize;
		button.paddingLeft = 2 * this.gutterSize;
	}

	private function setForwardButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonForwardUpSkinTextures;
		skinSelector.setValueForState(this.buttonForwardDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonForwardDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			smoothing: TextureSmoothing.NONE,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		this.setBaseButtonStyles(button);
		button.minWidth = this.controlSize;
		button.height = this.controlSize;
		button.paddingRight = 2 * this.gutterSize;
	}

//-------------------------
// ButtonGroup
//-------------------------

	private function setButtonGroupStyles(group:ButtonGroup):Void
	{
		group.minWidth = this.wideControlSize;
		group.gap = this.smallGutterSize;
	}

	private function setButtonGroupButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		if(button is ToggleButton)
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		}
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		button.focusPadding = this.focusPaddingSize;

		button.defaultLabelProperties.textFormat = this.primaryTextFormat;
		button.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

		button.paddingTop = this.smallGutterSize;
		button.paddingBottom = this.smallGutterSize;
		button.paddingLeft = this.gutterSize;
		button.paddingRight = this.gutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.buttonMinWidth;
		button.minHeight = this.smallControlSize;
	}

//-------------------------
// Callout
//-------------------------

	private function setCalloutStyles(callout:Callout):Void
	{
		callout.padding = this.gutterSize;
		callout.paddingRight = this.gutterSize + this.dropShadowSize;
		callout.paddingBottom = this.gutterSize + this.dropShadowSize;

		var backgroundSkin:Scale9Image = new Scale9Image(this.popUpBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.calloutBackgroundMinSize;
		backgroundSkin.height = this.calloutBackgroundMinSize;
		callout.backgroundSkin = backgroundSkin;

		var topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);
		topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
		callout.topArrowSkin = topArrowSkin;
		callout.topArrowGap = this.calloutTopLeftArrowOverlapGapSize;

		var bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);
		bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
		callout.bottomArrowSkin = bottomArrowSkin;
		callout.bottomArrowGap = this.calloutBottomRightArrowOverlapGapSize;

		var leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);
		leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
		callout.leftArrowSkin = leftArrowSkin;
		callout.leftArrowGap = this.calloutTopLeftArrowOverlapGapSize;

		var rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);
		rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
		callout.rightArrowSkin = rightArrowSkin;
		callout.rightArrowGap = this.calloutBottomRightArrowOverlapGapSize;
	}

//-------------------------
// Check
//-------------------------

	private function setCheckStyles(check:Check):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.checkIconTexture;
		iconSelector.defaultSelectedValue = this.checkSelectedIconTexture;
		iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
		iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale,
			snapToPixels: true,
			smoothing: TextureSmoothing.NONE
		};
		check.stateToIconFunction = iconSelector.updateValue;

		check.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		check.focusPaddingLeft = this.focusPaddingSize;
		check.focusPaddingRight = this.focusPaddingSize;

		check.defaultLabelProperties.textFormat = this.primaryTextFormat;
		check.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

		check.gap = this.smallGutterSize;
		check.minWidth = this.controlSize;
		check.minHeight = this.controlSize;
		check.horizontalAlign = Check.HORIZONTAL_ALIGN_LEFT;
		check.verticalAlign = Check.VERTICAL_ALIGN_MIDDLE;
	}

//-------------------------
// Drawers
//-------------------------

	private function setDrawersStyles(drawers:Drawers):Void
	{
		var overlaySkin:Quad = new Quad(10, 10, MODAL_OVERLAY_COLOR);
		overlaySkin.alpha = MODAL_OVERLAY_ALPHA;
		drawers.overlaySkin = overlaySkin;
	}

//-------------------------
// GroupedList
//-------------------------

	private function setGroupedListStyles(list:GroupedList):Void
	{
		this.setScrollerStyles(list);

		list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;

		var backgroundSkin:Scale9Image = new Scale9Image(this.listBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
		list.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);
		backgroundDisabledSkin.width = this.gridSize;
		backgroundDisabledSkin.height = this.gridSize;
		list.backgroundDisabledSkin = backgroundDisabledSkin;

		list.padding = this.borderSize;
	}

	//see List section for item renderer styles

	private function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		var backgroundSkin:Quad = new Quad(this.controlSize, this.controlSize, LIST_HEADER_BACKGROUND_COLOR);
		renderer.backgroundSkin = backgroundSkin;

		renderer.contentLabelProperties.textFormat = this.primaryTextFormat;
		renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;

		renderer.contentLoaderFactory = this.imageLoaderFactory;
	}

	private function setInsetGroupedListStyles(list:GroupedList):Void
	{
		this.setScrollerStyles(list);

		var backgroundSkin:Scale9Image = new Scale9Image(this.listInsetBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
		list.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);
		backgroundDisabledSkin.width = this.gridSize;
		backgroundDisabledSkin.height = this.gridSize;
		list.backgroundDisabledSkin = backgroundDisabledSkin;

		list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;

		list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
		list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;

		var layout:VerticalLayout = new VerticalLayout();
		layout.useVirtualLayout = true;
		layout.padding = this.gutterSize;
		layout.paddingTop = 0;
		layout.gap = 0;
		layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
		layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
		list.layout = layout;
	}

	private function setInsetGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.contentLabelProperties.textFormat = this.primaryTextFormat;

		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
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
		header.paddingTop = this.smallGutterSize;
		header.paddingBottom = this.smallGutterSize;
		header.paddingRight = this.gutterSize;
		header.paddingLeft = this.gutterSize;
		header.gap = this.smallGutterSize;
		header.titleGap = this.smallGutterSize;

		var backgroundSkin:Scale9Image = new Scale9Image(this.headerSkinTextures, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
		header.backgroundSkin = backgroundSkin;

		header.titleProperties.textFormat = this.primaryTextFormat;
		header.titleProperties.disabledTextFormat = this.disabledTextFormat;
	}

//-------------------------
// Label
//-------------------------

	private function setLabelStyles(label:Label):Void
	{
		label.textRendererProperties.textFormat = this.primaryTextFormat;
		label.textRendererProperties.disabledTextFormat = this.disabledTextFormat;
	}

	private function setHeadingLabelStyles(label:Label):Void
	{
		label.textRendererProperties.textFormat = this.headingTextFormat;
		label.textRendererProperties.disabledTextFormat = this.headingDisabledTextFormat;
	}

//-------------------------
// LayoutGroup
//-------------------------

	private function setToolbarLayoutGroupStyles(group:LayoutGroup):Void
	{
		if(!group.layout)
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.padding = this.gutterSize;
			layout.gap = this.smallGutterSize;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			group.layout = layout;
		}

		group.minWidth = this.gridSize;
		group.minHeight = this.gridSize;

		var backgroundSkin:Scale9Image = new Scale9Image(this.headerSkinTextures, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
		group.backgroundSkin = backgroundSkin;
	}

//-------------------------
// List
//-------------------------

	private function setListStyles(list:List):Void
	{
		this.setScrollerStyles(list);

		list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;

		var backgroundSkin:Scale9Image = new Scale9Image(this.listBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
		list.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);
		backgroundDisabledSkin.width = this.gridSize;
		backgroundDisabledSkin.height = this.gridSize;
		list.backgroundDisabledSkin = backgroundDisabledSkin;

		list.padding = this.borderSize;
		list.paddingRight = 0;
	}

	private function setItemRendererStyles(renderer:BaseDefaultItemRenderer):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = LIST_BACKGROUND_COLOR;
		skinSelector.defaultSelectedValue = LIST_SELECTED_BACKGROUND_COLOR;
		skinSelector.setValueForState(LIST_HOVER_BACKGROUND_COLOR, Button.STATE_HOVER, false);
		skinSelector.setValueForState(LIST_SELECTED_BACKGROUND_COLOR, Button.STATE_DOWN, false);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		renderer.defaultLabelProperties.textFormat = this.primaryTextFormat;
		renderer.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.gap = this.smallGutterSize;
		renderer.minGap = this.smallGutterSize;
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryGap = Float.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.smallGutterSize;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;

		renderer.useStateDelayTimer = false;

		renderer.accessoryLoaderFactory = this.imageLoaderFactory;
		renderer.iconLoaderFactory = this.imageLoaderFactory;
	}

	private function setItemRendererAccessoryLabelStyles(renderer:BitmapFontTextRenderer):Void
	{
		renderer.textFormat = this.primaryTextFormat;
	}

	private function setItemRendererIconLabelStyles(renderer:BitmapFontTextRenderer):Void
	{
		renderer.textFormat = this.primaryTextFormat;
	}

//-------------------------
// NumericStepper
//-------------------------

	private function setNumericStepperStyles(stepper:NumericStepper):Void
	{
		stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL;
		stepper.incrementButtonLabel = "+";
		stepper.decrementButtonLabel = "-";

		stepper.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		stepper.focusPadding = this.focusPaddingSize;
	}

	private function setNumericStepperButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		button.keepDownStateOnRollOut = true;
		this.setBaseButtonStyles(button);
	}

	private function setNumericStepperTextInputStyles(input:TextInput):Void
	{
		input.minWidth = this.gridSize;
		input.minHeight = this.controlSize;
		input.gap = this.smallGutterSize;
		input.paddingTop = this.smallGutterSize;
		input.paddingBottom = this.smallGutterSize;
		input.paddingLeft = this.gutterSize;
		input.paddingRight = this.gutterSize;

		input.textEditorProperties.textFormat = this.centeredTextFormat;
		input.textEditorProperties.disabledTextFormat = this.centeredDisabledTextFormat;
		input.textEditorProperties.cursorSkin = new Quad(1, 1, PRIMARY_TEXT_COLOR);
		input.textEditorProperties.selectionSkin = new Quad(1, 1, BACKGROUND_COLOR);

		input.promptProperties.textFormat = this.primaryTextFormat;
		input.promptProperties.disabledTextFormat = this.disabledTextFormat;

		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
		skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.gridSize,
			height: this.controlSize
		};
		input.stateToSkinFunction = skinSelector.updateValue;
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

		var backgroundSkin:Scale9Image = new Scale9Image(this.panelBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.controlSize;
		backgroundSkin.height = this.controlSize;
		panel.backgroundSkin = backgroundSkin;

		panel.padding = this.gutterSize;
	}

	private function setPanelHeaderStyles(header:Header):Void
	{
		header.minWidth = this.gridSize;
		header.minHeight = this.gridSize;
		header.paddingTop = this.smallGutterSize;
		header.paddingBottom = this.smallGutterSize;
		header.paddingRight = this.gutterSize;
		header.paddingLeft = this.gutterSize;
		header.gap = this.smallGutterSize;
		header.titleGap = this.smallGutterSize;

		var backgroundSkin:Scale9Image = new Scale9Image(this.panelHeaderSkinTextures, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
		header.backgroundSkin = backgroundSkin;

		header.titleProperties.textFormat = this.primaryTextFormat;
		header.titleProperties.disabledTextFormat = this.disabledTextFormat;
	}

//-------------------------
// PanelScreen
//-------------------------

	private function setPanelScreenStyles(screen:PanelScreen):Void
	{
		this.setScrollerStyles(screen);
	}

//-------------------------
// PickerList
//-------------------------

	private function setPickerListStyles(list:PickerList):Void
	{
		list.toggleButtonOnOpenAndClose = true;
		var popUpContentManager:DropDownPopUpContentManager = new DropDownPopUpContentManager();
		popUpContentManager.gap = this.dropDownGapSize;
		list.popUpContentManager = popUpContentManager;
		list.buttonFactory = pickerListButtonFactory;
	}

	private function setPickerListButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.pickerListButtonIconUpTexture;
		iconSelector.setValueForState(this.pickerListButtonIconDisabledTexture, Button.STATE_DISABLED, false);
		if(button is ToggleButton)
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			iconSelector.defaultSelectedValue = this.pickerListButtonIconSelectedTexture;
		}
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale,
			snapToPixels: true
		};
		button.stateToIconFunction = iconSelector.updateValue;

		this.setBaseButtonStyles(button);

		button.minWidth = this.buttonMinWidth;
		button.gap = Float.POSITIVE_INFINITY; //fill as completely as possible
		button.minGap = this.gutterSize;
		button.iconPosition = Button.ICON_POSITION_RIGHT;
		button.horizontalAlign =  Button.HORIZONTAL_ALIGN_LEFT;
	}

//-------------------------
// ProgressBar
//-------------------------

	private function setProgressBarStyles(progress:ProgressBar):Void
	{
		var backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
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

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(insetBackgroundDisabledSkinTextures, this.scale);
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

		var fillSkin:Scale9Image = new Scale9Image(buttonUpSkinTextures, this.scale);
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

		var fillDisabledSkin:Scale9Image = new Scale9Image(buttonDisabledSkinTextures, this.scale);
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
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.radioIconTexture;
		iconSelector.defaultSelectedValue = this.radioSelectedIconTexture;
		iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
		iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale,
			snapToPixels: true
		};
		radio.stateToIconFunction = iconSelector.updateValue;

		radio.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		radio.focusPadding = this.focusPaddingSize;

		radio.defaultLabelProperties.textFormat = this.primaryTextFormat;
		radio.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

		radio.gap = this.smallGutterSize;
		radio.minWidth = this.controlSize;
		radio.minHeight = this.controlSize;

		radio.horizontalAlign = Radio.HORIZONTAL_ALIGN_LEFT;
		radio.verticalAlign = Radio.VERTICAL_ALIGN_MIDDLE;
	}

//-------------------------
// ScrollBar
//-------------------------

	private function setHorizontalScrollBarStyles(scrollBar:ScrollBar):Void
	{
		scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

		scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
		scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
	}

	private function setVerticalScrollBarStyles(scrollBar:ScrollBar):Void
	{
		scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

		scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
		scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
	}

	private function setScrollBarThumbStyles(thumb:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.thumbSkinTextures;
		skinSelector.setValueForState(this.thumbDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		thumb.stateToSkinFunction = skinSelector.updateValue;

		thumb.hasLabelTextRenderer = false;
	}

	private function setScrollBarMinimumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

	private function setBaseScrollBarButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
		button.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		button.padding = 0;
		button.gap = 0;
		button.minGap = 0;
		button.minWidth = this.smallControlSize;
		button.minHeight = this.smallControlSize;

		button.hasLabelTextRenderer = false;
	}

	private function setHorizontalScrollBarDecrementButtonStyles(button:Button):Void
	{
		this.setBaseScrollBarButtonStyles(button);

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.horizontalScrollBarDecrementButtonIconTexture;
		iconSelector.setValueForState(null, Button.STATE_DISABLED, false);
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;
	}

	private function setHorizontalScrollBarIncrementButtonStyles(button:Button):Void
	{
		this.setBaseScrollBarButtonStyles(button);

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.horizontalScrollBarIncrementButtonIconTexture;
		iconSelector.setValueForState(null, Button.STATE_DISABLED, false);
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;
	}

	private function setVerticalScrollBarDecrementButtonStyles(button:Button):Void
	{
		this.setBaseScrollBarButtonStyles(button);

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.verticalScrollBarDecrementButtonIconTexture;
		iconSelector.setValueForState(null, Button.STATE_DISABLED, false);
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;
	}

	private function setVerticalScrollBarIncrementButtonStyles(button:Button):Void
	{
		this.setBaseScrollBarButtonStyles(button);

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.verticalScrollBarIncrementButtonIconTexture;
		iconSelector.setValueForState(null, Button.STATE_DISABLED, false);
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;
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

		if(!container.layout)
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.padding = this.gutterSize;
			layout.gap = this.smallGutterSize;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			container.layout = layout;
		}

		container.minWidth = this.gridSize;
		container.minHeight = this.gridSize;

		var backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
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
	}

//-------------------------
// SimpleScrollBar
//-------------------------

	private function setSimpleScrollBarThumbStyles(thumb:Button):Void
	{
		var defaultSkin:Scale9Image = new Scale9Image(this.simpleScrollBarThumbSkinTextures, this.scale);
		defaultSkin.width = this.smallControlSize;
		defaultSkin.height = this.smallControlSize;
		thumb.defaultSkin = defaultSkin;

		thumb.hasLabelTextRenderer = false;
	}

//-------------------------
// Slider
//-------------------------

	private function setSliderStyles(slider:Slider):Void
	{
		slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;

		if(slider.direction == Slider.DIRECTION_VERTICAL)
		{
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
			slider.minHeight = this.wideControlSize;
		}
		else //horizontal
		{
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
			slider.minWidth = this.wideControlSize;
		}

		slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		slider.focusPadding = this.focusPaddingSize;
	}

	private function setHorizontalSliderMinimumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.wideControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

	private function setVerticalSliderMinimumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.smallControlSize,
			height: this.wideControlSize,
			textureScale: this.scale
		};
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

	private function setSliderThumbStyles(thumb:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.thumbSkinTextures;
		skinSelector.setValueForState(this.thumbDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.smallControlSize,
			height: this.smallControlSize,
			textureScale: this.scale
		};
		thumb.stateToSkinFunction = skinSelector.updateValue;

		thumb.hasLabelTextRenderer = false;
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
		skinSelector.defaultValue = this.tabSkinTextures;
		skinSelector.defaultSelectedValue = this.tabSelectedSkinTextures;
		skinSelector.setValueForState(this.tabDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		tab.stateToSkinFunction = skinSelector.updateValue;

		tab.defaultLabelProperties.textFormat = this.primaryTextFormat;
		tab.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

		tab.iconPosition = Button.ICON_POSITION_LEFT;

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

		textArea.textEditorProperties.textFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, PRIMARY_TEXT_COLOR);
		textArea.textEditorProperties.disabledTextFormat = new TextFormat("PF Ronda Seven,Roboto,Helvetica,Arial,_sans", this.fontSize, DISABLED_TEXT_COLOR);
		textArea.textEditorProperties.paddingTop = this.extraSmallGutterSize;
		textArea.textEditorProperties.paddingRight = this.smallGutterSize;
		textArea.textEditorProperties.paddingBottom = this.extraSmallGutterSize;
		textArea.textEditorProperties.paddingLeft = this.smallGutterSize;

		textArea.padding = this.borderSize;

		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
		skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.wideControlSize * 2,
			height: this.wideControlSize,
			textureScale: this.scale
		};
		textArea.stateToSkinFunction = skinSelector.updateValue;
	}

//-------------------------
// TextInput
//-------------------------

	private function setBaseTextInputStyles(input:TextInput):Void
	{
		input.minWidth = this.controlSize;
		input.minHeight = this.controlSize;
		input.gap = this.smallGutterSize;
		input.paddingTop = this.smallGutterSize;
		input.paddingBottom = this.smallGutterSize;
		input.paddingLeft = this.gutterSize;
		input.paddingRight = this.gutterSize;

		input.textEditorProperties.textFormat = this.primaryTextFormat;
		input.textEditorProperties.disabledTextFormat = this.disabledTextFormat;
		input.textEditorProperties.cursorSkin = new Quad(1, 1, PRIMARY_TEXT_COLOR);
		input.textEditorProperties.selectionSkin = new Quad(1, 1, BACKGROUND_COLOR);

		input.promptProperties.textFormat = this.primaryTextFormat;
		input.promptProperties.disabledTextFormat = this.disabledTextFormat;

		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED, false);
		skinSelector.setValueForState(this.insetBackgroundFocusedSkinTextures, TextInput.STATE_FOCUSED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.wideControlSize,
			height: this.controlSize
		};
		input.stateToSkinFunction = skinSelector.updateValue;

		input.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		input.focusPadding = this.focusPaddingSize;
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
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale,
			snapToPixels: true
		};
		input.stateToIconFunction = iconSelector.updateValue;
	}

//-------------------------
// ToggleSwitch
//-------------------------

	private function setToggleSwitchStyles(toggleSwitch:ToggleSwitch):Void
	{
		toggleSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

		toggleSwitch.defaultLabelProperties.textFormat = this.primaryTextFormat;
		toggleSwitch.defaultLabelProperties.disabledTextFormat = this.disabledTextFormat;

		toggleSwitch.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		toggleSwitch.focusPadding = this.focusPaddingSize;
	}

	private function setToggleSwitchOnTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: Math.round(this.controlSize * 2.5),
			height: this.controlSize,
			textureScale: this.scale
		};
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

	private function setToggleSwitchThumbStyles(thumb:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.thumbSkinTextures;
		skinSelector.setValueForState(this.thumbDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		thumb.stateToSkinFunction = skinSelector.updateValue;

		thumb.hasLabelTextRenderer = false;
	}

//-------------------------
// VideoPlayer
//-------------------------

	private function setVideoPlayerStyles(player:VideoPlayer):Void
	{
		player.backgroundSkin = new Quad(1, 1, 0x000000);
	}

//-------------------------
// PlayPauseToggleButton
//-------------------------

	private function setPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.playPauseButtonPlayUpIconTexture;
		iconSelector.defaultSelectedValue = this.playPauseButtonPauseUpIconTexture;
		iconSelector.displayObjectProperties =
		{
			scaleX: this.scale,
			scaleY: this.scale,
			smoothing: TextureSmoothing.NONE,
			snapToPixels: true
		};
		button.stateToIconFunction = iconSelector.updateValue;
		
		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		button.focusPadding = this.focusPaddingSize;

		button.hasLabelTextRenderer = false;

		button.padding = this.smallGutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

	private function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayUpIconTexture, Button.STATE_UP, false);
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayUpIconTexture, Button.STATE_HOVER, false);
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.displayObjectProperties =
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
		
		//since the selected states don't have a skin, the minWidth and
		//minHeight values will ensure that the button doesn't resize!
		button.minWidth = this.overlayPlayPauseButtonPlayUpIconTexture.width;
		button.minHeight = this.overlayPlayPauseButtonPlayUpIconTexture.height;
	}

//-------------------------
// FullScreenToggleButton
//-------------------------

	private function setFullScreenToggleButtonStyles(button:FullScreenToggleButton):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.fullScreenToggleButtonEnterUpIconTexture;
		iconSelector.defaultSelectedValue = this.fullScreenToggleButtonExitUpIconTexture;
		iconSelector.displayObjectProperties =
		{
			scaleX: this.scale,
			scaleY: this.scale,
			smoothing: TextureSmoothing.NONE,
			snapToPixels: true
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		button.focusPadding = this.focusPaddingSize;

		button.hasLabelTextRenderer = false;

		button.padding = this.smallGutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

//-------------------------
// MuteToggleButton
//-------------------------

	private function setMuteToggleButtonStyles(button:MuteToggleButton):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;
		
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.muteToggleButtonLoudUpIconTexture;
		iconSelector.defaultSelectedValue = this.muteToggleButtonMutedUpIconTexture;
		iconSelector.displayObjectProperties =
		{
			scaleX: this.scale,
			scaleY: this.scale,
			smoothing: TextureSmoothing.NONE,
			snapToPixels: true
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		button.focusPadding = this.focusPaddingSize;

		button.hasLabelTextRenderer = false;
		button.showVolumeSliderOnHover = true;

		button.padding = this.smallGutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

	private function setPopUpVolumeSliderStyles(slider:VolumeSlider):Void
	{
		slider.direction = VolumeSlider.DIRECTION_VERTICAL;
		slider.trackLayoutMode = VolumeSlider.TRACK_LAYOUT_MODE_SINGLE;
		slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		slider.focusPadding = this.focusPaddingSize;
		slider.maximumPadding = this.popUpVolumeSliderPaddingTopLeft;
		slider.minimumPadding = this.popUpVolumeSliderPaddingBottomRight;
		slider.thumbOffset = -Math.round(this.dropShadowSize / 2);
		slider.customThumbStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_THUMB;
		slider.customMinimumTrackStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK;
		slider.width = this.smallControlSize + this.popUpVolumeSliderPaddingTopLeft + this.popUpVolumeSliderPaddingBottomRight;
		slider.height = this.wideControlSize + this.popUpVolumeSliderPaddingTopLeft + this.popUpVolumeSliderPaddingBottomRight;
	}

	private function setPopUpVolumeSliderTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.popUpVolumeSliderTrackSkinTextures;
		skinSelector.displayObjectProperties =
		{
			textureScale: this.scale
		};
		track.stateToSkinFunction = skinSelector.updateValue;

		track.hasLabelTextRenderer = false;
	}

//-------------------------
// VolumeSlider
//-------------------------

	private function setVolumeSliderStyles(slider:VolumeSlider):Void
	{
		slider.direction = VolumeSlider.DIRECTION_HORIZONTAL;
		slider.trackLayoutMode = VolumeSlider.TRACK_LAYOUT_MODE_MIN_MAX;
		slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		slider.focusPadding = this.focusPaddingSize;
		slider.showThumb = false;
		slider.minWidth = this.volumeSliderMinimumTrackSkinTexture.width * this.scale;
		slider.minHeight = this.volumeSliderMinimumTrackSkinTexture.height * this.scale;
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
		defaultSkin.textureScale = this.scale;
		track.defaultSkin = defaultSkin;

		track.hasLabelTextRenderer = false;
	}

	private function setVolumeSliderMaximumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.horizontalAlign = ImageLoader.HORIZONTAL_ALIGN_RIGHT;
		defaultSkin.source = this.volumeSliderMaximumTrackSkinTexture;
		defaultSkin.textureScale = this.scale;
		track.defaultSkin = defaultSkin;
		
		track.hasLabelTextRenderer = false;
	}
}
}
