package feathers.examples.trainTimes.themes
{
import feathers.controls.Button;
import feathers.controls.Callout;
import feathers.controls.Header;
import feathers.controls.ImageLoader;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.ScrollContainer;
import feathers.controls.SimpleScrollBar;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.text.StageTextTextEditor;
import feathers.controls.text.TextFieldTextRenderer;
import feathers.core.FeathersControl;
import feathers.core.ITextEditor;
import feathers.core.ITextRenderer;
import feathers.core.PopUpManager;
import feathers.display.Scale3Image;
import feathers.display.Scale9Image;
import feathers.display.TiledImage;
import feathers.examples.trainTimes.controls.StationListItemRenderer;
import feathers.examples.trainTimes.screens.StationScreen;
import feathers.examples.trainTimes.screens.TimesScreen;
import feathers.layout.HorizontalLayout;
import feathers.system.DeviceCapabilities;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;
import feathers.themes.StyleNameFunctionTheme;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextFormat;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.ResizeEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

class TrainTimesTheme extends StyleNameFunctionTheme
{
	[Embed(source="/../assets/images/traintimes.png")]
	private static const ATLAS_IMAGE:Class;

	[Embed(source="/../assets/images/traintimes.xml",mimeType="application/octet-stream")]
	private static const ATLAS_XML:Class;

	[Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf",fontName="SourceSansPro",mimeType="application/x-font",embedAsCFF="false")]
	private static const SOURCE_SANS_PRO_REGULAR:Class;

	[Embed(source="/../assets/fonts/SourceSansPro-Bold.ttf",fontName="SourceSansProBold",fontWeight="bold",mimeType="application/x-font",embedAsCFF="false")]
	private static const SOURCE_SANS_PRO_BOLD:Class;

	[Embed(source="/../assets/fonts/SourceSansPro-BoldIt.ttf",fontName="SourceSansProBoldItalic",fontWeight="bold",fontStyle="italic",mimeType="application/x-font",embedAsCFF="false")]
	private static const SOURCE_SANS_PRO_BOLD_ITALIC:Class;

	private static const TIMES_LIST_ITEM_RENDERER_NAME:String = "traintimes-times-list-item-renderer";

	private static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
	private static const ORIGINAL_DPI_IPAD_RETINA:int = 264;

	private static const HEADER_SCALE9_GRID:Rectangle = new Rectangle(0, 0, 4, 5);
	private static const SCROLL_BAR_THUMB_REGION1:int = 5;
	private static const SCROLL_BAR_THUMB_REGION2:int = 14;

	private static const PRIMARY_TEXT_COLOR:uint = 0xe8caa4;
	private static const DETAIL_TEXT_COLOR:uint = 0x64908a;

	private static function textRendererFactory():ITextRenderer
	{
		var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		renderer.embedFonts = true;
		return renderer;
	}

	private static function textEditorFactory():ITextEditor
	{
		return new StageTextTextEditor();
	}

	private static function popUpOverlayFactory():DisplayObject
	{
		var quad:Quad = new Quad(100, 100, 0x1a1a1a);
		quad.alpha = 0.85;
		return quad;
	}

	public function TrainTimesTheme()
	{
		super();
		this.initialize();
	}

	private var scale:Number = 1;

	private var primaryBackground:TiledImage;

	private var defaultTextFormat:TextFormat;
	private var selectedTextFormat:TextFormat;
	private var headerTitleTextFormat:TextFormat;
	private var stationListNameTextFormat:TextFormat;
	private var stationListDetailTextFormat:TextFormat;

	private var atlas:TextureAtlas;
	private var atlasBitmapData:BitmapData;
	private var mainBackgroundTexture:Texture;
	private var headerBackgroundTextures:Scale9Textures;
	private var stationListNormalIconTexture:Texture;
	private var stationListFirstNormalIconTexture:Texture;
	private var stationListLastNormalIconTexture:Texture;
	private var stationListSelectedIconTexture:Texture;
	private var stationListFirstSelectedIconTexture:Texture;
	private var stationListLastSelectedIconTexture:Texture;
	private var confirmIconTexture:Texture;
	private var cancelIconTexture:Texture;
	private var backIconTexture:Texture;
	private var horizontalScrollBarThumbSkinTextures:Scale3Textures;
	private var verticalScrollBarThumbSkinTextures:Scale3Textures;

	override public function dispose():Void
	{
		if(this.primaryBackground)
		{
			Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.stage.removeChild(this.primaryBackground, true);
			this.primaryBackground = null;
		}
		if(this.atlas)
		{
			this.atlas.dispose();
			this.atlas = null;
		}
		if(this.atlasBitmapData)
		{
			this.atlasBitmapData.dispose();
			this.atlasBitmapData = null;
		}
		super.dispose();
	}

	private function initialize():Void
	{
		this.initializeScale();
		this.initializeGlobals();
		this.initializeTextures();
		this.initializeStage();
		this.initializeStyleProviders();
	}

	private function initializeStage():Void
	{
		this.primaryBackground = new TiledImage(this.mainBackgroundTexture);
		this.primaryBackground.width = Starling.current.stage.stageWidth;
		this.primaryBackground.height = Starling.current.stage.stageHeight;
		Starling.current.stage.addChildAt(this.primaryBackground, 0);
		Starling.current.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
	}

	private function initializeScale():Void
	{
		var scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			var originalDPI:int = ORIGINAL_DPI_IPAD_RETINA;
		}
		else
		{
			originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
		}

		this.scale = scaledDPI / originalDPI;
	}

	private function initializeGlobals():Void
	{
		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		FeathersControl.defaultTextEditorFactory = textEditorFactory;

		PopUpManager.overlayFactory = popUpOverlayFactory;
		Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
			Callout.stagePaddingLeft = 16 * this.scale;
	}

	private function initializeTextures():Void
	{
		var atlasBitmapData:BitmapData = (new ATLAS_IMAGE()).bitmapData;
		this.atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new ATLAS_XML()));
		if(Starling.handleLostContext)
		{
			this.atlasBitmapData = atlasBitmapData;
		}
		else
		{
			atlasBitmapData.dispose();
		}

		this.mainBackgroundTexture = this.atlas.getTexture("main-background");
		this.headerBackgroundTextures = new Scale9Textures(this.atlas.getTexture("header-background"), HEADER_SCALE9_GRID);
		this.stationListNormalIconTexture = this.atlas.getTexture("station-list-normal-icon");
		this.stationListFirstNormalIconTexture = this.atlas.getTexture("station-list-first-normal-icon");
		this.stationListLastNormalIconTexture = this.atlas.getTexture("station-list-last-normal-icon");
		this.stationListSelectedIconTexture = this.atlas.getTexture("station-list-selected-icon");
		this.stationListFirstSelectedIconTexture = this.atlas.getTexture("station-list-first-selected-icon");
		this.stationListLastSelectedIconTexture = this.atlas.getTexture("station-list-last-selected-icon");
		this.confirmIconTexture = this.atlas.getTexture("confirm-icon");
		this.cancelIconTexture = this.atlas.getTexture("cancel-icon");
		this.backIconTexture = this.atlas.getTexture("back-icon");
		this.horizontalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		this.verticalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_VERTICAL);

		//we need to use different font names because Flash runtimes seem to
		//have a bug where setting defaultTextFormat on a TextField with a
		//different TextFormat that has the same font name as the existing
		//defaultTextFormat value causes the new TextFormat to be ignored,
		//even if the new TextFormat has different bold or italic values.
		//wtf, right?
		var regularFontName:String = "SourceSansPro";
		var boldFontName:String = "SourceSansProBold";
		var boldItalicFontName:String = "SourceSansProBoldItalic";
		this.defaultTextFormat = new TextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
		this.selectedTextFormat = new TextFormat(boldFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR, true);
		this.headerTitleTextFormat = new TextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
		this.stationListNameTextFormat = new TextFormat(boldItalicFontName, Math.round(48 * this.scale), PRIMARY_TEXT_COLOR, true, true);
		this.stationListDetailTextFormat = new TextFormat(boldFontName, Math.round(24 * this.scale), DETAIL_TEXT_COLOR, true);
		this.stationListDetailTextFormat.letterSpacing = 6 * this.scale;
	}

	private function initializeStyleProviders():Void
	{
		this.getStyleProviderForClass(Button).defaultStyleFunction = setButtonStyles;
		this.getStyleProviderForClass(Button).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_CONFIRM_BUTTON, setConfirmButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_CANCEL_BUTTON, setCancelButtonStyles);
		this.getStyleProviderForClass(Button).setFunctionForStyleName(SimpleScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB, setNoStyles);
		this.getStyleProviderForClass(Label).defaultStyleFunction = setLabelStyles;
		this.getStyleProviderForClass(Label).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_NAME_LABEL, setStationListNameLabelStyles);
		this.getStyleProviderForClass(Label).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_DETAILS_LABEL, setStationListDetailLabelStyles);
		this.getStyleProviderForClass(Header).defaultStyleFunction = setHeaderStyles;
		this.getStyleProviderForClass(List).setFunctionForStyleName(StationScreen.CHILD_STYLE_NAME_STATION_LIST, setStationListStyles);
		this.getStyleProviderForClass(List).setFunctionForStyleName(TimesScreen.CHILD_STYLE_NAME_TIMES_LIST, setTimesListStyles);
		this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(TIMES_LIST_ITEM_RENDERER_NAME, setTimesListItemRendererStyles);
		this.getStyleProviderForClass(StationListItemRenderer).defaultStyleFunction = setStationListItemRendererStyles;
		this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(StationListItemRenderer.CHILD_STYLE_NAME_STATION_LIST_ACTION_CONTAINER, setActionContainerStyles);
	}

	private function imageLoaderFactory():ImageLoader
	{
		var image:ImageLoader = new ImageLoader();
		image.textureScale = this.scale;
		return image;
	}

	private function horizontalScrollBarFactory():SimpleScrollBar
	{
		var scrollBar:SimpleScrollBar = new SimpleScrollBar();
		scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
		var defaultSkin:Scale3Image = new Scale3Image(this.horizontalScrollBarThumbSkinTextures, this.scale);
		defaultSkin.width = 10 * this.scale;
		scrollBar.thumbProperties.defaultSkin = defaultSkin;
		scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 4 * this.scale;
		return scrollBar;
	}

	private function verticalScrollBarFactory():SimpleScrollBar
	{
		var scrollBar:SimpleScrollBar = new SimpleScrollBar();
		scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
		var defaultSkin:Scale3Image = new Scale3Image(this.verticalScrollBarThumbSkinTextures, this.scale);
		defaultSkin.height = 10 * this.scale;
		scrollBar.thumbProperties.defaultSkin = defaultSkin;
		scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 4 * this.scale;
		return scrollBar;
	}

	private function setNoStyles(target:DisplayObject):Void {}

	private function setLabelStyles(label:Label):Void
	{
		label.textRendererProperties.textFormat = this.defaultTextFormat;
	}

	private function setStationListNameLabelStyles(label:Label):Void
	{
		label.textRendererProperties.textFormat = this.stationListNameTextFormat;
	}

	private function setStationListDetailLabelStyles(label:Label):Void
	{
		label.textRendererProperties.textFormat = this.stationListDetailTextFormat;
	}

	private function setButtonStyles(button:Button):Void
	{
		var defaultIcon:ImageLoader = new ImageLoader();
		defaultIcon.source = this.backIconTexture;
		defaultIcon.textureScale = this.scale;
		defaultIcon.snapToPixels = true;
		button.defaultIcon = defaultIcon;
		button.minWidth = button.minHeight = 44 * this.scale;
		button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
	}

	private function setConfirmButtonStyles(button:Button):Void
	{
		var defaultIcon:ImageLoader = new ImageLoader();
		defaultIcon.source = this.confirmIconTexture;
		defaultIcon.textureScale = this.scale;
		defaultIcon.snapToPixels = true;
		button.defaultIcon = defaultIcon;
		button.minWidth = button.minHeight = 44 * this.scale;
		button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
	}

	private function setCancelButtonStyles(button:Button):Void
	{
		var defaultIcon:ImageLoader = new ImageLoader();
		defaultIcon.source = this.cancelIconTexture;
		defaultIcon.textureScale = this.scale;
		defaultIcon.snapToPixels = true;
		button.defaultIcon = defaultIcon;
		button.minWidth = button.minHeight = 44 * this.scale;
		button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
	}

	private function setHeaderStyles(header:Header):Void
	{
		header.useExtraPaddingForOSStatusBar = true;
		
		header.minWidth = 88 * this.scale;
		header.minHeight = 88 * this.scale;
		header.paddingTop = header.paddingRight = header.paddingBottom =
			header.paddingLeft = 14 * this.scale;
		header.titleAlign = Header.TITLE_ALIGN_PREFER_RIGHT;

		var backgroundSkin:Scale9Image = new Scale9Image(this.headerBackgroundTextures, this.scale);
		header.backgroundSkin = backgroundSkin;
		header.titleProperties.textFormat = this.headerTitleTextFormat;
	}

	private function setStationListStyles(list:List):Void
	{
		list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
		list.verticalScrollBarFactory = this.verticalScrollBarFactory;

		list.itemRendererType = StationListItemRenderer;
	}

	private function setTimesListStyles(list:List):Void
	{
		list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
		list.verticalScrollBarFactory = this.verticalScrollBarFactory;
		list.customItemRendererStyleName = TIMES_LIST_ITEM_RENDERER_NAME;
	}

	private function setTimesListItemRendererStyles(renderer:DefaultListItemRenderer):Void
	{
		var defaultSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0xff00ff);
		defaultSkin.alpha = 0;
		renderer.defaultSkin = defaultSkin;
		var defaultSelectedSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0xcc2a41);
		renderer.defaultSelectedSkin = defaultSelectedSkin;
		renderer.defaultLabelProperties.textFormat = this.defaultTextFormat;
		renderer.defaultSelectedLabelProperties.textFormat = this.selectedTextFormat;
		renderer.paddingLeft = 8 * this.scale;
		renderer.paddingRight = 16 * this.scale;
	}

	private function setStationListItemRendererStyles(renderer:StationListItemRenderer):Void
	{
		renderer.paddingLeft = 44 * this.scale;
		renderer.paddingRight = 32 * this.scale
		renderer.iconLoaderFactory = imageLoaderFactory;
		renderer.normalIconTexture = this.stationListNormalIconTexture;
		renderer.firstNormalIconTexture = this.stationListFirstNormalIconTexture;
		renderer.lastNormalIconTexture = this.stationListLastNormalIconTexture;
		renderer.selectedIconTexture = this.stationListSelectedIconTexture;
		renderer.firstSelectedIconTexture = this.stationListFirstSelectedIconTexture;
		renderer.lastSelectedIconTexture = this.stationListLastSelectedIconTexture;
	}

	private function setActionContainerStyles(container:ScrollContainer):Void
	{
		var backgroundSkin:Quad = new Quad(48 * this.scale, 48 * this.scale, 0xcc2a41);
		container.backgroundSkin = backgroundSkin;

		var layout:HorizontalLayout = new HorizontalLayout();
		layout.paddingRight = 32 * this.scale;
		layout.gap = 48 * this.scale;
		layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
		layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
		container.layout = layout;
	}

	private function stage_resizeHandler(event:ResizeEvent):Void
	{
		this.primaryBackground.width = event.width;
		this.primaryBackground.height = event.height;
	}
}
}
