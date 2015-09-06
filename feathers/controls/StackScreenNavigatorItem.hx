/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.supportClasses.IScreenNavigatorItem;

import starling.display.DisplayObject;

import openfl.errors.ArgumentError;

/**
 * Data for an individual screen that will be displayed by a
 * <code>StackScreenNavigator</code> component.
 *
 * <p>The following example creates a new
 * <code>StackScreenNavigatorItem</code> using the
 * <code>SettingsScreen</code> class to instantiate the screen instance.
 * When the screen is shown, its <code>settings</code> property will be set.
 * When the screen instance dispatches the
 * <code>SettingsScreen.SHOW_ADVANCED_SETTINGS</code> event, the
 * <code>StackScreenNavigator</code> will push a screen with the ID
 * <code>"advancedSettings"</code> onto its stack. When the screen instance
 * dispatches <code>Event.COMPLETE</code>, the <code>StackScreenNavigator</code>
 * will pop the screen instance from its stack.</p>
 *
 * <listing version="3.0">
 * var settingsData:Object = { volume: 0.8, difficulty: "hard" };
 * var item:StackScreenNavigatorItem = new StackScreenNavigatorItem( SettingsScreen );
 * item.properties.settings = settingsData;
 * item.setScreenIDForPushEvent( SettingsScreen.SHOW_ADVANCED_SETTINGS, "advancedSettings" );
 * item.addPopEvent( Event.COMPLETE );
 * navigator.addScreen( "settings", item );</listing>
 *
 * @see ../../../help/stack-screen-navigator.html How to use the Feathers StackScreenNavigator component
 * @see feathers.controls.StackScreenNavigator
 */
class StackScreenNavigatorItem implements IScreenNavigatorItem
{
	/**
	 * Constructor.
	 *
	 * @param screen The screen to display. Must be a <code>Class</code>, <code>Function</code>, or Starling display object.
	 * @param pushEvents The screen navigator push a new screen when these events are dispatched.
	 * @param popEvent An event that pops the screen from the top of the stack.
	 * @param properties A set of key-value pairs to pass to the screen when it is shown.
	 */
	public function new(screen:Dynamic, pushEvents:Dynamic = null, popEvent:String = null, properties:Dynamic = null)
	{
		this._screen = screen;
		this._pushEvents = pushEvents ? pushEvents : {};
		if(popEvent != null)
		{
			this.addPopEvent(popEvent);
		}
		this._properties = properties ? properties : {};
	}

	/**
	 * @private
	 */
	private var _screen:Dynamic;

	/**
	 * The screen to be displayed by the <code>ScreenNavigator</code>. It
	 * may be one of several possible types:
	 *
	 * <ul>
	 *     <li>a <code>Class</code> that may be instantiated to create a <code>DisplayObject</code></li>
	 *     <li>a <code>Function</code> that returns a <code>DisplayObject</code></li>
	 *     <li>a Starling <code>DisplayObject</code> that is already instantiated</li>
	 * </ul>
	 *
	 * <p>If the screen is a <code>Class</code> or a <code>Function</code>,
	 * a new instance of the screen will be instantiated every time that it
	 * is shown by the <code>ScreenNavigator</code>. The screen's state
	 * will not be saved automatically. The screen's state may be saved in
	 * <code>properties</code>, if needed.</p>
	 *
	 * <p>If the screen is a <code>DisplayObject</code>, the same instance
	 * will be reused every time that it is shown by the
	 * <code>ScreenNavigator</code> When the screen is shown again, its
	 * state will remain the same as when it was previously hidden. However,
	 * the screen will also be kept in memory even when it isn't visible,
	 * limiting the resources that are available for other screens.</p>
	 *
	 * @default null
	 */
	public var screen(get, set):Dynamic;
	public function get_screen():Dynamic
	{
		return this._screen;
	}

	/**
	 * @private
	 */
	public function set_screen(value:Dynamic):Dynamic
	{
		this._screen = value;
		return get_screen();
	}

	/**
	 * @private
	 */
	private var _pushEvents:Dynamic;

