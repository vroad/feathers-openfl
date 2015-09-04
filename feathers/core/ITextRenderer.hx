/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import openfl.geom.Point;

/**
 * Interface that handles common capabilities of rendering text.
 *
 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
 */
interface ITextRenderer extends IFeathersControl extends ITextBaselineControl
{
	/**
	 * The text to render.
	 *
	 * <p>If using the <code>Label</code> component, this property should
	 * be set on the <code>Label</code>, and it will be passed down to the
	 * text renderer.</p>
	 */
	var text(get, set):String;
	//function get_text():String;

	/**
	 * @private
	 */
	//function set_text(value:String):Void;

	/**
	 * Determines if the text wraps to the next line when it reaches the
	 * width (or max width) of the component.
	 *
	 * <p>If using the <code>Label</code> component, this property should
	 * be set on the <code>Label</code>, and it will be passed down to the
	 * text renderer automatically.</p>
	 */
	var wordWrap(get, set):Bool;
	//function get_wordWrap():Bool;

	/**
	 * @private
	 */
	//function set_wordWrap(value:Bool):Void;

	/**
	 * Measures the text's bounds (without a full validation, if
	 * possible).
	 */
	function measureText(result:Point = null):Point;
}
