/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
import feathers.controls.LayoutGroup;
import feathers.core.PopUpManager;
import feathers.events.FeathersEventType;
import feathers.events.MediaPlayerEventType;
import feathers.skins.IStyleProvider;
#if 0
import feathers.utils.display.stageToStarling;
#else
import feathers.utils.display.FeathersDisplayUtil.stageToStarling;
#end

import flash.display.Stage;
import flash.display.StageDisplayState;
import flash.errors.IllegalOperationError;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.media.SoundTransform;
import flash.net.NetConnection;
import flash.net.NetStream;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.textures.Texture;

/**
 * Dispatched when the original native width or height of the video content
 * is calculated.
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
 * @see #nativeWidth
 * @see #nativeHeight
 *
 * @eventType feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
 */
#if 0
[Event(name="dimensionsChange",type="starling.events.Event")]
#end

/**
 * Dispatched when the media player changes to the full-screen display mode
 * or back to the normal display mode. The value of the
 * <code>isFullScreen</code> property indicates if the media player is
 * displayed in full screen mode or normally. 
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
 * @see #isFullScreen
 * @see #toggleFullScreen()
 *
 * @eventType feathers.events.MediaPlayerEventType.DISPLAY_STATE_CHANGE
 */
#if 0
[Event(name="displayStateChange",type="starling.events.Event")]
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
 * Dispatched when the video texture is ready to be rendered. Indicates that
 * the <code>texture</code> property will return a
 * <code>starling.textures.Texture</code> that may be displayed in an
 * <code>ImageLoader</code> or another component.
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
 *   dispatched by the <code>flash.net.NetStream</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 * 
 * @see #texture
 *
 * @eventType starling.events.Event.READY
 */
#if 0
[Event(name="ready",type="starling.events.Event")]
#end

/**
 * Dispatched when the <code>flash.net.NetStream</code> object dispatches
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
 *   dispatched by the <code>flash.net.NetStream</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html#event:ioError flash.net.NetStream: flash.events.IOErrorEvent.IO_ERROR
 *
 * @eventType starling.events.Event.IO_ERROR
 */
#if 0
[Event(name="ioError",type="starling.events.Event")]
#end

/**
 * Controls playback of video with a <code>flash.net.NetStream</code> object.
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
 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
 */
class VideoPlayer extends BaseTimedMediaPlayer implements IVideoPlayer
{
	/**
	 * @private
	 */
	inline private static var PLAY_STATUS_CODE_NETSTREAM_PLAY_COMPLETE:String = "NetStream.Play.Complete";
	/**
	 * @private
	 */
	inline private static var NET_STATUS_CODE_NETSTREAM_PLAY_STOP:String = "NetStream.Play.Stop";

	/**
	 * @private
	 */
	inline private static var NET_STATUS_CODE_NETSTREAM_PLAY_STREAMNOTFOUND:String = "NetStream.Play.StreamNotFound";

	/**
	 * @private
	 */
	inline private static var NET_STATUS_CODE_NETSTREAM_SEEK_NOTIFY:String = "NetStream.Seek.Notify";

	/**
	 * @private
	 */
	inline private static var NO_VIDEO_SOURCE_PLAY_ERROR:String = "Cannot play media when videoSource property has not been set.";

	/**
	 * @private
	 */
	inline private static var NO_VIDEO_SOURCE_PAUSE_ERROR:String = "Cannot pause media when videoSource property has not been set.";

	/**
	 * @private
	 */
	inline private static var NO_VIDEO_SOURCE_SEEK_ERROR:String = "Cannot seek media when videoSource property has not been set.";
	
