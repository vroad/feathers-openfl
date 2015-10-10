/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

import openfl.errors.ArgumentError;

/**
 * Creates animated effects, like transitions for screen navigators, that
 * slide a display object into view, animating the `x` or `y` property, to
 * cover the content below it.
 *
 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
 */
class Cover
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * new screen into view to the left, animating the `x` property, to
	 * cover up the old screen, which remains stationary.
	 *
	 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCoverLeftTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			if(newScreen != null)
			{
				newScreen.x = newScreen.width;
				newScreen.y = 0;
			}
			if(oldScreen != null)
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				new CoverTween(newScreen, oldScreen, -oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the new screen
			{
				slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * new screen into view to the right, animating the `x` property, to
	 * cover up the old screen, which remains stationary.
	 *
	 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCoverRightTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			if(newScreen != null)
			{
				newScreen.x = -newScreen.width;
				newScreen.y = 0;
			}
			if(oldScreen != null)
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				new CoverTween(newScreen, oldScreen, oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the new screen
			{
				slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * new screen up into view, animating the `y` property, to cover up the
	 * old screen, which remains stationary.
	 *
	 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCoverUpTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			if(newScreen != null)
			{
				newScreen.x = 0;
				newScreen.y = newScreen.height;
			}
			if(oldScreen != null)
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				new CoverTween(newScreen, oldScreen, 0, -oldScreen.height, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the new screen
			{
				slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * new screen down into view, animating the `y` property, to cover up the
	 * old screen, which remains stationary.
	 *
	 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCoverDownTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			if(newScreen != null)
			{
				newScreen.x = 0;
				newScreen.y = -newScreen.height;
			}
			if(oldScreen != null)
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				new CoverTween(newScreen, oldScreen, 0, oldScreen.height, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the new screen
			{
				slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
			}
		}
	}

	/**
	 * @private
	 */
	private static function slideInNewScreen(newScreen:DisplayObject,
		duration:Float, ease:String, tweenProperties:Dynamic, onComplete:Dynamic):Void
	{
		var tween:Tween = new Tween(newScreen, duration, ease);
		if(newScreen.x != 0)
		{
			tween.animate("x", 0);
		}
		if(newScreen.y != 0)
		{
			tween.animate("y", 0);
		}
		if(tweenProperties)
		{
			for(propertyName in Reflect.fields(tweenProperties))
			{
				Reflect.setProperty(tween, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}
		tween.onComplete = onComplete;
		Starling.current.juggler.add(tween);
	}
}