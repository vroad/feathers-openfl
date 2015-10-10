/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
import feathers.events.MediaPlayerEventType;
import feathers.skins.IStyleProvider;
import openfl.errors.ArgumentError;

import flash.errors.IllegalOperationError;

import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

import starling.events.Event;

/**
 * Dispatched periodically when a media player's content is loading to
 * indicate the current progress.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>A numeric value between <code>0</code>
 *   and <code>1</code> that indicates how much of the media has loaded so far.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.MediaPlayerEventType.LOAD_PROGRESS
 */
#if 0
[Event(name="loadProgress",type="starling.events.Event")]
#end

/**
 * Dispatched when a media player's content is fully loaded and it
 * may be played to completion without buffering.
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
 * @see #isLoaded
 *
 * @eventType feathers.events.MediaPlayerEventType.LOAD_COMPLETE
 */
#if 0
[Event(name="loadComplete",type="starling.events.Event")]
#end

/**
 * Dispatched when the <code>flash.media.Sound</code> object dispatches
 * <code>flash.events.IOErrorEvent.IO_ERROR</code>.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The <code>flash.events.IOErrorEvent</code>
 *   dispatched by the <code>flash.media.Sound</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Sound.html#event:ioError flash.media.Sound: flash.events.IOErrorEvent.IO_ERROR
 *
 * @eventType starling.events.Event.IO_ERROR
 */
#if 0
[Event(name="ioError",type="starling.events.Event")]
#end

/**
 * Dispatched when the <code>flash.media.Sound</code> object dispatches
 * <code>flash.events.SecurityErrorEvent.SECURITY_ERROR</code>.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The <code>flash.events.SecurityErrorEvent</code>
 *   dispatched by the <code>flash.media.Sound</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Sound.html#event:securityError flash.media.Sound: flash.events.SecurityErrorEvent.SECURITY_ERROR
 *
 * @eventType starling.events.Event.SECURITY_ERROR
 */
#if 0
[Event(name="securityError",type="starling.events.Event")]
#end

/**
 * Dispatched when the media player's sound transform changes.
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
 * @see #soundTransform
 *
 * @eventType feathers.events.MediaPlayerEventType.SOUND_TRANSFORM_CHANGE
 */
#if 0
[Event(name="soundTransformChange",type="starling.events.Event")]
#end

/**
 * Controls playback of audio with a <code>flash.media.Sound</code> object.
 *
 * <p><strong>Beta Component:</strong> This is a new component, and its APIs
 * may need some changes between now and the next version of Feathers to
 * account for overlooked requirements or other issues. Upgrading to future
 * versions of Feathers may involve manual changes to your code that uses
 * this component. The
 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>
 * will not go into effect until this component's status is upgraded from
 * beta to stable.</p>
 * 
 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
 */
class SoundPlayer extends BaseTimedMediaPlayer implements IAudioPlayer
{
	/**
	 * @private
	 */
	inline private static var NO_SOUND_SOURCE_PLAY_ERROR:String = "Cannot play media when soundSource property has not been set.";
	
	/**
	 * The default <code>IStyleProvider</code> for all
	 * <code>SoundPlayer</code> components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;
	
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
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return SoundPlayer.globalStyleProvider;
	}
	
	/**
	 * @private
	 */
	private var _sound:Sound;
	
	/**
	 * The <code>flash.media.Sound</code> object that has loaded the
	 * content specified by <code>soundSource</code>.
	 * 
	 * @see #soundSource
	 */
	public var sound(get, never):Sound;
	public function get_sound():Sound
	{
		return this._sound;
	}
	
	/**
	 * @private
	 */
	private var _soundChannel:SoundChannel;

	/**
	 * The currently playing <code>flash.media.SoundChannel</code>.
	 */
	public var soundChannel(get, never):SoundChannel;
	public function get_soundChannel():SoundChannel
	{
		return this._soundChannel;
	}

	/**
	 * @private
	 */
	private var _soundSource:Dynamic;

	/**
	 * A URL specified as a <code>String</code> representing a URL, a
	 * <code>flash.net.URLRequest</code>, or a
	 * <code>flash.media.Sound</code> object. In the case of a
	 * <code>String</code> or a <code>URLRequest</code>, a new
	 * <code>flash.media.Sound</code> object will be created internally and
	 * the content will by loaded automatically.
	 *
	 * <p>In the following example, a sound file URL is passed in:</p>
	 *
	 * <listing version="3.0">
	 * soundPlayer.soundSource = "http://example.com/sound.mp3";</listing>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html flash.net.URLRequest
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Sound.html flash.media.Sound
	 */
	public var soundSource(get, set):Dynamic;
	public function get_soundSource():Dynamic
	{
		return this._soundSource;
	}