	/**
	 * The default <code>IStyleProvider</code> for all
	 * <code>VideoPlayer</code> components.
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
		return VideoPlayer.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _fullScreenContainer:LayoutGroup;

	/**
	 * @private
	 */
	private var _ignoreDisplayListEvents:Bool = false;

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
	 * videoPlayer.soundTransform = new SoundTransform(0);</listing>
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
		if(this._netStream != null)
		{
			this._netStream.soundTransform = this._soundTransform;
		}
		this.dispatchEventWith(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE);
		return get_soundTransform();
	}

	/**
	 * @private
	 */
	private var _isWaitingForTextureReady:Bool = false;

	/**
	 * @private
	 */
	private var _texture:Texture;

	/**
	 * The texture used to display the video. This texture is not
	 * automatically rendered by the <code>VideoPlayer</code> component. A
	 * component like an <code>ImageLoader</code> should be added as a child
	 * of the <code>VideoPlayer</code> to display the texture when it is
	 * ready.
	 * 
	 * <p>The <code>texture</code> property will initially return
	 * <code>null</code>. Listen for <code>Event.READY</code> to know when
	 * a valid texture is available to render.</p>
	 * 
	 * <p>In the following example, a listener is added for
	 * <code>Event.READY</code>, and the texture is displayed by an
	 * <code>ImageLoader</code> component:</p>
	 * 
	 * <listing version="3.0">
	 * function videoPlayer_readyHandler( event:Event ):void
	 * {
	 * 	var view:ImageLoader = new ImageLoader();
	 * 	view.source = videoPlayer.texture;
	 * 	videoPlayer.addChildAt(view, 0);
	 * }
	 * 
	 * videoPlayer.addEventListener( Event.READY, videoPlayer_readyHandler );</listing>
	 * 
	 * @see #event:ready starling.events.Event.READY
	 * @see feathers.controls.ImageLoader
	 */
	public var texture(get, never):Texture;
	public function get_texture():Texture
	{
		//there can be runtime errors if the texture is rendered before it
		//is ready, so we must return null until we're sure it's safe
		if(this._isWaitingForTextureReady)
		{
			return null;
		}
		return this._texture;
	}

	/**
	 * @inheritDoc
	 *
	 * @see #event:dimensionsChange feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
	 */
	public var nativeWidth(get, never):Float;
	public function get_nativeWidth():Float
	{
		if(this._texture != null)
		{
			return this._texture.nativeWidth;
		}
		return 0;
	}

	/**
	 * @inheritDoc
	 *
	 * @see #event:dimensionsChange feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
	 */
	public var nativeHeight(get, never):Float;
	public function get_nativeHeight():Float
	{
		if(this._texture != null)
		{
			return this._texture.nativeHeight;
		}
		return 0;
	}

	/**
	 * @private
	 */
	private var _netConnection:NetConnection;

	/**
	 * @private
	 */
	private var _netStream:NetStream;

	/**
	 * The <code>flash.net.NetStream</code> object used to play the video.
	 * 
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html flash.net.NetStream
	 */
	public var netStream(get, never):NetStream;
	public function get_netStream():NetStream
	{
		return this._netStream;
	}

	/**
	 * @private
	 */
	private var _videoSource:String;

	/**
	 * A string representing the video URL or any other accepted value that
	 * may be passed to the <code>play()</code> function of a
	 * <code>NetStream</code> object.
	 * 
	 * <p>In the following example, a video file URL is passed in:</p>
	 * 
	 * <listing version="3.0">
	 * videoPlayer.videoSource = "http://example.com/video.m4v";</listing>
	 * 
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html#play() Full description of flash.net.NetStream.play() in Adobe's Flash Platform API Reference
	 */
	public var videoSource(get, set):String;
	public function get_videoSource():String
	{
		return this._videoSource;
	}

	/**
	 * @private
	 */
	public function set_videoSource(value:String):String
	{
		if(this._videoSource == value)
		{
			return get_videoSource();
		}
		if(this._isPlaying)
		{
			this.stop();
		}
		if(this._texture != null)
		{
			this._texture.dispose();
			this._texture = null;
		}
		if(value == null)
		{
			//if we're not playing anything, we shouldn't keep the NetStream
			//around in memory. if we're switching to something else, then
			//the NetStream can be reused.
			this.disposeNetStream();
		}
		this._videoSource = value;
		//reset the current and total time if we were playing a different
		//video previously
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
		if(this._autoPlay)
		{
			this.play();
		}
		return get_videoSource();
	}

	/**
	 * @private
	 */
	private var _autoPlay:Bool = true;

	/**
	 * Determines if the video starts playing immediately when the
	 * <code>videoSource</code> property is set.
	 *
	 * <p>In the following example, automatic playback is disabled:</p>
	 *
	 * <listing version="3.0">
	 * videoPlayer.autoPlay = false;</listing>
	 *
	 * @see #videoSource
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
	private var _isFullScreen:Bool = false;

	/**
	 * Indicates if the video player is currently full screen or not. When
	 * the player is full screen, it will be displayed as a modal pop-up
	 * that fills the entire Starling stage. Depending on the value of
	 * <code>fullScreenDisplayState</code>, it may also change the value of
	 * the native stage's <code>displayState</code> property.
	 * 
	 * @see #toggleFullScreen()
	 * @see #event:displayStateChange feathers.events.MediaPlayerEventType.DISPLAY_STATE_CHANGE
	 */
	public var isFullScreen(get, never):Bool;
	public function get_isFullScreen():Bool
	{
		return this._isFullScreen;
	}

	/**
	 * @private
	 */
	private var _normalDisplayState:StageDisplayState = StageDisplayState.NORMAL;

	#if 0
	[Inspectable(type="String",enumeration="fullScreenInteractive,fullScreen,normal")]
	#end
	/**
	 * When the video player is displayed normally (in other words, when it
	 * isn't full-screen), determines the value of the native stage's
	 * <code>displayState</code> property.
	 * 
	 * <p>Using this property, it is possible to set the native stage's
	 * <code>displayState</code> property to
	 * <code>StageDisplayState.FULL_SCREEN_INTERACTIVE</code> or
	 * <code>StageDisplayState.FULL_SCREEN</code> when the video player
	 * is not in full screen mode. This might be useful for mobile apps that
	 * should always display in full screen, while allowing a video player
	 * to toggle between filling the entire stage and displaying at a
	 * smaller size within its parent's layout.</p>
	 *
	 * <p>In the following example, the display state for normal mode
	 * is changed:</p>
	 *
	 * <listing version="3.0">
	 * videoPlayer.fullScreenDisplayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;</listing>
	 *
	 * @default StageDisplayState.NORMAL
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#FULL_SCREEN_INTERACTIVE StageDisplayState.FULL_SCREEN_INTERACTIVE
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#FULL_SCREEN StageDisplayState.FULL_SCREEN
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#NORMAL StageDisplayState.NORMAL
	 * @see #fullScreenDisplayState
	 */
	public var normalDisplayState(get, set):StageDisplayState;
	public function get_normalDisplayState():StageDisplayState
	{
		return this._normalDisplayState;
	}

	/**
	 * @private
	 */
	public function set_normalDisplayState(value:StageDisplayState):StageDisplayState
	{
		if(this._normalDisplayState == value)
		{
			return get_normalDisplayState();
		}
		this._normalDisplayState = value;
		if(!this._isFullScreen && this.stage != null)
		{
			var starling:Starling = stageToStarling(this.stage);
			var nativeStage:Stage = starling.nativeStage;
			nativeStage.displayState = this._normalDisplayState;
		}
		return get_normalDisplayState();
	}

	/**
	 * @private
	 */
	private var _fullScreenDisplayState:StageDisplayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

	#if 0
	[Inspectable(type="String",enumeration="fullScreenInteractive,fullScreen,normal")]
	#end
	/**
	 * When the video player is displayed full-screen, determines the value
	 * of the native stage's <code>displayState</code> property.
	 *
	 * <p>Using this property, it is possible to set the native stage's
	 * <code>displayState</code> property to
	 * <code>StageDisplayState.NORMAL</code> when the video player is in
	 * full screen mode. The video player will still be displayed as a modal
	 * pop-up that fills the entire Starling stage, in this situation.</p>
	 * 
	 * <p>In the following example, the display state for full-screen mode
	 * is changed:</p>
	 * 
	 * <listing version="3.0">
	 * videoPlayer.fullScreenDisplayState = StageDisplayState.FULL_SCREEN;</listing>
	 * 
	 * @default StageDisplayState.FULL_SCREEN_INTERACTIVE
	 * 
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#FULL_SCREEN_INTERACTIVE StageDisplayState.FULL_SCREEN_INTERACTIVE
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#FULL_SCREEN StageDisplayState.FULL_SCREEN
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#NORMAL StageDisplayState.NORMAL
	 * @see #normalDisplayState
	 */
	public var fullScreenDisplayState(get, set):StageDisplayState;
	public function get_fullScreenDisplayState():StageDisplayState
	{
		return this._fullScreenDisplayState;
	}

	/**
	 * @private
	 */
	public function set_fullScreenDisplayState(value:StageDisplayState):StageDisplayState
	{
		if(this._fullScreenDisplayState == value)
		{
			return get_fullScreenDisplayState();
		}
		this._fullScreenDisplayState = value;
		if(this._isFullScreen && this.stage != null)
		{
			var starling:Starling = stageToStarling(this.stage);
			var nativeStage:Stage = starling.nativeStage;
			nativeStage.displayState = this._fullScreenDisplayState;
		}
		return get_fullScreenDisplayState();
	}

	/**
	 * @private
	 */
	private var _hideRootWhenFullScreen:Bool = true;

	/**
	 * Determines if the Starling root display object is hidden when the
	 * video player switches to full screen mode. By hiding the root display
	 * object, rendering performance is optimized because Starling skips a
	 * portion of the display list that is obscured by the video player.
	 *
	 * <p>In the following example, the root display object isn't hidden
	 * when the video player is displayed in full screen:</p>
	 *
	 * <listing version="3.0">
	 * videoPlayer.hideRootWhenFullScreen = false;</listing>
	 *
	 * @default true
	 */
	public var hideRootWhenFullScreen(get, set):Bool;
	public function get_hideRootWhenFullScreen():Bool
	{
		return this._hideRootWhenFullScreen;
	}

	/**
	 * @private
	 */
	public function set_hideRootWhenFullScreen(value:Bool):Bool
	{
		this._hideRootWhenFullScreen = value;
		return get_hideRootWhenFullScreen();
	}

	/**
	 * @private
	 */
	override public function get_hasVisibleArea():Bool
	{
		if(this._isFullScreen)
		{
			return false;
		}
		return super.hasVisibleArea;
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this._texture != null)
		{
			this._texture.dispose();
			this._texture = null;
		}
		this.disposeNetStream();
		super.dispose();
	}

	/**
	 * Goes to full screen or returns to normal display.
	 * 
	 * <p> When the player is full screen, it will be displayed as a modal
	 * pop-up that fills the entire Starling stage. Depending on the value
	 * of <code>fullScreenDisplayState</code>, it may also change the value
	 * of the native stage's <code>displayState</code> property.</p>
	 * 
	 * <p>When the player is displaying normally (in other words, when it is
	 * not full screen), it will be displayed in its parent's layout like
	 * any other Feathers component.</p>
	 * 
	 * @see #isFullScreen
	 * @see #fullScreenDisplayState
	 * @see #normalDisplayState
	 * @see #event:displayStateChange feathers.events.MediaPlayerEventType.DISPLAY_STATE_CHANGE
	 */
	public function toggleFullScreen():Void
	{
		if(this.stage == null)
		{
			throw new IllegalOperationError("Cannot enter full screen mode if the video player does not have access to the Starling stage.");
		}
		var starling:Starling = stageToStarling(this.stage);
		var nativeStage:Stage = starling.nativeStage;
		var oldIgnoreDisplayListEvents:Bool = this._ignoreDisplayListEvents;
		this._ignoreDisplayListEvents = true;
		var childCount:Int;
		var child:DisplayObject;
		if(this._isFullScreen)
		{
			this.root.visible = true;
			PopUpManager.removePopUp(this._fullScreenContainer, false);
			childCount = this._fullScreenContainer.numChildren;
			//for(var i:Int = 0; i < childCount; i++)
			for(i in 0 ... childCount)
			{
				child = this._fullScreenContainer.getChildAt(0);
				this.addChild(child);
			}
			nativeStage.displayState = this._normalDisplayState;
		}
		else
		{
			if(this._hideRootWhenFullScreen)
			{
				this.root.visible = false;
			}
			nativeStage.displayState = this._fullScreenDisplayState;
			if(this._fullScreenContainer == null)
			{
				this._fullScreenContainer = new LayoutGroup();
				this._fullScreenContainer.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;
			}
			this._fullScreenContainer.layout = this._layout;
			childCount = this.numChildren;
			//for(i = 0; i < childCount; i++)
			for(i in 0 ... childCount)
			{
				child = this.getChildAt(0);
				this._fullScreenContainer.addChild(child);
			}
			PopUpManager.addPopUp(this._fullScreenContainer, true, false);
		}
		this._ignoreDisplayListEvents = oldIgnoreDisplayListEvents;
		this._isFullScreen = !this._isFullScreen;
		this.dispatchEventWith(MediaPlayerEventType.DISPLAY_STATE_CHANGE);
	}

	/**
	 * @private
	 */
	override private function playMedia():Void
	{
		if(this._videoSource == null)
		{
			throw new IllegalOperationError(NO_VIDEO_SOURCE_PLAY_ERROR);
		}
		if(this._netStream == null)
		{
			this._netConnection = new NetConnection();
			this._netConnection.connect(null);
			this._netStream = new NetStream(this._netConnection);
			this._netStream.client = new VideoPlayerNetStreamClient(this.netStream_onMetaData, this.netStream_onPlayStatus);
			this._netStream.addEventListener(NetStatusEvent.NET_STATUS, netStream_netStatusHandler);
			this._netStream.addEventListener(IOErrorEvent.IO_ERROR, netStream_ioErrorHandler);
		}
		if(this._soundTransform == null)
		{
			this._soundTransform = new SoundTransform();
		}
		this._netStream.soundTransform = this._soundTransform;
		if(this._texture != null)
		{
			this.addEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
			this._netStream.resume();
		}
		else
		{
			this._isWaitingForTextureReady = true;
			this._texture = Texture.fromNetStream(this._netStream, Starling.current.contentScaleFactor, videoTexture_onComplete);
			this._texture.root.onRestore = videoTexture_onRestore;
			//don't call play() until after Texture.fromNetStream() because
			//the texture needs to be created first.
			//however, we need to call play() even though a video texture
			//isn't ready to be rendered yet.
			this._netStream.play(this._videoSource);
		}
	}

	/**
	 * @private
	 */
	override private function pauseMedia():Void
	{
		if(this._videoSource == null)
		{
			throw new IllegalOperationError(NO_VIDEO_SOURCE_PAUSE_ERROR);
		}
		this.removeEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
		this._netStream.pause();
	}

	/**
	 * @private
	 */
	override private function seekMedia(seconds:Float):Void
	{
		if(this._videoSource == null)
		{
			throw new IllegalOperationError(NO_VIDEO_SOURCE_SEEK_ERROR);
		}
		this._currentTime = seconds;
		this._netStream.seek(seconds);
	}

	/**
	 * @private
	 */
	private function disposeNetStream():Void
	{
		if(this._netStream == null)
		{
			return;
		}
		this._netStream.removeEventListener(NetStatusEvent.NET_STATUS, netStream_netStatusHandler);
		this._netStream.removeEventListener(IOErrorEvent.IO_ERROR, netStream_ioErrorHandler);
		#if flash
		this._netStream.close();
		#end
		this._netStream = null;
		this._netConnection = null;
	}

	/**
	 * @private
	 */
	private function videoPlayer_enterFrameHandler(event:Event):Void
	{
		this._currentTime = this._netStream.time;
		this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
	}

	/**
	 * @private
	 */
	private function videoTexture_onRestore():Void
	{
		this.pauseMedia();
		this._isWaitingForTextureReady = true;
		this._texture.root.attachNetStream(this._netStream, videoTexture_onRestoreComplete);
		//this will start playback from the beginning again, but we can seek
		//back to the current time once the video texture is ready.
		this._netStream.play(this._videoSource);
	}

	/**
	 * @private
	 */
	private function videoTexture_onComplete():Void
	{
		this._isWaitingForTextureReady = false;
		//the texture is ready to be displayed
		this.dispatchEventWith(Event.READY);
		this.addEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
	}

	/**
	 * @private
	 */
	private function videoTexture_onRestoreComplete():Void
	{
		//seek back to the video's current time from when the context was
		//was lost. we couldn't seek when we started playing the video
		//again. we had to wait until this callback.
		this.seek(this._currentTime);
		if(!this._isPlaying)
		{
			this.pauseMedia();
		}
		this.videoTexture_onComplete();
	}

	/**
	 * @private
	 */
	private function netStream_onMetaData(metadata:Dynamic):Void
	{
		this.dispatchEventWith(MediaPlayerEventType.DIMENSIONS_CHANGE);
		this._totalTime = metadata.duration;
		this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
	}

	/**
	 * @private
	 */
	private function netStream_onPlayStatus(data:Dynamic):Void
	{
		var code:String = cast(data.code, String);
		switch(code)
		{
			case PLAY_STATUS_CODE_NETSTREAM_PLAY_COMPLETE:
			{
				//the video has reached the end
				if(this._isPlaying)
				{
					this.stop();
					this.dispatchEventWith(Event.COMPLETE);
				}
				//break;
			}
		}
	}

	/**
	 * @private
	 */
	private function netStream_ioErrorHandler(event:IOErrorEvent):Void
	{
		this.dispatchEventWith(event.type, false, event);
	}

	/**
	 * @private
	 */
	private function netStream_netStatusHandler(event:NetStatusEvent):Void
	{
		var code:String = event.info.code;
		switch(code)
		{
			case NET_STATUS_CODE_NETSTREAM_PLAY_STREAMNOTFOUND:
			{
				this.dispatchEventWith(FeathersEventType.ERROR, false, code);
				//break;
			}
			case NET_STATUS_CODE_NETSTREAM_PLAY_STOP:
			{
				//on iOS when context is lost, the NetStream will stop
				//automatically, and its time property will reset to 0.
				//we want to seek to the correct time after the texture is
				//restored, so we don't want _currentTime to get changed to
				//0 when the Event.ENTER_FRAME listener is called one last
				//time.
				this.removeEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
				//break;
			}
			case NET_STATUS_CODE_NETSTREAM_SEEK_NOTIFY:
			{
				if(this._isWaitingForTextureReady)
				{
					//ignore until the texture is ready because we might
					//be waiting to seek once the texture is ready, and this
					//will screw up our current time.
					return;
				}
				this._currentTime = this._netStream.time;
				this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
				//break;
			}
		}
	}

	/**
	 * @private
	 */
	override private function mediaPlayer_addedHandler(event:Event):Void
	{
		if(this._ignoreDisplayListEvents)
		{
			return;
		}
		super.mediaPlayer_addedHandler(event);
	}

	/**
	 * @private
	 */
	override private function mediaPlayer_removedHandler(event:Event):Void
	{
		if(this._ignoreDisplayListEvents)
		{
			return;
		}
		super.mediaPlayer_removedHandler(event);
	}
}

/*dynamic*/ class VideoPlayerNetStreamClient
{
	public function new(onMetaDataCallback:Dynamic->Void, onPlayStatusCallback:Dynamic->Void)
	{
		this.onMetaDataCallback = onMetaDataCallback;
		this.onPlayStatusCallback = onPlayStatusCallback;
	}

	public var onMetaDataCallback:Dynamic->Void;

	public function onMetaData(metadata:Dynamic):Void
	{
		this.onMetaDataCallback(metadata);
	}

	public var onPlayStatusCallback:Dynamic->Void;

	public function onPlayStatus(data:Dynamic):Void
	{
		if(this.onPlayStatusCallback != null)
		{
			this.onPlayStatusCallback(data);
		}
	}
}