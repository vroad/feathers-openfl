/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion;
import openfl.errors.ArgumentError;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

/**
 * Creates animated effects, like transitions for screen navigators, that
 * slides a display object out of view, animating the `x` or `y` property,
 * to reveal the content below it. The display object may slide up, right,
 * down, or left.
 *
 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
 */
class Reveal
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * old screen out of view to the left, animating the `x` property, to
	 * reveal the new screen under it. The new screen remains stationary.
	 *
	 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createRevealLeftTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				oldScreen.x = 0;
				oldScreen.y = 0;
			}
			if(newScreen != null)
			{
				newScreen.x = 0;
				newScreen.y = 0;
				new RevealTween(oldScreen, newScreen, -newScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				slideOutOldScreen(oldScreen, -oldScreen.width, 0, duration, ease, tweenProperties, onComplete);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * old screen out of view to the right, animating the `x` property, to
	 * reveal the new screen under it. The new screen remains stationary.
	 *
	 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createRevealRightTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				oldScreen.x = 0;
				oldScreen.y = 0;
			}
			if(newScreen != null)
			{
				newScreen.x = 0;
				newScreen.y = 0;
				new RevealTween(oldScreen, newScreen, newScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				slideOutOldScreen(oldScreen, oldScreen.width, 0, duration, ease, tweenProperties, onComplete);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * old screen up out of view, animating the `y` property, to reveal the
	 * new screen under it. The new screen remains stationary.
	 *
	 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createRevealUpTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				oldScreen.x = 0;
				oldScreen.y = 0;
			}
			if(newScreen != null)
			{
				newScreen.x = 0;
				newScreen.y = 0;
				new RevealTween(oldScreen, newScreen, 0, -newScreen.height, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				slideOutOldScreen(oldScreen, 0, -oldScreen.height, duration, ease, tweenProperties, onComplete);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * old screen down out of view, animating the `y` property, to reveal the
	 * new screen under it. The new screen remains stationary.
	 *
	 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createRevealDownTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				oldScreen.x = 0;
				oldScreen.y = 0;
			}
			if(newScreen != null)
			{
				newScreen.x = 0;
				newScreen.y = 0;
				new RevealTween(oldScreen, newScreen, 0, newScreen.height, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				slideOutOldScreen(oldScreen, 0, oldScreen.height, duration, ease, tweenProperties, onComplete);
			}
		}
	}

	/**
	 * @private
	 */
	private static function slideOutOldScreen(oldScreen:DisplayObject,
		xOffset:Float, yOffset:Float, duration:Float, ease:String,
		tweenProperties:Dynamic, onComplete:Dynamic):Void
	{
		var tween:Tween = new Tween(oldScreen, duration, ease);
		if(xOffset != 0)
		{
			tween.animate("x", xOffset);
		}
		if(yOffset != 0)
		{
			tween.animate("y", yOffset);
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

