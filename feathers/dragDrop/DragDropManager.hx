/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.dragDrop;
import feathers.core.PopUpManager;
import feathers.events.DragDropEvent;
import feathers.utils.type.SafeCast.safe_cast;
import openfl.errors.ArgumentError;

import openfl.errors.IllegalOperationError;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.ui.Keyboard;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Handles drag and drop operations based on Starling touch events.
 *
 * @see IDragSource
 * @see IDropTarget
 * @see DragData
 */
class DragDropManager
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	private static var _touchPointID:Int = -1;

	/**
	 * The ID of the touch that initiated the current drag. Returns <code>-1</code>
	 * if there is not an active drag action. In multi-touch applications,
	 * knowing the touch ID is useful if additional actions need to happen
	 * using the same touch.
	 */
	public static function get_touchPointID():Int
	{
		return _touchPointID;
	}

	/**
	 * @private
	 */
	private static var _dragSource:IDragSource;

	/**
	 * The <code>IDragSource</code> that started the current drag.
	 */
	public static function get_dragSource():IDragSource
	{
		return _dragSource;
	}

	/**
	 * @private
	 */
	private static var _dragData:DragData;

	/**
	 * Determines if the drag and drop manager is currently handling a drag.
	 * Only one drag may be active at a time.
	 */
	public static var isDragging(get, never):Bool;
	public static function get_isDragging():Bool
	{
		return _dragData != null;
	}

	/**
	 * The data associated with the current drag. Returns <code>null</code>
	 * if there is not a current drag.
	 */
	public static var dragData(get, never):DragData;
	public static function get_dragData():DragData
	{
		return _dragData;
	}

	/**
	 * @private
	 * The current target of the current drag.
	 */
	private static var dropTarget:IDropTarget;

	/**
	 * @private
	 * Indicates if the current drag has been accepted by the dropTarget.
	 */
	private static var isAccepted:Bool = false;

	/**
	 * @private
	 * The avatar for the current drag data.
	 */
	private static var avatar:DisplayObject;

	/**
	 * @private
	 */
	private static var avatarOffsetX:Float;

	/**
	 * @private
	 */
	private static var avatarOffsetY:Float;

	/**
	 * @private
	 */
	private static var dropTargetLocalX:Float;

	/**
	 * @private
	 */
	private static var dropTargetLocalY:Float;

	/**
	 * @private
	 */
	private static var avatarOldTouchable:Bool;

	/**
	 * Starts a new drag. If another drag is currently active, it is
	 * immediately cancelled. Includes an optional "avatar", a visual
	 * representation of the data that is being dragged.
	 */
	public static function startDrag(source:IDragSource, touch:Touch, data:DragData, dragAvatar:DisplayObject = null, dragAvatarOffsetX:Float = 0, dragAvatarOffsetY:Float = 0):Void
	{
		if(isDragging)
		{
			cancelDrag();
		}
		if(source == null)
		{
			throw new ArgumentError("Drag source cannot be null.");
		}
		if(data == null)
		{
			throw new ArgumentError("Drag data cannot be null.");
		}
		_dragSource = source;
		_dragData = data;
		_touchPointID = touch.id;
		avatar = dragAvatar;
		avatarOffsetX = dragAvatarOffsetX;
		avatarOffsetY = dragAvatarOffsetY;
		touch.getLocation(Starling.current.stage, HELPER_POINT);
		if(avatar != null)
		{
			avatarOldTouchable = avatar.touchable;
			avatar.touchable = false;
			avatar.x = HELPER_POINT.x + avatarOffsetX;
			avatar.y = HELPER_POINT.y + avatarOffsetY;
			PopUpManager.addPopUp(avatar, false, false);
		}
		Starling.current.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
		Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, 0, true);
		_dragSource.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_START, data, false));

		updateDropTarget(HELPER_POINT);
	}

	/**
	 * Tells the drag and drop manager if the target will accept the current
	 * drop. Meant to be called in a listener for the target's
	 * <code>DragDropEvent.DRAG_ENTER</code> event.
	 */
	public static function acceptDrag(target:IDropTarget):Void
	{
		if(dropTarget != target)
		{
			throw new ArgumentError("Drop target cannot accept a drag at this time. Acceptance may only happen after the DragDropEvent.DRAG_ENTER event is dispatched and before the DragDropEvent.DRAG_EXIT event is dispatched.");
		}
		isAccepted = true;
	}

	/**
	 * Immediately cancels the current drag.
	 */
	public static function cancelDrag():Void
	{
		if(!isDragging)
		{
			return;
		}
		completeDrag(false);
	}

	/**
	 * @private
	 */
	private static function completeDrag(isDropped:Bool):Void
	{
		if(!isDragging)
		{
			throw new IllegalOperationError("Drag cannot be completed because none is currently active.");
		}
		if(dropTarget != null)
		{
			dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_EXIT, _dragData, false, dropTargetLocalX, dropTargetLocalY));
			dropTarget = null;
		}
		var source:IDragSource = _dragSource;
		var data:DragData = _dragData;
		cleanup();
		source.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_COMPLETE, data, isDropped));
	}

	/**
	 * @private
	 */
	private static function cleanup():Void
	{
		if(avatar != null)
		{
			//may have been removed from parent already in the drop listener
			if(PopUpManager.isPopUp(avatar))
			{
				PopUpManager.removePopUp(avatar);
			}
			avatar.touchable = avatarOldTouchable;
			avatar = null;
		}
		Starling.current.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
		_dragSource = null;
		_dragData = null;
	}

	/**
	 * @private
	 */
	private static function updateDropTarget(location:Point):Void
	{
		var target:DisplayObject = Starling.current.stage.hitTest(location, true);
		while(target != null && !(Std.is(target, IDropTarget)))
		{
			target = target.parent;
		}
		if(target != null)
		{
			target.globalToLocal(location, location);
		}
		if(Std.is(target, DisplayObject))
		{
			if(dropTarget != null)
			{
				//notice that we can reuse the previously saved location
				dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_EXIT, _dragData, false, dropTargetLocalX, dropTargetLocalY));
			}
			dropTarget = safe_cast(target, IDropTarget);
			isAccepted = false;
			if(dropTarget != null)
			{
				dropTargetLocalX = location.x;
				dropTargetLocalY = location.y;
				dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_ENTER, _dragData, false, dropTargetLocalX, dropTargetLocalY));
			}
		}
		else if(dropTarget != null)
		{
			dropTargetLocalX = location.x;
			dropTargetLocalY = location.y;
			dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_MOVE, _dragData, false, dropTargetLocalX, dropTargetLocalY));
		}
	}

	/**
	 * @private
	 */
	private static function nativeStage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.keyCode == Keyboard.ESCAPE #if flash || event.keyCode == Keyboard.BACK #end)
		{
			#if flash
			event.preventDefault();
			#end
			cancelDrag();
		}
	}

	/**
	 * @private
	 */
	private static function stage_touchHandler(event:TouchEvent):Void
	{
		var stage:Stage = Starling.current.stage;
		var touch:Touch = event.getTouch(stage, null, _touchPointID);
		if(touch == null)
		{
			return;
		}
		if(touch.phase == TouchPhase.MOVED)
		{
			touch.getLocation(stage, HELPER_POINT);
			if(avatar != null)
			{
				avatar.x = HELPER_POINT.x + avatarOffsetX;
				avatar.y = HELPER_POINT.y + avatarOffsetY;
			}
			updateDropTarget(HELPER_POINT);
		}
		else if(touch.phase == TouchPhase.ENDED)
		{
			_touchPointID = -1;
			var isDropped:Bool = false;
			if(dropTarget != null && isAccepted)
			{
				dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_DROP, _dragData, true, dropTargetLocalX, dropTargetLocalY));
				isDropped = true;
			}
			dropTarget = null;
			completeDrag(isDropped);
		}
	}
}
