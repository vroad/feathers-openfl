package feathers.examples.youtube.screens;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.ScreenNavigatorItem;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.core.FeathersControl;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.examples.youtube.models.VideoDetails;
import feathers.examples.youtube.models.YouTubeModel;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

import starling.display.DisplayObject;
import starling.events.Event;

//[Event(name="complete",type="starling.events.Event")]

//[Event(name="showVideoDetails",type="starling.events.Event")]

class ListVideosScreen extends PanelScreen
{
	inline public static var SHOW_VIDEO_DETAILS:String = "showVideoDetails";

	public function new()
	{
		super();
		this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	private var _backButton:Button;
	private var _list:List;
	private var _message:Label;

	private var _isTransitioning:Bool = false;

	private var _model:YouTubeModel;

	public var model(get, set):YouTubeModel;
	public function get_model():YouTubeModel
	{
		return this._model;
	}

	public function set_model(value:YouTubeModel):YouTubeModel
	{
		if(this._model == value)
		{
			return get_model();
		}
		this._model = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_model();
	}

	public var savedVerticalScrollPosition:Float = 0;
	public var savedSelectedIndex:Int = -1;
	public var savedDataProvider:ListCollection;

	private var _loader:URLLoader;
	private var _savedLoaderData:Dynamic;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.itemRendererFactory = function():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "title";
			renderer.accessoryLabelField = "author";
			//no accessory and anything interactive, so we can use the quick
			//hit area to improve performance.
			renderer.isQuickHitAreaEnabled = true;
			return renderer;
		}
		//when navigating to video details, we save this information to
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

		this._backButton = new Button();
		this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
		this._backButton.label = "Back";
		this._backButton.addEventListener(starling.events.Event.TRIGGERED, onBackButton);
		this.headerProperties.setProperty("leftItems",  
		[
			this._backButton
		]);

		this.backButtonHandler = onBackButton;

		this._isTransitioning = true;
		this._owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);
	}

	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);

		//only load the list of videos if don't have restored results
		if(this.savedDataProvider == null && dataInvalid)
		{
			this._list.dataProvider = null;
			if(this._model != null && this._model.selectedList != null)
			{
				this.headerProperties.setProperty("title", this._model.selectedList.name);
				if(this._loader != null)
				{
					this.cleanUpLoader();
				}
				if(this._model.cachedLists.exists(this._model.selectedList.url))
				{
					this._message.visible = false;
					this._list.dataProvider = cast(this._model.cachedLists[this._model.selectedList.url], ListCollection);

					//show the scroll bars so that the user knows they can scroll
					this._list.revealScrollBars();
				}
				else
				{
					this._loader = new URLLoader();
					this._loader.addEventListener(openfl.events.Event.COMPLETE, loader_completeHandler);
					this._loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
					this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
					this._loader.load(new URLRequest(this._model.selectedList.url));
				}
			}
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

		//var atom:Namespace = feed.namespace();
		//var media:Namespace = feed.namespace("media");

		var items:Array<VideoDetails> = new Array();
		var entries:Iterator<Xml> = feed.elementsNamed("entry");
		for(entry in entries)
		{
			var item:VideoDetails = new VideoDetails();
			item.title = entry.elementsNamed("title").next().toString();
			item.author = entry.elementsNamed("author").next().elementsNamed("name").next().toString();
			item.url = entry.elementsNamed("group").next().elementsNamed("player").next().get("url");
			item.description = entry.elementsNamed("group").next().elementsNamed("description").next().toString();
			items.push(item);
		}
		var collection:ListCollection = new ListCollection(items);
		this._model.cachedLists[this._model.selectedList.url] = collection;
		this._list.dataProvider = collection;

		//show the scroll bars so that the user knows they can scroll
		this._list.revealScrollBars();
	}

	private function onBackButton(event:starling.events.Event = null):Void
	{
		var screenItem:ScreenNavigatorItem = this._owner.getScreen(this.screenID);
		if(screenItem.properties != null)
		{
			//if we're going backwards, we should clear the restored results
			//because next time we come back, we may be asked to display
			//completely different data
			screenItem.properties.remove("savedVerticalScrollPosition");
			screenItem.properties.remove("savedSelectedIndex");
			screenItem.properties.remove("savedDataProvider");
		}

		this.dispatchEventWith(starling.events.Event.COMPLETE);
	}

	private function list_changeHandler(event:starling.events.Event):Void
	{
		if(this._list.selectedIndex < 0)
		{
			return;
		}

		var screenItem:ScreenNavigatorItem = this._owner.getScreen(this.screenID);
		if(screenItem.properties == null)
		{
			screenItem.properties = {}
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

		this.dispatchEventWith(SHOW_VIDEO_DETAILS, false, cast(this._list.selectedItem, VideoDetails));
	}

	private function removedFromStageHandler(event:starling.events.Event):Void
	{
		this.cleanUpLoader();
	}

	private function loader_completeHandler(event:openfl.events.Event):Void
	{
		var loaderData:Dynamic = this._loader.data;
		this.cleanUpLoader();
		if(this._isTransitioning)
		{
			//if this screen is still transitioning in, the we'll save the
			//feed until later to ensure that the animation isn't affected.
			this._savedLoaderData = loaderData;
			return;
		}
		this.parseFeed(Xml.parse(loaderData).firstElement());
	}

	private function loader_errorHandler(event:ErrorEvent):Void
	{
		this.cleanUpLoader();
		this._message.text = "Unable to load data. Please try again later.";
		this._message.visible = true;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		trace(event.toString());
	}

	private function owner_transitionCompleteHandler(event:starling.events.Event):Void
	{
		this.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);

		this._isTransitioning = false;

		if(this._savedLoaderData != null)
		{
			this.parseFeed(Xml.parse(this._savedLoaderData).firstElement());
			this._savedLoaderData = null;
		}

		this._list.selectedIndex = -1;
		this._list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);
		this._list.revealScrollBars();
	}
}
