/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups;
import feathers.core.IFeathersControl;
import feathers.core.IValidating;
import feathers.core.PopUpManager;
import feathers.core.ValidationQueue;
import feathers.events.FeathersEventType;
import feathers.utils.display.FeathersDisplayUtil.getDisplayObjectDepthFromStage;

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
 * @inheritDoc
 *///[Event(name="open",type="starling.events.Event")]

/**
 * @inheritDoc
 *///[Event(name="close",type="starling.events.Event")]

/**
 * Displays pop-up content as a desktop-style drop-down.
 */
class DropDownPopUpContentManager extends EventDispatcher implements IPopUpContentManager
{
	/**
	 * Constructor.
	 */
	public function new()
	{
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
		PopUpManager.addPopUp(this.content, false, false);
		if(Std.is(this.content, IFeathersControl))
		{
			this.content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
		}
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
		var stage:Stage = Starling.current.stage;
		stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
		if(Std.is(this.content, IFeathersControl))
		{
			this.content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
		}
		PopUpManager.removePopUp(this.content);
		this.content = null;
		this.source = null;
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
		var globalOrigin:Rectangle = this.source.getBounds(stage);

		if(Std.is(this.source, IValidating))
		{
			cast(this.source, IValidating).validate();
		}

		var sourceWidth:Float = this.source.width;
		var hasSetBounds:Bool = false;
		var uiContent:IFeathersControl = cast(this.content, IFeathersControl);
		if(uiContent != null && uiContent.minWidth < sourceWidth)
		{
			uiContent.minWidth = sourceWidth;
			hasSetBounds = true;
		}
		if(Std.is(this.content, IValidating))
		{
			uiContent.validate();
		}
		if(!hasSetBounds && this.content.width < sourceWidth)
		{
			this.content.width = sourceWidth;
		}

		//we need to be sure that the source is properly positioned before
		//positioning the content relative to it.
		var validationQueue:ValidationQueue = ValidationQueue.forStarling(Starling.current);
		if(validationQueue != null && !validationQueue.isValidating)
		{
			//force a COMPLETE validation of everything
			//but only if we're not already doing that...
			validationQueue.advanceTime(0);
		}

		var downSpace:Float = (stage.stageHeight - this.content.height) - (globalOrigin.y + globalOrigin.height + this._gap);
		if(downSpace >= 0)
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
		var idealXPosition:Float = globalOrigin.x + (globalOrigin.width - this.content.width) / 2;
		var xPosition:Float = Starling.current.stage.stageWidth - this.content.width;
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
		var xPosition:Float = Starling.current.stage.stageWidth - this.content.width;
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
		var touch:Touch = event.getTouch(Starling.current.stage, TouchPhase.BEGAN);
		if(touch == null)
		{
			return;
		}
		this.close();
	}
}
