/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * @inheritDoc
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Extra, optional data used by an <code>HorizontalLayout</code> instance to
 * position and size a display object.
 *
 * @see http://wiki.starling-framework.org/feathers/horizontal-layout
 * @see HorizontalLayout
 * @see ILayoutDisplayObject
 */
class HorizontalLayoutData extends EventDispatcher implements ILayoutData
{
	/**
	 * Constructor.
	 */
	public function new(percentWidth:Float = Math.NaN, percentHeight:Float = Math.NaN)
	{
		this._percentWidth = percentWidth;
		this._percentHeight = percentHeight;
	}

	/**
	 * @private
	 */
	private var _percentWidth:Float;

	/**
	 * The width of the layout object, as a percentage of the container's
	 * width. The container will calculate the sum of all of its children
	 * with explicit pixel widths, and then the remaining space will be
	 * distributed to children with percent widths.
	 *
	 * <p>The <code>percentWidth</code> property is ignored when its value
	 * is <code>Math.NaN</code> or when the <code>useVirtualLayout</code>
	 * property of the <code>HorizontalLayout</code> is set to
	 * <code>false</code>.</p>
	 *
	 * @default Math.NaN
	 */
	public var percentWidth(get, set):Float;
	public function get_percentWidth():Float
	{
		return this._percentWidth;
	}

	/**
	 * @private
	 */
	public function set_percentWidth(value:Float):Float
	{
		if(this._percentWidth == value)
		{
			return;
		}
		this._percentWidth = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _percentHeight:Float;


	/**
	 * The height of the layout object, as a percentage of the container's
	 * height.
	 *
	 * <p>If the value is <code>Math.NaN</code>, this property is ignored.</p>
	 *
	 * @default Math.NaN
	 */
	public var percentHeight(get, set):Float;
	public function get_percentHeight():Float
	{
		return this._percentHeight;
	}

	/**
	 * @private
	 */
	public function set_percentHeight(value:Float):Float
	{
		if(this._percentHeight == value)
		{
			return;
		}
		this._percentHeight = value;
		this.dispatchEventWith(Event.CHANGE);
	}
}
