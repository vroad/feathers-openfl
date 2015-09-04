/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.events;
import feathers.dragDrop.DragData;

import starling.events.Event;

/**
 * Events used by the <code>DragDropManager</code>.
 *
 * @see feathers.dragDrop.DragDropManager
 */
class DragDropEvent extends Event
{
	/**
	 * Dispatched by the <code>IDragSource</code> when a drag starts.
	 *
	 * @see feathers.dragDrop.IDragSource
	 */
	inline public static var DRAG_START:String = "dragStart";

	/**
	 * Dispatched by the <code>IDragSource</code> when a drag completes.
	 * This is always dispatched, even when there wasn't a successful drop.
	 * See the <code>isDropped</code> property to determine if the drop
	 * was successful.
	 *
	 * @see feathers.dragDrop.IDragSource
	 */
	inline public static var DRAG_COMPLETE:String = "dragComplete";

	/**
	 * Dispatched by a <code>IDropTarget</code> when a drag enters its
	 * bounds.
	 *
	 * @see feathers.dragDrop.IDropTarget
	 */
	inline public static var DRAG_ENTER:String = "dragEnter";

	/**
	 * Dispatched by a <code>IDropTarget</code> when a drag moves to a new
	 * location within its bounds.
	 *
	 * @see feathers.dragDrop.IDropTarget
	 */
	inline public static var DRAG_MOVE:String = "dragMove";

	/**
	 * Dispatched by a <code>IDropTarget</code> when a drag exits its
	 * bounds.
	 *
	 * @see feathers.dragDrop.IDropTarget
	 */
	inline public static var DRAG_EXIT:String = "dragExit";

	/**
	 * Dispatched by a <code>IDropTarget</code> when a drop occurs.
	 *
	 * @see feathers.dragDrop.IDropTarget
	 */
	inline public static var DRAG_DROP:String = "dragDrop";

	/**
	 * Constructor.
	 */
	public function new(type:String, dragData:DragData, isDropped:Bool, localX:Null<Float> = null, localY:Null<Float> = null)
	{
		if (localX == null) localX = Math.NaN;
		if (localY == null) localY = Math.NaN;
		super(type, false, dragData);
		this.isDropped = isDropped;
		this.localX = localX;
		this.localY = localY;
	}

	/**
	 * The <code>DragData</code> associated with the current drag.
	 */
	public var dragData(get, never):DragData;
	public function get_dragData():DragData
	{
		return cast(this.data, DragData);
	}

	/**
	 * Determines if there has been a drop.
	 */
	public var isDropped:Bool;

	/**
	 * The x location, in pixels, of the current action, in the local
	 * coordinate system of the <code>IDropTarget</code>.
	 *
	 * @see feathers.dragDrop.IDropTarget
	 */
	public var localX:Float;

	/**
	 * The y location, in pixels, of the current action, in the local
	 * coordinate system of the <code>IDropTarget</code>.
	 *
	 * @see feathers.dragDrop.IDropTarget
	 */
	public var localY:Float;
}
