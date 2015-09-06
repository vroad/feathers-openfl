/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
import feathers.events.MediaPlayerEventType;

import starling.errors.AbstractClassError;

/**
 * Dispatched when the media player's total playhead time changes.
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
 * @see #totalTime
 *
 * @eventType feathers.events.MediaPlayerEventType.TOTAL_TIME_CHANGE
 */
#if 0
[Event(name="totalTimeChange",type="starling.events.Event")]
#end

/**
 * Dispatched when the media player's current playhead time changes.
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
 * @see #currentTime
 *
 * @eventType feathers.events.MediaPlayerEventType.CURRENT_TIME_CHANGE
 */
#if 0
[Event(name="currentTimeChange",type="starling.events.Event")]
#end

/**
 * Dispatched when the media player's playback state changes, such as when
 * it begins playing or is paused.
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
 * @see #isPlaying
 *
 * @eventType feathers.events.MediaPlayerEventType.PLAYBACK_STATE_CHANGE
 */
#if 0
[Event(name="playbackStageChange",type="starling.events.Event")]
#end

/**
 * Dispatched when the media completes playback because the current time has
 * reached the total time.
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
 * @eventType starling.events.Event.COMPLETE
 */
#if 0
[Event(name="complete",type="starling.events.Event")]
#end

/**
 * An abstract superclass for media players that should implement the
 * <code>feathers.media.ITimedMediaPlayer</code> interface.
 */
class BaseTimedMediaPlayer extends BaseMediaPlayer implements ITimedMediaPlayer
{
	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		#if 0
		if(Object(this).constructor == BaseTimedMediaPlayer)
		{
			throw new AbstractClassError();
		}
		#end
	}

	/**
	 * @private
	 */
	private var _isPlaying:Bool = false;

	/**
	 * @inheritDoc
	 *
	 * @see #event:playbackStateChange feathers.events.MediaPlayerEventType.PLAYBACK_STATE_CHANGE
	 */
	public var isPlaying(get, never):Bool;
	public function get_isPlaying():Bool
	{
		return this._isPlaying;
	}

	/**
	 * @private
	 */
	private var _currentTime:Float = 0;

	/**
	 * @inheritDoc
	 *
	 * @see #event:currentTimeChange feathers.events.MediaPlayerEventType.CURRENT_TIME_CHANGE
	 */
	public var currentTime(get, never):Float;
	public function get_currentTime():Float
	{
		return this._currentTime;
	}

	/**
	 * @private
	 */
	private var _totalTime:Float = 0;

	/**
	 * @inheritDoc
	 *
	 * @see #event:totalTimeChange feathers.events.MediaPlayerEventType.TOTAL_TIME_CHANGE
	 */
	public var totalTime(get, never):Float;
	public function get_totalTime():Float
	{
		return this._totalTime;
	}

	/**
	 * @inheritDoc
	 *
	 * @see #isPlaying
	 * @see #play()
	 * @see #pause()
	 */
	public function togglePlayPause():Void
	{
		if(this._isPlaying)
		{
			this.pause();
		}
		else
		{
			this.play();
		}
	}

	/**
	 * @inheritDoc
	 *
	 * @see #isPlaying
	 * @see #pause()
	 * @see #stop()
	 */
	public function play():Void
	{
		if(this._isPlaying)
		{
			return;
		}
		this.playMedia();
		this._isPlaying = true;
		this.dispatchEventWith(MediaPlayerEventType.PLAYBACK_STATE_CHANGE);
	}

	/**
	 * @inheritDoc
	 *
	 * @see #isPlaying
	 * @see #play()
	 */
	public function pause():Void
	{
		if(!this._isPlaying)
		{
			return;
		}
		this.pauseMedia();
		this._isPlaying = false;
		this.dispatchEventWith(MediaPlayerEventType.PLAYBACK_STATE_CHANGE);
	}

	/**
	 * @inheritDoc
	 *
	 * @see #isPlaying
	 * @see #play()
	 * @see #pause()
	 */
	public function stop():Void
	{
		this.pause();
		this.seek(0);
	}

	/**
	 * @inheritDoc
	 */
	public function seek(seconds:Float):Void
	{
		this.seekMedia(seconds);
		this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
	}

	/**
	 * Internal function that starts playing the media content. Subclasses
	 * are expected override this function with a custom implementation for
	 * their specific type of media content.
	 */
	private function playMedia():Void
	{
		
	}

	/**
	 * Internal function that pauses the media content. Subclasses are
	 * expected override this function with a custom implementation for
	 * their specific type of media content.
	 */
	private function pauseMedia():Void
	{

	}

	/**
	 * Internal function that seeks the media content to a specific playhead
	 * time, in seconds. Subclasses are expected override this function with
	 * a custom implementation for their specific type of media content.
	 */
	private function seekMedia(seconds:Float):Void
	{

	}
}
