/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.IFeathersControl;

/**
 * A screen to display in a screen navigator.
 *
 * @see feathers.controls.StackScreenNavigator
 * @see feathers.controls.ScreenNavigator
 */
interface IScreen extends IFeathersControl
{
	/**
	 * The identifier for the screen. This value is passed in by the
	 * <code>ScreenNavigator</code> when the screen is instantiated.
	 */
	var screenID(get, set):String;
	//function get_screenID():String;

	/**
	 * @private
	 */
	//function set_screenID(value:String):Void;

	/**
	 * The screen navigator that is currently displaying this screen.
	 */
	var owner(get, set):Dynamic;
	//function get_owner():Dynamic;

	/**
	 * @private
	 */
	//function set_owner(value:Dynamic):Dynamic;
}
