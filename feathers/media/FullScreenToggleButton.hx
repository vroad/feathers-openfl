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

/**
 * A specialized toggle button that controls whether a media player is
 * displayed normally or in full-screen mode.
 * 
 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
 */
class FullScreenToggleButton extends ToggleButton implements IMediaPlayerControl
{
	/**
	 * The default <code>IStyleProvider</code> for all
	 * <code>FullScreenToggleButton</code> components.
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
		this.addEventListener(Event.TRIGGERED, fullScreenButton_triggeredHandler);
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return FullScreenToggleButton.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _mediaPlayer:VideoPlayer;

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
			this._mediaPlayer.removeEventListener(MediaPlayerEventType.DISPLAY_STATE_CHANGE, mediaPlayer_displayStageChangeHandler);
		}
		this._mediaPlayer = safe_cast(value, VideoPlayer);
		if(this._mediaPlayer != null)
		{
			this.isSelected = this._mediaPlayer.isFullScreen;
			this._mediaPlayer.addEventListener(MediaPlayerEventType.DISPLAY_STATE_CHANGE, mediaPlayer_displayStageChangeHandler);
		}
		return get_mediaPlayer();
	}
	
	/**
	 * @private
	 */
	private function fullScreenButton_triggeredHandler(event:Event):Void
	{
		this._mediaPlayer.toggleFullScreen();
	}
	
	/**
	 * @private
	 */
	private function mediaPlayer_displayStageChangeHandler(event:Event):Void
	{
		this.isSelected = this._mediaPlayer.isFullScreen;
	}
}
