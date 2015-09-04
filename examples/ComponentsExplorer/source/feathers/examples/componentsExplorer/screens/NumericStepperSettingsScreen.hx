package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.NumericStepper;
import feathers.controls.PanelScreen;
import feathers.data.ListCollection;
import feathers.examples.componentsExplorer.data.NumericStepperSettings;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]

@:keep class NumericStepperSettingsScreen extends PanelScreen
{
	public function new()
	{
		super();
	}

	public var settings:NumericStepperSettings;

	private var _list:List;
	private var _stepStepper:NumericStepper;

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

		this.title = "Numeric Stepper Settings";

		this.layout = new AnchorLayout();

		this._stepStepper = new NumericStepper();
		this._stepStepper.minimum = 1;
		this._stepStepper.maximum = 20;
		this._stepStepper.step = 1;
		this._stepStepper.value = this.settings.step;
		this._stepStepper.addEventListener(Event.CHANGE, stepStepper_changeHandler);

		this._list = new List();
		this._list.isSelectable = false;
		this._list.dataProvider = new ListCollection(
		[
			{ label: "step", accessory: this._stepStepper },
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
		header.rightItems = new <DisplayObject>
		[
			doneButton
		]);
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

	private function stepStepper_changeHandler(event:Event):Void
	{
		this.settings.step = this._stepStepper.value;
	}

	private function doneButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}
}
