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
 * positions a display object in 3D space as if it is on a side of a cube,
 * and the cube may rotate up or down around the x-axis, or it may rotate
 * left or right around the y-axis..
 *
 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
 */
class Cube
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * Creates a transition function for a screen navigator that positions
	 * the screens in 3D space as if they are on two adjacent sides of a
	 * cube, and the cube rotates left around the y-axis.
	 *
	 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCubeLeftTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new CubeTween(newScreen, oldScreen, Math.PI / 2, 0, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that positions
	 * the screens in 3D space as if they are on two adjacent sides of a
	 * cube, and the cube rotates right around the y-axis.
	 *
	 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCubeRightTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new CubeTween(newScreen, oldScreen, -Math.PI / 2, 0, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that positions
	 * the screens in 3D space as if they are on two adjacent sides of a
	 * cube, and the cube rotates up around the x-axis.
	 *
	 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCubeUpTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new CubeTween(newScreen, oldScreen, 0, -Math.PI / 2, duration, ease, onComplete, tweenProperties);
		}
	}

	/**
	 * Creates a transition function for a screen navigator that positions
	 * the screens in 3D space as if they are on two adjacent sides of a
	 * cube, and the cube rotates down around the y-axis.
	 *
	 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createCubeDownTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Dynamic):Void
		{
			if(oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			new CubeTween(newScreen, oldScreen, 0, Math.PI / 2, duration, ease, onComplete, tweenProperties);
		}
	}
}