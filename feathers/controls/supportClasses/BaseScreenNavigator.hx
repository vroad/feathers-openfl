/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.controls.IScreen;
import feathers.core.FeathersControl;
import feathers.core.IValidating;
import feathers.events.FeathersEventType;
import openfl.errors.ArgumentError;

import flash.errors.IllegalOperationError;
import flash.geom.Rectangle;
#if 0
import flash.utils.getDefinitionByName;
#end

import starling.display.DisplayObject;
import starling.errors.AbstractMethodError;
import starling.events.Event;

import feathers.core.FeathersControl.INVALIDATION_FLAG_SELECTED;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;

/**
 * Dispatched when the active screen changes.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.CHANGE
 */
#if 0
[Event(name="change",type="starling.events.Event")]
#end

/**
 * Dispatched when the current screen is removed and there is no active
 * screen.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.CLEAR
 */
#if 0
[Event(name="clear",type="starling.events.Event")]
#end

/**
 * Dispatched when the transition between screens begins.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_START
 */
#if 0
[Event(name="transitionStart",type="starling.events.Event")]
#end

/**
 * Dispatched when the transition between screens has completed.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_COMPLETE
 */
#if 0
[Event(name="transitionComplete",type="starling.events.Event")]
#end

/**
 * A base class for screen navigator components that isn't meant to be
 * instantiated directly. It should only be subclassed.
 *
 * @see feathers.controls.StackScreenNavigator
 * @see feathers.controls.ScreenNavigator
 */
class BaseScreenNavigator extends FeathersControl
{
	/**
	 * @private
	 */
	private static var SIGNAL_TYPE:Class<Dynamic>;

	/**
	 * The screen navigator will auto size itself to fill the entire stage.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_STAGE:String = "stage";

	/**
	 * The screen navigator will auto size itself to fit its content.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_CONTENT:String = "content";

	/**
	 * The default transition function.
	 */
	private static function defaultTransition(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Dynamic):Void
	{
		//in short, do nothing
		completeCallback();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		#if 0
		if(Object(this).constructor == BaseScreenNavigator)
		{
			throw new Error(FeathersControl.ABSTRACT_CLASS_ERROR);
		}
		if(!SIGNAL_TYPE)
		{
			try
			{
				SIGNAL_TYPE = Class(getDefinitionByName("org.osflash.signals.ISignal"));
			}
			catch(error:Error)
			{
				//signals not being used
			}
		}
		#end
		this.addEventListener(Event.ADDED_TO_STAGE, screenNavigator_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, screenNavigator_removedFromStageHandler);
	}

	/**
	 * @private
	 */
	private var _activeScreenID:String;

	/**
	 * The string identifier for the currently active screen.
	 */
	public var activeScreenID(get, never):String;
	public function get_activeScreenID():String
	{
		return this._activeScreenID;
	}

	/**
	 * @private
	 */
	private var _activeScreen:DisplayObject;

	/**
	 * A reference to the currently active screen.
	 */
	public var activeScreen(get, never):DisplayObject;
	public function get_activeScreen():DisplayObject
	{
		return this._activeScreen;
	}

	/**
	 * @private
	 */
	private var _screens:Map<String, IScreenNavigatorItem> = new Map();

	/**
	 * @private
	 */
	private var _previousScreenInTransitionID:String;

	/**
	 * @private
	 */
	private var _previousScreenInTransition:DisplayObject;

	/**
	 * @private
	 */
	private var _nextScreenID:String = null;

	/**
	 * @private
	 */
	private var _nextScreenTransition:DisplayObject->DisplayObject->Dynamic->Void = null;

	/**
	 * @private
	 */
	private var _clearAfterTransition:Bool = false;

	/**
	 * @private
	 */
	private var _clipContent:Bool = false;

	/**
	 * Determines if the navigator's content should be clipped to the width
	 * and height.
	 *
	 * <p>In the following example, clipping is enabled:</p>
	 *
	 * <listing version="3.0">
	 * navigator.clipContent = true;</listing>
	 *
	 * @default false
	 */
	public var clipContent(get, set):Bool;
	public function get_clipContent():Bool
	{
		return this._clipContent;
	}

