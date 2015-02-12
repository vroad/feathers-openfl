/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import flash.utils.Dictionary;

/**
 * Maps a component's states to values, perhaps for one of the component's
 * properties such as a skin or text format.
 */
class StateValueSelector
{
	/**
	 * Constructor.
	 */
	public function StateValueSelector()
	{
	}

	/**
	 * @private
	 * Stores the values for each state.
	 */
	private var stateToValue:Dictionary = new Dictionary(true);

	/**
	 * If there is no value for the specified state, a default value can
	 * be used as a fallback.
	 */
	public var defaultValue:Dynamic;

	/**
	 * Stores a value for a specified state to be returned from
	 * getValueForState().
	 */
	public function setValueForState(value:Dynamic, state:Dynamic):Void
	{
		this.stateToValue[state] = value;
	}

	/**
	 * Clears the value stored for a specific state.
	 */
	public function clearValueForState(state:Dynamic):Dynamic
	{
		var value:Dynamic = this.stateToValue[state];
		delete this.stateToValue[state];
		return value;
	}

	/**
	 * Returns the value stored for a specific state.
	 */
	public function getValueForState(state:Dynamic):Dynamic
	{
		return this.stateToValue[state];
	}

	/**
	 * Returns the value stored for a specific state. May generate a value,
	 * if none is present.
	 *
	 * @param target		The object receiving the stored value. The manager may query properties on the target to customize the returned value.
	 * @param state			The current state.
	 * @param oldValue		The previous value. May be reused for the new value.
	 */
	public function updateValue(target:Dynamic, state:Dynamic, oldValue:Dynamic = null):Dynamic
	{
		var value:Dynamic = this.stateToValue[state];
		if(!value)
		{
			value = this.defaultValue;
		}
		return value;
	}
}
