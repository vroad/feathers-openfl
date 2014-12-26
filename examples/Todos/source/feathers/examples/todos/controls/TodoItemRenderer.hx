package feathers.examples.todos.controls;
import feathers.controls.Button;
import feathers.controls.Check;
import feathers.controls.List;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.examples.todos.TodoItem;

import starling.events.Event;

class TodoItemRenderer extends DefaultListItemRenderer
{
	public function TodoItemRenderer()
	{
		super();
		this.itemHasIcon = false;
		this.itemHasAccessory = false;
	}

	private var check:Check;
	private var deleteButton:Button;

	private var _isEditable:Bool = false;

	public function get_isEditable():Bool
	{
		return this._isEditable;
	}

	public function set_isEditable(value:Bool):Void
	{
		if(this._isEditable == value)
		{
			return;
		}
		this._isEditable = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	override public function dispose():Void
	{
		if(this.check)
		{
			this.check.removeFromParent(true);
			this.check = null;
		}
		if(this.deleteButton)
		{
			this.deleteButton.removeFromParent(true);
			this.deleteButton = null;
		}
		super.dispose();
	}

	override private function commitData():Void
	{
		super.commitData();
		var item:TodoItem = this._data as TodoItem;
		if(!item)
		{
			return;
		}
		if(!this.check)
		{
			this.check = new Check();
			this.check.addEventListener(Event.CHANGE, check_changeHandler);
		}
		this.check.isSelected = item.isCompleted;
		this.check.isEnabled = !this._isEditable;
		this.replaceIcon(this.check);

		if(!this.deleteButton)
		{
			this.deleteButton = new Button();
			this.deleteButton.label = "Delete";
			this.deleteButton.addEventListener(Event.TRIGGERED, deleteButton_triggeredHandler);
		}
		if(this._isEditable)
		{
			this.replaceAccessory(this.deleteButton);
		}
		else
		{
			this.replaceAccessory(null)
		}
	}

	private function check_changeHandler(event:Event):Void
	{
		var item:TodoItem = this._data as TodoItem;
		if(!item)
		{
			return;
		}
		item.isCompleted = this.check.isSelected;
	}

	private function deleteButton_triggeredHandler(event:Event):Void
	{
		List(this._owner).dataProvider.removeItemAt(this._index);
	}
}
