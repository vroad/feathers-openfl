package feathers.examples.layoutExplorer.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.PanelScreen;
import feathers.controls.ScrollContainer;
import feathers.events.FeathersEventType;
import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
import feathers.layout.VerticalLayout;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]
//[Event(name="showSettings",type="starling.events.Event")]

@:keep class VerticalLayoutScreen extends PanelScreen
{
	inline public static var SHOW_SETTINGS:String = "showSettings";

	public function new()
	{
		super();
	}

	public var settings:VerticalLayoutSettings;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "Vertical Layout";

		var layout:VerticalLayout = new VerticalLayout();
		layout.gap = this.settings.gap;
		layout.paddingTop = this.settings.paddingTop;
		layout.paddingRight = this.settings.paddingRight;
		layout.paddingBottom = this.settings.paddingBottom;
		layout.paddingLeft = this.settings.paddingLeft;
		layout.horizontalAlign = this.settings.horizontalAlign;
		layout.verticalAlign = this.settings.verticalAlign;

		this.layout = layout;
		//when the scroll policy is set to on, the "elastic" edges will be
		//active even when the max scroll position is zero
		this.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
		this.snapScrollPositionsToPixels = true;

		var minQuadSize:Float = Math.min(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight) / 15;
		//for(var i:Int = 0; i < this.settings.itemCount; i++)
		for(i in 0 ... this.settings.itemCount)
		{
			var size:Float = (minQuadSize + minQuadSize * 2 * Math.random());
			var quad:Quad = new Quad(size, size, 0xff8800);
			this.addChild(quad);
		}

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

	private function transitionInCompleteHandler(event:Event):void
	{
		this.revealScrollBars();
	}

	{
		this.onBackButton();
	}

	private function settingsButton_triggeredHandler(event:Event):Void
	{
		this.dispatchEventWith(SHOW_SETTINGS);
	}
}
