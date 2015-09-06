/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.errors.AbstractClassError;
import starling.events.Event;

/**
 * An abstract superclass for media players that should implement the
 * <code>feathers.media.IMediaPlayer</code> interface.
 */
class BaseMediaPlayer extends LayoutGroup implements IMediaPlayer
{
	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		#if 0
		if(Object(this).constructor == BaseMediaPlayer)
		{
			throw new AbstractClassError();
		}
		#end
		this.addEventListener(Event.ADDED, mediaPlayer_addedHandler);
		this.addEventListener(Event.REMOVED, mediaPlayer_removedHandler);
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(this._layout == null)
		{
			this.layout = new AnchorLayout();
		}
		super.initialize();
	}

	/**
	 * @private
	 */
	private function handleAddedChild(child:DisplayObject):Void
	{
		if(Std.is(child, IMediaPlayerControl))
		{
			cast(child, IMediaPlayerControl).mediaPlayer = this;
		}
		if(Std.is(child, DisplayObjectContainer))
		{
			var container:DisplayObjectContainer = cast(child, DisplayObjectContainer);
			var childCount:Int = container.numChildren;
			//for(var i:Int = 0; i < childCount; i++)
			for(i in 0 ... childCount)
			{
				child = container.getChildAt(i);
				this.handleAddedChild(child);
			}
		}
	}

	/**
	 * @private
	 */
	private function handleRemovedChild(child:DisplayObject):Void
	{
		if(Std.is(child, IMediaPlayerControl))
		{
			cast(child, IMediaPlayerControl).mediaPlayer = null;
		}
		if(Std.is(child, DisplayObjectContainer))
		{
			var container:DisplayObjectContainer = cast child;
			var childCount:Int = container.numChildren;
			//for(var i:Int = 0; i < childCount; i++)
			for(i in 0 ... childCount)
			{
				child = container.getChildAt(i);
				this.handleRemovedChild(child);
			}
		}
	}

	/**
	 * @private
	 */
	private function mediaPlayer_addedHandler(event:Event):Void
	{
		var addedChild:DisplayObject = cast(event.target, DisplayObject);
		this.handleAddedChild(addedChild);
	}

	/**
	 * @private
	 */
	private function mediaPlayer_removedHandler(event:Event):Void
	{
		var removedChild:DisplayObject = cast(event.target, DisplayObject);
		this.handleRemovedChild(removedChild);
	}
}