	/**
	 * @private
	 */
	public function set_soundSource(value:Dynamic):Dynamic
	{
		if(this._soundSource == value)
		{
			return get_soundSource();
		}
		if(this._isPlaying)
		{
			this.stop();
		}
		this._soundSource = value;
		//reset the current and total time if we were playing a different
		//sound previously
		if(this._currentTime != 0)
		{
			this._currentTime = 0;
			this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
		}
		if(this._totalTime != 0)
		{
			this._totalTime = 0;
			this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
		}
		this._isLoaded = false;
		if(Std.is(this._soundSource, String))
		{
			this.loadSourceFromURL(cast value);
		}
		else if(Std.is(this._soundSource, URLRequest))
		{
			this.loadSourceFromURLRequest(cast value);
		}
		else if(Std.is(this._soundSource, Sound))
		{
			this._sound = cast this._soundSource;
		}
		else if(this._soundSource == null)
		{
			this._sound = null;
		}
		else
		{
			throw new ArgumentError("Invalid source type for AudioPlayer. Expected a URL as a String, an URLRequest, a Sound object, or null.");
		}
		if(this._autoPlay && this._sound != null)
		{
			this.play();
		}
		return get_soundSource();
	}

	/**
	 * @private
	 */
	private var _isLoading:Bool = false;

	/**
	 * Indicates if the <code>flash.media.Sound</code> object is currently
	 * loading its content.
	 */
	public var isLoading(get, never):Bool;
	public function get_isLoading():Bool
	{
		return this._isLoading;
	}

	/**
	 * @private
	 */
	private var _isLoaded:Bool = false;

	/**
	 * Indicates if the <code>flash.media.Sound</code> object has finished
	 * loading its content.
	 * 
	 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
	 * @see #event:loadComplete feathers.events.MediaPlayerEventType.LOAD_COMPLETE
	 */
	public var isLoaded(get, never):Bool;
	public function get_isLoaded():Bool
	{
		return this._isLoaded;
	}

	/**
	 * @private
	 */
	private var _soundTransform:SoundTransform;

	/**
	 * @inheritDoc
	 *
	 * <p>In the following example, the audio is muted:</p>
	 *
	 * <listing version="3.0">
	 * soundPlayer.soundTransform = new SoundTransform(0);</listing>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/SoundTransform.html flash.media.SoundTransform
	 * @see #event:soundTransformChange feathers.events.MediaPlayerEventType.SOUND_TRANSFORM_CHANGE
	 */
	public var soundTransform(get, set):SoundTransform;
	public function get_soundTransform():SoundTransform
	{
		if(this._soundTransform == null)
		{
			this._soundTransform = new SoundTransform();
		}
		return this._soundTransform;
	}

	/**
	 * @private
	 */
	public function set_soundTransform(value:SoundTransform):SoundTransform
	{
		this._soundTransform = value;
		if(this._soundChannel != null)
		{
			this._soundChannel.soundTransform = this._soundTransform;
		}
		this.dispatchEventWith(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE);
		return get_soundTransform();
	}

	/**
	 * @private
	 */
	private var _autoPlay:Bool = true;

	/**
	 * Determines if the sound starts playing immediately when the
	 * <code>soundSource</code> property is set.
	 *
	 * <p>In the following example, automatic playback is disabled:</p>
	 *
	 * <listing version="3.0">
	 * soundPlayer.autoPlay = false;</listing>
	 * 
	 * @see #soundSource
	 */
	public var autoPlay(get, set):Bool;
	public function get_autoPlay():Bool
	{
		return this._autoPlay;
	}

	/**
	 * @private
	 */
	public function set_autoPlay(value:Bool):Bool
	{
		this._autoPlay = value;
		return get_autoPlay();
	}

	/**
	 * @private
	 */
	private var _loop:Bool = false;

	/**
	 * Determines if, upon reaching the end of the sound, the playhead
	 * automatically returns to the start of the media and plays again.
	 * 
	 * <p>If <code>loop</code> is <code>true</code>, the
	 * <code>autoRewind</code> property will be ignored because looping will
	 * always automatically rewind to the beginning.</p>
	 *
	 * <p>In the following example, looping is enabled:</p>
	 *
	 * <listing version="3.0">
	 * soundPlayer.loop = true;</listing>
	 */
	public var loop(get, set):Bool;
	public function get_loop():Bool
	{
		return this._loop;
	}

