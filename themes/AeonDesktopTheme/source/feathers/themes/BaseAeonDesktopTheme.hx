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
import feathers.media.FullScreenToggleButton;
import feathers.media.MuteToggleButton;
import feathers.media.PlayPauseToggleButton;
import feathers.media.SeekSlider;
import feathers.media.VideoPlayer;
import feathers.media.VolumeSlider;
import feathers.skins.SmartDisplayObjectStateValueSelector;
import feathers.skins.StandardIcons;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;

import flash.geom.Rectangle;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

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
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-increment-button";

	/**
	 * @private
	 * The theme's custom style name for the decrement button of a horizontal ScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-decrement-button";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a horizontal ScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB:String = "aeon-horizontal-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a horizontal ScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-horizontal-scroll-bar-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the increment button of a vertical ScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-vertical-scroll-bar-increment-button";

	/**
	 * @private
	 * The theme's custom style name for the decrement button of a vertical ScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-vertical-scroll-bar-decrement-button";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a vertical ScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB:String = "aeon-vertical-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a vertical ScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-vertical-scroll-bar-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a horizontal SimpleScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-horizontal-simple-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a vertical SimpleScrollBar.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-vertical-simple-scroll-bar-thumb";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a horizontal Slider.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB:String = "aeon-horizontal-slider-thumb";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a horizontal Slider.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "aeon-horizontal-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the thumb of a vertical Slider.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB:String = "aeon-vertical-slider-thumb";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a vertical Slider.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "aeon-vertical-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a vertical VolumeSlider.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-vertical-volume-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a vertical VolumeSlider.
	 */
	inline private static var THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-vertical-volume-slider-maximum-track";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a horizontal VolumeSlider.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-horizontal-volume-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a horizontal VolumeSlider.
	 */
	inline private static var THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-horizontal-volume-slider-maximum-track";

	/**
	 * @private
	 * The theme's custom style name for the minimum track of a pop-up VolumeSlider.
	 */
	inline private static var THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-pop-up-volume-slider-minimum-track";

	/**
	 * @private
	 * The theme's custom style name for the maximum track of a pop-up VolumeSlider.
	 */
	inline private static var THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-pop-up-volume-slider-maximum-track";

	/**
	 * The name of the font used by controls in this theme. This font is not
	 * embedded. It is the default sans-serif system font.
	 */
	public static const FONT_NAME:String = "_sans";

	inline private static var FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 2, 2);
	inline private static var BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 7);
	inline private static var TAB_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 15);
	inline private static var STEPPER_INCREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 9, 15, 1);
	inline private static var STEPPER_DECREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 15, 1);
	inline private static var SLIDER_TRACK_FIRST_REGION:Float = 3;
	inline private static var SLIDER_TRACK_SECOND_REGION:Float = 1;
	inline private static var TEXT_INPUT_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 1, 1);
	inline private static var VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(2, 5, 6, 42);
	inline private static var VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(2, 1, 11, 2);
	inline private static var VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 11, 10);
	inline private static var HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(5, 2, 42, 6);
	inline private static var HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(1, 2, 2, 11);
	inline private static var HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 10, 11);
	inline private static var SIMPLE_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(2, 2, 2, 2);
	inline private static var PANEL_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(5, 5, 1, 1);
	inline private static var HEADER_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 28);
	inline private static var SEEK_SLIDER_MINIMUM_TRACK_FIRST_REGION:Float = 3;
	inline private static var SEEK_SLIDER_MINIMUM_TRACK_SECOND_REGION:Float = 1;
	inline private static var SEEK_SLIDER_MAXIMUM_TRACK_FIRST_REGION:Float = 1;
	inline private static var SEEK_SLIDER_MAXIMUM_TRACK_SECOND_REGION:Float = 1;
	
	inline private static var ITEM_RENDERER_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1, 1, 4, 4);
	inline private static var PROGRESS_BAR_FILL_TEXTURE_REGION:Rectangle = new Rectangle(1, 1, 4, 4);

	inline private static var BACKGROUND_COLOR:UInt = 0x869CA7;
	inline private static var MODAL_OVERLAY_COLOR:UInt = 0xDDDDDD;
	inline private static var MODAL_OVERLAY_ALPHA:Float = 0.5;
	inline private static var PRIMARY_TEXT_COLOR:UInt = 0x0B333C;
	inline private static var DISABLED_TEXT_COLOR:UInt = 0x5B6770;
	inline private static var VIDEO_OVERLAY_COLOR:UInt = 0xc9e0eE;
	inline private static var VIDEO_OVERLAY_ALPHA:Float = 0.25;

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
	public function BaseAeonDesktopTheme()
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
	private var popUpVolumeSliderPaddingSize:Int;

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
	private var toggleButtonSelectedUpSkinTextures:Scale9Textures;
	private var toggleButtonSelectedHoverSkinTextures:Scale9Textures;
	private var toggleButtonSelectedDownSkinTextures:Scale9Textures;
	private var toggleButtonSelectedDisabledSkinTextures:Scale9Textures;
	private var quietButtonHoverSkinTextures:Scale9Textures;
	private var callToActionButtonUpSkinTextures:Scale9Textures;
	private var callToActionButtonHoverSkinTextures:Scale9Textures;
	private var dangerButtonUpSkinTextures:Scale9Textures;
	private var dangerButtonHoverSkinTextures:Scale9Textures;
	private var dangerButtonDownSkinTextures:Scale9Textures;
	private var backButtonUpIconTexture:Texture;
	private var backButtonDisabledIconTexture:Texture;
	private var forwardButtonUpIconTexture:Texture;
	private var forwardButtonDisabledIconTexture:Texture;

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
	private var hSliderTrackEnabledSkinTextures:Scale3Textures;

	private var vSliderThumbUpSkinTexture:Texture;
	private var vSliderThumbHoverSkinTexture:Texture;
	private var vSliderThumbDownSkinTexture:Texture;
	private var vSliderThumbDisabledSkinTexture:Texture;
	private var vSliderTrackEnabledSkinTextures:Scale3Textures;

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

	private var textInputBackgroundEnabledSkinTextures:Scale9Textures;
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
	private var insetBorderBackgroundSkinTextures:Scale9Textures;
	private var panelBorderBackgroundSkinTextures:Scale9Textures;
	private var alertBorderBackgroundSkinTextures:Scale9Textures;

	private var progressBarFillSkinTexture:Texture;

	//media textures
	private var playPauseButtonPlayUpIconTexture:Texture;
	private var playPauseButtonPauseUpIconTexture:Texture;
	private var overlayPlayPauseButtonPlayUpIconTexture:Texture;
	private var fullScreenToggleButtonEnterUpIconTexture:Texture;
	private var fullScreenToggleButtonExitUpIconTexture:Texture;
	private var muteToggleButtonLoudUpIconTexture:Texture;
	private var muteToggleButtonMutedUpIconTexture:Texture;
	private var horizontalVolumeSliderMinimumTrackSkinTexture:Texture;
	private var horizontalVolumeSliderMaximumTrackSkinTexture:Texture;
	private var verticalVolumeSliderMinimumTrackSkinTexture:Texture;
	private var verticalVolumeSliderMaximumTrackSkinTexture:Texture;
	private var popUpVolumeSliderMinimumTrackSkinTexture:Texture;
	private var popUpVolumeSliderMaximumTrackSkinTexture:Texture;
	private var seekSliderMinimumTrackSkinTextures:Scale3Textures;
	private var seekSliderMaximumTrackSkinTextures:Scale3Textures;

	/**
	 * Disposes the texture atlas before calling super.dispose()
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
		this.initializeGlobals()
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
		this.popUpVolumeSliderPaddingSize = Math.round(6 * this.scale);
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

		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		FeathersControl.defaultTextEditorFactory = textEditorFactory;

		PopUpManager.overlayFactory = popUpOverlayFactory;
		Callout.stagePadding = this.smallGutterSize;
	}

	/**
	 * Initializes font sizes and formats.
	 */
	private function initializeFonts():Void
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
	private function initializeTextures():Void
	{
		this.focusIndicatorSkinTextures = new Scale9Textures(this.atlas.getTexture("focus-indicator-skin0000"), FOCUS_INDICATOR_SCALE_9_GRID);

		this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-up-skin0000"), BUTTON_SCALE_9_GRID);
		this.buttonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("button-hover-skin0000"), BUTTON_SCALE_9_GRID);
		this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin0000"), BUTTON_SCALE_9_GRID);
		this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin0000"), BUTTON_SCALE_9_GRID);
		this.toggleButtonSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("toggle-button-selected-up-skin0000"), BUTTON_SCALE_9_GRID);
		this.toggleButtonSelectedHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("toggle-button-selected-hover-skin0000"), BUTTON_SCALE_9_GRID);
		this.toggleButtonSelectedDownSkinTextures = new Scale9Textures(this.atlas.getTexture("toggle-button-selected-down-skin0000"), BUTTON_SCALE_9_GRID);
		this.toggleButtonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("toggle-button-selected-disabled-skin0000"), BUTTON_SCALE_9_GRID);
		this.quietButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("quiet-button-hover-skin0000"), BUTTON_SCALE_9_GRID);
		this.callToActionButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("call-to-action-button-up-skin0000"), BUTTON_SCALE_9_GRID);
		this.callToActionButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("call-to-action-button-hover-skin0000"), BUTTON_SCALE_9_GRID);
		this.dangerButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("danger-button-up-skin0000"), BUTTON_SCALE_9_GRID);
		this.dangerButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("danger-button-hover-skin0000"), BUTTON_SCALE_9_GRID);
		this.dangerButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("danger-button-down-skin0000"), BUTTON_SCALE_9_GRID);
		this.backButtonUpIconTexture = this.atlas.getTexture("back-button-up-icon0000");
		this.backButtonDisabledIconTexture = this.atlas.getTexture("back-button-disabled-icon0000");
		this.forwardButtonUpIconTexture = this.atlas.getTexture("forward-button-up-icon0000");
		this.forwardButtonDisabledIconTexture = this.atlas.getTexture("forward-button-disabled-icon0000");

		this.tabUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-up-skin0000"), TAB_SCALE_9_GRID);
		this.tabHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-hover-skin0000"), TAB_SCALE_9_GRID);
		this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin0000"), TAB_SCALE_9_GRID);
		this.tabDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-disabled-skin0000"), TAB_SCALE_9_GRID);
		this.tabSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-up-skin0000"), TAB_SCALE_9_GRID);
		this.tabSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-disabled-skin0000"), TAB_SCALE_9_GRID);

		this.stepperIncrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-up-skin0000"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
		this.stepperIncrementButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-hover-skin0000"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
		this.stepperIncrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-down-skin0000"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);
		this.stepperIncrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-increment-button-disabled-skin0000"), STEPPER_INCREMENT_BUTTON_SCALE_9_GRID);

		this.stepperDecrementButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-up-skin0000"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
		this.stepperDecrementButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-hover-skin0000"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
		this.stepperDecrementButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-down-skin0000"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);
		this.stepperDecrementButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("numeric-stepper-decrement-button-disabled-skin0000"), STEPPER_DECREMENT_BUTTON_SCALE_9_GRID);

		this.hSliderThumbUpSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-up-skin0000");
		this.hSliderThumbHoverSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-hover-skin0000");
		this.hSliderThumbDownSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-down-skin0000");
		this.hSliderThumbDisabledSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-disabled-skin0000");
		this.hSliderTrackEnabledSkinTextures = new Scale3Textures(this.atlas.getTexture("horizontal-slider-track-enabled-skin0000"), SLIDER_TRACK_FIRST_REGION, SLIDER_TRACK_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);

		this.vSliderThumbUpSkinTexture = this.atlas.getTexture("vertical-slider-thumb-up-skin0000");
		this.vSliderThumbHoverSkinTexture = this.atlas.getTexture("vertical-slider-thumb-hover-skin0000");
		this.vSliderThumbDownSkinTexture = this.atlas.getTexture("vertical-slider-thumb-down-skin0000");
		this.vSliderThumbDisabledSkinTexture = this.atlas.getTexture("vertical-slider-thumb-disabled-skin0000");
		this.vSliderTrackEnabledSkinTextures = new Scale3Textures(this.atlas.getTexture("vertical-slider-track-enabled-skin0000"), SLIDER_TRACK_FIRST_REGION, SLIDER_TRACK_SECOND_REGION, Scale3Textures.DIRECTION_VERTICAL);

		this.itemRendererUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-up-skin0000"), ITEM_RENDERER_SKIN_TEXTURE_REGION);
		this.itemRendererHoverSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-hover-skin0000"), ITEM_RENDERER_SKIN_TEXTURE_REGION);
		this.itemRendererSelectedUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-selected-up-skin0000"), ITEM_RENDERER_SKIN_TEXTURE_REGION);

		this.headerBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("header-background-skin0000"), HEADER_SCALE_9_GRID);
		this.groupedListHeaderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("grouped-list-header-background-skin0000"), HEADER_SCALE_9_GRID);

		this.checkUpIconTexture = this.atlas.getTexture("check-up-icon0000");
		this.checkHoverIconTexture = this.atlas.getTexture("check-hover-icon0000");
		this.checkDownIconTexture = this.atlas.getTexture("check-down-icon0000");
		this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon0000");
		this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
		this.checkSelectedHoverIconTexture = this.atlas.getTexture("check-selected-hover-icon0000");
		this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon0000");
		this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");

		this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon0000");
		this.radioHoverIconTexture = this.atlas.getTexture("radio-hover-icon0000");
		this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon0000");
		this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon0000");
		this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
		this.radioSelectedHoverIconTexture = this.atlas.getTexture("radio-selected-hover-icon0000");
		this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon0000");
		this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");

		this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-symbol0000");
		this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-symbol0000");

		this.pickerListUpIconTexture = this.atlas.getTexture("picker-list-up-icon0000");
		this.pickerListHoverIconTexture = this.atlas.getTexture("picker-list-hover-icon0000");
		this.pickerListDownIconTexture = this.atlas.getTexture("picker-list-down-icon0000");
		this.pickerListDisabledIconTexture = this.atlas.getTexture("picker-list-disabled-icon0000");

		this.textInputBackgroundEnabledSkinTextures = new Scale9Textures(this.atlas.getTexture("text-input-background-enabled-skin0000"), TEXT_INPUT_SCALE_9_GRID);
		this.textInputBackgroundDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("text-input-background-disabled-skin0000"), TEXT_INPUT_SCALE_9_GRID);
		this.textInputSearchIconTexture = this.atlas.getTexture("search-icon0000");
		this.textInputSearchIconDisabledTexture = this.atlas.getTexture("search-icon-disabled0000");

		this.vScrollBarThumbUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-up-skin0000"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
		this.vScrollBarThumbHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-hover-skin0000"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
		this.vScrollBarThumbDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-down-skin0000"), VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
		this.vScrollBarTrackSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-track-skin0000"), VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID);
		this.vScrollBarThumbIconTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-icon0000");
		this.vScrollBarStepButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-up-skin0000"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
		this.vScrollBarStepButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-hover-skin0000"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
		this.vScrollBarStepButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-down-skin0000"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
		this.vScrollBarStepButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("vertical-scroll-bar-step-button-disabled-skin0000"), VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
		this.vScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon0000");
		this.vScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon0000");

		this.hScrollBarThumbUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-up-skin0000"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
		this.hScrollBarThumbHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-hover-skin0000"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
		this.hScrollBarThumbDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-down-skin0000"), HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID);
		this.hScrollBarTrackSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-track-skin0000"), HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID);
		this.hScrollBarThumbIconTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-icon0000");
		this.hScrollBarStepButtonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-up-skin0000"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
		this.hScrollBarStepButtonHoverSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-hover-skin0000"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
		this.hScrollBarStepButtonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-down-skin0000"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
		this.hScrollBarStepButtonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("horizontal-scroll-bar-step-button-disabled-skin0000"), HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID);
		this.hScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon0000");
		this.hScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon0000");

		this.simpleBorderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("simple-border-background-skin0000"), SIMPLE_BORDER_SCALE_9_GRID);
		this.insetBorderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("inset-border-background-skin0000"), SIMPLE_BORDER_SCALE_9_GRID);
		this.panelBorderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("panel-background-skin0000"), PANEL_BORDER_SCALE_9_GRID);
		this.alertBorderBackgroundSkinTextures = new Scale9Textures(this.atlas.getTexture("alert-background-skin0000"), PANEL_BORDER_SCALE_9_GRID);

		this.progressBarFillSkinTexture = Texture.fromTexture(this.atlas.getTexture("progress-bar-fill-skin0000"), PROGRESS_BAR_FILL_TEXTURE_REGION);

		this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon0000");
		this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon0000");
		this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon0000");
		this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon0000");
		this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon0000");
		this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon0000");
		this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon0000");
		this.horizontalVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("horizontal-volume-slider-minimum-track-skin0000");
		this.horizontalVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("horizontal-volume-slider-maximum-track-skin0000");
		this.verticalVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("vertical-volume-slider-minimum-track-skin0000");
		this.verticalVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("vertical-volume-slider-maximum-track-skin0000");
		this.popUpVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("pop-up-volume-slider-minimum-track-skin0000");
		this.popUpVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("pop-up-volume-slider-maximum-track-skin0000");
		this.seekSliderMinimumTrackSkinTextures = new Scale3Textures(this.atlas.getTexture("seek-slider-minimum-track-skin0000"), SEEK_SLIDER_MINIMUM_TRACK_FIRST_REGION, SEEK_SLIDER_MINIMUM_TRACK_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);
		this.seekSliderMaximumTrackSkinTextures = new Scale3Textures(this.atlas.getTexture("seek-slider-maximum-track-skin0000"), SEEK_SLIDER_MAXIMUM_TRACK_FIRST_REGION, SEEK_SLIDER_MAXIMUM_TRACK_SECOND_REGION, Scale3Textures.DIRECTION_HORIZONTAL);

		StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon0000");
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
		this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, this.setAlertMessageTextRendererStyles);

		//autocomplete
		this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
		this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);

		//button
		this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON, this.setCallToActionButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON, this.setDangerButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON, this.setBackButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON, this.setForwardButtonStyles);

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
		this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST, this.setInsetGroupedListStyles);

		//header
		this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;

		//item renderers for lists
		this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
		this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER, this.setInsetGroupedListItemRendererStyles);
		this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL, this.setItemRendererAccessoryLabelStyles);
		this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName(BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL, this.setItemRendererIconLabelStyles);

		//header and footer renderers for grouped list
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER, this.setInsetGroupedListHeaderRendererStyles);
		this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER, this.setInsetGroupedListFooterRendererStyles);

		//label
		this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING, this.setHeadingLabelStyles);
		this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL, this.setDetailLabelStyles);

		//layout group
		this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarLayoutGroupStyles);

		//list (see also: item renderers)
		this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;

		//numeric stepper
		this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
		this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, this.setNumericStepperTextInputStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON, this.setNumericStepperIncrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, this.setNumericStepperDecrementButtonStyles);

		//panel
		this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
		this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER, this.setPanelHeaderStyles);

		//panel screen
		this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;

		//page indicator
		this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;

		//picker list (see also: item renderers)
		this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
		this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, this.setDropDownListStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, this.setPickerListButtonStyles);

		//progress bar
		this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;

		//radio
		this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;

		//scroll bar
		this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalScrollBarStyles);
		this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR, this.setVerticalScrollBarStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON, this.setHorizontalScrollBarIncrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON, this.setHorizontalScrollBarDecrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB, this.setHorizontalScrollBarThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK, this.setHorizontalScrollBarMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON, this.setVerticalScrollBarIncrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON, this.setVerticalScrollBarDecrementButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB, this.setVerticalScrollBarThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK, this.setVerticalScrollBarMinimumTrackStyles);

		//scroll container
		this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
		this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR, this.setToolbarScrollContainerStyles);

		//scroll screen
		this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;

		//scroll text
		this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;

		//simple scroll bar
		this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR, this.setHorizontalSimpleScrollBarStyles);
		this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName(Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR, this.setVerticalSimpleScrollBarStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB, this.setHorizontalSimpleScrollBarThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB, this.setVerticalSimpleScrollBarThumbStyles);

		//slider
		this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB, this.setHorizontalSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK, this.setHorizontalSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB, this.setVerticalSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK, this.setVerticalSliderMinimumTrackStyles);

		//tab bar
		this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB, this.setTabStyles);

		//text area
		this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;

		//text input
		this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
		this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT, this.setSearchTextInputStyles);

		//toggle button
		this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_NAME_QUIET_BUTTON, this.setQuietButtonStyles);

		//toggle switch
		this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, this.setToggleSwitchOnTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);
		this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setToggleSwitchThumbStyles);

		//media controls
		
		//play/pause toggle button
		this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
		this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON, this.setOverlayPlayPauseToggleButtonStyles);

		//full screen toggle button
		this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;

		//mute toggle button
		this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;
		this.getStyleProviderForClass(VolumeSlider).setFunctionForStyleName(MuteToggleButton.DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER, this.setPopUpVolumeSliderStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK, this.setPopUpVolumeSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MAXIMUM_TRACK, this.setPopUpVolumeSliderMaximumTrackStyles);

		//seek slider
		this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setHorizontalSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK, this.setSeekSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK, this.setSeekSliderMaximumTrackStyles);

		//volume slider
		this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setVolumeSliderThumbStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MINIMUM_TRACK, this.setHorizontalVolumeSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MAXIMUM_TRACK, this.setHorizontalVolumeSliderMaximumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MINIMUM_TRACK, this.setVerticalVolumeSliderMinimumTrackStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MAXIMUM_TRACK, this.setVerticalVolumeSliderMaximumTrackStyles);
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

	private function setScrollerStyles(scroller:Scroller):Void
	{
		scroller.clipContent = true;
		scroller.horizontalScrollBarFactory = scrollBarFactory;
		scroller.verticalScrollBarFactory = scrollBarFactory;
		scroller.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
		scroller.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;

		scroller.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
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

		alert.backgroundSkin = new Scale9Image(this.alertBorderBackgroundSkinTextures);

		alert.outerPadding = this.borderSize;
		
		alert.paddingTop = this.smallGutterSize;
		alert.paddingBottom = this.smallGutterSize;
		alert.paddingRight = this.gutterSize;
		alert.paddingLeft = this.gutterSize;
		alert.gap = this.gutterSize;

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

	private function setAlertMessageTextRendererStyles(renderer:TextFieldTextRenderer):Void
	{
		renderer.textFormat = this.defaultTextFormat;
		renderer.wordWrap = true;
	}

//-------------------------
// Button
//-------------------------

	private function setBaseButtonStyles(button:Button):Void
	{
		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		button.focusPadding = -1;

		button.defaultLabelProperties.textFormat = this.defaultTextFormat;
		button.disabledLabelProperties.textFormat = this.disabledTextFormat;

		button.paddingTop = this.extraSmallGutterSize;
		button.paddingBottom = this.extraSmallGutterSize;
		button.paddingLeft = this.smallGutterSize;
		button.paddingRight = this.smallGutterSize;
		button.gap = this.smallGutterSize;
		button.minGap = this.smallGutterSize;
		button.minWidth = this.smallControlSize;
		button.minHeight = this.smallControlSize;
	}

	private function setButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.buttonUpSkinTextures;
		skinSelector.setValueForState(this.buttonHoverSkinTextures, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		if(button is ToggleButton)
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			skinSelector.defaultSelectedValue = this.toggleButtonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.toggleButtonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
			skinSelector.setValueForState(this.toggleButtonSelectedDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.toggleButtonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
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

	private function setQuietButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.quietButtonHoverSkinTextures, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, null, false);
		if(button is ToggleButton)
		{
			//for convenience, this function can style both a regular button
			//and a toggle button
			skinSelector.defaultSelectedValue = this.toggleButtonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.toggleButtonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
			skinSelector.setValueForState(this.toggleButtonSelectedDownSkinTextures, Button.STATE_DOWN, true);
			skinSelector.setValueForState(this.toggleButtonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
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

	private function setCallToActionButtonStyles(button:Button):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.callToActionButtonUpSkinTextures;
		skinSelector.setValueForState(this.callToActionButtonHoverSkinTextures, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, null, false);
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
		skinSelector.defaultValue = this.dangerButtonUpSkinTextures;
		skinSelector.setValueForState(this.dangerButtonHoverSkinTextures, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.dangerButtonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, null, false);
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

	private function setBackButtonStyles(button:Button):Void
	{
		this.setButtonStyles(button);
		
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.backButtonUpIconTexture;
		iconSelector.setValueForState(this.backButtonDisabledIconTexture, Button.STATE_DISABLED, false);
		iconSelector.displayObjectProperties =
		{
			snapToPixels: true,
			textureScale: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;
		button.iconPosition = Button.ICON_POSITION_LEFT_BASELINE;
	}

	private function setForwardButtonStyles(button:Button):Void
	{
		this.setButtonStyles(button);

		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		iconSelector.defaultValue = this.forwardButtonUpIconTexture;
		iconSelector.setValueForState(this.forwardButtonDisabledIconTexture, Button.STATE_DISABLED, false);
		iconSelector.displayObjectProperties =
		{
			snapToPixels: true,
			textureScale: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;
		button.iconPosition = Button.ICON_POSITION_RIGHT_BASELINE;
	}

//-------------------------
// ButtonGroup
//-------------------------

	private function setButtonGroupStyles(group:ButtonGroup):Void
	{
		group.gap = this.smallGutterSize;
	}

//-------------------------
// Callout
//-------------------------

	private function setCalloutStyles(callout:Callout):Void
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

	private function setCheckStyles(check:Check):Void
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

		check.horizontalAlign = Check.HORIZONTAL_ALIGN_LEFT;
		check.verticalAlign = Check.VERTICAL_ALIGN_MIDDLE;

		check.gap = this.smallGutterSize;
		check.minWidth = this.controlSize;
		check.minHeight = this.controlSize;
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

		list.backgroundSkin = new Scale9Image(this.simpleBorderBackgroundSkinTextures);

		list.padding = this.borderSize;
	}

	//see List section for item renderer styles

	private function setGroupedListHeaderOrFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.backgroundSkin = new Scale9Image(this.groupedListHeaderBackgroundSkinTextures);
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

	private function setInsetGroupedListStyles(list:GroupedList):Void
	{
		this.setScrollerStyles(list);

		list.verticalScrollPolicy = GroupedList.SCROLL_POLICY_AUTO;

		list.backgroundSkin = new Scale9Image(this.insetBorderBackgroundSkinTextures);

		list.padding = this.borderSize;

		list.customItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER;
		list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
		list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;

		var layout:VerticalLayout = new VerticalLayout();
		layout.useVirtualLayout = true;
		layout.paddingTop = this.gutterSize;
		layout.paddingBottom = this.gutterSize;
		layout.gap = 0;
		layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
		layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
		list.layout = layout;
	}

	private function setInsetGroupedListItemRendererStyles(renderer:BaseDefaultItemRenderer):Void
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
		renderer.paddingRight = this.gutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.gap = this.extraSmallGutterSize;
		renderer.minGap = this.extraSmallGutterSize;
		renderer.accessoryGap = Float.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.smallGutterSize;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;

		renderer.useStateDelayTimer = false;
	}

	private function setInsetGroupedListHeaderRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.contentLabelProperties.textFormat = this.defaultTextFormat;
		renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

		renderer.paddingTop = this.gutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;
	}

	private function setInsetGroupedListFooterRendererStyles(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.contentLabelProperties.textFormat = this.defaultTextFormat;
		renderer.contentLabelProperties.disabledTextFormat = this.disabledTextFormat;

		renderer.paddingTop = this.smallGutterSize;
		renderer.paddingBottom = this.smallGutterSize;
		renderer.paddingRight = this.gutterSize;
		renderer.paddingLeft = this.gutterSize;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;
	}

//-------------------------
// Header
//-------------------------

	private function setHeaderStyles(header:Header):Void
	{
		header.backgroundSkin = new Scale9Image(this.headerBackgroundSkinTextures);

		header.minWidth = this.gridSize;
		header.minHeight = this.gridSize;

		header.titleProperties.textFormat = this.defaultTextFormat;
		header.titleProperties.disabledTextFormat = this.disabledTextFormat;

		header.paddingTop = this.extraSmallGutterSize;
		header.paddingBottom = this.extraSmallGutterSize + this.borderSize;
		header.paddingLeft = this.smallGutterSize;
		header.paddingRight = this.smallGutterSize;

		header.gap = this.extraSmallGutterSize;
		header.titleGap = this.gutterSize;
	}

//-------------------------
// Label
//-------------------------

	private function setLabelStyles(label:Label):Void
	{
		label.textRendererProperties.textFormat = this.defaultTextFormat;
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
// LayoutGroup
//-------------------------

	private function setToolbarLayoutGroupStyles(group:LayoutGroup):Void
	{
		if(!group.layout)
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.paddingTop = this.extraSmallGutterSize;
			layout.paddingBottom = this.extraSmallGutterSize;
			layout.paddingRight = this.smallGutterSize;
			layout.paddingLeft = this.smallGutterSize;
			layout.gap = this.smallGutterSize;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			group.layout = layout;
		}

		group.minHeight = this.gridSize;
		group.backgroundSkin = new Scale9Image(headerBackgroundSkinTextures);
	}

//-------------------------
// List
//-------------------------

	private function setListStyles(list:List):Void
	{
		this.setScrollerStyles(list);

		list.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;

		list.backgroundSkin = new Scale9Image(this.simpleBorderBackgroundSkinTextures);

		list.padding = this.borderSize;
	}

	private function setItemRendererStyles(renderer:BaseDefaultItemRenderer):Void
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
		renderer.accessoryGap = Float.POSITIVE_INFINITY;
		renderer.minAccessoryGap = this.smallGutterSize;
		renderer.minWidth = this.controlSize;
		renderer.minHeight = this.controlSize;

		renderer.useStateDelayTimer = false;
	}

	private function setItemRendererAccessoryLabelStyles(renderer:TextFieldTextRenderer):Void
	{
		renderer.textFormat = this.defaultTextFormat;
	}

	private function setItemRendererIconLabelStyles(renderer:TextFieldTextRenderer):Void
	{
		renderer.textFormat = this.defaultTextFormat;
	}

//-------------------------
// NumericStepper
//-------------------------

	private function setNumericStepperStyles(stepper:NumericStepper):Void
	{
		stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;

		stepper.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		stepper.focusPadding = -1;
	}

	private function setNumericStepperIncrementButtonStyles(button:Button):Void
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

	private function setNumericStepperDecrementButtonStyles(button:Button):Void
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

	private function setNumericStepperTextInputStyles(input:TextInput):Void
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

		var backgroundSkin:Scale9Image = new Scale9Image(textInputBackgroundEnabledSkinTextures);
		backgroundSkin.width = backgroundSkin.height;
		input.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(textInputBackgroundDisabledSkinTextures);
		backgroundDisabledSkin.width = backgroundDisabledSkin.height;
		input.backgroundDisabledSkin = backgroundDisabledSkin;
	}

//-------------------------
// PanelScreen
//-------------------------

	private function setPanelScreenStyles(screen:PanelScreen):Void
	{
		this.setScrollerStyles(screen);
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

		panel.backgroundSkin = new Scale9Image(this.panelBorderBackgroundSkinTextures);

		panel.paddingTop = 0;
		panel.paddingRight = this.gutterSize;
		panel.paddingBottom = this.gutterSize;
		panel.paddingLeft = this.gutterSize;
	}

	private function setPanelHeaderStyles(header:Header):Void
	{
		header.titleProperties.textFormat = this.defaultTextFormat;
		header.titleProperties.disabledTextFormat = this.disabledTextFormat;

		header.minHeight = this.gridSize;

		header.paddingTop = this.extraSmallGutterSize;
		header.paddingBottom = this.extraSmallGutterSize;
		header.paddingLeft = this.gutterSize;
		header.paddingRight = this.gutterSize;
		header.gap = this.extraSmallGutterSize;
		header.titleGap = this.smallGutterSize;
	}

//-------------------------
// PickerList
//-------------------------

	private function setPickerListStyles(list:PickerList):Void
	{
		list.popUpContentManager = new DropDownPopUpContentManager();
	}

	private function setPickerListButtonStyles(button:Button):Void
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

		button.gap = Float.POSITIVE_INFINITY; //fill as completely as possible
		button.minGap = this.smallGutterSize;
		button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		button.iconPosition = Button.ICON_POSITION_RIGHT;
		button.paddingRight = this.smallGutterSize;
	}

