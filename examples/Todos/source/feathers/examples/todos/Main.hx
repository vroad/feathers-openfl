package feathers.examples.todos;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.ScrollContainer;
import feathers.controls.TextInput;
import feathers.controls.ToggleButton;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.examples.todos.controls.TodoItemRenderer;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.themes.MetalWorksMobileTheme;

import starling.display.DisplayObject;
import starling.events.Event;

@:keep class Main extends PanelScreen
{
	public function new()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	private var _input:TextInput;
	private var _list:List;
	private var _editButton:ToggleButton;
	private var _toolbar:ScrollContainer;

	private function customHeaderFactory():Header
	{
		var header:Header = new Header();
		header.title = "TODOS";
		header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;

		if(this._input == null)
		{
			this._input = new TextInput();
			this._input.prompt = "What needs to be done?";

			//we can't get an enter key event without changing the returnKeyLabel
			//not using ReturnKeyLabel.GO here so that it will build for web
			this._input.textEditorProperties.setProperty("returnKeyLabel", "go");

			this._input.addEventListener(FeathersEventType.ENTER, input_enterHandler);
		}

		header.rightItems = 
		[
			this._input
		];

		return header;
	}

	private function customFooterFactory():ScrollContainer
	{
		if(this._toolbar == null)
		{
			this._toolbar = new ScrollContainer();
			this._toolbar.styleNameList.add(ScrollContainer.ALTERNATE_NAME_TOOLBAR);
		}
		else
		{
			this._toolbar.removeChildren();
		}

		if(this._editButton == null)
		{
			this._editButton = new ToggleButton();
			this._editButton.label = "Edit";
			this._editButton.addEventListener(Event.CHANGE, editButton_changeHandler);
		}
		this._toolbar.addChild(this._editButton);

		return this._toolbar;
	}

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		new MetalWorksMobileTheme(false);

		this.width = this.stage.stageWidth;
		this.height = this.stage.stageHeight;

		this.layout = new AnchorLayout();

		this.headerFactory = this.customHeaderFactory;
		this.footerFactory = this.customFooterFactory;

		this._list = new List();
		this._list.isSelectable = false;
		this._list.dataProvider = new ListCollection();
		this._list.itemRendererType = TodoItemRenderer;
		this._list.itemRendererProperties.setProperty("labelField", "description");
		var listLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
		listLayoutData.topAnchorDisplayObject = this._input;
		this._list.layoutData = listLayoutData;
		this.addChild(this._list);
	}

	private function addedToStageHandler():Void
	{
		this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
	}

	private function removedFromStageHandler():Void
	{
		this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
	}

	private function input_enterHandler():Void
	{
		if(this._input.text == null)
		{
			return;
		}

		this._list.dataProvider.addItem(new TodoItem(this._input.text));
		this._input.text = "";
	}

	private function editButton_changeHandler(event:Event):Void
	{
		var isEditing:Bool = this._editButton.isSelected;
		this._list.itemRendererProperties.setProperty("isEditable", isEditing);
		this._input.visible = !isEditing;
	}

	private function stage_resizeHandler():Void
	{
		this.width = this.stage.stageWidth;
		this.height = this.stage.stageHeight;
	}
}
