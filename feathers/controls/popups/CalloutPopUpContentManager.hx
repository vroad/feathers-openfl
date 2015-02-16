/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups;
import feathers.controls.Callout;

import openfl.errors.IllegalOperationError;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * @inheritDoc
 *///[Event(name="open",type="starling.events.Event")]

/**
 * @inheritDoc
 *///[Event(name="close",type="starling.events.Event")]

/**
 * Displays pop-up content (such as the List in a PickerList) in a Callout.
 *
 * @see feathers.controls.PickerList
 * @see feathers.controls.Callout
 */
class CalloutPopUpContentManager extends EventDispatcher implements IPopUpContentManager
{
	/**
	 * Constructor.
	 */
	public function CalloutPopUpContentManager()
	{
	}

	/**
	 * The factory used to create the <code>Callout</code> instance. If
	 * <code>null</code>, <code>Callout.calloutFactory()</code> will be used.
	 *
	 * <p>Note: If you change this value while a callout is open, the new
	 * value will not go into effect until the callout is closed and a new
	 * callout is opened.</p>
	 *
	 * @see feathers.controls.Callout#calloutFactory
	 *
	 * @default null
	 */
	public var calloutFactory:Dynamic;

	/**
	 * The direction of the callout.
	 *
	 * <p>Note: If you change this value while a callout is open, the new
	 * value will not go into effect until the callout is closed and a new
	 * callout is opened.</p>
	 *
	 * <p>In the following example, the callout direction is restricted to down:</p>
	 *
	 * <listing version="3.0">
	 * manager.direction = Callout.DIRECTION_DOWN;</listing>
	 *
	 * @see feathers.controls.Callout#DIRECTION_ANY
	 * @see feathers.controls.Callout#DIRECTION_UP
	 * @see feathers.controls.Callout#DIRECTION_DOWN
	 * @see feathers.controls.Callout#DIRECTION_LEFT
	 * @see feathers.controls.Callout#DIRECTION_RIGHT
	 *
	 * @default Callout.DIRECTION_ANY
	 */
	public var direction:String = Callout.DIRECTION_ANY;

	/**
	 * Determines if the callout will be modal or not.
	 *
	 * <p>Note: If you change this value while a callout is open, the new
	 * value will not go into effect until the callout is closed and a new
	 * callout is opened.</p>
	 *
	 * <p>In the following example, the callout is not modal:</p>
	 *
	 * <listing version="3.0">
	 * manager.isModal = false;</listing>
	 *
	 * @default true
	 */
	public var isModal:Bool = true;

	/**
	 * @private
	 */
	private var content:DisplayObject;

	/**
	 * @private
	 */
	private var callout:Callout;

	/**
	 * @inheritDoc
	 */
	public var isOpen(get, set):Bool;
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
		this.callout = Callout.show(content, source, this.direction, this.isModal, this.calloutFactory);
		this.callout.addEventListener(Event.CLOSE, callout_closeHandler);
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
		this.callout.close();
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
	private function cleanup():Void
	{
		this.content = null;
		this.callout.content = null;
		this.callout.removeEventListener(Event.CLOSE, callout_closeHandler);
		this.callout = null;
	}

	/**
	 * @private
	 */
	private function callout_closeHandler(event:Event):Void
	{
		this.cleanup();
		this.dispatchEventWith(Event.CLOSE);
	}
}
