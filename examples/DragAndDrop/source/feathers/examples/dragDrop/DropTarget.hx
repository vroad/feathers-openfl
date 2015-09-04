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

	public function new(dragFormat:String)
	{
		super();
		this._dragFormat = dragFormat;
		this.addEventListener(DragDropEvent.DRAG_ENTER, dragEnterHandler);
		this.addEventListener(DragDropEvent.DRAG_EXIT, dragExitHandler);
		this.addEventListener(DragDropEvent.DRAG_DROP, dragDropHandler);
	}

	private var _dragFormat:String;
	private var _backgroundQuad:Quad;

	override private function initialize():Void
	{
		this._backgroundQuad = new Quad(1, 1, DEFAULT_COLOR);
		this.backgroundSkin = this._backgroundQuad;
	}

	private function dragEnterHandler(event:DragDropEvent, dragData:DragData):Void
	{
		if(!dragData.hasDataForFormat(this._dragFormat))
		{
			return;
		}
		DragDropManager.acceptDrag(this);
		this._backgroundQuad.color = HOVER_COLOR;
	}

	private function dragExitHandler(event:DragDropEvent, dragData:DragData):Void
	{
		this._backgroundQuad.color = DEFAULT_COLOR;
	}

	private function dragDropHandler(event:DragDropEvent, dragData:DragData):Void
	{
		var droppedObject:DisplayObject = cast(dragData.getDataForFormat(this._dragFormat), DisplayObject);
		droppedObject.x = Math.min(Math.max(event.localX - droppedObject.width / 2,
			0), this.actualWidth - droppedObject.width); //keep within the bounds of the target
		droppedObject.y = Math.min(Math.max(event.localY - droppedObject.height / 2,
			0), this.actualHeight - droppedObject.height); //keep within the bounds of the target
		this.addChild(droppedObject);

		this._backgroundQuad.color = DEFAULT_COLOR;
	}
}
