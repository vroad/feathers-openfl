/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.skins.IStyleProvider;

import openfl.errors.IllegalOperationError;

//[Exclude(name="isToggle",kind="property")]

/**
 * A toggle control that contains a label and a box that may be checked
 * or not to indicate selection.
 *
 * <p>In the following example, a check is created and selected, and a
 * listener for <code>Event.CHANGE</code> is added:</p>
 *
 * <listing version="3.0">
 * var check:Check = new Check();
 * check.label = "Pick Me!";
 * check.isSelected = true;
 * check.addEventListener( Event.CHANGE, check_changeHandler );
 * this.addChild( check );</listing>
 *
 * @see ../../../help/check.html How to use the Feathers Check component
 * @see feathers.controls.ToggleSwitch
 */
class Check extends ToggleButton
{
	/**
	 * @copy feathers.controls.Button#STATE_UP
	 *
	 * @see #stateToSkinFunction
	 * @see #stateToIconFunction
	 * @see #stateToLabelPropertiesFunction
	 */
	inline public static var STATE_UP:String = "up";

	/**
	 * @copy feathers.controls.Button#STATE_DOWN
	 *
	 * @see #stateToSkinFunction
	 * @see #stateToIconFunction
	 * @see #stateToLabelPropertiesFunction
	 */
	inline public static var STATE_DOWN:String = "down";

	/**
	 * @copy feathers.controls.Button#STATE_HOVER
	 *
	 * @see #stateToSkinFunction
	 * @see #stateToIconFunction
	 * @see #stateToLabelPropertiesFunction
	 */
	inline public static var STATE_HOVER:String = "hover";

	/**
	 * @copy feathers.controls.Button#STATE_DISABLED
	 *
	 * @see #stateToSkinFunction
	 * @see #stateToIconFunction
	 * @see #stateToLabelPropertiesFunction
	 */
	inline public static var STATE_DISABLED:String = "disabled";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_TOP
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_TOP:String = "top";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_RIGHT
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_RIGHT:String = "right";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_BOTTOM
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_BOTTOM:String = "bottom";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_LEFT
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_MANUAL
	 *
	 * @see #iconPosition
	 * @see #iconOffsetX
	 * @see #iconOffsetY
	 */
	inline public static var ICON_POSITION_MANUAL:String = "manual";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_LEFT_BASELINE
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_RIGHT_BASELINE
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";

	/**
	 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_LEFT
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_CENTER
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_RIGHT
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * @copy feathers.controls.Button#VERTICAL_ALIGN_TOP
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * @copy feathers.controls.Button#VERTICAL_ALIGN_MIDDLE
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * @copy feathers.controls.Button#VERTICAL_ALIGN_BOTTOM
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";
	
	/**
	 * The default <code>IStyleProvider</code> for all <code>Check</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		super.isToggle = true;
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Check.globalStyleProvider;
	}

	/**
	 * @private
	 */
	override public function set_isToggle(value:Bool):Bool
	{
		throw new IllegalOperationError("CheckBox isToggle must always be true.");
	}
}