	/**
	 * A set of key-value pairs representing actions that should be
	 * triggered when events are dispatched by the screen when it is shown.
	 * A pair's key is the event type to listen for (or the property name of
	 * an <code>ISignal</code> instance), and a pair's value is one of two
	 * possible types. When this event is dispatched, and a pair's value
	 * is a <code>String</code>, the <code>StackScreenNavigator</code> will
	 * show another screen with an ID equal to the string value. When this
	 * event is dispatched, and the pair's value is a <code>Function</code>,
	 * the function will be called as if it were a listener for the event.
	 *
	 * @see #setFunctionForPushEvent()
	 * @see #setScreenIDForPushEvent()
	 */
	public var pushEvents(get, set):Dynamic;
	public function get_pushEvents():Dynamic
	{
		return this._pushEvents;
	}

	/**
	 * @private
	 */
	public function set_pushEvents(value:Dynamic):Dynamic
	{
		if(value == null)
		{
			value = {};
		}
		this._pushEvents = value;
		return get_pushEvents();
	}

	/**
	 * @private
	 */
	private var _popEvents:Array<String>;

	/**
	 * A list of events that will cause the screen navigator to pop this
	 * screen off the top of the stack.
	 *
	 * @see #addPopEvent()
	 * @see #removePopEvent()
	 */
	public var popEvents(get, set):Array<String>;
	public function get_popEvents():Array<String>
	{
		return this._popEvents;
	}

	/**
	 * @private
	 */
	public function set_popEvents(value:Array<String>):Array<String>
	{
		if(value == null)
		{
			value = new Array<String>();
		}
		this._popEvents = value;
		return get_popEvents();
	}

	/**
	 * @private
	 */
	private var _popToRootEvents:Array<String>;

	/**
	 * A list of events that will cause the screen navigator to clear its
	 * stack and show the first screen added to the stack.
	 *
	 * @see #addPopToRootEvent()
	 * @see #removePopToRootEvent()
	 */
	public var popToRootEvents(get, set):Array<String>;
	public function get_popToRootEvents():Array<String>
	{
		return this._popToRootEvents;
	}

	/**
	 * @private
	 */
	public function set_popToRootEvents(value:Array<String>):Array<String>
	{
		this._popToRootEvents = value;
		return get_popToRootEvents();
	}

	/**
	 * @private
	 */
	private var _properties:Dynamic;

	/**
	 * A set of key-value pairs representing properties to be set on the
	 * screen when it is shown. A pair's key is the name of the screen's
	 * property, and a pair's value is the value to be passed to the
	 * screen's property.
	 */
	public var properties(get, set):Dynamic;
	public function get_properties():Dynamic
	{
		return this._properties;
	}

	/**
	 * @private
	 */
	public function set_properties(value:Dynamic):Dynamic
	{
		if(value == null)
		{
			value = {};
		}
		this._properties = value;
		return get_properties();
	}

	/**
	 * @private
	 */
	private var _pushTransition:DisplayObject->DisplayObject->Dynamic->Void;

	/**
	 * A custom push transition for this screen only. If <code>null</code>,
	 * the default <code>pushTransition</code> defined by the
	 * <code>StackScreenNavigator</code> will be used.
	 *
	 * <p>In the following example, the screen navigator item is given a
	 * push transition:</p>
	 *
	 * <listing version="3.0">
	 * item.pushTransition = Slide.createSlideLeftTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>A custom transition function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. This callback indicate to the
	 * screen navigator that the transition has finished. This function has
	 * the following signature:</p>
	 *
	 * <pre>function(cancelTransition:Boolean = false):void</pre>
	 *
	 * <p>The first argument defaults to <code>false</code>, meaning that
	 * the transition completed successfully. In most cases, this callback
	 * may be called without arguments. If a transition is cancelled before
	 * completion (perhaps through some kind of user interaction), and the
	 * previous screen should be restored, pass <code>true</code> as the
	 * first argument to the callback to inform the screen navigator that
	 * the transition is cancelled.</p>
	 *
	 * @default null
	 *
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 */
	public var pushTransition(get, set):DisplayObject->DisplayObject->Dynamic->Void;
	public function get_pushTransition():DisplayObject->DisplayObject->Dynamic->Void
	{
		return this._pushTransition;
	}

