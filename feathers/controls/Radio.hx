/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.IGroupedToggle;
import feathers.core.ToggleGroup;
import feathers.skins.IStyleProvider;

import openfl.errors.IllegalOperationError;

import starling.events.Event;

//[Exclude(name="isToggle",kind="property")]

/**
 * A toggleable control that exists in a set that requires a single,
 * exclusive toggled item.
 *
 * <p>In the following example, a set of radios are created, along with a
 * toggle group to group them together:</p>
 *
 * <listing version="3.0">
 * var group:ToggleGroup = new ToggleGroup();
 * group.addEventListener( Event.CHANGE, group_changeHandler );
 * 
 * var radio1:Radio = new Radio();
 * radio1.label = "One";
 * radio1.toggleGroup = group;
 * this.addChild( radio1 );
 * 
 * var radio2:Radio = new Radio();
 * radio2.label = "Two";
 * radio2.toggleGroup = group;
 * this.addChild( radio2 );
 * 
 * var radio3:Radio = new Radio();
 * radio3.label = "Three";
 * radio3.toggleGroup = group;
 * this.addChild( radio3 );</listing>
 *
 * @see ../../../help/radio.html How to use the Feathers Radio component
 * @see feathers.core.ToggleGroup
 */
class Radio extends ToggleButton implements IGroupedToggle
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
	 * If a <code>Radio</code> has not been added to a <code>ToggleGroup</code>,
	 * it will automatically be added to this group. If the Radio's
	 * <code>toggleGroup</code> property is set to a different group, it
	 * will be automatically removed from this group, if required.
	 */
	public static var defaultRadioGroup:ToggleGroup = new ToggleGroup();

	/**
	 * The default <code>IStyleProvider</code> for all <code>Radio</code>
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
		this.addEventListener(Event.ADDED_TO_STAGE, radio_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, radio_removedFromStageHandler);
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Radio.globalStyleProvider;
	}

	/**
	 * @private
	 */
	override public function set_isToggle(value:Bool):Bool
	{
		throw new IllegalOperationError("Radio isToggle must always be true.");
	}

	/**
	 * @private
	 */
	private var _toggleGroup:ToggleGroup;

	/**
	 * @inheritDoc
	 */
	public var toggleGroup(get, set):ToggleGroup;
	public function get_toggleGroup():ToggleGroup
	{
		return this._toggleGroup;
	}

	/**
	 * @private
	 */
	public function set_toggleGroup(value:ToggleGroup):ToggleGroup
	{
		if(this._toggleGroup == value)
		{
			return get_toggleGroup();
		}
		//a null toggle group will automatically add it to
		//defaultRadioGroup. however, if toggleGroup is already
		// defaultRadioGroup, then we really want to use null because
		//otherwise we'd remove the radio from defaultRadioGroup and then
		//immediately add it back because ToggleGroup sets the toggleGroup
		//property to null when removing an item.
		if(value == null && this._toggleGroup != defaultRadioGroup && this.stage != null)
		{
			value = defaultRadioGroup;
		}
		if(this._toggleGroup != null && this._toggleGroup.hasItem(this))
		{
			this._toggleGroup.removeItem(this);
		}
		this._toggleGroup = value;
		if(this._toggleGroup != null && !this._toggleGroup.hasItem(this))
		{
			this._toggleGroup.addItem(this);
		}
		return get_toggleGroup();
	}

	/**
	 * @private
	 */
	private function radio_addedToStageHandler(event:Event):Void
	{
		if(this._toggleGroup == null)
		{
			this.toggleGroup = defaultRadioGroup;
		}
	}

	/**
	 * @private
	 */
	private function radio_removedFromStageHandler(event:Event):Void
	{
		if(this._toggleGroup == defaultRadioGroup)
		{
			this._toggleGroup.removeItem(this);
		}
	}
}
