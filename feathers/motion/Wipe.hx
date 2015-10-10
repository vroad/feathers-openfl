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
 * wipes a display object out of view, revealing another display object
 * under the first. Both display objects remain stationary while the
 * effect animates clipping rectangles.
 *
 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
 */
class Wipe
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * Creates a transition function for a screen navigator that wipes the
	 * old screen out of view to the left, animating the <code>width</code>
	 * property of a <code>clipRect</code>, to reveal the new screen under
	 * it. The new screen remains stationary.
	 *
	 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createWipeLeftTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var xOffset:Float = oldScreen != null ? -oldScreen.width : -newScreen.width;
			new WipeTween(newScreen, oldScreen, xOffset, 0, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that wipes the
	 * old screen out of view to the right, animating the <code>x</code>
	 * and <code>width</code> properties of a <code>clipRect</code>, to
	 * reveal the new screen under it. The new screen remains stationary.
	 *
	 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createWipeRightTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var xOffset:Float = oldScreen != null ? oldScreen.width : newScreen.width;
			new WipeTween(newScreen, oldScreen, xOffset, 0, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that wipes the
	 * old screen up, animating the <code>height</code> property of a
	 * <code>clipRect</code>, to reveal the new screen under it. The new
	 * screen remains stationary.
	 *
	 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createWipeUpTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var yOffset:Float = oldScreen != null ? -oldScreen.height : -newScreen.height;
			new WipeTween(newScreen, oldScreen, 0, yOffset, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that wipes the
	 * old screen down, animating the <code>y</code> and <code>height</code>
	 * properties of a <code>clipRect</code>, to reveal the new screen under
	 * it. The new screen remains stationary.
	 *
	 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createWipeDownTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var yOffset:Float = oldScreen != null ? oldScreen.height : newScreen.height;
			new WipeTween(newScreen, oldScreen, 0, yOffset, duration, ease, onComplete, tweenProperties);
		}
	}
}