package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.NumericStepper;
import feathers.controls.PanelScreen;
import feathers.controls.ToggleSwitch;
import feathers.data.ListCollection;
import feathers.examples.componentsExplorer.data.SliderSettings;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]

@:keep class SliderSettingsScreen extends PanelScreen
{
	public function new()
	{
		super();
	}

	public var settings:SliderSettings;

	private var _list:List;
	private var _liveDraggingToggle:ToggleSwitch;
	private var _stepStepper:NumericStepper;
	private var _pageStepper:NumericStepper;

	override public function dispose():Void
	{
		//icon and accessory display objects in the list's data provider
		//won't be automatically disposed because feathers cannot know if
		//they need to be used again elsewhere or not. we need to dispose
		//them manually.
		this._list.dataProvider.dispose(disposeItemAccessory);

		//never forget to call super.dispose() because you don't want to
		//create a memory leak!
		super.dispose();
	}

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "Slider Settings";

		this.layout = new AnchorLayout();

		this._liveDraggingToggle = new ToggleSwitch();
		this._liveDraggingToggle.isSelected = this.settings.liveDragging;
		this._liveDraggingToggle.addEventListener(Event.CHANGE, liveDraggingToggle_changeHandler);

		this._stepStepper = new NumericStepper();
		this._stepStepper.minimum = 1;
		this._stepStepper.maximum = 20;
		this._stepStepper.step = 1;
		this._stepStepper.value = this.settings.step;
		this._stepStepper.addEventListener(Event.CHANGE, stepStepper_changeHandler);

		this._pageStepper = new NumericStepper();
		this._pageStepper.minimum = 1;
		this._pageStepper.maximum = 20;
		this._pageStepper.step = 1;
		this._pageStepper.value = this.settings.page;
		this._pageStepper.addEventListener(Event.CHANGE, pageStepper_changeHandler);

		this._list = new List();
		this._list.isSelectable = false;
		this._list.dataProvider = new ListCollection(
		[
			{ label: "liveDragging", accessory: this._liveDraggingToggle },
			{ label: "step", accessory: this._stepStepper },
			{ label: "page", accessory: this._pageStepper },
		]);
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.clipContent = false;
		this._list.autoHideBackground = true;
		this.addChild(this._list);

		this.headerFactory = this.customHeaderFactory;

		this.backButtonHandler = this.onBackButton;
	}

	private function customHeaderFactory():Header
	{
		var header:Header = new Header();
		var doneButton:Button = new Button();
		doneButton.label = "Done";
		doneButton.addEventListener(Event.TRIGGERED, doneButton_triggeredHandler);
		header.rightItems = 
		[
			doneButton
		];
		return header;
	}

	private function disposeItemAccessory(item:Dynamic):Void
	{
		cast(item.accessory, DisplayObject).dispose();
	}

	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function liveDraggingToggle_changeHandler(event:Event):Void
	{
		this.settings.liveDragging = this._liveDraggingToggle.isSelected;
	}

	private function stepStepper_changeHandler(event:Event):Void
	{
		this.settings.step = this._stepStepper.value;
	}

	private function pageStepper_changeHandler(event:Event):Void
	{
		this.settings.page = this._pageStepper.value;
	}

	private function doneButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}
}
