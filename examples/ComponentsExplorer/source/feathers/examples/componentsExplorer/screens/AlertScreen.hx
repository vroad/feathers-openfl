package feathers.examples.componentsExplorer.screens;
import feathers.controls.Alert;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.PanelScreen;
import feathers.data.ListCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;

@:keep class AlertScreen extends PanelScreen
{
	public function new()
	{
		super();
	}

	private var _showAlertButton:Button;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "Alert";

		this.layout = new AnchorLayout();

		this._showAlertButton = new Button();
		this._showAlertButton.label = "Show Alert";
		this._showAlertButton.addEventListener(Event.TRIGGERED, showAlertButton_triggeredHandler);
		var buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
		buttonGroupLayoutData.horizontalCenter = 0;
		buttonGroupLayoutData.verticalCenter = 0;
		this._showAlertButton.layoutData = buttonGroupLayoutData;
		this.addChild(this._showAlertButton);

		this.headerFactory = this.customHeaderFactory;

		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this.backButtonHandler = this.onBackButton;
		}
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
		return header;
	}

	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}

	private function showAlertButton_triggeredHandler(event:Event):Void
	{
		var alert:Alert = Alert.show("I just wanted you to know that I have a very important message to share with you.", "Alert", new ListCollection(
		[
			{ label: "OK" },
			{ label: "Cancel" }
		]));
		alert.addEventListener(Event.CLOSE, alert_closeHandler);
	}

	private function alert_closeHandler(event:Event, data:Dynamic):Void
	{
		if(data != null)
		{
			trace("alert closed with button:" + data.label);
		}
		else
		{
			trace("alert closed without button");
		}
	}
}
