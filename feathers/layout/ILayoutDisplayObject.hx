/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IFeathersDisplayObject;

/**
 * Dispatched when a property of the display object's layout data changes.
 *
 * @eventType feathers.events.FeathersEventType.LAYOUT_DATA_CHANGE
 */
///[Event(name="layoutDataChange",type="starling.events.Event")]

/**
 * A display object that may be associated with extra data for use with
 * advanced layouts.
 */
interface ILayoutDisplayObject extends IFeathersDisplayObject
{
	/**
	 * Extra parameters associated with this display object that will be
	 * used by the layout algorithm.
	 */
	var layoutData(get, set):ILayoutData;
	//function get_layoutData():ILayoutData;

	/**
	 * @private
	 */
	//function set_layoutData(value:ILayoutData):Void;

	/**
	 * Determines if the ILayout should use this object or ignore it.
	 *
	 * <p>In the following example, the display object is excluded from
	 * the layout:</p>
	 *
	 * <listing version="3.0">
	 * object.includeInLayout = false;</listing>
	 */
	var includeInLayout(get, set):Bool;
	//function get_includeInLayout():Bool;

	/**
	 * @private
	 */
	//function set_includeInLayout(value:Bool):Void;
}
