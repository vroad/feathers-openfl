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

/**
 * Creates animated effects, like transitions for screen navigators, that
 * shows or hides a display object masked by a growing or shrinking circle.
 * In a transition, both display objects remain stationary while the effect
 * animates a stencil mask.
 * 
 * <p>Note: This effect is not supported with display objects that have
 * transparent backgrounds due to limitations in stencil masks. Display
 * objects should be fully opaque.</p>
 *
 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
 */
class Iris
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * Creates a transition function for a screen navigator that shows a
	 * screen by masking it with a growing circle in the center.
	 *
	 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createIrisOpenTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var originX:Float;
			var originY:Float;
			if(oldScreen != null)
			{
				originX = oldScreen.width / 2;
				originY = oldScreen.height / 2;
			}
			else
			{
				originX = newScreen.width / 2;
				originY = newScreen.height / 2;
			}
			new IrisTween(newScreen, oldScreen, originX, originY, true, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that shows a
	 * screen by masking it with a growing circle at a specific position.
	 *
	 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createIrisOpenTransitionAt(x:Float, y:Float, duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new IrisTween(newScreen, oldScreen, x, y, true, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that hides a
	 * screen by masking it with a shrinking circle in the center.
	 *
	 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createIrisCloseTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var originX:Float;
			var originY:Float;
			if(oldScreen != null)
			{
				originX = oldScreen.width / 2;
				originY = oldScreen.height / 2;
			}
			else
			{
				originX = newScreen.width / 2;
				originY = newScreen.height / 2;
			}
			new IrisTween(newScreen, oldScreen, originX, originY, false, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that hides a
	 * screen by masking it with a shrinking circle at a specific position.
	 *
	 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createIrisCloseTransitionAt(x:Float, y:Float, duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new IrisTween(newScreen, oldScreen, x, y, false, duration, ease, onComplete, tweenProperties);
		}
	}
}