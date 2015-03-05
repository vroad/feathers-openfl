package feathers.examples.trainTimes.themes;
import feathers.controls.Button;
import feathers.controls.Callout;
import feathers.controls.Header;
import feathers.controls.ImageLoader;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.ScrollContainer;
import feathers.controls.SimpleScrollBar;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.controls.text.StageTextTextEditor;
import feathers.controls.text.TextFieldTextRenderer;
import feathers.core.DisplayListWatcher;
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
import feathers.text.BitmapFontTextFormat;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;
import openfl.Assets;
import openfl.text.Font;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.events.Event;
import starling.events.ResizeEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

class TrainTimesTheme extends DisplayListWatcher
{
	//[Embed(source="/../assets/images/traintimes.png")]
	//inline private static var ATLAS_IMAGE:Class<Dynamic>;
	inline private static var ATLAS_IMAGE_FILE_NAME = "assets/images/traintimes.png";

	//[Embed(source="/../assets/images/traintimes.xml",mimeType="application/octet-stream")]
	//inline private static var ATLAS_XML:Class<Dynamic>;
	inline private static var ATLAS_XML_FILE_NAME = "assets/images/traintimes.xml";

	//[Embed(source="/../assets/fonts/SourceSansPro-Regular.ttf",fontName="SourceSansPro",mimeType="application/x-font",embedAsCFF="false")]
	//inline private static var SOURCE_SANS_PRO_REGULAR:Class<Dynamic>;
	inline private static var SOURCE_SANS_PRO_REGULAR_FILE_NAME = "assets/fonts/SourceSansPro-Regular.ttf";

	//[Embed(source="/../assets/fonts/SourceSansPro-Bold.ttf",fontName="SourceSansProBold",fontWeight="bold",mimeType="application/x-font",embedAsCFF="false")]
	//inline private static var SOURCE_SANS_PRO_BOLD:Class<Dynamic>;
	inline private static var SOURCE_SANS_PRO_BOLD_FILE_NAME = "assets/fonts/SourceSansPro-Bold.ttf";

	//[Embed(source="/../assets/fonts/SourceSansPro-BoldIt.ttf",fontName="SourceSansProBoldItalic",fontWeight="bold",fontStyle="italic",mimeType="application/x-font",embedAsCFF="false")]
	//inline private static var SOURCE_SANS_PRO_BOLD_ITALIC:Class<Dynamic>;
	inline private static var SOURCE_SANS_PRO_BOLD_IT_FILE_NAME = "assets/fonts/SourceSansPro-BoldIt.ttf";

	inline private static var TIMES_LIST_ITEM_RENDERER_NAME:String = "traintimes-times-list-item-renderer";

	inline private static var ORIGINAL_DPI_IPHONE_RETINA:Int = 326;
	inline private static var ORIGINAL_DPI_IPAD_RETINA:Int = 264;

	private static var HEADER_SCALE9_GRID:Rectangle = new Rectangle(0, 0, 4, 5);
	inline private static var SCROLL_BAR_THUMB_REGION1:Int = 5;
	inline private static var SCROLL_BAR_THUMB_REGION2:Int = 14;

	inline private static var PRIMARY_TEXT_COLOR:UInt = 0xe8caa4;
	inline private static var DETAIL_TEXT_COLOR:UInt = 0x64908a;

