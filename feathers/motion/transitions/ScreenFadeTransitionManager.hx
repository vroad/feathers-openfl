/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions;
import feathers.controls.ScreenNavigator;
import feathers.motion.Fade;

import openfl.errors.ArgumentError;

import starling.animation.Transitions;
import starling.display.DisplayObject;

/**
 * A transition for <code>ScreenNavigator</code> that fades out the old
 * screen and fades in the new screen.
 *
 * @see feathers.controls.ScreenNavigator
 */
class ScreenFadeTransitionManager
{
	/**
	 * Constructor.
	 */
	public function new(navigator:ScreenNavigator)
	{
		if(navigator == null)
		{
			throw new ArgumentError("ScreenNavigator cannot be null.");
		}
		this.navigator = navigator;
		this.navigator.transition = this.onTransition;
	}

	/**
	 * The <code>ScreenNavigator</code> being managed.
	 */
	private var navigator:ScreenNavigator;

	/**
	 * @private
	 */
	private var _transition:Function;

	/**
	 * @private
	 */
	private var _duration:Number = 0.25;
	
	/**
	 * The duration of the transition, measured in seconds.
	 *
	 * @default 0.25
	 */
	public function get_duration():Number
	{
		return this._duration;
	}

	/**
	 * @private
	 */
	public function set_duration(value:Number):Number
	{
		if(this._duration == value)
		{
			return;
		}
		this._duration = value;
		this._transition = null;
	}

	/**
	 * @private
	 */
	private var _delay:Number = 0.1;

	/**
	 * A delay before the transition starts, measured in seconds. This may
	 * be required on low-end systems that will slow down for a short time
	 * after heavy texture uploads.
	 *
	 * @default 0.1
	 */
	public function get_delay():Number
	{
		return this._delay;
	}

	/**
	 * @private
	 */
	public function set_delay(value:Number):Number
	{
		if(this._delay == value)
		{
			return;
		}
		this._delay = value;
		this._transition = null;
	}

	/**
	 * @private
	 */
	private var _ease:Object = Transitions.EASE_OUT;
	
	/**
	 * The easing function to use.
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 */
	public function get_ease():Object
	{
		return this._ease;
	}

	/**
	 * @private
	 */
	public function set_ease(value:Object):Object
	{
		if(this._ease == value)
		{
			return;
		}
		this._ease = value;
		this._transition = null;
	}

	/**
	 * Determines if the next transition should be skipped. After the
	 * transition, this value returns to <code>false</code>.
	 *
	 * @default false
	 */
	public var skipNextTransition:Bool = false;
	
	/**
	 * The function passed to the <code>transition</code> property of the
	 * <code>ScreenNavigator</code>.
	 */
	private function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
	{
		if(this.skipNextTransition != null)
		{
			this.skipNextTransition = false;
			if(onComplete != null)
			{
				onComplete();
			}
			return;
		}
		if(this._transition === null)
		{
			this._transition = Fade.createCrossfadeTransition(this._duration, this._ease, {delay: this._delay});
		}
		this._transition(oldScreen, newScreen, onComplete);
	}
}