	/**
	 * @private
	 */
	public function set_pushTransition(value:DisplayObject->DisplayObject->Dynamic->Void):DisplayObject->DisplayObject->Dynamic->Void
	{
		this._pushTransition = value;
		return get_pushTransition();
	}

	/**
	 * @private
	 */
	private var _popTransition:DisplayObject->DisplayObject->Dynamic->Void;

	/**
	 * A custom pop transition for this screen only. If <code>null</code>,
	 * the default <code>popTransition</code> defined by the
	 * <code>StackScreenNavigator</code> will be used.
	 *
	 * <p>In the following example, the screen navigator item is given a
	 * pop transition:</p>
	 *
	 * <listing version="3.0">
	 * item.popTransition = Slide.createSlideRightTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. This callback indicate to the
	 * screen navigator that the transition has finished. This function has
	 * the following signature:</p>
	 *
	 * <pre>function(cancelTransition:Boolean = false):void</pre>
	 *
	 * <p>The first argument defaults to <code>false</code>, meaning that
	 * the transition completed successfully. In most cases, this callback
	 * may be called without arguments. If a transition is cancelled before
	 * completion (perhaps through some kind of user interaction), and the
	 * previous screen should be restored, pass <code>true</code> as the
	 * first argument to the callback to inform the screen navigator that
	 * the transition is cancelled.</p>
	 *
	 * @default null
	 *
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 */
	public var popTransition(get, set):DisplayObject->DisplayObject->Dynamic->Void;
	public function get_popTransition():DisplayObject->DisplayObject->Dynamic->Void
	{
		return this._popTransition;
	}

	/**
	 * @private
	 */
	public function set_popTransition(value:DisplayObject->DisplayObject->Dynamic->Void):DisplayObject->DisplayObject->Dynamic->Void
	{
		this._popTransition = value;
		return get_popTransition();
	}

	/**
	 * @inheritDoc
	 */
	public var canDispose(get, never):Bool;
	public function get_canDispose():Bool
	{
		return !Std.is(this._screen, DisplayObject);
	}

	/**
	 * Specifies a function to call when an event is dispatched by the
	 * screen.
	 *
	 * <p>If the screen is currently being displayed by a
	 * <code>StackScreenNavigator</code>, and you call
	 * <code>setFunctionForPushEvent()</code> on the <code>StackScreenNavigatorItem</code>,
	 * the <code>StackScreenNavigator</code> won't listen for the event
	 * until the next time that the screen is shown.</p>
	 *
	 * @see #setScreenIDForPushEvent()
	 * @see #clearEvent()
	 * @see #events
	 */
	public function setFunctionForPushEvent(eventType:String, action:Dynamic):Void
	{
		Reflect.setField(this._pushEvents, eventType, action);
	}

	/**
	 * Specifies another screen to push on the stack when an event is
	 * dispatched by this screen. The other screen should be specified by
	 * its ID that was registered with a call to <code>addScreen()</code> on
	 * the <code>StackScreenNavigator</code>.
	 *
	 * <p>If the screen is currently being displayed by a
	 * <code>StackScreenNavigator</code>, and you call
	 * <code>setScreenIDForPushEvent()</code> on the <code>StackScreenNavigatorItem</code>,
	 * the <code>StackScreenNavigator</code> won't listen for the event
	 * until the next time that the screen is shown.</p>
	 *
	 * @see #setFunctionForPushEvent()
	 * @see #clearPushEvent()
	 * @see #pushEvents
	 */
	public function setScreenIDForPushEvent(eventType:String, screenID:String):Void
	{
		Reflect.setField(this._pushEvents, eventType, screenID);
	}

	/**
	 * Cancels the action previously registered to be triggered when the
	 * screen dispatches an event.
	 *
	 * @see #pushEvents
	 */
	public function clearPushEvent(eventType:String):Void
	{
		Reflect.deleteField(this._pushEvents, eventType);
	}

