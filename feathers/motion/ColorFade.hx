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

#if 0
[Exclude(name="createBlackFadeToBlackTransition",kind="method")]
#end

/**
 * Creates animated effects, like transitions for screen navigators, that
 * fade a display object to a solid color.
 *
 * @see ../../../help/transitions.html#colorfade Transitions for Feathers screen navigators: ColorFade
 */
class ColorFade
{
	/**
	 * @private
	 */
	inline private static var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	/**
	 * @private
	 * This was accidentally named wrong. It is included for temporary
	 * backward compatibility.
	 */
	public static function createBlackFadeToBlackTransition(duration:Float = 0.75, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return createBlackFadeTransition(duration, ease, tweenProperties);
	}

	/**
	 * Creates a transition function for a screen navigator that hides the
	 * old screen as a solid black color fades in over it. Then, the solid
	 * black color fades back out to show that the new screen has replaced
	 * the old screen.
	 *
	 * @see ../../../help/transitions.html#colorfade Transitions for Feathers screen navigators: ColorFade
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createBlackFadeTransition(duration:Float = 0.75, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return createColorFadeTransition(0x000000, duration, ease, tweenProperties);
	}

	/**
	 * Creates a transition function for a screen navigator that hides the old screen as a solid
	 * white color fades in over it. Then, the solid white color fades back
	 * out to show that the new screen has replaced the old screen.
	 *
	 * @see ../../../help/transitions.html#colorfade Transitions for Feathers screen navigators: ColorFade
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createWhiteFadeTransition(duration:Float = 0.75, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return createColorFadeTransition(0xffffff, duration, ease, tweenProperties);
	}

	/**
	 * Creates a transition function for a screen navigator that hides the
	 * old screen as a customizable solid color fades in over it. Then, the
	 * solid color fades back out to show that the new screen has replaced
	 * the old screen.
	 *
	 * @see ../../../help/transitions.html#colorfade Transitions for Feathers screen navigators: ColorFade
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createColorFadeTransition(color:UInt, duration:Float = 0.75, ease:String = null, tweenProperties:Dynamic = null):DisplayObject->DisplayObject->Dynamic->Void
	{
		if (ease == null) ease = Transitions.EASE_OUT;
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:DisplayObject->DisplayObject->Dynamic->Void):Void
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
				new ColorFadeTween(newScreen, oldScreen, color, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.alpha = 1;
				new ColorFadeTween(oldScreen, null, color, duration, ease, onComplete, tweenProperties);
			}
		}
	}
}