	private static function textRendererFactory():ITextRenderer
	{
		#if (html5 || flash)
		var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		#else
		var renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
		#end
		//renderer.embedFonts = true;
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

	public function new(container:DisplayObjectContainer = null, scaleToDPI:Bool = true)
	{
		if(container == null)
		{
			container = Starling.current.stage;
		}
		super(container);
		this._scaleToDPI = scaleToDPI;
		this.initialize();
	}

	private var _originalDPI:Int;

	public var originalDPI(get, never):Int;
	public function get_originalDPI():Int
	{
		return this._originalDPI;
	}

	private var _scaleToDPI:Bool;

	public var scaleToDPI(get, never):Bool;
	public function get_scaleToDPI():Bool
	{
		return this._scaleToDPI;
	}

	private var scale:Float = 1;

	private var primaryBackground:TiledImage;

	#if (flash || html5)
	private var defaultTextFormat:TextFormat;
	private var selectedTextFormat:TextFormat;
	private var headerTitleTextFormat:TextFormat;
	private var stationListNameTextFormat:TextFormat;
	private var stationListDetailTextFormat:TextFormat;
	#else
	private var defaultTextFormat:BitmapFontTextFormat;
	private var selectedTextFormat:BitmapFontTextFormat;
	private var headerTitleTextFormat:BitmapFontTextFormat;
	private var stationListNameTextFormat:BitmapFontTextFormat;
	private var stationListDetailTextFormat:BitmapFontTextFormat;
	#end

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
		if(this.root != null)
		{
			this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			if(this.primaryBackground != null)
			{
				this.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
				this.root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
				this.root.removeChild(this.primaryBackground, true);
				this.primaryBackground = null;
			}
		}
		if(this.atlas != null)
		{
			this.atlas.dispose();
			this.atlas = null;
		}
		if(this.atlasBitmapData != null)
		{
			this.atlasBitmapData.dispose();
			this.atlasBitmapData = null;
		}
		super.dispose();
	}

	private function initializeRoot():Void
	{
		this.primaryBackground = new TiledImage(this.mainBackgroundTexture);
		this.primaryBackground.width = root.stage.stageWidth;
		this.primaryBackground.height = root.stage.stageHeight;
		this.root.addChildAt(this.primaryBackground, 0);
		this.root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		this.root.addEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
	}

