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
 * positions display objects in 3D space is if they are printed on opposite
 * sides of a postcard. A display object may appear on the front or back
 * side, and the card rotates around its center to reveal the other side.
 * The card may rotate up or down around the x-axis, or they may rotate left
 * or right around the y-axis.
 *
 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
 */
class Flip
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * Creates a transition function for a screen navigator that positions
	 * the screens in 3D space is if they are printed on opposite sides of a
	 * postcard, and the card rotates left, around its y-axis, to reveal the
	 * new screen on the back side.
	 *
	 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createFlipLeftTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new FlipTween(newScreen, oldScreen, Math.PI, 0, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that positions
	 * the screens in 3D space is if they are printed on opposite sides of a
	 * postcard, and the card rotates right, around its y-axis, to reveal
	 * the new screen on the back side.
	 *
	 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createFlipRightTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new FlipTween(newScreen, oldScreen, -Math.PI, 0, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that positions
	 * the screens in 3D space is if they are printed on opposite sides of a
	 * postcard, and the card rotates up, around its x-axis, to reveal the
	 * new screen on the back side.
	 *
	 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createFlipUpTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new FlipTween(newScreen, oldScreen, 0, -Math.PI, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that positions
	 * the screens in 3D space is if they are printed on opposite sides of a
	 * postcard, and the card rotates down, around its x-axis, to reveal the
	 * new screen on the back side.
	 *
	 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createFlipDownTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new FlipTween(newScreen, oldScreen, 0, Math.PI, duration, ease, onComplete, tweenProperties);
		}
	}
}