/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions;
import feathers.controls.IScreen;
import feathers.controls.ScreenNavigator;
import feathers.motion.Slide;
import openfl.errors.ArgumentError;

//import openfl.utils.getQualifiedClassName;

import starling.animation.Transitions;
import starling.display.DisplayObject;

/**
 * A transition for <code>ScreenNavigator</code> that slides out the old
 * screen and slides in the new screen at the same time. The slide starts
 * from the right or left, depending on if the manager determines that the
 * transition is a push or a pop.
 *
 * <p>Whether a screen change is supposed to be a push or a pop is
 * determined automatically. The manager generates an identifier from the
 * fully-qualified class name of the screen, and if present, the
 * <code>screenID</code> defined by <code>IScreen</code> instances. If the
 * generated identifier is present on the stack, a screen change is
 * considered a pop. If the token is not present, it's a push. Screen IDs
 * should be tailored to this behavior to avoid false positives.</p>
 *
 * <p>If your navigation structure requires explicit pushing and popping, a
 * custom transition manager is probably better.</p>
 *
 * @see feathers.controls.ScreenNavigator
 */
class ScreenSlidingStackTransitionManager
{
	/**
	 * Constructor.
	 */
	public function new(navigator:ScreenNavigator, quickStackScreenClass:Class<Dynamic> = null, quickStackScreenID:String = null)
	{
		if(navigator == null)
		{
			throw new ArgumentError("ScreenNavigator cannot be null.");
		}
		this.navigator = navigator;
		var quickStack:String = null;
		if(quickStackScreenClass != null)
		{
			quickStack = Type.getClassName(quickStackScreenClass);
		}
		if(quickStack != null && quickStackScreenID != null)
		{
			quickStack += "~" + quickStackScreenID;
		}
		if(quickStack != null)
		{
			this._stack.push(quickStack);
		}
		this.navigator.transition = this.onTransition;
	}

	/**
	 * The <code>ScreenNavigator</code> being managed.
	 */
	private var navigator:ScreenNavigator;

	/**
	 * @private
	 */
	private var _stack:Array<String> = new Array();

	/**
	 * @private
	 */
	private var _pushTransition:DisplayObject->DisplayObject->Dynamic->Void;

	/**
	 * @private
	 */
	private var _popTransition:DisplayObject->DisplayObject->Dynamic->Void;

	/**
	 * @private
	 */
	private var _duration:Float = 0.25;

	/**
	 * The duration of the transition, measured in seconds.
	 *
	 * @default 0.25
	 */
	public var duration(get, set):Float;
	public function get_duration():Float
	{
		return this._duration;
	}

	/**
	 * @private
	 */
	public function set_duration(value:Float):Float
	{
		if(this._duration == value)
		{
			return get_duration();
		}
		this._duration = value;
		this._pushTransition = null;
		this._popTransition = null;
		return get_duration();
	}

	/**
	 * @private
	 */
	private var _delay:Float = 0.1;

	/**
	 * A delay before the transition starts, measured in seconds. This may
	 * be required on low-end systems that will slow down for a short time
	 * after heavy texture uploads.
	 *
	 * @default 0.1
	 */
	public var delay(get, set):Float;
	public function get_delay():Float
	{
		return this._delay;
	}

	/**
	 * @private
	 */
	public function set_delay(value:Float):Float
	{
		if(this._delay == value)
		{
			return get_delay();
		}
		this._delay = value;
		this._pushTransition = null;
		this._popTransition = null;
		return get_delay();
	}

	/**
	 * @private
	 */
	private var _ease:String = Transitions.EASE_OUT;

	/**
	 * The easing function to use.
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 */
	public var ease(get, set):String;
	public function get_ease():String
	{
		return this._ease;
	}

	/**
	 * @private
	 */
	public function set_ease(value:String):String
	{
		if(this._ease == value)
		{
			return get_ease();
		}
		this._ease = value;
		this._pushTransition = null;
		this._popTransition = null;
		return get_ease();
	}

	/**
	 * Determines if the next transition should be skipped. After the
	 * transition, this value returns to <code>false</code>.
	 *
	 * @default false
	 */
	public var skipNextTransition:Bool = false;
	
	/**
	 * Removes all saved classes from the stack that are used to determine
	 * which side of the <code>ScreenNavigator</code> the new screen will
	 * slide in from.
	 */
	public function clearStack():Void
	{
		this._stack.splice(0, this._stack.length);
	}

	/**
	 * The function passed to the <code>transition</code> property of the
	 * <code>ScreenNavigator</code>.
	 */
	private function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
	{
		if(this.skipNextTransition)
		{
			this.skipNextTransition = false;
			if(newScreen != null)
			{
				newScreen.x = 0;
			}
			if(oldScreen != null)
			{
				oldScreen.x = 0;
			}
			if(onComplete != null)
			{
				onComplete();
			}
			return;
		}

		var newScreenClassAndID:String = Type.getClassName(Type.getClass(newScreen));
		if(Std.is(newScreen, IScreen))
		{
			newScreenClassAndID += "~" + cast(newScreen, IScreen).screenID;
		}
		var stackIndex:Int = this._stack.indexOf(newScreenClassAndID);
		if(stackIndex < 0) //push
		{
			var oldScreenClassAndID:String = Type.getClassName(Type.getClass(oldScreen));
			if(Std.is(oldScreen, IScreen))
			{
				oldScreenClassAndID += "~" + cast(oldScreen, IScreen).screenID;
			}
			this._stack.push(oldScreenClassAndID);

			if(this._pushTransition == null)
			{
				this._pushTransition = Slide.createSlideLeftTransition(this._duration, this._ease, {delay: this._delay});
			}
			this._pushTransition(oldScreen, newScreen, onComplete);
		}
		else //pop
		{
			this._stack.splice(stackIndex, this._stack.length - stackIndex);

			if(this._popTransition == null)
			{
				this._popTransition = Slide.createSlideRightTransition(this._duration, this._ease, {delay: this._delay});
			}
			this._popTransition(oldScreen, newScreen, onComplete);
		}
	}
}