	private function initialize():Void
	{
		var scaledDPI:Int = Std.int(DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
		this._originalDPI = scaledDPI;
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

		this.scale = scaledDPI / this._originalDPI;

		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		FeathersControl.defaultTextEditorFactory = textEditorFactory;

		PopUpManager.overlayFactory = popUpOverlayFactory;
		Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
			Callout.stagePaddingLeft = 16 * this.scale;

		var atlasBitmapData:BitmapData = Assets.getBitmapData(ATLAS_IMAGE_FILE_NAME);
		this.atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), Xml.parse(Assets.getText(ATLAS_XML_FILE_NAME)).firstElement());
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

		
		var regularFont:Font = Assets.getFont(SOURCE_SANS_PRO_REGULAR_FILE_NAME);
		var boldFont:Font = Assets.getFont(SOURCE_SANS_PRO_BOLD_FILE_NAME);
		var boldItFont:Font = Assets.getFont(SOURCE_SANS_PRO_BOLD_IT_FILE_NAME);
		//we need to use different font names because Flash runtimes seem to
		//have a bug where setting defaultTextFormat on a TextField with a
		//different TextFormat that has the same font name as the existing
		//defaultTextFormat value causes the new TextFormat to be ignored,
		//even if the new TextFormat has different bold or italic values.
		//wtf, right?
		#if flash
		var regularFontName:String = "SourceSansPro";
		var boldFontName:String = "SourceSansProBold";
		var boldItalicFontName:String = "SourceSansProBoldItalic";
		#else
		var regularFontName:String = "Source Sans Pro";
		var boldFontName:String = "Source Sans Pro";
		var boldItalicFontName:String = "Source Sans Pro";
		#end
		#if (flash || html5)
		this.defaultTextFormat = new TextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
		this.selectedTextFormat = new TextFormat(boldFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR, true);
		this.headerTitleTextFormat = new TextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
		this.stationListNameTextFormat = new TextFormat(boldItalicFontName, Math.round(48 * this.scale), PRIMARY_TEXT_COLOR, true, true);
		this.stationListDetailTextFormat = new TextFormat(boldFontName, Math.round(24 * this.scale), DETAIL_TEXT_COLOR, true);
		this.stationListDetailTextFormat.letterSpacing = 6 * this.scale;
		#else
		this.defaultTextFormat = new BitmapFontTextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
		this.selectedTextFormat = new BitmapFontTextFormat(boldFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
		this.headerTitleTextFormat = new BitmapFontTextFormat(regularFontName, Math.round(36 * this.scale), PRIMARY_TEXT_COLOR);
		this.stationListNameTextFormat = new BitmapFontTextFormat(boldItalicFontName, Math.round(48 * this.scale), PRIMARY_TEXT_COLOR);
		this.stationListDetailTextFormat = new BitmapFontTextFormat(boldFontName, Math.round(24 * this.scale), DETAIL_TEXT_COLOR);
		this.stationListDetailTextFormat.letterSpacing = 6 * this.scale;
		#end

		if(this.root.stage != null)
		{
			this.initializeRoot();
		}
		else
		{
			this.root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
		}

		this.setInitializerForClass(Button, buttonInitializer);
		this.setInitializerForClass(Button, confirmButtonInitializer, StationListItemRenderer.CHILD_NAME_STATION_LIST_CONFIRM_BUTTON);
		this.setInitializerForClass(Button, cancelButtonInitializer, StationListItemRenderer.CHILD_NAME_STATION_LIST_CANCEL_BUTTON);
		this.setInitializerForClass(Button, nothingInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);
		this.setInitializerForClass(Label, labelInitializer);
		this.setInitializerForClass(Label, stationListNameLabelInitializer, StationListItemRenderer.CHILD_NAME_STATION_LIST_NAME_LABEL);
		this.setInitializerForClass(Label, stationListDetailLabelInitializer, StationListItemRenderer.CHILD_NAME_STATION_LIST_DETAILS_LABEL);
		this.setInitializerForClass(Header, headerInitializer);
		this.setInitializerForClass(List, stationListInitializer, StationScreen.CHILD_NAME_STATION_LIST);
		this.setInitializerForClass(List, timesListInitializer, TimesScreen.CHILD_NAME_TIMES_LIST);
		this.setInitializerForClass(DefaultListItemRenderer, timesListItemRendererInitializer, TIMES_LIST_ITEM_RENDERER_NAME);
		this.setInitializerForClass(StationListItemRenderer, stationListItemRendererInitializer);
		this.setInitializerForClass(ScrollContainer, actionContainerInitializer, StationListItemRenderer.CHILD_NAME_STATION_LIST_ACTION_CONTAINER);
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
		scrollBar.thumbProperties.setProperty("defaultSkin", defaultSkin);
		scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 4 * this.scale;
		return scrollBar;
	}

	private function verticalScrollBarFactory():SimpleScrollBar
	{
		var scrollBar:SimpleScrollBar = new SimpleScrollBar();
		scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
		var defaultSkin:Scale3Image = new Scale3Image(this.verticalScrollBarThumbSkinTextures, this.scale);
		defaultSkin.height = 10 * this.scale;
		scrollBar.thumbProperties.setProperty("defaultSkin", defaultSkin);
		scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 4 * this.scale;
		return scrollBar;
	}

	private function nothingInitializer(target:DisplayObject):Void {}

	private function labelInitializer(label:Label):Void
	{
		label.textRendererProperties.setProperty("textFormat", this.defaultTextFormat);
	}

	private function stationListNameLabelInitializer(label:Label):Void
	{
		label.textRendererProperties.setProperty("textFormat", this.stationListNameTextFormat);
	}

	private function stationListDetailLabelInitializer(label:Label):Void
	{
		label.textRendererProperties.setProperty("textFormat", this.stationListDetailTextFormat);
	}

