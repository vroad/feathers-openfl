/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
import feathers.controls.ToggleButton;
import feathers.events.MediaPlayerEventType;
import feathers.skins.IStyleProvider;

import starling.events.Event;

import feathers.utils.type.SafeCast.safe_cast;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;

/**
 * A specialized toggle button that controls whether a media player is
 * playing or paused.
 *
 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
 */
class PlayPauseToggleButton extends ToggleButton implements IMediaPlayerControl
{
	/**
	 * An alternate style name to use with
	 * <code>PlayPauseToggleButton</code> to allow a theme to give it an
	 * appearance of an overlay above video. If a theme does not provide a
	 * style for an overlay play/pause button, the theme will automatically
	 * fall back to using the default play/pause button style.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the overlay play/pause style is applied
	 * to a button:</p>
	 *
	 * <listing version="3.0">
	 * var overlayButton:PlayPauseButton = new PlayPauseButton();
	 * overlayButton.styleNameList.add( PlayPauseButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON );
	 * player.addChild( overlayButton );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON:String = "feathers-overlay-play-pause-toggle-button";
	
	/**
	 * The default <code>IStyleProvider</code> for all
	 * <code>PlayPauseToggleButton</code> components.
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
		//we don't actually want this to toggle automatically. instead,
		//we'll update isSelected based on events dispatched by the media
		//player
		this.isToggle = false;
		this.addEventListener(Event.TRIGGERED, playPlayButton_triggeredHandler);
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return PlayPauseToggleButton.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _mediaPlayer:ITimedMediaPlayer;

	/**
	 * @inheritDoc
	 */
	public var mediaPlayer(get, set):IMediaPlayer;
	public function get_mediaPlayer():IMediaPlayer
	{
		return this._mediaPlayer;
	}

	/**
	 * @private
	 */
	public function set_mediaPlayer(value:IMediaPlayer):IMediaPlayer
	{
		if(this._mediaPlayer == value)
		{
			return get_mediaPlayer();
		}
		if(this._mediaPlayer != null)
		{
			this._mediaPlayer.removeEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChangeHandler);
		}
		this._mediaPlayer = safe_cast(value, ITimedMediaPlayer);
		this.refreshState();
		if(this._mediaPlayer != null)
		{
			this._mediaPlayer.addEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChangeHandler);
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_mediaPlayer();
	}

	/**
	 * @private
	 */
	private var _touchableWhenPlaying:Bool = true;

	/**
	 * Determines if the button may be touched when the media player is
	 * playing its content. In other words, this button will only work when
	 * the content is paused.
	 * 
	 * @default true
	 */
	public var touchableWhenPlaying(get, set):Bool;
	public function get_touchableWhenPlaying():Bool
	{
		return this._touchableWhenPlaying;
	}

	/**
	 * @private
	 */
	public function set_touchableWhenPlaying(value:Bool):Bool
	{
		if(this._touchableWhenPlaying == value)
		{
			return get_touchableWhenPlaying();
		}
		this._touchableWhenPlaying = value;
		return get_touchableWhenPlaying();
	}

	/**
	 * @private
	 */
	private function refreshState():Void
	{
		if(this._mediaPlayer == null)
		{
			this.isSelected = false;
			return;
		}
		this.isSelected = this._mediaPlayer.isPlaying;
		this.touchable = !this._isSelected || this._touchableWhenPlaying;
	}

	/**
	 * @private
	 */
	private function playPlayButton_triggeredHandler(event:Event):Void
	{
		this._mediaPlayer.togglePlayPause();
	}

	/**
	 * @private
	 */
	private function mediaPlayer_playbackStateChangeHandler(event:Event):Void
	{
		this.refreshState();
	}
}