//-------------------------
// ProgressBar
//-------------------------

	private function setProgressBarStyles(progress:ProgressBar):Void
	{
		var backgroundSkin:Scale9Image = new Scale9Image(this.simpleBorderBackgroundSkinTextures);
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

	private function setRadioStyles(radio:Radio):Void
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

		radio.horizontalAlign = Radio.HORIZONTAL_ALIGN_LEFT;
		radio.verticalAlign = Radio.VERTICAL_ALIGN_MIDDLE;

		radio.gap = this.smallGutterSize;
		radio.minWidth = this.controlSize;
		radio.minHeight = this.controlSize;
	}

//-------------------------
// ScrollBar
//-------------------------

	private function setHorizontalScrollBarStyles(scrollBar:ScrollBar):Void
	{
		scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

		scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON;
		scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON;
		scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB;
		scrollBar.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK;
	}

	private function setVerticalScrollBarStyles(scrollBar:ScrollBar):Void
	{
		scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;

		scrollBar.customIncrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON;
		scrollBar.customDecrementButtonStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON;
		scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB;
		scrollBar.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK;
	}

	private function setHorizontalScrollBarIncrementButtonStyles(button:Button):Void
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

	private function setHorizontalScrollBarDecrementButtonStyles(button:Button):Void
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

	private function setHorizontalScrollBarThumbStyles(thumb:Button):Void
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

	private function setHorizontalScrollBarMinimumTrackStyles(track:Button):Void
	{
		track.defaultSkin = new Scale9Image(this.hScrollBarTrackSkinTextures);

		track.hasLabelTextRenderer = false;
	}

	private function setVerticalScrollBarIncrementButtonStyles(button:Button):Void
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

	private function setVerticalScrollBarDecrementButtonStyles(button:Button):Void
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

	private function setVerticalScrollBarThumbStyles(thumb:Button):Void
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

	private function setVerticalScrollBarMinimumTrackStyles(track:Button):Void
	{
		track.defaultSkin = new Scale9Image(this.vScrollBarTrackSkinTextures);

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

		if(!container.layout)
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.paddingTop = this.extraSmallGutterSize;
			layout.paddingBottom = this.extraSmallGutterSize;
			layout.paddingRight = this.smallGutterSize;
			layout.paddingLeft = this.smallGutterSize;
			layout.gap = this.extraSmallGutterSize;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			container.layout = layout;
		}

		container.minHeight = this.gridSize;

		container.backgroundSkin = new Scale9Image(headerBackgroundSkinTextures);
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

		text.textFormat = this.defaultTextFormat;
		text.disabledTextFormat = this.disabledTextFormat;
		text.padding = this.gutterSize;
	}

