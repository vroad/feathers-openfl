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
import feathers.controls.ScrollContainer;
import feathers.controls.ScrollText;
import feathers.controls.Scroller;
import feathers.controls.SimpleScrollBar;
import feathers.controls.Slider;
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
import feathers.controls.text.BitmapFontTextEditor;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.controls.text.StageTextTextEditor;
import feathers.core.FeathersControl;
import feathers.core.PopUpManager;
import feathers.display.Scale9Image;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import feathers.skins.SmartDisplayObjectStateValueSelector;
import feathers.skins.StandardIcons;
import feathers.system.DeviceCapabilities;
import feathers.text.BitmapFontTextFormat;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;
import feathers.utils.math.roundToNearest;

import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.textures.TextureSmoothing;

/**
 * The base class for the "Minimal" theme for mobile Feathers apps. Handles
 * everything except asset loading, which is left to subclasses.
 *
 * @see MinimalMobileTheme
 * @see MinimalMobileThemeWithAssetManager
 */
class BaseMinimalMobileTheme extends StyleNameFunctionTheme
{
	/**
	 * The name of the embedded bitmap font used by controls in this theme.
	 */
	inline public static var FONT_NAME:String = "PF Ronda Seven";

	/**
	 * @private
	 * The theme's custom style name for item renderers in a PickerList.
	 */
	private static const THEME_NAME_PICKER_LIST_ITEM_RENDERER:String = "minimal-mobile-picker-list-item-renderer";
	/**
	 * @private
	 * The theme's custom style name for the minimum track of a horizontal slider.
	 */
	private static const THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "minimal-mobile-horizontal-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a vertical slider.
	 */
	private static const THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "minimal-mobile-vertical-slider-minimum-track";

	private static const FONT_TEXTURE_NAME:String = "pf_ronda_seven_0";

