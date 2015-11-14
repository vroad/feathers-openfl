/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import feathers.core.IToggle;
import feathers.utils.type.SafeCast.safe_cast;
import haxe.ds.WeakMap;

#if 0
import openfl.utils.Dictionary;
#end

/**
 * Maps a component's states to values, perhaps for one of the component's
 * properties such as a skin or text format.
 */
class StateWithToggleValueSelector<T>
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
	private var stateToValue:WeakMap<String, T> = new WeakMap();
#else
	private var stateToValue:Map<String, T> = new Map();
#end
	/**
	 * @private
	 * Stores the values for each state where isSelected is true.
	 */
#if flash
	private var stateToSelectedValue:WeakMap<String, T> = new WeakMap();
#else
	private var stateToSelectedValue:Map<String, T> = new Map();
#end
	/**
	 * If there is no value for the specified state, a default value can
	 * be used as a fallback.
	 */
	public var defaultValue:T;

	/**
	 * If the target is a selected IToggle instance, and if there is no
	 * value for the specified state, a default value may be used as a
	 * fallback (with a higher priority than the regular default fallback).
	 *
	 * @see feathers.core.IToggle
	 */
	public var defaultSelectedValue:T;

	/**
	 * Stores a value for a specified state to be returned from
	 * getValueForState().
	 */
	public function setValueForState(value:T, state:String, isSelected:Bool = false):Void
	{
		if(isSelected)
		{
			this.stateToSelectedValue.set(state, value);
		}
		else
		{
			this.stateToValue.set(state, value);
		}
	}

	/**
	 * Clears the value stored for a specific state.
	 */
	public function clearValueForState(state:String, isSelected:Bool = false):T
	{
		var value:T;
		if(isSelected)
		{
			value = this.stateToSelectedValue.get(state);
			this.stateToSelectedValue.remove(state);
		}
		else
		{
			value = this.stateToValue.get(state);
			this.stateToValue.remove(state);
		}
		return value;
	}

	/**
	 * Returns the value stored for a specific state.
	 */
	public function getValueForState(state:String, isSelected:Bool = false):T
	{
		if(isSelected)
		{
			return this.stateToSelectedValue.get(state);
		}
		return this.stateToValue.get(state);
	}

	/**
	 * Returns the value stored for a specific state. May generate a value,
	 * if none is present.
	 *
	 * @param target		The object receiving the stored value. The manager may query properties on the target to customize the returned value.
	 * @param state			The current state.
	 * @param oldValue		The previous value. May be reused for the new value.
	 */
	public function updateValue(target:Dynamic, state:String, oldValue:T = null):T
	{
		var value:T;
		var toggle:IToggle = safe_cast(target, IToggle);
		if(toggle != null && toggle.isSelected)
		{
			value = this.stateToSelectedValue.get(state);
			if(value == null)
			{
				value = this.defaultSelectedValue;
			}
		}
		else
		{
			value = this.stateToValue.get(state);
		}
		if(value == null)
		{
			value = this.defaultValue;
		}
		return value;
	}
}