//-------------------------
// SimpleScrollBar
//-------------------------

	private function setHorizontalSimpleScrollBarStyles(scrollBar:SimpleScrollBar):Void
	{
		scrollBar.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
	}

	private function setVerticalSimpleScrollBarStyles(scrollBar:SimpleScrollBar):Void
	{
		scrollBar.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
	}

	private function setHorizontalSimpleScrollBarThumbStyles(thumb:Button):Void
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

	private function setVerticalSimpleScrollBarThumbStyles(thumb:Button):Void
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

	private function setSliderStyles(slider:Slider):Void
	{
		slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;
		slider.minimumPadding = slider.maximumPadding = -vSliderThumbUpSkinTexture.height / 2;

		if(slider.direction == Slider.DIRECTION_VERTICAL)
		{
			slider.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB;
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;

			slider.focusPaddingLeft = slider.focusPaddingRight = -2;
			slider.focusPaddingTop = slider.focusPaddingBottom = -2 + slider.minimumPadding;
		}
		else //horizontal
		{
			slider.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB;
			slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;

			slider.focusPaddingTop = slider.focusPaddingBottom = -2;
			slider.focusPaddingLeft = slider.focusPaddingRight = -2 + slider.minimumPadding;
		}

		slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
	}

	private function setHorizontalSliderThumbStyles(thumb:Button):Void
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

	private function setHorizontalSliderMinimumTrackStyles(track:Button):Void
	{
		var defaultSkin:Scale3Image = new Scale3Image(this.hSliderTrackEnabledSkinTextures)
		defaultSkin.width = this.wideControlSize;
		track.defaultSkin = defaultSkin;
		
		track.minTouchHeight = this.controlSize;

		track.hasLabelTextRenderer = false;
	}

	private function setVerticalSliderThumbStyles(thumb:Button):Void
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

	private function setVerticalSliderMinimumTrackStyles(track:Button):Void
	{
		var defaultSkin:Scale3Image = new Scale3Image(this.vSliderTrackEnabledSkinTextures);
		defaultSkin.height = this.wideControlSize;
		track.defaultSkin = defaultSkin;

		track.minTouchWidth = this.controlSize;

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

		tab.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);

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

	private function setTextAreaStyles(textArea:TextArea):Void
	{
		this.setScrollerStyles(textArea);

		textArea.textEditorProperties.textFormat = this.defaultTextFormat;
		textArea.textEditorProperties.disabledTextFormat = this.disabledTextFormat;
		textArea.textEditorProperties.paddingTop = this.extraSmallGutterSize;
		textArea.textEditorProperties.paddingRight = this.smallGutterSize;
		textArea.textEditorProperties.paddingBottom = this.extraSmallGutterSize;
		textArea.textEditorProperties.paddingLeft = this.smallGutterSize;

		textArea.padding = this.borderSize;

		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.textInputBackgroundEnabledSkinTextures;
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

	private function setBaseTextInputStyles(input:TextInput):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = this.textInputBackgroundEnabledSkinTextures;
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

	private function setTextInputStyles(input:TextInput):Void
	{
		this.setBaseTextInputStyles(input);
	}

	private function setSearchTextInputStyles(input:TextInput):Void
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

	private function setToggleSwitchStyles(toggle:ToggleSwitch):Void
	{
		toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
		toggle.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
		toggle.defaultLabelProperties.textFormat = this.defaultTextFormat;
		toggle.disabledLabelProperties.textFormat = this.disabledTextFormat;

		toggle.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		toggle.focusPadding = -1;
	}

	private function setToggleSwitchOnTrackStyles(track:Button):Void
	{
		var defaultSkin:Scale9Image = new Scale9Image(this.toggleButtonSelectedUpSkinTextures);
		defaultSkin.width = 2 * this.controlSize + this.smallControlSize;
		track.defaultSkin = defaultSkin;

		track.hasLabelTextRenderer = false;
	}

	private function setToggleSwitchThumbStyles(thumb:Button):Void
	{
		this.setButtonStyles(thumb);

		var frame:Rectangle = this.buttonUpSkinTextures.texture.frame;
		if(frame)
		{
			thumb.width = thumb.height = this.buttonUpSkinTextures.texture.frame.height;
		}
		else
		{
			thumb.width = thumb.height = this.buttonUpSkinTextures.texture.height;
		}

		thumb.hasLabelTextRenderer = false;
	}

//-------------------------
// PlayPauseToggleButton
//-------------------------

	private function setPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.quietButtonHoverSkinTextures, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, null, false);
		skinSelector.setValueForState(this.toggleButtonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
		skinSelector.setValueForState(this.toggleButtonSelectedDownSkinTextures, Button.STATE_DOWN, true);
		skinSelector.setValueForState(this.toggleButtonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		button.focusPadding = -1;
		
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.defaultValue = this.playPauseButtonPlayUpIconTexture;
		iconSelector.defaultSelectedValue = this.playPauseButtonPauseUpIconTexture;
		iconSelector.displayObjectProperties =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.hasLabelTextRenderer = false;

		button.paddingTop = this.extraSmallGutterSize;
		button.paddingRight = this.smallGutterSize;
		button.paddingBottom = this.extraSmallGutterSize;
		button.paddingLeft = this.smallGutterSize;
		button.gap = this.smallGutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

	private function setOverlayPlayPauseToggleButtonStyles(button:PlayPauseToggleButton):Void
	{
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayUpIconTexture, Button.STATE_UP, false);
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayUpIconTexture, Button.STATE_HOVER, false);
		iconSelector.setValueForState(this.overlayPlayPauseButtonPlayUpIconTexture, Button.STATE_DOWN, false);
		iconSelector.displayObjectProperties =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;
		
		button.isFocusEnabled = false;

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
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.quietButtonHoverSkinTextures, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, null, false);
		skinSelector.setValueForState(this.toggleButtonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
		skinSelector.setValueForState(this.toggleButtonSelectedDownSkinTextures, Button.STATE_DOWN, true);
		skinSelector.setValueForState(this.toggleButtonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		button.focusPadding = -1;
		
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.defaultValue = this.fullScreenToggleButtonEnterUpIconTexture;
		iconSelector.defaultSelectedValue = this.fullScreenToggleButtonExitUpIconTexture;
		iconSelector.displayObjectProperties =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.hasLabelTextRenderer = false;

		button.paddingTop = this.extraSmallGutterSize;
		button.paddingRight = this.smallGutterSize;
		button.paddingBottom = this.extraSmallGutterSize;
		button.paddingLeft = this.smallGutterSize;
		button.gap = this.smallGutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

//-------------------------
// VolumeSlider
//-------------------------

	private function setVolumeSliderStyles(slider:VolumeSlider):Void
	{
		slider.trackLayoutMode = VolumeSlider.TRACK_LAYOUT_MODE_MIN_MAX;
		slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		slider.focusPadding = -1;
		slider.showThumb = false;
		if(slider.direction == VolumeSlider.DIRECTION_VERTICAL)
		{
			slider.customMinimumTrackName = THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MINIMUM_TRACK;
			slider.customMaximumTrackName = THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MAXIMUM_TRACK;
			slider.width = this.verticalVolumeSliderMinimumTrackSkinTexture.width * this.scale;
			slider.height = this.verticalVolumeSliderMinimumTrackSkinTexture.height * this.scale;
		}
		else //horizontal
		{
			slider.customMinimumTrackName = THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MINIMUM_TRACK;
			slider.customMaximumTrackName = THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MAXIMUM_TRACK;
			slider.width = this.horizontalVolumeSliderMinimumTrackSkinTexture.width * this.scale;
			slider.height = this.horizontalVolumeSliderMinimumTrackSkinTexture.height * this.scale;
		}
	}

	private function setVolumeSliderThumbStyles(button:Button):Void
	{
		var thumbSize:Float = 6 * this.scale;
		button.defaultSkin = new Quad(thumbSize, thumbSize);
		button.defaultSkin.width = 0;
		button.defaultSkin.height = 0;
		button.hasLabelTextRenderer = false;
	}

	private function setHorizontalVolumeSliderMinimumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.source = this.horizontalVolumeSliderMinimumTrackSkinTexture;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
	}

	private function setHorizontalVolumeSliderMaximumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.horizontalAlign = ImageLoader.HORIZONTAL_ALIGN_RIGHT;
		defaultSkin.source = this.horizontalVolumeSliderMaximumTrackSkinTexture;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
	}

	private function setVerticalVolumeSliderMinimumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.verticalAlign = ImageLoader.VERTICAL_ALIGN_BOTTOM;
		defaultSkin.source = this.verticalVolumeSliderMinimumTrackSkinTexture;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
	}

	private function setVerticalVolumeSliderMaximumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.source = this.verticalVolumeSliderMaximumTrackSkinTexture;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
	}

