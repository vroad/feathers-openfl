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
 * slides a display object from off-stage. The display object may slide up,
 * right, down, or left.
 *
 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
 */
class Slide
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * Creates a transition function for a screen navigator that slides the
	 * new screen to the left from off-stage, pushing the old screen in the
	 * same direction.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createSlideLeftTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				if(oldScreen != null)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				newScreen.x = newScreen.width;
				newScreen.y = 0;
				new SlideTween(newScreen, oldScreen, -newScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				new SlideTween(oldScreen, null, -oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that that slides
	 * the new screen to the right from off-stage, pushing the old screen in
	 * the same direction.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createSlideRightTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				if(oldScreen != null)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				newScreen.x = -newScreen.width;
				newScreen.y = 0;
				new SlideTween(newScreen, oldScreen, newScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				new SlideTween(oldScreen, null, oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that that slides
	 * the new screen up from off-stage, pushing the old screen in the same
	 * direction.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createSlideUpTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				if(oldScreen != null)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				newScreen.x = 0;
				newScreen.y = newScreen.height;
				new SlideTween(newScreen, oldScreen, 0, -newScreen.height, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				new SlideTween(oldScreen, null, 0, -oldScreen.height, duration, ease, onComplete, tweenProperties);
			}
		}
	}

	/**
	 * Creates a transition function for a screen navigator that that slides
	 * the new screen down from off-stage, pushing the old screen in the
	 * same direction.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createSlideDownTransition(duration:Float = 0.5, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
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
				if(oldScreen != null)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				newScreen.x = 0;
				newScreen.y = -newScreen.height;
				new SlideTween(newScreen, oldScreen, 0, newScreen.height, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				new SlideTween(oldScreen, null, 0, oldScreen.height, duration, ease, onComplete, tweenProperties);
			}
		}
	}
}