	/**
	 * Specifies an event dispatched by the screen that will cause the
	 * <code>StackScreenNavigator</code> to pop the screen off the top of
	 * the stack and return to the previous screen.
	 *
	 * <p>If the screen is currently being displayed by a
	 * <code>StackScreenNavigator</code>, and you call
	 * <code>addPopEvent()</code> on the <code>StackScreenNavigatorItem</code>,
	 * the <code>StackScreenNavigator</code> won't listen for the event
	 * until the next time that the screen is shown.</p>
	 *
	 * @see #removePopEvent()
	 * @see #popEvents
	 */
	public function addPopEvent(eventType:String):Void
	{
		if(this._popEvents == null)
		{
			this._popEvents = new Array<String>();
		}
		var index:Int = this._popEvents.indexOf(eventType);
		if(index >= 0)
		{
			return;
		}
		this._popEvents[this._popEvents.length] = eventType;
	}

	/**
	 * Removes an event that would cause the <code>StackScreenNavigator</code>
	 * to remove this screen from the top of the stack.
	 *
	 * <p>If the screen is currently being displayed by a
	 * <code>StackScreenNavigator</code>, and you call
	 * <code>removePopEvent()</code> on the <code>StackScreenNavigatorItem</code>,
	 * the <code>StackScreenNavigator</code> won't remove the listener for
	 * the event on the currently displayed screen. The event listener won't
	 * be added the next time that the screen is shown.</p>
	 *
	 * @see #addPopEvent()
	 * @see #popEvents
	 */
	public function removePopEvent(eventType:String):Void
	{
		if(this._popEvents == null)
		{
			return;
		}
		var index:Int = this._popEvents.indexOf(eventType);
		if(index >= 0)
		{
			return;
		}
		this._popEvents.splice(index, 1);
	}

	/**
	 * Specifies an event dispatched by the screen that will cause the
	 * <code>StackScreenNavigator</code> to pop the screen off the top of
	 * the stack and return to the previous screen.
	 *
	 * <p>If the screen is currently being displayed by a
	 * <code>StackScreenNavigator</code>, and you call
	 * <code>addPopToRootEvent()</code> on the <code>StackScreenNavigatorItem</code>,
	 * the <code>StackScreenNavigator</code> won't listen for the event
	 * until the next time that the screen is shown.</p>
	 *
	 * @see #removePopToRootEvent()
	 * @see #popToRootEvents
	 */
	public function addPopToRootEvent(eventType:String):Void
	{
		if(this._popToRootEvents == null)
		{
			this._popToRootEvents = new Array<String>();
		}
		var index:Int = this._popToRootEvents.indexOf(eventType);
		if(index >= 0)
		{
			return;
		}
		this._popToRootEvents[this._popToRootEvents.length] = eventType;
	}

	/**
	 * Removes an event that would have cause the <code>StackScreenNavigator</code>
	 * to clear its stack to show the first screen added to the stack.
	 *
	 * <p>If the screen is currently being displayed by a
	 * <code>StackScreenNavigator</code>, and you call
	 * <code>removePopEvent()</code> on the <code>StackScreenNavigatorItem</code>,
	 * the <code>StackScreenNavigator</code> won't remove the listener for
	 * the event on the currently displayed screen. The event listener won't
	 * be added the next time that the screen is shown.</p>
	 *
	 * @see #addPopToRootEvent()
	 * @see #popToRootEvents
	 */
	public function removePopToRootEvent(eventType:String):Void
	{
		if(this._popToRootEvents == null)
		{
			return;
		}
		var index:Int = this._popToRootEvents.indexOf(eventType);
		if(index >= 0)
		{
			return;
		}
		this._popToRootEvents.splice(index, 1);
	}

	/**
	 * @inheritDoc
	 */
	public function getScreen():DisplayObject
	{
		var screenInstance:DisplayObject;
		if(Std.is(this._screen, Class))
		{
			var ScreenType:Class<Dynamic> = cast this._screen;
			screenInstance = Type.createInstance(ScreenType, []);
		}
		else if(Reflect.isFunction(this._screen))
		{
			screenInstance = cast(this._screen(), DisplayObject);
		}
		else
		{
			screenInstance = cast(this._screen, DisplayObject);
		}
		if(!Std.is(screenInstance, DisplayObject))
		{
			throw new ArgumentError("ScreenNavigatorItem \"getScreen()\" must return a Starling display object.");
		}
		if(this._properties)
		{
			for(propertyName in Reflect.fields(this._properties))
			{
				Reflect.setProperty(screenInstance, propertyName, Reflect.field(this._properties, propertyName));
			}
		}

		return screenInstance;
	}
}