	/**
	 * @private
	 */
	public function set_loop(value:Bool):Bool
	{
		this._loop = value;
		return get_loop();
	}

	/**
	 * @private
	 */
	override private function playMedia():Void
	{
		if(this._soundSource == null)
		{
			throw new IllegalOperationError(NO_SOUND_SOURCE_PLAY_ERROR);
		}
		if(!this._sound.isBuffering && this._currentTime == this._totalTime)
		{
			//flash.events.Event.SOUND_COMPLETE may not be dispatched (or
			//maybe it is dispatched, but before the listener can be added)
			//if currentTime is equal to totalTime, so we need to do it
			//manually.
			this.handleSoundComplete();
			return;
		}
		if(this._soundTransform == null)
		{
			this._soundTransform = new SoundTransform();
		}
		this._soundChannel = this._sound.play(this._currentTime * 1000, 0, this._soundTransform);
		this._soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, soundChannel_soundCompleteHandler);
		this.addEventListener(Event.ENTER_FRAME, soundPlayer_enterFrameHandler);
	}

	/**
	 * @private
	 */
	override private function pauseMedia():Void
	{
		if(this._soundChannel == null)
		{
			//this could be null when seeking
			return;
		}
		this.removeEventListener(Event.ENTER_FRAME, soundPlayer_enterFrameHandler);
		this._soundChannel.stop();
		this._soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, soundChannel_soundCompleteHandler);
		this._soundChannel = null;
	}

	/**
	 * @private
	 */
	override private function seekMedia(seconds:Float):Void
	{
		this.pauseMedia();
		this._currentTime = seconds;
		if(this._isPlaying)
		{
			this.playMedia();
		}
	}

	/**
	 * @private
	 */
	private function handleSoundComplete():Void
	{
		//return to the beginning
		this.stop();
		this.dispatchEventWith(Event.COMPLETE);
		if(this._loop)
		{
			this.play();
		}
	}

	/**
	 * @private
	 */
	private function loadSourceFromURL(url:String):Void
	{
		this.loadSourceFromURLRequest(new URLRequest(url));
	}

	/**
	 * @private
	 */
	private function loadSourceFromURLRequest(request:URLRequest):Void
	{
		this._isLoading = true;
		if(this._sound != null)
		{
			this._sound.removeEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
			this._sound.removeEventListener(ProgressEvent.PROGRESS, sound_progressHandler);
			this._sound.removeEventListener(Event.COMPLETE, sound_completeHandler);
			this._sound = null;
		}
		this._sound = new Sound();
		this._sound.addEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
		this._sound.addEventListener(ProgressEvent.PROGRESS, sound_progressHandler);
		this._sound.addEventListener(Event.COMPLETE, sound_completeHandler);
		this._sound.load(request);
	}

	/**
	 * @private
	 */
	private function soundPlayer_enterFrameHandler(event:Event):Void
	{
		this._currentTime = this._soundChannel.position / 1000;
		this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
	}

	/**
	 * @private
	 * This isn't when the sound finishes playing. It's when the sound has
	 * finished loading.
	 */
	private function sound_completeHandler(event:flash.events.Event):Void
	{
		this._totalTime = this._sound.length / 1000;
		this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
		this._isLoading = false;
		this._isLoaded = true;
		this.dispatchEventWith(MediaPlayerEventType.LOAD_COMPLETE);
	}

	/**
	 * @private
	 */
	private function sound_progressHandler(event:ProgressEvent):Void
	{
		var oldTotalTime:Float = this._totalTime;
		this._totalTime = this._sound.length / 1000;
		if(oldTotalTime != this._totalTime)
		{
			this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
		}
		this.dispatchEventWith(MediaPlayerEventType.LOAD_PROGRESS, false, event.bytesLoaded / event.bytesTotal);
	}

	/**
	 * @private
	 */
	private function sound_errorHandler(event:ErrorEvent):Void
	{
		//since it's just a string in both cases, we'll reuse event.type for
		//the Starling event.
		this.dispatchEventWith(event.type, false, event);
	}

	/**
	 * @private
	 */
	private function soundChannel_soundCompleteHandler(event:flash.events.Event):Void
	{
		this.handleSoundComplete();
	}
	
}
