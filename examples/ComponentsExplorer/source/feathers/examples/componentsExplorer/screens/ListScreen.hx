package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
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

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]//[Event(name="showSettings",type="starling.events.Event")]

class ListScreen extends PanelScreen
{
	inline public static var SHOW_SETTINGS:String = "showSettings";

	public function ListScreen()
	{
		super();
	}

	public var settings:ListSettings;

	private var _list:List;
	private var _backButton:Button;
	private var _settingsButton:Button;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.layout = new AnchorLayout();

		var items:Array = [];
		for(i in 0 ... 150)
		{
			var item:Dynamic = {text: "Item " + (i + 1).toString()};
			items[i] = item;
		}
		items.fixed = true;
		
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

		this.headerProperties.title = "List";

		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this._backButton = new Button();
			this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this.headerProperties.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			this.backButtonHandler = this.onBackButton;
		}

		this._settingsButton = new Button();
		this._settingsButton.label = "Settings";
		this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

		this.headerProperties.rightItems = new <DisplayObject>
		[
			this._settingsButton
		];

		this.owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);
	}
	
	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
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
		trace("List onChange:", selectedIndices.length > 0 ? selectedIndices : this._list.selectedIndex);
	}

	private function owner_transitionCompleteHandler(event:Event):Void
	{
		this.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);
		this._list.revealScrollBars();
	}
}