/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions;
import feathers.controls.IScreen;
import feathers.controls.ScreenNavigator;

import openfl.utils.getQualifiedClassName;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
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
	public function ScreenSlidingStackTransitionManager(navigator:ScreenNavigator, quickStackScreenClass:Class<Dynamic> = null, quickStackScreenID:String = null)
	{
		if(!navigator)
		{
			throw new ArgumentError("ScreenNavigator cannot be null.");
		}
		this.navigator = navigator;
		var quickStack:String;
		if(quickStackScreenClass)
		{
			quickStack = getQualifiedClassName(quickStackScreenClass);
		}
		if(quickStack && quickStackScreenID)
		{
			quickStack += "~" + quickStackScreenID;
		}
		if(quickStack)
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
	private var _activeTransition:Tween;

	/**
	 * @private
	 */
	private var _savedOtherTarget:DisplayObject;

	/**
	 * @private
	 */
	private var _savedCompleteHandler:Dynamic;
	
	/**
	 * The duration of the transition, in seconds.
	 *
	 * @default 0.25
	 */
	public var duration:Float = 0.25;

	/**
	 * A delay before the transition starts, measured in seconds. This may
	 * be required on low-end systems that will slow down for a short time
	 * after heavy texture uploads.
	 *
	 * @default 0.1
	 */
	public var delay:Float = 0.1;
	
	/**
	 * The easing function to use.
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 */
	public var ease:Dynamic = Transitions.EASE_OUT;

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
		this._stack.length = 0;
	}

	/**
	 * The function passed to the <code>transition</code> property of the
	 * <code>ScreenNavigator</code>.
	 */
	private function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
	{
		if(this._activeTransition)
		{
			this._savedOtherTarget = null;
			Starling.current.juggler.remove(this._activeTransition);
			this._activeTransition = null;
		}

		if(!oldScreen || !newScreen || this.skipNextTransition)
		{
			this.skipNextTransition = false;
			this._savedCompleteHandler = null;
			if(newScreen)
			{
				newScreen.x = 0;
			}
			if(oldScreen)
			{
				oldScreen.x = 0;
			}
			if(onComplete != null)
			{
				onComplete();
			}
			return;
		}
		
		this._savedCompleteHandler = onComplete;

		var newScreenClassAndID:String = getQualifiedClassName(newScreen);
		if(Std.is(newScreen, IScreen))
		{
			newScreenClassAndID += "~" + IScreen(newScreen).screenID;
		}
		var stackIndex:Int = this._stack.indexOf(newScreenClassAndID);
		var activeTransition_onUpdate:Dynamic;
		if(stackIndex < 0)
		{
			var oldScreenClassAndID:String = getQualifiedClassName(oldScreen);
			if(Std.is(oldScreen, IScreen))
			{
				oldScreenClassAndID += "~" + IScreen(oldScreen).screenID;
			}
			this._stack.push(oldScreenClassAndID);
			oldScreen.x = 0;
			newScreen.x = this.navigator.width;
			activeTransition_onUpdate = this.activeTransitionPush_onUpdate;
		}
		else
		{
			this._stack.length = stackIndex;
			oldScreen.x = 0;
			newScreen.x = -this.navigator.width;
			activeTransition_onUpdate = this.activeTransitionPop_onUpdate;
		}
		this._savedOtherTarget = oldScreen;
		this._activeTransition = new Tween(newScreen, this.duration, this.ease);
		this._activeTransition.animate("x", 0);
		this._activeTransition.delay = this.delay;
		this._activeTransition.onUpdate = activeTransition_onUpdate;
		this._activeTransition.onComplete = activeTransition_onComplete;
		Starling.current.juggler.add(this._activeTransition);
	}
	
	/**
	 * @private
	 */
	private function activeTransitionPush_onUpdate():Void
	{
		if(this._savedOtherTarget)
		{
			var newScreen:DisplayObject = DisplayObject(this._activeTransition.target);
			this._savedOtherTarget.x = newScreen.x - this.navigator.width;
		}
	}
	
	/**
	 * @private
	 */
	private function activeTransitionPop_onUpdate():Void
	{
		if(this._savedOtherTarget)
		{
			var newScreen:DisplayObject = DisplayObject(this._activeTransition.target);
			this._savedOtherTarget.x = newScreen.x + this.navigator.width;
		}
	}
	
	/**
	 * @private
	 */
	private function activeTransition_onComplete():Void
	{
		this._activeTransition = null;
		this._savedOtherTarget = null;
		if(this._savedCompleteHandler != null)
		{
			this._savedCompleteHandler();
		}
	}
}