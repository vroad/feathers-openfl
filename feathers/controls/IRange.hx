/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.IFeathersControl;

/**
 * Dispatched when the value changes.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.CHANGE
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Minimum requirements for a scroll bar to be usable with a <code>Scroller</code>
 * component.
 *
 * @see Scroller
 */
interface IRange extends IFeathersControl
{
	/**
	 * The minimum numeric value of the range.
	 *
	 * <p>In the following example, the minimum is changed to 0:</p>
	 *
	 * <listing version="3.0">
	 * component.minimum = 0;
	 * component.maximum = 100;
	 * component.step = 1;
	 * component.page = 10
	 * component.value = 12;</listing>
	 */
	var minimum(get, set):Float;
	//function get_minimum():Float;

	/**
	 * @private
	 */
	//function set_minimum(value:Float):Void;

	/**
	 * The maximum numeric value of the range.
	 *
	 * <p>In the following example, the maximum is changed to 100:</p>
	 *
	 * <listing version="3.0">
	 * component.minimum = 0;
	 * component.maximum = 100;
	 * component.step = 1;
	 * component.page = 10
	 * component.value = 12;</listing>
	 */
	var maximum(get, set):Float;
	//function get_maximum():Float;

	/**
	 * @private
	 */
	//function set_maximum(value:Float):Void;

	/**
	 * The current numeric value.
	 *
	 * <p>In the following example, the value is changed to 12:</p>
	 *
	 * <listing version="3.0">
	 * component.minimum = 0;
	 * component.maximum = 100;
	 * component.step = 1;
	 * component.page = 10
	 * component.value = 12;</listing>
	 */
	var value(get, set):Float;
	//function get_value():Float;

	/**
	 * @private
	 */
	//function set_value(value:Float):Void;

	/**
	 * The amount the value must change to increment or decrement.
	 *
	 * <p>In the following example, the step is changed to 1:</p>
	 *
	 * <listing version="3.0">
	 * component.minimum = 0;
	 * component.maximum = 100;
	 * component.step = 1;
	 * component.page = 10
	 * component.value = 12;</listing>
	 */
	var step(get, set):Float;
	//function get_step():Float;

	/**
	 * @private
	 */
	//function set_step(value:Float):Void;
}
