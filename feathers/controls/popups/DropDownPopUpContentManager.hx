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
import feathers.core.ValidationQueue;
import feathers.events.FeathersEventType;
#if 0
import feathers.utils.display.getDisplayObjectDepthFromStage;
import feathers.utils.display.stageToStarling;
#else
import feathers.utils.display.FeathersDisplayUtil.getDisplayObjectDepthFromStage;
import feathers.utils.display.FeathersDisplayUtil.stageToStarling;
#end

import openfl.errors.IllegalOperationError;
import openfl.events.KeyboardEvent;
import openfl.geom.Rectangle;
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
 * Displays pop-up content as a desktop-style drop-down.
 */
class DropDownPopUpContentManager extends EventDispatcher implements IPopUpContentManager
{
	/**
	 * @private
	 */
	private static var HELPER_RECTANGLE:Rectangle = new Rectangle();

	/**
	 * The pop-up content will be positioned below the source, if possible. 
	 * 
	 * @see #primaryDirection
	 */
	inline public static var PRIMARY_DIRECTION_DOWN:String = "down";

	/**
	 * The pop-up content will be positioned above the source, if possible.
	 *
	 * @see #primaryDirection
	 */
	inline public static var PRIMARY_DIRECTION_UP:String = "up";
	
	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * @private
	 */
	private var content:DisplayObject;

	/**
	 * @private
	 */
	private var source:DisplayObject;

	/**
	 * @inheritDoc
	 */
	public var isOpen(get, never):Bool;
	public function get_isOpen():Bool
	{
		return this.content != null;
	}

	/**
	 * @private
	 */
	private var _isModal:Bool = false;

	/**
	 * Determines if the pop-up will be modal or not.
	 *
	 * <p>Note: If you change this value while a pop-up is displayed, the
	 * new value will not go into effect until the pop-up is removed and a
	 * new pop-up is added.</p>
	 *
	 * <p>In the following example, the pop-up is modal:</p>
	 *
	 * <listing version="3.0">
	 * manager.isModal = true;</listing>
	 *
	 * @default false
	 */
	public var isModal(get, set):Bool;
	public function get_isModal():Bool
	{
		return this._isModal;
	}

	/**
	 * @private
	 */
	public function set_isModal(value:Bool):Bool
	{
		this._isModal = value;
		return get_isModal();
	}

	/**
	 * @private
	 */
	private var _overlayFactory:Void->DisplayObject;

	/**
	 * If <code>isModal</code> is <code>true</code>, this function may be
	 * used to customize the modal overlay displayed by the pop-up manager.
	 * If the value of <code>overlayFactory</code> is <code>null</code>, the
	 * pop-up manager's default overlay factory will be used instead.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 * <pre>function():DisplayObject</pre>
	 *
	 * <p>In the following example, the overlay is customized:</p>
	 *
	 * <listing version="3.0">
	 * manager.isModal = true;
	 * manager.overlayFactory = function():DisplayObject
	 * {
	 *     var quad:Quad = new Quad(1, 1, 0xff00ff);
	 *     quad.alpha = 0;
	 *     return quad;
	 * };</listing>
	 *
	 * @default null
	 * 
	 * @see feathers.core.PopUpManager#overlayFactory
	 */
	public var overlayFactory(get, set):Void->DisplayObject;
	public function get_overlayFactory():Void->DisplayObject
	{
		return this._overlayFactory;
	}