	private static const SCALE_9_GRID:Rectangle = new Rectangle(9, 9, 2, 2);
	private static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
	private static const BUTTON_DOWN_SCALE_9_GRID:Rectangle = new Rectangle(9, 9, 1, 1);
	private static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
	private static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(25, 21, 1, 1);
	private static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 5, 3, 1);
	private static const LIST_ITEM_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
	private static const BACK_BUTTON_SCALE_REGION1:Int = 30;
	private static const BACK_BUTTON_SCALE_REGION2:Int = 1;
	private static const FORWARD_BUTTON_SCALE_REGION1:Int = 9;
	private static const FORWARD_BUTTON_SCALE_REGION2:Int = 1;

	private static const BACKGROUND_COLOR:UInt = 0xf3f3f3;
	private static const LIST_BACKGROUND_COLOR:UInt = 0xf8f8f8;
	private static const LIST_HEADER_BACKGROUND_COLOR:UInt = 0xeeeeee;
	private static const PRIMARY_TEXT_COLOR:UInt = 0x666666;
	private static const DISABLED_TEXT_COLOR:UInt = 0x999999;
	private static const MODAL_OVERLAY_COLOR:UInt = 0xcccccc;
	private static const MODAL_OVERLAY_ALPHA:Float = 0.4;

	/**
	 * The screen density of an iPhone with Retina display. The textures
	 * used by this theme are designed for this density and scale for other
	 * densities.
	 */
	private static const ORIGINAL_DPI_IPHONE_RETINA:Int = 326;

	/**
	 * The screen density of an iPad with Retina display. The textures used
	 * by this theme are designed for this density and scale for other
	 * densities.
	 */
	private static const ORIGINAL_DPI_IPAD_RETINA:Int = 264;

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
	 * StageTextTextEditor.
	 */
	private static function textEditorFactory():StageTextTextEditor
	{
		return new StageTextTextEditor();
	}

	/**
	 * The text editor factory for a NumericStepper creates a
	 * BitmapFontTextEditor.
	 */
	private static function numericStepperTextEditorFactory():BitmapFontTextEditor
	{
		//we're only using this text editor in the NumericStepper because
		//isEditable is false on the TextInput. this text editor is not
		//suitable for mobile use if the TextInput needs to be editable
		//because it can't use the soft keyboard or other mobile-friendly UI
		var editor:BitmapFontTextEditor = new BitmapFontTextEditor();
		//since it's a pixel font, we don't want to smooth it.
		editor.smoothing = TextureSmoothing.NONE;
		return editor;
	}

	private static function popUpOverlayFactory():DisplayObject
	{
		var quad:Quad = new Quad(100, 100, MODAL_OVERLAY_COLOR);
		quad.alpha = MODAL_OVERLAY_ALPHA;
		return quad;
	}

	/**
	 * This theme's scroll bar type is SimpleScrollBar.
	 */
	private static function scrollBarFactory():SimpleScrollBar
	{
		return new SimpleScrollBar();
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
	 * A normal font size.
	 */
	private var fontSize:Int;

	/**
	 * A larger font size for headers.
	 */
	private var largeFontSize:Int;

	/**
	 * A smaller font size for details.
	 */
	private var smallFontSize:Int;

	/**
	 * A special font size for text editing.
	 */
	private var inputFontSize:Int;

	/**
	 * The texture atlas that contains skins for this theme. This base class
	 * does not initialize this member variable. Subclasses are expected to
	 * load the assets somehow and set the <code>atlas</code> member
	 * variable before calling <code>initialize()</code>.
	 */
	private var atlas:TextureAtlas;

	private var buttonUpSkinTextures:Scale9Textures;
	private var buttonDownSkinTextures:Scale9Textures;
	private var buttonDisabledSkinTextures:Scale9Textures;
	private var buttonSelectedSkinTextures:Scale9Textures;
	private var buttonSelectedDisabledSkinTextures:Scale9Textures;
	private var buttonCallToActionUpSkinTextures:Scale9Textures;
	private var buttonDangerUpSkinTextures:Scale9Textures;
	private var buttonDangerDownSkinTextures:Scale9Textures;
	private var buttonBackUpSkinTextures:Scale3Textures;
	private var buttonBackDownSkinTextures:Scale3Textures;
	private var buttonBackDisabledSkinTextures:Scale3Textures;
	private var buttonForwardUpSkinTextures:Scale3Textures;
	private var buttonForwardDownSkinTextures:Scale3Textures;
	private var buttonForwardDisabledSkinTextures:Scale3Textures;

	private var tabDownSkinTextures:Scale9Textures;
	private var tabSelectedSkinTextures:Scale9Textures;
	private var tabSelectedDisabledSkinTextures:Scale9Textures;

	private var thumbSkinTextures:Scale9Textures;
	private var thumbDisabledSkinTextures:Scale9Textures;

	private var scrollBarThumbSkinTextures:Scale9Textures;

	private var insetBackgroundSkinTextures:Scale9Textures;
	private var insetBackgroundDisabledSkinTextures:Scale9Textures;

	private var dropDownArrowTexture:Texture;
	private var dropDownDisabledArrowTexture:Texture;
	private var searchIconTexture:Texture;
	private var searchIconDisabledTexture:Texture;

	private var listItemUpTextures:Scale9Textures;
	private var listItemDownTextures:Scale9Textures;
	private var listItemSelectedTextures:Scale9Textures;
	private var pickerListItemSelectedIconTexture:Texture;

	private var headerSkinTextures:Scale9Textures;

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

	private var pageIndicatorNormalSkinTexture:Texture;
	private var pageIndicatorSelectedSkinTexture:Texture;

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

	/**
	 * The size, in pixels, of a UI control's border.
	 */
	private var borderSize:Int;

	private var simpleScrollBarThumbSize:Int;
	private var calloutBorderPaddingSize:Int;
	private var calloutBackgroundMinSize:Int;
	private var popUpFillSize:Int;

	private var primaryTextFormat:BitmapFontTextFormat;
	private var disabledTextFormat:BitmapFontTextFormat;
	private var centeredTextFormat:BitmapFontTextFormat;
	private var centeredDisabledTextFormat:BitmapFontTextFormat;
	private var headingTextFormat:BitmapFontTextFormat;
	private var headingDisabledTextFormat:BitmapFontTextFormat;
	private var detailTextFormat:BitmapFontTextFormat;
	private var detailDisabledTextFormat:BitmapFontTextFormat;

	private var scrollTextTextFormat:TextFormat;
	private var scrollTextDisabledTextFormat:TextFormat;

	/**
	 * Disposes the texture atlas before calling super.dispose()
	 */
	override public function dispose():Void
	{
		if(this.atlas)
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
		this.initializeTextures();
		this.initializeFonts();
		this.initializeGlobals();
		this.initializeStage();
		this.initializeStyleProviders();
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
		PopUpManager.overlayFactory = popUpOverlayFactory;
		Callout.stagePadding = this.smallGutterSize;

		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		FeathersControl.defaultTextEditorFactory = textEditorFactory;
	}

	/**
	 * Initializes the scale value based on the screen density and content
	 * scale factor.
	 */
	private function initializeScale():Void
	{
		var scaledDPI:Int = DeviceCapabilities.dpi / Starling.current.contentScaleFactor;
		if(this._scaleToDPI)
		{
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
			}
			else
			{
				this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
			}
		}
		else
		{
			this._originalDPI = scaledDPI;
		}
		//our min scale is 0.25 because lines in the graphics are four
		//pixels wide and this will keep them crisp.
		this.scale = Math.max(0.25, scaledDPI / this._originalDPI);
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
		this.wideControlSize = this.gridSize * 3 + this.gutterSize * 2;
		this.borderSize = Math.round(4 * this.scale);
		this.simpleScrollBarThumbSize = Math.round(8 * this.scale);
		this.calloutBackgroundMinSize = Math.round(11 * this.scale);
		this.calloutBorderPaddingSize = -Math.round(8 * this.scale);
	}

	/**
	 * Initializes the textures by extracting them from the atlas and
	 * setting up any scaling grids that are needed.
	 */
	private function initializeTextures():Void
	{
		this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE_9_GRID);
		this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_DOWN_SCALE_9_GRID);
		this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE_9_GRID);
		this.buttonSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-skin"), BUTTON_DOWN_SCALE_9_GRID);
		this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), BUTTON_DOWN_SCALE_9_GRID);
		this.buttonCallToActionUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-call-to-action-up-skin"), BUTTON_SCALE_9_GRID);
		this.buttonDangerUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-up-skin"), BUTTON_SCALE_9_GRID);
		this.buttonDangerDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-danger-down-skin"), BUTTON_DOWN_SCALE_9_GRID);
		this.buttonBackUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-up-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonBackDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-down-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonBackDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-back-disabled-skin"), BACK_BUTTON_SCALE_REGION1, BACK_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonForwardUpSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-up-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonForwardDownSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-down-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.buttonForwardDisabledSkinTextures = new Scale3Textures(this.atlas.getTexture("button-forward-disabled-skin"), FORWARD_BUTTON_SCALE_REGION1, FORWARD_BUTTON_SCALE_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);

		this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE_9_GRID);
		this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"), TAB_SCALE_9_GRID);
		this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE_9_GRID);

		this.thumbSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-skin"), SCALE_9_GRID);
		this.thumbDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("thumb-disabled-skin"), SCALE_9_GRID);

		this.scrollBarThumbSkinTextures = new Scale9Textures(this.atlas.getTexture("scrollbar-thumb-skin"), SCROLLBAR_THUMB_SCALE_9_GRID);

		this.insetBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-skin"), SCALE_9_GRID);
		this.insetBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-background-disabled-skin"), SCALE_9_GRID);

		this.dropDownArrowTexture = this.atlas.getTexture("drop-down-arrow-icon");
		this.dropDownDisabledArrowTexture = this.atlas.getTexture("drop-down-arrow-icon-disabled");
		this.searchIconTexture = this.atlas.getTexture("search-icon");
		this.searchIconDisabledTexture = this.atlas.getTexture("search-icon-disabled");

		this.listItemUpTextures = new Scale9Textures(this.atlas.getTexture("list-item-up"), LIST_ITEM_SCALE_9_GRID);
		this.listItemDownTextures = new Scale9Textures(this.atlas.getTexture("list-item-down"), LIST_ITEM_SCALE_9_GRID);
		this.listItemSelectedTextures = new Scale9Textures(this.atlas.getTexture("list-item-selected"), LIST_ITEM_SCALE_9_GRID);
		this.pickerListItemSelectedIconTexture = this.atlas.getTexture("picker-list-item-selected-icon");

		this.headerSkinTextures = new Scale9Textures(this.atlas.getTexture("header-skin"), HEADER_SCALE_9_GRID);

		this.popUpBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("callout-background-skin"), BUTTON_SCALE_9_GRID);
		this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top");
		this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom");
		this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left");
		this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right");

		this.checkIconTexture = this.atlas.getTexture("check-icon");
		this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon");
		this.checkSelectedIconTexture = this.atlas.getTexture("check-selected-icon");
		this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

		this.radioIconTexture = this.atlas.getTexture("radio-icon");
		this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon");
		this.radioSelectedIconTexture = this.atlas.getTexture("radio-selected-icon");
		this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

		this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");
		this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");

		StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");
	}

	/**
	 * Initializes font sizes and formats.
	 */
	private function initializeFonts():Void
	{
		//since it's a pixel font, we want a multiple of the original size,
		//which, in this case, is 8.
		this.fontSize = Math.max(4, roundToNearest(24 * this.scale, 8));
		this.largeFontSize = Math.max(4, roundToNearest(32 * this.scale, 8));
		this.smallFontSize = Math.max(4, roundToNearest(16 * this.scale, 8));
		this.inputFontSize = 26 * this.scale;

		this.primaryTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR);
		this.disabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR);
		this.centeredTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, PRIMARY_TEXT_COLOR, TextFormatAlign.CENTER);
		this.centeredDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.fontSize, DISABLED_TEXT_COLOR, TextFormatAlign.CENTER);
		this.headingTextFormat = new BitmapFontTextFormat(FONT_NAME, this.largeFontSize, PRIMARY_TEXT_COLOR);
		this.headingDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.largeFontSize, DISABLED_TEXT_COLOR);
		this.detailTextFormat = new BitmapFontTextFormat(FONT_NAME, this.smallFontSize, PRIMARY_TEXT_COLOR);
		this.detailDisabledTextFormat = new BitmapFontTextFormat(FONT_NAME, this.smallFontSize, DISABLED_TEXT_COLOR);

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
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_HEADER, this.setPanelHeaderStyles);
		this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
		this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

		//button
		this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_BACK_BUTTON, this.setBackButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

		//button group
		this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_NAME_BUTTON, this.setButtonGroupButtonStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_NAME_BUTTON, this.setButtonGroupButtonStyles);

		//callout
		this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;

		//check
		this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;

		//check
		this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;

		//grouped list (see also: item renderers)
		this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
		this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

		//header
		this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

		//item renderers for lists
		this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_NAME_PICKER_LIST_ITEM_RENDERER, this.setPickerListItemRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
		this.getStyleProviderForClass(BitmapFontTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

		//header and footer renderers for grouped list
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);

		//label
		this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_HEADING, this.setHeadingLabelStyles);
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_DETAIL, this.setDetailLabelStyles);

		//list (see also: item renderers)
		this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

		//numeric stepper
		this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
		this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_DECREMENT_BUTTON, this.setNumericStepperButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_INCREMENT_BUTTON, this.setNumericStepperButtonStyles);

		//page indicator
		this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

		//panel
		this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_NAME_HEADER, this.setPanelHeaderStyles);

		//panel screen
		this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_NAME_HEADER, this.setPanelScreenHeaderStyles);

		//picker list (see also: item renderers)
		this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_BUTTON, this.setPickerListButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_BUTTON, this.setPickerListButtonStyles);
		this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_LIST, this.setNoStyles);

		//progress bar
		this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

		//radio
		this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

		//scroll container
		this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
		this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

		//scroll text
		this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

		//simple scroll bar
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB, this.setSimpleScrollBarThumbStyles);

		//slider
		this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_NAME_THUMB, this.setSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);

		//tab bar
		this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(TabBar.DEFAULT_CHILD_NAME_TAB, this.setTabStyles);

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
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
	}

	private function pageIndicatorNormalSymbolFactory():DisplayObject
	{
		var symbol:ImageLoader = new ImageLoader();
		symbol.source = this.pageIndicatorNormalSkinTexture;
		symbol.textureScale = this.scale;
		symbol.snapToPixels = true;
		return symbol;
	}

	private function pageIndicatorSelectedSymbolFactory():DisplayObject
	{
		var symbol:ImageLoader = new ImageLoader();
		symbol.source = this.pageIndicatorSelectedSkinTexture;
		symbol.textureScale = this.scale;
		symbol.snapToPixels = true;
		return symbol;
	}

	private function imageLoaderFactory():ImageLoader
	{
		var image:ImageLoader = new ImageLoader();
		image.smoothing = TextureSmoothing.NONE;
		image.textureScale = this.scale;
		return image;
	}

