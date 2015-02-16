/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.skins.IStyleProvider;
import feathers.utils.display.getDisplayObjectDepthFromStage;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

import starling.core.Starling;
import starling.events.Event;

/**
 * A basic screen to be displayed by <code>ScreenNavigator</code>. Provides
 * layout capabilities, but no scrolling.
 *
 * <p>The following example provides a basic framework for a new screen:</p>
 *
 * <listing version="3.0">
 * package
 * {
 *     import feathers.controls.Screen;
 *
 *     class CustomScreen extends Screen
 *     {
 *         public function CustomScreen()
 *         {
 *         }
 *
 *         override private function initialize():Void
 *         {
 *             //runs once when screen is first added to the stage.
 *             //a good place to add children and set a layout.
 *         }
 *
 *         override private function draw():Void
 *         {
 *             //override only if you want to do manual measurement and layout.
 *         }
 *     }
 * }</listing>
 *
 * @see http://wiki.starling-framework.org/feathers/screen
 * @see ScreenNavigator
 */
class Screen extends LayoutGroup implements IScreen
{
	/**
	 * The default <code>IStyleProvider</code> for all <code>Screen</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * Constructor.
	 */
	public function Screen()
	{
		this.addEventListener(Event.ADDED_TO_STAGE, screen_addedToStageHandler);
		super();
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Screen.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _screenID:String;

	/**
	 * @inheritDoc
	 */
	public var screenID(get, set):String;
	public function get_screenID():String
	{
		return this._screenID;
	}

	/**
	 * @private
	 */
	public function set_screenID(value:String):Void
	{
		this._screenID = value;
	}

	/**
	 * @private
	 */
	private var _owner:ScreenNavigator;

	/**
	 * @inheritDoc
	 */
	public var owner(get, set):ScreenNavigator;
	public function get_owner():ScreenNavigator
	{
		return this._owner;
	}

	/**
	 * @private
	 */
	public function set_owner(value:ScreenNavigator):Void
	{
		this._owner = value;
	}
	
	/**
	 * Optional callback for the back hardware key. Automatically handles
	 * keyboard events to cancel the default behavior.
	 *
	 * <p>This function has the following signature:</p>
	 *
	 * <pre>function():Void</pre>
	 *
	 * <p>In the following example, a function will dispatch <code>Event.COMPLETE</code>
	 * when the back button is pressed:</p>
	 *
	 * <listing version="3.0">
	 * this.backButtonHandler = onBackButton;
	 *
	 * private function onBackButton():Void
	 * {
	 *     this.dispatchEvent( Event.COMPLETE );
	 * };</listing>
	 *
	 * @default null
	 */
	private var backButtonHandler:Dynamic;
	
	/**
	 * Optional callback for the menu hardware key. Automatically handles
	 * keyboard events to cancel the default behavior.
	 *
	 * <p>This function has the following signature:</p>
	 *
	 * <pre>function():Void</pre>
	 *
	 * <p>In the following example, a function will be called when the menu
	 * button is pressed:</p>
	 *
	 * <listing version="3.0">
	 * this.menuButtonHandler = onMenuButton;
	 *
	 * private function onMenuButton():Void
	 * {
	 *     //do something with the menu button
	 * };</listing>
	 *
	 * @default null
	 */
	private var menuButtonHandler:Dynamic;
	
	/**
	 * Optional callback for the search hardware key. Automatically handles
	 * keyboard events to cancel the default behavior.
	 *
	 * <p>This function has the following signature:</p>
	 *
	 * <pre>function():Void</pre>
	 *
	 * <p>In the following example, a function will be called when the search
	 * button is pressed:</p>
	 *
	 * <listing version="3.0">
	 * this.searchButtonHandler = onSearchButton;
	 *
	 * private function onSearchButton():Void
	 * {
	 *     //do something with the search button
	 * };</listing>
	 *
	 * @default null
	 */
	private var searchButtonHandler:Dynamic;
	
	/**
	 * @private
	 */
	private function screen_addedToStageHandler(event:Event):Void
	{
		if(event.target != this)
		{
			return;
		}
		this.addEventListener(Event.REMOVED_FROM_STAGE, screen_removedFromStageHandler);
		//using priority here is a hack so that objects higher up in the
		//display list have a chance to cancel the event first.
		var priority:Int = -getDisplayObjectDepthFromStage(this);
		Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, screen_nativeStage_keyDownHandler, false, priority, true);
	}

	/**
	 * @private
	 */
	private function screen_removedFromStageHandler(event:Event):Void
	{
		if(event.target != this)
		{
			return;
		}
		this.removeEventListener(Event.REMOVED_FROM_STAGE, screen_removedFromStageHandler);
		Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, screen_nativeStage_keyDownHandler);
	}
	
	/**
	 * @private
	 */
	private function screen_nativeStage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.isDefaultPrevented())
		{
			//someone else already handled this one
			return;
		}
		if(this.backButtonHandler != null &&
			event.keyCode == Keyboard.BACK)
		{
			event.preventDefault();
			this.backButtonHandler();
		}
		
		if(this.menuButtonHandler != null &&
			event.keyCode == Keyboard.MENU)
		{
			event.preventDefault();
			this.menuButtonHandler();
		}
		
		if(this.searchButtonHandler != null &&
			event.keyCode == Keyboard.SEARCH)
		{
			event.preventDefault();
			this.searchButtonHandler();
		}
	}
}