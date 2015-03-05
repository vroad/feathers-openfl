package feathers.examples.youtube.screens;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.ScreenNavigatorItem;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.core.FeathersControl;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.examples.youtube.models.VideoFeed;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.StandardIcons;
import openfl.errors.Error;

import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

import starling.events.Event;
import starling.textures.Texture;
//[Event(name="listVideos",type="starling.events.Event")]

class MainMenuScreen extends PanelScreen
{
	inline public static var LIST_VIDEOS:String = "listVideos";

	inline private static var CATEGORIES_URL:String = "http://gdata.youtube.com/schemas/2007/categories.cat";
	inline private static var FEED_URL_BEFORE:String = "http://gdata.youtube.com/feeds/api/standardfeeds/US/most_popular_";
	inline private static var FEED_URL_AFTER:String = "?v=2";

	public function new()
	{
		super();
		this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	private var _list:List;

	private var _loader:URLLoader;
	private var _message:Label;

	public var savedVerticalScrollPosition:Float = 0;
	public var savedSelectedIndex:Int = -1;
	public var savedDataProvider:ListCollection;

	override private function initialize():Void
	{
		super.initialize();

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.itemRendererFactory = function():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

			//enable the quick hit area to optimize hit tests when an item
			//is only selectable and doesn't have interactive children.
			renderer.isQuickHitAreaEnabled = true;

			renderer.labelField = "name";
			renderer.accessorySourceFunction = accessorySourceFunction;
			return renderer;
		}
		//when navigating to video results, we save this information to
		//restore the list when later navigating back to this screen.
		if(this.savedDataProvider != null)
		{
			this._list.dataProvider = this.savedDataProvider;
			this._list.selectedIndex = this.savedSelectedIndex;
			this._list.verticalScrollPosition = this.savedVerticalScrollPosition;
		}
		this.addChild(this._list);

		this._message = new Label();
		this._message.text = "Loading...";
		this._message.layoutData = new AnchorLayoutData(Math.NaN, Math.NaN, Math.NaN, Math.NaN, 0, 0);
		//hide the loading message if we're using restored results
		this._message.visible = this.savedDataProvider == null;
		this.addChild(this._message);

		this.headerProperties.setProperty("title", "YouTube Feeds");

		this.owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);
	}

	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);

		//only load the list of videos if don't have restored results
		if(this.savedDataProvider == null && dataInvalid)
		{
			this._list.dataProvider = null;
			this._message.visible = true;
			if(this._loader != null)
			{
				this.cleanUpLoader();
			}
			this._loader = new URLLoader();
			this._loader.addEventListener(openfl.events.Event.COMPLETE, loader_completeHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			this._loader.load(new URLRequest(CATEGORIES_URL));
		}

		//never forget to call super.draw()!
		super.draw();
	}

	private function cleanUpLoader():Void
	{
		if(this._loader == null)
		{
			return;
		}
		this._loader.removeEventListener(openfl.events.Event.COMPLETE, loader_completeHandler);
		this._loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
		this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
		this._loader = null;
	}

	private function parseFeed(feed:Xml):Void
	{
		this._message.visible = false;

		//var atom:Namespace = feed.namespace("atom");
		//var yt:Namespace = feed.namespace("yt");
		var deprecatedElement:String = "deprecated";
		var browsableElement:String = "browsable";

		var items:Array<VideoFeed> = new Array();
		var categories:Iterator<Xml> = feed.elementsNamed("category");
		for(category in categories)
		{
			var item:VideoFeed = new VideoFeed();
			if(category.elementsNamed(deprecatedElement).hasNext())
			{
				continue;
			}
			var browsable:Iterator<Xml> = category.elementsNamed(browsableElement);
			if(!browsable.hasNext())
			{
				continue;
			}
			var regions:String = browsable.next().get("regions");
			if(regions.toString().indexOf("US") < 0)
			{
				continue;
			}
			item.name = category.get("label");
			var term:String = category.get("term");
			//item.url = FEED_URL_BEFORE + encodeURI(term) + FEED_URL_AFTER;
			item.url = FEED_URL_BEFORE + term + FEED_URL_AFTER;
			items.push(item);
		}
		var collection:ListCollection = new ListCollection(items);
		this._list.dataProvider = collection;

		//show the scroll bars so that the user knows they can scroll
		this._list.revealScrollBars();
	}

	private function accessorySourceFunction(item:Dynamic):Texture
	{
		return StandardIcons.listDrillDownAccessoryTexture;
	}

	private function list_changeHandler(event:starling.events.Event):Void
	{
		var screenItem:ScreenNavigatorItem = this._owner.getScreen(this.screenID);
		if(screenItem.properties == null)
		{
			screenItem.properties = {};
		}
		//we're going to save the position of the list so that when the user
		//navigates back to this screen, they won't need to scroll back to
		//the same position manually
		Reflect.setField(screenItem.properties, "savedVerticalScrollPosition", this._list.verticalScrollPosition);
		//we'll also save the selected index to temporarily highlight
		//the previously selected item when transitioning back
		Reflect.setField(screenItem.properties, "savedSelectedIndex", this._list.selectedIndex);
		//and we'll save the data provider so that we don't need to reload
		//data when we return to this screen. we can restore it.
		Reflect.setField(screenItem.properties, "savedDataProvider", this._list.dataProvider);

		this.dispatchEventWith(LIST_VIDEOS, false, cast(this._list.selectedItem, VideoFeed));
	}

	private function owner_transitionCompleteHandler(event:starling.events.Event):Void
	{
		this.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);

		this._list.selectedIndex = -1;
		this._list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);

		this._list.revealScrollBars();
	}

	private function removedFromStageHandler(event:starling.events.Event):Void
	{
		this.cleanUpLoader();
	}

	private function loader_completeHandler(event:openfl.events.Event):Void
	{
		try
		{
			var loaderData:Dynamic = this._loader.data;
			this.parseFeed(Xml.parse(loaderData).firstElement());
		}
		catch(error:Error)
		{
			this._message.text = "Unable to load data. Please try again later.";
			this._message.visible = true;
			this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
			trace(error.toString());
		}
		this.cleanUpLoader();
	}

	private function loader_errorHandler(event:ErrorEvent):Void
	{
		this.cleanUpLoader();
		this._message.text = "Unable to load data. Please try again later.";
		this._message.visible = true;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		trace(event.toString());
	}
}
