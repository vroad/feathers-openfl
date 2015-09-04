/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IFocusDisplayObject;
import feathers.core.PropertyProxy;
import feathers.events.ExclusiveTouch;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.utils.math.FeathersMathUtil.clamp;
import feathers.utils.math.FeathersMathUtil.roundToNearest;

import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import openfl.utils.Timer;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the slider's value changes.
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
 * @eventType starling.events.Event.CHANGE
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when the user starts dragging the slider's thumb or track.
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
 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
 *///[Event(name="beginInteraction",type="starling.events.Event")]

/**
 * Dispatched when the user stops dragging the slider's thumb or track.
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
 * @eventType feathers.events.FeathersEventType.END_INTERACTION
 *///[Event(name="endInteraction",type="starling.events.Event")]

/**
 * Select a value between a minimum and a maximum by dragging a thumb over
 * the bounds of a track. The slider's track is divided into two parts split
 * by the thumb.
 *
 * <p>The following example sets the slider's values and listens for when
 * when the value changes:</p>
 *
 * <listing version="3.0">
 * var slider:Slider = new Slider();
 * slider.minimum = 0;
 * slider.maximum = 100;
 * slider.step = 1;
 * slider.page = 10;
 * slider.value = 12;
 * slider.addEventListener( Event.CHANGE, slider_changeHandler );
 * this.addChild( slider );</listing>
 *
 * @see ../../../help/slider.html How to use the Feathers Slider component
 */
