/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
/**
 * A layout for the <code>SpinnerList</code> component.
 *
 * @see feathers.controls.SpinnerList
 */
interface ISpinnerLayout extends ILayout
{
	/**
	 * The interval, in pixels, between snapping points.
	 */
	var snapInterval(get, never):Float;
	function get_snapInterval():Float;
}