	/**
	 * @private
	 */
	public function set_clipContent(value:Bool):Bool
	{
		if(this._clipContent == value)
		{
			return get_clipContent();
		}
		this._clipContent = value;
		if(!value)
		{
			this.clipRect = null;
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_clipContent();
	}

	/**
	 * @private
	 */
	private var _autoSizeMode:String = AUTO_SIZE_MODE_STAGE;

	#if 0
	[Inspectable(type="String",enumeration="stage,content")]
	#end
	/**
	 * Determines how the screen navigator will set its own size when its
	 * dimensions (width and height) aren't set explicitly.
	 *
	 * <p>In the following example, the screen navigator will be sized to
	 * match its content:</p>
	 *
	 * <listing version="3.0">
	 * navigator.autoSizeMode = ScreenNavigator.AUTO_SIZE_MODE_CONTENT;</listing>
	 *
	 * @default ScreenNavigator.AUTO_SIZE_MODE_STAGE
	 *
	 * @see #AUTO_SIZE_MODE_STAGE
	 * @see #AUTO_SIZE_MODE_CONTENT
	 */
	public var autoSizeMode(get, set):String;
	public function get_autoSizeMode():String
	{
		return this._autoSizeMode;
	}

	/**
	 * @private
	 */
	public function set_autoSizeMode(value:String):String
	{
		if(this._autoSizeMode == value)
		{
			return get_autoSizeMode();
		}
		this._autoSizeMode = value;
		if(this._activeScreen != null)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
			{
				this._activeScreen.addEventListener(Event.RESIZE, activeScreen_resizeHandler);
			}
			else
			{
				this._activeScreen.removeEventListener(Event.RESIZE, activeScreen_resizeHandler);
			}
		}
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return get_autoSizeMode();
	}

	/**
	 * @private
	 */
	private var _waitingTransition:DisplayObject->DisplayObject->Dynamic->Void;

	/**
	 * @private
	 */
	private var _waitingForTransitionFrameCount:Int = 1;

	/**
	 * @private
	 */
	private var _isTransitionActive:Bool = false;

