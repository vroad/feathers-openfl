/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.PropertyProxy;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.utils.math.FeathersMathUtil.clamp;
import feathers.utils.math.FeathersMathUtil.roundToNearest;

import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.utils.Timer;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the scroll bar's value changes.
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
 * Dispatched when the user starts interacting with the scroll bar's thumb,
 * track, or buttons.
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
 * Dispatched when the user stops interacting with the scroll bar's thumb,
 * track, or buttons.
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
 * a physical range or by using step buttons. This is a desktop-centric
 * scroll bar with many skinnable parts. For mobile, the
 * <code>SimpleScrollBar</code> is probably a better choice as it provides
 * only the thumb to indicate position without all the extra chrome.
 *
 * <p>The following example updates a list to use scroll bars:</p>
 *
 * <listing version="3.0">
 * list.horizontalScrollBarFactory = function():IScrollBar
 * {
 *     return new ScrollBar();
 * };
 * list.verticalScrollBarFactory = function():IScrollBar
 * {
 *     return new ScrollBar();
 * };</listing>
 *
 * @see ../../../help/scroll-bar.html How to use the Feathers ScrollBar component
 * @see feathers.controls.SimpleScrollBar
 */
class ScrollBar extends FeathersControl implements IDirectionalScrollBar
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
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY:String = "decrementButtonFactory";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY:String = "incrementButtonFactory";

	/**
	 * The scroll bar's thumb may be dragged horizontally (on the x-axis).
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * The scroll bar's thumb may be dragged vertically (on the y-axis).
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_VERTICAL:String = "vertical";

	/**
	 * The scroll bar has only one track, that fills the full length of the
	 * scroll bar. In this layout mode, the "minimum" track is displayed and
	 * fills the entire length of the scroll bar. The maximum track will not
	 * exist.
	 *
	 * @see #trackLayoutMode
	 */
	inline public static var TRACK_LAYOUT_MODE_SINGLE:String = "single";

	/**
	 * The scroll bar has two tracks, stretching to fill each side of the
	 * scroll bar with the thumb in the middle. The tracks will be resized
	 * as the thumb moves. This layout mode is designed for scroll bars
	 * where the two sides of the track may be colored differently to show
	 * the value "filling up" as the thumb is dragged or to highlight the
	 * track when it is triggered to scroll by a page instead of a step.
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
	 * The default value added to the <code>styleNameList</code> of the minimum
	 * track.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-scroll-bar-minimum-track";

	/**
	 * DEPRECATED: Replaced by <code>ScrollBar.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see ScrollBar#DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK
	 */
	inline public static var DEFAULT_CHILD_NAME_MINIMUM_TRACK:String = DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK;

	/**
	 * The default value added to the <code>styleNameList</code> of the maximum
	 * track.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-scroll-bar-maximum-track";

	/**
	 * DEPRECATED: Replaced by <code>ScrollBar.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see ScrollBar#DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK
	 */
	inline public static var DEFAULT_CHILD_NAME_MAXIMUM_TRACK:String = DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK;

	/**
	 * The default value added to the <code>styleNameList</code> of the thumb.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-scroll-bar-thumb";

	/**
	 * DEPRECATED: Replaced by <code>ScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see ScrollBar#DEFAULT_CHILD_STYLE_NAME_THUMB
	 */
	inline public static var DEFAULT_CHILD_NAME_THUMB:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

	/**
	 * The default value added to the <code>styleNameList</code> of the decrement
	 * button.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON:String = "feathers-scroll-bar-decrement-button";

	/**
	 * DEPRECATED: Replaced by <code>ScrollBar.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see ScrollBar#DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON
	 */
	inline public static var DEFAULT_CHILD_NAME_DECREMENT_BUTTON:String = DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON;

	/**
	 * The default value added to the <code>styleNameList</code> of the increment
	 * button.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON:String = "feathers-scroll-bar-increment-button";

	/**
	 * DEPRECATED: Replaced by <code>ScrollBar.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see ScrollBar#DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON
	 */
	inline public static var DEFAULT_CHILD_NAME_INCREMENT_BUTTON:String = DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON;

	/**
	 * The default <code>IStyleProvider</code> for all <code>ScrollBar</code>
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
	 * @private
	 */
	private static function defaultDecrementButtonFactory():Button
	{
		return new Button();
	}

	/**
	 * @private
	 */
	private static function defaultIncrementButtonFactory():Button
	{
		return new Button();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
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
	private var minimumTrackName(get, set):String;
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
		return get_minimumTrackName();
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
	private var maximumTrackName(get, set):String;
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
		return get_maximumTrackName();
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
	private var thumbName(get, set):String;
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
		return get_thumbName();
	}

	/**
	 * The value added to the <code>styleNameList</code> of the decrement
	 * button. This variable is <code>protected</code> so that sub-classes
	 * can customize the decrement button style name in their constructors
	 * instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON</code>.
	 *
	 * <p>To customize the decrement button style name without subclassing,
	 * see <code>customDecrementButtonStyleName</code>.</p>
	 *
	 * @see #customDecrementButtonStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var decrementButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON;

	/**
	 * DEPRECATED: Replaced by <code>decrementButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #decrementButtonStyleName
	 */
	private var decrementButtonName(get, set):String;
	private function get_decrementButtonName():String
	{
		return this.decrementButtonStyleName;
	}

	/**
	 * @private
	 */
	private function set_decrementButtonName(value:String):String
	{
		this.decrementButtonStyleName = value;
		return get_decrementButtonName();
	}

	/**
	 * The value added to the <code>styleNameList</code> of the increment
	 * button. This variable is <code>protected</code> so that sub-classes
	 * can customize the increment button style name in their constructors
	 * instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON</code>.
	 *
	 * <p>To customize the increment button style name without subclassing,
	 * see <code>customIncrementButtonName</code>.</p>
	 *
	 * @see #customIncrementButtonStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var incrementButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON;

	/**
	 * DEPRECATED: Replaced by <code>incrementButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #incrementButtonStyleName
	 */
	private var incrementButtonName(get, set):String;
	private function get_incrementButtonName():String
	{
		return this.incrementButtonStyleName;
	}

	/**
	 * @private
	 */
	private function set_incrementButtonName(value:String):String
	{
		this.incrementButtonStyleName = value;
		return get_incrementButtonName();
	}

	/**
	 * @private
	 */
	private var thumbOriginalWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var thumbOriginalHeight:Float = Math.NaN;

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
	 * The scroll bar's decrement button sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #decrementButtonFactory
	 * @see #createDecrementButton()
	 */
	private var decrementButton:Button;

	/**
	 * The scroll bar's increment button sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #incrementButtonFactory
	 * @see #createIncrementButton()
	 */
	private var incrementButton:Button;

	/**
	 * The scroll bar's thumb sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #thumbFactory
	 * @see #createThumb()
	 */
	private var thumb:Button;

	/**
	 * The scroll bar's minimum track sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #minimumTrackFactory
	 * @see #createMinimumTrack()
	 */
	private var minimumTrack:Button;

	/**
	 * The scroll bar's maximum track sub-component.
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
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ScrollBar.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _direction:String = DIRECTION_HORIZONTAL;

	//[Inspectable(type="String",enumeration="horizontal,vertical")]
	/**
	 * Determines if the scroll bar's thumb can be dragged horizontally or
	 * vertically. When this value changes, the scroll bar's width and
	 * height values do not change automatically.
	 *
	 * <p>In the following example, the direction is changed to vertical:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;</listing>
	 *
	 * @default ScrollBar.DIRECTION_HORIZONTAL
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
		this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
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
	 * @inheritDoc
	 *
	 * @default 0
	 *
	 * @see #minimum
	 * @see #maximum
	 * @see #step
	 * @see #page
	 * @see #event:change
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
	 * @inheritDoc
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
	 * @inheritDoc
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
	 * @inheritDoc
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
		this._step = value;
		return get_step();
	}

	/**
	 * @private
	 */
	private var _page:Float = 0;

	/**
	 * @inheritDoc
	 *
	 * <p>If this value is <code>0</code>, the <code>step</code> value
	 * will be used instead. If the <code>step</code> value is
	 * <code>0</code>, paging with the track is not possible.</p>
	 *
	 * @default 0
	 *
	 * @see #value
	 * @see #step
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_page();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.padding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #paddingTop
	 * @see #paddingRight
	 * @see #paddingBottom
	 * @see #paddingLeft
	 */
	public var padding(get, set):Float;
	public function get_padding():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_padding(value:Float):Float
	{
		this.paddingTop = value;
		this.paddingRight = value;
		this.paddingBottom = value;
		this.paddingLeft = value;
		return get_padding();
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, above the content, not
	 * including the track(s).
	 *
	 * <p>In the following example, the top padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.paddingTop = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingTop(get, set):Float;
	public function get_paddingTop():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_paddingTop(value:Float):Float
	{
		if(this._paddingTop == value)
		{
			return get_paddingTop();
		}
		this._paddingTop = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, to the right of the content, not
	 * including the track(s).
	 *
	 * <p>In the following example, the right padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.paddingRight = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingRight(get, set):Float;
	public function get_paddingRight():Float
	{
		return this._paddingRight;
	}

	/**
	 * @private
	 */
	public function set_paddingRight(value:Float):Float
	{
		if(this._paddingRight == value)
		{
			return get_paddingRight();
		}
		this._paddingRight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, below the content, not
	 * including the track(s).
	 *
	 * <p>In the following example, the bottom padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingBottom(get, set):Float;
	public function get_paddingBottom():Float
	{
		return this._paddingBottom;
	}

	/**
	 * @private
	 */
	public function set_paddingBottom(value:Float):Float
	{
		if(this._paddingBottom == value)
		{
			return get_paddingBottom();
		}
		this._paddingBottom = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, to the left of the content, not
	 * including the track(s).
	 *
	 * <p>In the following example, the left padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingLeft(get, set):Float;
	public function get_paddingLeft():Float
	{
		return this._paddingLeft;
	}

	/**
	 * @private
	 */
	public function set_paddingLeft(value:Float):Float
	{
		if(this._paddingLeft == value)
		{
			return get_paddingLeft();
		}
		this._paddingLeft = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
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
	 * <p>In the following example, the repeat delay is changed to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.repeatDelay = 0.5;</listing>
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
	private var isDragging:Bool = false;

	/**
	 * Determines if the scroll bar dispatches the <code>Event.CHANGE</code>
	 * event every time the thumb moves, or only once it stops moving.
	 *
	 * <p>In the following example, live dragging is disabled:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.liveDragging = false;</listing>
	 *
	 * @default true
	 */
	public var liveDragging:Bool = true;

	/**
	 * @private
	 */
	private var _trackLayoutMode:String = TRACK_LAYOUT_MODE_SINGLE;

	//[Inspectable(type="String",enumeration="single,minMax")]
	/**
	 * Determines how the minimum and maximum track skins are positioned and
	 * sized.
	 *
	 * <p>In the following example, the scroll bar is given two tracks:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX;</listing>
	 *
	 * @default ScrollBar.TRACK_LAYOUT_MODE_SINGLE
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_trackLayoutMode();
	}

	/**
	 * @private
	 */
	private var _minimumTrackFactory:Void->Button;

	/**
	 * A function used to generate the scroll bar's minimum track
	 * sub-component. The minimum track must be an instance of
	 * <code>Button</code>. This factory can be used to change properties on
	 * the minimum track when it is first created. For instance, if you
	 * are skinning Feathers components without a theme, you might use this
	 * factory to set skins and other styles on the minimum track.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom minimum track factory is passed
	 * to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.minimumTrackFactory = function():Button
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
	 * A style name to add to the scroll bar's minimum track sub-component.
	 * Typically used by a theme to provide different styles to different
	 * scroll bars.
	 *
	 * <p>In the following example, a custom minimum track style name is
	 * passed to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customMinimumTrackStyleName = "my-custom-minimum-track";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to provide
	 * different styles than the default:</p>
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
	public var customMinimumTrackStyleName(get, set):String;
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
	public var customMinimumTrackName(get, set):String;
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
		return get_customMinimumTrackName();
	}

	/**
	 * @private
	 */
	private var _minimumTrackProperties:PropertyProxy;

	/**
	 * An object that stores properties for the scroll bar's "minimum"
	 * track, and the properties will be passed down to the "minimum" track when
	 * the scroll bar validates. For a list of available properties, refer to
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
	 * <p>In the following example, the scroll bar's minimum track properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.minimumTrackProperties.defaultSkin = new Image( upTexture );
	 * scrollBar.minimumTrackProperties.downSkin = new Image( downTexture );</listing>
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
			this._minimumTrackProperties = new PropertyProxy(minimumTrackProperties_onChange);
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
			this._minimumTrackProperties.removeOnChangeCallback(minimumTrackProperties_onChange);
		}
		this._minimumTrackProperties = value;
		if(this._minimumTrackProperties != null)
		{
			this._minimumTrackProperties.addOnChangeCallback(minimumTrackProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_minimumTrackProperties();
	}

	/**
	 * @private
	 */
	private var _maximumTrackFactory:Void->Button;

	/**
	 * A function used to generate the scroll bar's maximum track
	 * sub-component. The maximum track must be an instance of
	 * <code>Button</code>. This factory can be used to change properties on
	 * the maximum track when it is first created. For instance, if you
	 * are skinning Feathers components without a theme, you might use this
	 * factory to set skins and other styles on the maximum track.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom maximum track factory is passed
	 * to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.maximumTrackFactory = function():Button
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
	 * A style name to add to the scroll bar's maximum track sub-component.
	 * Typically used by a theme to provide different styles to different
	 * scroll bars.
	 *
	 * <p>In the following example, a custom maximum track style name is
	 * passed to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customMaximumTrackStyleName = "my-custom-maximum-track";</listing>
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
	public var customMaximumTrackStyleName(get, set):String;
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
	public var customMaximumTrackName(get, set):String;
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
		return get_customMaximumTrackName();
	}

	/**
	 * @private
	 */
	private var _maximumTrackProperties:PropertyProxy;

	/**
	 * An object that stores properties for the scroll bar's "maximum"
	 * track, and the properties will be passed down to the "maximum" track when
	 * the scroll bar validates. For a list of available properties, refer to
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
	 * <p>In the following example, the scroll bar's maximum track properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.maximumTrackProperties.defaultSkin = new Image( upTexture );
	 * scrollBar.maximumTrackProperties.downSkin = new Image( downTexture );</listing>
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
			this._maximumTrackProperties = new PropertyProxy(maximumTrackProperties_onChange);
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
			this._maximumTrackProperties.removeOnChangeCallback(maximumTrackProperties_onChange);
		}
		this._maximumTrackProperties = value;
		if(this._maximumTrackProperties != null)
		{
			this._maximumTrackProperties.addOnChangeCallback(maximumTrackProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_maximumTrackProperties();
	}

	/**
	 * @private
	 */
	private var _thumbFactory:Void->Button;

	/**
	 * A function used to generate the scroll bar's thumb sub-component.
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
	 * to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.thumbFactory = function():Button
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
	 * A style name to add to the scroll bar's thumb sub-component.
	 * Typically used by a theme to provide different styles to different
	 * scroll bars.
	 *
	 * <p>In the following example, a custom thumb style name is passed
	 * to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customThumbStyleName = "my-custom-thumb";</listing>
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
	public var customThumbStyleName(get, set):String;
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
	public var customThumbName(get, set):String;
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
		return get_customThumbName();
	}

	/**
	 * @private
	 */
	private var _thumbProperties:PropertyProxy;

	/**
	 * An object that stores properties for the scroll bar's thumb, and the
	 * properties will be passed down to the thumb when the scroll bar
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
	 * <p>In the following example, the scroll bar's thumb properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.thumbProperties.defaultSkin = new Image( upTexture );
	 * scrollBar.thumbProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 *
	 * @see #thumbFactory
	 * @see feathers.controls.Button
	 */
	public var thumbProperties(get, set):PropertyProxy;
	public function get_thumbProperties():PropertyProxy
	{
		if(this._thumbProperties == null)
		{
			this._thumbProperties = new PropertyProxy(thumbProperties_onChange);
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
			this._thumbProperties.removeOnChangeCallback(thumbProperties_onChange);
		}
		this._thumbProperties = value;
		if(this._thumbProperties != null)
		{
			this._thumbProperties.addOnChangeCallback(thumbProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_thumbProperties();
	}

	/**
	 * @private
	 */
	private var _decrementButtonFactory:Void->Button;

	/**
	 * A function used to generate the scroll bar's decrement button
	 * sub-component. The decrement button must be an instance of
	 * <code>Button</code>. This factory can be used to change properties on
	 * the decrement button when it is first created. For instance, if you
	 * are skinning Feathers components without a theme, you might use this
	 * factory to set skins and other styles on the decrement button.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom decrement button factory is passed
	 * to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.decrementButtonFactory = function():Button
	 * {
	 *     var button:Button = new Button();
	 *     button.defaultSkin = new Image( upTexture );
	 *     button.downSkin = new Image( downTexture );
	 *     return button;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #decrementButtonProperties
	 */
	public var decrementButtonFactory(get, set):Void->Button;
	public function get_decrementButtonFactory():Void->Button
	{
		return this._decrementButtonFactory;
	}

	/**
	 * @private
	 */
	public function set_decrementButtonFactory(value:Void->Button):Void->Button
	{
		if(this._decrementButtonFactory == value)
		{
			return get_decrementButtonFactory();
		}
		this._decrementButtonFactory = value;
		this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		return get_decrementButtonFactory();
	}

	/**
	 * @private
	 */
	private var _customDecrementButtonStyleName:String;

	/**
	 * A style name to add to the scroll bar's decrement button
	 * sub-component. Typically used by a theme to provide different styles
	 * to different scroll bars.
	 *
	 * <p>In the following example, a custom decrement button style name is
	 * passed to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customDecrementButtonStyleName = "my-custom-decrement-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-decrement-button", setCustomDecrementButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #decrementButtonFactory
	 * @see #decrementButtonProperties
	 */
	public var customDecrementButtonStyleName(get, set):String;
	public function get_customDecrementButtonStyleName():String
	{
		return this._customDecrementButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customDecrementButtonStyleName(value:String):String
	{
		if(this._customDecrementButtonStyleName == value)
		{
			return get_customDecrementButtonName();
		}
		this._customDecrementButtonStyleName = value;
		this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		return get_customDecrementButtonName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customDecrementButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customDecrementButtonStyleName
	 */
	public var customDecrementButtonName(get, set):String;
	public function get_customDecrementButtonName():String
	{
		return this.customDecrementButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customDecrementButtonName(value:String):String
	{
		this.customDecrementButtonStyleName = value;
		return get_customDecrementButtonName();
	}

	/**
	 * @private
	 */
	private var _decrementButtonProperties:PropertyProxy;

	/**
	 * An object that stores properties for the scroll bar's decrement
	 * button, and the properties will be passed down to the decrement
	 * button when the scroll bar validates. For a list of available
	 * properties, refer to
	 * <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>decrementButtonFactory</code>
	 * function instead of using <code>decrementButtonProperties</code> will
	 * result in better performance.</p>
	 *
	 * <p>In the following example, the scroll bar's decrement button properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.decrementButtonProperties.defaultSkin = new Image( upTexture );
	 * scrollBar.decrementButtonProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 *
	 * @see #decrementButtonFactory
	 * @see feathers.controls.Button
	 */
	public var decrementButtonProperties(get, set):PropertyProxy;
	public function get_decrementButtonProperties():PropertyProxy
	{
		if(this._decrementButtonProperties == null)
		{
			this._decrementButtonProperties = new PropertyProxy(decrementButtonProperties_onChange);
		}
		return this._decrementButtonProperties;
	}

	/**
	 * @private
	 */
	public function set_decrementButtonProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._decrementButtonProperties == value)
		{
			return get_decrementButtonProperties();
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
		if(this._decrementButtonProperties != null)
		{
			this._decrementButtonProperties.removeOnChangeCallback(decrementButtonProperties_onChange);
		}
		this._decrementButtonProperties = value;
		if(this._decrementButtonProperties != null)
		{
			this._decrementButtonProperties.addOnChangeCallback(decrementButtonProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_decrementButtonProperties();
	}

	/**
	 * @private
	 */
	private var _incrementButtonFactory:Void->Button;

	/**
	 * A function used to generate the scroll bar's increment button
	 * sub-component. The increment button must be an instance of
	 * <code>Button</code>. This factory can be used to change properties on
	 * the increment button when it is first created. For instance, if you
	 * are skinning Feathers components without a theme, you might use this
	 * factory to set skins and other styles on the increment button.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom increment button factory is passed
	 * to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.incrementButtonFactory = function():Button
	 * {
	 *     var button:Button = new Button();
	 *     button.defaultSkin = new Image( upTexture );
	 *     button.downSkin = new Image( downTexture );
	 *     return button;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #incrementButtonProperties
	 */
	public var incrementButtonFactory(get, set):Void->Button;
	public function get_incrementButtonFactory():Void->Button
	{
		return this._incrementButtonFactory;
	}

	/**
	 * @private
	 */
	public function set_incrementButtonFactory(value:Void->Button):Void->Button
	{
		if(this._incrementButtonFactory == value)
		{
			return get_incrementButtonFactory();
		}
		this._incrementButtonFactory = value;
		this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		return get_incrementButtonFactory();
	}

	/**
	 * @private
	 */
	private var _customIncrementButtonStyleName:String;

	/**
	 * A style name to add to the scroll bar's increment button
	 * sub-component. Typically used by a theme to provide different styles
	 * to different scroll bars.
	 *
	 * <p>In the following example, a custom increment button style name is
	 * passed to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customIncrementButtonStyleName = "my-custom-increment-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-increment-button", setCustomIncrementButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #incrementButtonFactory
	 * @see #incrementButtonProperties
	 */
	public var customIncrementButtonStyleName(get, set):String;
	public function get_customIncrementButtonStyleName():String
	{
		return this._customIncrementButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customIncrementButtonStyleName(value:String):String
	{
		if(this._customIncrementButtonStyleName == value)
		{
			return get_customIncrementButtonName();
		}
		this._customIncrementButtonStyleName = value;
		this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		return get_customIncrementButtonName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customIncrementButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customIncrementButtonStyleName
	 */
	public var customIncrementButtonName(get, set):String;
	public function get_customIncrementButtonName():String
	{
		return this.customIncrementButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set_customIncrementButtonName(value:String):String
	{
		this.customIncrementButtonStyleName = value;
		return get_customIncrementButtonName();
	}

	/**
	 * @private
	 */
	private var _incrementButtonProperties:PropertyProxy;

	/**
	 * An object that stores properties for the scroll bar's increment
	 * button, and the properties will be passed down to the increment
	 * button when the scroll bar validates. For a list of available
	 * properties, refer to
	 * <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>incrementButtonFactory</code>
	 * function instead of using <code>incrementButtonProperties</code> will
	 * result in better performance.</p>
	 *
	 * <p>In the following example, the scroll bar's increment button properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.incrementButtonProperties.defaultSkin = new Image( upTexture );
	 * scrollBar.incrementButtonProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 *
	 * @see #incrementButtonFactory
	 * @see feathers.controls.Button
	 */
	public var incrementButtonProperties(get, set):PropertyProxy;
	public function get_incrementButtonProperties():PropertyProxy
	{
		if(this._incrementButtonProperties == null)
		{
			this._incrementButtonProperties = new PropertyProxy(incrementButtonProperties_onChange);
		}
		return this._incrementButtonProperties;
	}

	/**
	 * @private
	 */
	public function set_incrementButtonProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._incrementButtonProperties == value)
		{
			return get_incrementButtonProperties();
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
		if(this._incrementButtonProperties != null)
		{
			this._incrementButtonProperties.removeOnChangeCallback(incrementButtonProperties_onChange);
		}
		this._incrementButtonProperties = value;
		if(this._incrementButtonProperties != null)
		{
			this._incrementButtonProperties.addOnChangeCallback(incrementButtonProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_incrementButtonProperties();
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
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var layoutInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		var thumbFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
		var minimumTrackFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
		var maximumTrackFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
		var incrementButtonFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		var decrementButtonFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);

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
		if(decrementButtonFactoryInvalid)
		{
			this.createDecrementButton();
		}
		if(incrementButtonFactoryInvalid)
		{
			this.createIncrementButton();
		}

		if(thumbFactoryInvalid || stylesInvalid)
		{
			this.refreshThumbStyles();
		}
		if(minimumTrackFactoryInvalid || stylesInvalid)
		{
			this.refreshMinimumTrackStyles();
		}
		if((maximumTrackFactoryInvalid || stylesInvalid || layoutInvalid) && this.maximumTrack != null)
		{
			this.refreshMaximumTrackStyles();
		}
		if(decrementButtonFactoryInvalid || stylesInvalid)
		{
			this.refreshDecrementButtonStyles();
		}
		if(incrementButtonFactoryInvalid || stylesInvalid)
		{
			this.refreshIncrementButtonStyles();
		}

		var isEnabled:Bool = this._isEnabled && this._maximum > this._minimum;
		if(dataInvalid || stateInvalid || thumbFactoryInvalid)
		{
			this.thumb.isEnabled = isEnabled;
		}
		if(dataInvalid || stateInvalid || minimumTrackFactoryInvalid)
		{
			this.minimumTrack.isEnabled = isEnabled;
		}
		if((dataInvalid || stateInvalid || maximumTrackFactoryInvalid || layoutInvalid) && this.maximumTrack != null)
		{
			this.maximumTrack.isEnabled = isEnabled;
		}
		if(dataInvalid || stateInvalid || decrementButtonFactoryInvalid)
		{
			this.decrementButton.isEnabled = isEnabled;
		}
		if(dataInvalid || stateInvalid || incrementButtonFactoryInvalid)
		{
			this.incrementButton.isEnabled = isEnabled;
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layout();
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
		if(this.thumbOriginalWidth != this.thumbOriginalWidth || //isNaN
			this.thumbOriginalHeight != this.thumbOriginalHeight) //isNaN
		{
			this.thumb.validate();
			this.thumbOriginalWidth = this.thumb.width;
			this.thumbOriginalHeight = this.thumb.height;
		}
		this.decrementButton.validate();
		this.incrementButton.validate();

		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}

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
				newWidth += this.incrementButton.width + this.decrementButton.width;
			}
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
				newHeight += this.incrementButton.height + this.decrementButton.height;
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
		this.thumb.isFocusEnabled = false;
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
		this.minimumTrack.isFocusEnabled = false;
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
			this.maximumTrack.isFocusEnabled = false;
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
	 * Creates and adds the <code>decrementButton</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #decrementButton
	 * @see #decrementButtonFactory
	 * @see #customDecremenButtonStyleName
	 */
	private function createDecrementButton():Void
	{
		if(this.decrementButton != null)
		{
			this.decrementButton.removeFromParent(true);
			this.decrementButton = null;
		}

		var factory:Void->Button = this._decrementButtonFactory != null ? this._decrementButtonFactory : defaultDecrementButtonFactory;
		var decrementButtonStyleName:String = this._customDecrementButtonStyleName != null ? this._customDecrementButtonStyleName : this.decrementButtonStyleName;
		this.decrementButton = factory();
		this.decrementButton.styleNameList.add(decrementButtonStyleName);
		this.decrementButton.keepDownStateOnRollOut = true;
		this.decrementButton.isFocusEnabled = false;
		this.decrementButton.addEventListener(TouchEvent.TOUCH, decrementButton_touchHandler);
		this.addChild(this.decrementButton);
	}

	/**
	 * Creates and adds the <code>incrementButton</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #incrementButton
	 * @see #incrementButtonFactory
	 * @see #customIncrementButtonStyleName
	 */
	private function createIncrementButton():Void
	{
		if(this.incrementButton != null)
		{
			this.incrementButton.removeFromParent(true);
			this.incrementButton = null;
		}

		var factory:Void->Button = this._incrementButtonFactory != null ? this._incrementButtonFactory : defaultIncrementButtonFactory;
		var incrementButtonStyleName:String = this._customIncrementButtonStyleName != null ? this._customIncrementButtonStyleName : this.incrementButtonStyleName;
		this.incrementButton = factory();
		this.incrementButton.styleNameList.add(incrementButtonStyleName);
		this.incrementButton.keepDownStateOnRollOut = true;
		this.incrementButton.isFocusEnabled = false;
		this.incrementButton.addEventListener(TouchEvent.TOUCH, incrementButton_touchHandler);
		this.addChild(this.incrementButton);
	}

	/**
	 * @private
	 */
	private function refreshThumbStyles():Void
	{
		for (propertyName in Reflect.fields(this._thumbProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._thumbProperties.storage, propertyName);
			Reflect.setProperty(this.thumb, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function refreshMinimumTrackStyles():Void
	{
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
		if(this.maximumTrack == null)
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
	private function refreshDecrementButtonStyles():Void
	{
		for (propertyName in Reflect.fields(this._decrementButtonProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._decrementButtonProperties.storage, propertyName);
			Reflect.setProperty(this.decrementButton, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function refreshIncrementButtonStyles():Void
	{
		for (propertyName in Reflect.fields(this._incrementButtonProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._incrementButtonProperties.storage, propertyName);
			Reflect.setProperty(this.incrementButton, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function layout():Void
	{
		this.layoutStepButtons();
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
	private function layoutStepButtons():Void
	{
		if(this._direction == DIRECTION_VERTICAL)
		{
			this.decrementButton.x = (this.actualWidth - this.decrementButton.width) / 2;
			this.decrementButton.y = 0;
			this.incrementButton.x = (this.actualWidth - this.incrementButton.width) / 2;
			this.incrementButton.y = this.actualHeight - this.incrementButton.height;
		}
		else
		{
			this.decrementButton.x = 0;
			this.decrementButton.y = (this.actualHeight - this.decrementButton.height) / 2;
			this.incrementButton.x = this.actualWidth - this.incrementButton.width;
			this.incrementButton.y = (this.actualHeight - this.incrementButton.height) / 2;
		}
		var showButtons:Bool = this._maximum != this._minimum;
		this.decrementButton.visible = showButtons;
		this.incrementButton.visible = showButtons;
	}

	/**
	 * @private
	 */
	private function layoutThumb():Void
	{
		var range:Float = this._maximum - this._minimum;
		this.thumb.visible = range > 0 && range < Math.POSITIVE_INFINITY && this._isEnabled;
		if(!this.thumb.visible)
		{
			return;
		}

		//this will auto-size the thumb, if needed
		this.thumb.validate();

		var contentWidth:Float = this.actualWidth - this._paddingLeft - this._paddingRight;
		var contentHeight:Float = this.actualHeight - this._paddingTop - this._paddingBottom;
		var adjustedPage:Float = this._page;
		if(this._page == 0)
		{
			adjustedPage = this._step;
		}
		if(adjustedPage > range)
		{
			adjustedPage = range;
		}
		if(this._direction == DIRECTION_VERTICAL)
		{
			contentHeight -= (this.decrementButton.height + this.incrementButton.height);
			var thumbMinHeight:Float = this.thumb.minHeight > 0 ? this.thumb.minHeight : this.thumbOriginalHeight;
			this.thumb.width = this.thumbOriginalWidth;
			this.thumb.height = Math.max(thumbMinHeight, contentHeight * adjustedPage / range);
			var trackScrollableHeight:Float = contentHeight - this.thumb.height;
			this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
			this.thumb.y = this.decrementButton.height + this._paddingTop + Math.max(0, Math.min(trackScrollableHeight, trackScrollableHeight * (this._value - this._minimum) / range));
		}
		else //horizontal
		{
			contentWidth -= (this.decrementButton.width + this.decrementButton.width);
			var thumbMinWidth:Float = this.thumb.minWidth > 0 ? this.thumb.minWidth : this.thumbOriginalWidth;
			this.thumb.width = Math.max(thumbMinWidth, contentWidth * adjustedPage / range);
			this.thumb.height = this.thumbOriginalHeight;
			var trackScrollableWidth:Float = contentWidth - this.thumb.width;
			this.thumb.x = this.decrementButton.width + this._paddingLeft + Math.max(0, Math.min(trackScrollableWidth, trackScrollableWidth * (this._value - this._minimum) / range));
			this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
		}
	}

	/**
	 * @private
	 */
	private function layoutTrackWithMinMax():Void
	{
		var range:Float = this._maximum - this._minimum;
		this.minimumTrack.touchable = range > 0 && range < Math.POSITIVE_INFINITY;
		if(this.maximumTrack != null)
		{
			this.maximumTrack.touchable = range > 0 && range < Math.POSITIVE_INFINITY;
		}

		var showButtons:Bool = this._maximum != this._minimum;
		if(this._direction == DIRECTION_VERTICAL)
		{
			this.minimumTrack.x = 0;
			if(showButtons)
			{
				this.minimumTrack.y = this.decrementButton.height;
			}
			else
			{
				this.minimumTrack.y = 0;
			}
			this.minimumTrack.width = this.actualWidth;
			this.minimumTrack.height = (this.thumb.y + this.thumb.height / 2) - this.minimumTrack.y;

			this.maximumTrack.x = 0;
			this.maximumTrack.y = this.minimumTrack.y + this.minimumTrack.height;
			this.maximumTrack.width = this.actualWidth;
			if(showButtons)
			{
				this.maximumTrack.height = this.actualHeight - this.incrementButton.height - this.maximumTrack.y;
			}
			else
			{
				this.maximumTrack.height = this.actualHeight - this.maximumTrack.y;
			}
		}
		else //horizontal
		{
			if(showButtons)
			{
				this.minimumTrack.x = this.decrementButton.width;
			}
			else
			{
				this.minimumTrack.x = 0;
			}
			this.minimumTrack.y = 0;
			this.minimumTrack.width = (this.thumb.x + this.thumb.width / 2) - this.minimumTrack.x;
			this.minimumTrack.height = this.actualHeight;

			this.maximumTrack.x = this.minimumTrack.x + this.minimumTrack.width;
			this.maximumTrack.y = 0;
			if(showButtons)
			{
				this.maximumTrack.width = this.actualWidth - this.incrementButton.width - this.maximumTrack.x;
			}
			else
			{
				this.maximumTrack.width = this.actualWidth - this.maximumTrack.x;
			}
			this.maximumTrack.height = this.actualHeight;
		}

		//final validation to avoid juggler next frame issues
		this.minimumTrack.validate();
		this.maximumTrack.validate();
	}

	/**
	 * @private
	 */
	private function layoutTrackWithSingle():Void
	{
		var range:Float = this._maximum - this._minimum;
		this.minimumTrack.touchable = range > 0 && range < Math.POSITIVE_INFINITY;

		var showButtons:Bool = this._maximum != this._minimum;
		if(this._direction == DIRECTION_VERTICAL)
		{
			this.minimumTrack.x = 0;
			if(showButtons)
			{
				this.minimumTrack.y = this.decrementButton.height;
			}
			else
			{
				this.minimumTrack.y = 0;
			}
			this.minimumTrack.width = this.actualWidth;
			if(showButtons)
			{
				this.minimumTrack.height = this.actualHeight - this.minimumTrack.y - this.incrementButton.height;
			}
			else
			{
				this.minimumTrack.height = this.actualHeight - this.minimumTrack.y;
			}
		}
		else //horizontal
		{
			if(showButtons)
			{
				this.minimumTrack.x = this.decrementButton.width;
			}
			else
			{
				this.minimumTrack.x = 0;
			}
			this.minimumTrack.y = 0;
			if(showButtons)
			{
				this.minimumTrack.width = this.actualWidth - this.minimumTrack.x - this.incrementButton.width;
			}
			else
			{
				this.minimumTrack.width = this.actualWidth - this.minimumTrack.x;
			}
			this.minimumTrack.height = this.actualHeight;
		}

		//final validation to avoid juggler next frame issues
		this.minimumTrack.validate();
	}

	/**
	 * @private
	 */
	private function locationToValue(location:Point):Float
	{
		var percentage:Float = 0;
		if(this._direction == DIRECTION_VERTICAL)
		{
			var trackScrollableHeight:Float = this.actualHeight - this.thumb.height - this.decrementButton.height - this.incrementButton.height - this._paddingTop - this._paddingBottom;
			if(trackScrollableHeight > 0)
			{
				var yOffset:Float = location.y - this._touchStartY - this._paddingTop;
				var yPosition:Float = Math.min(Math.max(0, this._thumbStartY + yOffset - this.decrementButton.height), trackScrollableHeight);
				percentage = yPosition / trackScrollableHeight;
			}
		}
		else //horizontal
		{
			var trackScrollableWidth:Float = this.actualWidth - this.thumb.width - this.decrementButton.width - this.incrementButton.width - this._paddingLeft - this._paddingRight;
			if(trackScrollableWidth > 0)
			{
				var xOffset:Float = location.x - this._touchStartX - this._paddingLeft;
				var xPosition:Float = Math.min(Math.max(0, this._thumbStartX + xOffset - this.decrementButton.width), trackScrollableWidth);
				percentage = xPosition / trackScrollableWidth;
			}
		}

		return this._minimum + percentage * (this._maximum - this._minimum);
	}

	/**
	 * @private
	 */
	private function decrement():Void
	{
		this.value -= this._step;
	}

	/**
	 * @private
	 */
	private function increment():Void
	{
		this.value += this._step;
	}

	/**
	 * @private
	 */
	private function adjustPage():Void
	{
		var range:Float = this._maximum - this._minimum;
		var adjustedPage:Float = this._page;
		if(this._page == 0)
		{
			adjustedPage = this._step;
		}
		if(adjustedPage > range)
		{
			adjustedPage = range;
		}
		var newValue:Float;
		if(this._touchValue < this._value)
		{
			newValue = Math.max(this._touchValue, this._value - adjustedPage);
			if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
			{
				newValue = roundToNearest(newValue, this._step);
			}
			this.value = newValue;
		}
		else if(this._touchValue > this._value)
		{
			newValue = Math.min(this._touchValue, this._value + adjustedPage);
			if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
			{
				newValue = roundToNearest(newValue, this._step);
			}
			this.value = newValue;
		}
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
	private function thumbProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function minimumTrackProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function maximumTrackProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function decrementButtonProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function incrementButtonProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void
	{
		this._touchPointID = -1;
		if(this._repeatTimer != null)
		{
			this._repeatTimer.stop();
		}
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
			touch = event.getTouch(track, TouchPhase.ENDED, this._touchPointID);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = -1;
			this._repeatTimer.stop();
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
		}
		else
		{
			touch = event.getTouch(track, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = touch.id;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			touch.getLocation(this, HELPER_POINT);
			this._touchStartX = HELPER_POINT.x;
			this._touchStartY = HELPER_POINT.y;
			this._thumbStartX = HELPER_POINT.x;
			this._thumbStartY = HELPER_POINT.y;
			this._touchValue = this.locationToValue(HELPER_POINT);
			this.adjustPage();
			this.startRepeatTimer(this.adjustPage);
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
				touch.getLocation(this, HELPER_POINT);
				var newValue:Float = this.locationToValue(HELPER_POINT);
				if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
				{
					newValue = roundToNearest(newValue, this._step);
				}
				this.value = newValue;
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
	private function decrementButton_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._touchPointID = -1;
			return;
		}

		var touch:Touch;
		if(this._touchPointID >= 0)
		{
			touch = event.getTouch(this.decrementButton, TouchPhase.ENDED, this._touchPointID);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = -1;
			this._repeatTimer.stop();
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
		}
		else //if we get here, we don't have a saved touch ID yet
		{
			touch = event.getTouch(this.decrementButton, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = touch.id;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			this.decrement();
			this.startRepeatTimer(this.decrement);
		}
	}

	/**
	 * @private
	 */
	private function incrementButton_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._touchPointID = -1;
			return;
		}

		var touch:Touch;
		if(this._touchPointID >= 0)
		{
			touch = event.getTouch(this.incrementButton, TouchPhase.ENDED, this._touchPointID);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = -1;
			this._repeatTimer.stop();
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
		}
		else //if we get here, we don't have a saved touch ID yet
		{
			touch = event.getTouch(this.incrementButton, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = touch.id;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			this.increment();
			this.startRepeatTimer(this.increment);
		}
	}

	/**
	 * @private
	 */
	private function repeatTimer_timerHandler(event:TimerEvent):Void
	{
		if(this._repeatTimer.currentCount < 5)
		{
			return;
		}
		this.currentRepeatAction();
	}
}