class Slider extends FeathersControl implements IDirectionalScrollBar implements IFocusDisplayObject
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY:String = "minimumTrackFactory";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY:String = "maximumTrackFactory";

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
	inline public static var DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-slider-minimum-track";

	/**
	 * DEPRECATED: Replaced by <code>Slider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Slider#DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK
	 */
	inline public static var DEFAULT_CHILD_NAME_MINIMUM_TRACK:String = DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK;

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * maximum track.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-slider-maximum-track";

	/**
	 * DEPRECATED: Replaced by <code>Slider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Slider#DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK
	 */
	inline public static var DEFAULT_CHILD_NAME_MAXIMUM_TRACK:String = DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK;

	/**
	 * The default value added to the <code>styleNameList</code> of the thumb.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-slider-thumb";

	/**
	 * DEPRECATED: Replaced by <code>Slider.DEFAULT_CHILD_STYLE_NAME_THUMB</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Slider#DEFAULT_CHILD_STYLE_NAME_THUMB
	 */
	inline public static var DEFAULT_CHILD_NAME_THUMB:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

	/**
	 * The default <code>IStyleProvider</code> for all <code>Slider</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * @private
	 */
	private static function defaultThumbFactory():Button
	{
		return new Button();
	}

	/**
	 * @private
	 */
	private static function defaultMinimumTrackFactory():Button
	{
		return new Button();
	}

	/**
	 * @private
	 */
	private static function defaultMaximumTrackFactory():Button
	{
		return new Button();
	}
	
	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.addEventListener(Event.REMOVED_FROM_STAGE, slider_removedFromStageHandler);
	}

	/**
	 * The value added to the <code>styleNameList</code> of the minimum
	 * track. This variable is <code>protected</code> so that sub-classes
	 * can customize the minimum track style name in their constructors
	 * instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK</code>.
	 *
	 * <p>To customize the minimum track style name without subclassing, see
	 * <code>customMinimumTrackStyleName</code>.</p>
	 *
	 * @see #customMinimumTrackStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var minimumTrackStyleName:String = DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK;

	/**
	 * DEPRECATED: Replaced by <code>minimumTrackStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #minimumTrackStyleName
	 */
	private function get_minimumTrackName():String
	{
		return this.minimumTrackStyleName;
	}

	/**
	 * @private
	 */
	private function set_minimumTrackName(value:String):String
	{
		this.minimumTrackStyleName = value;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the maximum
	 * track. This variable is <code>protected</code> so that sub-classes
	 * can customize the maximum track style name in their constructors
	 * instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK</code>.
	 *
	 * <p>To customize the maximum track style name without subclassing, see
	 * <code>customMaximumTrackStyleName</code>.</p>
	 *
	 * @see #customMaximumTrackStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var maximumTrackStyleName:String = DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK;

	/**
	 * DEPRECATED: Replaced by <code>maximumTrackStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #maximumTrackStyleName
	 */
	private function get_maximumTrackName():String
	{
		return this.maximumTrackStyleName;
	}

	/**
	 * @private
	 */
	private function set_maximumTrackName(value:String):String
	{
		this.maximumTrackStyleName = value;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the thumb. This
	 * variable is <code>private</code> so that sub-classes can customize
	 * the thumb style name in their constructors instead of using the
	 * default style name defined by <code>DEFAULT_CHILD_STYLE_NAME_THUMB</code>.
	 *
	 * <p>To customize the thumb style name without subclassing, see
	 * <code>customThumbStyleName</code>.</p>
	 *
	 * @see #customThumbStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var thumbStyleName:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

	/**
	 * DEPRECATED: Replaced by <code>thumbStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #thumbStyleName
	 */
	private function get_thumbName():String
	{
		return this.thumbStyleName;
	}

	/**
	 * @private
	 */
	private function set_thumbName(value:String):String
	{
		this.thumbStyleName = value;
	}

	/**
	 * The thumb sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #thumbFactory
	 * @see #createThumb()
	 */
	private var thumb:Button;
	
	/**
	 * The minimum track sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #minimumTrackFactory
	 * @see #createMinimumTrack()
	 */
	private var minimumTrack:Button;

	/**
	 * The maximum track sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #maximumTrackFactory
	 * @see #createMaximumTrack()
	 */
	private var maximumTrack:Button;

	/**
	 * @private
	 */
	private var minimumTrackOriginalWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var minimumTrackOriginalHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var maximumTrackOriginalWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var maximumTrackOriginalHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Slider.globalStyleProvider;
	}
	
	/**
	 * @private
	 */
	private var _direction:String = DIRECTION_HORIZONTAL;

	//[Inspectable(type="String",enumeration="horizontal,vertical")]
	/**
	 * Determines if the slider's thumb can be dragged horizontally or
	 * vertically. When this value changes, the slider's width and height
	 * values do not change automatically.
	 *
	 * <p>In the following example, the direction is changed to vertical:</p>
	 *
	 * <listing version="3.0">
	 * slider.direction = Slider.DIRECTION_VERTICAL;</listing>
	 *
	 * @default Slider.DIRECTION_HORIZONTAL
	 *
	 * @see #DIRECTION_HORIZONTAL
	 * @see #DIRECTION_VERTICAL
	 */
	public var direction(get, set):String;
	public function get_direction():String
	{
		return this._direction;
	}
	
	/**
	 * @private
	 */
	public function set_direction(value:String):String
	{
		if(this._direction == value)
		{
			return get_direction();
		}
		this._direction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
		this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
		this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		return get_direction();
	}
	
	/**
	 * @private
	 */
	private var _value:Float = 0;
	
	/**
	 * The value of the slider, between the minimum and maximum.
	 *
	 * <p>In the following example, the value is changed to 12:</p>
	 *
	 * <listing version="3.0">
	 * slider.minimum = 0;
	 * slider.maximum = 100;
	 * slider.step = 1;
	 * slider.page = 10
	 * slider.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #minimum
	 * @see #maximum
	 * @see #step
	 * @see #page
	 */
	public var value(get, set):Float;
	public function get_value():Float
	{
		return this._value;
	}
	
	/**
	 * @private
	 */
	public function set_value(newValue:Float):Float
	{
		if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
		{
			newValue = roundToNearest(newValue - this._minimum, this._step) + this._minimum;
		}
		newValue = clamp(newValue, this._minimum, this._maximum);
		if(this._value == newValue)
		{
			return get_value();
		}
		this._value = newValue;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		if(this.liveDragging || !this.isDragging)
		{
			this.dispatchEventWith(Event.CHANGE);
		}
		return get_value();
	}
	
	/**
	 * @private
	 */
	private var _minimum:Float = 0;
	
	/**
	 * The slider's value will not go lower than the minimum.
	 *
	 * <p>In the following example, the minimum is set to 0:</p>
	 *
	 * <listing version="3.0">
	 * slider.minimum = 0;
	 * slider.maximum = 100;
	 * slider.step = 1;
	 * slider.page = 10
	 * slider.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #value
	 * @see #maximum
	 */
	public var minimum(get, set):Float;
	public function get_minimum():Float
	{
		return this._minimum;
	}
	
	/**
	 * @private
	 */
	public function set_minimum(value:Float):Float
	{
		if(this._minimum == value)
		{
			return get_minimum();
		}
		this._minimum = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_minimum();
	}
	
	/**
	 * @private
	 */
	private var _maximum:Float = 0;
	
	/**
	 * The slider's value will not go higher than the maximum. The maximum
	 * is zero (<code>0</code>), by default, and it should almost always be
	 * changed to something more appropriate.
	 *
	 * <p>In the following example, the maximum is set to 100:</p>
	 *
	 * <listing version="3.0">
	 * slider.minimum = 0;
	 * slider.maximum = 100;
	 * slider.step = 1;
	 * slider.page = 10
	 * slider.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #value
	 * @see #minimum
	 */
	public var maximum(get, set):Float;
	public function get_maximum():Float
	{
		return this._maximum;
	}
	
	/**
	 * @private
	 */
	public function set_maximum(value:Float):Float
	{
		if(this._maximum == value)
		{
			return get_maximum();
		}
		this._maximum = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_maximum();
	}
	
	/**
	 * @private
	 */
	private var _step:Float = 0;
	
	/**
	 * As the slider's thumb is dragged, the value is snapped to a multiple
	 * of the step. Paging using the slider's track will use the <code>step</code>
	 * value if the <code>page</code> value is <code>NaN</code>. If the
	 * <code>step</code> is zero (<code>0</code>), paging with the track will not be possible.
	 *
	 * <p>In the following example, the step is changed to 1:</p>
	 *
	 * <listing version="3.0">
	 * slider.minimum = 0;
	 * slider.maximum = 100;
	 * slider.step = 1;
	 * slider.page = 10;
	 * slider.value = 10;</listing>
	 *
	 * @default 0
	 *
	 * @see #value
	 * @see #page
	 */
	public var step(get, set):Float;
	public function get_step():Float
	{
		return this._step;
	}
	
	/**
	 * @private
	 */
	public function set_step(value:Float):Float
	{
		if(this._step == value)
		{
			return get_step();
		}
		this._step = value;
		return get_step();
	}

	/**
	 * @private
	 */
	private var _page:Float = Math.NaN;

	/**
	 * If the <code>trackInteractionMode</code> property is set to
	 * <code>Slider.TRACK_INTERACTION_MODE_BY_PAGE</code>, and the slider's
	 * track is touched, and the thumb is shown, the slider value will be
	 * incremented or decremented by the page value.
	 *
	 * <p>If this value is <code>NaN</code>, the <code>step</code> value
	 * will be used instead. If the <code>step</code> value is zero, paging
	 * with the track is not possible.</p>
	 *
	 * <p>In the following example, the page is changed to 10:</p>
	 *
	 * <listing version="3.0">
	 * slider.minimum = 0;
	 * slider.maximum = 100;
	 * slider.step = 1;
	 * slider.page = 10
	 * slider.value = 12;</listing>
	 *
	 * @default NaN
	 *
	 * @see #value
	 * @see #page
	 * @see #trackInteractionMode
	 */
	public var page(get, set):Float;
	public function get_page():Float
	{
		return this._page;
	}

	/**
	 * @private
	 */
	public function set_page(value:Float):Float
	{
		if(this._page == value)
		{
			return get_page();
		}
		this._page = value;
		return get_page();
	}
	
	/**
	 * @private
	 */
	private var isDragging:Bool = false;
	
	/**
	 * Determines if the slider dispatches the <code>Event.CHANGE</code>
	 * event every time the thumb moves, or only once it stops moving.
	 *
	 * <p>In the following example, live dragging is disabled:</p>
	 *
	 * <listing version="3.0">
	 * slider.liveDragging = false;</listing>
	 *
	 * @default true
	 */
	public var liveDragging:Bool = true;
	
	/**
	 * @private
	 */
	private var _showThumb:Bool = true;
	
	/**
	 * Determines if the thumb should be displayed.
	 *
	 * <p>In the following example, the thumb is hidden:</p>
	 *
	 * <listing version="3.0">
	 * slider.showThumb = false;</listing>
	 *
	 * @default true
	 */
	public var showThumb(get, set):Bool;
	public function get_showThumb():Bool
	{
		return this._showThumb;
	}
	
	/**
	 * @private
	 */
	public function set_showThumb(value:Bool):Bool
	{
		if(this._showThumb == value)
		{
			return get_showThumb();
		}
		this._showThumb = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_showThumb();
	}

	/**
	 * @private
	 */
	private var _thumbOffset:Float = 0;

	/**
	 *
	 * Offsets the position of the thumb by a certain number of pixels in a
	 * direction perpendicular to the track. This does not affect the
	 * measurement of the slider. The slider will measure itself as if the
	 * thumb were not offset from its original position.
	 *
	 * <p>In the following example, the thumb is offset by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * slider.thumbOffset = 20;</listing>
	 *
	 * @default 0
	 */
	public function get_thumbOffset():Float
	{
		return this._thumbOffset;
	}

	/**
	 * @private
	 */
	public function set_thumbOffset(value:Float):Float
	{
		if(this._thumbOffset == value)
		{
			return;
		}
		this._thumbOffset = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _minimumPadding:Float = 0;

	/**
	 * The space, in pixels, between the minimum position of the thumb and
	 * the minimum edge of the track. May be negative to extend the range of
	 * the thumb.
	 *
	 * <p>In the following example, minimum padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * slider.minimumPadding = 20;</listing>
	 *
	 * @default 0
	 */
	public var minimumPadding(get, set):Float;
	public function get_minimumPadding():Float
	{
		return this._minimumPadding;
	}

	/**
	 * @private
	 */
	public function set_minimumPadding(value:Float):Float
	{
		if(this._minimumPadding == value)
		{
			return get_minimumPadding();
		}
		this._minimumPadding = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_minimumPadding();
	}

	/**
	 * @private
	 */
	private var _maximumPadding:Float = 0;

	/**
	 * The space, in pixels, between the maximum position of the thumb and
	 * the maximum edge of the track. May be negative to extend the range
	 * of the thumb.
	 *
	 * <p>In the following example, maximum padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * slider.maximumPadding = 20;</listing>
	 *
	 * @default 0
	 */
	public var maximumPadding(get, set):Float;
	public function get_maximumPadding():Float
	{
		return this._maximumPadding;
	}

	/**
	 * @private
	 */
	public function set_maximumPadding(value:Float):Float
	{
		if(this._maximumPadding == value)
		{
			return get_maximumPadding();
		}
		this._maximumPadding = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_maximumPadding();
	}

	/**
	 * @private
	 */
	private var _trackLayoutMode:String = TRACK_LAYOUT_MODE_SINGLE;

	//[Inspectable(type="String",enumeration="single,minMax")]
	/**
	 * Determines how the minimum and maximum track skins are positioned and
	 * sized.
	 *
	 * <p>In the following example, the slider is given two tracks:</p>
	 *
	 * <listing version="3.0">
	 * slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;</listing>
	 *
	 * @default Slider.TRACK_LAYOUT_MODE_SINGLE
	 *
	 * @see #TRACK_LAYOUT_MODE_SINGLE
	 * @see #TRACK_LAYOUT_MODE_MIN_MAX
	 */
	public var trackLayoutMode(get, set):String;
	public function get_trackLayoutMode():String
	{
		return this._trackLayoutMode;
	}

	/**
	 * @private
	 */
	public function set_trackLayoutMode(value:String):String
	{
		if(this._trackLayoutMode == value)
		{
			return get_trackLayoutMode();
		}
		this._trackLayoutMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_trackLayoutMode();
	}

	/**
	 * @private
	 */
	private var _trackScaleMode:String = TRACK_SCALE_MODE_DIRECTIONAL;

	//[Inspectable(type="String",enumeration="exactFit,directional")]
	/**
	 * Determines how the minimum and maximum track skins are positioned and
	 * sized.
	 *
	 * <p>In the following example, the slider's track layout is customized:</p>
	 *
	 * <listing version="3.0">
	 * slider.trackScaleMode = Slider.TRACK_SCALE_MODE_EXACT_FIT;</listing>
	 *
	 * @default Slider.TRACK_SCALE_MODE_DIRECTIONAL
	 *
	 * @see #TRACK_SCALE_MODE_DIRECTIONAL
	 * @see #TRACK_SCALE_MODE_EXACT_FIT
	 * @see #trackLayoutMode
	 */
	public var trackScaleMode(get, set):String;
	public function get_trackScaleMode():String
	{
		return this._trackScaleMode;
	}

	/**
	 * @private
	 */
	public function set_trackScaleMode(value:String):String
	{
		if(this._trackScaleMode == value)
		{
			return get_trackScaleMode();
		}
		this._trackScaleMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_trackScaleMode();
	}

	/**
	 * @private
	 */
	private var _trackInteractionMode:String = TRACK_INTERACTION_MODE_TO_VALUE;

	//[Inspectable(type="String",enumeration="toValue,byPage")]
	/**
	 * Determines how the slider's value changes when the track is touched.
	 *
	 * <p>If <code>showThumb</code> is set to <code>false</code>, the slider
	 * will always behave as if <code>trackInteractionMode</code> has been
	 * set to <code>Slider.TRACK_INTERACTION_MODE_TO_VALUE</code>. In other
	 * words, the value of <code>trackInteractionMode</code> may be ignored
	 * if the thumb is hidden.</p>
	 *
	 * <p>In the following example, the slider's track interaction is changed:</p>
	 *
	 * <listing version="3.0">
	 * slider.trackScaleMode = Slider.TRACK_INTERACTION_MODE_BY_PAGE;</listing>
	 *
	 * @default Slider.TRACK_INTERACTION_MODE_TO_VALUE
	 *
	 * @see #TRACK_INTERACTION_MODE_TO_VALUE
	 * @see #TRACK_INTERACTION_MODE_BY_PAGE
	 * @see #page
	 */
	public var trackInteractionMode(get, set):String;
	public function get_trackInteractionMode():String
	{
		return this._trackInteractionMode;
	}

	/**
	 * @private
	 */
	public function set_trackInteractionMode(value:String):String
	{
		this._trackInteractionMode = value;
		return get_trackInteractionMode();
	}

	/**
	 * @private
	 */
	private var currentRepeatAction:Dynamic;

	/**
	 * @private
	 */
	private var _repeatTimer:Timer;

	/**
	 * @private
	 */
	private var _repeatDelay:Float = 0.05;

	/**
	 * The time, in seconds, before actions are repeated. The first repeat
	 * happens after a delay that is five times longer than the following
	 * repeats.
	 *
	 * <p>In the following example, the slider's repeat delay is set to
	 * 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * slider.repeatDelay = 0.5;</listing>
	 *
	 * @default 0.05
	 */
	public var repeatDelay(get, set):Float;
	public function get_repeatDelay():Float
	{
		return this._repeatDelay;
	}

	/**
	 * @private
	 */
	public function set_repeatDelay(value:Float):Float
	{
		if(this._repeatDelay == value)
		{
			return get_repeatDelay();
		}
		this._repeatDelay = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_repeatDelay();
	}

	/**
	 * @private
	 */
	private var _minimumTrackFactory:Void->Button;

	/**
	 * A function used to generate the slider's minimum track sub-component.
	 * The minimum track must be an instance of <code>Button</code>. This
	 * factory can be used to change properties on the minimum track when it
	 * is first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on the minimum track.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom minimum track factory is passed
	 * to the slider:</p>
	 *
	 * <listing version="3.0">
	 * slider.minimumTrackFactory = function():Button
	 * {
	 *     var track:Button = new Button();
	 *     track.defaultSkin = new Image( upTexture );
	 *     track.downSkin = new Image( downTexture );
	 *     return track;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #minimumTrackProperties
	 */
	public var minimumTrackFactory(get, set):Void->Button;
	public function get_minimumTrackFactory():Void->Button
	{
		return this._minimumTrackFactory;
	}

	/**
	 * @private
	 */
	public function set_minimumTrackFactory(value:Void->Button):Void->Button
	{
		if(this._minimumTrackFactory == value)
		{
			return get_minimumTrackFactory();
		}
		this._minimumTrackFactory = value;
		this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
		return get_minimumTrackFactory();
	}

	/**
	 * @private
	 */
	private var _customMinimumTrackStyleName:String;

	/**
	 * A style name to add to the slider's minimum track sub-component.
	 * Typically used by a theme to provide different styles to different
	 * sliders.
	 *
	 * <p>In the following example, a custom minimum track style name is
	 * passed to the slider:</p>
	 *
	 * <listing version="3.0">
	 * slider.customMinimumTrackStyleName = "my-custom-minimum-track";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-minimum-track", setCustomMinimumTrackStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #minimumTrackFactory
	 * @see #minimumTrackProperties
	 */
	public function get_customMinimumTrackStyleName():String
	{
		return this._customMinimumTrackStyleName;
	}

	/**
	 * @private
	 */
	public function set_customMinimumTrackStyleName(value:String):String
	{
		if(this._customMinimumTrackStyleName == value)
		{
			return get_customMinimumTrackName();
		}
		this._customMinimumTrackStyleName = value;
		this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
		return get_customMinimumTrackName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customMinimumTrackStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customMinimumTrackStyleName
	 */
	public function get_customMinimumTrackName():String
	{
		return this.customMinimumTrackStyleName;
	}

	/**
	 * @private
	 */
	public function set_customMinimumTrackName(value:String):String
	{
		this.customMinimumTrackStyleName = value;
	}

	/**
	 * @private
	 */
	private var _minimumTrackProperties:PropertyProxy;

	/**
	 * An object that stores properties for the slider's "minimum" track,
	 * and the properties will be passed down to the "minimum" track when
	 * the slider validates. For a list of available properties, refer to
	 * <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>minimumTrackFactory</code> function
	 * instead of using <code>minimumTrackProperties</code> will result in
	 * better performance.</p>
	 *
	 * <p>In the following example, the slider's minimum track properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * slider.minimumTrackProperties.defaultSkin = new Image( upTexture );
	 * slider.minimumTrackProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 *
	 * @see #minimumTrackFactory
	 * @see feathers.controls.Button
	 */
	public var minimumTrackProperties(get, set):PropertyProxy;
	public function get_minimumTrackProperties():PropertyProxy
	{
		if(this._minimumTrackProperties == null)
		{
			this._minimumTrackProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._minimumTrackProperties;
	}

	/**
	 * @private
	 */
	public function set_minimumTrackProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._minimumTrackProperties == value)
		{
			return get_minimumTrackProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._minimumTrackProperties != null)
		{
			this._minimumTrackProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._minimumTrackProperties = value;
		if(this._minimumTrackProperties != null)
		{
			this._minimumTrackProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_minimumTrackProperties();
	}

	/**
	 * @private
	 */
	private var _maximumTrackFactory:Void->Button;

	/**
	 * A function used to generate the slider's maximum track sub-component.
	 * The maximum track must be an instance of <code>Button</code>.
	 * This factory can be used to change properties on the maximum track
	 * when it is first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on the maximum track.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom maximum track factory is passed
	 * to the slider:</p>
	 *
	 * <listing version="3.0">
	 * slider.maximumTrackFactory = function():Button
	 * {
	 *     var track:Button = new Button();
	 *     track.defaultSkin = new Image( upTexture );
	 *     track.downSkin = new Image( downTexture );
	 *     return track;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #maximumTrackProperties
	 */
	public var maximumTrackFactory(get, set):Void->Button;
	public function get_maximumTrackFactory():Void->Button
	{
		return this._maximumTrackFactory;
	}

	/**
	 * @private
	 */
	public function set_maximumTrackFactory(value:Void->Button):Void->Button
	{
		if(this._maximumTrackFactory == value)
		{
			return get_maximumTrackFactory();
		}
		this._maximumTrackFactory = value;
		this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
		return get_maximumTrackFactory();
	}

	/**
	 * @private
	 */
	private var _customMaximumTrackStyleName:String;

	/**
	 * A style name to add to the slider's maximum track sub-component.
	 * Typically used by a theme to provide different skins to different
	 * sliders.
	 *
	 * <p>In the following example, a custom maximum track style name is
	 * passed to the slider:</p>
	 *
	 * <listing version="3.0">
	 * slider.customMaximumTrackStyleName = "my-custom-maximum-track";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-maximum-track", setCustomMaximumTrackStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #maximumTrackFactory
	 * @see #maximumTrackProperties
	 */
	public function get_customMaximumTrackStyleName():String
	{
		return this._customMaximumTrackStyleName;
	}

	/**
	 * @private
	 */
	public function set_customMaximumTrackStyleName(value:String):String
	{
		if(this._customMaximumTrackStyleName == value)
		{
			return get_customMaximumTrackName();
		}
		this._customMaximumTrackStyleName = value;
		this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
		return get_customMaximumTrackName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customMaximumTrackStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customMaximumTrackStyleName
	 */
	public function get_customMaximumTrackName():String
	{
		return this.customMaximumTrackStyleName;
	}

	/**
	 * @private
	 */
	public function set_customMaximumTrackName(value:String):String
	{
		this.customMaximumTrackStyleName = value;
	}
	
	/**
	 * @private
	 */
	private var _maximumTrackProperties:PropertyProxy;
	
	/**
	 * An object that stores properties for the slider's "maximum" track,
	 * and the properties will be passed down to the "maximum" track when
	 * the slider validates. For a list of available properties, refer to
	 * <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>maximumTrackFactory</code> function
	 * instead of using <code>maximumTrackProperties</code> will result in
	 * better performance.</p>
	 *
	 * <p>In the following example, the slider's maximum track properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * slider.maximumTrackProperties.defaultSkin = new Image( upTexture );
	 * slider.maximumTrackProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 *
	 * @see #maximumTrackFactory
	 * @see feathers.controls.Button
	 */
	public var maximumTrackProperties(get, set):PropertyProxy;
	public function get_maximumTrackProperties():PropertyProxy
	{
		if(this._maximumTrackProperties == null)
		{
			this._maximumTrackProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._maximumTrackProperties;
	}
	
	/**
	 * @private
	 */
	public function set_maximumTrackProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._maximumTrackProperties == value)
		{
			return get_maximumTrackProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._maximumTrackProperties != null)
		{
			this._maximumTrackProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._maximumTrackProperties = value;
		if(this._maximumTrackProperties != null)
		{
			this._maximumTrackProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_maximumTrackProperties();
	}

	/**
	 * @private
	 */
	private var _thumbFactory:Void->Button;

	/**
	 * A function used to generate the slider's thumb sub-component.
	 * The thumb must be an instance of <code>Button</code>. This factory
	 * can be used to change properties on the thumb when it is first
	 * created. For instance, if you are skinning Feathers components
	 * without a theme, you might use this factory to set skins and other
	 * styles on the thumb.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom thumb factory is passed
	 * to the slider:</p>
	 *
	 * <listing version="3.0">
	 * slider.thumbFactory = function():Button
	 * {
	 *     var thumb:Button = new Button();
	 *     thumb.defaultSkin = new Image( upTexture );
	 *     thumb.downSkin = new Image( downTexture );
	 *     return thumb;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #thumbProperties
	 */
	public var thumbFactory(get, set):Void->Button;
	public function get_thumbFactory():Void->Button
	{
		return this._thumbFactory;
	}

	/**
	 * @private
	 */
	public function set_thumbFactory(value:Void->Button):Void->Button
	{
		if(this._thumbFactory == value)
		{
			return get_thumbFactory();
		}
		this._thumbFactory = value;
		this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		return get_thumbFactory();
	}

	/**
	 * @private
	 */
	private var _customThumbStyleName:String;

	/**
	 * A style name to add to the slider's thumb sub-component. Typically
	 * used by a theme to provide different styles to different sliders.
	 *
	 * <p>In the following example, a custom thumb style name is passed
	 * to the slider:</p>
	 *
	 * <listing version="3.0">
	 * slider.customThumbStyleName = "my-custom-thumb";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-thumb", setCustomThumbStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_THUMB
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #thumbFactory
	 * @see #thumbProperties
	 */
	public function get_customThumbStyleName():String
	{
		return this._customThumbStyleName;
	}

	/**
	 * @private
	 */
	public function set_customThumbStyleName(value:String):String
	{
		if(this._customThumbStyleName == value)
		{
			return get_customThumbName();
		}
		this._customThumbStyleName = value;
		this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		return get_customThumbName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customThumbStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customThumbStyleName
	 */
	public function get_customThumbName():String
	{
		return this.customThumbStyleName;
	}

	/**
	 * @private
	 */
	public function set_customThumbName(value:String):String
	{
		this.customThumbStyleName = value;
	}
	
	/**
	 * @private
	 */
	private var _thumbProperties:PropertyProxy;
	
	/**
	 * An object that stores properties for the slider's thumb, and the
	 * properties will be passed down to the thumb when the slider
	 * validates. For a list of available properties, refer to
	 * <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>thumbFactory</code> function instead
	 * of using <code>thumbProperties</code> will result in better
	 * performance.</p>
	 *
	 * <p>In the following example, the slider's thumb properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * slider.thumbProperties.defaultSkin = new Image( upTexture );
	 * slider.thumbProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 * 
	 * @see feathers.controls.Button
	 * @see #thumbFactory
	 */
	public var thumbProperties(get, set):PropertyProxy;
	public function get_thumbProperties():PropertyProxy
	{
		if(this._thumbProperties == null)
		{
			this._thumbProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._thumbProperties;
	}
	
	/**
	 * @private
	 */
	public function set_thumbProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._thumbProperties == value)
		{
			return get_thumbProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._thumbProperties != null)
		{
			this._thumbProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._thumbProperties = value;
		if(this._thumbProperties != null)
		{
			this._thumbProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_thumbProperties();
	}

	/**
	 * @private
	 */
	private var _touchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _touchStartX:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _touchStartY:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _thumbStartX:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _thumbStartY:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _touchValue:Float;

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(this._value < this._minimum)
		{
			this.value = this._minimum;
		}
		else if(this._value > this._maximum)
		{
			this.value = this._maximum;
		}
	}
	
	/**
	 * @private
	 */
	override private function draw():Void
	{
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var focusInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_FOCUS);
		var layoutInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		var thumbFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
		var minimumTrackFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
		var maximumTrackFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);

		if(thumbFactoryInvalid)
		{
			this.createThumb();
		}

		if(minimumTrackFactoryInvalid)
		{
			this.createMinimumTrack();
		}

		if(maximumTrackFactoryInvalid || layoutInvalid)
		{
			this.createMaximumTrack();
		}

		if(thumbFactoryInvalid || stylesInvalid)
		{
			this.refreshThumbStyles();
		}
		if(minimumTrackFactoryInvalid || stylesInvalid)
		{
			this.refreshMinimumTrackStyles();
		}
		if((maximumTrackFactoryInvalid || layoutInvalid || stylesInvalid) && this.maximumTrack != null)
		{
			this.refreshMaximumTrackStyles();
		}
		
		if(thumbFactoryInvalid || stateInvalid)
		{
			this.thumb.isEnabled = this._isEnabled;
		}
		if(minimumTrackFactoryInvalid || stateInvalid)
		{
			this.minimumTrack.isEnabled = this._isEnabled;
		}
		if((maximumTrackFactoryInvalid || layoutInvalid || stateInvalid) && this.maximumTrack != null)
		{
			this.maximumTrack.isEnabled = this._isEnabled;
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layoutChildren();

		if(sizeInvalid || focusInvalid)
		{
			this.refreshFocusIndicator();
		}
	}

	/**
	 * If the component's dimensions have not been set explicitly, it will
	 * measure its content and determine an ideal size for itself. If the
	 * <code>explicitWidth</code> or <code>explicitHeight</code> member
	 * variables are set, those value will be used without additional
	 * measurement. If one is set, but not the other, the dimension with the
	 * explicit value will not be measured, but the other non-explicit
	 * dimension will still need measurement.
	 *
	 * <p>Calls <code>setSizeInternal()</code> to set up the
	 * <code>actualWidth</code> and <code>actualHeight</code> member
	 * variables used for layout.</p>
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function autoSizeIfNeeded():Bool
	{
		if(this.minimumTrackOriginalWidth != this.minimumTrackOriginalWidth || //isNaN
			this.minimumTrackOriginalHeight != this.minimumTrackOriginalHeight) //isNaN
		{
			this.minimumTrack.validate();
			this.minimumTrackOriginalWidth = this.minimumTrack.width;
			this.minimumTrackOriginalHeight = this.minimumTrack.height;
		}
		if(this.maximumTrack != null)
		{
			if(this.maximumTrackOriginalWidth != this.maximumTrackOriginalWidth || //isNaN
				this.maximumTrackOriginalHeight != this.maximumTrackOriginalHeight) //isNaN
			{
				this.maximumTrack.validate();
				this.maximumTrackOriginalWidth = this.maximumTrack.width;
				this.maximumTrackOriginalHeight = this.maximumTrack.height;
			}
		}

		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		this.thumb.validate();
		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				if(this.maximumTrack != null)
				{
					newWidth = Math.max(this.minimumTrackOriginalWidth, this.maximumTrackOriginalWidth);
				}
				else
				{
					newWidth = this.minimumTrackOriginalWidth;
				}
			}
			else //horizontal
			{
				if(this.maximumTrack != null)
				{
					newWidth = Math.min(this.minimumTrackOriginalWidth, this.maximumTrackOriginalWidth) + this.thumb.width / 2;
				}
				else
				{
					newWidth = this.minimumTrackOriginalWidth;
				}
			}
			newWidth = Math.max(newWidth, this.thumb.width);
		}
		if(needsHeight)
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				if(this.maximumTrack != null)
				{
					newHeight = Math.min(this.minimumTrackOriginalHeight, this.maximumTrackOriginalHeight) + this.thumb.height / 2;
				}
				else
				{
					newHeight = this.minimumTrackOriginalHeight;
				}
			}
			else //horizontal
			{
				if(this.maximumTrack != null)
				{
					newHeight = Math.max(this.minimumTrackOriginalHeight, this.maximumTrackOriginalHeight);
				}
				else
				{
					newHeight = this.minimumTrackOriginalHeight;
				}
			}
			newHeight = Math.max(newHeight, this.thumb.height);
		}
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates and adds the <code>thumb</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #thumb
	 * @see #thumbFactory
	 * @see #customThumbStyleName
	 */
	private function createThumb():Void
	{
		if(this.thumb != null)
		{
			this.thumb.removeFromParent(true);
			this.thumb = null;
		}

		var factory:Void->Button = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
		var thumbStyleName:String = this._customThumbStyleName != null ? this._customThumbStyleName : this.thumbStyleName;
		this.thumb = factory();
		this.thumb.styleNameList.add(thumbStyleName);
		this.thumb.keepDownStateOnRollOut = true;
		this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
		this.addChild(this.thumb);
	}

	/**
	 * Creates and adds the <code>minimumTrack</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #minimumTrack
	 * @see #minimumTrackFactory
	 * @see #customMinimumTrackStyleName
	 */
	private function createMinimumTrack():Void
	{
		if(this.minimumTrack != null)
		{
			this.minimumTrack.removeFromParent(true);
			this.minimumTrack = null;
		}

		var factory:Void->Button = this._minimumTrackFactory != null ? this._minimumTrackFactory : defaultMinimumTrackFactory;
		var minimumTrackStyleName:String = this._customMinimumTrackStyleName != null ? this._customMinimumTrackStyleName : this.minimumTrackStyleName;
		this.minimumTrack = factory();
		this.minimumTrack.styleNameList.add(minimumTrackStyleName);
		this.minimumTrack.keepDownStateOnRollOut = true;
		this.minimumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
		this.addChildAt(this.minimumTrack, 0);
	}

	/**
	 * Creates and adds the <code>maximumTrack</code> sub-component and
	 * removes the old instance, if one exists. If the maximum track is not
	 * needed, it will not be created.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #maximumTrack
	 * @see #maximumTrackFactory
	 * @see #customMaximumTrackStyleName
	 */
	private function createMaximumTrack():Void
	{
		if(this._trackLayoutMode == TRACK_LAYOUT_MODE_MIN_MAX)
		{
			if(this.maximumTrack != null)
			{
				this.maximumTrack.removeFromParent(true);
				this.maximumTrack = null;
			}
			var factory:Void->Button = this._maximumTrackFactory != null ? this._maximumTrackFactory : defaultMaximumTrackFactory;
			var maximumTrackStyleName:String = this._customMaximumTrackStyleName != null ? this._customMaximumTrackStyleName : this.maximumTrackStyleName;
			this.maximumTrack = factory();
			this.maximumTrack.styleNameList.add(maximumTrackStyleName);
			this.maximumTrack.keepDownStateOnRollOut = true;
			this.maximumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
			this.addChildAt(this.maximumTrack, 1);
		}
		else if(this.maximumTrack != null) //single
		{
			this.maximumTrack.removeFromParent(true);
			this.maximumTrack = null;
		}
	}
	
	/**
	 * @private
	 */
	private function refreshThumbStyles():Void
	{
		if (this._thumbProperties == null)
			return;
		for (propertyName in Reflect.fields(this._thumbProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._thumbProperties.storage, propertyName);
			Reflect.setProperty(this.thumb, propertyName, propertyValue);
		}
		this.thumb.visible = this._showThumb;
	}
	
	/**
	 * @private
	 */
	private function refreshMinimumTrackStyles():Void
	{
		if (this._minimumTrackProperties == null)
			return;
		for (propertyName in Reflect.fields(this._minimumTrackProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._minimumTrackProperties.storage, propertyName);
			Reflect.setProperty(this.minimumTrack, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function refreshMaximumTrackStyles():Void
	{
		if(this.maximumTrack == null || this._maximumTrackProperties == null)
		{
			return;
		}
		for (propertyName in Reflect.fields(this._maximumTrackProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._maximumTrackProperties.storage, propertyName);
			Reflect.setProperty(this.maximumTrack, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function layoutChildren():Void
	{
		this.layoutThumb();

		if(this._trackLayoutMode == TRACK_LAYOUT_MODE_MIN_MAX)
		{
			this.layoutTrackWithMinMax();
		}
		else //single
		{
			this.layoutTrackWithSingle();
		}
	}

	/**
	 * @private
	 */
	private function layoutThumb():Void
	{
		//this will auto-size the thumb, if needed
		this.thumb.validate();
		
		if(this._minimum == this._maximum)
		{
			var percentage:Float = 1;
		}
		else
		{
			percentage = (this._value - this._minimum) / (this._maximum - this._minimum);
			if(percentage < 0)
			{
				percentage = 0;
			}
			else if(percentage > 1)
			{
				percentage = 1;
			}
		}
		if(this._direction == DIRECTION_VERTICAL)
		{
			var trackScrollableHeight:Float = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
			this.thumb.x = Math.round((this.actualWidth - this.thumb.width) / 2) + this._thumbOffset;
			//maximum is at the top, so we need to start the y position of
			//the thumb from the maximum padding
			this.thumb.y = Math.round(this._maximumPadding + trackScrollableHeight * (1 - percentage));
		}
		else //horizontal
		{
			var trackScrollableWidth:Float = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
			//minimum is at the left, so we need to start the x position of
			//the thumb from the minimum padding
			this.thumb.x = Math.round(this._minimumPadding + (trackScrollableWidth * percentage));
			this.thumb.y = Math.round((this.actualHeight - this.thumb.height) / 2) + this._thumbOffset;
		}
	}

	/**
	 * @private
	 */
	private function layoutTrackWithMinMax():Void
	{
		if(this._direction == DIRECTION_VERTICAL)
		{
			this.maximumTrack.y = 0;
			this.maximumTrack.height = this.thumb.y + this.thumb.height / 2;
			this.minimumTrack.y = this.maximumTrack.height;
			this.minimumTrack.height = this.actualHeight - this.minimumTrack.y;

			if(this._trackScaleMode == TRACK_SCALE_MODE_DIRECTIONAL)
			{
				this.maximumTrack.width = Math.NaN;
				this.maximumTrack.validate();
				this.maximumTrack.x = (this.actualWidth - this.maximumTrack.width) / 2;
				this.minimumTrack.width = Math.NaN;
				this.minimumTrack.validate();
				this.minimumTrack.x = (this.actualWidth - this.minimumTrack.width) / 2;
			}
			else //exact fit
			{
				this.maximumTrack.x = 0;
				this.maximumTrack.width = this.actualWidth;
				this.minimumTrack.x = 0;
				this.minimumTrack.width = this.actualWidth;

				//final validation to avoid juggler next frame issues
				this.minimumTrack.validate();
				this.maximumTrack.validate();
			}
		}
		else //horizontal
		{
			this.minimumTrack.x = 0;
			this.minimumTrack.width = this.thumb.x + this.thumb.width / 2;
			this.maximumTrack.x = this.minimumTrack.width;
			this.maximumTrack.width = this.actualWidth - this.maximumTrack.x;

			if(this._trackScaleMode == TRACK_SCALE_MODE_DIRECTIONAL)
			{
				this.minimumTrack.height = Math.NaN;
				this.minimumTrack.validate();
				this.minimumTrack.y = (this.actualHeight - this.minimumTrack.height) / 2;
				this.maximumTrack.height = Math.NaN;
				this.maximumTrack.validate();
				this.maximumTrack.y = (this.actualHeight - this.maximumTrack.height) / 2;
			}
			else //exact fit
			{
				this.minimumTrack.y = 0;
				this.minimumTrack.height = this.actualHeight;
				this.maximumTrack.y = 0;
				this.maximumTrack.height = this.actualHeight;

				//final validation to avoid juggler next frame issues
				this.minimumTrack.validate();
				this.maximumTrack.validate();
			}
		}
	}

	/**
	 * @private
	 */
	private function layoutTrackWithSingle():Void
	{
		if(this._trackScaleMode == TRACK_SCALE_MODE_DIRECTIONAL)
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				this.minimumTrack.y = 0;
				this.minimumTrack.width = Math.NaN;
				this.minimumTrack.height = this.actualHeight;
				this.minimumTrack.validate();
				this.minimumTrack.x = (this.actualWidth - this.minimumTrack.width) / 2;
			}
			else //horizontal
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.width = this.actualWidth;
				this.minimumTrack.height = Math.NaN;
				this.minimumTrack.validate();
				this.minimumTrack.y = (this.actualHeight - this.minimumTrack.height) / 2;
			}
		}
		else //exact fit
		{
			this.minimumTrack.x = 0;
			this.minimumTrack.y = 0;
			this.minimumTrack.width = this.actualWidth;
			this.minimumTrack.height = this.actualHeight;

			//final validation to avoid juggler next frame issues
			this.minimumTrack.validate();
		}
	}

	/**
	 * @private
	 */
	private function locationToValue(location:Point):Float
	{
		var percentage:Float;
		if(this._direction == DIRECTION_VERTICAL)
		{
			var trackScrollableHeight:Float = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
			var yOffset:Float = location.y - this._touchStartY - this._maximumPadding;
			var yPosition:Float = Math.min(Math.max(0, this._thumbStartY + yOffset), trackScrollableHeight);
			percentage = 1 - (yPosition / trackScrollableHeight);
		}
		else //horizontal
		{
			var trackScrollableWidth:Float = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
			var xOffset:Float = location.x - this._touchStartX - this._minimumPadding;
			var xPosition:Float = Math.min(Math.max(0, this._thumbStartX + xOffset), trackScrollableWidth);
			percentage = xPosition / trackScrollableWidth;
		}

		return this._minimum + percentage * (this._maximum - this._minimum);
	}

	/**
	 * @private
	 */
	private function startRepeatTimer(action:Dynamic):Void
	{
		this.currentRepeatAction = action;
		if(this._repeatDelay > 0)
		{
			if(this._repeatTimer == null)
			{
				this._repeatTimer = new Timer(this._repeatDelay * 1000);
				this._repeatTimer.addEventListener(TimerEvent.TIMER, repeatTimer_timerHandler);
			}
			else
			{
				this._repeatTimer.reset();
				this._repeatTimer.delay = this._repeatDelay * 1000;
			}
			this._repeatTimer.start();
		}
	}

	/**
	 * @private
	 */
	private function adjustPage():Void
	{
		var page:Float = this._page;
		if(page != page) //isNaN
		{
			page = this._step;
		}
		if(this._touchValue < this._value)
		{
			this.value = Math.max(this._touchValue, this._value - page);
		}
		else if(this._touchValue > this._value)
		{
			this.value = Math.min(this._touchValue, this._value + page);
		}
	}

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function slider_removedFromStageHandler(event:Event):Void
	{
		this._touchPointID = -1;
		var wasDragging:Bool = this.isDragging;
		this.isDragging = false;
		if(wasDragging && !this.liveDragging)
		{
			this.dispatchEventWith(Event.CHANGE);
		}
	}

	/**
	 * @private
	 */
	override private function focusInHandler(event:Event):Void
	{
		super.focusInHandler(event);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
	}

	/**
	 * @private
	 */
	override private function focusOutHandler(event:Event):Void
	{
		super.focusOutHandler(event);
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
	}
	
	/**
	 * @private
	 */
	private function track_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._touchPointID = -1;
			return;
		}

		var track:DisplayObject = cast(event.currentTarget, DisplayObject);
		var touch:Touch;
		if(this._touchPointID >= 0)
		{
			touch = event.getTouch(track, null, this._touchPointID);
			if(touch == null)
			{
				return;
			}
			if(!this._showThumb && touch.phase == TouchPhase.MOVED)
			{
				touch.getLocation(this, HELPER_POINT);
				this.value = this.locationToValue(HELPER_POINT);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				if(this._repeatTimer != null)
				{
					this._repeatTimer.stop();
				}
				this._touchPointID = -1;
				this.isDragging = false;
				if(!this.liveDragging)
				{
					this.dispatchEventWith(Event.CHANGE);
				}
				this.dispatchEventWith(FeathersEventType.END_INTERACTION);
			}
		}
		else
		{
			touch = event.getTouch(track, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			touch.getLocation(this, HELPER_POINT);
			this._touchPointID = touch.id;
			if(this._direction == DIRECTION_VERTICAL)
			{
				this._thumbStartX = HELPER_POINT.x;
				this._thumbStartY = Math.min(this.actualHeight - this.thumb.height, Math.max(0, HELPER_POINT.y - this.thumb.height / 2));
			}
			else //horizontal
			{
				this._thumbStartX = Math.min(this.actualWidth - this.thumb.width, Math.max(0, HELPER_POINT.x - this.thumb.width / 2));
				this._thumbStartY = HELPER_POINT.y;
			}
			this._touchStartX = HELPER_POINT.x;
			this._touchStartY = HELPER_POINT.y;
			this._touchValue = this.locationToValue(HELPER_POINT);
			this.isDragging = true;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			if(this._showThumb && this._trackInteractionMode == TRACK_INTERACTION_MODE_BY_PAGE)
			{
				this.adjustPage();
				this.startRepeatTimer(this.adjustPage);
			}
			else
			{
				this.value = this._touchValue;
			}
		}
	}
	
	/**
	 * @private
	 */
	private function thumb_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._touchPointID = -1;
			return;
		}

		var touch:Touch;
		if(this._touchPointID >= 0)
		{
			touch = event.getTouch(this.thumb, null, this._touchPointID);
			if(touch == null)
			{
				return;
			}
			if(touch.phase == TouchPhase.MOVED)
			{
				var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
				var claim:DisplayObject = exclusiveTouch.getClaim(this._touchPointID);
				if(claim != this)
				{
					if(claim != null)
					{
						//already claimed by another display object
						return;
					}
					else
					{
						exclusiveTouch.claimTouch(this._touchPointID, this);
					}
				}
				touch.getLocation(this, HELPER_POINT);
				this.value = this.locationToValue(HELPER_POINT);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._touchPointID = -1;
				this.isDragging = false;
				if(!this.liveDragging)
				{
					this.dispatchEventWith(Event.CHANGE);
				}
				this.dispatchEventWith(FeathersEventType.END_INTERACTION);
			}
		}
		else
		{
			touch = event.getTouch(this.thumb, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			touch.getLocation(this, HELPER_POINT);
			this._touchPointID = touch.id;
			this._thumbStartX = this.thumb.x;
			this._thumbStartY = this.thumb.y;
			this._touchStartX = HELPER_POINT.x;
			this._touchStartY = HELPER_POINT.y;
			this.isDragging = true;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
		}
	}

	/**
	 * @private
	 */
	private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.keyCode == Keyboard.HOME)
		{
			this.value = this._minimum;
			return;
		}
		if(event.keyCode == Keyboard.END)
		{
			this.value = this._maximum;
			return;
		}
		var page:Float = this._page;
		if(page != page) //isNaN
		{
			page = this._step;
		}
		if(this._direction == Slider.DIRECTION_VERTICAL)
		{
			if(event.keyCode == Keyboard.UP)
			{
				if(event.shiftKey)
				{
					this.value += page;
				}
				else
				{
					this.value += this._step;
				}
			}
			else if(event.keyCode == Keyboard.DOWN)
			{
				if(event.shiftKey)
				{
					this.value -= page;
				}
				else
				{
					this.value -= this._step;
				}
			}
		}
		else
		{
			if(event.keyCode == Keyboard.LEFT)
			{
				if(event.shiftKey)
				{
					this.value -= page;
				}
				else
				{
					this.value -= this._step;
				}
			}
			else if(event.keyCode == Keyboard.RIGHT)
			{
				if(event.shiftKey)
				{
					this.value += page;
				}
				else
				{
					this.value += this._step;
				}
			}
		}
	}

	/**
	 * @private
	 */
	private function repeatTimer_timerHandler(event:TimerEvent):Void
	{
		var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
		var claim:DisplayObject = exclusiveTouch.getClaim(this._touchPointID);
		if(claim != null && claim != this)
		{
			return;
		}
		if(this._repeatTimer.currentCount < 5)
		{
			return;
		}
		this.currentRepeatAction();
	}
}