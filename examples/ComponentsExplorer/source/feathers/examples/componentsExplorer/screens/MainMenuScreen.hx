package feathers.examples.componentsExplorer.screens;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.StandardIcons;
import feathers.system.DeviceCapabilities;

import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.textures.Texture;
//[Event(name="complete",type="starling.events.Event")]//[Event(name="showAlert",type="starling.events.Event")]//[Event(name="showButton",type="starling.events.Event")]//[Event(name="showButtonGroup",type="starling.events.Event")]//[Event(name="showCallout",type="starling.events.Event")]//[Event(name="showGroupedList",type="starling.events.Event")]//[Event(name="showItemRenderer",type="starling.events.Event")]//[Event(name="showList",type="starling.events.Event")]//[Event(name="showNumericStepper",type="starling.events.Event")]//[Event(name="showPageIndicator",type="starling.events.Event")]//[Event(name="showPickerList",type="starling.events.Event")]//[Event(name="showProgressBar",type="starling.events.Event")]//[Event(name="showScrollText",type="starling.events.Event")]//[Event(name="showSlider",type="starling.events.Event")]//[Event(name="showTabBar",type="starling.events.Event")]//[Event(name="showTextInput",type="starling.events.Event")]//[Event(name="showToggles",type="starling.events.Event")]

[Event(name="complete",type="starling.events.Event")]
[Event(name="showAlert",type="starling.events.Event")]
[Event(name="showButton",type="starling.events.Event")]
[Event(name="showButtonGroup",type="starling.events.Event")]
[Event(name="showCallout",type="starling.events.Event")]
[Event(name="showGroupedList",type="starling.events.Event")]
[Event(name="showItemRenderer",type="starling.events.Event")]
[Event(name="showList",type="starling.events.Event")]
[Event(name="showNumericStepper",type="starling.events.Event")]
[Event(name="showPageIndicator",type="starling.events.Event")]
[Event(name="showPickerList",type="starling.events.Event")]
[Event(name="showProgressBar",type="starling.events.Event")]
[Event(name="showScrollText",type="starling.events.Event")]
[Event(name="showSlider",type="starling.events.Event")]
[Event(name="showSpinnerList",type="starling.events.Event")]
[Event(name="showTabBar",type="starling.events.Event")]
[Event(name="showTextInput",type="starling.events.Event")]
[Event(name="showToggles",type="starling.events.Event")]

class MainMenuScreen extends PanelScreen
{
	inline public static var SHOW_ALERT:String = "showAlert";
	inline public static var SHOW_AUTO_COMPLETE:String = "showAutoComplete";
	inline public static var SHOW_BUTTON:String = "showButton";
	inline public static var SHOW_BUTTON_GROUP:String = "showButtonGroup";
	inline public static var SHOW_CALLOUT:String = "showCallout";
	inline public static var SHOW_GROUPED_LIST:String = "showGroupedList";
	inline public static var SHOW_ITEM_RENDERER:String = "showItemRenderer";
	inline public static var SHOW_LABEL:String = "showLabel";
	inline public static var SHOW_LIST:String = "showList";
	inline public static var SHOW_NUMERIC_STEPPER:String = "showNumericStepper";
	inline public static var SHOW_PAGE_INDICATOR:String = "showPageIndicator";
	inline public static var SHOW_PICKER_LIST:String = "showPickerList";
	inline public static var SHOW_PROGRESS_BAR:String = "showProgressBar";
	inline public static var SHOW_SCROLL_TEXT:String = "showScrollText";
	inline public static var SHOW_SLIDER:String = "showSlider";
	inline public static var SHOW_SPINNER_LIST:String = "showSpinnerList";
	inline public static var SHOW_TAB_BAR:String = "showTabBar";
	inline public static var SHOW_TEXT_INPUT:String = "showTextInput";
	inline public static var SHOW_TOGGLES:String = "showToggles";
	inline public static var SHOW_WEB_VIEW:String = "showWebView";
	
	public function new()
	{
		super();
	}

	private var _list:List;

	public var savedVerticalScrollPosition:Float = 0;
	public var savedSelectedIndex:Int = -1;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "Feathers";

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.dataProvider = new ListCollection(
		[
			{ label: "Alert", event: SHOW_ALERT },
			{ label: "Auto-complete", event: SHOW_AUTO_COMPLETE },
			{ label: "Button", event: SHOW_BUTTON },
			{ label: "Button Group", event: SHOW_BUTTON_GROUP },
			{ label: "Callout", event: SHOW_CALLOUT },
			{ label: "Grouped List", event: SHOW_GROUPED_LIST },
			{ label: "Item Renderer", event: SHOW_ITEM_RENDERER },
			{ label: "Label", event: SHOW_LABEL },
			{ label: "List", event: SHOW_LIST },
			{ label: "Numeric Stepper", event: SHOW_NUMERIC_STEPPER },
			{ label: "Page Indicator", event: SHOW_PAGE_INDICATOR },
			{ label: "Picker List", event: SHOW_PICKER_LIST },
			{ label: "Progress Bar", event: SHOW_PROGRESS_BAR },
			{ label: "Scroll Text", event: SHOW_SCROLL_TEXT },
			{ label: "Slider", event: SHOW_SLIDER},
			{ label: "Spinner List", event: SHOW_SPINNER_LIST },
			{ label: "Tab Bar", event: SHOW_TAB_BAR },
			{ label: "Text Input", event: SHOW_TEXT_INPUT },
			{ label: "Toggles", event: SHOW_TOGGLES },
		]);
		if(Capabilities.playerType == "Desktop") //this means AIR, even for mobile
		{
			this._list.dataProvider.addItem( { label: "Web View", event: SHOW_WEB_VIEW } );
		}
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.clipContent = false;
		this._list.autoHideBackground = true;
		this._list.verticalScrollPosition = this.savedVerticalScrollPosition;

		var isTablet:Bool = DeviceCapabilities.isTablet(Starling.current.nativeStage);
		var itemRendererAccessorySourceFunction:Function = null;
		if(!isTablet)
		{
			itemRendererAccessorySourceFunction = this.accessorySourceFunction;
		}
		this._list.itemRendererFactory = function():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

			//enable the quick hit area to optimize hit tests when an item
			//is only selectable and doesn't have interactive children.
			renderer.isQuickHitAreaEnabled = true;

			renderer.labelField = "label";
			renderer.accessorySourceFunction = itemRendererAccessorySourceFunction;
			return renderer;
		};

		if(isTablet)
		{
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this._list.selectedIndex = 0;
			this._list.revealScrollBars();
		}
		else
		{
			this._list.selectedIndex = this.savedSelectedIndex;
			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}
		this.addChild(this._list);
	}

	private function accessorySourceFunction(item:Dynamic):Texture
	{
		return StandardIcons.listDrillDownAccessoryTexture;
	}
	
	private function transitionInCompleteHandler(event:Event):Void
	{
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this._list.selectedIndex = -1;
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
		}
		this._list.revealScrollBars();
	}
	
	private function list_changeHandler(event:Event):Void
	{
		var eventType:String = this._list.selectedItem.event as String;
		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this.dispatchEventWith(eventType);
			return;
		}

		//save the list's scroll position and selected index so that we
		//can restore some context when this screen when we return to it
		//again later.
		this.dispatchEventWith(eventType, false,
		{
			savedVerticalScrollPosition: this._list.verticalScrollPosition,
			savedSelectedIndex: this._list.selectedIndex
		});
	}
}