	/**
	 * Indicates whether the screen navigator is currently transitioning
	 * between screens.
	 */
	public var isTransitionActive(get, never):Bool;
	public function get_isTransitionActive():Bool
	{
		return this._isTransitionActive;
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this._activeScreen != null)
		{
			this.cleanupActiveScreen();
			this._activeScreen = null;
			this._activeScreenID = null;
		}
		super.dispose();
	}

	/**
	 * Removes all screens that were added with <code>addScreen()</code>.
	 *
	 * @see #addScreen()
	 */
	public function removeAllScreens():Void
	{
		if(this._isTransitionActive)
		{
			throw new IllegalOperationError("Cannot remove all screens while a transition is active.");
		}
		if(this._activeScreen != null)
		{
			//if someone meant to have a transition, they would have called
			//clearScreen()
			this.clearScreenInternal(null);
			this.dispatchEventWith(FeathersEventType.CLEAR);
		}
		for(id in this._screens.keys())
		{
			this._screens.remove(id);
		}
	}

	/**
	 * Determines if the specified screen identifier has been added with
	 * <code>addScreen()</code>.
	 *
	 * @see #addScreen()
	 */
	public function hasScreen(id:String):Bool
	{
		return this._screens.exists(id);
	}

	/**
	 * Returns a list of the screen identifiers that have been added.
	 */
	public function getScreenIDs(result:Array<String> = null):Array<String>
	{
		if(result != null)
		{
			result.splice(0, result.length);
		}
		else
		{
			result = new Array<String>();
		}
		var pushIndex:Int = 0;
		for(id in this._screens.keys())
		{
			result[pushIndex] = id;
			pushIndex++;
		}
		return result;
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);
		var selectionInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SELECTED);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(sizeInvalid || selectionInvalid)
		{
			if(this._activeScreen != null)
			{
				if(this._activeScreen.width != this.actualWidth)
				{
					this._activeScreen.width = this.actualWidth;
				}
				if(this._activeScreen.height != this.actualHeight)
				{
					this._activeScreen.height = this.actualHeight;
				}
			}
		}

		if(stylesInvalid || sizeInvalid)
		{
			this.refreshClipRect();
		}
	}

	/**
	 * If the component's dimensions have not been set explicitly, it will
	 * measure its content and determine an ideal size for itself. If the
	 * <code>explicitWidth</code> or <code>explicitHeight</code> member
	 * variables are set, those value will be used without additional
	 * measurement. If one is set, but not the other, the dimension with the
	 * explicit value will not be measured, but the other non-explicit
	 * dimension will still need measurement.
	 *
	 * <p>Calls <code>setSizeInternal()</code> to set up the
	 * <code>actualWidth</code> and <code>actualHeight</code> member
	 * variables used for layout.</p>
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}

		if((this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || this.stage == null) &&
			Std.is(this._activeScreen, IValidating))
		{
			cast(this._activeScreen, IValidating).validate();
		}

		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || this.stage == null)
			{
				newWidth = this._activeScreen != null ? this._activeScreen.width : 0;
			}
			else
			{
				newWidth = this.stage.stageWidth;
			}
		}

		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || this.stage == null)
			{
				newHeight = this._activeScreen != null ? this._activeScreen.height : 0;
			}
			else
			{
				newHeight = this.stage.stageHeight;
			}
		}

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * @private
	 */
	private function addScreenInternal(id:String, item:IScreenNavigatorItem):Void
	{
		if(this._screens.exists(id))
		{
			throw new ArgumentError("Screen with id '" + id + "' already defined. Cannot add two screens with the same id.");
		}
		this._screens[id] = item;
	}

	/**
	 * @private
	 */
	private function refreshClipRect():Void
	{
		if(!this._clipContent)
		{
			return;
		}
		var clipRect:Rectangle = this.clipRect;
		if(clipRect == null)
		{
			clipRect = new Rectangle();
		}
		clipRect.width = this.actualWidth;
		clipRect.height = this.actualHeight;
		this.clipRect = clipRect;
	}

	/**
	 * @private
	 */
	private function removeScreenInternal(id:String):IScreenNavigatorItem
	{
		if(!this._screens.exists(id))
		{
			throw new ArgumentError("Screen '" + id + "' cannot be removed because it has not been added.");
		}
		if(this._isTransitionActive && (id == this._previousScreenInTransitionID || id == this._activeScreenID))
		{
			throw new IllegalOperationError("Cannot remove a screen while it is transitioning in or out.");
		}
		if(this._activeScreenID == id)
		{
			//if someone meant to have a transition, they would have called
			//clearScreen()
			this.clearScreenInternal(null);
			this.dispatchEventWith(FeathersEventType.CLEAR);
		}
		var item:IScreenNavigatorItem = this._screens[id];
		this._screens.remove(id);
		return item;
	}

	/**
	 * @private
	 */
	private function showScreenInternal(id:String, transition:DisplayObject->DisplayObject->Dynamic->Void, properties:Dynamic = null):DisplayObject
	{
		if(!this.hasScreen(id))
		{
			throw new ArgumentError("Screen with id '" + id + "' cannot be shown because it has not been defined.");
		}

		if(this._isTransitionActive)
		{
			this._nextScreenID = id;
			this._nextScreenTransition = transition;
			this._clearAfterTransition = false;
			return null;
		}

		if(this._activeScreenID == id)
		{
			return this._activeScreen;
		}

		this._previousScreenInTransition = this._activeScreen;
		this._previousScreenInTransitionID = this._activeScreenID;
		if(this._activeScreen != null)
		{
			this.cleanupActiveScreen();
		}

		this._isTransitionActive = true;

		var item:IScreenNavigatorItem = this._screens[id];
		this._activeScreen = item.getScreen();
		this._activeScreenID = id;
		for(propertyName in Reflect.fields(properties))
		{
			Reflect.setProperty(this._activeScreen, propertyName, Reflect.getProperty(properties, propertyName));
		}
		if(Std.is(this._activeScreen, IScreen))
		{
			var screen:IScreen = cast this._activeScreen;
			screen.screenID = this._activeScreenID;
			screen.owner = this; //subclasses will implement the interface
		}
		if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || this.stage == null)
		{
			this._activeScreen.addEventListener(Event.RESIZE, activeScreen_resizeHandler);
		}
		this.prepareActiveScreen();
		this.addChild(this._activeScreen);

		this.invalidate(INVALIDATION_FLAG_SELECTED);
		if(this._validationQueue != null && !this._validationQueue.isValidating)
		{
			//force a COMPLETE validation of everything
			//but only if we're not already doing that...
			this._validationQueue.advanceTime(0);
		}
		else if(!this._isValidating)
		{
			this.validate();
		}

		this.dispatchEventWith(FeathersEventType.TRANSITION_START);
		this._activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_START);
		if(this._previousScreenInTransition != null)
		{
			this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);
		}
		if(transition != null)
		{
			//temporarily make the active screen invisible because the
			//transition doesn't start right away.
			this._activeScreen.visible = false;
			this._waitingForTransitionFrameCount = 0;
			this._waitingTransition = transition;
			//this is a workaround for an issue with transition performance.
			//see the comment in the listener for details.
			this.addEventListener(Event.ENTER_FRAME, waitingForTransition_enterFrameHandler);
		}
		else
		{
			defaultTransition(this._previousScreenInTransition, this._activeScreen, transitionComplete);
		}

		this.dispatchEventWith(Event.CHANGE);
		return this._activeScreen;
	}

	/**
	 * @private
	 */
	private function clearScreenInternal(transition:Dynamic = null):Void
	{
		if(this._activeScreen == null)
		{
			//no screen visible.
			return;
		}

		if(this._isTransitionActive)
		{
			this._nextScreenID = null;
			this._clearAfterTransition = true;
			this._nextScreenTransition = transition;
			return;
		}

		this.cleanupActiveScreen();

		this._isTransitionActive = true;
		this._previousScreenInTransition = this._activeScreen;
		this._previousScreenInTransitionID = this._activeScreenID;
		this._activeScreen = null;
		this._activeScreenID = null;

		this.dispatchEventWith(FeathersEventType.TRANSITION_START);
		this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);
		if(transition != null)
		{
			this._waitingForTransitionFrameCount = 0;
			this._waitingTransition = transition;
			//this is a workaround for an issue with transition performance.
			//see the comment in the listener for details.
			this.addEventListener(Event.ENTER_FRAME, waitingForTransition_enterFrameHandler);
		}
		else
		{
			defaultTransition(this._previousScreenInTransition, this._activeScreen, transitionComplete);
		}
		this.invalidate(INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * @private
	 */
	private function prepareActiveScreen():Void
	{
		throw new AbstractMethodError();
	}

	/**
	 * @private
	 */
	private function cleanupActiveScreen():Void
	{
		throw new AbstractMethodError();
	}

	/**
	 * @private
	 */
	private function transitionComplete(cancelTransition:Bool = false):Void
	{
		this._isTransitionActive = false;
		var item:IScreenNavigatorItem;
		if(cancelTransition)
		{
			if(this._activeScreen != null)
			{
				item = this._screens[this._activeScreenID];
				this.cleanupActiveScreen();
				this.removeChild(this._activeScreen, item.canDispose);
			}
			this._activeScreen = this._previousScreenInTransition;
			this._activeScreenID = this._previousScreenInTransitionID;
			this._previousScreenInTransition = null;
			this._previousScreenInTransitionID = null;
			this.prepareActiveScreen();
			this.dispatchEventWith(FeathersEventType.TRANSITION_CANCEL);
		}
		else
		{
			if(this._previousScreenInTransition != null)
			{
				this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_COMPLETE);
			}
			if(this._activeScreen != null)
			{
				this._activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE);
			}
			this.dispatchEventWith(FeathersEventType.TRANSITION_COMPLETE);
			if(this._previousScreenInTransition != null)
			{
				item = this._screens[this._previousScreenInTransitionID];
				if(Std.is(this._previousScreenInTransition, IScreen))
				{
					var screen:IScreen = cast this._previousScreenInTransition;
					screen.screenID = null;
					screen.owner = null;
				}
				this._previousScreenInTransition.removeEventListener(Event.RESIZE, activeScreen_resizeHandler);
				this.removeChild(this._previousScreenInTransition, item.canDispose);
				this._previousScreenInTransition = null;
				this._previousScreenInTransitionID = null;
			}
		}

		if(this._clearAfterTransition)
		{
			this.clearScreenInternal(this._nextScreenTransition);
		}
		else if(this._nextScreenID != null)
		{
			this.showScreenInternal(this._nextScreenID, this._nextScreenTransition);
		}

		this._nextScreenID = null;
		this._nextScreenTransition = null;
		this._clearAfterTransition = false;
	}

	/**
	 * @private
	 */
	private function screenNavigator_addedToStageHandler(event:Event):Void
	{
		this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
	}

	/**
	 * @private
	 */
	private function screenNavigator_removedFromStageHandler(event:Event):Void
	{
		this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
	}

	/**
	 * @private
	 */
	private function activeScreen_resizeHandler(event:Event):Void
	{
		if(this._isValidating || this._autoSizeMode != AUTO_SIZE_MODE_CONTENT)
		{
			return;
		}
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function stage_resizeHandler(event:Event):Void
	{
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function waitingForTransition_enterFrameHandler(event:Event):Void
	{
		//we need to wait a couple of frames before we can start the
		//transition to make it as smooth as possible. this feels a little
		//hacky, to be honest, but I can't figure out why waiting only one
		//frame won't do the trick. the delay is so small though that it's
		//virtually impossible to notice.
		if(this._waitingForTransitionFrameCount < 2)
		{
			this._waitingForTransitionFrameCount++;
			return;
		}
		this.removeEventListener(Event.ENTER_FRAME, waitingForTransition_enterFrameHandler);
		if(this._activeScreen != null)
		{
			this._activeScreen.visible = true;
		}

		var transition:DisplayObject->DisplayObject->Dynamic->Void = this._waitingTransition;
		this._waitingTransition = null;
		transition(this._previousScreenInTransition, this._activeScreen, transitionComplete);
	}
}
