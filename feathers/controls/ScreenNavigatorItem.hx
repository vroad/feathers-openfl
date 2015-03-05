/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import openfl.errors.IllegalOperationError;

import starling.display.DisplayObject;

/**
 * Data for an individual screen that will be used by a <code>ScreenNavigator</code>
 * object.
 *
 * <p>The following example creates a new screen navigator item that
 * navigates to a "main menu" screen on <code>Event.COMPLETE</code> and
 * sets the <code>settings</code> property when the screen is displayed:</p>
 *
 * <listing version="3.0">
 * var item:ScreenNavigatorItem = new ScreenNavigatorItem( SettingsScreen,
 * {
 *     complete: MAIN_MENU_SCREEN_ID
 * },
 * {
 *     settings: settingsData
 * });
 * navigator.addScreen( SETTINGS_SCREEN_ID, item );</listing>
 *
 * @see http://wiki.starling-framework.org/feathers/screen-navigator
 * @see feathers.controls.ScreenNavigator
 */
class ScreenNavigatorItem
{
	/**
	 * Constructor.
	 */
	public function new(screen:Dynamic = null, events:Dynamic= null, properties:Dynamic = null)
	{
		this.screen = screen;
		this.events = events != null ? events : {};
		this.properties = properties != null ? properties : {};
	}
	
	/**
	 * A Starling DisplayObject, a Class that may be instantiated to create
	 * a DisplayObject, or a Function that returns a DisplayObject.
	 *
	 * @default null
	 */
	public var screen:Dynamic;
	
	/**
	 * A hash of events to which the ScreenNavigator will listen. Keys in
	 * the hash are event types (or the property name of an <code>ISignal</code>),
	 * and values are one of two possible types. If the value is a
	 * <code>String</code>, it must refer to a screen ID for the
	 * <code>ScreenNavigator</code> to display. If the value is a
	 * <code>Function</code>, it must be a listener for the screen's event
	 * or <code>ISignal</code>.
	 *
	 * @default null
	 */
	public var events:Dynamic;
	
	/**
	 * A hash of properties to set on the screen.
	 *
	 * @default null
	 */
	public var properties:Dynamic;
	
	/**
	 * Creates and instance of the screen type (or uses the screen directly
	 * if it isn't a class).
	 */
	private function getScreen():DisplayObject
	{
		var screenInstance:DisplayObject;
		if(Std.is(this.screen, Class))
		{
			var ScreenType:Class<Dynamic> = this.screen;
			screenInstance = Type.createInstance(ScreenType, []);
		}
		else if(Reflect.isFunction(this.screen))
		{
			screenInstance = this.screen();
		}
		else if(Std.is(this.screen, DisplayObject))
		{
			screenInstance = cast(this.screen, DisplayObject);
		}
		else
		{
			throw new IllegalOperationError("ScreenNavigatorItem \"screen\" must be a Class, a Function, or a Starling display object.");
		}
		
		if(this.properties != null)
		{
			for (property in Reflect.fields(this.properties))
			{
				Reflect.setProperty(screenInstance, property, Reflect.field(this.properties, property));
			}
		}
		
		return screenInstance;
	}
}