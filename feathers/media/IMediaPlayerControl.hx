/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
/**
 * An interface for sub-components added to a media player.
 * 
 * @see feathers.media.IMediaPlayer
 * @see feathers.media.IAudioPlayer
 * @see feathers.media.IVideoPlayer
 */
interface IMediaPlayerControl
{
	/**
	 * The media player that this component controls.
	 */
	var mediaPlayer(get, set):IMediaPlayer;
	//function get_mediaPlayer():IMediaPlayer;

	/**
	 * @private
	 */
	//function set_mediaPlayer(value:IMediaPlayer):IMediaPlayer;
}