//-------------------------
// Shared
//-------------------------

	private function setNoStyles(target:DisplayObject):Void
	{
		//if this is assigned as a style function, chances are the target
		//will be a subcomponent of something. the style function for this
		//component's parent is probably handing the styling for the target
	}

	private function setScrollerStyles(scroller:Scroller):Void
	{
		scroller.horizontalScrollBarFactory = scrollBarFactory;
		scroller.verticalScrollBarFactory = scrollBarFactory;
	}

//-------------------------
// Alert
//-------------------------

	private function setAlertStyles(alert:Alert):Void
	{
		this.setScrollerStyles(alert);

		var backgroundSkin:Scale9Image = new Scale9Image(this.popUpBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.smallGutterSize;
		backgroundSkin.height = this.smallGutterSize;
		alert.backgroundSkin = backgroundSkin;

		alert.paddingTop = this.smallGutterSize;
		alert.paddingBottom = this.smallGutterSize;
		alert.paddingLeft = this.gutterSize;
		alert.paddingRight = this.gutterSize;
		alert.gap = this.gutterSize;

		alert.maxWidth = this.popUpFillSize;
		alert.maxHeight = this.popUpFillSize;
	}

	private function setAlertButtonGroupStyles(group:ButtonGroup):Void
	{
		group.direction = ButtonGroup.DIRECTION_VERTICAL;
		group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_JUSTIFY;
		group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
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
		button.defaultLabelProperties.textFormat = this.primaryTextFormat;
		button.disabledLabelProperties.textFormat = this.disabledTextFormat;
		if(Std.is(button, ToggleButton))
		{
			ToggleButton(button).selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;
		}

		button.paddingTop = this.smallGutterSize;
		button.paddingBottom = this.smallGutterSize;
		button.paddingLeft = this.gutterSize;
		button.paddingRight = this.gutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
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
	}

	private function setQuietButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(null, Button.STATE_DISABLED, false);
		if(Std.is(button, ToggleButton))
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
			textureScale: this.scale
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
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
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
			skinSelector.defaultSelectedValue = this.buttonSelectedSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		}
		skinSelector.displayObjectProperties =
		{
			width: this.gridSize,
			height: this.gridSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.defaultLabelProperties.textFormat = this.primaryTextFormat;
		button.disabledLabelProperties.textFormat = this.disabledTextFormat;
		if(Std.is(button, ToggleButton))
		{
			ToggleButton(button).selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;
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
		callout.minWidth = this.calloutBackgroundMinSize;
		callout.minHeight = this.calloutBackgroundMinSize;
		callout.padding = this.smallGutterSize;
		var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.calloutBackgroundMinSize;
		backgroundSkin.height = this.calloutBackgroundMinSize;
		callout.backgroundSkin = backgroundSkin;

		var topArrowSkin:Image = new Image(calloutTopArrowSkinTexture);
		topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;
		callout.topArrowSkin = topArrowSkin;
		callout.topArrowGap = this.calloutBorderPaddingSize;

		var bottomArrowSkin:Image = new Image(calloutBottomArrowSkinTexture);
		bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;
		callout.bottomArrowSkin = bottomArrowSkin;
		callout.bottomArrowGap = this.calloutBorderPaddingSize;

		var leftArrowSkin:Image = new Image(calloutLeftArrowSkinTexture);
		leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;
		callout.leftArrowSkin = leftArrowSkin;
		callout.leftArrowGap = this.calloutBorderPaddingSize;

		var rightArrowSkin:Image = new Image(calloutRightArrowSkinTexture);
		rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;
		callout.rightArrowSkin = rightArrowSkin;
		callout.rightArrowGap = this.calloutBorderPaddingSize;
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
			snapToPixels: true
		};
		check.stateToIconFunction = iconSelector.updateValue;

		check.defaultLabelProperties.textFormat = this.primaryTextFormat;
		check.disabledLabelProperties.textFormat = this.disabledTextFormat;
		check.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

		check.gap = this.smallGutterSize;
		check.minWidth = this.controlSize;
		check.minHeight = this.controlSize;
		check.minTouchWidth = this.gridSize;
		check.minTouchHeight = this.gridSize;
		check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
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

		var backgroundSkin:Quad = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
		list.backgroundSkin = backgroundSkin;
	}

	//see List section for item renderer styles

	private function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.backgroundSkin = new Quad(1, 1, LIST_HEADER_BACKGROUND_COLOR);

		renderer.contentLabelProperties.textFormat = this.primaryTextFormat;
		renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;

		renderer.contentLoaderFactory = this.imageLoaderFactory;
	}

	private function setInsetGroupedListStyles(list:GroupedList):Void
	{
		this.setScrollerStyles(list);

		list.headerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER;
		list.footerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER;

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
		renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

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
		header.padding = this.smallGutterSize;
		header.gap = this.smallGutterSize;
		header.titleGap = this.smallGutterSize;

		var backgroundSkin:Scale9Image = new Scale9Image(headerSkinTextures, this.scale);
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

	private function setDetailLabelStyles(label:Label):Void
	{
		label.textRendererProperties.textFormat = this.detailTextFormat;
		label.textRendererProperties.disabledTextFormat = this.detailDisabledTextFormat;
	}

//-------------------------
// List
//-------------------------

	private function setListStyles(list:List):Void
	{
		this.setScrollerStyles(list);

		list.backgroundSkin = new Quad(this.gridSize, this.gridSize, LIST_BACKGROUND_COLOR);
	}

	private function setItemRendererStyles(renderer:BaseDefaultItemRenderer):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.listItemUpTextures;
		skinSelector.defaultSelectedValue = this.listItemSelectedTextures;
		skinSelector.setValueForState(this.listItemDownTextures, Button.STATE_DOWN, false);
		skinSelector.displayObjectProperties =
		{
			width: this.gridSize,
			height: this.gridSize,
			textureScale: this.scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		renderer.defaultLabelProperties.textFormat = this.primaryTextFormat;
		renderer.disabledLabelProperties.textFormat = this.disabledTextFormat;
		renderer.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.gap = this.gutterSize;
		renderer.minGap = this.gutterSize;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.gutterSize;
		renderer.minWidth = this.gridSize;
		renderer.minHeight = this.gridSize;
		renderer.minTouchWidth = this.gridSize;
		renderer.minTouchHeight = this.gridSize;
		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

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
	}

	private function setNumericStepperTextInputStyles(input:TextInput):Void
	{
		input.minWidth = this.controlSize;
		input.minHeight = this.controlSize;
		input.minTouchWidth = this.gridSize;
		input.minTouchHeight = this.gridSize;
		input.gap = this.smallGutterSize;
		input.padding = this.smallGutterSize;
		input.isEditable = false;
		input.textEditorFactory = numericStepperTextEditorFactory;
		input.textEditorProperties.textFormat = this.centeredTextFormat;
		input.textEditorProperties.disabledTextFormat = this.centeredDisabledTextFormat;

		var backgroundSkin:Scale9Image = new Scale9Image(insetBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.controlSize;
		backgroundSkin.height = this.controlSize;
		input.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(insetBackgroundDisabledSkinTextures, this.scale);
		backgroundDisabledSkin.width = this.controlSize;
		backgroundDisabledSkin.height = this.controlSize;
		input.backgroundDisabledSkin = backgroundDisabledSkin;
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

		var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.smallControlSize;
		backgroundSkin.height = this.smallControlSize;
		panel.backgroundSkin = backgroundSkin;

		panel.padding = this.smallGutterSize;
	}

	private function setPanelHeaderStyles(header:Header):Void
	{
		header.minWidth = this.gridSize;
		header.minHeight = this.gridSize;
		header.padding = this.smallGutterSize;
		header.gap = this.smallGutterSize;
		header.titleGap = this.smallGutterSize;

		var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
		backgroundSkin.width = this.gridSize;
		backgroundSkin.height = this.gridSize;
		header.backgroundSkin = backgroundSkin;

		header.titleProperties.textFormat = this.primaryTextFormat;
		header.titleProperties.disabledTextFormat = this.disabledTextFormat;
	}

//-------------------------
// PanelScreen
//-------------------------

	private function setPanelScreenHeaderStyles(header:Header):Void
	{
		this.setPanelHeaderStyles(header);
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
		list.listProperties.layout = layout;
		list.listProperties.verticalScrollPolicy = List.SCROLL_POLICY_ON;

		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			list.listProperties.minWidth = this.popUpFillSize;
			list.listProperties.maxHeight = this.popUpFillSize;
		}
		else
		{
			var backgroundSkin:Scale9Image = new Scale9Image(popUpBackgroundSkinTextures, this.scale);
			backgroundSkin.width = this.gridSize;
			backgroundSkin.height = this.gridSize;
			list.listProperties.backgroundSkin = backgroundSkin;
			list.listProperties.padding = this.borderSize;
		}

		list.listProperties.itemRendererName = THEME_NAME_PICKER_LIST_ITEM_RENDERER;
	}

	private function setPickerListItemRendererStyles(renderer:BaseDefaultItemRenderer):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.listItemUpTextures;
		skinSelector.setValueForState(this.listItemDownTextures, Button.STATE_DOWN, false);
		skinSelector.displayObjectProperties =
		{
			width: this.gridSize,
			height: this.gridSize,
			textureScale: this.scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		var defaultSelectedIcon:ImageLoader = new ImageLoader();
		defaultSelectedIcon.source = this.pickerListItemSelectedIconTexture;
		defaultSelectedIcon.textureScale = this.scale;
		defaultSelectedIcon.snapToPixels = true;
		renderer.defaultSelectedIcon = defaultSelectedIcon;

		var frame:Rectangle = this.pickerListItemSelectedIconTexture.frame;
		if(frame)
		{
			var iconWidth:Float = frame.width;
			var iconHeight:Float = frame.height;
		}
		else
		{
			iconWidth = this.pickerListItemSelectedIconTexture.width;
			iconHeight = this.pickerListItemSelectedIconTexture.height;
		}
		var defaultIcon:Quad = new Quad(iconWidth, iconHeight, 0xff00ff);
		defaultIcon.alpha = 0;
		renderer.defaultIcon = defaultIcon;

		renderer.defaultLabelProperties.textFormat = this.primaryTextFormat;
		renderer.disabledLabelProperties.textFormat = this.disabledTextFormat;
		renderer.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.gap = Math.POSITIVE_INFINITY;
		renderer.minGap = this.gutterSize;
		renderer.iconPosition = Button.ICON_POSITION_RIGHT;
		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
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

	private function setPickerListButtonStyles(button:Button):Void
	{
		//we're going to expand on the standard button styles
		this.setButtonStyles(button);

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.dropDownArrowTexture;
		iconSelector.setValueForState(this.dropDownDisabledArrowTexture, Button.STATE_DISABLED, false);
		iconSelector.setValueForState(this.dropDownDisabledArrowTexture, Button.STATE_DISABLED, true);
		iconSelector.displayObjectProperties =
		{
			textureScale: this.scale,
			snapToPixels: true
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.gap = Math.POSITIVE_INFINITY; //fill as completely as possible
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
			fillSkin.width = this.smallGutterSize;
			fillSkin.height = this.borderSize;
		}
		else
		{
			fillSkin.width = this.borderSize;
			fillSkin.height = this.smallGutterSize;
		}
		progress.fillSkin = fillSkin;

		var fillDisabledSkin:Scale9Image = new Scale9Image(buttonDisabledSkinTextures, this.scale);
		if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
		{
			fillDisabledSkin.width = this.smallGutterSize;
			fillDisabledSkin.height = this.borderSize;
		}
		else
		{
			fillDisabledSkin.width = this.borderSize;
			fillDisabledSkin.height = this.smallGutterSize;
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

		radio.defaultLabelProperties.textFormat = this.primaryTextFormat;
		radio.disabledLabelProperties.textFormat = this.disabledTextFormat;
		radio.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

		radio.gap = this.smallGutterSize;
		radio.minWidth = this.controlSize;
		radio.minHeight = this.controlSize;
		radio.minTouchWidth = this.gridSize;
		radio.minTouchHeight = this.gridSize;
		radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
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
			layout.padding = this.smallGutterSize;
			layout.gap = this.smallGutterSize;
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

	private function setSimpleScrollBarThumbStyles(thumb:Button):Void
	{
		var defaultSkin:Scale9Image = new Scale9Image(scrollBarThumbSkinTextures, this.scale);
		defaultSkin.width = this.simpleScrollBarThumbSize;
		defaultSkin.height = this.simpleScrollBarThumbSize;
		thumb.defaultSkin = defaultSkin;

		thumb.minTouchWidth = this.smallControlSize;
		thumb.minTouchHeight = this.smallControlSize;

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
			slider.customMinimumTrackName = THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
		}
		else //horizontal
		{
			slider.customMinimumTrackName = THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
		}
	}

	private function setHorizontalSliderMinimumTrackStyles(track:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.displayObjectProperties =
		{
			width: this.wideControlSize,
			height: this.controlSize,
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
			width: this.controlSize,
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
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		thumb.stateToSkinFunction = skinSelector.updateValue;
		thumb.minTouchWidth = this.gridSize;
		thumb.minTouchHeight = this.gridSize;

		thumb.hasLabelTextRenderer = false;
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
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.headerSkinTextures;
		skinSelector.defaultSelectedValue = this.tabSelectedSkinTextures;
		skinSelector.setValueForState(this.tabDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		skinSelector.displayObjectProperties =
		{
			width: this.gridSize,
			height: this.gridSize,
			textureScale: this.scale
		};
		tab.stateToSkinFunction = skinSelector.updateValue;

		tab.defaultLabelProperties.textFormat = this.primaryTextFormat;
		tab.disabledLabelProperties.textFormat = this.disabledTextFormat;
		tab.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

		tab.iconPosition = Button.ICON_POSITION_TOP;
		tab.padding = this.gutterSize;
		tab.gap = this.smallGutterSize;
		tab.minGap = this.smallGutterSize;
		tab.minWidth = this.gridSize;
		tab.minHeight = this.gridSize;
		tab.minTouchWidth = this.gridSize;
		tab.minTouchHeight = this.gridSize;
	}

//-------------------------
// TextArea
//-------------------------

	private function setTextAreaStyles(textArea:TextArea):Void
	{
		this.setScrollerStyles(textArea);

		textArea.textEditorProperties.textFormat = this.scrollTextTextFormat;
		textArea.textEditorProperties.disabledTextFormat = this.scrollTextDisabledTextFormat;

		textArea.padding = this.smallGutterSize;

		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextArea.STATE_DISABLED);
		skinSelector.displayObjectProperties =
		{
			width: this.wideControlSize,
			height: this.controlSize * 2,
			textureScale: this.scale
		};
		textArea.stateToSkinFunction = skinSelector.updateValue;
	}

//-------------------------
// TextInput
//-------------------------

	private function setBaseTextInputStyles(input:TextInput):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.insetBackgroundSkinTextures;
		skinSelector.setValueForState(this.insetBackgroundDisabledSkinTextures, TextArea.STATE_DISABLED);
		skinSelector.displayObjectProperties =
		{
			width: this.wideControlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		input.stateToSkinFunction = skinSelector.updateValue;

		input.minWidth = this.controlSize;
		input.minHeight = this.controlSize;
		input.minTouchWidth = this.gridSize;
		input.minTouchHeight = this.gridSize;
		input.gap = this.smallGutterSize;
		input.padding = this.smallGutterSize;

		input.textEditorProperties.fontFamily = "_sans";
		input.textEditorProperties.fontSize = this.inputFontSize;
		input.textEditorProperties.color = PRIMARY_TEXT_COLOR;
		input.textEditorProperties.disabledColor = DISABLED_TEXT_COLOR;

		input.promptProperties.textFormat = this.primaryTextFormat;
		input.promptProperties.disabledTextFormat = this.disabledTextFormat;
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
		toggleSwitch.disabledLabelProperties.textFormat = this.disabledTextFormat;
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
		track.minTouchWidth = this.gridSize;
		track.minTouchHeight = this.gridSize;

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
		thumb.minTouchWidth = this.gridSize;
		thumb.minTouchHeight = this.gridSize;

		thumb.hasLabelTextRenderer = false;
	}
}
