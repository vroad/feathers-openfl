package feathers.examples.layoutExplorer.screens;
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.events.FeathersEventType;
import feathers.examples.layoutExplorer.data.TiledColumnsLayoutSettings;
import feathers.layout.TiledColumnsLayout;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]
//[Event(name="showSettings",type="starling.events.Event")]

@:keep class TiledColumnsLayoutScreen extends PanelScreen
{
	inline public static var SHOW_SETTINGS:String = "showSettings";

	public function new()
	{
		super();
	}

	public var settings:TiledColumnsLayoutSettings;

	private var _backButton:Button;
	private var _settingsButton:Button;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		var layout:TiledColumnsLayout = new TiledColumnsLayout();
		layout.paging = this.settings.paging;
		layout.horizontalGap = this.settings.horizontalGap;
		layout.verticalGap = this.settings.verticalGap;
		layout.paddingTop = this.settings.paddingTop;
		layout.paddingRight = this.settings.paddingRight;
		layout.paddingBottom = this.settings.paddingBottom;
		layout.paddingLeft = this.settings.paddingLeft;
		layout.horizontalAlign = this.settings.horizontalAlign;
		layout.verticalAlign = this.settings.verticalAlign;
		layout.tileHorizontalAlign = this.settings.tileHorizontalAlign;
		layout.tileVerticalAlign = this.settings.tileVerticalAlign;

		this.layout = layout;
		this.snapToPages = this.settings.paging != TiledColumnsLayout.PAGING_NONE;
		this.snapScrollPositionsToPixels = true;

		var minQuadSize:Float = Math.min(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight) / 15;
		//for(var i:Int = 0; i < this.settings.itemCount; i++)
		for(i in 0 ... this.settings.itemCount)
		{
			var size:Float = minQuadSize + minQuadSize * 2 * Math.random();
			var quad:Quad = new Quad(size, size, 0xff8800);
			this.addChild(quad);
		}

		this.headerProperties.setProperty("title", "Tiled Columns Layout");

		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this._backButton = new Button();
			this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this.headerProperties.setProperty("leftItems", 
			[
				this._backButton
			]);

			this.backButtonHandler = this.onBackButton;
		}

		this._settingsButton = new Button();
		this._settingsButton.label = "Settings";
		this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

		this.headerProperties.setProperty("rightItems", 
		[
			this._settingsButton
		]);

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

	private function owner_transitionCompleteHandler(event:Event):Void
	{
		this.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);
		this.revealScrollBars();
	}
}