	private function buttonInitializer(button:Button):Void
	{
		var defaultIcon:ImageLoader = new ImageLoader();
		defaultIcon.source = this.backIconTexture;
		defaultIcon.textureScale = this.scale;
		defaultIcon.snapToPixels = true;
		button.defaultIcon = defaultIcon;
		button.minWidth = button.minHeight = 44 * this.scale;
		button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
	}

	private function confirmButtonInitializer(button:Button):Void
	{
		var defaultIcon:ImageLoader = new ImageLoader();
		defaultIcon.source = this.confirmIconTexture;
		defaultIcon.textureScale = this.scale;
		defaultIcon.snapToPixels = true;
		button.defaultIcon = defaultIcon;
		button.minWidth = button.minHeight = 44 * this.scale;
		button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
	}

	private function cancelButtonInitializer(button:Button):Void
	{
		var defaultIcon:ImageLoader = new ImageLoader();
		defaultIcon.source = this.cancelIconTexture;
		defaultIcon.textureScale = this.scale;
		defaultIcon.snapToPixels = true;
		button.defaultIcon = defaultIcon;
		button.minWidth = button.minHeight = 44 * this.scale;
		button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
	}

	private function headerInitializer(header:Header):Void
	{
		header.minWidth = 88 * this.scale;
		header.minHeight = 88 * this.scale;
		header.paddingTop = header.paddingRight = header.paddingBottom =
			header.paddingLeft = 14 * this.scale;
		header.titleAlign = Header.TITLE_ALIGN_PREFER_RIGHT;

		var backgroundSkin:Scale9Image = new Scale9Image(this.headerBackgroundTextures, this.scale);
		header.backgroundSkin = backgroundSkin;
		header.titleProperties.setProperty("textFormat", this.headerTitleTextFormat);
	}

	private function stationListInitializer(list:List):Void
	{
		list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
		list.verticalScrollBarFactory = this.verticalScrollBarFactory;

		list.itemRendererType = StationListItemRenderer;
	}

	private function timesListInitializer(list:List):Void
	{
		list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
		list.verticalScrollBarFactory = this.verticalScrollBarFactory;
		list.itemRendererName = TIMES_LIST_ITEM_RENDERER_NAME;
	}

	private function timesListItemRendererInitializer(renderer:DefaultListItemRenderer):Void
	{
		var defaultSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0xff00ff);
		defaultSkin.alpha = 0;
		renderer.defaultSkin = defaultSkin;
		var defaultSelectedSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0xcc2a41);
		renderer.defaultSelectedSkin = defaultSelectedSkin;
		renderer.defaultLabelProperties.setProperty("textFormat", this.defaultTextFormat);
		renderer.defaultSelectedLabelProperties.setProperty("textFormat", this.selectedTextFormat);
		renderer.paddingLeft = 8 * this.scale;
		renderer.paddingRight = 16 * this.scale;
	}

	private function stationListItemRendererInitializer(renderer:StationListItemRenderer):Void
	{
		renderer.paddingLeft = 44 * this.scale;
		renderer.paddingRight = 32 * this.scale;
		renderer.iconLoaderFactory = imageLoaderFactory;
		renderer.normalIconTexture = this.stationListNormalIconTexture;
		renderer.firstNormalIconTexture = this.stationListFirstNormalIconTexture;
		renderer.lastNormalIconTexture = this.stationListLastNormalIconTexture;
		renderer.selectedIconTexture = this.stationListSelectedIconTexture;
		renderer.firstSelectedIconTexture = this.stationListFirstSelectedIconTexture;
		renderer.lastSelectedIconTexture = this.stationListLastSelectedIconTexture;
	}

	private function actionContainerInitializer(container:ScrollContainer):Void
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

	private function root_addedToStageHandler(event:Event):Void
	{
		this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
		this.initializeRoot();
	}

	private function root_removedFromStageHandler(event:Event):Void
	{
		this.root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
		this.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		this.root.removeChild(this.primaryBackground, true);
		this.primaryBackground = null;
	}
}
