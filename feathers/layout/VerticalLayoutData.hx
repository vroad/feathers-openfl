/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

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
 * Extra, optional data used by an <code>VerticalLayout</code> instance to
 * position and size a display object.
 *
 * @see VerticalLayout
 * @see ILayoutDisplayObject
 */
class VerticalLayoutData extends EventDispatcher implements ILayoutData
{
	/**
	 * Constructor.
	 */
	public function new(percentWidth:Null<Float> = null, percentHeight:Null<Float> = null)
	{
		super();
		this._percentWidth = percentWidth != null ? percentWidth : Math.NaN;
		this._percentHeight = percentHeight != null ? percentHeight : Math.NaN;
	}

	/**
	 * @private
	 */
	private var _percentWidth:Float;

	/**
	 * The width of the layout object, as a percentage of the container's
	 * width.
	 *
	 * <p>If the value is <code>NaN</code>, this property is ignored.</p>
	 * 
	 * <p>Performance tip: If all items in your layout will have 100% width,
	 * it's better to set the <code>horizontalAlign</code> property of the
	 * <code>VerticalLayout</code> to
	 * <code>VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY</code>.</p>
	 *
	 * @default NaN
	 * 
	 * @see feathers.layout.VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY
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
			return this._percentWidth;
		}
		this._percentWidth = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._percentWidth;
	}

	/**
	 * @private
	 */
	private var _percentHeight:Float;

	/**
	 * The height of the layout object, as a percentage of the container's
	 * height. The container will calculate the sum of all of its children
	 * with explicit pixel heights, and then the remaining space will be
	 * distributed to children with percent heights.
	 *
	 * <p>The <code>percentHeight</code> property is ignored when its value
	 * is <code>NaN</code> or when the <code>useVirtualLayout</code>
	 * property of the <code>VerticalLayout</code> is set to
	 * <code>false</code>.</p>
	 *
	 * @default NaN
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
			return this._percentHeight;
		}
		this._percentHeight = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._percentHeight;
	}
}
