/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
/**
 * A component that can receive focus with children that can receive focus.
 *
 * @see feathers.core.IFocusManager
 */
interface IFocusContainer extends IFocusDisplayObject
{
	/**
	 * Determines if this component's children can receive focus. This
	 * property is completely independent from the <code>isFocusEnabled</code>
	 * property. In other words, it's possible to disable focus on this
	 * component while still allowing focus on its children (or the other
	 * way around).
	 *
	 * <p>In the following example, the focus is disabled:</p>
	 *
	 * <listing version="3.0">
	 * object.isFocusEnabled = false;</listing>
	 *
	 * @see #isFocusEnabled
	 */
	var isChildFocusEnabled(get, set):Bool;
	//function get_isChildFocusEnabled():Bool;

	/**
	 * @private
	 */
	//function set_isChildFocusEnabled(value:Bool):Bool;
}
