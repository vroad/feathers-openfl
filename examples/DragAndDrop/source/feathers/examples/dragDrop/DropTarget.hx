package feathers.examples.dragDrop;
import feathers.controls.LayoutGroup;
import feathers.dragDrop.DragData;
import feathers.dragDrop.DragDropManager;
import feathers.dragDrop.IDropTarget;
import feathers.events.DragDropEvent;

import starling.display.DisplayObject;
import starling.display.Quad;

class DropTarget extends LayoutGroup implements IDropTarget
{
	inline private static var DEFAULT_COLOR:UInt = 0x36322e;
	inline private static var HOVER_COLOR:UInt = 0x26221e;

	public function DropTarget(dragFormat:String)
	{
		this._dragFormat = dragFormat;
		this.addEventListener(DragDropEvent.DRAG_ENTER, dragEnterHandler);
		this.addEventListener(DragDropEvent.DRAG_EXIT, dragExitHandler);
		this.addEventListener(DragDropEvent.DRAG_DROP, dragDropHandler);
	}

	private var _background:Quad;
	private var _dragFormat:String;

	override private function initialize():Void
	{
		this._background = new Quad(1, 1, DEFAULT_COLOR);
		this.addChildAt(this._background, 0);
	}

	override private function draw():Void
	{
		super.draw();
		this._background.width = this.actualWidth;
		this._background.height = this.actualHeight;
	}

	private function dragEnterHandler(event:DragDropEvent, dragData:DragData):Void
	{
		if(!dragData.hasDataForFormat(this._dragFormat))
		{
			return;
		}
		DragDropManager.acceptDrag(this);
		this._background.color = HOVER_COLOR;
	}

	private function dragExitHandler(event:DragDropEvent, dragData:DragData):Void
	{
		this._background.color = DEFAULT_COLOR;
	}

	private function dragDropHandler(event:DragDropEvent, dragData:DragData):Void
	{
		var droppedObject:DisplayObject = DisplayObject(dragData.getDataForFormat(this._dragFormat))
		droppedObject.x = event.localX - droppedObject.width / 2;
		droppedObject.y = event.localY - droppedObject.height / 2;
		this.addChild(droppedObject);

		this._background.color = DEFAULT_COLOR;
	}
}
