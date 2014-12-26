/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
/**
 * Used by layout algorithms for determining the bounds in which to position
 * and size items.
 */
class ViewPortBounds
{
	/**
	 * Constructor.
	 */
	public function ViewPortBounds()
	{

	}

	/**
	 * The x position of the view port, in pixels.
	 */
	public var x:Float = 0;

	/**
	 * The y position of the view port, in pixels.
	 */
	public var y:Float = 0;

	/**
	 * The horizontal scroll position of the view port, in pixels.
	 */
	public var scrollX:Float = 0;

	/**
	 * The vertical scroll position of the view port, in pixels.
	 */
	public var scrollY:Float = 0;

	/**
	 * The explicit width of the view port, in pixels. If <code>NaN</code>,
	 * there is no explicit width value.
	 */
	public var explicitWidth:Float = NaN;

	/**
	 * The explicit height of the view port, in pixels. If <code>NaN</code>,
	 * there is no explicit height value.
	 */
	public var explicitHeight:Float = NaN;

	/**
	 * The minimum width of the view port, in pixels. Should be 0 or
	 * a positive number less than infinity.
	 */
	public var minWidth:Float = 0;

	/**
	 * The minimum width of the view port, in pixels. Should be 0 or
	 * a positive number less than infinity.
	 */
	public var minHeight:Float = 0;

	/**
	 * The maximum width of the view port, in pixels. Should be 0 or
	 * a positive number, including infinity.
	 */
	public var maxWidth:Float = Number.POSITIVE_INFINITY;

	/**
	 * The maximum height of the view port, in pixels. Should be 0 or
	 * a positive number, including infinity.
	 */
	public var maxHeight:Float = Number.POSITIVE_INFINITY;
}
