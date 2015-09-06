/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion;
import openfl.errors.ArgumentError;
import starling.animation.Transitions;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;

/**
 * Creates animated effects, like transitions for screen navigators, that
 * animates the `alpha` property of a display object to fade it in or out.
 *
 * @see ../../../help/transitions.html#fade Transitions for Feathers screen navigators: Fade
 */
class Fade
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * Creates a transition function for a screen navigator that fades in
	 * the new screen by animating the `alpha` property from `0.0` to `1.0`,
	 * while the old screen remains fully opaque at a lower depth.
	 *
	 * @see ../../../help/transitions.html#fade Transitions for Feathers screen navigators: Fade
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createFadeInTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				newScreen.alpha = 0;
				//make sure the new screen is on top
				var parent:DisplayObjectContainer = newScreen.parent;
				parent.setChildIndex(newScreen, parent.numChildren - 1);
				if(oldScreen != null) //oldScreen can be null, that's okay
				{
					oldScreen.alpha = 1;
				}
				new FadeTween(newScreen, oldScreen, duration, ease, onComplete, tweenProperties);
			}
			else
			{
				//there's no new screen to fade in, but we still want some
				//kind of animation, so we'll just fade out the old screen
				//in order to have some animation, we're going to fade out
				oldScreen.alpha = 1;
				new FadeTween(oldScreen, null, duration, ease, onComplete, tweenProperties);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that fades out
	 * the old screen by animating the `alpha` property from `1.0` to `0.0`,
	 * while the new screen remains fully opaque at a lower depth.
	 *
	 * @see ../../../help/transitions.html#fade Transitions for Feathers screen navigators: Fade
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createFadeOutTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			if(oldScreen != null)
			{
				//make sure the old screen is on top
				var parent:DisplayObjectContainer = oldScreen.parent;
				parent.setChildIndex(oldScreen, parent.numChildren - 1);
				oldScreen.alpha = 1;
				if(newScreen != null) //newScreen can be null, that's okay
				{
					newScreen.alpha = 1;
				}
				new FadeTween(oldScreen, null, duration, ease, onComplete, tweenProperties);
			}
			else
			{
				//there's no old screen to fade out, but we still want some
				//kind of animation, so we'll just fade in the new screen
				//in order to have some animation, we're going to fade out
				newScreen.alpha = 0;
				new FadeTween(newScreen, null, duration, ease, onComplete, tweenProperties);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that crossfades
	 * the screens. In other words, the old screen fades out, animating the
	 * `alpha` property from `1.0` to `0.0`. Simultaneously, the new screen
	 * fades in, animating its `alpha` property from `0.0` to `1.0`.
	 *
	 * @see ../../../help/transitions.html#fade Transitions for Feathers screen navigators: Fade
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCrossfadeTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				newScreen.alpha = 0;
				if(oldScreen != null) //oldScreen can be null, that's okay
				{
					oldScreen.alpha = 1;
				}
				new FadeTween(newScreen, oldScreen, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.alpha = 1;
				new FadeTween(oldScreen, null, duration, ease, onComplete, tweenProperties);
			}
		}
	}
}