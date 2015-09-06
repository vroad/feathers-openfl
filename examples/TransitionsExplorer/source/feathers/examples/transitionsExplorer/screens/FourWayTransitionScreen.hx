package feathers.examples.transitionsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import starling.display.DisplayObject;
import starling.events.Event;

class FourWayTransitionScreen extends PanelScreen
{
	inline public static var TRANSITION:String = "transition";

	public function new()
	{
		super();
	}

	private var _list:List;
	private var _backButton:Button;

	public var transitionName:String;
	public var upTransition:DisplayObject->DisplayObject->Dynamic->Void;
	public var downTransition:DisplayObject->DisplayObject->Dynamic->Void;
	public var leftTransition:DisplayObject->DisplayObject->Dynamic->Void;
	public var rightTransition:DisplayObject->DisplayObject->Dynamic->Void;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = this.transitionName;

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.dataProvider = new ListCollection(
		[
			{ label: "Left", transition: this.leftTransition },
			{ label: "Right", transition: this.rightTransition },
			{ label: "Up", transition: this.upTransition },
			{ label: "Down", transition: this.downTransition },
		]);
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.clipContent = false;
		this._list.autoHideBackground = true;

		this._list.itemRendererFactory = function():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

			//enable the quick hit area to optimize hit tests when an item
			//is only selectable and doesn't have interactive children.
			renderer.isQuickHitAreaEnabled = true;

			renderer.labelField = "label";
			return renderer;
		};

		this._list.addEventListener(Event.TRIGGERED, list_triggeredHandler);
		this._list.revealScrollBars();
		this.addChild(this._list);

		this.headerFactory = this.customHeaderFactory;
	}

	private function customHeaderFactory():Header
	{
		var header:Header = new Header();

		this._backButton = new Button();
		this._backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
		this._backButton.label = "Transitions";
		this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
		header.leftItems = [this._backButton];

		return header;
	}

	private function list_triggeredHandler(event:Event, item:Dynamic):Void
	{
		var transition:Dynamic = item.transition;
		this.dispatchEventWith(TRANSITION, false, transition);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}
}
