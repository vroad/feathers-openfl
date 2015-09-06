/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media;
import feathers.controls.Slider;
import feathers.events.MediaPlayerEventType;
import feathers.skins.IStyleProvider;

import flash.media.SoundTransform;

import starling.events.Event;

import feathers.utils.type.SafeCast.safe_cast;
import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;

/**
 * A specialized slider that controls the volume of a media player that
 * plays audio content.
 *
 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
 */
class VolumeSlider extends Slider implements IMediaPlayerControl
{
	/**
	 * The slider's thumb may be dragged horizontally (on the x-axis).
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * The slider's thumb may be dragged vertically (on the y-axis).
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_VERTICAL:String = "vertical";

	/**
	 * The slider has only one track, that fills the full length of the
	 * slider. In this layout mode, the "minimum" track is displayed and
	 * fills the entire length of the slider. The maximum track will not
	 * exist.
	 *
	 * @see #trackLayoutMode
	 */
	inline public static var TRACK_LAYOUT_MODE_SINGLE:String = "single";

	/**
	 * The slider has two tracks, stretching to fill each side of the slider
	 * with the thumb in the middle. The tracks will be resized as the thumb
	 * moves. This layout mode is designed for sliders where the two sides
	 * of the track may be colored differently to show the value
	 * "filling up" as the slider is dragged.
	 *
	 * <p>Since the width and height of the tracks will change, consider
	 * using a special display object such as a <code>Scale9Image</code>,
	 * <code>Scale3Image</code> or a <code>TiledImage</code> that is
	 * designed to be resized dynamically.</p>
	 *
	 * @see #trackLayoutMode
	 * @see feathers.display.Scale9Image
	 * @see feathers.display.Scale3Image
	 * @see feathers.display.TiledImage
	 */
	inline public static var TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";

	/**
	 * The slider's track dimensions fill the full width and height of the
	 * slider.
	 *
	 * @see #trackScaleMode
	 */
	inline public static var TRACK_SCALE_MODE_EXACT_FIT:String = "exactFit";

	/**
	 * If the slider's direction is horizontal, the width of the track will
	 * fill the full width of the slider, and if the slider's direction is
	 * vertical, the height of the track will fill the full height of the
	 * slider. The other edge will not be scaled.
	 *
	 * @see #trackScaleMode
	 */
	inline public static var TRACK_SCALE_MODE_DIRECTIONAL:String = "directional";

	/**
	 * When the track is touched, the slider's thumb jumps directly to the
	 * touch position, and the slider's <code>value</code> property is
	 * updated to match as if the thumb were dragged to that position.
	 *
	 * @see #trackInteractionMode
	 */
	inline public static var TRACK_INTERACTION_MODE_TO_VALUE:String = "toValue";

	/**
	 * When the track is touched, the <code>value</code> is increased or
	 * decreased (depending on the location of the touch) by the value of
	 * the <code>page</code> property.
	 *
	 * @see #trackInteractionMode
	 */
	inline public static var TRACK_INTERACTION_MODE_BY_PAGE:String = "byPage";

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * minimum track.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-volume-slider-minimum-track";

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * maximum track.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-volume-slider-maximum-track";

	/**
	 * The default value added to the <code>styleNameList</code> of the thumb.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-volume-slider-thumb";
	
	/**
	 * The default <code>IStyleProvider</code> for all
	 * <code>VolumeSlider</code> components.
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
		this.thumbStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB;
		this.minimumTrackStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK;
		this.maximumTrackStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK;
		this.minimum = 0;
		this.maximum = 1;
		this.addEventListener(Event.CHANGE, volumeSlider_changeHandler);
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return VolumeSlider.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _ignoreChanges:Bool = false;

	/**
	 * @private
	 */
	private var _mediaPlayer:IAudioPlayer;

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
		this._mediaPlayer = safe_cast(value, IAudioPlayer);
		this.refreshVolumeFromMediaPlayer();
		if(this._mediaPlayer != null)
		{
			this._mediaPlayer.addEventListener(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE, mediaPlayer_soundTransformChangeHandler);
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_mediaPlayer();
	}

	/**
	 * @private
	 */
	private function refreshVolumeFromMediaPlayer():Void
	{
		var oldIgnoreChanges:Bool = this._ignoreChanges;
		this._ignoreChanges = true;
		if(this._mediaPlayer != null)
		{
			this.value = this._mediaPlayer.soundTransform.volume;
		}
		else
		{
			this.value = 0;
		}
		this._ignoreChanges = oldIgnoreChanges;
	}

	/**
	 * @private
	 */
	private function mediaPlayer_soundTransformChangeHandler(event:Event):Void
	{
		this.refreshVolumeFromMediaPlayer();
	}

	/**
	 * @private
	 */
	private function volumeSlider_changeHandler(event:Event):Void
	{
		if(this._mediaPlayer == null || this._ignoreChanges)
		{
			return;
		}
		var soundTransform:SoundTransform = this._mediaPlayer.soundTransform;
		soundTransform.volume = this._value;
		this._mediaPlayer.soundTransform = soundTransform;
	}
}
