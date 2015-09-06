/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
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
 * Dispatched when the media has played to its end.
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
 * An interface for media players that play timed content.
 */
interface ITimedMediaPlayer extends IMediaPlayer
{
	/**
	 * The current position of the playhead, in seconds.
	 *
	 * @see #event:currentTimeChange feathers.events.MediaPlayerEventType.CURRENT_TIME_CHANGE
	 */
	var currentTime(get, never):Float;
	//function get_currentTime():Float;

	/**
	 * The maximum position of the playhead, in seconds.
	 *
	 * @see #event:totalTimeChange feathers.events.MediaPlayerEventType.TOTAL_TIME_CHANGE
	 */
	var totalTime(get, never):Float;
	//function get_totalTime():Float;

	/**
	 * Determines if the media content is currently playing.
	 *
	 * @see #event:playbackStateChange feathers.events.MediaPlayerEventType.PLAYBACK_STATE_CHANGE
	 */
	var isPlaying(get, never):Bool;
	//function get_isPlaying():Bool;

	/**
	 * Toggles the media content between playing and paused states.
	 * 
	 * @see #isPlaying
	 * @see #play()
	 * @see #pause()
	 */
	function togglePlayPause():Void;

	/**
	 * Plays the media content.
	 * 
	 * @see #isPlaying
	 * @see #pause()
	 * @see #stop()
	 */
	function play():Void;

	/**
	 * Pauses the media content.
	 *
	 * @see #isPlaying
	 * @see #play()
	 */
	function pause():Void;

	/**
	 * Stops the media content and returns the playhead to the beginning.
	 * 
	 * @see #isPlaying
	 * @see #play()
	 * @see #pause()
	 */
	function stop():Void;

	/**
	 * Seeks the media content to a specific position, in seconds.
	 */
	function seek(seconds:Float):Void;
}
