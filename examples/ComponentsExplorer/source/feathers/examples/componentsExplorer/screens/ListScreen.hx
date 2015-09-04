package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.examples.componentsExplorer.data.ListSettings;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.system.DeviceCapabilities;
import haxe.ds.Vector;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]//[Event(name="showSettings",type="starling.events.Event")]

@:keep class ListScreen extends PanelScreen
{
	inline public static var SHOW_SETTINGS:String = "showSettings";

	public function new()
	{
		super();
	}

	public var settings:ListSettings;

	private var _list:List;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "List";

		this.layout = new AnchorLayout();

		var items:Vector<Dynamic> = new Vector(150);
		for(i in 0 ... 150)
		{
			var item:Dynamic = {text: "Item " + (i + 1)};
			items[i] = item;
		}
		//items.fixed = true;
		
		this._list = new List();
		this._list.dataProvider = new ListCollection(items);
		this._list.typicalItem = {text: "Item 1000"};
		this._list.isSelectable = this.settings.isSelectable;
		this._list.allowMultipleSelection = this.settings.allowMultipleSelection;
		this._list.hasElasticEdges = this.settings.hasElasticEdges;
		//optimization to reduce draw calls.
		//only do this if the header or other content covers the edges of
		//the list. otherwise, the list items may be displayed outside of
		//the list's bounds.
		this._list.clipContent = false;
		this._list.autoHideBackground = true;
		this._list.itemRendererFactory = function():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

			//enable the quick hit area to optimize hit tests when an item
			//is only selectable and doesn't have interactive children.
			renderer.isQuickHitAreaEnabled = true;

			renderer.labelField = "text";
			return renderer;
		};
		this._list.addEventListener(Event.CHANGE, list_changeHandler);
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this.addChild(this._list);

		this.headerFactory = this.customHeaderFactory;

		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{

			this.headerProperties.setProperty("leftItems", 
			[
				this._backButton
			]);

			this.backButtonHandler = this.onBackButton;
		}

		this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
	}
	private function customHeaderFactory():Header
	{
		var header:Header = new Header();
		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			var backButton:Button = new Button();
			backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
			backButton.label = "Back";
			backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			header.leftItems = new <DisplayObject>
			[
				backButton
			];
		}
		var settingsButton:Button = new Button();
		settingsButton.label = "Settings";
		settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
		header.rightItems = new <DisplayObject>
		[
			settingsButton
		]);
		return header;
	}
	
	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function transitionInCompleteHandler(event:Event):Void
	{
		this._list.revealScrollBars();
	}
	
	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}

	private function settingsButton_triggeredHandler(event:Event):Void
	{
		this.dispatchEventWith(SHOW_SETTINGS);
	}

	private function list_changeHandler(event:Event):Void
	{
		var selectedIndices:Array<Int> = this._list.selectedIndices;
		trace("List change:", selectedIndices.length > 0 ? selectedIndices : this._list.selectedIndex);
	}
}