/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions;
import feathers.controls.ScreenNavigator;
import feathers.controls.TabBar;
import openfl.errors.ArgumentError;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;

/**
 * Slides new screens from the left or right depending on the old and new
 * selected index values of a TabBar control.
 *
 * @see feathers.controls.ScreenNavigator
 * @see feathers.controls.TabBar
 */
class TabBarSlideTransitionManager
{
	/**
	 * Constructor.
	 */
	public function new(navigator:ScreenNavigator, tabBar:TabBar)
	{
		if(navigator == null)
		{
			throw new ArgumentError("ScreenNavigator cannot be null.");
		}
		this.navigator = navigator;
		this.tabBar = tabBar;
		this._activeIndex = this._pendingIndex = tabBar.selectedIndex;
		this.tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
		this.navigator.transition = this.onTransition;
	}

	/**
	 * The <code>ScreenNavigator</code> being managed.
	 */
	private var navigator:ScreenNavigator;

	/**
	 * The <code>TabBar</code> that controls the navigation.
	 */
	private var tabBar:TabBar;

	/**
	 * @private
	 */
	private var _activeTransition:Tween;

	/**
	 * @private
	 */
	private var _savedOtherTarget:DisplayObject;

	/**
	 * @private
	 */
	private var _savedCompleteHandler:Dynamic;

	/**
	 * @private
	 */
	private var _oldScreen:DisplayObject;

	/**
	 * @private
	 */
	private var _newScreen:DisplayObject;

	/**
	 * @private
	 */
	private var _pendingIndex:Int;

	/**
	 * @private
	 */
	private var _activeIndex:Int;

	/**
	 * @private
	 */
	private var _isFromRight:Bool = true;

	/**
	 * @private
	 */
	private var _isWaitingOnTabBarChange:Bool = true;

	/**
	 * @private
	 */
	private var _isWaitingOnTransitionChange:Bool = true;

	/**
	 * The duration of the transition, measured in seconds.
	 *
	 * @default 0.25
	 */
	public var duration:Float = 0.25;

	/**
	 * A delay before the transition starts, measured in seconds. This may
	 * be required on low-end systems that will slow down for a short time
	 * after heavy texture uploads.
	 *
	 * @default 0.1
	 */
	public var delay:Float = 0.1;

	/**
	 * The easing function to use.
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 */
	public var ease:Dynamic = Transitions.EASE_OUT;

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
		this._oldScreen = oldScreen;
		this._newScreen = newScreen;
		this._savedCompleteHandler = onComplete;

		if(!this._isWaitingOnTabBarChange)
		{
			this.transitionNow();
		}
		else
		{
			this._isWaitingOnTransitionChange = false;
		}
	}

	/**
	 * @private
	 */
	private function transitionNow():Void
	{
		this._activeIndex = this._pendingIndex;
		if(this._activeTransition != null)
		{
			this._savedOtherTarget  = null;
			Starling.current.juggler.remove(this._activeTransition);
			this._activeTransition = null;
		}

		if(this._oldScreen == null || this._newScreen == null || this.skipNextTransition)
		{
			this.skipNextTransition = false;
			var savedCompleteHandler:Dynamic = this._savedCompleteHandler;
			this._savedCompleteHandler = null;
			if(this._oldScreen != null)
			{
				this._oldScreen.x = 0;
			}
			if(this._newScreen != null)
			{
				this._newScreen.x = 0;
			}
			if(savedCompleteHandler != null)
			{
				savedCompleteHandler();
			}
		}
		else
		{
			this._oldScreen.x = 0;
			var activeTransition_onUpdate:Dynamic;
			if(this._isFromRight)
			{
				this._newScreen.x = this.navigator.width;
				activeTransition_onUpdate = this.activeTransitionFromRight_onUpdate;
			}
			else
			{
				this._newScreen.x = -this.navigator.width;
				activeTransition_onUpdate = this.activeTransitionFromLeft_onUpdate;
			}
			this._savedOtherTarget = this._oldScreen;
			this._activeTransition = new Tween(this._newScreen, this.duration, this.ease);
			this._activeTransition.animate("x", 0);
			this._activeTransition.delay = this.delay;
			this._activeTransition.onUpdate = activeTransition_onUpdate;
			this._activeTransition.onComplete = activeTransition_onComplete;
			Starling.current.juggler.add(this._activeTransition);
		}

		this._oldScreen = null;
		this._newScreen = null;
		this._isWaitingOnTabBarChange = true;
		this._isWaitingOnTransitionChange = true;
	}

	/**
	 * @private
	 */
	private function activeTransitionFromRight_onUpdate():Void
	{
		if(this._savedOtherTarget != null)
		{
			var newScreen:DisplayObject = cast this._activeTransition.target;
			this._savedOtherTarget.x = newScreen.x - this.navigator.width;
		}
	}

	/**
	 * @private
	 */
	private function activeTransitionFromLeft_onUpdate():Void
	{
		if(this._savedOtherTarget != null)
		{
			var newScreen:DisplayObject = cast this._activeTransition.target;
			this._savedOtherTarget.x = newScreen.x + this.navigator.width;
		}
	}

	/**
	 * @private
	 */
	private function activeTransition_onComplete():Void
	{
		this._savedOtherTarget = null;
		this._activeTransition = null;
		if(this._savedCompleteHandler != null)
		{
			this._savedCompleteHandler();
		}
	}

	/**
	 * @private
	 */
	private function tabBar_changeHandler(event:Event):Void
	{
		this._pendingIndex = this.tabBar.selectedIndex;
		if(this._pendingIndex == this._activeIndex)
		{
			//someone is changing tabs very quickly, and they just went back
			//to the tab we're currently transitioning to. cancel the next
			//transition.
			this._isWaitingOnTabBarChange = true;
			return;
		}
		this._isFromRight = this._pendingIndex > this._activeIndex;

		if(!this._isWaitingOnTransitionChange)
		{
			this.transitionNow();
		}
		else
		{
			this._isWaitingOnTabBarChange = false;
		}
	}
}