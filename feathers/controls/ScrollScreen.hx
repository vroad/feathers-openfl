/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.skins.IStyleProvider;
import feathers.utils.display.FeathersDisplayUtil.getDisplayObjectDepthFromStage;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

import starling.core.Starling;
import starling.events.Event;

/**
 * Dispatched when the transition animation begins as the screen is shown
 * by the screen navigator.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_IN_START
 */
#if 0
[Event(name="transitionInStart",type="starling.events.Event")]
#end

/**
 * Dispatched when the transition animation finishes as the screen is shown
 * by the screen navigator.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_IN_COMPLETE
 */
#if 0
[Event(name="transitionInComplete",type="starling.events.Event")]
#end

/**
 * Dispatched when the transition animation begins as a different screen is
 * shown by the screen navigator and this screen is hidden.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_OUT_START
 */
#if 0
[Event(name="transitionOutStart",type="starling.events.Event")]
#end

/**
 * Dispatched when the transition animation finishes as a different screen
 * is shown by the screen navigator and this screen is hidden.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_OUT_COMPLETE
 */
#if 0
[Event(name="transitionOutComplete",type="starling.events.Event")]
#end

/**
 * A screen for use with <code>ScreenNavigator</code>, based on
 * <code>ScrollContainer</code> in order to provide scrolling and layout.
 *
 * <p>This component is generally not instantiated directly. Instead it is
 * typically used as a super class for concrete implementations of screens.
 * With that in mind, no code example is included here.</p>
 *
 * <p>The following example provides a basic framework for a new scroll screen:</p>
 *
 * <listing version="3.0">
 * package
 * {
 *     import feathers.controls.ScrollScreen;
 *     
 *     class CustomScreen extends ScrollScreen
 *     {
 *         public function new()
 *         {
 *             super();
 *         }
 *         
 *         override protected function initialize():void
 *         {
 *             //runs once when screen is first added to the stage
 *             //a good place to add children and customize the layout
 *             
 *             //don't forget to call this!
 *             super.initialize()
 *         }
 *     }
 * }</listing>
 *
 * @see ../../../help/scroll-screen.html How to use the Feathers ScrollScreen component
 * @see feathers.controls.StackScreenNavigator
 * @see feathers.controls.ScreenNavigator
 */
class ScrollScreen extends ScrollContainer implements IScreen
{
	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_AUTO:String = "auto";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_ON:String = "on";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_OFF:String = "off";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

	/**
	 * The vertical scroll bar will be positioned on the right.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

	/**
	 * The vertical scroll bar will be positioned on the left.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH:String = "touch";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_MOUSE:String = "mouse";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_NORMAL:Float = 0.998;

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_FAST:Float = 0.99;

	/**
	 * @copy feathers.controls.ScrollContainer#AUTO_SIZE_MODE_STAGE
	 *
	 * @see feathers.controls.ScrollContainer#autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_STAGE:String = "stage";

	/**
	 * @copy feathers.controls.ScrollContainer#AUTO_SIZE_MODE_CONTENT
	 *
	 * @see feathers.controls.ScrollContainer#autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_CONTENT:String = "content";

	/**
	 * The default <code>IStyleProvider</code> for all <code>ScrollScreen</code>
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
		this.addEventListener(Event.ADDED_TO_STAGE, scrollScreen_addedToStageHandler);
		super();
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ScrollScreen.globalStyleProvider;
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
	public function set_screenID(value:String):String
	{
		this._screenID = value;
		return get_screenID();
	}

	/**
	 * @private
	 */
	private var _owner:Dynamic;

	/**
	 * @inheritDoc
	 */
	public var owner(get, set):Dynamic;
	public function get_owner():Dynamic
	{
		return this._owner;
	}

	/**
	 * @private
	 */
	public function set_owner(value:Dynamic):Dynamic
	{
		this._owner = value;
		return get_owner();
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
	private function scrollScreen_addedToStageHandler(event:Event):Void
	{
		this.addEventListener(Event.REMOVED_FROM_STAGE, scrollScreen_removedFromStageHandler);
		//using priority here is a hack so that objects higher up in the
		//display list have a chance to cancel the event first.
		var priority:Int = -getDisplayObjectDepthFromStage(this);
		Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, scrollScreen_nativeStage_keyDownHandler, false, priority, true);
	}

	/**
	 * @private
	 */
	private function scrollScreen_removedFromStageHandler(event:Event):Void
	{
		this.removeEventListener(Event.REMOVED_FROM_STAGE, scrollScreen_removedFromStageHandler);
		Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, scrollScreen_nativeStage_keyDownHandler);
	}

	/**
	 * @private
	 */
	private function scrollScreen_nativeStage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.isDefaultPrevented())
		{
			//someone else already handled this one
			return;
		}
		#if flash
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
		#end
	}
}
