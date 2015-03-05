package feathers.examples.gallery;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.data.ListCollection;
import feathers.layout.HorizontalLayout;
import feathers.utils.type.SafeCast.safe_cast;

import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.ResizeEvent;
import starling.textures.Texture;

@:keep class Main extends Sprite
{
	inline private static var FLICKR_API_KEY = "";

	//used by the extended theme
	inline public static var THUMBNAIL_LIST_NAME:String = "thumbnailList";

	private static var LOADER_CONTEXT:LoaderContext = new LoaderContext(true);
	inline private static var FLICKR_URL:String = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=" + FLICKR_API_KEY + "&format=rest";
	inline private static var FLICKR_PHOTO_URL:String = "https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_{size}.jpg";

	public function new()
	{
		super();
		this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private var selectedImage:Image;
	private var list:List;
	private var message:Label;
	private var apiLoader:URLLoader;
	private var loader:Loader;
	private var fadeTween:Tween;
	private var originalImageWidth:Float;
	private var originalImageHeight:Float;

	private function layout():Void
	{
		this.list.width = this.stage.stageWidth;
		this.list.height = 100;
		this.list.y = this.stage.stageHeight - this.list.height;

		var availableHeight:Float;
		if(this.selectedImage != null)
		{
			availableHeight = this.stage.stageHeight - this.list.height;
			var widthScale:Float = this.stage.stageWidth / this.originalImageWidth;
			var heightScale:Float = availableHeight / this.originalImageHeight;
			this.selectedImage.scaleX = this.selectedImage.scaleY = Math.min(1, Math.min(widthScale, heightScale));
			this.selectedImage.x = (this.stage.stageWidth - this.selectedImage.width) / 2;
			this.selectedImage.y = (availableHeight - this.selectedImage.height) / 2;
		}

		this.message.validate();
		availableHeight = this.stage.stageHeight - this.list.height;
		this.message.x = (this.stage.stageWidth - this.message.width) / 2;
		this.message.y = (availableHeight - this.message.height) / 2;
	}

	private function list_changeHandler(event:starling.events.Event):Void
	{
		var item:GalleryItem = safe_cast(this.list.selectedItem, GalleryItem);
		if(item == null)
		{
			if(this.selectedImage != null)
			{
				this.selectedImage.visible = false;
			}
			return;
		}
		if(this.loader != null)
		{
			this.loader.unloadAndStop(true);
		}
		else
		{
			this.loader = new Loader();
			this.loader.contentLoaderInfo.addEventListener(openfl.events.Event.COMPLETE, loader_completeHandler);
			this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
		}
		this.loader.load(new URLRequest(item.url), LOADER_CONTEXT);
		if(this.selectedImage != null)
		{
			this.selectedImage.visible = false;
		}
		if(this.fadeTween != null)
		{
			Starling.current.juggler.remove(this.fadeTween);
			this.fadeTween = null;
		}
		this.message.text = "Loading...";
		this.layout();
	}

	private function addedToStageHandler(event:starling.events.Event):Void
	{
		//this is an *extended* version of MetalWorksMobileTheme
		new GalleryTheme();

		this.apiLoader = new URLLoader();
		this.apiLoader.addEventListener(openfl.events.Event.COMPLETE, apiLoader_completeListener);
		this.apiLoader.addEventListener(IOErrorEvent.IO_ERROR, apiLoader_errorListener);
		this.apiLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, apiLoader_errorListener);
		this.apiLoader.load(new URLRequest(FLICKR_URL));

		this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

		var listLayout:HorizontalLayout = new HorizontalLayout();
		listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
		listLayout.hasVariableItemDimensions = true;

		this.list = new List();
		this.list.styleNameList.add(THUMBNAIL_LIST_NAME);
		this.list.layout = listLayout;
		this.list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
		this.list.snapScrollPositionsToPixels = true;
		this.list.itemRendererType = GalleryItemRenderer;
		this.list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);
		this.addChild(this.list);

		this.message = new Label();
		this.message.text = "Loading...";
		this.addChild(this.message);

		this.layout();
	}

	private function stage_resizeHandler(event:ResizeEvent):Void
	{
		this.layout();
	}

	private function apiLoader_completeListener(event:openfl.events.Event):Void
	{
		var result:Xml = this.apiLoader.data;
		if(result.get("stat") == "fail")
		{
			message.text = "Unable to load the list of images from Flickr at this time.";
			this.layout();
			return;
		}
		var items:Array<GalleryItem> = new Array();
		var photosList:Iterator<Xml> = result.elementsNamed("photos").next().elementsNamed("photo");
		for(photoXML in photosList)
		{
			var url:String = StringTools.replace(FLICKR_PHOTO_URL, "{farm-id}", photoXML.get("farm"));
			url = StringTools.replace(url, "{server-id}", photoXML.get("server"));
			url = StringTools.replace(url, "{id}", photoXML.get("id"));
			url = StringTools.replace(url, "{secret}", photoXML.get("secret"));
			var thumbURL:String = StringTools.replace(url, "{size}", "t");
			url = StringTools.replace(url, "{size}", "b");
			var title:String = photoXML.get("title");
			items.push(new GalleryItem(title, url, thumbURL));
		}

		this.message.text = "";

		this.list.dataProvider = new ListCollection(items);
		this.list.selectedIndex = 0;
	}

	private function apiLoader_errorListener(event:openfl.events.Event):Void
	{
		this.message.text = "Error loading images.";
		this.layout();
	}

	private function loader_completeHandler(event:openfl.events.Event):Void
	{
		var texture:Texture = Texture.fromBitmap(cast(this.loader.content, Bitmap));
		if(this.selectedImage != null)
		{
			this.selectedImage.texture.dispose();
			this.selectedImage.texture = texture;
			this.selectedImage.scaleX = this.selectedImage.scaleY = 1;
			this.selectedImage.readjustSize();
		}
		else
		{
			this.selectedImage = new Image(texture);
			this.addChildAt(this.selectedImage, 1);
		}
		this.originalImageWidth = this.selectedImage.width;
		this.originalImageHeight = this.selectedImage.height;
		this.selectedImage.alpha = 0;
		this.selectedImage.visible = true;

		this.fadeTween = new Tween(this.selectedImage, 0.5, Transitions.EASE_OUT);
		this.fadeTween.fadeTo(1);
		Starling.current.juggler.add(this.fadeTween);

		this.message.text = "";

		this.layout();
	}

	private function loader_errorHandler(event:openfl.events.Event):Void
	{
		this.message.text = "Error loading image.";
		this.layout();
	}
}
