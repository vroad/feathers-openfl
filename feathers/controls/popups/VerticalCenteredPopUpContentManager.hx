/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups;
import feathers.core.IFeathersControl;
import feathers.core.IValidating;
import feathers.core.PopUpManager;
import feathers.events.FeathersEventType;
import feathers.utils.display.FeathersDisplayUtil.getDisplayObjectDepthFromStage;

import openfl.errors.IllegalOperationError;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.ui.Keyboard;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Stage;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.ResizeEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the pop-up content opens.
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
 * @eventType starling.events.Event.OPEN
 *///[Event(name="open",type="starling.events.Event")]

/**
 * Dispatched when the pop-up content closes.
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
 * @eventType starling.events.Event.CLOSE
 *///[Event(name="close",type="starling.events.Event")]

/**
 * Displays a pop-up at the center of the stage, filling the vertical space.
 * The content will be sized horizontally so that it is no larger than the
 * the width or height of the stage (Std.is(whichever, smaller)).
 */
class VerticalCenteredPopUpContentManager extends EventDispatcher implements IPopUpContentManager
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * Quickly sets all margin properties to the same value. The
	 * <code>margin</code> getter always returns the value of
	 * <code>marginTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>The following example gives the pop-up a minimum of 20 pixels of
	 * margin on all sides:</p>
	 *
	 * <listing version="3.0">
	 * manager.margin = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #marginTop
	 * @see #marginRight
	 * @see #marginBottom
	 * @see #marginLeft
	 */
	public var margin(get, set):Float;
	public function get_margin():Float
	{
		return this.marginTop;
	}

	/**
	 * @private
	 */
	public function set_margin(value:Float):Float
	{
		this.marginTop = 0;
		this.marginRight = 0;
		this.marginBottom = 0;
		this.marginLeft = 0;
		return get_margin();
	}

	/**
	 * The minimum space, in pixels, between the top edge of the content and
	 * the top edge of the stage.
	 *
	 * <p>The following example gives the pop-up a minimum of 20 pixels of
	 * margin on the top:</p>
	 *
	 * <listing version="3.0">
	 * manager.marginTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #margin
	 */
	public var marginTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the right edge of the content
	 * and the right edge of the stage.
	 *
	 * <p>The following example gives the pop-up a minimum of 20 pixels of
	 * margin on the right:</p>
	 *
	 * <listing version="3.0">
	 * manager.marginRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #margin
	 */
	public var marginRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the bottom edge of the content
	 * and the bottom edge of the stage.
	 *
	 * <p>The following example gives the pop-up a minimum of 20 pixels of
	 * margin on the bottom:</p>
	 *
	 * <listing version="3.0">
	 * manager.marginBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #margin
	 */
	public var marginBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the left edge of the content
	 * and the left edge of the stage.
	 *
	 * <p>The following example gives the pop-up a minimum of 20 pixels of
	 * margin on the left:</p>
	 *
	 * <listing version="3.0">
	 * manager.marginLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #margin
	 */
	public var marginLeft:Float = 0;

	/**
	 * @private
	 */
	private var content:DisplayObject;

	/**
	 * @private
	 */
	private var touchPointID:Int = -1;

	/**
	 * @inheritDoc
	 */
	public var isOpen(get, never):Bool;
	public function get_isOpen():Bool
	{
		return this.content != null;
	}

	/**
	 * @inheritDoc
	 */
	public function open(content:DisplayObject, source:DisplayObject):Void
	{
		if(this.isOpen)
		{
			throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
		}

		this.content = content;
		PopUpManager.addPopUp(this.content, true, false);
		if(Std.is(this.content, IFeathersControl))
		{
			this.content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
		}
		this.content.addEventListener(Event.REMOVED_FROM_STAGE, content_removedFromStageHandler);
		this.layout();
		var stage:Stage = Starling.current.stage;
		stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
		stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

		//using priority here is a hack so that objects higher up in the
		//display list have a chance to cancel the event first.
		var priority:Int = -getDisplayObjectDepthFromStage(this.content);
		Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, priority, true);
		this.dispatchEventWith(Event.OPEN);
	}

	/**
	 * @inheritDoc
	 */
	public function close():Void
	{
		if(!this.isOpen)
		{
			return;
		}
		var content:DisplayObject = this.content;
		this.content = null;
		var stage:Stage = Starling.current.stage;
		stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
		if(Std.is(content, IFeathersControl))
		{
			content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
		}
		content.removeEventListener(Event.REMOVED_FROM_STAGE, content_removedFromStageHandler);
		if(content.parent != null)
		{
			content.removeFromParent(false);
		}
		this.dispatchEventWith(Event.CLOSE);
	}

	/**
	 * @inheritDoc
	 */
	public function dispose():Void
	{
		this.close();
	}

	/**
	 * @private
	 */
	private function layout():Void
	{
		var stage:Stage = Starling.current.stage;
		var maxWidth:Float = stage.stageWidth;
		if(maxWidth > stage.stageHeight)
		{
			maxWidth = stage.stageHeight;
		}
		maxWidth -= (this.marginLeft + this.marginRight);
		var maxHeight:Float = stage.stageHeight - this.marginTop - this.marginBottom;
		var hasSetBounds:Bool = false;
		if(Std.is(this.content, IFeathersControl))
		{
			//if it's a ui control that is able to auto-size, this section
			//will ensure that the control stays within the required bounds.
			var uiContent:IFeathersControl = cast(this.content, IFeathersControl);
			uiContent.minWidth = maxWidth;
			uiContent.maxWidth = maxWidth;
			uiContent.maxHeight = maxHeight;
			hasSetBounds = true;
		}
		if(Std.is(this.content, IValidating))
		{
			cast(this.content, IValidating).validate();
		}
		if(!hasSetBounds)
		{
			//if it's not a ui control, and the control's explicit width and
			//height values are greater than our maximum bounds, then we
			//will enforce the maximum bounds the hard way.
			if(this.content.width > maxWidth)
			{
				this.content.width = maxWidth;
			}
			if(this.content.height > maxHeight)
			{
				this.content.height = maxHeight;
			}
		}
		//round to the nearest pixel to avoid unnecessary smoothing
		this.content.x = Math.round((stage.stageWidth - this.content.width) / 2);
		this.content.y = Math.round((stage.stageHeight - this.content.height) / 2);
	}

	/**
	 * @private
	 */
	private function content_resizeHandler(event:Event):Void
	{
		this.layout();
	}

	/**
	 * @private
	 */
	private function content_removedFromStageHandler(event:Event):Void
	{
		this.close();
	}

	/**
	 * @private
	 */
	private function nativeStage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.isDefaultPrevented())
		{
			//someone else already handled this one
			return;
		}
		#if flash
		if(event.keyCode != Keyboard.BACK && event.keyCode != Keyboard.ESCAPE)
		{
			return;
		}
		//don't let the OS handle the event
		event.preventDefault();
		#end

		this.close();
	}

	/**
	 * @private
	 */
	private function stage_resizeHandler(event:ResizeEvent):Void
	{
		this.layout();
	}

	/**
	 * @private
	 */
	private function stage_touchHandler(event:TouchEvent):Void
	{
		if(!PopUpManager.isTopLevelPopUp(this.content))
		{
			return;
		}
		var stage:Stage = Starling.current.stage;
		var touch:Touch;
		var hitTestResult:DisplayObject;
		var isInBounds:Bool;
		if(this.touchPointID >= 0)
		{
			touch = event.getTouch(stage, TouchPhase.ENDED, this.touchPointID);
			if(touch == null)
			{
				return;
			}
			touch.getLocation(stage, HELPER_POINT);
			hitTestResult = stage.hitTest(HELPER_POINT, true);
			isInBounds = false;
			if(Std.is(this.content, DisplayObjectContainer))
			{
				isInBounds = cast(this.content, DisplayObjectContainer).contains(hitTestResult);
			}
			else
			{
				isInBounds = this.content == hitTestResult;
			}
			if(!isInBounds)
			{
				this.touchPointID = -1;
				this.close();
			}
		}
		else
		{
			touch = event.getTouch(stage, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			touch.getLocation(stage, HELPER_POINT);
			hitTestResult = stage.hitTest(HELPER_POINT, true);
			isInBounds = false;
			if(Std.is(this.content, DisplayObjectContainer))
			{
				isInBounds = cast(this.content, DisplayObjectContainer).contains(hitTestResult);
			}
			else
			{
				isInBounds = this.content == hitTestResult;
			}
			if(isInBounds)
			{
				return;
			}
			this.touchPointID = touch.id;
		}
	}


}
