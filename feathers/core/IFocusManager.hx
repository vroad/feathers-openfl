/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import starling.display.DisplayObjectContainer;

/**
 * Interface for focus management.
 *
 * @see feathers.core.IFocusDisplayObject
 * @see feathers.core.FocusManager
 */
interface IFocusManager
{
	/**
	 * Determines if this focus manager is enabled. A focus manager may be
	 * disabled when another focus manager has control, such as when a
	 * modal pop-up is displayed.
	 */
	var isEnabled(get, set):Bool;
	//function get_isEnabled():Bool;

	/**
	 * @private
	 */
	//function set_isEnabled(value:Bool):Void;

	/**
	 * The object that currently has focus. May return <code>null</code> if
	 * no object has focus.
	 *
	 * <p>In the following example, the focus is changed:</p>
	 *
	 * <listing version="3.0">
	 * focusManager.focus = someObject;</listing>
	 */
	var focus(get, set):IFocusDisplayObject;
	//function get_focus():IFocusDisplayObject;

	/**
	 * @private
	 */
	//function set_focus(value:IFocusDisplayObject):Void;

	/**
	 * The top-level container of the focus manager. This isn't necessarily
	 * the root of the display list.
	 */
	var root(get, never):DisplayObjectContainer;
	function get_root():DisplayObjectContainer;
}