//-------------------------
// MuteToggleButton
//-------------------------

	private function setMuteToggleButtonStyles(button:MuteToggleButton):Void
	{
		var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		skinSelector.defaultValue = null;
		skinSelector.setValueForState(this.quietButtonHoverSkinTextures, Button.STATE_HOVER, false);
		skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(this.buttonDisabledSkinTextures, null, false);
		skinSelector.setValueForState(this.toggleButtonSelectedHoverSkinTextures, Button.STATE_HOVER, true);
		skinSelector.setValueForState(this.toggleButtonSelectedDownSkinTextures, Button.STATE_DOWN, true);
		skinSelector.setValueForState(this.toggleButtonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		skinSelector.displayObjectProperties =
		{
			width: this.controlSize,
			height: this.controlSize,
			textureScale: this.scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
		button.focusPadding = -1;
		
		var iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
		iconSelector.defaultValue = this.muteToggleButtonLoudUpIconTexture;
		iconSelector.defaultSelectedValue = this.muteToggleButtonMutedUpIconTexture;
		iconSelector.displayObjectProperties =
		{
			scaleX: this.scale,
			scaleY: this.scale
		};
		button.stateToIconFunction = iconSelector.updateValue;

		button.showVolumeSliderOnHover = true;
		button.hasLabelTextRenderer = false;

		button.paddingTop = this.extraSmallGutterSize;
		button.paddingRight = this.smallGutterSize;
		button.paddingBottom = this.extraSmallGutterSize;
		button.paddingLeft = this.smallGutterSize;
		button.gap = this.smallGutterSize;
		button.minWidth = this.controlSize;
		button.minHeight = this.controlSize;
	}

	private function setPopUpVolumeSliderStyles(slider:VolumeSlider):Void
	{
		slider.direction = VolumeSlider.DIRECTION_VERTICAL;
		slider.trackLayoutMode = VolumeSlider.TRACK_LAYOUT_MODE_MIN_MAX;
		slider.showThumb = false;
		slider.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures, this.scale);
		slider.focusPadding = 4 * this.scale;
		slider.width = this.popUpVolumeSliderMinimumTrackSkinTexture.width * this.scale;
		slider.height = this.popUpVolumeSliderMinimumTrackSkinTexture.height * this.scale;
		slider.minimumPadding = this.popUpVolumeSliderPaddingSize;
		slider.maximumPadding = this.popUpVolumeSliderPaddingSize;
		slider.customMinimumTrackStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK;
		slider.customMaximumTrackStyleName = THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MAXIMUM_TRACK;
	}

	private function setPopUpVolumeSliderMinimumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.verticalAlign = ImageLoader.VERTICAL_ALIGN_BOTTOM;
		defaultSkin.source = this.popUpVolumeSliderMinimumTrackSkinTexture;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
	}

	private function setPopUpVolumeSliderMaximumTrackStyles(track:Button):Void
	{
		var defaultSkin:ImageLoader = new ImageLoader();
		defaultSkin.scaleContent = false;
		defaultSkin.source = this.popUpVolumeSliderMaximumTrackSkinTexture;
		track.defaultSkin = defaultSkin;
		track.hasLabelTextRenderer = false;
	}

