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
package feathers.themes
{
	import feathers.controls.Alert;
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
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.skins.StandardIcons;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;

	import openfl.geom.Rectangle;
	import openfl.text.TextFormat;
	import openfl.text.TextFormatAlign;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.ConcreteTexture;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * The base class for the "Aeon" theme for desktop Feathers apps. Handles
	 * everything except asset loading, which is left to subclasses.
	 *
	 * @see AeonDesktopTheme
	 * @see AeonDesktopThemeWithAssetManager
	 */
	public class BaseAeonDesktopTheme extends StyleNameFunctionTheme
	{
		/**
		 * @private
		 * The theme's custom style name for the increment button of a horizontal ScrollBar.
		 */
		private static const THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-increment-button";

		/**
		 * @private
		 * The theme's custom style name for the decrement button of a horizontal ScrollBar.
		 */
		private static const THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-decrement-button";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal ScrollBar.
		 */
		private static const THEME_NAME_HORIZONTAL_SCROLL_BAR_THUMB:String = "aeon-horizontal-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal ScrollBar.
		 */
		private static const THEME_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-horizontal-scroll-bar-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the increment button of a vertical ScrollBar.
		 */
		private static const THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-vertical-scroll-bar-increment-button";

		/**
		 * @private
		 * The theme's custom style name for the decrement button of a vertical ScrollBar.
		 */
		private static const THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-vertical-scroll-bar-decrement-button";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical ScrollBar.
		 */
		private static const THEME_NAME_VERTICAL_SCROLL_BAR_THUMB:String = "aeon-vertical-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical ScrollBar.
		 */
		private static const THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-vertical-scroll-bar-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal SimpleScrollBar.
		 */
		private static const THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-horizontal-simple-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical SimpleScrollBar.
		 */
		private static const THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-vertical-simple-scroll-bar-thumb";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a horizontal Slider.
		 */
		private static const THEME_NAME_HORIZONTAL_SLIDER_THUMB:String = "aeon-horizontal-slider-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a horizontal Slider.
		 */
		private static const THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "aeon-horizontal-slider-minimum-track";

		/**
		 * @private
		 * The theme's custom style name for the thumb of a vertical Slider.
		 */
		private static const THEME_NAME_VERTICAL_SLIDER_THUMB:String = "aeon-vertical-slider-thumb";

		/**
		 * @private
		 * The theme's custom style name for the minimum track of a vertical Slider.
		 */
		private static const THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "aeon-vertical-slider-minimum-track";

		/**
		 * The name of the font used by controls in this theme. This font is not
		 * embedded. It is the default sans-serif system font.
		 */
		inline public static var FONT_NAME:String = "_sans";

		private static const FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5, 4, 1, 14);
		private static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(6, 6, 70, 10);
		private static const SELECTED_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(6, 6, 52, 10);
		private static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 55, 16);
		private static const STEPPER_INCREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 9, 15, 1);
		private static const STEPPER_DECREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 15, 1);
		private static const HSLIDER_FIRST_REGION:Float = 2;
		private static const HSLIDER_SECOND_REGION:Float = 75;
		private static const TEXT_INPUT_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 148, 18);
		private static const VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(2, 5, 6, 42);
		private static const VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(2, 1, 11, 2);
		private static const VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 11, 10);
		private static const HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(5, 2, 42, 6);
		private static const HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(1, 2, 2, 11);
		private static const HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 10, 11);
		private static const SIMPLE_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 2, 2);
		private static const PANEL_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(6, 6, 2, 2);
		private static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(0, 0, 4, 28);

		private static const BACKGROUND_COLOR:uint = 0x869CA7;
		private static const MODAL_OVERLAY_COLOR:uint = 0xDDDDDD;
		private static const PRIMARY_TEXT_COLOR:uint = 0x0B333C;
		private static const DISABLED_TEXT_COLOR:uint = 0x5B6770;
		private static const MODAL_OVERLAY_ALPHA:Float = 0.5;

		/**
		 * The default global text renderer factory for this theme creates a
		 * TextFieldTextRenderer.
		 */
		private static function textRendererFactory():ITextRenderer
		{
			return new TextFieldTextRenderer();
		}

		/**
		 * The default global text editor factory for this theme creates a
		 * TextFieldTextEditor.
		 */
		private static function textEditorFactory():ITextEditor
		{
			return new TextFieldTextEditor();
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

		private var calloutBackgroundMinSize:Int;
		private var progressBarFillMinSize:Int;
		private var popUpSize:Int;

		/**
		 * The texture atlas that contains skins for this theme. This base class
		 * does not initialize this member variable. Subclasses are expected to
		 * load the assets somehow and set the <code>atlas</code> member
		 * variable before calling <code>initialize()</code>.
		 */
		private var atlas:TextureAtlas;

		/**
		 * A TextFormat for most UI controls and text.
		 */
		private var defaultTextFormat:TextFormat;

		/**
		 * A TextFormat for most disabled UI controls and text.
		 */
		private var disabledTextFormat:TextFormat;

		/**
		 * A TextFormat for larger text.
		 */
		private var headingTextFormat:TextFormat;

		/**
		 * A TextFormat for larger, disabled text.
		 */
		private var headingDisabledTextFormat:TextFormat;

		/**
		 * A TextFormat for smaller text.
		 */
		private var detailTextFormat:TextFormat;

		/**
		 * A TextFormat for smaller, disabled text.
		 */
		private var detailDisabledTextFormat:TextFormat;

		private var focusIndicatorSkinTextures:Scale9Textures;

		private var buttonUpSkinTextures:Scale9Textures;
		private var buttonHoverSkinTextures:Scale9Textures;
		private var buttonDownSkinTextures:Scale9Textures;
		private var buttonDisabledSkinTextures:Scale9Textures;
		private var buttonSelectedUpSkinTextures:Scale9Textures;
		private var buttonSelectedHoverSkinTextures:Scale9Textures;
		private var buttonSelectedDownSkinTextures:Scale9Textures;
		private var buttonSelectedDisabledSkinTextures:Scale9Textures;

		private var tabUpSkinTextures:Scale9Textures;
		private var tabHoverSkinTextures:Scale9Textures;
		private var tabDownSkinTextures:Scale9Textures;
		private var tabDisabledSkinTextures:Scale9Textures;
		private var tabSelectedUpSkinTextures:Scale9Textures;
		private var tabSelectedDisabledSkinTextures:Scale9Textures;

		private var stepperIncrementButtonUpSkinTextures:Scale9Textures;
		private var stepperIncrementButtonHoverSkinTextures:Scale9Textures;
		private var stepperIncrementButtonDownSkinTextures:Scale9Textures;
		private var stepperIncrementButtonDisabledSkinTextures:Scale9Textures;

		private var stepperDecrementButtonUpSkinTextures:Scale9Textures;
		private var stepperDecrementButtonHoverSkinTextures:Scale9Textures;
		private var stepperDecrementButtonDownSkinTextures:Scale9Textures;
		private var stepperDecrementButtonDisabledSkinTextures:Scale9Textures;

		private var hSliderThumbUpSkinTexture:Texture;
		private var hSliderThumbHoverSkinTexture:Texture;
		private var hSliderThumbDownSkinTexture:Texture;
		private var hSliderThumbDisabledSkinTexture:Texture;
		private var hSliderTrackSkinTextures:Scale3Textures;

		private var vSliderThumbUpSkinTexture:Texture;
		private var vSliderThumbHoverSkinTexture:Texture;
		private var vSliderThumbDownSkinTexture:Texture;
		private var vSliderThumbDisabledSkinTexture:Texture;
		private var vSliderTrackSkinTextures:Scale3Textures;

		private var itemRendererUpSkinTexture:Texture;
		private var itemRendererHoverSkinTexture:Texture;
		private var itemRendererSelectedUpSkinTexture:Texture;

		private var headerBackgroundSkinTextures:Scale9Textures;
		private var groupedListHeaderBackgroundSkinTextures:Scale9Textures;

		private var checkUpIconTexture:Texture;
		private var checkHoverIconTexture:Texture;
		private var checkDownIconTexture:Texture;
		private var checkDisabledIconTexture:Texture;
		private var checkSelectedUpIconTexture:Texture;
		private var checkSelectedHoverIconTexture:Texture;
		private var checkSelectedDownIconTexture:Texture;
		private var checkSelectedDisabledIconTexture:Texture;

		private var radioUpIconTexture:Texture;
		private var radioHoverIconTexture:Texture;
		private var radioDownIconTexture:Texture;
		private var radioDisabledIconTexture:Texture;
		private var radioSelectedUpIconTexture:Texture;
		private var radioSelectedHoverIconTexture:Texture;
		private var radioSelectedDownIconTexture:Texture;
		private var radioSelectedDisabledIconTexture:Texture;

		private var pageIndicatorNormalSkinTexture:Texture;
		private var pageIndicatorSelectedSkinTexture:Texture;

		private var pickerListUpIconTexture:Texture;
		private var pickerListHoverIconTexture:Texture;
		private var pickerListDownIconTexture:Texture;
		private var pickerListDisabledIconTexture:Texture;

		private var textInputBackgroundSkinTextures:Scale9Textures;
		private var textInputBackgroundDisabledSkinTextures:Scale9Textures;
		private var textInputSearchIconTexture:Texture;
		private var textInputSearchIconDisabledTexture:Texture;

		private var vScrollBarThumbUpSkinTextures:Scale9Textures;
		private var vScrollBarThumbHoverSkinTextures:Scale9Textures;
		private var vScrollBarThumbDownSkinTextures:Scale9Textures;
		private var vScrollBarTrackSkinTextures:Scale9Textures;
		private var vScrollBarThumbIconTexture:Texture;
		private var vScrollBarStepButtonUpSkinTextures:Scale9Textures;
		private var vScrollBarStepButtonHoverSkinTextures:Scale9Textures;
		private var vScrollBarStepButtonDownSkinTextures:Scale9Textures;
		private var vScrollBarStepButtonDisabledSkinTextures:Scale9Textures;
		private var vScrollBarDecrementButtonIconTexture:Texture;
		private var vScrollBarIncrementButtonIconTexture:Texture;

		private var hScrollBarThumbUpSkinTextures:Scale9Textures;
		private var hScrollBarThumbHoverSkinTextures:Scale9Textures;
		private var hScrollBarThumbDownSkinTextures:Scale9Textures;
		private var hScrollBarTrackSkinTextures:Scale9Textures;
		private var hScrollBarThumbIconTexture:Texture;
		private var hScrollBarStepButtonUpSkinTextures:Scale9Textures;
		private var hScrollBarStepButtonHoverSkinTextures:Scale9Textures;
		private var hScrollBarStepButtonDownSkinTextures:Scale9Textures;
		private var hScrollBarStepButtonDisabledSkinTextures:Scale9Textures;
		private var hScrollBarDecrementButtonIconTexture:Texture;
		private var hScrollBarIncrementButtonIconTexture:Texture;

		private var simpleBorderBackgroundSkinTextures:Scale9Textures;
		private var panelBorderBackgroundSkinTextures:Scale9Textures;

		private var progressBarFillSkinTexture:Texture;

		/**
		 * Disposes the texture atlas before calling super.dispose()
		 */
		override public function dispose():void
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
		private function initialize():void
		{
			this.initializeScale();
			this.initializeDimensions();
			this.initializeFonts();
			this.initializeTextures();
			this.initializeGlobals()
			this.initializeStage();
			this.initializeStyleProviders();
		}

		/**
		 * Initializes the value used for scaling things like textures and font
		 * sizes.
		 */
		private function initializeScale():void
		{
			//Starling automatically accounts for the contentScaleFactor on Mac
			//HiDPI screens, and converts pixels to points, so we don't need to
			//do any scaling for that.
			this.scale = 1;
		}

		/**
		 * Initializes common values used for setting the dimensions of components.
		 */
		private function initializeDimensions():void
		{
			this.gridSize = Math.round(30 * this.scale);
			this.extraSmallGutterSize = Math.round(2 * this.scale);
			this.smallGutterSize = Math.round(6 * this.scale);
			this.gutterSize = Math.round(10 * this.scale);
			this.borderSize = Math.max(1, Math.round(1 * this.scale));
			this.controlSize = Math.round(22 * this.scale);
			this.smallControlSize = Math.round(12 * this.scale);
			this.calloutBackgroundMinSize = Math.round(5 * this.scale);
			this.progressBarFillMinSize = Math.round(7 * this.scale);
			this.buttonMinWidth = Math.round(40 * this.scale);
			this.wideControlSize = Math.round(152 * this.scale);
			this.popUpSize = this.gridSize * 10 + this.smallGutterSize * 9;
		}

		/**
		 * Sets the stage background color.
		 */
		private function initializeStage():void
		{
			Starling.current.stage.color = BACKGROUND_COLOR;
			Starling.current.nativeStage.color = BACKGROUND_COLOR;
		}

		/**
		 * Initializes global variables (not including global style providers).
		 */
		private function initializeGlobals():void
		{
			FocusManager.setEnabledForStage(Starling.current.stage, true);

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			PopUpManager.overlayFactory = popUpOverlayFactory;
			Callout.stagePadding = this.smallGutterSize;
		}

		/**
		 * Initializes font sizes and formats.
		 */
		private function initializeFonts():void
		{
			this.smallFontSize = Math.round(10 * this.scale);
			this.regularFontSize = Math.round(11 * this.scale);
			this.largeFontSize = Math.round(13 * this.scale);

			this.defaultTextFormat = new TextFormat(FONT_NAME, this.regularFontSize, PRIMARY_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.disabledTextFormat = new TextFormat(FONT_NAME, this.regularFontSize, DISABLED_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.headingTextFormat = new TextFormat(FONT_NAME, this.largeFontSize, PRIMARY_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.headingDisabledTextFormat = new TextFormat(FONT_NAME, this.largeFontSize, DISABLED_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.detailTextFormat = new TextFormat(FONT_NAME, this.smallFontSize, PRIMARY_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
			this.detailDisabledTextFormat = new TextFormat(FONT_NAME, this.smallFontSize, DISABLED_TEXT_COLOR, false, false, false, null, null, TextFormatAlign.LEFT, 0, 0, 0, 0);
		}

		/**
		 * Initializes the textures by extracting them from the atlas and
		 * setting up any scaling grids that are needed.
		 */
		private function initializeTextures():void
		{
			this.focusIndicatorSkinTextures = new Scale9Textures(this.atlas.getTexture("focus-indicator-skin"), FOCUS_INDICATOR_SCALE_9_GRID);

			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin"), BUTTON_SCALE_9_GRID);
			this.buttonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("button-hover-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_SCALE_9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE_9_GRID);
			this.buttonSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-up-skin"), SELECTED_BUTTON_SCALE_9_GRID);
			this.buttonSelectedHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-hover-skin"), SELECTED_BUTTON_SCALE_9_GRID);
			this.buttonSelectedDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-down-skin"), SELECTED_BUTTON_SCALE_9_GRID);
			this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), SELECTED_BUTTON_SCALE_9_GRID);

			this.tabUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-up-skin"), TAB_SCALE_9_GRID);
			this.tabHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-hover-skin"), TAB_SCALE_9_GRID);
			this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE_9_GRID);
			this.tabDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-disabled-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-up-skin"), TAB_SCALE_9_GRID);
			this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin"), TAB_SCALE_9_GRID);

			this.stepperIncrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-up-skin"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
			this.stepperIncrementButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-hover-skin"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
			this.stepperIncrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-down-skin"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
			this.stepperIncrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-disabled-skin"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);

			this.stepperDecrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-up-skin"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
			this.stepperDecrementButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-hover-skin"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
			this.stepperDecrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-down-skin"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
			this.stepperDecrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-disabled-skin"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);

			this.hSliderThumbUpSkinTexture = this.atlas.getTexture("hslider-thumb-up-skin");
			this.hSliderThumbHoverSkinTexture = this.atlas.getTexture("hslider-thumb-hover-skin");
			this.hSliderThumbDownSkinTexture = this.atlas.getTexture("hslider-thumb-down-skin");
			this.hSliderThumbDisabledSkinTexture = this.atlas.getTexture("hslider-thumb-disabled-skin");
			this.hSliderTrackSkinTextures = new Scale3Textures(this.atlas.getTexture("hslider-track-skin"), HSLIDER_FIRST_REGION, HSLIDER_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);

			this.vSliderThumbUpSkinTexture = this.atlas.getTexture("vslider-thumb-up-skin");
			this.vSliderThumbHoverSkinTexture = this.atlas.getTexture("vslider-thumb-hover-skin");
			this.vSliderThumbDownSkinTexture = this.atlas.getTexture("vslider-thumb-down-skin");
			this.vSliderThumbDisabledSkinTexture = this.atlas.getTexture("vslider-thumb-disabled-skin");
			this.vSliderTrackSkinTextures = new Scale3Textures(this.atlas.getTexture("vslider-track-skin"), HSLIDER_FIRST_REGION, HSLIDER_SECOND_REGION, Scale3Textures.DIRECTION_VERTICAL);

			this.itemRendererUpSkinTexture = this.atlas.getTexture("item-renderer-up-skin");
			this.itemRendererHoverSkinTexture = this.atlas.getTexture("item-renderer-hover-skin");
			this.itemRendererSelectedUpSkinTexture = this.atlas.getTexture("item-renderer-selected-up-skin");

			this.headerBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("header-background-skin"), HEADER_SCALE_9_GRID);
			this.groupedListHeaderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("grouped-list-header-background-skin"), HEADER_SCALE_9_GRID);

			this.checkUpIconTexture = this.atlas.getTexture("check-up-icon");
			this.checkHoverIconTexture = this.atlas.getTexture("check-hover-icon");
			this.checkDownIconTexture = this.atlas.getTexture("check-down-icon");
			this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon");
			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon");
			this.checkSelectedHoverIconTexture = this.atlas.getTexture("check-selected-hover-icon");
			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon");
			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");

			this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon");
			this.radioHoverIconTexture = this.atlas.getTexture("radio-hover-icon");
			this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon");
			this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon");
			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon");
			this.radioSelectedHoverIconTexture = this.atlas.getTexture("radio-selected-hover-icon");
			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon");
			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");
			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");

			this.pickerListUpIconTexture = this.atlas.getTexture("picker-list-up-icon");
			this.pickerListHoverIconTexture = this.atlas.getTexture("picker-list-hover-icon");
			this.pickerListDownIconTexture = this.atlas.getTexture("picker-list-down-icon");
			this.pickerListDisabledIconTexture = this.atlas.getTexture("picker-list-disabled-icon");

			this.textInputBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("text-input-background-skin"), TEXT_INPUT_SCALE_9_GRID);
			this.textInputBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("text-input-background-disabled-skin"), TEXT_INPUT_SCALE_9_GRID);
			this.textInputSearchIconTexture = this.atlas.getTexture("search-icon");
			this.textInputSearchIconDisabledTexture = this.atlas.getTexture("search-icon-disabled");

			this.vScrollBarThumbUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-up-skin"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.vScrollBarThumbHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-hover-skin"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.vScrollBarThumbDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-down-skin"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.vScrollBarTrackSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-track-skin"), VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID);
			this.vScrollBarThumbIconTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-icon");
			this.vScrollBarStepButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-up-skin"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.vScrollBarStepButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-hover-skin"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.vScrollBarStepButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-down-skin"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.vScrollBarStepButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-disabled-skin"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.vScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon");
			this.vScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon");

			this.hScrollBarThumbUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-up-skin"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.hScrollBarThumbHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-hover-skin"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.hScrollBarThumbDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-down-skin"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
			this.hScrollBarTrackSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-track-skin"), HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID);
			this.hScrollBarThumbIconTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-icon");
			this.hScrollBarStepButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-up-skin"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.hScrollBarStepButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-hover-skin"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.hScrollBarStepButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-down-skin"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.hScrollBarStepButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-disabled-skin"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
			this.hScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon");
			this.hScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon");

			this.simpleBorderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("simple-border-background-skin"), SIMPLE_BORDER_SCALE_9_GRID);
			this.panelBorderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("panel-background-skin"), PANEL_BORDER_SCALE_9_GRID);

			this.progressBarFillSkinTexture = this.atlas.getTexture("progress-bar-fill-skin");

			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");
		}

		/**
		 * Sets global style providers for all components.
		 */
		private function initializeStyleProviders():void
		{
			//alert
			this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_HEADER, this.setPanelHeaderStyles);
			this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_BUTTON_GROUP, this.setAlertButtonGroupStyles);
			this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

			//button
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

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
			this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

			//header
			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

			//item renderers for lists
			this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
			this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
			this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

			//header and footer renderers for grouped list
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
			this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderOrFooterRendererStyles);

			//label
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_HEADING, this.setHeadingLabelStyles);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_NAME_DETAIL, this.setDetailLabelStyles);

			//list (see also: item renderers)
			this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

			//numeric stepper
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_INCREMENT_BUTTON, this.setNumericStepperIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_NAME_DECREMENT_BUTTON, this.setNumericStepperDecrementButtonStyles);

			//panel
			this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
			this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_NAME_HEADER, this.setPanelHeaderStyles);

			//panel screen
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setScrollerStyles;

			//page indicator
			this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

			//picker list (see also: item renderers)
			this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
			this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_LIST, this.setPickerListListStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_BUTTON, this.setPickerListButtonStyles);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_NAME_BUTTON, this.setPickerListButtonStyles);

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
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_THUMB, this.setVerticalScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK, this.setVerticalScrollBarMinimumTrackStyles);

			//scroll container
			this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
			this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

			//scroll screen
			this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollerStyles;

			//scroll text
			this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

			//simple scroll bar
			this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalSimpleScrollBarStyles);
			this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR, this.setVerticalSimpleScrollBarStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);

			//slider
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SLIDER_THUMB, this.setHorizontalSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SLIDER_THUMB, this.setVerticalSliderThumbStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);

			//tab bar
			this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_NAME_TAB, this.setTabStyles);

			//text area
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

			//text input
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

			//toggle button
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

			//toggle switch
			this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_NAME_THUMB, this.setToggleSwitchThumbStyles);
		}

		private function pageIndicatorNormalSymbolFactory():Image
		{
			return new Image(this.pageIndicatorNormalSkinTexture);
		}

		private function pageIndicatorSelectedSymbolFactory():Image
		{
			return new Image(this.pageIndicatorSelectedSkinTexture);
		}

	//-------------------------
	// Shared
	//-------------------------

		private function setScrollerStyles(scroller:Scroller):void
		{
			scroller.clipContent = true;
			scroller.horizontalScrollBarFactory = scrollBarFactory;
			scroller.verticalScrollBarFactory = scrollBarFactory;
			scroller.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			scroller.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
		}

	//-------------------------
	// Alert
	//-------------------------

		private function setAlertStyles(alert:Alert):void
		{
			this.setScrollerStyles(alert);

			alert.backgroundSkin = new Scale9Image(panelBorderBackgroundSkinTextures);

			alert.paddingTop = 0;
			alert.paddingBottom = 0;
			alert.paddingRight = this.gutterSize;
			alert.paddingLeft = this.gutterSize;
			alert.gap = this.gutterSize;

			alert.maxWidth = this.popUpSize;
			alert.maxHeight = this.popUpSize;
		}

		private function setAlertButtonGroupStyles(group:ButtonGroup):void
		{
			group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			group.horizontalAlign = ButtonGroup.HORIZONTAL_ALIGN_CENTER;
			group.verticalAlign = ButtonGroup.VERTICAL_ALIGN_JUSTIFY;
			group.distributeButtonSizes = false;
			group.gap = this.smallGutterSize;
			group.padding = this.smallGutterSize;
		}

		private function setAlertMessageTextRendererStyles(renderer:TextFieldTextRenderer):void
		{
			renderer.textFormat = this.defaultTextFormat;
			renderer.wordWrap = true;
		}

	//-------------------------
	// Button
	//-------------------------

		private function setBaseButtonStyles(button:Button):void
		{
			button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			button.focusPadding = -1;

			button.defaultLabelProperties.textFormat = this.defaultTextFormat;
			button.disabledLabelProperties.textFormat = this.disabledTextFormat;

			button.paddingTop = this.extraSmallGutterSize;
			button.paddingBottom = this.extraSmallGutterSize;
			button.paddingLeft = this.smallGutterSize;
			button.paddingRight = this.smallGutterSize;
			button.gap = this.extraSmallGutterSize;
			button.minGap = this.extraSmallGutterSize;
			button.minWidth = this.smallControlSize;
			button.minHeight = this.smallControlSize;
		}

		private function setButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			if(Std.is(button, ToggleButton))
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
				skinSelector.setValueForState(this.buttonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
				skinSelector.setValueForState(this.buttonSelectedDownSkinTextures, Button.STATE_DOWN, true);
				skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			}
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.minWidth = this.buttonMinWidth;
			button.minHeight = this.controlSize;
		}

		private function setQuietButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = null;
			skinSelector.setValueForState(this.buttonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, null, false);
			if(Std.is(button, ToggleButton))
			{
				//for convenience, this function can style both a regular button
				//and a toggle button
				skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
				skinSelector.setValueForState(this.buttonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
				skinSelector.setValueForState(this.buttonSelectedDownSkinTextures, Button.STATE_DOWN, true);
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

	//-------------------------
	// ButtonGroup
	//-------------------------

		private function setButtonGroupStyles(group:ButtonGroup):void
		{
			group.gap = this.smallGutterSize;
		}

	//-------------------------
	// Callout
	//-------------------------

		private function setCalloutStyles(callout:Callout):void
		{
			callout.backgroundSkin = new Scale9Image(panelBorderBackgroundSkinTextures);

			var arrowSkin:Quad = new Quad(this.gutterSize, this.gutterSize, 0xff00ff);
			arrowSkin.alpha = 0;
			callout.topArrowSkin =  callout.rightArrowSkin =  callout.bottomArrowSkin =
				callout.leftArrowSkin = arrowSkin;

			callout.paddingTop = this.smallGutterSize;
			callout.paddingBottom = this.smallGutterSize;
			callout.paddingRight = this.gutterSize;
			callout.paddingLeft = this.gutterSize;
		}

	//-------------------------
	// Check
	//-------------------------

		private function setCheckStyles(check:Check):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.checkUpIconTexture;
			iconSelector.defaultSelectedValue = this.checkSelectedUpIconTexture;
			iconSelector.setValueForState(this.checkHoverIconTexture, Button.STATE_HOVER, false);
			iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.checkSelectedHoverIconTexture, Button.STATE_HOVER, true);
			iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				snapToPixels: true,
				textureScale: this.scale
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			check.focusPadding = -2;

			check.defaultLabelProperties.textFormat = this.defaultTextFormat;
			check.disabledLabelProperties.textFormat = this.disabledTextFormat;
			check.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;

			check.gap = this.smallGutterSize;
			check.minWidth = this.controlSize;
			check.minHeight = this.controlSize;
		}

	//-------------------------
	// Drawers
	//-------------------------

		private function setDrawersStyles(drawers:Drawers):void
		{
			var overlaySkin:Quad = new Quad(10, 10, MODAL_OVERLAY_COLOR);
			overlaySkin.alpha = MODAL_OVERLAY_ALPHA;
			drawers.overlaySkin = overlaySkin;
		}

	//-------------------------
	// GroupedList
	//-------------------------

		private function setGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;

			list.backgroundSkin = new Scale9Image(simpleBorderBackgroundSkinTextures);

			list.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			list.focusPadding = -1;

			list.padding = this.borderSize;
		}

		//see List section for item renderer styles

		private function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.backgroundSkin = new Scale9Image(groupedListHeaderBackgroundSkinTextures);
			renderer.backgroundSkin.height = this.controlSize;

			renderer.contentLabelProperties.textFormat = this.defaultTextFormat;
			renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

			renderer.paddingTop = this.extraSmallGutterSize;
			renderer.paddingBottom = this.extraSmallGutterSize;
			renderer.paddingRight = this.smallGutterSize;
			renderer.paddingLeft = this.smallGutterSize;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;
		}

		private function setInsetGroupedListStyles(list:GroupedList):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;

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

		private function setInsetGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			renderer.contentLabelProperties.textFormat = this.defaultTextFormat;
			renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

			renderer.paddingTop = this.smallGutterSize;
			renderer.paddingBottom = this.extraSmallGutterSize;
			renderer.paddingRight = this.smallGutterSize;
			renderer.paddingLeft = this.smallGutterSize;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;
		}

	//-------------------------
	// Header
	//-------------------------

		private function setHeaderStyles(header:Header):void
		{
			header.backgroundSkin = new Scale9Image(headerBackgroundSkinTextures);

			header.minWidth = this.gridSize;
			header.minHeight = this.gridSize;

			header.titleProperties.textFormat = this.defaultTextFormat;
			header.titleProperties.disabledTextFormat = this.disabledTextFormat;

			header.paddingTop = this.extraSmallGutterSize;
			header.paddingBottom = this.extraSmallGutterSize;
			header.paddingLeft = this.smallGutterSize;
			header.paddingRight = this.smallGutterSize;

			header.gap = this.extraSmallGutterSize;
			header.titleGap = this.gutterSize;
		}

	//-------------------------
	// Label
	//-------------------------

		private function setLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.defaultTextFormat;
			label.textRendererProperties.disabledTextFormat = this.disabledTextFormat;
		}

		private function setHeadingLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.headingTextFormat;
			label.textRendererProperties.disabledTextFormat = this.headingDisabledTextFormat;
		}

		private function setDetailLabelStyles(label:Label):void
		{
			label.textRendererProperties.textFormat = this.detailTextFormat;
			label.textRendererProperties.disabledTextFormat = this.detailDisabledTextFormat;
		}

	//-------------------------
	// List
	//-------------------------

		private function setListStyles(list:List):void
		{
			this.setScrollerStyles(list);

			list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;

			list.backgroundSkin = new Scale9Image(simpleBorderBackgroundSkinTextures);

			list.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			list.focusPadding = -1;

			list.padding = this.borderSize;
		}

		private function setItemRendererStyles(renderer:BaseDefaultItemRenderer):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.itemRendererUpSkinTexture;
			skinSelector.defaultSelectedValue = this.itemRendererSelectedUpSkinTexture;
			skinSelector.setValueForState(this.itemRendererHoverSkinTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.itemRendererSelectedUpSkinTexture, Button.STATE_DOWN, false);
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = this.defaultTextFormat;
			renderer.disabledLabelProperties.textFormat = this.disabledTextFormat;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;

			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.paddingTop = this.extraSmallGutterSize;
			renderer.paddingBottom = this.extraSmallGutterSize;
			renderer.paddingRight = this.smallGutterSize;
			renderer.paddingLeft = this.smallGutterSize;
			renderer.gap = this.extraSmallGutterSize;
			renderer.minGap = this.extraSmallGutterSize;
			renderer.accessoryGap = Math.POSITIVE_INFINITY;
			renderer.minAccessoryGap = this.smallGutterSize;
			renderer.minWidth = this.controlSize;
			renderer.minHeight = this.controlSize;

			renderer.useStateDelayTimer = false;
		}

		private function setItemRendererAccessoryLabelStyles(renderer:TextFieldTextRenderer):void
		{
			renderer.textFormat = this.defaultTextFormat;
		}

		private function setItemRendererIconLabelStyles(renderer:TextFieldTextRenderer):void
		{
			renderer.textFormat = this.defaultTextFormat;
		}

	//-------------------------
	// NumericStepper
	//-------------------------

		private function setNumericStepperStyles(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;

			stepper.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			stepper.focusPadding = -1;
		}

		private function setNumericStepperIncrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.stepperIncrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.stepperIncrementButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.stepperIncrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.stepperIncrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			button.keepDownStateOnRollOut = true;

			button.hasLabelTextRenderer = false;
		}

		private function setNumericStepperDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.stepperDecrementButtonUpSkinTextures;
			skinSelector.setValueForState(this.stepperDecrementButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.stepperDecrementButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.stepperDecrementButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			button.keepDownStateOnRollOut = true;

			button.hasLabelTextRenderer = false;
		}

		private function setNumericStepperTextInputStyles(input:TextInput):void
		{
			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.gap = this.extraSmallGutterSize;
			input.paddingTop = this.extraSmallGutterSize;
			input.paddingBottom = this.extraSmallGutterSize;
			input.paddingRight = this.smallGutterSize;
			input.paddingLeft = this.smallGutterSize;

			input.textEditorProperties.textFormat = this.defaultTextFormat;
			input.textEditorProperties.disabledTextFormat = this.disabledTextFormat;
			input.promptProperties.textFormat = this.defaultTextFormat;
			input.promptProperties.disabledTextFormat = this.defaultTextFormat;

			var backgroundSkin:Scale9Image = new Scale9Image(textInputBackgroundSkinTextures);
			backgroundSkin.width = backgroundSkin.height;
			input.backgroundSkin = backgroundSkin;

			var backgroundDisabledSkin:Scale9Image = new Scale9Image(textInputBackgroundDisabledSkinTextures);
			backgroundDisabledSkin.width = backgroundDisabledSkin.height;
			input.backgroundDisabledSkin = backgroundDisabledSkin;
		}

	//-------------------------
	// PageIndicator
	//-------------------------

		private function setPageIndicatorStyles(pageIndicator:PageIndicator):void
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

		private function setPanelStyles(panel:Panel):void
		{
			this.setScrollerStyles(panel);

			panel.backgroundSkin = new Scale9Image(panelBorderBackgroundSkinTextures);

			panel.paddingTop = 0;
			panel.paddingRight = this.gutterSize;
			panel.paddingBottom = this.gutterSize;
			panel.paddingLeft = this.gutterSize;
		}

		private function setPanelHeaderStyles(header:Header):void
		{
			header.titleProperties.textFormat = this.defaultTextFormat;
			header.titleProperties.disabledTextFormat = this.disabledTextFormat;

			header.minHeight = this.gridSize;

			header.paddingTop = this.extraSmallGutterSize;
			header.paddingBottom = this.extraSmallGutterSize;
			header.paddingLeft = this.smallGutterSize;
			header.paddingRight = this.smallGutterSize;
			header.gap = this.extraSmallGutterSize;
			header.titleGap = this.smallGutterSize;
		}

	//-------------------------
	// PickerList
	//-------------------------

		private function setPickerListStyles(list:PickerList):void
		{
			list.popUpContentManager = new DropDownPopUpContentManager();
		}

		private function setPickerListListStyles(list:List):void
		{
			this.setListStyles(list);
			list.maxHeight = this.wideControlSize;
		}

		private function setPickerListButtonStyles(button:Button):void
		{
			this.setButtonStyles(button);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.setValueTypeHandler(ConcreteTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.pickerListUpIconTexture;
			iconSelector.setValueForState(this.pickerListHoverIconTexture, Button.STATE_HOVER, false);
			iconSelector.setValueForState(this.pickerListDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.pickerListDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			}
			button.stateToIconFunction = iconSelector.updateValue;

			button.gap = Math.POSITIVE_INFINITY; //fill as completely as possible
			button.minGap = this.smallGutterSize;
			button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.paddingRight = this.smallGutterSize;
		}

	//-------------------------
	// ProgressBar
	//-------------------------

		private function setProgressBarStyles(progress:ProgressBar):void
		{
			var backgroundSkin:Scale9Image = new Scale9Image(simpleBorderBackgroundSkinTextures);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				backgroundSkin.height = this.wideControlSize;
			}
			else
			{
				backgroundSkin.width = this.wideControlSize;
			}
			progress.backgroundSkin = backgroundSkin;

			var fillSkin:Image = new Image(progressBarFillSkinTexture);
			if(progress.direction == ProgressBar.DIRECTION_VERTICAL)
			{
				fillSkin.height = 0;
			}
			else
			{
				fillSkin.width = 0;
			}
			progress.fillSkin = fillSkin;

			progress.padding = this.borderSize;
		}

	//-------------------------
	// Radio
	//-------------------------

		private function setRadioStyles(radio:Radio):void
		{
			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.setValueTypeHandler(ConcreteTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.radioUpIconTexture;
			iconSelector.defaultSelectedValue = this.radioSelectedUpIconTexture;
			iconSelector.setValueForState(this.radioHoverIconTexture, Button.STATE_HOVER, false);
			iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.radioSelectedHoverIconTexture, Button.STATE_HOVER, true);
			iconSelector.setValueForState(this.radioSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			radio.focusPadding = -2;

			radio.defaultLabelProperties.textFormat = this.defaultTextFormat;
			radio.disabledLabelProperties.textFormat = this.disabledTextFormat;
			radio.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;

			radio.gap = this.smallGutterSize;
			radio.minWidth = this.controlSize;
			radio.minHeight = this.controlSize;
		}

	//-------------------------
	// ScrollBar
	//-------------------------

		private function setHorizontalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			scrollBar.customIncrementButtonName = THEME_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonName = THEME_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbName = THEME_NAME_HORIZONTAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackName = THEME_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK;
		}

		private function setVerticalScrollBarStyles(scrollBar:ScrollBar):void
		{
			scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

			scrollBar.customIncrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
			scrollBar.customDecrementButtonName = THEME_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
			scrollBar.customThumbName = THEME_NAME_VERTICAL_SCROLL_BAR_THUMB;
			scrollBar.customMinimumTrackName = THEME_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK;
		}

		private function setHorizontalScrollBarIncrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.hScrollBarStepButtonUpSkinTextures;
			skinSelector.setValueForState(this.hScrollBarStepButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hScrollBarStepButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.hScrollBarStepButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.hScrollBarIncrementButtonIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		private function setHorizontalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = hScrollBarStepButtonUpSkinTextures;
			skinSelector.setValueForState(this.hScrollBarStepButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hScrollBarStepButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.hScrollBarStepButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.hScrollBarDecrementButtonIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		private function setHorizontalScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.hScrollBarThumbUpSkinTextures;
			skinSelector.setValueForState(this.hScrollBarThumbHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hScrollBarThumbDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.defaultIcon = new Image(this.hScrollBarThumbIconTexture);
			thumb.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			thumb.paddingBottom = this.extraSmallGutterSize;

			thumb.hasLabelTextRenderer = false;
		}

		private function setHorizontalScrollBarMinimumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Scale9Image(this.hScrollBarTrackSkinTextures);

			track.hasLabelTextRenderer = false;
		}

		private function setVerticalScrollBarIncrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vScrollBarStepButtonUpSkinTextures;
			skinSelector.setValueForState(this.vScrollBarStepButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vScrollBarStepButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.vScrollBarStepButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.vScrollBarIncrementButtonIconTexture);

			var incrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			incrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = incrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		private function setVerticalScrollBarDecrementButtonStyles(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vScrollBarStepButtonUpSkinTextures;
			skinSelector.setValueForState(this.vScrollBarStepButtonHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vScrollBarStepButtonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.vScrollBarStepButtonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultIcon = new Image(this.vScrollBarDecrementButtonIconTexture);

			var decrementButtonDisabledIcon:Quad = new Quad(1, 1, 0xff00ff);
			decrementButtonDisabledIcon.alpha = 0;
			button.disabledIcon = decrementButtonDisabledIcon;

			button.hasLabelTextRenderer = false;
		}

		private function setVerticalScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vScrollBarThumbUpSkinTextures;
			skinSelector.setValueForState(this.vScrollBarThumbHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vScrollBarThumbDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.defaultIcon = new Image(this.vScrollBarThumbIconTexture);
			thumb.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
			thumb.paddingRight = this.extraSmallGutterSize;

			thumb.hasLabelTextRenderer = false;
		}

		private function setVerticalScrollBarMinimumTrackStyles(track:Button):void
		{
			track.defaultSkin = new Scale9Image(this.vScrollBarTrackSkinTextures);

			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// ScrollContainer
	//-------------------------

		private function setScrollContainerStyles(container:ScrollContainer):void
		{
			this.setScrollerStyles(container);
		}

		private function setToolbarScrollContainerStyles(container:ScrollContainer):void
		{
			this.setScrollerStyles(container);

			if(!container.layout)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.paddingTop = this.extraSmallGutterSize;
				layout.paddingBottom = this.extraSmallGutterSize;
				layout.paddingRight = this.smallGutterSize;
				layout.paddingLeft = this.smallGutterSize;
				layout.gap = this.extraSmallGutterSize;
				container.layout = layout;
			}

			container.minHeight = this.gridSize;

			container.backgroundSkin = new Scale9Image(headerBackgroundSkinTextures);
		}

	//-------------------------
	// ScrollText
	//-------------------------

		private function setScrollTextStyles(text:ScrollText):void
		{
			this.setScrollerStyles(text);

			text.textFormat = this.defaultTextFormat;
			text.disabledTextFormat = this.disabledTextFormat;
			text.padding = this.gutterSize;
		}

	//-------------------------
	// SimpleScrollBar
	//-------------------------

		private function setHorizontalSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			scrollBar.customThumbName = THEME_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
		}

		private function setVerticalSimpleScrollBarStyles(scrollBar:SimpleScrollBar):void
		{
			scrollBar.customThumbName = THEME_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
		}

		private function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.hScrollBarThumbUpSkinTextures;
			skinSelector.setValueForState(this.hScrollBarThumbHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hScrollBarThumbDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.defaultIcon = new Image(this.hScrollBarThumbIconTexture);
			thumb.verticalAlign = Button.VERTICAL_ALIGN_TOP;
			thumb.paddingTop = this.smallGutterSize;

			thumb.hasLabelTextRenderer = false;
		}

		private function setVerticalSimpleScrollBarThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.vScrollBarThumbUpSkinTextures;
			skinSelector.setValueForState(this.vScrollBarThumbHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vScrollBarThumbDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.defaultIcon = new Image(this.vScrollBarThumbIconTexture);
			thumb.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			thumb.paddingLeft = this.smallGutterSize;

			thumb.hasLabelTextRenderer = false;
		}

	//-------------------------
	// Slider
	//-------------------------

		private function setSliderStyles(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;
			slider.minimumPadding = slider.maximumPadding = -vSliderThumbUpSkinTexture.height / 2;

			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				slider.customThumbName = THEME_NAME_VERTICAL_SLIDER_THUMB;
				slider.customMinimumTrackName = THEME_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;

				slider.focusPaddingLeft = slider.focusPaddingRight = -2;
				slider.focusPaddingTop = slider.focusPaddingBottom = -2 + slider.minimumPadding;
			}
			else //horizontal
			{
				slider.customThumbName = THEME_NAME_HORIZONTAL_SLIDER_THUMB;
				slider.customMinimumTrackName = THEME_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;

				slider.focusPaddingTop = slider.focusPaddingBottom = -2;
				slider.focusPaddingLeft = slider.focusPaddingRight = -2 + slider.minimumPadding;
			}

			slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		}

		private function setHorizontalSliderThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			skinSelector.setValueTypeHandler(ConcreteTexture, textureValueTypeHandler);
			skinSelector.defaultValue = this.hSliderThumbUpSkinTexture;
			skinSelector.setValueForState(this.hSliderThumbHoverSkinTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.hSliderThumbDownSkinTexture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.hSliderThumbDisabledSkinTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.hasLabelTextRenderer = false;
		}

		private function setHorizontalSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.hSliderTrackSkinTextures)
			defaultSkin.width = this.wideControlSize;
			track.defaultSkin = defaultSkin;

			track.hasLabelTextRenderer = false;
		}

		private function setVerticalSliderThumbStyles(thumb:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			skinSelector.setValueTypeHandler(ConcreteTexture, textureValueTypeHandler);
			skinSelector.defaultValue = this.vSliderThumbUpSkinTexture;
			skinSelector.setValueForState(this.vSliderThumbHoverSkinTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.vSliderThumbDownSkinTexture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.vSliderThumbDisabledSkinTexture, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			thumb.stateToSkinFunction = skinSelector.updateValue;

			thumb.hasLabelTextRenderer = false;
		}

		private function setVerticalSliderMinimumTrackStyles(track:Button):void
		{
			var defaultSkin:Scale3Image = new Scale3Image(this.vSliderTrackSkinTextures);
			defaultSkin.height = this.wideControlSize;
			track.defaultSkin = defaultSkin;

			track.hasLabelTextRenderer = false;
		}

	//-------------------------
	// TabBar
	//-------------------------

		private function setTabBarStyles(tabBar:TabBar):void
		{
			tabBar.distributeTabSizes = false;
			tabBar.horizontalAlign = TabBar.HORIZONTAL_ALIGN_LEFT;
			tabBar.verticalAlign = TabBar.VERTICAL_ALIGN_JUSTIFY;
		}

		private function setTabStyles(tab:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.tabUpSkinTextures;
			skinSelector.defaultSelectedValue = this.tabSelectedUpSkinTextures;
			skinSelector.setValueForState(this.tabHoverSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.tabDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.tabDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.tabSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.defaultLabelProperties.textFormat = this.defaultTextFormat;
			tab.disabledLabelProperties.textFormat = this.disabledTextFormat;
			tab.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;

			tab.paddingTop = this.extraSmallGutterSize;
			tab.paddingBottom = this.extraSmallGutterSize;
			tab.paddingLeft = this.smallGutterSize;
			tab.paddingRight = this.smallGutterSize;
			tab.gap = this.extraSmallGutterSize;
			tab.minWidth = this.buttonMinWidth;
			tab.minHeight = this.controlSize;
		}

	//-------------------------
	// TextArea
	//-------------------------

		private function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			textArea.textEditorProperties.textFormat = this.defaultTextFormat;
			textArea.textEditorProperties.disabledTextFormat = this.disabledTextFormat;

			textArea.padding = this.borderSize;

			textArea.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			textArea.focusPadding = -1;

			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.textInputBackgroundSkinTextures;
			skinSelector.setValueForState(this.textInputBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
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

		private function setBaseTextInputStyles(input:TextInput):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.textInputBackgroundSkinTextures;
			skinSelector.setValueForState(this.textInputBackgroundDisabledSkinTextures, TextInput.STATE_DISABLED);
			skinSelector.displayObjectProperties =
			{
				width: this.wideControlSize,
				height: this.controlSize,
				textureScale: this.scale
			};
			input.stateToSkinFunction = skinSelector.updateValue;

			input.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			input.focusPadding = -1;

			input.minWidth = this.controlSize;
			input.minHeight = this.controlSize;
			input.gap = this.extraSmallGutterSize;
			input.paddingTop = this.extraSmallGutterSize;
			input.paddingBottom = this.extraSmallGutterSize;
			input.paddingRight = this.smallGutterSize;
			input.paddingLeft = this.smallGutterSize;

			input.textEditorProperties.textFormat = this.defaultTextFormat;
			input.textEditorProperties.disabledTextFormat = this.disabledTextFormat;
			input.promptProperties.textFormat = this.defaultTextFormat;
			input.promptProperties.disabledTextFormat = this.disabledTextFormat;
		}

		private function setTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);
		}

		private function setSearchTextInputStyles(input:TextInput):void
		{
			this.setBaseTextInputStyles(input);

			var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			iconSelector.defaultValue = this.textInputSearchIconTexture;
			iconSelector.setValueForState(this.textInputSearchIconDisabledTexture, TextInput.STATE_DISABLED, false);
			iconSelector.displayObjectProperties =
			{
				snapToPixels: true,
				textureScale: this.scale
			};
			input.stateToIconFunction = iconSelector.updateValue;
		}

	//-------------------------
	// ToggleSwitch
	//-------------------------

		private function setToggleSwitchStyles(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			toggle.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
			toggle.defaultLabelProperties.textFormat = this.defaultTextFormat;
			toggle.disabledLabelProperties.textFormat = this.disabledTextFormat;

			toggle.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			toggle.focusPadding = -1;
		}

		private function setToggleSwitchOnTrackStyles(track:Button):void
		{
			track.defaultSkin = new Scale9Image(buttonSelectedUpSkinTextures);

			track.hasLabelTextRenderer = false;
		}

		private function setToggleSwitchThumbStyles(thumb:Button):void
		{
			this.setButtonStyles(thumb);

			var frame:Rectangle = this.buttonUpSkinTextures.texture.frame;
			if(frame)
			{
				thumb.width = thumb.height = buttonUpSkinTextures.texture.frame.height;
			}
			else
			{
				thumb.width = thumb.height = buttonUpSkinTextures.texture.height;
			}

			thumb.hasLabelTextRenderer = false;
		}
	}
}
