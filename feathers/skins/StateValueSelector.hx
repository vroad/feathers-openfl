/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import haxe.ds.WeakMap;
import openfl.utils.Dictionary;

/**
 * Maps a component's states to values, perhaps for one of the component's
 * properties such as a skin or text format.
 */
class StateValueSelector<V>
{
	/**
	 * Constructor.
	 */
	public function new()
	{
	}

	/**
	 * @private
	 * Stores the values for each state.
	 */
	#if flash
	private var stateToValue:WeakMap<String, V> = new WeakMap();
	#else
	private var stateToValue:Map<String, V> = new Map();
	#end

	/**
	 * If there is no value for the specified state, a default value can
	 * be used as a fallback.
	 */
	public var defaultValue:V;

	/**
	 * Stores a value for a specified state to be returned from
	 * getValueForState().
	 */
	public function setValueForState(value:V, state:String):Void
	{
		this.stateToValue[state] = value;
	}

	/**
	 * Clears the value stored for a specific state.
	 */
	public function clearValueForState(state:String):V
	{
		var value:Dynamic = this.stateToValue[state];
		this.stateToValue.remove(state);
		return value;
	}

	/**
	 * Returns the value stored for a specific state.
	 */
	public function getValueForState(state:String):V
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
	public function updateValue(target:Dynamic, state:String, oldValue:V = null):V
	{
		var value:Dynamic = this.stateToValue[state];
		if(value == null)
		{
			value = this.defaultValue;
		}
		return value;
	}
}