//-------------------------
// SeekSlider
//-------------------------

	private function setSeekSliderStyles(slider:SeekSlider):Void
	{
		slider.direction = SeekSlider.DIRECTION_HORIZONTAL;
		slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
		
		slider.minimumPadding = slider.maximumPadding = -this.vSliderThumbUpSkinTexture.height / 2;

		slider.focusPaddingTop = slider.focusPaddingBottom = -2;
		slider.focusPaddingLeft = slider.focusPaddingRight = -2 + slider.minimumPadding;
		
		slider.minWidth = this.wideControlSize;
		slider.minHeight = this.smallControlSize;
	}

	private function setSeekSliderMinimumTrackStyles(track:Button):Void
	{
		var defaultSkin:Scale3Image = new Scale3Image(this.seekSliderMinimumTrackSkinTextures, this.scale);
		defaultSkin.width = this.wideControlSize;
		track.defaultSkin = defaultSkin;
		track.minTouchHeight = this.controlSize;
		track.hasLabelTextRenderer = false;
	}

	private function setSeekSliderMaximumTrackStyles(track:Button):Void
	{
		var defaultSkin:Scale3Image = new Scale3Image(this.seekSliderMaximumTrackSkinTextures, this.scale);
		defaultSkin.width = this.wideControlSize;
		track.defaultSkin = defaultSkin;
		track.minTouchHeight = this.controlSize;
		track.hasLabelTextRenderer = false;
	}
}
}
