/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
/**
 * Calculated bounds for layout.
 */
class LayoutBoundsResult
{
	/**
	 * Constructor.
	 */
	public function new()
	{

	}

	/**
	 * The starting position of the view port's content on the x axis.
	 * Usually, this value is <code>0</code>, but it may be negative.
	 * negative.
	 */
	public var contentX:Float = 0;

	/**
	 * The starting position of the view port's content on the y axis.
	 * Usually, this value is <code>0</code>, but it may be negative.
	 */
	public var contentY:Float = 0;

	/**
	 * The visible width of the view port. The view port's content may be
	 * clipped.
	 */
	public var viewPortWidth:Float;

	/**
	 * The visible height of the view port. The view port's content may be
	 * clipped.
	 */
	public var viewPortHeight:Float;

	/**
	 * The width of the content. May be larger or smaller than the view
	 * port.
	 */
	public var contentWidth:Float;

	/**
	 * The height of the content. May be larger or smaller than the view
	 * port.
	 */
	public var contentHeight:Float;
}