	/**
	 * @private
	 */
	public function set_overlayFactory(value:Void->DisplayObject):Void->DisplayObject
	{
		this._overlayFactory = value;
		return get_overlayFactory();
	}

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * The space, in pixels, between the source and the pop-up.
	 */
	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return this._gap;
	}

	/**
	 * @private
	 */
	public function set_gap(value:Float):Float
	{
		this._gap = value;
		return get_gap();
	}

	/**
	 * @private
	 */
	private var _primaryDirection:String = PRIMARY_DIRECTION_DOWN;

	/**
	 * The space, in pixels, between the source and the pop-up.
	 * 
	 * @default DropDownPopUpContentManager.PRIMARY_DIRECTION_DOWN
	 * 
	 * @see #PRIMARY_DIRECTION_DOWN
	 * @see #PRIMARY_DIRECTION_UP
	 */
	public var primaryDirection(get, set):String;
	public function get_primaryDirection():String
	{
		return this._primaryDirection;
	}

	/**
	 * @private
	 */
	public function set_primaryDirection(value:String):String
	{
		this._primaryDirection = value;
		return get_primaryDirection();
	}

	/**
	 * @private
	 */
	private var _fitContentMinWidthToOrigin:Bool = true;

	/**
	 * If enabled, the pop-up content's <code>minWidth</code> property will
	 * be set to the <code>width</code> property of the origin, if it is
	 * smaller.
	 *
	 * @default true
	 */
	public var fitContentMinWidthToOrigin(get, set):Bool;
	public function get_fitContentMinWidthToOrigin():Bool
	{
		return this._fitContentMinWidthToOrigin;
	}

	/**
	 * @private
	 */
	public function set_fitContentMinWidthToOrigin(value:Bool):Bool
	{
		this._fitContentMinWidthToOrigin = value;
		return get_fitContentMinWidthToOrigin();
	}

	/**
	 * @private
	 */
	private var _lastGlobalX:Float;

	/**
	 * @private
	 */
	private var _lastGlobalY:Float;

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
		this.source = source;
		PopUpManager.addPopUp(this.content, this._isModal, false, this._overlayFactory);
		if(Std.is(this.content, IFeathersControl))
		{
			this.content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
		}
		this.content.addEventListener(Event.REMOVED_FROM_STAGE, content_removedFromStageHandler);
		this.layout();
		var stage:Stage = this.source.stage;
		stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
		stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);

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
		this.source = null;
		var stage:Stage = content.stage;
		stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
		var starling:Starling = stageToStarling(stage);
		starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
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
		if(Std.is(this.source, IValidating))
		{
			cast(this.source, IValidating).validate();
			if(!this.isOpen)
			{
				//it's possible that the source will close its pop-up during
				//validation, so we should check for that.
				return;
			}
		}

		var sourceWidth:Float = this.source.width;
		var hasSetBounds:Bool = false;
		var uiContent:IFeathersControl = cast(this.content, IFeathersControl);
		if(this._fitContentMinWidthToOrigin && uiContent != null && uiContent.minWidth < sourceWidth)
		{
			uiContent.minWidth = sourceWidth;
			hasSetBounds = true;
		}
		if(Std.is(this.content, IValidating))
		{
			uiContent.validate();
		}
		if(!hasSetBounds && this._fitContentMinWidthToOrigin && this.content.width < sourceWidth)
		{
			this.content.width = sourceWidth;
		}

		var stage:Stage = this.source.stage;
		
		//we need to be sure that the source is properly positioned before
		//positioning the content relative to it.
		var starling:Starling = stageToStarling(stage);
		var validationQueue:ValidationQueue = ValidationQueue.forStarling(starling);
		if(validationQueue != null && !validationQueue.isValidating)
		{
			//force a COMPLETE validation of everything
			//but only if we're not already doing that...
			validationQueue.advanceTime(0);
		}

		var globalOrigin:Rectangle = this.source.getBounds(stage);
		this._lastGlobalX = globalOrigin.x;
		this._lastGlobalY = globalOrigin.y;

		var downSpace:Float = (stage.stageHeight - this.content.height) - (globalOrigin.y + globalOrigin.height + this._gap);
		//skip this if the primary direction is up
		if(this._primaryDirection == PRIMARY_DIRECTION_DOWN && downSpace >= 0)
		{
			layoutBelow(globalOrigin);
			return;
		}

		var upSpace:Float = globalOrigin.y - this._gap - this.content.height;
		if(upSpace >= 0)
		{
			layoutAbove(globalOrigin);
			return;
		}
		
		//do what we skipped earlier if the primary direction is up
		if(this._primaryDirection == PRIMARY_DIRECTION_UP && downSpace >= 0)
		{
			layoutBelow(globalOrigin);
			return;
		}

		//worst case: pick the side that has the most available space
		if(upSpace >= downSpace)
		{
			layoutAbove(globalOrigin);
		}
		else
		{
			layoutBelow(globalOrigin);
		}

		//the content is too big for the space, so we need to adjust it to
		//fit properly
		var newMaxHeight:Float = stage.stageHeight - (globalOrigin.y + globalOrigin.height);
		if(uiContent != null)
		{
			if(uiContent.maxHeight > newMaxHeight)
			{
				uiContent.maxHeight = newMaxHeight;
			}
		}
		else if(this.content.height > newMaxHeight)
		{
			this.content.height = newMaxHeight;
		}
	}

	/**
	 * @private
	 */
	private function layoutAbove(globalOrigin:Rectangle):Void
	{
		var idealXPosition:Float = globalOrigin.x;
		var xPosition:Float = this.content.stage.stageWidth - this.content.width;
		if(xPosition > idealXPosition)
		{
			xPosition = idealXPosition;
		}
		if(xPosition < 0)
		{
			xPosition = 0;
		}
		this.content.x = xPosition;
		this.content.y = globalOrigin.y - this.content.height - this._gap;
	}

	/**
	 * @private
	 */
	private function layoutBelow(globalOrigin:Rectangle):Void
	{
		var idealXPosition:Float = globalOrigin.x;
		var xPosition:Float = this.content.stage.stageWidth - this.content.width;
		if(xPosition > idealXPosition)
		{
			xPosition = idealXPosition;
		}
		if(xPosition < 0)
		{
			xPosition = 0;
		}
		this.content.x = xPosition;
		this.content.y = globalOrigin.y + globalOrigin.height + this._gap;
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
	private function stage_enterFrameHandler(event:Event):Void
	{
		this.source.getBounds(this.source.stage, HELPER_RECTANGLE);
		if(HELPER_RECTANGLE.x != this._lastGlobalX || HELPER_RECTANGLE.y != this._lastGlobalY)
		{
			this.layout();
		}
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
		var target:DisplayObject = cast(event.target, DisplayObject);
		if(this.content == target || (Std.is(this.content, DisplayObjectContainer) && cast(this.content, DisplayObjectContainer).contains(target)))
		{
			return;
		}
		if(this.source == target || (Std.is(this.source, DisplayObjectContainer) && cast(this.source, DisplayObjectContainer).contains(target)))
		{
			return;
		}
		if(!PopUpManager.isTopLevelPopUp(this.content))
		{
			return;
		}
		//any began touch is okay here. we don't need to check all touches
		var stage:Stage = cast(event.currentTarget, Stage);
		var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
		if(touch == null)
		{
			return;
		}
		this.close();
	}
}
