/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.supportClasses.IViewPort;
import feathers.core.FeathersControl;
import feathers.core.IFocusDisplayObject;
import feathers.core.PropertyProxy;
import feathers.events.ExclusiveTouch;
import feathers.events.FeathersEventType;
import feathers.system.DeviceCapabilities;
import feathers.utils.math.FeathersMathUtil.roundDownToNearest;
import feathers.utils.math.FeathersMathUtil.roundToNearest;
import feathers.utils.math.FeathersMathUtil.roundUpToNearest;

import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.getTimer;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the scroller scrolls in either direction or when the view
 * port's scrolling bounds have changed. Listen for <code>FeathersEventType.SCROLL_START</code>
 * to know when scrolling starts as a result of user interaction or when
 * scrolling is triggered by an animation. Similarly, listen for
 * <code>FeathersEventType.SCROLL_COMPLETE</code> to know when the scrolling
 * ends.
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
 * @eventType starling.events.Event.SCROLL
 * @see #event:scrollStart feathers.events.FeathersEventType.SCROLL_START
 * @see #event:scrollComplete feathers.events.FeathersEventType.SCROLL_COMPLETE
 */
//[Event(name="scroll",type="starling.events.Event")]

/**
 * Dispatched when the scroller starts scrolling in either direction
 * as a result of either user interaction or animation.
 *
 * <p>Note: If <code>horizontalScrollPosition</code> or <code>verticalScrollPosition</code>
 * is set manually (in other words, the scrolling is not triggered by user
 * interaction or an animated scroll), no <code>FeathersEventType.SCROLL_START</code>
 * or <code>FeathersEventType.SCROLL_COMPLETE</code> events will be
 * dispatched.</p>
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
 * @eventType feathers.events.FeathersEventType.SCROLL_START
 * @see #event:scrollComplete feathers.events.FeathersEventType.SCROLL_COMPLETE
 * @see #event:scroll feathers.events.FeathersEventType.SCROLL
 */
//[Event(name="scrollStart",type="starling.events.Event")]

/**
 * Dispatched when the scroller finishes scrolling in either direction
 * as a result of either user interaction or animation. Animations may not
 * end at the same time that user interaction ends, so the event may be
 * delayed if user interaction triggers scrolling again.
 *
 * <p>Note: If <code>horizontalScrollPosition</code> or <code>verticalScrollPosition</code>
 * is set manually (in other words, the scrolling is not triggered by user
 * interaction or an animated scroll), no <code>FeathersEventType.SCROLL_START</code>
 * or <code>FeathersEventType.SCROLL_COMPLETE</code> events will be
 * dispatched.</p>
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
 * @eventType feathers.events.FeathersEventType.SCROLL_COMPLETE
 * @see #event:scrollStart feathers.events.FeathersEventType.SCROLL_START
 * @see #event:scroll feathers.events.FeathersEventType.SCROLL
 */
//[Event(name="scrollComplete",type="starling.events.Event")]

/**
 * Dispatched when the user starts dragging the scroller when
 * <code>INTERACTION_MODE_TOUCH</code> is enabled or when the user starts
 * interacting with the scroll bar.
 *
 * <p>Note: If <code>horizontalScrollPosition</code> or <code>verticalScrollPosition</code>
 * is set manually (in other words, the scrolling is not triggered by user
 * interaction), no <code>FeathersEventType.BEGIN_INTERACTION</code>
 * or <code>FeathersEventType.END_INTERACTION</code> events will be
 * dispatched.</p>
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
 * @see #event:endInteraction feathers.events.FeathersEventType.END_INTERACTION
 * @see #event:scroll feathers.events.FeathersEventType.SCROLL
 */
//[Event(name="beginInteraction",type="starling.events.Event")]

/**
 * Dispatched when the user stops dragging the scroller when
 * <code>INTERACTION_MODE_TOUCH</code> is enabled or when the user stops
 * interacting with the scroll bar. The scroller may continue scrolling
 * after this event is dispatched if the user interaction has also triggered
 * an animation.
 *
 * <p>Note: If <code>horizontalScrollPosition</code> or <code>verticalScrollPosition</code>
 * is set manually (in other words, the scrolling is not triggered by user
 * interaction), no <code>FeathersEventType.BEGIN_INTERACTION</code>
 * or <code>FeathersEventType.END_INTERACTION</code> events will be
 * dispatched.</p>
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
 * @see #event:beginInteraction feathers.events.FeathersEventType.BEGIN_INTERACTION
 * @see #event:scroll feathers.events.FeathersEventType.SCROLL
 */
//[Event(name="endInteraction",type="starling.events.Event")]

/**
 * Dispatched when the component receives focus.
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
 * @eventType feathers.events.FeathersEventType.FOCUS_IN
 */
[Event(name="focusIn",type="starling.events.Event")]

/**
 * Dispatched when the component loses focus.
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
 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
 */
[Event(name="focusOut",type="starling.events.Event")]

/**
 * Allows horizontal and vertical scrolling of a <em>view port</em>. Not
 * meant to be used as a standalone container or component. Generally meant
 * to be the super class of another component that needs to support
 * scrolling. To put components in a generic scrollable container (with
 * optional layout), see <code>ScrollContainer</code>. To scroll long
 * passages of text, see <code>ScrollText</code>.
 *
 * <p>This component is generally not instantiated directly. Instead it is
 * typically used as a super class for other scrolling components like lists
 * and containers. With that in mind, no code example is included here.</p>
 *
 * @see feathers.controls.ScrollContainer
 */
class Scroller extends FeathersControl implements IFocusDisplayObject
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String = "scrollBarRenderer";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_PENDING_SCROLL:String = "pendingScroll";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS:String = "pendingRevealScrollBars";

	/**
	 * The scroller may scroll if the view port is larger than the
	 * scroller's bounds. If the interaction mode is touch, the elastic
	 * edges will only be active if the maximum scroll position is greater
	 * than zero. If the scroll bar display mode is fixed, the scroll bar
	 * will only be visible when the maximum scroll position is greater than
	 * zero.
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_AUTO:String = "auto";

	/**
	 * The scroller will always scroll. If the interaction mode is touch,
	 * elastic edges will always be active, even when the maximum scroll
	 * position is zero. If the scroll bar display mode is fixed, the scroll
	 * bar will always be visible.
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_ON:String = "on";

	/**
	 * The scroller does not scroll at all. If the scroll bar display mode
	 * is fixed or float, the scroll bar will never be visible.
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_OFF:String = "off";

	/**
	 * The scroll bars appear above the scroller's view port, overlapping
	 * the content, and they fade out when not in use.
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

	/**
	 * The scroll bars are always visible and appear next to the scroller's
	 * view port, making the view port smaller than the scroller.
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

	/**
	 * The scroll bars appear above the scroller's view port, overlapping
	 * the content, but they do not fade out when not in use.
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT:String = "fixedFloat";

	/**
	 * The scroll bars are never visible.
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

	/**
	 * The vertical scroll bar will be positioned on the right.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

	/**
	 * The vertical scroll bar will be positioned on the left.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

	/**
	 * The user may touch anywhere on the scroller and drag to scroll. The
	 * scroll bars will be visual indicator of position, but they will not
	 * be interactive.
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH:String = "touch";

	/**
	 * The user may only interact with the scroll bars to scroll. The user
	 * cannot touch anywhere in the scroller's content and drag like a touch
	 * interface.
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_MOUSE:String = "mouse";

	/**
	 * The user may touch anywhere on the scroller and drag to scroll, and
	 * the scroll bars may be dragged separately. For most touch interfaces,
	 * this is not a common behavior. The scroll bar on touch interfaces is
	 * often simply a visual indicator and non-interactive.
	 *
	 * <p>One case where this mode might be used is a "scroll bar" that
	 * displays a tappable alphabetical index to navigate a
	 * <code>GroupedList</code> with alphabetical categories.</p>
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

	/**
	 * The scroller will scroll vertically when the mouse wheel is scrolled.
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

	/**
	 * The scroller will scroll horizontally when the mouse wheel is scrolled.
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * Flag to indicate that the clipping has changed.
	 */
	inline private static var INVALIDATION_FLAG_CLIPPING:String = "clipping";

	/**
	 * @private
	 * The point where we stop calculating velocity changes because floating
	 * point issues can start to appear.
	 */
	inline private static var MINIMUM_VELOCITY:Float = 0.02;

	/**
	 * @private
	 * The current velocity is given high importance.
	 */
	inline private static var CURRENT_VELOCITY_WEIGHT:Float = 2.33;

	/**
	 * @private
	 * Older saved velocities are given less importance.
	 */
	private static var VELOCITY_WEIGHTS:Array<Float> = [1, 1.33, 1.66, 2];

	/**
	 * @private
	 */
	inline private static var MAXIMUM_SAVED_VELOCITY_COUNT:Int = 4;

	/**
	 * The default deceleration rate per millisecond.
	 *
	 * @see #decelerationRate
	 */
	inline public static var DECELERATION_RATE_NORMAL:Float = 0.998;

	/**
	 * Decelerates a bit faster per millisecond than the default.
	 *
	 * @see #decelerationRate
	 */
	inline public static var DECELERATION_RATE_FAST:Float = 0.99;

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * horizontal scroll bar.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR:String = "feathers-scroller-horizontal-scroll-bar";

	/**
	 * DEPRECATED: Replaced by <code>Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Scroller#DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR
	 */
	inline public static var DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR:String = DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR;

	/**
	 * The default value added to the <code>styleNameList</code> of the vertical
	 * scroll bar.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR:String = "feathers-scroller-vertical-scroll-bar";

	/**
	 * DEPRECATED: Replaced by <code>Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Scroller#DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR
	 */
	inline public static var DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR:String = DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR;

	/**
	 * @private
	 */
	private static const FUZZY_PAGE_SIZE_PADDING:Number = 0.000001;

	/**
	 * @private
	 */
	private static function defaultScrollBarFactory():IScrollBar
	{
		return new SimpleScrollBar();
	}

	/**
	 * @private
	 */
	private static function defaultThrowEase(ratio:Number):Number
	{
		ratio -= 1;
		return 1 - ratio * ratio * ratio * ratio;
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();

		this.addEventListener(Event.ADDED_TO_STAGE, scroller_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, scroller_removedFromStageHandler);
	}

	/**
	 * The value added to the <code>styleNameList</code> of the horizontal
	 * scroll bar. This variable is <code>protected</code> so that
	 * sub-classes can customize the horizontal scroll bar style name in
	 * their constructors instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR</code>.
	 *
	 * <p>To customize the horizontal scroll bar style name without
	 * subclassing, see <code>customHorizontalScrollBarStyleName</code>.</p>
	 *
	 * @see #customHorizontalScrollBarStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var horizontalScrollBarStyleName:String = DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR;

	/**
	 * DEPRECATED: Replaced by <code>horizontalScrollBarStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #horizontalScrollBarStyleName
	 */
	private function get_horizontalScrollBarName():String
	{
		return this.horizontalScrollBarStyleName;
	}

	/**
	 * @private
	 */
	private function set_horizontalScrollBarName(value:String):String
	{
		this.horizontalScrollBarStyleName = value;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the vertical
	 * scroll bar. This variable is <code>protected</code> so that
	 * sub-classes can customize the vertical scroll bar style name in their
	 * constructors instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR</code>.
	 *
	 * <p>To customize the vertical scroll bar style name without
	 * subclassing, see <code>customVerticalScrollBarStyleName</code>.</p>
	 *
	 * @see #customVerticalScrollBarStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var verticalScrollBarStyleName:String = DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR;

	/**
	 * DEPRECATED: Replaced by <code>verticalScrollBarStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #verticalScrollBarStyleName
	 */
	private function get_verticalScrollBarName():String
	{
		return this.verticalScrollBarStyleName;
	}

	/**
	 * @private
	 */
	private function set_verticalScrollBarName(value:String):String
	{
		this.verticalScrollBarStyleName = value;
	}

	/**
	 * The horizontal scrollbar instance. May be null.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #horizontalScrollBarFactory
	 * @see #createScrollBars()
	 */
	private var horizontalScrollBar:IScrollBar;

	/**
	 * The vertical scrollbar instance. May be null.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #verticalScrollBarFactory
	 * @see #createScrollBars()
	 */
	private var verticalScrollBar:IScrollBar;

	/**
	 * @private
	 */
	override public function get_isFocusEnabled():Boolean
	{
		return (this._maxVerticalScrollPosition != this._minVerticalScrollPosition ||
			this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition) &&
			super.isFocusEnabled;
	}

	/**
	 * @private
	 */
	private var _topViewPortOffset:Number;

	/**
	 * @private
	 */
	private var _rightViewPortOffset:Float;

	/**
	 * @private
	 */
	private var _bottomViewPortOffset:Float;

	/**
	 * @private
	 */
	private var _leftViewPortOffset:Float;

	/**
	 * @private
	 */
	private var _hasHorizontalScrollBar:Bool = false;

	/**
	 * @private
	 */
	private var _hasVerticalScrollBar:Bool = false;

	/**
	 * @private
	 */
	private var _horizontalScrollBarTouchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _verticalScrollBarTouchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _touchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _startTouchX:Float;

	/**
	 * @private
	 */
	private var _startTouchY:Float;

	/**
	 * @private
	 */
	private var _startHorizontalScrollPosition:Float;

	/**
	 * @private
	 */
	private var _startVerticalScrollPosition:Float;

	/**
	 * @private
	 */
	private var _currentTouchX:Float;

	/**
	 * @private
	 */
	private var _currentTouchY:Float;

	/**
	 * @private
	 */
	private var _previousTouchTime:Int;

	/**
	 * @private
	 */
	private var _previousTouchX:Float;

	/**
	 * @private
	 */
	private var _previousTouchY:Float;

	/**
	 * @private
	 */
	private var _velocityX:Float = 0;

	/**
	 * @private
	 */
	private var _velocityY:Float = 0;

	/**
	 * @private
	 */
	private var _previousVelocityX:Array<Float> = new Array();

	/**
	 * @private
	 */
	private var _previousVelocityY:Array<Float> = new Array();

	/**
	 * @private
	 */
	private var _lastViewPortWidth:Float = 0;

	/**
	 * @private
	 */
	private var _lastViewPortHeight:Float = 0;

	/**
	 * @private
	 */
	private var _hasViewPortBoundsChanged:Bool = false;

	/**
	 * @private
	 */
	private var _horizontalAutoScrollTween:Tween;

	/**
	 * @private
	 */
	private var _verticalAutoScrollTween:Tween;

	/**
	 * @private
	 */
	private var _isDraggingHorizontally:Bool = false;

	/**
	 * @private
	 */
	private var _isDraggingVertically:Bool = false;

	/**
	 * @private
	 */
	private var ignoreViewPortResizing:Bool = false;

	/**
	 * @private
	 */
	private var _touchBlocker:Quad;

	/**
	 * @private
	 */
	private var _viewPort:IViewPort;

	/**
	 * The display object displayed and scrolled within the Scroller.
	 *
	 * @default null
	 */
	public var viewPort(get, set):IViewPort;
	public function get_viewPort():IViewPort
	{
		return this._viewPort;
	}

	/**
	 * @private
	 */
	public function set_viewPort(value:IViewPort):IViewPort
	{
		if(this._viewPort == value)
		{
			return get_viewPort();
		}
		if(this._viewPort != null)
		{
			this._viewPort.removeEventListener(FeathersEventType.RESIZE, viewPort_resizeHandler);
			this.removeRawChildInternal(cast(this._viewPort, DisplayObject));
		}
		this._viewPort = value;
		if(this._viewPort != null)
		{
			this._viewPort.addEventListener(FeathersEventType.RESIZE, viewPort_resizeHandler);
			this.addRawChildAtInternal(cast(this._viewPort, DisplayObject), 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_viewPort();
	}

	/**
	 * @private
	 */
	private var _measureViewPort:Bool = true;

	/**
	 * Determines if the dimensions of the view port are used when measuring
	 * the scroller. If disabled, only children other than the view port
	 * (such as the background skin) are used for measurement.
	 *
	 * <p>In the following example, the view port measurement is disabled:</p>
	 *
	 * <listing version="3.0">
	 * scroller.measureViewPort = false;</listing>
	 *
	 * @default true
	 */
	public var measureViewPort(get, set):Bool;
	public function get_measureViewPort():Bool
	{
		return this._measureViewPort;
	}

	/**
	 * @private
	 */
	public function set_measureViewPort(value:Bool):Bool
	{
		if(this._measureViewPort == value)
		{
			return get_measureViewPort();
		}
		this._measureViewPort = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_measureViewPort();
	}

	/**
	 * @private
	 */
	private var _snapToPages:Bool = false;

	/**
	 * Determines if scrolling will snap to the nearest page.
	 *
	 * <p>In the following example, the scroller snaps to the nearest page:</p>
	 *
	 * <listing version="3.0">
	 * scroller.snapToPages = true;</listing>
	 *
	 * @default false
	 */
	public var snapToPages(get, set):Bool;
	public function get_snapToPages():Bool
	{
		return this._snapToPages;
	}

	/**
	 * @private
	 */
	public function set_snapToPages(value:Bool):Bool
	{
		if(this._snapToPages == value)
		{
			return get_snapToPages();
		}
		this._snapToPages = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return get_snapToPages();
	}

	/**
	 * @private
	 */
	private var _snapOnComplete:Boolean = false;

	/**
	 * @private
	 */
	private var _horizontalScrollBarFactory:Function = defaultScrollBarFactory;

	/**
	 * Creates the horizontal scroll bar. The horizontal scroll bar must be
	 * an instance of <code>IScrollBar</code>. This factory can be used to
	 * change properties on the horizontal scroll bar when it is first
	 * created. For instance, if you are skinning Feathers components
	 * without a theme, you might use this factory to set skins and other
	 * styles on the horizontal scroll bar.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():IScrollBar</pre>
	 *
	 * <p>In the following example, a custom horizontal scroll bar factory
	 * is passed to the scroller:</p>
	 *
	 * <listing version="3.0">
	 * scroller.horizontalScrollBarFactory = function():IScrollBar
	 * {
	 *     return new ScrollBar();
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.IScrollBar
	 * @see #horizontalScrollBarProperties
	 */
	public var horizontalScrollBarFactory(get, set):Void->IScrollBar;
	public function get_horizontalScrollBarFactory():Void->IScrollBar
	{
		return this._horizontalScrollBarFactory;
	}

	/**
	 * @private
	 */
	public function set_horizontalScrollBarFactory(value:Void->IScrollBar):Void->IScrollBar
	{
		if(this._horizontalScrollBarFactory == value)
		{
			return get_horizontalScrollBarFactory();
		}
		this._horizontalScrollBarFactory = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		return get_horizontalScrollBarFactory();
	}

	/**
	 * @private
	 */
	private var _customHorizontalScrollBarStyleName:String;

	/**
	 * A style name to add to the container's horizontal scroll bar
	 * sub-component. Typically used by a theme to provide different styles
	 * to different containers.
	 *
	 * <p>In the following example, a custom horizontal scroll bar style
	 * name is passed to the scroller:</p>
	 *
	 * <listing version="3.0">
	 * scroller.customHorizontalScrollBarStyleName = "my-custom-horizontal-scroll-bar";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( SimpleScrollBar ).setFunctionForStyleName( "my-custom-horizontal-scroll-bar", setCustomHorizontalScrollBarStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #horizontalScrollBarFactory
	 * @see #horizontalScrollBarProperties
	 */
	public function get_customHorizontalScrollBarStyleName():String
	{
		return this._customHorizontalScrollBarStyleName;
	}

	/**
	 * @private
	 */
	public function set_customHorizontalScrollBarStyleName(value:String):String
	{
		if(this._customHorizontalScrollBarStyleName == value)
		{
			return get_customHorizontalScrollBarName();
		}
		this._customHorizontalScrollBarStyleName = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		return get_customHorizontalScrollBarName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customHorizontalScrollBarName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customHorizontalScrollBarName
	 */
	public function get_customHorizontalScrollBarName():String
	{
		return this.customHorizontalScrollBarStyleName;
	}

	/**
	 * @private
	 */
	public function set_customHorizontalScrollBarName(value:String):String
	{
		this.customHorizontalScrollBarStyleName = value;
	}

	/**
	 * @private
	 */
	private var _horizontalScrollBarProperties:PropertyProxy;

	/**
	 * An object that stores properties for the container's horizontal
	 * scroll bar, and the properties will be passed down to the horizontal
	 * scroll bar when the container validates. The available properties
	 * depend on which <code>IScrollBar</code> implementation is returned
	 * by <code>horizontalScrollBarFactory</code>. Refer to
	 * <a href="IScrollBar.html"><code>feathers.controls.IScrollBar</code></a>
	 * for a list of available scroll bar implementations.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>horizontalScrollBarFactory</code>
	 * function instead of using <code>horizontalScrollBarProperties</code>
	 * will result in better performance.</p>
	 *
	 * <p>In the following example, properties for the horizontal scroll bar
	 * are passed to the scroller:</p>
	 *
	 * <listing version="3.0">
	 * scroller.horizontalScrollBarProperties.liveDragging = false;</listing>
	 *
	 * @default null
	 *
	 * @see #horizontalScrollBarFactory
	 * @see feathers.controls.IScrollBar
	 * @see feathers.controls.SimpleScrollBar
	 * @see feathers.controls.ScrollBar
	 */
	public var horizontalScrollBarProperties(get, set):PropertyProxy;
	public function get_horizontalScrollBarProperties():PropertyProxy
	{
		if(this._horizontalScrollBarProperties == null)
		{
			this._horizontalScrollBarProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._horizontalScrollBarProperties;
	}

	/**
	 * @private
	 */
	public function set_horizontalScrollBarProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._horizontalScrollBarProperties == value)
		{
			return get_horizontalScrollBarProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!Std.is(value, PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for(propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._horizontalScrollBarProperties != null)
		{
			this._horizontalScrollBarProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._horizontalScrollBarProperties = value;
		if(this._horizontalScrollBarProperties != null)
		{
			this._horizontalScrollBarProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_horizontalScrollBarProperties();
	}

	/**
	 * @private
	 */
	private var _verticalScrollBarPosition:String = VERTICAL_SCROLL_BAR_POSITION_RIGHT;

	//[Inspectable(type="String",enumeration="right,left")]
	/**
	 * Determines where the vertical scroll bar will be positioned.
	 *
	 * <p>In the following example, the scroll bars is positioned on the left:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalScrollBarPosition = Scroller.VERTICAL_SCROLL_BAR_POSITION_LEFT;</listing>
	 *
	 * @default Scroller.VERTICAL_SCROLL_BAR_POSITION_RIGHT
	 *
	 * @see #VERTICAL_SCROLL_BAR_POSITION_RIGHT
	 * @see #VERTICAL_SCROLL_BAR_POSITION_LEFT
	 */
	public var verticalScrollBarPosition(get, set):String;
	public function get_verticalScrollBarPosition():String
	{
		return this._verticalScrollBarPosition;
	}

	/**
	 * @private
	 */
	public function set_verticalScrollBarPosition(value:String):String
	{
		if(this._verticalScrollBarPosition == value)
		{
			return get_verticalScrollBarPosition();
		}
		this._verticalScrollBarPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_verticalScrollBarPosition();
	}

	/**
	 * @private
	 */
	private var _verticalScrollBarFactory:Void->IScrollBar = defaultScrollBarFactory;

	/**
	 * Creates the vertical scroll bar. The vertical scroll bar must be an
	 * instance of <code>Button</code>. This factory can be used to change
	 * properties on the vertical scroll bar when it is first created. For
	 * instance, if you are skinning Feathers components without a theme,
	 * you might use this factory to set skins and other styles on the
	 * vertical scroll bar.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():IScrollBar</pre>
	 *
	 * <p>In the following example, a custom vertical scroll bar factory
	 * is passed to the scroller:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalScrollBarFactory = function():IScrollBar
	 * {
	 *     return new ScrollBar();
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.IScrollBar
	 * @see #verticalScrollBarProperties
	 */
	public var verticalScrollBarFactory(get, set):Void->IScrollBar;
	public function get_verticalScrollBarFactory():Void->IScrollBar
	{
		return this._verticalScrollBarFactory;
	}

	/**
	 * @private
	 */
	public function set_verticalScrollBarFactory(value:Void->IScrollBar):Void->IScrollBar
	{
		if(this._verticalScrollBarFactory == value)
		{
			return get_verticalScrollBarFactory();
		}
		this._verticalScrollBarFactory = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		return get_verticalScrollBarFactory();
	}

	/**
	 * @private
	 */
	private var _customVerticalScrollBarStyleName:String;

	/**
	 * A style name to add to the container's vertical scroll bar
	 * sub-component. Typically used by a theme to provide different styles
	 * to different containers.
	 *
	 * <p>In the following example, a custom vertical scroll bar style name
	 * is passed to the scroller:</p>
	 *
	 * <listing version="3.0">
	 * scroller.customVerticalScrollBarStyleName = "my-custom-vertical-scroll-bar";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( SimpleScrollBar ).setFunctionForStyleName( "my-custom-vertical-scroll-bar", setCustomVerticalScrollBarStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #verticalScrollBarFactory
	 * @see #verticalScrollBarProperties
	 */
	public function get_customVerticalScrollBarStyleName():String
	{
		return this._customVerticalScrollBarStyleName;
	}

	/**
	 * @private
	 */
	public function set_customVerticalScrollBarStyleName(value:String):String
	{
		if(this._customVerticalScrollBarStyleName == value)
		{
			return get_customVerticalScrollBarName();
		}
		this._customVerticalScrollBarStyleName = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		return get_customVerticalScrollBarName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customVerticalScrollBarStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customVerticalScrollBarStyleName
	 */
	public function get_customVerticalScrollBarName():String
	{
		return this.customVerticalScrollBarStyleName;
	}

	/**
	 * @private
	 */
	public function set_customVerticalScrollBarName(value:String):String
	{
		this.customVerticalScrollBarStyleName = value;
	}

	/**
	 * @private
	 */
	private var _verticalScrollBarProperties:PropertyProxy;

	/**
	 * An object that stores properties for the container's vertical scroll
	 * bar, and the properties will be passed down to the vertical scroll
	 * bar when the container validates. The available properties depend on
	 * which <code>IScrollBar</code> implementation is returned by
	 * <code>verticalScrollBarFactory</code>. Refer to
	 * <a href="IScrollBar.html"><code>feathers.controls.IScrollBar</code></a>
	 * for a list of available scroll bar implementations.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>verticalScrollBarFactory</code>
	 * function instead of using <code>verticalScrollBarProperties</code>
	 * will result in better performance.</p>
	 *
	 * <p>In the following example, properties for the vertical scroll bar
	 * are passed to the container:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalScrollBarProperties.liveDragging = false;</listing>
	 *
	 * @default null
	 *
	 * @see #verticalScrollBarFactory
	 * @see feathers.controls.IScrollBar
	 * @see feathers.controls.SimpleScrollBar
	 * @see feathers.controls.ScrollBar
	 */
	public var verticalScrollBarProperties(get, set):PropertyProxy;
	public function get_verticalScrollBarProperties():PropertyProxy
	{
		if(this._verticalScrollBarProperties == null)
		{
			this._verticalScrollBarProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._verticalScrollBarProperties;
	}

	/**
	 * @private
	 */
	public function set_verticalScrollBarProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._horizontalScrollBarProperties == value)
		{
			return get_verticalScrollBarProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!Std.is(value, PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for(propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._verticalScrollBarProperties != null)
		{
			this._verticalScrollBarProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._verticalScrollBarProperties = value;
		if(this._verticalScrollBarProperties != null)
		{
			this._verticalScrollBarProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_verticalScrollBarProperties();
	}

	/**
	 * @private
	 */
	private var actualHorizontalScrollStep:Float = 1;

	/**
	 * @private
	 */
	private var explicitHorizontalScrollStep:Float = Math.NaN;

	/**
	 * The number of pixels the horizontal scroll position can be adjusted
	 * by a "step". Passed to the horizontal scroll bar, if one exists.
	 * Touch scrolling is not affected by the step value.
	 *
	 * <p>In the following example, the horizontal scroll step is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.horizontalScrollStep = 0;</listing>
	 *
	 * @default NaN
	 */
	public var horizontalScrollStep(get, set):Float;
	public function get_horizontalScrollStep():Float
	{
		return this.actualHorizontalScrollStep;
	}

	/**
	 * @private
	 */
	public function set_horizontalScrollStep(value:Float):Float
	{
		if(this.explicitHorizontalScrollStep == value)
		{
			return get_horizontalScrollStep();
		}
		this.explicitHorizontalScrollStep = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return get_horizontalScrollStep();
	}

	/**
	 * @private
	 */
	private var _targetHorizontalScrollPosition:Float;

	/**
	 * @private
	 */
	private var _horizontalScrollPosition:Float = 0;

	/**
	 * The number of pixels the container has been scrolled horizontally (on
	 * the x-axis).
	 *
	 * <p>In the following example, the horizontal scroll position is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.horizontalScrollPosition = scroller.maxHorizontalScrollPosition;</listing>
	 *
	 * @see #minHorizontalScrollPosition
	 * @see #maxHorizontalScrollPosition
	 */
	public var horizontalScrollPosition(get, set):Float;
	public function get_horizontalScrollPosition():Float
	{
		return this._horizontalScrollPosition;
	}

	/**
	 * @private
	 */
	public function set_horizontalScrollPosition(value:Float):Float
	{
		if(this._snapScrollPositionsToPixels)
		{
			value = Math.round(value);
		}
		if(this._horizontalScrollPosition == value)
		{
			return get_horizontalScrollPosition();
		}
		if(value != value) //isNaN
		{
			//there isn't any recovery from this, so stop it early
			throw new ArgumentError("horizontalScrollPosition cannot be NaN.");
		}
		this._horizontalScrollPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return get_horizontalScrollPosition();
	}

	/**
	 * @private
	 */
	private var _minHorizontalScrollPosition:Float = 0;

	/**
	 * The number of pixels the scroller may be scrolled horizontally to the
	 * left. This value is automatically calculated based on the bounds of
	 * the viewport. The <code>horizontalScrollPosition</code> property may
	 * have a lower value than the minimum due to elastic edges. However,
	 * once the user stops interacting with the scroller, it will
	 * automatically animate back to the maximum or minimum position.
	 *
	 * @see #horizontalScrollPosition
	 * @see #maxHorizontalScrollPosition
	 */
	public var minHorizontalScrollPosition(get, never):Float;
	public function get_minHorizontalScrollPosition():Float
	{
		return this._minHorizontalScrollPosition;
	}

	/**
	 * @private
	 */
	private var _maxHorizontalScrollPosition:Float = 0;

	/**
	 * The number of pixels the scroller may be scrolled horizontally to the
	 * right. This value is automatically calculated based on the bounds of
	 * the viewport. The <code>horizontalScrollPosition</code> property may
	 * have a higher value than the maximum due to elastic edges. However,
	 * once the user stops interacting with the scroller, it will
	 * automatically animate back to the maximum or minimum position.
	 *
	 * @see #horizontalScrollPosition
	 * @see #minHorizontalScrollPosition
	 */
	public var maxHorizontalScrollPosition(get, never):Float;
	public function get_maxHorizontalScrollPosition():Float
	{
		return this._maxHorizontalScrollPosition;
	}

	/**
	 * @private
	 */
	private var _horizontalPageIndex:Int = 0;

	/**
	 * The index of the horizontal page, if snapping is enabled. If snapping
	 * is disabled, the index will always be <code>0</code>.
	 * 
	 * @see #horizontalPageCount
	 * @see #minHorizontalPageIndex
	 * @see #maxHorizontalPageIndex
	 */
	public var horizontalPageIndex(get, never):Int;
	public function get_horizontalPageIndex():Int
	{
		if(this.hasPendingHorizontalPageIndex)
		{
			return this.pendingHorizontalPageIndex;
		}
		return this._horizontalPageIndex;
	}

	/**
	 * @private
	 */
	private var _minHorizontalPageIndex:int = 0;

	/**
	 * The minimum horizontal page index that may be displayed by this
	 * container, if page snapping is enabled.
	 *
	 * @see #snapToPages
	 * @see #horizontalPageCount
	 * @see #maxHorizontalPageIndex
	 */
	public function get_minHorizontalPageIndex():int
	{
		return this._minHorizontalPageIndex;
	}

	/**
	 * @private
	 */
	private var _maxHorizontalPageIndex:int = 0;

	/**
	 * The maximum horizontal page index that may be displayed by this
	 * container, if page snapping is enabled.
	 *
	 * @see #snapToPages
	 * @see #horizontalPageCount
	 * @see #minHorizontalPageIndex
	 */
	public function get_maxHorizontalPageIndex():int
	{
		return this._maxHorizontalPageIndex;
	}

	/**
	 * The number of horizontal pages, if snapping is enabled. If snapping
	 * is disabled, the page count will always be <code>1</code>.
	 *
	 * <p>If the scroller's view port supports infinite scrolling, this
	 * property will return <code>int.MAX_VALUE</code>, since an
	 * <code>int</code> cannot hold the value <code>Number.POSITIVE_INFINITY</code>.</p>
	 *
	 * @see #snapToPages
	 * @see #horizontalPageIndex
	 * @see #minHorizontalPageIndex
	 * @see #maxHorizontalPageIndex
	 */
	public var horizontalPageCount(get, never):Int;
	public function get_horizontalPageCount():Int
	{
		if(this._maxHorizontalPageIndex == int.MAX_VALUE ||
			this._minHorizontalPageIndex == int.MIN_VALUE)
		{
			return int.MAX_VALUE;
		}
		return this._maxHorizontalPageIndex - this._minHorizontalPageIndex + 1;
	}

	/**
	 * @private
	 */
	private var _horizontalScrollPolicy:String = SCROLL_POLICY_AUTO;

	//[Inspectable(type="String",enumeration="auto,on,off")]
	/**
	 * Determines whether the scroller may scroll horizontally (on the
	 * x-axis) or not.
	 *
	 * <p>In the following example, horizontal scrolling is disabled:</p>
	 *
	 * <listing version="3.0">
	 * scroller.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;</listing>
	 *
	 * @default Scroller.SCROLL_POLICY_AUTO
	 *
	 * @see #SCROLL_POLICY_AUTO
	 * @see #SCROLL_POLICY_ON
	 * @see #SCROLL_POLICY_OFF
	 */
	public var horizontalScrollPolicy(get, set):String;
	public function get_horizontalScrollPolicy():String
	{
		return this._horizontalScrollPolicy;
	}

	/**
	 * @private
	 */
	public function set_horizontalScrollPolicy(value:String):String
	{
		if(this._horizontalScrollPolicy == value)
		{
			return get_horizontalScrollPolicy();
		}
		this._horizontalScrollPolicy = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		return get_horizontalScrollPolicy();
	}

	/**
	 * @private
	 */
	private var actualVerticalScrollStep:Float = 1;

	/**
	 * @private
	 */
	private var explicitVerticalScrollStep:Float = Math.NaN;

	/**
	 * The number of pixels the vertical scroll position can be adjusted
	 * by a "step". Passed to the vertical scroll bar, if one exists.
	 * Touch scrolling is not affected by the step value.
	 *
	 * <p>In the following example, the vertical scroll step is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalScrollStep = 0;</listing>
	 *
	 * @default NaN
	 */
	public var verticalScrollStep(get, set):Float;
	public function get_verticalScrollStep():Float
	{
		return this.actualVerticalScrollStep;
	}

	/**
	 * @private
	 */
	public function set_verticalScrollStep(value:Float):Float
	{
		if(this.explicitVerticalScrollStep == value)
		{
			return get_verticalScrollStep();
		}
		this.explicitVerticalScrollStep = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return get_verticalScrollStep();
	}

	/**
	 * @private
	 */
	private var _verticalMouseWheelScrollStep:Float = Math.NaN;

	/**
	 * The number of pixels the vertical scroll position can be adjusted by
	 * a "step" when using the mouse wheel. If this value is
	 * <code>NaN</code>, the mouse wheel will use the same scroll step as the scroll bars.
	 *
	 * <p>In the following example, the vertical mouse wheel scroll step is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalMouseWheelScrollStep = 10;</listing>
	 *
	 * @default NaN
	 */
	public var verticalMouseWheelScrollStep(get, set):Float;
	public function get_verticalMouseWheelScrollStep():Float
	{
		return this._verticalMouseWheelScrollStep;
	}

	/**
	 * @private
	 */
	public function set_verticalMouseWheelScrollStep(value:Float):Float
	{
		if(this._verticalMouseWheelScrollStep == value)
		{
			return get_verticalMouseWheelScrollStep();
		}
		this._verticalMouseWheelScrollStep = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return get_verticalMouseWheelScrollStep();
	}

	/**
	 * @private
	 */
	private var _targetVerticalScrollPosition:Float;

	/**
	 * @private
	 */
	private var _verticalScrollPosition:Float = 0;

	/**
	 * The number of pixels the container has been scrolled vertically (on
	 * the y-axis).
	 *
	 * <p>In the following example, the vertical scroll position is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalScrollPosition = scroller.maxVerticalScrollPosition;</listing>
	 * 
	 * @see #minVerticalScrollPosition
	 * @see #maxVerticalScrollPosition
	 */
	public var verticalScrollPosition(get, set):Float;
	public function get_verticalScrollPosition():Float
	{
		return this._verticalScrollPosition;
	}

	/**
	 * @private
	 */
	public function set_verticalScrollPosition(value:Float):Float
	{
		if(this._snapScrollPositionsToPixels)
		{
			value = Math.round(value);
		}
		if(this._verticalScrollPosition == value)
		{
			return get_verticalScrollPosition();
		}
		if(value != value) //isNaN
		{
			//there isn't any recovery from this, so stop it early
			throw new ArgumentError("verticalScrollPosition cannot be NaN.");
		}
		this._verticalScrollPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return get_verticalScrollPosition();
	}

	/**
	 * @private
	 */
	private var _minVerticalScrollPosition:Float = 0;

	/**
	 * The number of pixels the scroller may be scrolled vertically beyond
	 * the top edge. This value is automatically calculated based on the
	 * bounds of the viewport. The <code>verticalScrollPosition</code>
	 * property may have a lower value than the minimum due to elastic
	 * edges. However, once the user stops interacting with the scroller, it
	 * will automatically animate back to the maximum or minimum position.
	 *
	 * @see #verticalScrollPosition
	 * @see #maxVerticalScrollPosition
	 */
	public var minVerticalScrollPosition(get, never):Float;
	public function get_minVerticalScrollPosition():Float
	{
		return this._minVerticalScrollPosition;
	}

	/**
	 * @private
	 */
	private var _maxVerticalScrollPosition:Float = 0;

	/**
	 * The number of pixels the scroller may be scrolled vertically beyond
	 * the bottom edge. This value is automatically calculated based on the
	 * bounds of the viewport. The <code>verticalScrollPosition</code>
	 * property may have a lower value than the minimum due to elastic
	 * edges. However, once the user stops interacting with the scroller, it
	 * will automatically animate back to the maximum or minimum position.
	 *
	 * @see #verticalScrollPosition
	 * @see #minVerticalScrollPosition
	 */
	public var maxVerticalScrollPosition(get, never):Float;
	public function get_maxVerticalScrollPosition():Float
	{
		return this._maxVerticalScrollPosition;
	}

	/**
	 * @private
	 */
	private var _verticalPageIndex:Int = 0;

	/**
	 * The index of the vertical page, if snapping is enabled. If snapping
	 * is disabled, the index will always be <code>0</code>.
	 *
	 * @see #verticalPageCount
	 * @see #minVerticalPageIndex
	 * @see #maxVerticalPageIndex
	 */
	public var verticalPageIndex(get, never):Int;
	public function get_verticalPageIndex():Int
	{
		if(this.hasPendingVerticalPageIndex)
		{
			return this.pendingVerticalPageIndex;
		}
		return this._verticalPageIndex;
	}

	/**
	 * @private
	 */
	private var _minVerticalPageIndex:int = 0;

	/**
	 * The minimum vertical page index that may be displayed by this
	 * container, if page snapping is enabled.
	 *
	 * @see #snapToPages
	 * @see #verticalPageCount
	 * @see #maxVerticalPageIndex
	 */
	public function get_minVerticalPageIndex():int
	{
		return this._minVerticalPageIndex;
	}

	/**
	 * @private
	 */
	private var _maxVerticalPageIndex:int = 0;

	/**
	 * The maximum vertical page index that may be displayed by this
	 * container, if page snapping is enabled.
	 *
	 * @see #snapToPages
	 * @see #verticalPageCount
	 * @see #minVerticalPageIndex
	 */
	public function get_maxVerticalPageIndex():int
	{
		return this._maxVerticalPageIndex;
	}

	/**
	 * The number of vertical pages, if snapping is enabled. If snapping
	 * is disabled, the page count will always be <code>1</code>.
	 *
	 * <p>If the scroller's view port supports infinite scrolling, this
	 * property will return <code>int.MAX_VALUE</code>, since an
	 * <code>int</code> cannot hold the value <code>Number.POSITIVE_INFINITY</code>.</p>
	 *
	 * @see #snapToPages
	 * @see #verticalPageIndex
	 * @see #minVerticalPageIndex
	 * @see #maxVerticalPageIndex
	 */
	public var verticalPageCount(get, never):Int;
	public function get_verticalPageCount():Int
	{
		if(this._maxVerticalPageIndex == int.MAX_VALUE ||
			this._minVerticalPageIndex == int.MIN_VALUE)
		{
			return int.MAX_VALUE;
		}
		return this._maxVerticalPageIndex - this._minVerticalPageIndex + 1;
	}

	/**
	 * @private
	 */
	private var _verticalScrollPolicy:String = SCROLL_POLICY_AUTO;

	//[Inspectable(type="String",enumeration="auto,on,off")]
	/**
	 * Determines whether the scroller may scroll vertically (on the
	 * y-axis) or not.
	 *
	 * <p>In the following example, vertical scrolling is disabled:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;</listing>
	 *
	 * @default Scroller.SCROLL_POLICY_AUTO
	 *
	 * @see #SCROLL_POLICY_AUTO
	 * @see #SCROLL_POLICY_ON
	 * @see #SCROLL_POLICY_OFF
	 */
	public var verticalScrollPolicy(get, set):String;
	public function get_verticalScrollPolicy():String
	{
		return this._verticalScrollPolicy;
	}

	/**
	 * @private
	 */
	public function set_verticalScrollPolicy(value:String):String
	{
		if(this._verticalScrollPolicy == value)
		{
			return get_verticalScrollPolicy();
		}
		this._verticalScrollPolicy = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		return get_verticalScrollPolicy();
	}

	/**
	 * @private
	 */
	private var _clipContent:Bool = true;

	/**
	 * If true, the viewport will be clipped to the scroller's bounds. In
	 * other words, anything appearing outside the scroller's bounds will
	 * not be visible.
	 *
	 * <p>To improve performance, turn off clipping and place other display
	 * objects over the edges of the scroller to hide the content that
	 * bleeds outside of the scroller's bounds.</p>
	 *
	 * <p>In the following example, clipping is disabled:</p>
	 *
	 * <listing version="3.0">
	 * scroller.clipContent = false;</listing>
	 *
	 * @default true
	 */
	public var clipContent(get, set):Bool;
	public function get_clipContent():Bool
	{
		return this._clipContent;
	}

	/**
	 * @private
	 */
	public function set_clipContent(value:Bool):Bool
	{
		if(this._clipContent == value)
		{
			return get_clipContent();
		}
		this._clipContent = value;
		if(!value && this._viewPort)
		{
			this._viewPort.clipRect = null;
		}
		this.invalidate(INVALIDATION_FLAG_CLIPPING);
		return get_clipContent();
	}

	/**
	 * @private
	 */
	private var actualPageWidth:Float = 0;

	/**
	 * @private
	 */
	private var explicitPageWidth:Float = Math.NaN;

	/**
	 * When set, the horizontal pages snap to this width value instead of
	 * the width of the scroller.
	 *
	 * <p>In the following example, the page width is set to 200 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.pageWidth = 200;</listing>
	 *
	 * @see #snapToPages
	 */
	public var pageWidth(get, set):Float;
	public function get_pageWidth():Float
	{
		return this.actualPageWidth;
	}

	/**
	 * @private
	 */
	public function set_pageWidth(value:Float):Float
	{
		if(this.explicitPageWidth == value)
		{
			return get_pageWidth();
		}
		var valueIsNaN:Bool = value != value; //isNaN
		if(valueIsNaN && this.explicitPageWidth != this.explicitPageWidth)
		{
			return get_pageWidth();
		}
		this.explicitPageWidth = value;
		if(valueIsNaN)
		{
			//we need to calculate this value during validation
			this.actualPageWidth = 0;
		}
		else
		{
			this.actualPageWidth = this.explicitPageWidth;
		}
		return get_pageWidth();
	}

	/**
	 * @private
	 */
	private var actualPageHeight:Float = 0;

	/**
	 * @private
	 */
	private var explicitPageHeight:Float = Math.NaN;

	/**
	 * When set, the vertical pages snap to this height value instead of
	 * the height of the scroller.
	 *
	 * <p>In the following example, the page height is set to 200 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.pageHeight = 200;</listing>
	 *
	 * @see #snapToPages
	 */
	public var pageHeight(get, set):Float;
	public function get_pageHeight():Float
	{
		return this.actualPageHeight;
	}

	/**
	 * @private
	 */
	public function set_pageHeight(value:Float):Float
	{
		if(this.explicitPageHeight == value)
		{
			return get_pageHeight();
		}
		var valueIsNaN:Bool = value != value; //isNaN
		if(valueIsNaN && this.explicitPageHeight != this.explicitPageHeight)
		{
			return get_pageHeight();
		}
		this.explicitPageHeight = value;
		if(valueIsNaN)
		{
			//we need to calculate this value during validation
			this.actualPageHeight = 0;
		}
		else
		{
			this.actualPageHeight = this.explicitPageHeight;
		}
		return get_pageHeight();
	}

	/**
	 * @private
	 */
	private var _hasElasticEdges:Bool = true;

	/**
	 * Determines if the scrolling can go beyond the edges of the viewport.
	 *
	 * <p>In the following example, elastic edges are disabled:</p>
	 *
	 * <listing version="3.0">
	 * scroller.hasElasticEdges = false;</listing>
	 *
	 * @default true
	 *
	 * @see #elasticity
	 * @see #throwElasticity
	 */
	public var hasElasticEdges(get, set):Bool;
	public function get_hasElasticEdges():Bool
	{
		return this._hasElasticEdges;
	}

	/**
	 * @private
	 */
	public function set_hasElasticEdges(value:Bool):Bool
	{
		this._hasElasticEdges = value;
		return get_hasElasticEdges();
	}

	/**
	 * @private
	 */
	private var _elasticity:Float = 0.33;

	/**
	 * If the scroll position goes outside the minimum or maximum bounds
	 * when the scroller's content is being actively dragged, the scrolling
	 * will be constrained using this multiplier. A value of <code>0</code>
	 * means that the scroller will not go beyond its minimum or maximum
	 * bounds. A value of <code>1</code> means that going beyond the minimum
	 * or maximum bounds is completely unrestrained.
	 *
	 * <p>In the following example, the elasticity of dragging beyond the
	 * scroller's edges is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.elasticity = 0.5;</listing>
	 *
	 * @default 0.33
	 *
	 * @see #hasElasticEdges
	 * @see #throwElasticity
	 */
	public var elasticity(get, set):Float;
	public function get_elasticity():Float
	{
		return this._elasticity;
	}

	/**
	 * @private
	 */
	public function set_elasticity(value:Float):Float
	{
		this._elasticity = value;
		return get_elasticity();
	}

	/**
	 * @private
	 */
	private var _throwElasticity:Float = 0.05;

	/**
	 * If the scroll position goes outside the minimum or maximum bounds
	 * when the scroller's content is "thrown", the scrolling will be
	 * constrained using this multiplier. A value of <code>0</code> means
	 * that the scroller will not go beyond its minimum or maximum bounds.
	 * A value of <code>1</code> means that going beyond the minimum or
	 * maximum bounds is completely unrestrained.
	 *
	 * <p>In the following example, the elasticity of throwing beyond the
	 * scroller's edges is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.throwElasticity = 0.1;</listing>
	 *
	 * @default 0.05
	 *
	 * @see #hasElasticEdges
	 * @see #elasticity
	 */
	public var throwElasticity(get, set):Float;
	public function get_throwElasticity():Float
	{
		return this._throwElasticity;
	}

	/**
	 * @private
	 */
	public function set_throwElasticity(value:Float):Float
	{
		this._throwElasticity = value;
		return get_throwElasticity();
	}

	/**
	 * @private
	 */
	private var _scrollBarDisplayMode:String = SCROLL_BAR_DISPLAY_MODE_FLOAT;

	//[Inspectable(type="String",enumeration="float,fixed,none")]
	/**
	 * Determines how the scroll bars are displayed.
	 *
	 * <p>In the following example, the scroll bars are fixed:</p>
	 *
	 * <listing version="3.0">
	 * scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;</listing>
	 *
	 * @default Scroller.SCROLL_BAR_DISPLAY_MODE_FLOAT
	 *
	 * @see #SCROLL_BAR_DISPLAY_MODE_FLOAT
	 * @see #SCROLL_BAR_DISPLAY_MODE_FIXED
	 * @see #SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT
	 * @see #SCROLL_BAR_DISPLAY_MODE_NONE
	 */
	public var scrollBarDisplayMode(get, set):String;
	public function get_scrollBarDisplayMode():String
	{
		return this._scrollBarDisplayMode;
	}

	/**
	 * @private
	 */
	public function set_scrollBarDisplayMode(value:String):String
	{
		if(this._scrollBarDisplayMode == value)
		{
			return get_scrollBarDisplayMode();
		}
		this._scrollBarDisplayMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_scrollBarDisplayMode();
	}

	/**
	 * @private
	 */
	private var _interactionMode:String = INTERACTION_MODE_TOUCH;

	//[Inspectable(type="String",enumeration="touch,mouse,touchAndScrollBars")]
	/**
	 * Determines how the user may interact with the scroller.
	 *
	 * <p>In the following example, the interaction mode is optimized for mouse:</p>
	 *
	 * <listing version="3.0">
	 * scroller.interactionMode = Scroller.INTERACTION_MODE_MOUSE;</listing>
	 *
	 * @default Scroller.INTERACTION_MODE_TOUCH
	 *
	 * @see #INTERACTION_MODE_TOUCH
	 * @see #INTERACTION_MODE_MOUSE
	 * @see #INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
	 */
	public var interactionMode(get, set):String;
	public function get_interactionMode():String
	{
		return this._interactionMode;
	}

	/**
	 * @private
	 */
	public function set_interactionMode(value:String):String
	{
		if(this._interactionMode == value)
		{
			return get_interactionMode();
		}
		this._interactionMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_interactionMode();
	}

	/**
	 * @private
	 */
	private var originalBackgroundWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var originalBackgroundHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var currentBackgroundSkin:DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * The default background to display.
	 *
	 * <p>In the following example, the scroller is given a background skin:</p>
	 *
	 * <listing version="3.0">
	 * scroller.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundSkin(get, set):DisplayObject;
	public function get_backgroundSkin():DisplayObject
	{
		return this._backgroundSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundSkin == value)
		{
			return get_backgroundSkin();
		}

		if(this._backgroundSkin != null && this.currentBackgroundSkin == this._backgroundSkin)
		{
			this.removeRawChildInternal(this._backgroundSkin);
			this.currentBackgroundSkin = null;
		}
		this._backgroundSkin = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_backgroundSkin();
	}

	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * A background to display when the container is disabled.
	 *
	 * <p>In the following example, the scroller is given a disabled background skin:</p>
	 *
	 * <listing version="3.0">
	 * scroller.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundDisabledSkin(get, set):DisplayObject;
	public function get_backgroundDisabledSkin():DisplayObject
	{
		return this._backgroundDisabledSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundDisabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundDisabledSkin == value)
		{
			return get_backgroundDisabledSkin();
		}

		if(this._backgroundDisabledSkin !=null && this.currentBackgroundSkin == this._backgroundDisabledSkin)
		{
			this.removeRawChildInternal(this._backgroundDisabledSkin);
			this.currentBackgroundSkin = null;
		}
		this._backgroundDisabledSkin = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_backgroundDisabledSkin();
	}

	/**
	 * @private
	 */
	private var _autoHideBackground:Bool = false;

	/**
	 * If <code>true</code>, the background's <code>visible</code> property
	 * will be set to <code>false</code> when the scroll position is greater
	 * than or equal to the minimum scroll position and less than or equal
	 * to the maximum scroll position. The background will be visible when
	 * the content is extended beyond the scrolling bounds, such as when
	 * <code>hasElasticEdges</code> is <code>true</code>.
	 *
	 * <p>If the content is not fully opaque, this setting should not be
	 * enabled.</p>
	 *
	 * <p>This setting may be enabled to potentially improve performance.</p>
	 *
	 * <p>In the following example, the background is automatically hidden:</p>
	 *
	 * <listing version="3.0">
	 * scroller.autoHideBackground = true;</listing>
	 *
	 * @default false
	 */
	public var autoHideBackground(get, set):Bool;
	public function get_autoHideBackground():Bool
	{
		return this._autoHideBackground;
	}

	/**
	 * @private
	 */
	public function set_autoHideBackground(value:Bool):Bool
	{
		if(this._autoHideBackground == value)
		{
			return get_autoHideBackground();
		}
		this._autoHideBackground = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_autoHideBackground();
	}

	/**
	 * @private
	 */
	private var _minimumDragDistance:Float = 0.04;

	/**
	 * The minimum physical distance (in inches) that a touch must move
	 * before the scroller starts scrolling.
	 *
	 * <p>In the following example, the minimum drag distance is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.minimumDragDistance = 0.1;</listing>
	 *
	 * @default 0.04
	 */
	public var minimumDragDistance(get, set):Float;
	public function get_minimumDragDistance():Float
	{
		return this._minimumDragDistance;
	}

	/**
	 * @private
	 */
	public function set_minimumDragDistance(value:Float):Float
	{
		this._minimumDragDistance = value;
		return get_minimumDragDistance();
	}

	/**
	 * @private
	 */
	private var _minimumPageThrowVelocity:Float = 5;

	/**
	 * The minimum physical velocity (in inches per second) that a touch
	 * must move before the scroller will "throw" to the next page.
	 * Otherwise, it will settle to the nearest page.
	 *
	 * <p>In the following example, the minimum page throw velocity is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.minimumPageThrowVelocity = 2;</listing>
	 *
	 * @default 5
	 */
	public var minimumPageThrowVelocity(get, set):Float;
	public function get_minimumPageThrowVelocity():Float
	{
		return this._minimumPageThrowVelocity;
	}

	/**
	 * @private
	 */
	public function set_minimumPageThrowVelocity(value:Float):Float
	{
		this._minimumPageThrowVelocity = value;
		return get_minimumPageThrowVelocity();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the container's top edge and the
	 * container's content.
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.paddingTop = 20;</listing>
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
	 * The minimum space, in pixels, between the container's right edge and
	 * the container's content.
	 *
	 * <p>In the following example, the right padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.paddingRight = 20;</listing>
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
	 * The minimum space, in pixels, between the container's bottom edge and
	 * the container's content.
	 *
	 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.paddingBottom = 20;</listing>
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
	 * The minimum space, in pixels, between the container's left edge and the
	 * container's content.
	 *
	 * <p>In the following example, the left padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.paddingLeft = 20;</listing>
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
	private var _horizontalScrollBarHideTween:Tween;

	/**
	 * @private
	 */
	private var _verticalScrollBarHideTween:Tween;

	/**
	 * @private
	 */
	private var _hideScrollBarAnimationDuration:Float = 0.2;

	/**
	 * The duration, in seconds, of the animation when a scroll bar fades
	 * out.
	 *
	 * <p>In the following example, the duration of the animation that hides
	 * the scroll bars is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.hideScrollBarAnimationDuration = 0.5;</listing>
	 *
	 * @default 0.2
	 */
	public var hideScrollBarAnimationDuration(get, set):Float;
	public function get_hideScrollBarAnimationDuration():Float
	{
		return this._hideScrollBarAnimationDuration;
	}

	/**
	 * @private
	 */
	public function set_hideScrollBarAnimationDuration(value:Float):Float
	{
		this._hideScrollBarAnimationDuration = value;
		return get_hideScrollBarAnimationDuration();
	}

	/**
	 * @private
	 */
	private var _hideScrollBarAnimationEase:Dynamic = Transitions.EASE_OUT;

	/**
	 * The easing function used for hiding the scroll bars, if applicable.
	 *
	 * <p>In the following example, the ease of the animation that hides
	 * the scroll bars is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.hideScrollBarAnimationEase = Transitions.EASE_IN_OUT;</listing>
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 *
	 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
	 */
	public var hideScrollBarAnimationEase(get, set):Dynamic;
	public function get_hideScrollBarAnimationEase():Dynamic
	{
		return this._hideScrollBarAnimationEase;
	}

	/**
	 * @private
	 */
	public function set_hideScrollBarAnimationEase(value:Dynamic):Dynamic
	{
		this._hideScrollBarAnimationEase = value;
		return get_hideScrollBarAnimationEase();
	}

	/**
	 * @private
	 */
	private var _elasticSnapDuration:Float = 0.5;

	/**
	 * The duration, in seconds, of the animation when a the scroller snaps
	 * back to the minimum or maximum position after going out of bounds.
	 *
	 * <p>In the following example, the duration of the animation that snaps
	 * the content back after pulling it beyond the edge is set to 750
	 * milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.elasticSnapDuration = 0.75;</listing>
	 *
	 * @default 0.5
	 */
	public var elasticSnapDuration(get, set):Float;
	public function get_elasticSnapDuration():Float
	{
		return this._elasticSnapDuration;
	}

	/**
	 * @private
	 */
	public function set_elasticSnapDuration(value:Float):Float
	{
		this._elasticSnapDuration = value;
		return get_elasticSnapDuration();
	}

	/**
	 * @private
	 * This value is precalculated. See the <code>decelerationRate</code>
	 * setter for the dynamic calculation.
	 */
	private var _logDecelerationRate:Float = -0.0020020026706730793;

	/**
	 * @private
	 */
	private var _decelerationRate:Float = DECELERATION_RATE_NORMAL;

	/**
	 * This value is used to decelerate the scroller when "thrown". The
	 * velocity of a throw is multiplied by this value once per millisecond
	 * to decelerate. A value greater than <code>0</code> and less than
	 * <code>1</code> is expected.
	 *
	 * <p>In the following example, deceleration rate is lowered to adjust
	 * the behavior of a throw:</p>
	 *
	 * <listing version="3.0">
	 * scroller.decelerationRate = Scroller.DECELERATION_RATE_FAST;</listing>
	 *
	 * @default Scroller.DECELERATION_RATE_NORMAL
	 *
	 * @see #DECELERATION_RATE_NORMAL
	 * @see #DECELERATION_RATE_FAST
	 */
	public var decelerationRate(get, set):Float;
	public function get_decelerationRate():Float
	{
		return this._decelerationRate;
	}

	/**
	 * @private
	 */
	public function set_decelerationRate(value:Float):Float
	{
		if(this._decelerationRate == value)
		{
			return get_decelerationRate();
		}
		this._decelerationRate = value;
		this._logDecelerationRate = Math.log(this._decelerationRate);
		this._fixedThrowDuration = -0.1 / Math.log(Math.pow(this._decelerationRate, 1000 / 60));
		return get_decelerationRate();
	}

	/**
	 * @private
	 * This value is precalculated. See the <code>decelerationRate</code>
	 * setter for the dynamic calculation.
	 */
	private var _fixedThrowDuration:Float = 2.996998998998728;

	/**
	 * @private
	 */
	private var _useFixedThrowDuration:Bool = true;

	/**
	 * If <code>true</code>, the duration of a "throw" animation will be the
	 * same no matter the value of the throw's initial velocity. This value
	 * may be set to <code>false</code> to have the scroller calculate a
	 * variable duration based on the velocity of the throw.
	 *
	 * <p>It may seem unintuitive, but using the same fixed duration for any
	 * velocity is recommended if you are looking to closely match the
	 * behavior of native scrolling on iOS.</p>
	 *
	 * <p>In the following example, the duration of the animation that
	 * changes the scroller's content is equal:</p>
	 *
	 * <listing version="3.0">
	 * scroller.throwDuration = 1.5;</listing>
	 *
	 * @default 2.0
	 *
	 * @see #decelerationRate
	 * @see #pageThrowDuration
	 */
	public var useFixedThrowDuration(get, set):Bool;
	public function get_useFixedThrowDuration():Bool
	{
		return this._useFixedThrowDuration;
	}

	/**
	 * @private
	 */
	public function set_useFixedThrowDuration(value:Bool):Bool
	{
		this._useFixedThrowDuration = value;
		return get_useFixedThrowDuration();
	}

	/**
	 * @private
	 */
	private var _pageThrowDuration:Float = 0.5;

	/**
	 * The duration, in seconds, of the animation when the scroller is
	 * thrown to a page.
	 *
	 * <p>In the following example, the duration of the animation that
	 * changes the page when thrown is set to 250 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.pageThrowDuration = 0.25;</listing>
	 *
	 * @default 0.5
	 */
	public var pageThrowDuration(get, set):Float;
	public function get_pageThrowDuration():Float
	{
		return this._pageThrowDuration;
	}

	/**
	 * @private
	 */
	public function set_pageThrowDuration(value:Float):Float
	{
		this._pageThrowDuration = value;
		return get_pageThrowDuration();
	}

	/**
	 * @private
	 */
	private var _mouseWheelScrollDuration:Float = 0.35;

	/**
	 * The duration, in seconds, of the animation when the mouse wheel
	 * initiates a scroll action.
	 *
	 * <p>In the following example, the duration of the animation that runs
	 * when the mouse wheel is scrolled is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.mouseWheelScrollDuration = 0.5;</listing>
	 *
	 * @default 0.35
	 */
	public var mouseWheelScrollDuration(get, set):Float;
	public function get_mouseWheelScrollDuration():Float
	{
		return this._mouseWheelScrollDuration;
	}

	/**
	 * @private
	 */
	public function set_mouseWheelScrollDuration(value:Float):Float
	{
		this._mouseWheelScrollDuration = value;
		return get_mouseWheelScrollDuration();
	}

	/**
	 * @private
	 */
	private var _verticalMouseWheelScrollDirection:String = MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL;

	/**
	 * The direction of scrolling when the user scrolls the mouse wheel
	 * vertically. In some cases, it is common for a container that only
	 * scrolls horizontally to scroll even when the mouse wheel is scrolled
	 * vertically.
	 *
	 * <p>In the following example, the direction of scrolling when using
	 * the mouse wheel is changed:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalMouseWheelScrollDirection = Scroller.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL;</listing>
	 *
	 * @default Scroller.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
	 *
	 * @see #MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
	 * @see #MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
	 */
	public function get_verticalMouseWheelScrollDirection():String
	{
		return this._verticalMouseWheelScrollDirection;
	}

	/**
	 * @private
	 */
	public function set_verticalMouseWheelScrollDirection(value:String):String
	{
		this._verticalMouseWheelScrollDirection = value;
	}

	/**
	 * @private
	 */
	private var _throwEase:Object = defaultThrowEase;

	/**
	 * The easing function used for "throw" animations.
	 *
	 * <p>In the following example, the ease of throwing animations is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.throwEase = Transitions.EASE_IN_OUT;</listing>
	 *
	 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
	 */
	public var throwEase(get, set):Dynamic;
	public function get_throwEase():Dynamic
	{
		return this._throwEase;
	}

	/**
	 * @private
	 */
	public function set_throwEase(value:Dynamic):Dynamic
	{
		if(value == null)
		{
			value = defaultThrowEase;
		}
		this._throwEase = value;
		return get_throwEase();
	}

	/**
	 * @private
	 */
	private var _snapScrollPositionsToPixels:Boolean = true;

	/**
	 * If enabled, the scroll position will always be adjusted to whole
	 * pixels.
	 *
	 * <p>In the following example, the scroll position is not snapped to pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.snapScrollPositionsToPixels = false;</listing>
	 *
	 * @default true
	 */
	public var snapScrollPositionsToPixels(get, set):Bool;
	public function get_snapScrollPositionsToPixels():Bool
	{
		return this._snapScrollPositionsToPixels;
	}

	/**
	 * @private
	 */
	public function set_snapScrollPositionsToPixels(value:Bool):Bool
	{
		if(this._snapScrollPositionsToPixels == value)
		{
			return get_snapScrollPositionsToPixels();
		}
		this._snapScrollPositionsToPixels = value;
		if(this._snapScrollPositionsToPixels)
		{
			this.horizontalScrollPosition = Math.round(this._horizontalScrollPosition);
			this.verticalScrollPosition = Math.round(this._verticalScrollPosition);
		}
		return get_snapScrollPositionsToPixels();
	}

	/**
	 * @private
	 */
	private var _horizontalScrollBarIsScrolling:Bool = false;

	/**
	 * @private
	 */
	private var _verticalScrollBarIsScrolling:Bool = false;

	/**
	 * @private
	 */
	private var _isScrolling:Bool = false;

	/**
	 * Determines if the scroller is currently scrolling with user
	 * interaction or with animation.
	 */
	public var isScrolling(get, never):Bool;
	public function get_isScrolling():Bool
	{
		return this._isScrolling;
	}

	/**
	 * @private
	 */
	private var _isScrollingStopped:Bool = false;

	/**
	 * The pending horizontal scroll position to scroll to after validating.
	 * A value of <code>NaN</code> means that the scroller won't scroll to a
	 * horizontal position after validating.
	 */
	private var pendingHorizontalScrollPosition:Float = Math.NaN;

	/**
	 * The pending vertical scroll position to scroll to after validating.
	 * A value of <code>NaN</code> means that the scroller won't scroll to a
	 * vertical position after validating.
	 */
	private var pendingVerticalScrollPosition:Float = Math.NaN;

	/**
	 * A flag that indicates if the scroller should scroll to a new page
	 * when it validates. If <code>true</code>, it will use the value of
	 * <code>pendingHorizontalPageIndex</code> as the target page index.
	 * 
	 * @see #pendingHorizontalPageIndex
	 */
	private var hasPendingHorizontalPageIndex:Boolean = false;

	/**
	 * A flag that indicates if the scroller should scroll to a new page
	 * when it validates. If <code>true</code>, it will use the value of
	 * <code>pendingVerticalPageIndex</code> as the target page index.
	 *
	 * @see #pendingVerticalPageIndex
	 */
	private var hasPendingVerticalPageIndex:Boolean = false;

	/**
	 * The pending horizontal page index to scroll to after validating. The
	 * flag <code>hasPendingHorizontalPageIndex</code> must be set to true
	 * if there is a pending page index to scroll to.
	 * 
	 * @see #hasPendingHorizontalPageIndex
	 */
	private var pendingHorizontalPageIndex:int;

	/**
	 * The pending vertical page index to scroll to after validating. The
	 * flag <code>hasPendingVerticalPageIndex</code> must be set to true
	 * if there is a pending page index to scroll to.
	 *
	 * @see #hasPendingVerticalPageIndex
	 */
	private var pendingVerticalPageIndex:int;

	/**
	 * The duration of the pending scroll action.
	 */
	private var pendingScrollDuration:Float;

	/**
	 * @private
	 */
	private var isScrollBarRevealPending:Bool = false;

	/**
	 * @private
	 */
	private var _revealScrollBarsDuration:Float = 1.0;

	/**
	 * The duration, in seconds, that the scroll bars will be shown when
	 * calling <code>revealScrollBars()</code>
	 *
	 * @default 1.0
	 *
	 * @see #revealScrollBars()
	 */
	public var revealScrollBarsDuration(get, set):Float;
	public function get_revealScrollBarsDuration():Float
	{
		return this._revealScrollBarsDuration;
	}

	/**
	 * @private
	 */
	public function set_revealScrollBarsDuration(value:Float):Float
	{
		this._revealScrollBarsDuration = value;
		return get_revealScrollBarsDuration();
	}

	/**
	 * @private
	 */
	private var _horizontalAutoScrollTweenEndRatio:Float = 1;

	/**
	 * @private
	 */
	private var _verticalAutoScrollTweenEndRatio:Float = 1;

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler);
		Starling.current.nativeStage.removeEventListener("orientationChange", nativeStage_orientationChangeHandler);
		super.dispose();
	}

	/**
	 * If the user is scrolling with touch or if the scrolling is animated,
	 * calling stopScrolling() will cause the scroller to ignore the drag
	 * and stop animations. This function may only be called during scrolling,
	 * so if you need to stop scrolling on a <code>TouchEvent</code> with
	 * <code>TouchPhase.BEGAN</code>, you may need to wait for the scroller
	 * to start scrolling before you can call this function.
	 *
	 * <p>In the following example, we listen for <code>FeathersEventType.SCROLL_START</code>
	 * to stop scrolling:</p>
	 *
	 * <listing version="3.0">
	 * scroller.addEventListener( FeathersEventType.SCROLL_START, function( event:Event ):Void
	 * {
	 *     scroller.stopScrolling();
	 * });</listing>
	 */
	public function stopScrolling():Void
	{
		if(this._horizontalAutoScrollTween != null)
		{
			Starling.current.juggler.remove(this._horizontalAutoScrollTween);
			this._horizontalAutoScrollTween = null;
		}
		if(this._verticalAutoScrollTween != null)
		{
			Starling.current.juggler.remove(this._verticalAutoScrollTween);
			this._verticalAutoScrollTween = null;
		}
		this._isScrollingStopped = true;
		this._velocityX = 0;
		this._velocityY = 0;
		this._previousVelocityX.splice(0, this._previousVelocityX.length);
		this._previousVelocityY.splice(0, this._previousVelocityY.length);
		this.hideHorizontalScrollBar();
		this.hideVerticalScrollBar();
	}

	/**
	 * After the next validation, animates the scroll positions to a
	 * specific location. May scroll in only one direction by passing in a
	 * value of <code>NaN</code> for either scroll position. If the
	 * <code>animationDuration</code> argument is <code>NaN</code> (the
	 * default value), the duration of a standard throw is used. The
	 * duration is in seconds.
	 *
	 * <p>Because this function is primarily designed for animation, using a
	 * duration of <code>0</code> may require a frame or two before the
	 * scroll position updates.</p>
	 *
	 * <p>In the following example, we scroll to the maximum vertical scroll
	 * position:</p>
	 *
	 * <listing version="3.0">
	 * scroller.scrollToPosition( scroller.horizontalScrollPosition, scroller.maxVerticalScrollPosition );</listing>
	 *
	 * @see #horizontalScrollPosition
	 * @see #verticalScrollPosition
	 * @see #throwEase
	 */
	public function scrollToPosition(horizontalScrollPosition:Float, verticalScrollPosition:Float, animationDuration:Null<Float> = null):Void
	{
		if (animationDuration == null) animationDuration = Math.NaN;
		if(animationDuration != animationDuration) //isNaN
		{
			if(this._useFixedThrowDuration)
			{
				animationDuration = this._fixedThrowDuration;
			}
			else
			{
				HELPER_POINT.setTo(horizontalScrollPosition - this._horizontalScrollPosition, verticalScrollPosition - this._verticalScrollPosition);
				animationDuration = this.calculateDynamicThrowDuration(HELPER_POINT.length * this._logDecelerationRate + MINIMUM_VELOCITY);
			}
		}
		//cancel any pending scroll to a different page. we can have only
		//one type of pending scroll at a time.
		this.hasPendingHorizontalPageIndex = false;
		this.hasPendingVerticalPageIndex = false;
		if(this.pendingHorizontalScrollPosition == horizontalScrollPosition &&
			this.pendingVerticalScrollPosition == verticalScrollPosition &&
			this.pendingScrollDuration == animationDuration)
		{
			return;
		}
		this.pendingHorizontalScrollPosition = horizontalScrollPosition;
		this.pendingVerticalScrollPosition = verticalScrollPosition;
		this.pendingScrollDuration = animationDuration;
		this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
	}

	/**
	 * After the next validation, animates the scroll position to a specific
	 * page index. To scroll in only one direction, pass in the value of the
	 * <code>horizontalPageIndex</code> or the
	 * <code>verticalPageIndex</code> property to the appropriate parameter.
	 * If the <code>animationDuration</code> argument is <code>NaN</code>
	 * (the default value) the value of the <code>pageThrowDuration</code>
	 * property is used for the duration. The duration is in seconds.
	 *
	 * <p>You can only scroll to a page if the <code>snapToPages</code>
	 * property is <code>true</code>.</p>
	 *
	 * <p>In the following example, we scroll to the last horizontal page:</p>
	 *
	 * <listing version="3.0">
	 * scroller.scrollToPageIndex( scroller.horizontalPageCount - 1, scroller.verticalPageIndex );</listing>
	 *
	 * @see #snapToPages
	 * @see #pageThrowDuration
	 * @see #throwEase
	 * @see #horizontalPageIndex
	 * @see #verticalPageIndex
	 */
	public function scrollToPageIndex(horizontalPageIndex:Int, verticalPageIndex:Int, animationDuration:Null<Float> = null):Void
	{
		if (animationDuration == null) animationDuration = Math.NaN;
		if(animationDuration != animationDuration) //isNaN
		{
			animationDuration = this._pageThrowDuration;
		}
		//cancel any pending scroll to a specific scroll position. we can
		//have only one type of pending scroll at a time.
		this.pendingHorizontalScrollPosition = NaN;
		this.pendingVerticalScrollPosition = NaN;
		this.hasPendingHorizontalPageIndex = this._horizontalPageIndex != horizontalPageIndex;
		this.hasPendingVerticalPageIndex = this._verticalPageIndex != verticalPageIndex;
		if(!this.hasPendingHorizontalPageIndex && !this.hasPendingVerticalPageIndex)
		{
			return;
		}
		this.pendingHorizontalPageIndex = horizontalPageIndex;
		this.pendingVerticalPageIndex = verticalPageIndex;
		this.pendingScrollDuration = animationDuration;
		this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
	}

	/**
	 * If the scroll bars are floating, briefly show them as a hint to the
	 * user. Useful when first navigating to a screen to give the user
	 * context about both the ability to scroll and the current scroll
	 * position.
	 *
	 * @see #revealScrollBarsDuration
	 */
	public function revealScrollBars():Void
	{
		this.isScrollBarRevealPending = true;
		this.invalidate(INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS);
	}

	/**
	 * @private
	 */
	override public function hitTest(localPoint:Point, forTouch:Bool = false):DisplayObject
	{
		//save localX and localY because localPoint could change after the
		//call to super.hitTest().
		var localX:Float = localPoint.x;
		var localY:Float = localPoint.y;
		//first check the children for touches
		var result:DisplayObject = super.hitTest(localPoint, forTouch);
		if(result == null)
		{
			//we want to register touches in our hitArea as a last resort
			if(forTouch && (!this.visible || !this.touchable))
			{
				return null;
			}
			return this._hitArea.contains(localX, localY) ? this : null;
		}
		return result;
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		//we don't use this flag in this class, but subclasses will use it,
		//and it's better to handle it here instead of having them
		//invalidate unrelated flags
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var scrollInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SCROLL);
		var clippingInvalid:Bool = this.isInvalid(Scroller.INVALIDATION_FLAG_CLIPPING);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var scrollBarInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		var pendingScrollInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_PENDING_SCROLL);
		var pendingRevealScrollBarsInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS);

		if(scrollBarInvalid)
		{
			this.createScrollBars();
		}

		if(sizeInvalid || stylesInvalid || stateInvalid)
		{
			this.refreshBackgroundSkin();
		}

		if(scrollBarInvalid || stylesInvalid)
		{
			this.refreshScrollBarStyles();
			this.refreshInteractionModeEvents();
		}

		if(scrollBarInvalid || stateInvalid)
		{
			this.refreshEnabled();
		}

		if(this.horizontalScrollBar != null)
		{
			this.horizontalScrollBar.validate();
		}
		if(this.verticalScrollBar != null)
		{
			this.verticalScrollBar.validate();
		}

		var needsWidthOrHeight:Bool = this.explicitWidth != this.explicitWidth ||
			this.explicitHeight != this.explicitHeight; //isNaN
		var oldMaxHorizontalScrollPosition:Float = this._maxHorizontalScrollPosition;
		var oldMaxVerticalScrollPosition:Float = this._maxVerticalScrollPosition;
		var loopCount:Int = 0;
		do
		{
			this._hasViewPortBoundsChanged = false;
			//if we don't need to do any measurement, we can skip this stuff
			//and improve performance
			if(needsWidthOrHeight && this._measureViewPort)
			{
				//even if fixed, we need to measure without them first because
				//if the scroll policy is auto, we only show them when needed.
				if(scrollInvalid || dataInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid)
				{
					this.calculateViewPortOffsets(true, false);
					this.refreshViewPortBoundsWithoutFixedScrollBars();
					this.calculateViewPortOffsets(false, false);
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			//just in case autoSizeIfNeeded() is overridden, we need to call
			//this again and use actualWidth/Height instead of
			//explicitWidth/Height.
			this.calculateViewPortOffsets(false, true);

			if(scrollInvalid || dataInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid)
			{
				this.refreshViewPortBoundsWithFixedScrollBars();
				this.refreshScrollValues();
			}
			loopCount++;
			if(loopCount >= 10)
			{
				//if it still fails after ten tries, we've probably entered
				//an infinite loop due to rounding errors or something
				break;
			}
		}
		while(this._hasViewPortBoundsChanged);
		this._lastViewPortWidth = viewPort.width;
		this._lastViewPortHeight = viewPort.height;
		if(oldMaxHorizontalScrollPosition != this._maxHorizontalScrollPosition)
		{
			this.refreshHorizontalAutoScrollTweenEndRatio();
			scrollInvalid = true;
		}
		if(oldMaxVerticalScrollPosition != this._maxVerticalScrollPosition)
		{
			this.refreshVerticalAutoScrollTweenEndRatio();
			scrollInvalid = true;
		}
		if(scrollInvalid)
		{
			this.dispatchEventWith(Event.SCROLL);
		}

		this.showOrHideChildren();

		if(scrollInvalid || sizeInvalid || stylesInvalid || stateInvalid || scrollBarInvalid)
		{
			this.layoutChildren();
		}

		if(scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid)
		{
			this.refreshScrollBarValues();
		}

		if(scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || clippingInvalid)
		{
			this.refreshClipRect();
		}
		this.refreshFocusIndicator();

		if(pendingScrollInvalid)
		{
			this.handlePendingScroll();
		}

		if(pendingRevealScrollBarsInvalid)
		{
			this.handlePendingRevealScrollBars();
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
			if(this._measureViewPort)
			{
				newWidth = this._viewPort.visibleWidth;
				if(newWidth != newWidth) //isNaN
				{
					newWidth = this._viewPort.width;
				}
				newWidth += this._rightViewPortOffset + this._leftViewPortOffset;
			}
			else
			{
				newWidth = 0;
			}
			if(this.originalBackgroundWidth === this.originalBackgroundWidth && //!isNaN
				this.originalBackgroundWidth > newWidth)
			{
				newWidth = this.originalBackgroundWidth;
			}
		}
		if(needsHeight)
		{
			if(this._measureViewPort)
			{
				newHeight = this._viewPort.visibleHeight;
				if(newHeight != newHeight) //isNaN
				{
					newHeight = this._viewPort.height;
				}
				newHeight += this._bottomViewPortOffset + this._topViewPortOffset;
			}
			else
			{
				newHeight = 0;
			}
			if(this.originalBackgroundHeight === this.originalBackgroundHeight && //!isNaN
				this.originalBackgroundHeight > newHeight)
			{
				newHeight = this.originalBackgroundHeight;
			}
		}
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates and adds the <code>horizontalScrollBar</code> and
	 * <code>verticalScrollBar</code> sub-components and removes the old
	 * instances, if they exist.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #horizontalScrollBar
	 * @see #verticalScrollBar
	 * @see #horizontalScrollBarFactory
	 * @see #verticalScrollBarFactory
	 */
	private function createScrollBars():Void
	{
		if(this.horizontalScrollBar != null)
		{
			this.horizontalScrollBar.removeEventListener(FeathersEventType.BEGIN_INTERACTION, horizontalScrollBar_beginInteractionHandler);
			this.horizontalScrollBar.removeEventListener(FeathersEventType.END_INTERACTION, horizontalScrollBar_endInteractionHandler);
			this.horizontalScrollBar.removeEventListener(Event.CHANGE, horizontalScrollBar_changeHandler);
			this.removeRawChildInternal(cast(this.horizontalScrollBar, DisplayObject), true);
			this.horizontalScrollBar = null;
		}
		if(this.verticalScrollBar != null)
		{
			this.verticalScrollBar.removeEventListener(FeathersEventType.BEGIN_INTERACTION, verticalScrollBar_beginInteractionHandler);
			this.verticalScrollBar.removeEventListener(FeathersEventType.END_INTERACTION, verticalScrollBar_endInteractionHandler);
			this.verticalScrollBar.removeEventListener(Event.CHANGE, verticalScrollBar_changeHandler);
			this.removeRawChildInternal(cast(this.verticalScrollBar, DisplayObject), true);
			this.verticalScrollBar = null;
		}

		if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_NONE &&
			this._horizontalScrollPolicy != SCROLL_POLICY_OFF && this._horizontalScrollBarFactory != null)
		{
			this.horizontalScrollBar = this._horizontalScrollBarFactory();
			if(Std.is(this.horizontalScrollBar, IDirectionalScrollBar))
			{
				cast(this.horizontalScrollBar, IDirectionalScrollBar).direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			}
			var horizontalScrollBarStyleName:String = this._customHorizontalScrollBarStyleName != null ? this._customHorizontalScrollBarStyleName : this.horizontalScrollBarStyleName;
			this.horizontalScrollBar.styleNameList.add(horizontalScrollBarStyleName);
			this.horizontalScrollBar.addEventListener(Event.CHANGE, horizontalScrollBar_changeHandler);
			this.horizontalScrollBar.addEventListener(FeathersEventType.BEGIN_INTERACTION, horizontalScrollBar_beginInteractionHandler);
			this.horizontalScrollBar.addEventListener(FeathersEventType.END_INTERACTION, horizontalScrollBar_endInteractionHandler);
			this.addRawChildInternal(cast(this.horizontalScrollBar, DisplayObject));
		}
		if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_NONE &&
			this._verticalScrollPolicy != SCROLL_POLICY_OFF && this._verticalScrollBarFactory != null)
		{
			this.verticalScrollBar = this._verticalScrollBarFactory();
			if(Std.is(this.verticalScrollBar, IDirectionalScrollBar))
			{
				cast(this.verticalScrollBar, IDirectionalScrollBar).direction = SimpleScrollBar.DIRECTION_VERTICAL;
			}
			var verticalScrollBarStyleName:String = this._customVerticalScrollBarStyleName != null ? this._customVerticalScrollBarStyleName : this.verticalScrollBarStyleName;
			this.verticalScrollBar.styleNameList.add(verticalScrollBarStyleName);
			this.verticalScrollBar.addEventListener(Event.CHANGE, verticalScrollBar_changeHandler);
			this.verticalScrollBar.addEventListener(FeathersEventType.BEGIN_INTERACTION, verticalScrollBar_beginInteractionHandler);
			this.verticalScrollBar.addEventListener(FeathersEventType.END_INTERACTION, verticalScrollBar_endInteractionHandler);
			this.addRawChildInternal(cast(this.verticalScrollBar, DisplayObject));
		}
	}

	/**
	 * Choose the appropriate background skin based on the control's current
	 * state.
	 */
	private function refreshBackgroundSkin():Void
	{
		var newCurrentBackgroundSkin:DisplayObject = this._backgroundSkin;
		if(!this._isEnabled && this._backgroundDisabledSkin != null)
		{
			newCurrentBackgroundSkin = this._backgroundDisabledSkin;
		}
		if(this.currentBackgroundSkin != newCurrentBackgroundSkin)
		{
			if(this.currentBackgroundSkin != null)
			{
				this.removeRawChildInternal(this.currentBackgroundSkin);
			}
			this.currentBackgroundSkin = newCurrentBackgroundSkin;
			if(this.currentBackgroundSkin != null)
			{
				this.addRawChildAtInternal(this.currentBackgroundSkin, 0);
			}
		}
		if(this.currentBackgroundSkin != null)
		{
			//force it to the bottom
			this.setRawChildIndexInternal(this.currentBackgroundSkin, 0);

			if(this.originalBackgroundWidth != this.originalBackgroundWidth) //isNaN
			{
				this.originalBackgroundWidth = this.currentBackgroundSkin.width;
			}
			if(this.originalBackgroundHeight != this.originalBackgroundHeight) //isNaN
			{
				this.originalBackgroundHeight = this.currentBackgroundSkin.height;
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshScrollBarStyles():Void
	{
		var propertyValue:Dynamic;
		if(this.horizontalScrollBar != null)
		{
			if (this._horizontalScrollBarProperties != null)
			{
				for(propertyName in Reflect.fields(this._horizontalScrollBarProperties.storage))
				{
					propertyValue = Reflect.field(this._horizontalScrollBarProperties.storage, propertyName);
					Reflect.setProperty(this.horizontalScrollBar, propertyName, propertyValue);
				}
			}
			if(this._horizontalScrollBarHideTween != null)
			{
				Starling.current.juggler.remove(this._horizontalScrollBarHideTween);
				this._horizontalScrollBarHideTween = null;
			}
			this.horizontalScrollBar.alpha = this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT ? 0 : 1;
		}
		if(this.verticalScrollBar != null)
		{
			if (this._verticalScrollBarProperties != null)
			{
				for(propertyName in Reflect.fields(this._verticalScrollBarProperties.storage))
				{
					propertyValue = Reflect.field(this._verticalScrollBarProperties.storage, propertyName);
					Reflect.setProperty(this.verticalScrollBar, propertyName, propertyValue);
				}
			}
			if(this._verticalScrollBarHideTween != null)
			{
				Starling.current.juggler.remove(this._verticalScrollBarHideTween);
				this._verticalScrollBarHideTween = null;
			}
			this.verticalScrollBar.alpha = this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT ? 0 : 1;
		}
	}

	/**
	 * @private
	 */
	private function refreshEnabled():Void
	{
		if(this._viewPort != null)
		{
			this._viewPort.isEnabled = this._isEnabled;
		}
		if(this.horizontalScrollBar != null)
		{
			this.horizontalScrollBar.isEnabled = this._isEnabled;
		}
		if(this.verticalScrollBar != null)
		{
			this.verticalScrollBar.isEnabled = this._isEnabled;
		}
	}

	/**
	 * @private
	 */
	override private function refreshFocusIndicator():Void
	{
		if(this._focusIndicatorSkin)
		{
			if(this._hasFocus && this._showFocus)
			{
				if(this._focusIndicatorSkin.parent != this)
				{
					this.addRawChildInternal(this._focusIndicatorSkin);
				}
				else
				{
					this.setRawChildIndexInternal(this._focusIndicatorSkin, this.numRawChildrenInternal - 1);
				}
			}
			else if(this._focusIndicatorSkin.parent == this)
			{
				this.removeRawChildInternal(this._focusIndicatorSkin, false);
			}
			this._focusIndicatorSkin.x = this._focusPaddingLeft;
			this._focusIndicatorSkin.y = this._focusPaddingTop;
			this._focusIndicatorSkin.width = this.actualWidth - this._focusPaddingLeft - this._focusPaddingRight;
			this._focusIndicatorSkin.height = this.actualHeight - this._focusPaddingTop - this._focusPaddingBottom;
		}
	}

	/**
	 * @private
	 */
	private function refreshViewPortBoundsWithoutFixedScrollBars():Void
	{
		var horizontalWidthOffset:Float = this._leftViewPortOffset + this._rightViewPortOffset;
		var verticalHeightOffset:Float = this._topViewPortOffset + this._bottomViewPortOffset;

		//if scroll bars are fixed, we're going to include the offsets even
		//if they may not be needed in the final pass. if not fixed, the
		//view port fills the entire bounds.
		this._viewPort.visibleWidth = this.explicitWidth - horizontalWidthOffset;
		this._viewPort.visibleHeight = this.explicitHeight - verticalHeightOffset;
		var minVisibleWidth:Number = this._minWidth - horizontalWidthOffset;
		if(this.originalBackgroundWidth === this.originalBackgroundWidth && //!isNaN
		 this.originalBackgroundWidth > minVisibleWidth)
		{
			//to avoid going through the loop too many times, we need to
			//account for the background skin's size.
			minVisibleWidth = this.originalBackgroundWidth;
		}
		if(minVisibleWidth < 0)
		{
			minVisibleWidth = 0;
		}
		this._viewPort.minVisibleWidth = minVisibleWidth;
		this._viewPort.maxVisibleWidth = this._maxWidth - horizontalWidthOffset;
		var minVisibleHeight:Number = this._minHeight - verticalHeightOffset;
		if(this.originalBackgroundHeight === this.originalBackgroundHeight && //!isNaN
			this.originalBackgroundHeight > minVisibleHeight)
		{
			//see note above about the background skin size
			minVisibleHeight = this.originalBackgroundHeight;
		}
		if(minVisibleHeight < 0)
		{
			minVisibleHeight = 0;
		}
		this._viewPort.minVisibleHeight = minVisibleHeight;
		this._viewPort.maxVisibleHeight = this._maxHeight - verticalHeightOffset;
		this._viewPort.horizontalScrollPosition = this._horizontalScrollPosition;
		this._viewPort.verticalScrollPosition = this._verticalScrollPosition;

		var oldIgnoreViewPortResizing:Bool = this.ignoreViewPortResizing;
		if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
		{
			this.ignoreViewPortResizing = true;
		}
		this._viewPort.validate();
		this.ignoreViewPortResizing = oldIgnoreViewPortResizing;
	}

	/**
	 * @private
	 */
	private function refreshViewPortBoundsWithFixedScrollBars():Void
	{
		var horizontalWidthOffset:Float = this._leftViewPortOffset + this._rightViewPortOffset;
		var verticalHeightOffset:Float = this._topViewPortOffset + this._bottomViewPortOffset;
		var needsWidthOrHeight:Bool = this.explicitWidth != this.explicitWidth ||
			this.explicitHeight != this.explicitHeight; //isNaN
		if(!(this._measureViewPort && needsWidthOrHeight))
		{
			//if we didn't need to do any measurement, we would have skipped
			//setting this stuff earlier, and now is the last chance
			var minVisibleWidth:Number = this._minWidth - horizontalWidthOffset;
			if(this.originalBackgroundWidth === this.originalBackgroundWidth && //!isNaN
				this.originalBackgroundWidth > minVisibleWidth)
			{
				//to avoid going through the loop too many times, we need to
				//account for the background skin's size
				minVisibleWidth = this.originalBackgroundWidth;
			}
			if(minVisibleWidth < 0)
			{
				minVisibleWidth = 0;
			}
			this._viewPort.minVisibleWidth = minVisibleWidth;
			this._viewPort.maxVisibleWidth = this._maxWidth - horizontalWidthOffset;
			var minVisibleHeight:Number = this._minHeight - verticalHeightOffset;
			if(this.originalBackgroundHeight === this.originalBackgroundHeight && //!isNaN
				this.originalBackgroundHeight > minVisibleHeight)
			{
				//see note above about the background skin size
				minVisibleHeight = this.originalBackgroundHeight;
			}
			if(minVisibleHeight < 0)
			{
				minVisibleHeight = 0;
			}
			this._viewPort.minVisibleHeight = minVisibleHeight;
			this._viewPort.maxVisibleHeight = this._maxHeight - verticalHeightOffset;
			this._viewPort.horizontalScrollPosition = this._horizontalScrollPosition;
			this._viewPort.verticalScrollPosition = this._verticalScrollPosition;
		}
		this._viewPort.visibleWidth = this.actualWidth - horizontalWidthOffset;
		this._viewPort.visibleHeight = this.actualHeight - verticalHeightOffset;
		this._viewPort.validate();
	}

	/**
	 * @private
	 */
	private function refreshScrollValues():Void
	{
		this.refreshScrollSteps();

		var oldMaxHSP:Float = this._maxHorizontalScrollPosition;
		var oldMaxVSP:Float = this._maxVerticalScrollPosition;
		this.refreshMinAndMaxScrollPositions();
		var maximumPositionsChanged:Bool = this._maxHorizontalScrollPosition != oldMaxHSP || this._maxVerticalScrollPosition != oldMaxVSP;
		if(maximumPositionsChanged && this._touchPointID < 0)
		{
			this.clampScrollPositions();
		}

		this.refreshPageCount();
		this.refreshPageIndices();
	}

	/**
	 * @private
	 */
	private function clampScrollPositions():Void
	{
		if(this._horizontalAutoScrollTween == null)
		{
			if(this._snapToPages)
			{
				this._horizontalScrollPosition = roundToNearest(this._horizontalScrollPosition, this.actualPageWidth);
			}
			var targetHorizontalScrollPosition:Float = this._horizontalScrollPosition;
			if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
			{
				targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
			}
			else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
			}
			this.horizontalScrollPosition = targetHorizontalScrollPosition;
		}
		if(this._verticalAutoScrollTween == null)
		{
			if(this._snapToPages)
			{
				this._verticalScrollPosition = roundToNearest(this._verticalScrollPosition, this.actualPageHeight);
			}
			var targetVerticalScrollPosition:Float = this._verticalScrollPosition;
			if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
			{
				targetVerticalScrollPosition = this._minVerticalScrollPosition;
			}
			else if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
			{
				targetVerticalScrollPosition = this._maxVerticalScrollPosition;
			}
			this.verticalScrollPosition = targetVerticalScrollPosition;
		}
	}

	/**
	 * @private
	 */
	private function refreshScrollSteps():Void
	{
		if(this.explicitHorizontalScrollStep != this.explicitHorizontalScrollStep) //isNaN
		{
			if(this._viewPort != null)
			{
				this.actualHorizontalScrollStep = this._viewPort.horizontalScrollStep;
			}
			else
			{
				this.actualHorizontalScrollStep = 1;
			}
		}
		else
		{
			this.actualHorizontalScrollStep = this.explicitHorizontalScrollStep;
		}
		if(this.explicitVerticalScrollStep != this.explicitVerticalScrollStep) //isNaN
		{
			if(this._viewPort != null)
			{
				this.actualVerticalScrollStep = this._viewPort.verticalScrollStep;
			}
			else
			{
				this.actualVerticalScrollStep = 1;
			}
		}
		else
		{
			this.actualVerticalScrollStep = this.explicitVerticalScrollStep;
		}
	}

	/**
	 * @private
	 */
	private function refreshMinAndMaxScrollPositions():Void
	{
		var visibleViewPortWidth:Float = this.actualWidth - (this._leftViewPortOffset + this._rightViewPortOffset);
		var visibleViewPortHeight:Float = this.actualHeight - (this._topViewPortOffset + this._bottomViewPortOffset);
		if(this.explicitPageWidth != this.explicitPageWidth) //isNaN
		{
			this.actualPageWidth = visibleViewPortWidth;
		}
		if(this.explicitPageHeight != this.explicitPageHeight) //isNaN
		{
			this.actualPageHeight = visibleViewPortHeight;
		}
		if(this._viewPort != null)
		{
			this._minHorizontalScrollPosition = this._viewPort.contentX;
			if(this._viewPort.width == Number.POSITIVE_INFINITY)
			{
				//we don't want to risk the possibility of negative infinity
				//being added to positive infinity. the result is NaN.
				this._maxHorizontalScrollPosition = Number.POSITIVE_INFINITY;
			}
			else
			{
				this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition + this._viewPort.width - visibleViewPortWidth;
			}
			if(this._maxHorizontalScrollPosition < this._minHorizontalScrollPosition)
			{
				this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition;
			}
			this._minVerticalScrollPosition = this._viewPort.contentY;
			if(this._viewPort.height == Number.POSITIVE_INFINITY)
			{
				//we don't want to risk the possibility of negative infinity
				//being added to positive infinity. the result is NaN.
				this._maxVerticalScrollPosition = Number.POSITIVE_INFINITY;
			}
			else
			{
				this._maxVerticalScrollPosition = this._minVerticalScrollPosition + this._viewPort.height - visibleViewPortHeight;
			}
			if(this._maxVerticalScrollPosition < this._minVerticalScrollPosition)
			{
				this._maxVerticalScrollPosition =  this._minVerticalScrollPosition;
			}
			if(this._snapScrollPositionsToPixels)
			{
				this._minHorizontalScrollPosition = Math.round(this._minHorizontalScrollPosition);
				this._minVerticalScrollPosition = Math.round(this._minVerticalScrollPosition);
				this._maxHorizontalScrollPosition = Math.round(this._maxHorizontalScrollPosition);
				this._maxVerticalScrollPosition = Math.round(this._maxVerticalScrollPosition);
			}
		}
		else
		{
			this._minHorizontalScrollPosition = 0;
			this._minVerticalScrollPosition = 0;
			this._maxHorizontalScrollPosition = 0;
			this._maxVerticalScrollPosition = 0;
		}
	}

	/**
	 * @private
	 */
	private function refreshPageCount():Void
	{
		if(this._snapToPages)
		{
			var horizontalScrollRange:Number = this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition;
			if(horizontalScrollRange == Number.POSITIVE_INFINITY)
			{
				//trying to put positive infinity into an int results in 0
				//so we need a special case to provide a large int value.
				if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY)
				{
					this._minHorizontalPageIndex = int.MIN_VALUE;
				}
				else
				{
					this._minHorizontalPageIndex = 0;
				}
				this._maxHorizontalPageIndex = int.MAX_VALUE;
			}
			else
			{
				this._minHorizontalPageIndex = 0;
				//floating point errors could result in the max page index
				//being 1 larger than it should be.
				var roundedDownRange:Number = roundDownToNearest(horizontalScrollRange, this.actualPageWidth);
				if((horizontalScrollRange - roundedDownRange) < FUZZY_PAGE_SIZE_PADDING)
				{
					horizontalScrollRange = roundedDownRange;
				}
				this._maxHorizontalPageIndex = Math.ceil(horizontalScrollRange / this.actualPageWidth);
			}

			var verticalScrollRange:Number = this._maxVerticalScrollPosition - this._minVerticalScrollPosition;
			if(verticalScrollRange == Number.POSITIVE_INFINITY)
			{
				//trying to put positive infinity into an int results in 0
				//so we need a special case to provide a large int value.
				if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY)
				{
					this._minVerticalPageIndex = int.MIN_VALUE;
				}
				else
				{
					this._minVerticalPageIndex = 0;
				}
				this._maxVerticalPageIndex = int.MAX_VALUE;
			}
			else
			{
				this._minVerticalPageIndex = 0;
				//floating point errors could result in the max page index
				//being 1 larger than it should be.
				roundedDownRange = roundDownToNearest(verticalScrollRange, this.actualPageHeight);
				if((verticalScrollRange - roundedDownRange) < FUZZY_PAGE_SIZE_PADDING)
				{
					verticalScrollRange = roundedDownRange;
				}
				this._maxVerticalPageIndex = Math.ceil(verticalScrollRange / this.actualPageHeight);
			}
		}
		else
		{
			this._maxHorizontalPageIndex = 0;
			this._maxHorizontalPageIndex = 0;
			this._minVerticalPageIndex = 0;
			this._maxVerticalPageIndex = 0;
		}
	}

	/**
	 * @private
	 */
	private function refreshPageIndices():Void
	{
		if(!this._horizontalAutoScrollTween && !this.hasPendingHorizontalPageIndex)
		{
			if(this._snapToPages)
			{
				if(this._horizontalScrollPosition == this._maxHorizontalScrollPosition)
				{
					this._horizontalPageIndex = this._maxHorizontalPageIndex;
				}
				else if(this._horizontalScrollPosition == this._minHorizontalScrollPosition)
				{
					this._horizontalPageIndex = this._minHorizontalPageIndex;
				}
				else if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY && this._horizontalScrollPosition < 0)
				{
					this._horizontalPageIndex = Math.floor(this._horizontalScrollPosition / this.actualPageWidth);
				}
				else if(this._maxHorizontalScrollPosition == Number.POSITIVE_INFINITY && this._horizontalScrollPosition >= 0)
				{
					this._horizontalPageIndex = Math.floor(this._horizontalScrollPosition / this.actualPageWidth);
				}
				else
				{
					var adjustedHorizontalScrollPosition:Float = this._horizontalScrollPosition - this._minHorizontalScrollPosition;
					var unroundedPageIndex:Number = adjustedHorizontalScrollPosition / this.actualPageWidth;
					var nextPageIndex:int = Math.ceil(unroundedPageIndex);
					if(unroundedPageIndex != nextPageIndex && (nextPageIndex - unroundedPageIndex) < FUZZY_PAGE_SIZE_PADDING)
					{
						//we almost always want to round down, but a
						//floating point math error may result in the page
						//index being 1 too small in rare cases.
						this._horizontalPageIndex = nextPageIndex;
					}
					else
					{
						this._horizontalPageIndex = Math.floor(unroundedPageIndex);
					}
				}
			}
			else
			{
				this._horizontalPageIndex = this._minHorizontalPageIndex;
			}
			if(this._horizontalPageIndex < this._minHorizontalPageIndex)
			{
				this._horizontalPageIndex = this._minHorizontalPageIndex;
			}
			if(this._horizontalPageIndex > this._maxHorizontalPageIndex)
			{
				this._horizontalPageIndex = this._maxHorizontalPageIndex;
			}
		}
		if(!this._verticalAutoScrollTween && !this.hasPendingVerticalPageIndex)
		{
			if(this._snapToPages)
			{
				if(this._verticalScrollPosition == this._maxVerticalScrollPosition)
				{
					this._verticalPageIndex = this._maxVerticalPageIndex;
				}
				else if(this._verticalScrollPosition == this._minVerticalScrollPosition)
				{
					this._verticalPageIndex = this._minVerticalPageIndex;
				}
				else if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY && this._verticalScrollPosition < 0)
				{
					this._verticalPageIndex = Math.floor(this._verticalScrollPosition / this.actualPageHeight);
				}
				else if(this._maxVerticalScrollPosition == Number.POSITIVE_INFINITY && this._verticalScrollPosition >= 0)
				{
					this._verticalPageIndex = Math.floor(this._verticalScrollPosition / this.actualPageHeight);
				}
				else
				{
					var adjustedVerticalScrollPosition:Float = this._verticalScrollPosition - this._minVerticalScrollPosition;
					unroundedPageIndex = adjustedVerticalScrollPosition / this.actualPageHeight;
					nextPageIndex = Math.ceil(unroundedPageIndex);
					if(unroundedPageIndex != nextPageIndex && (nextPageIndex - unroundedPageIndex) < FUZZY_PAGE_SIZE_PADDING)
					{
						//we almost always want to round down, but a
						//floating point math error may result in the page
						//index being 1 too small in rare cases.
						this._verticalPageIndex = nextPageIndex;
					}
					else
					{
						this._verticalPageIndex = Math.floor(unroundedPageIndex);
					}
				}
			}
			else
			{
				this._verticalPageIndex = this._minVerticalScrollPosition;
			}
			if(this._verticalPageIndex < this._minVerticalScrollPosition)
			{
				this._verticalPageIndex = this._minVerticalScrollPosition;
			}
			if(this._verticalPageIndex > this._maxVerticalPageIndex)
			{
				this._verticalPageIndex = this._maxVerticalPageIndex;
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshScrollBarValues():Void
	{
		if(this.horizontalScrollBar != null)
		{
			this.horizontalScrollBar.minimum = this._minHorizontalScrollPosition;
			this.horizontalScrollBar.maximum = this._maxHorizontalScrollPosition;
			this.horizontalScrollBar.value = this._horizontalScrollPosition;
			this.horizontalScrollBar.page = (this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition) * this.actualPageWidth / this._viewPort.width;
			this.horizontalScrollBar.step = this.actualHorizontalScrollStep;
		}

		if(this.verticalScrollBar != null)
		{
			this.verticalScrollBar.minimum = this._minVerticalScrollPosition;
			this.verticalScrollBar.maximum = this._maxVerticalScrollPosition;
			this.verticalScrollBar.value = this._verticalScrollPosition;
			this.verticalScrollBar.page = (this._maxVerticalScrollPosition - this._minVerticalScrollPosition) * this.actualPageHeight / this._viewPort.height;
			this.verticalScrollBar.step = this.actualVerticalScrollStep;
		}
	}

	/**
	 * @private
	 */
	private function showOrHideChildren():Void
	{
		var isFixed:Bool = this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED;
		var childCount:Int = this.numRawChildrenInternal;
		if(this.verticalScrollBar != null)
		{
			this.verticalScrollBar.visible = this._hasVerticalScrollBar;
			this.verticalScrollBar.touchable = this._hasVerticalScrollBar && this._interactionMode != INTERACTION_MODE_TOUCH;
			this.setRawChildIndexInternal(cast(this.verticalScrollBar, DisplayObject), childCount - 1);
		}
		if(this.horizontalScrollBar != null)
		{
			this.horizontalScrollBar.visible = this._hasHorizontalScrollBar;
			this.horizontalScrollBar.touchable = this._hasHorizontalScrollBar && this._interactionMode != INTERACTION_MODE_TOUCH;
			if(this.verticalScrollBar != null)
			{
				this.setRawChildIndexInternal(cast(this.horizontalScrollBar, DisplayObject), childCount - 2);
			}
			else
			{
				this.setRawChildIndexInternal(cast(this.horizontalScrollBar, DisplayObject), childCount - 1);
			}
		}
		if(this.currentBackgroundSkin != null)
		{
			if(this._autoHideBackground)
			{
				this.currentBackgroundSkin.visible = this._viewPort.width < this.actualWidth ||
					this._viewPort.height < this.actualHeight ||
					this._horizontalScrollPosition < 0 ||
					this._horizontalScrollPosition > this._maxHorizontalScrollPosition ||
					this._verticalScrollPosition < 0 ||
					this._verticalScrollPosition > this._maxVerticalScrollPosition;
			}
			else
			{
				this.currentBackgroundSkin.visible = true;
			}
		}

	}

	/**
	 * @private
	 */
	private function calculateViewPortOffsetsForFixedHorizontalScrollBar(forceScrollBars:Bool = false, useActualBounds:Bool = false):Void
	{
		if(this.horizontalScrollBar != null && (this._measureViewPort || useActualBounds))
		{
			var scrollerWidth:Float = useActualBounds ? this.actualWidth : this.explicitWidth;
			var totalWidth:Float = this._viewPort.width + this._leftViewPortOffset + this._rightViewPortOffset;
			if(forceScrollBars || this._horizontalScrollPolicy == SCROLL_POLICY_ON ||
				((totalWidth > scrollerWidth || totalWidth > this._maxWidth) &&
					this._horizontalScrollPolicy != SCROLL_POLICY_OFF))
			{
				this._hasHorizontalScrollBar = true;
				if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
				{
					this._bottomViewPortOffset += this.horizontalScrollBar.height;
				}
			}
			else
			{
				this._hasHorizontalScrollBar = false;
			}
		}
		else
		{
			this._hasHorizontalScrollBar = false;
		}
	}

	/**
	 * @private
	 */
	private function calculateViewPortOffsetsForFixedVerticalScrollBar(forceScrollBars:Bool = false, useActualBounds:Bool = false):Void
	{
		if(this.verticalScrollBar != null && (this._measureViewPort || useActualBounds))
		{
			var scrollerHeight:Float = useActualBounds ? this.actualHeight : this.explicitHeight;
			var totalHeight:Float = this._viewPort.height + this._topViewPortOffset + this._bottomViewPortOffset;
			if(forceScrollBars || this._verticalScrollPolicy == SCROLL_POLICY_ON ||
				((totalHeight > scrollerHeight || totalHeight > this._maxHeight) &&
					this._verticalScrollPolicy != SCROLL_POLICY_OFF))
			{
				this._hasVerticalScrollBar = true;
				if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
				{
					if(this._verticalScrollBarPosition == VERTICAL_SCROLL_BAR_POSITION_LEFT)
					{
						this._leftViewPortOffset += this.verticalScrollBar.width;
					}
					else
					{
						this._rightViewPortOffset += this.verticalScrollBar.width;
					}
				}
			}
			else
			{
				this._hasVerticalScrollBar = false;
			}
		}
		else
		{
			this._hasVerticalScrollBar = false;
		}
	}

	/**
	 * @private
	 */
	private function calculateViewPortOffsets(forceScrollBars:Bool = false, useActualBounds:Bool = false):Void
	{
		//in fixed mode, if we determine that scrolling is required, we
		//remember the offsets for later. if scrolling is not needed, then
		//we will ignore the offsets from here forward
		this._topViewPortOffset = this._paddingTop;
		this._rightViewPortOffset = this._paddingRight;
		this._bottomViewPortOffset = this._paddingBottom;
		this._leftViewPortOffset = this._paddingLeft;
		this.calculateViewPortOffsetsForFixedHorizontalScrollBar(forceScrollBars, useActualBounds);
		this.calculateViewPortOffsetsForFixedVerticalScrollBar(forceScrollBars, useActualBounds);
		//we need to double check the horizontal scroll bar if the scroll
		//bars are fixed because adding a vertical scroll bar may require a
		//horizontal one too.
		if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED &&
			this._hasVerticalScrollBar && !this._hasHorizontalScrollBar)
		{
			this.calculateViewPortOffsetsForFixedHorizontalScrollBar(forceScrollBars, useActualBounds);
		}
	}

	/**
	 * @private
	 */
	private function refreshInteractionModeEvents():Void
	{
		if(this._interactionMode == INTERACTION_MODE_TOUCH || this._interactionMode == INTERACTION_MODE_TOUCH_AND_SCROLL_BARS)
		{
			this.addEventListener(TouchEvent.TOUCH, scroller_touchHandler);
			if(this._touchBlocker == null)
			{
				this._touchBlocker = new Quad(100, 100, 0xff00ff);
				this._touchBlocker.alpha = 0;
			}
		}
		else
		{
			this.removeEventListener(TouchEvent.TOUCH, scroller_touchHandler);
			if(this._touchBlocker != null)
			{
				this.removeRawChildInternal(this._touchBlocker, true);
				this._touchBlocker = null;
			}
		}

		if((this._interactionMode == INTERACTION_MODE_MOUSE || this._interactionMode == INTERACTION_MODE_TOUCH_AND_SCROLL_BARS) &&
			this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
		{
			if(this.horizontalScrollBar != null)
			{
				this.horizontalScrollBar.addEventListener(TouchEvent.TOUCH, horizontalScrollBar_touchHandler);
			}
			if(this.verticalScrollBar != null)
			{
				this.verticalScrollBar.addEventListener(TouchEvent.TOUCH, verticalScrollBar_touchHandler);
			}
		}
		else
		{
			if(this.horizontalScrollBar != null)
			{
				this.horizontalScrollBar.removeEventListener(TouchEvent.TOUCH, horizontalScrollBar_touchHandler);
			}
			if(this.verticalScrollBar != null)
			{
				this.verticalScrollBar.removeEventListener(TouchEvent.TOUCH, verticalScrollBar_touchHandler);
			}
		}
	}

	/**
	 * Positions and sizes children based on the actual width and height
	 * values.
	 */
	private function layoutChildren():Void
	{
		if(this.currentBackgroundSkin != null)
		{
			this.currentBackgroundSkin.width = this.actualWidth;
			this.currentBackgroundSkin.height = this.actualHeight;
		}

		if(this.horizontalScrollBar != null)
		{
			this.horizontalScrollBar.validate();
		}
		if(this.verticalScrollBar != null)
		{
			this.verticalScrollBar.validate();
		}
		if(this._touchBlocker != null)
		{
			this._touchBlocker.x = this._leftViewPortOffset;
			this._touchBlocker.y = this._topViewPortOffset;
			this._touchBlocker.width = this._viewPort.visibleWidth;
			this._touchBlocker.height = this._viewPort.visibleHeight;
		}

		this._viewPort.x = this._leftViewPortOffset - this._horizontalScrollPosition;
		this._viewPort.y = this._topViewPortOffset - this._verticalScrollPosition;

		if(this.horizontalScrollBar != null)
		{
			this.horizontalScrollBar.x = this._leftViewPortOffset;
			this.horizontalScrollBar.y = this._topViewPortOffset + this._viewPort.visibleHeight;
			if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				this.horizontalScrollBar.y -= this.horizontalScrollBar.height;
				if((this._hasVerticalScrollBar || this._verticalScrollBarHideTween != null) && this.verticalScrollBar != null)
				{
					this.horizontalScrollBar.width = this._viewPort.visibleWidth - this.verticalScrollBar.width;
				}
				else
				{
					this.horizontalScrollBar.width = this._viewPort.visibleWidth;
				}
			}
			else
			{
				this.horizontalScrollBar.width = this._viewPort.visibleWidth;
			}
		}

		if(this.verticalScrollBar != null)
		{
			if(this._verticalScrollBarPosition == VERTICAL_SCROLL_BAR_POSITION_LEFT)
			{
				this.verticalScrollBar.x = this._paddingLeft;
			}
			else
			{
				this.verticalScrollBar.x = this._leftViewPortOffset + this._viewPort.visibleWidth;
			}
			this.verticalScrollBar.y = this._topViewPortOffset;
			if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				this.verticalScrollBar.x -= this.verticalScrollBar.width;
				if((this._hasHorizontalScrollBar || this._horizontalScrollBarHideTween != null) && this.horizontalScrollBar != null)
				{
					this.verticalScrollBar.height = this._viewPort.visibleHeight - this.horizontalScrollBar.height;
				}
				else
				{
					this.verticalScrollBar.height = this._viewPort.visibleHeight;
				}
			}
			else
			{
				this.verticalScrollBar.height = this._viewPort.visibleHeight;
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshClipRect():Void
	{
		if(!this._clipContent)
		{
			return;
		}
		var clipRect:Rectangle = this._viewPort.clipRect;
		if(!clipRect)
		{
			clipRect = new Rectangle();
		}
		clipRect.x = this._horizontalScrollPosition;
		clipRect.y = this._verticalScrollPosition;
		var clipWidth:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
		if(clipWidth < 0)
		{
			clipWidth = 0;
		}
		clipRect.width = clipWidth;
		var clipHeight:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
		if(clipHeight < 0)
		{
			clipHeight = 0;
		}
		clipRect.height = clipHeight;
		this._viewPort.clipRect = clipRect;
	}

	/**
	 * @private
	 */
	private var numRawChildrenInternal(get, never):Int;
	private function get_numRawChildrenInternal():Int
	{
		if(Std.is(this, IScrollContainer))
		{
			return cast(this, IScrollContainer).numRawChildren;
		}
		return this.numChildren;
	}

	/**
	 * @private
	 */
	private function addRawChildInternal(child:DisplayObject):DisplayObject
	{
		if(Std.is(this, IScrollContainer))
		{
			return cast(this, IScrollContainer).addRawChild(child);
		}
		return this.addChild(child);
	}

	/**
	 * @private
	 */
	private function addRawChildAtInternal(child:DisplayObject, index:Int):DisplayObject
	{
		if(Std.is(this, IScrollContainer))
		{
			return cast(this, IScrollContainer).addRawChildAt(child, index);
		}
		return this.addChildAt(child, index);
	}

	/**
	 * @private
	 */
	private function removeRawChildInternal(child:DisplayObject, dispose:Bool = false):DisplayObject
	{
		if(Std.is(this, IScrollContainer))
		{
			return cast(this, IScrollContainer).removeRawChild(child, dispose);
		}
		return this.removeChild(child, dispose);
	}

	/**
	 * @private
	 */
	private function removeRawChildAtInternal(index:Int, dispose:Bool = false):DisplayObject
	{
		if(Std.is(this, IScrollContainer))
		{
			return cast(this, IScrollContainer).removeRawChildAt(index, dispose);
		}
		return this.removeChildAt(index, dispose);
	}

	/**
	 * @private
	 */
	private function setRawChildIndexInternal(child:DisplayObject, index:Int):Void
	{
		if(Std.is(this, IScrollContainer))
		{
			IScrollContainer(this).setRawChildIndex(child, index);
			return;
		}
		this.setChildIndex(child, index);
	}

	/**
	 * @private
	 */
	private function updateHorizontalScrollFromTouchPosition(touchX:Float):Void
	{
		var offset:Float = this._startTouchX - touchX;
		var position:Float = this._startHorizontalScrollPosition + offset;
		if(position < this._minHorizontalScrollPosition)
		{
			if(this._hasElasticEdges)
			{
				position -= (position - this._minHorizontalScrollPosition) * (1 - this._elasticity);
			}
			else
			{
				position = this._minHorizontalScrollPosition;
			}
		}
		else if(position > this._maxHorizontalScrollPosition)
		{
			if(this._hasElasticEdges)
			{
				position -= (position - this._maxHorizontalScrollPosition) * (1 - this._elasticity);
			}
			else
			{
				position = this._maxHorizontalScrollPosition;
			}
		}
		this.horizontalScrollPosition = position;
	}

	/**
	 * @private
	 */
	private function updateVerticalScrollFromTouchPosition(touchY:Float):Void
	{
		var offset:Float = this._startTouchY - touchY;
		var position:Float = this._startVerticalScrollPosition + offset;
		if(position < this._minVerticalScrollPosition)
		{
			if(this._hasElasticEdges)
			{
				position -= (position - this._minVerticalScrollPosition) * (1 - this._elasticity);
			}
			else
			{
				position = this._minVerticalScrollPosition;
			}
		}
		else if(position > this._maxVerticalScrollPosition)
		{
			if(this._hasElasticEdges)
			{
				position -= (position - this._maxVerticalScrollPosition) * (1 - this._elasticity);
			}
			else
			{
				position = this._maxVerticalScrollPosition;
			}
		}
		this.verticalScrollPosition = position;
	}

	/**
	 * Immediately throws the scroller to the specified position, with
	 * optional animation. If you want to throw in only one direction, pass
	 * in <code>NaN</code> for the value that you do not want to change. The
	 * scroller should be validated before throwing.
	 *
	 * @see #scrollToPosition()
	 */
	private function throwTo(targetHorizontalScrollPosition:Null<Float> = null, targetVerticalScrollPosition:Null<Float> = null, duration:Float = 0.5):Void
	{
		if (targetHorizontalScrollPosition == null) targetHorizontalScrollPosition = Math.NaN;
		if (targetVerticalScrollPosition == null) targetVerticalScrollPosition = Math.NaN;
		var changedPosition:Bool = false;
		if(targetHorizontalScrollPosition == targetHorizontalScrollPosition) //!isNaN
		{
			if(this._snapToPages && targetHorizontalScrollPosition > this._minHorizontalScrollPosition &&
				targetHorizontalScrollPosition < this._maxHorizontalScrollPosition)
			{
				targetHorizontalScrollPosition = roundToNearest(targetHorizontalScrollPosition, this.actualPageWidth);
			}
			if(this._horizontalAutoScrollTween)
			{
				Starling.current.juggler.remove(this._horizontalAutoScrollTween);
				this._horizontalAutoScrollTween = null;
			}
			if(this._horizontalScrollPosition != targetHorizontalScrollPosition)
			{
				changedPosition = true;
				this.revealHorizontalScrollBar();
				this.startScroll();
				if(duration == 0)
				{
					this.horizontalScrollPosition = targetHorizontalScrollPosition;
				}
				else
				{
					this._startHorizontalScrollPosition = this._horizontalScrollPosition;
					this._targetHorizontalScrollPosition = targetHorizontalScrollPosition;
					this._horizontalAutoScrollTween = new Tween(this, duration, this._throwEase);
					this._horizontalAutoScrollTween.animate("horizontalScrollPosition", targetHorizontalScrollPosition);
					//warning: if you try to set onUpdate here, it may be
					//replaced elsewhere.
					this._horizontalAutoScrollTween.onComplete = horizontalAutoScrollTween_onComplete;
					Starling.juggler.add(this._horizontalAutoScrollTween);
					this.refreshHorizontalAutoScrollTweenEndRatio();
				}
			}
			else
			{
				this.finishScrollingHorizontally();
			}
		}

		if(targetVerticalScrollPosition == targetVerticalScrollPosition) //!isNaN
		{
			if(this._snapToPages && targetVerticalScrollPosition > this._minVerticalScrollPosition &&
				targetVerticalScrollPosition < this._maxVerticalScrollPosition)
			{
				targetVerticalScrollPosition = roundToNearest(targetVerticalScrollPosition, this.actualPageHeight);
			}
			if(this._verticalAutoScrollTween)
			{
				Starling.current.juggler.remove(this._verticalAutoScrollTween);
				this._verticalAutoScrollTween = null;
			}
			if(this._verticalScrollPosition != targetVerticalScrollPosition)
			{
				changedPosition = true;
				this.revealVerticalScrollBar();
				this.startScroll();
				if(duration == 0)
				{
					this.verticalScrollPosition = targetVerticalScrollPosition;
				}
				else
				{
					this._startVerticalScrollPosition = this._verticalScrollPosition;
					this._targetVerticalScrollPosition = targetVerticalScrollPosition;
					this._verticalAutoScrollTween = new Tween(this, duration, this._throwEase);
					this._verticalAutoScrollTween.animate("verticalScrollPosition", targetVerticalScrollPosition);
					//warning: if you try to set onUpdate here, it may be
					//replaced elsewhere.
					this._verticalAutoScrollTween.onComplete = verticalAutoScrollTween_onComplete;
					Starling.juggler.add(this._verticalAutoScrollTween);
					this.refreshVerticalAutoScrollTweenEndRatio();
				}
			}
			else
			{
				this.finishScrollingVertically();
			}
		}

		if(changedPosition && duration == 0)
		{
			this.completeScroll();
		}
	}

	/**
	 * Immediately throws the scroller to the specified page index, with
	 * optional animation. If you want to throw in only one direction, pass
	 * in the value from the <code>horizontalPageIndex</code> or
	 * <code>verticalPageIndex</code> property to the appropriate parameter.
	 * The scroller must be validated before throwing, to ensure that the
	 * minimum and maximum scroll positions are accurate.
	 *
	 * @see #scrollToPageIndex()
	 */
	private function throwToPage(targetHorizontalPageIndex:int, targetVerticalPageIndex:int, duration:Number = 0.5):Void
	{
		var targetHorizontalScrollPosition:Float = this._horizontalScrollPosition;
		if(targetHorizontalPageIndex >= this._minHorizontalPageIndex)
		{
			targetHorizontalScrollPosition = this.actualPageWidth * targetHorizontalPageIndex;
		}
		if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
		{
			targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
		}
		if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
		{
			targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
		}
		var targetVerticalScrollPosition:Float = this._verticalScrollPosition;
		if(targetVerticalPageIndex >= this._minVerticalPageIndex)
		{
			targetVerticalScrollPosition = this.actualPageHeight * targetVerticalPageIndex;
		}
		if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
		{
			targetVerticalScrollPosition = this._minVerticalScrollPosition;
		}
		if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
		{
			targetVerticalScrollPosition = this._maxVerticalScrollPosition;
		}
		if(duration > 0)
		{
			this.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, duration);
		}
		else
		{
			this.horizontalScrollPosition = targetHorizontalScrollPosition;
			this.verticalScrollPosition = targetVerticalScrollPosition;
		}
		if(targetHorizontalPageIndex >= this._minHorizontalPageIndex)
		{
			this._horizontalPageIndex = targetHorizontalPageIndex;
		}
		if(targetVerticalPageIndex >= this._minVerticalPageIndex)
		{
			this._verticalPageIndex = targetVerticalPageIndex;
		}
	}

	/**
	 * @private
	 */
	private function calculateDynamicThrowDuration(pixelsPerMS:Float):Float
	{
		return (Math.log(MINIMUM_VELOCITY / Math.abs(pixelsPerMS)) / this._logDecelerationRate) / 1000;
	}

	/**
	 * @private
	 */
	private function calculateThrowDistance(pixelsPerMS:Float):Float
	{
		return (pixelsPerMS - MINIMUM_VELOCITY) / this._logDecelerationRate;
	}

	/**
	 * @private
	 */
	private function finishScrollingHorizontally():Void
	{
		var targetHorizontalScrollPosition:Float = Math.NaN;
		if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
		{
			targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
		}
		else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
		{
			targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
		}

		this._isDraggingHorizontally = false;
		if(targetHorizontalScrollPosition != targetHorizontalScrollPosition) //isNaN
		{
			this.completeScroll();
		}
		else if(Math.abs(targetHorizontalScrollPosition - this._horizontalScrollPosition) < 1)
		{
			//this distance is too small to animate. just finish now.
			this.horizontalScrollPosition = targetHorizontalScrollPosition;
			this.completeScroll();
		}
		else
		{
			this.throwTo(targetHorizontalScrollPosition, Math.NaN, this._elasticSnapDuration);
		}
	}

	/**
	 * @private
	 */
	private function finishScrollingVertically():Void
	{
		var targetVerticalScrollPosition:Float = Math.NaN;
		if(this._verticalScrollPosition < this._minVerticalScrollPosition)
		{
			targetVerticalScrollPosition = this._minVerticalScrollPosition;
		}
		else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
		{
			targetVerticalScrollPosition = this._maxVerticalScrollPosition;
		}

		this._isDraggingVertically = false;
		if(targetVerticalScrollPosition != targetVerticalScrollPosition) //isNaN
		{
			this.completeScroll();
		}
		else if(Math.abs(targetVerticalScrollPosition - this._verticalScrollPosition) < 1)
		{
			//this distance is too small to animate. just finish now.
			this.verticalScrollPosition = targetVerticalScrollPosition;
			this.completeScroll();
		}
		else
		{
			this.throwTo(Math.NaN, targetVerticalScrollPosition, this._elasticSnapDuration);
		}
	}

	/**
	 * @private
	 */
	private function throwHorizontally(pixelsPerMS:Float):Void
	{
		if(this._snapToPages && !this._snapOnComplete)
		{
			var inchesPerSecond:Float = 1000 * pixelsPerMS / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
			var snappedPageHorizontalScrollPosition:Float;
			if(inchesPerSecond > this._minimumPageThrowVelocity)
			{
				snappedPageHorizontalScrollPosition = roundDownToNearest(this._horizontalScrollPosition, this.actualPageWidth);
			}
			else if(inchesPerSecond < -this._minimumPageThrowVelocity)
			{
				snappedPageHorizontalScrollPosition = roundUpToNearest(this._horizontalScrollPosition, this.actualPageWidth);
			}
			else
			{
				var lastPageWidth:Float = this._maxHorizontalScrollPosition % this.actualPageWidth;
				var startOfLastPage:Float = this._maxHorizontalScrollPosition - lastPageWidth;
				if(lastPageWidth < this.actualPageWidth && this._horizontalScrollPosition >= startOfLastPage)
				{
					var lastPagePosition:Float = this._horizontalScrollPosition - startOfLastPage;
					if(inchesPerSecond > this._minimumPageThrowVelocity)
					{
						snappedPageHorizontalScrollPosition = startOfLastPage + roundDownToNearest(lastPagePosition, lastPageWidth);
					}
					else if(inchesPerSecond < -this._minimumPageThrowVelocity)
					{
						snappedPageHorizontalScrollPosition = startOfLastPage + roundUpToNearest(lastPagePosition, lastPageWidth);
					}
					else
					{
						snappedPageHorizontalScrollPosition = startOfLastPage + roundToNearest(lastPagePosition, lastPageWidth);
					}
				}
				else
				{
					snappedPageHorizontalScrollPosition = roundToNearest(this._horizontalScrollPosition, this.actualPageWidth);
				}
			}
			var targetHorizontalPageIndex:Int;
			if(snappedPageHorizontalScrollPosition < this._minHorizontalScrollPosition)
			{
				snappedPageHorizontalScrollPosition = this._minHorizontalScrollPosition;
			}
			else if(snappedPageHorizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				snappedPageHorizontalScrollPosition = this._maxHorizontalScrollPosition;
			}
			if(snappedPageHorizontalScrollPosition == this._maxHorizontalScrollPosition)
			{
				var targetHorizontalPageIndex:int = this._maxHorizontalPageIndex;
			}
			else
			{
				//we need to use Math.round() on these values to avoid
				//floating-point errors that could result in the values
				//being rounded down too far.
				if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY)
				{
					targetHorizontalPageIndex = Math.round(snappedPageHorizontalScrollPosition / this.actualPageWidth);
				}
				else
				{
					targetHorizontalPageIndex = Math.round((snappedPageHorizontalScrollPosition - this._minHorizontalScrollPosition) / this.actualPageWidth);
				}
			}
			this.throwToPage(targetHorizontalPageIndex, -1, this._pageThrowDuration);
			return;
		}

		var absPixelsPerMS:Float = Math.abs(pixelsPerMS);
		if(!this._snapToPages && absPixelsPerMS <= MINIMUM_VELOCITY)
		{
			this.finishScrollingHorizontally();
			return;
		}

		var duration:Float = this._fixedThrowDuration;
		if(!this._useFixedThrowDuration)
		{
			duration = this.calculateDynamicThrowDuration(pixelsPerMS);
		}
		this.throwTo(this._horizontalScrollPosition + this.calculateThrowDistance(pixelsPerMS), NaN, duration);
	}

	/**
	 * @private
	 */
	private function throwVertically(pixelsPerMS:Float):Void
	{
		if(this._snapToPages && !this._snapOnComplete)
		{
			var inchesPerSecond:Float = 1000 * pixelsPerMS / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
			var snappedPageVerticalScrollPosition:Float;
			if(inchesPerSecond > this._minimumPageThrowVelocity)
			{
				snappedPageVerticalScrollPosition = roundDownToNearest(this._verticalScrollPosition, this.actualPageHeight);
			}
			else if(inchesPerSecond < -this._minimumPageThrowVelocity)
			{
				snappedPageVerticalScrollPosition = roundUpToNearest(this._verticalScrollPosition, this.actualPageHeight);
			}
			else
			{
				var lastPageHeight:Float = this._maxVerticalScrollPosition % this.actualPageHeight;
				var startOfLastPage:Float = this._maxVerticalScrollPosition - lastPageHeight;
				if(lastPageHeight < this.actualPageHeight && this._verticalScrollPosition >= startOfLastPage)
				{
					var lastPagePosition:Float = this._verticalScrollPosition - startOfLastPage;
					if(inchesPerSecond > this._minimumPageThrowVelocity)
					{
						snappedPageVerticalScrollPosition = startOfLastPage + roundDownToNearest(lastPagePosition, lastPageHeight);
					}
					else if(inchesPerSecond < -this._minimumPageThrowVelocity)
					{
						snappedPageVerticalScrollPosition = startOfLastPage + roundUpToNearest(lastPagePosition, lastPageHeight);
					}
					else
					{
						snappedPageVerticalScrollPosition = startOfLastPage + roundToNearest(lastPagePosition, lastPageHeight);
					}
				}
				else
				{
					snappedPageVerticalScrollPosition = roundToNearest(this._verticalScrollPosition, this.actualPageHeight);
				}
			}
			if(snappedPageVerticalScrollPosition < this._minVerticalScrollPosition)
			{
				snappedPageVerticalScrollPosition = this._minVerticalScrollPosition;
			}
			else if(snappedPageVerticalScrollPosition > this._maxVerticalScrollPosition)
			{
				snappedPageVerticalScrollPosition = this._maxVerticalScrollPosition;
			}
			var targetVerticalPageIndex:Int;
			if(snappedPageVerticalScrollPosition == this._maxVerticalScrollPosition)
			{
				var targetVerticalPageIndex:int = this._maxVerticalPageIndex;
			}
			else
			{
				//we need to use Math.round() on these values to avoid
				//floating-point errors that could result in the values
				//being rounded down too far.
				if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY)
				{
					targetVerticalPageIndex = Math.round(snappedPageVerticalScrollPosition / this.actualPageHeight);
				}
				else
				{
					targetVerticalPageIndex = Math.round((snappedPageVerticalScrollPosition - this._minVerticalScrollPosition) / this.actualPageHeight);
				}
			}
			this.throwToPage(-1, targetVerticalPageIndex, this._pageThrowDuration);
			return;
		}

		var absPixelsPerMS:Float = Math.abs(pixelsPerMS);
		if(!this._snapToPages && absPixelsPerMS <= MINIMUM_VELOCITY)
		{
			this.finishScrollingVertically();
			return;
		}

		var duration:Float = this._fixedThrowDuration;
		if(!this._useFixedThrowDuration)
		{
			duration = this.calculateDynamicThrowDuration(pixelsPerMS);
		}
		this.throwTo(NaN, this._verticalScrollPosition + this.calculateThrowDistance(pixelsPerMS), duration);
	}

	/**
	 * @private
	 */
	private function onHorizontalAutoScrollTweenUpdate():Void
	{
		var ratio:Float = this._horizontalAutoScrollTween.transitionFunc(this._horizontalAutoScrollTween.currentTime / this._horizontalAutoScrollTween.totalTime);
		if(ratio >= this._horizontalAutoScrollTweenEndRatio)
		{
			if(!this._hasElasticEdges)
			{
				if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
				{
					this._horizontalScrollPosition = this._minHorizontalScrollPosition;
				}
				else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
				}
			}
			Starling.current.juggler.remove(this._horizontalAutoScrollTween);
			this._horizontalAutoScrollTween = null;
			this.finishScrollingHorizontally();
		}
	}

	/**
	 * @private
	 */
	private function onVerticalAutoScrollTweenUpdate():Void
	{
		var ratio:Float = this._verticalAutoScrollTween.transitionFunc(this._verticalAutoScrollTween.currentTime / this._verticalAutoScrollTween.totalTime);
		if(ratio >= this._verticalAutoScrollTweenEndRatio)
		{
			if(!this._hasElasticEdges)
			{
				if(this._verticalScrollPosition < this._minVerticalScrollPosition)
				{
					this._verticalScrollPosition = this._minVerticalScrollPosition;
				}
				else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
				{
					this._verticalScrollPosition = this._maxVerticalScrollPosition;
				}
			}
			Starling.current.juggler.remove(this._verticalAutoScrollTween);
			this._verticalAutoScrollTween = null;
			this.finishScrollingVertically();
		}
	}

	/**
	 * @private
	 */
	private function refreshHorizontalAutoScrollTweenEndRatio():Void
	{
		var distance:Float = Math.abs(this._targetHorizontalScrollPosition - this._startHorizontalScrollPosition);
		var ratioOutOfBounds:Float = 0;
		if(this._targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
		{
			ratioOutOfBounds = (this._targetHorizontalScrollPosition - this._maxHorizontalScrollPosition) / distance;
		}
		else if(this._targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
		{
			ratioOutOfBounds = (this._minHorizontalScrollPosition - this._targetHorizontalScrollPosition) / distance;
		}
		if(ratioOutOfBounds > 0)
		{
			if(this._hasElasticEdges)
			{
				this._horizontalAutoScrollTweenEndRatio = (1 - ratioOutOfBounds) + (ratioOutOfBounds * this._throwElasticity);
			}
			else
			{
				this._horizontalAutoScrollTweenEndRatio = 1 - ratioOutOfBounds;
			}
		}
		else
		{
			this._horizontalAutoScrollTweenEndRatio = 1;
		}
		if(this._horizontalAutoScrollTween != null)
		{
			if(this._horizontalAutoScrollTweenEndRatio < 1)
			{
				this._horizontalAutoScrollTween.onUpdate = onHorizontalAutoScrollTweenUpdate;
			}
			else
			{
				this._horizontalAutoScrollTween.onUpdate = null;
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshVerticalAutoScrollTweenEndRatio():Void
	{
		var distance:Float = Math.abs(this._targetVerticalScrollPosition - this._startVerticalScrollPosition);
		var ratioOutOfBounds:Float = 0;
		if(this._targetVerticalScrollPosition > this._maxVerticalScrollPosition)
		{
			ratioOutOfBounds = (this._targetVerticalScrollPosition - this._maxVerticalScrollPosition) / distance;
		}
		else if(this._targetVerticalScrollPosition < this._minVerticalScrollPosition)
		{
			ratioOutOfBounds = (this._minVerticalScrollPosition - this._targetVerticalScrollPosition) / distance;
		}
		if(ratioOutOfBounds > 0)
		{
			if(this._hasElasticEdges)
			{
				this._verticalAutoScrollTweenEndRatio = (1 - ratioOutOfBounds) + (ratioOutOfBounds * this._throwElasticity);
			}
			else
			{
				this._verticalAutoScrollTweenEndRatio = 1 - ratioOutOfBounds;
			}
		}
		else
		{
			this._verticalAutoScrollTweenEndRatio = 1;
		}
		if(this._verticalAutoScrollTween != null)
		{
			if(this._verticalAutoScrollTweenEndRatio < 1)
			{
				this._verticalAutoScrollTween.onUpdate = onVerticalAutoScrollTweenUpdate;
			}
			else
			{
				this._verticalAutoScrollTween.onUpdate = null;
			}
		}
	}

	/**
	 * @private
	 */
	private function hideHorizontalScrollBar(delay:Float = 0):Void
	{
		if(this.horizontalScrollBar == null || this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT || this._horizontalScrollBarHideTween != null)
		{
			return;
		}
		if(this.horizontalScrollBar.alpha == 0)
		{
			return;
		}
		if(this._hideScrollBarAnimationDuration == 0 && delay == 0)
		{
			this.horizontalScrollBar.alpha = 0;
		}
		else
		{
			this._horizontalScrollBarHideTween = new Tween(this.horizontalScrollBar, this._hideScrollBarAnimationDuration, this._hideScrollBarAnimationEase);
			this._horizontalScrollBarHideTween.fadeTo(0);
			this._horizontalScrollBarHideTween.delay = delay;
			this._horizontalScrollBarHideTween.onComplete = horizontalScrollBarHideTween_onComplete;
			Starling.current.juggler.add(this._horizontalScrollBarHideTween);
		}
	}

	/**
	 * @private
	 */
	private function hideVerticalScrollBar(delay:Float = 0):Void
	{
		if(this.verticalScrollBar == null || this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT || this._verticalScrollBarHideTween != null)
		{
			return;
		}
		if(this.verticalScrollBar.alpha == 0)
		{
			return;
		}
		if(this._hideScrollBarAnimationDuration == 0 && delay == 0)
		{
			this.verticalScrollBar.alpha = 0;
		}
		else
		{
			this._verticalScrollBarHideTween = new Tween(this.verticalScrollBar, this._hideScrollBarAnimationDuration, this._hideScrollBarAnimationEase);
			this._verticalScrollBarHideTween.fadeTo(0);
			this._verticalScrollBarHideTween.delay = delay;
			this._verticalScrollBarHideTween.onComplete = verticalScrollBarHideTween_onComplete;
			Starling.current.juggler.add(this._verticalScrollBarHideTween);
		}
	}

	/**
	 * @private
	 */
	private function revealHorizontalScrollBar():Void
	{
		if(this.horizontalScrollBar == null || this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT)
		{
			return;
		}
		if(this._horizontalScrollBarHideTween != null)
		{
			Starling.current.juggler.remove(this._horizontalScrollBarHideTween);
			this._horizontalScrollBarHideTween = null;
		}
		this.horizontalScrollBar.alpha = 1;
	}

	/**
	 * @private
	 */
	private function revealVerticalScrollBar():Void
	{
		if(this.verticalScrollBar == null || this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT)
		{
			return;
		}
		if(this._verticalScrollBarHideTween != null)
		{
			Starling.current.juggler.remove(this._verticalScrollBarHideTween);
			this._verticalScrollBarHideTween = null;
		}
		this.verticalScrollBar.alpha = 1;
	}

	/**
	 * If scrolling hasn't already started, prepares the scroller to scroll
	 * and dispatches <code>FeathersEventType.SCROLL_START</code>.
	 */
	private function startScroll():Void
	{
		if(this._isScrolling)
		{
			return;
		}
		this._isScrolling = true;
		if(this._touchBlocker != null)
		{
			this.addRawChildInternal(this._touchBlocker);
		}
		this.dispatchEventWith(FeathersEventType.SCROLL_START);
	}

	/**
	 * Prepares the scroller for normal interaction and dispatches
	 * <code>FeathersEventType.SCROLL_COMPLETE</code>.
	 */
	private function completeScroll():Void
	{
		if(!this._isScrolling || this._verticalAutoScrollTween != null || this._horizontalAutoScrollTween != null ||
			this._isDraggingHorizontally || this._isDraggingVertically ||
			this._horizontalScrollBarIsScrolling || this._verticalScrollBarIsScrolling)
		{
			return;
		}
		this._isScrolling = false;
		if(this._touchBlocker != null)
		{
			this.removeRawChildInternal(this._touchBlocker, false);
		}
		this.hideHorizontalScrollBar();
		this.hideVerticalScrollBar();
		//we validate to ensure that the final Event.SCROLL
		//dispatched before FeathersEventType.SCROLL_COMPLETE
		this.validate();
		this.dispatchEventWith(FeathersEventType.SCROLL_COMPLETE);
	}

	/**
	 * Scrolls to a pending scroll position, if required.
	 */
	private function handlePendingScroll():Void
	{
		if(this.pendingHorizontalScrollPosition == this.pendingHorizontalScrollPosition ||
			this.pendingVerticalScrollPosition == this.pendingVerticalScrollPosition) //!isNaN
		{
			this.throwTo(this.pendingHorizontalScrollPosition, this.pendingVerticalScrollPosition, this.pendingScrollDuration);
			this.pendingHorizontalScrollPosition = Math.NaN;
			this.pendingVerticalScrollPosition = Math.NaN;
		}
		if(this.hasPendingHorizontalPageIndex && this.hasPendingVerticalPageIndex)
		{
			//both
			this.throwToPage(this.pendingHorizontalPageIndex, this.pendingVerticalPageIndex, this.pendingScrollDuration);
		}
		else if(this.hasPendingHorizontalPageIndex)
		{
			//horizontal only
			this.throwToPage(this.pendingHorizontalPageIndex, this._verticalPageIndex, this.pendingScrollDuration);
		}
		else if(this.hasPendingVerticalPageIndex)
		{
			//vertical only
			this.throwToPage(this._horizontalPageIndex, this.pendingVerticalPageIndex, this.pendingScrollDuration);
		}
		this.hasPendingHorizontalPageIndex = false;
		this.hasPendingVerticalPageIndex = false;
	}

	/**
	 * @private
	 */
	private function handlePendingRevealScrollBars():Void
	{
		if(!this.isScrollBarRevealPending)
		{
			return;
		}
		this.isScrollBarRevealPending = false;
		if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT)
		{
			return;
		}
		this.revealHorizontalScrollBar();
		this.revealVerticalScrollBar();
		this.hideHorizontalScrollBar(this._revealScrollBarsDuration);
		this.hideVerticalScrollBar(this._revealScrollBarsDuration);
	}

	/**
	 * @private
	 */
	private function viewPort_resizeHandler(event:Event):Void
	{
		if(this.ignoreViewPortResizing ||
			(this._viewPort.width == this._lastViewPortWidth && this._viewPort.height == this._lastViewPortHeight))
		{
			return;
		}
		this._lastViewPortWidth = this._viewPort.width;
		this._lastViewPortHeight = this._viewPort.height;
		if(this._isValidating)
		{
			this._hasViewPortBoundsChanged = true;
		}
		else
		{
			this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		}
	}

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function verticalScrollBar_changeHandler(event:Event):Void
	{
		this.verticalScrollPosition = this.verticalScrollBar.value;
	}

	/**
	 * @private
	 */
	private function horizontalScrollBar_changeHandler(event:Event):Void
	{
		this.horizontalScrollPosition = this.horizontalScrollBar.value;
	}

	/**
	 * @private
	 */
	private function horizontalScrollBar_beginInteractionHandler(event:Event):Void
	{
		if(this._horizontalAutoScrollTween)
		{
			Starling.juggler.remove(this._horizontalAutoScrollTween);
			this._horizontalAutoScrollTween = null;
		}
		this._isDraggingHorizontally = false;
		this._horizontalScrollBarIsScrolling = true;
		this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
		if(!this._isScrolling)
		{
			this.startScroll();
		}
	}

	/**
	 * @private
	 */
	private function horizontalScrollBar_endInteractionHandler(event:Event):Void
	{
		this._horizontalScrollBarIsScrolling = false;
		this.dispatchEventWith(FeathersEventType.END_INTERACTION);
		this.completeScroll();
	}

	/**
	 * @private
	 */
	private function verticalScrollBar_beginInteractionHandler(event:Event):Void
	{
		if(this._verticalAutoScrollTween)
		{
			Starling.juggler.remove(this._verticalAutoScrollTween);
			this._verticalAutoScrollTween = null;
		}
		this._isDraggingVertically = false;
		this._verticalScrollBarIsScrolling = true;
		this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
		if(!this._isScrolling)
		{
			this.startScroll();
		}
	}

	/**
	 * @private
	 */
	private function verticalScrollBar_endInteractionHandler(event:Event):Void
	{
		this._verticalScrollBarIsScrolling = false;
		this.dispatchEventWith(FeathersEventType.END_INTERACTION);
		this.completeScroll();
	}

	/**
	 * @private
	 */
	private function horizontalAutoScrollTween_onComplete():Void
	{
		this._horizontalAutoScrollTween = null;
		//the page index will not have updated during the animation, so we
		//need to ensure that it is updated now.
		this.invalidate(INVALIDATION_FLAG_SCROLL);
		this.finishScrollingHorizontally();
	}

	/**
	 * @private
	 */
	private function verticalAutoScrollTween_onComplete():Void
	{
		this._verticalAutoScrollTween = null;
		//the page index will not have updated during the animation, so we
		//need to ensure that it is updated now.
		this.invalidate(INVALIDATION_FLAG_SCROLL);
		this.finishScrollingVertically();
	}

	/**
	 * @private
	 */
	private function horizontalScrollBarHideTween_onComplete():Void
	{
		this._horizontalScrollBarHideTween = null;
	}

	/**
	 * @private
	 */
	private function verticalScrollBarHideTween_onComplete():Void
	{
		this._verticalScrollBarHideTween = null;
	}

	/**
	 * @private
	 */
	private function scroller_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._touchPointID = -1;
			return;
		}
		if(this._touchPointID >= 0)
		{
			return;
		}

		//any began touch is okay here. we don't need to check all touches.
		var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
		if(touch == null)
		{
			return;
		}

		if(this._interactionMode == INTERACTION_MODE_TOUCH_AND_SCROLL_BARS &&
			(event.interactsWith(cast(this.horizontalScrollBar, DisplayObject)) || event.interactsWith(cast(this.verticalScrollBar, DisplayObject))))
		{
			return;
		}

		touch.getLocation(this, HELPER_POINT);
		var touchX:Float = HELPER_POINT.x;
		var touchY:Float = HELPER_POINT.y;
		if(touchX < this._leftViewPortOffset || touchY < this._topViewPortOffset ||
			touchX >= this.actualWidth - this._rightViewPortOffset ||
			touchY >= this.actualHeight - this._bottomViewPortOffset)
		{
			return;
		}

		var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
		if(exclusiveTouch.getClaim(touch.id) != null)
		{
			//already claimed
			return;
		}

		//if the scroll policy is off, we shouldn't stop this animation
		if(this._horizontalAutoScrollTween != null && this._horizontalScrollPolicy != Scroller.SCROLL_POLICY_OFF)
		{
			Starling.current.juggler.remove(this._horizontalAutoScrollTween);
			this._horizontalAutoScrollTween = null;
			if(this._isScrolling)
			{
				//immediately start dragging, since it was scrolling already
				this._isDraggingHorizontally = true;
			}
		}
		if(this._verticalAutoScrollTween != null && this._verticalScrollPolicy != Scroller.SCROLL_POLICY_OFF)
		{
			Starling.current.juggler.remove(this._verticalAutoScrollTween);
			this._verticalAutoScrollTween = null;
			if(this._isScrolling)
			{
				//immediately start dragging, since it was scrolling already
				this._isDraggingVertically = true;
			}
		}

		this._touchPointID = touch.id;
		this._velocityX = 0;
		this._velocityY = 0;
		this._previousVelocityX.splice(0, this._previousVelocityX.length);
		this._previousVelocityY.splice(0, this._previousVelocityY.length);
		this._previousTouchTime = getTimer();
		this._previousTouchX = this._startTouchX = this._currentTouchX = touchX;
		this._previousTouchY = this._startTouchY = this._currentTouchY = touchY;
		this._startHorizontalScrollPosition = this._horizontalScrollPosition;
		this._startVerticalScrollPosition = this._verticalScrollPosition;
		this._isScrollingStopped = false;

		this.addEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);

		//we need to listen on the stage because if we scroll the bottom or
		//right edge past the top of the scroller, it gets stuck and we stop
		//receiving touch events for "this".
		this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);

		if(this._isScrolling && (this._isDraggingHorizontally || this._isDraggingVertically))
		{
			exclusiveTouch.claimTouch(this._touchPointID, this);
		}
		else
		{
			exclusiveTouch.addEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
		}
	}

	/**
	 * @private
	 */
	private function scroller_enterFrameHandler(event:Event):Void
	{
		if(this._isScrollingStopped)
		{
			return;
		}
		var now:Int = getTimer();
		var timeOffset:Int = now - this._previousTouchTime;
		if(timeOffset > 0)
		{
			//we're keeping previous velocity updates to improve accuracy
			this._previousVelocityX[this._previousVelocityX.length] = this._velocityX;
			if(this._previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
			{
				this._previousVelocityX.shift();
			}
			this._previousVelocityY[this._previousVelocityY.length] = this._velocityY;
			if(this._previousVelocityY.length > MAXIMUM_SAVED_VELOCITY_COUNT)
			{
				this._previousVelocityY.shift();
			}
			this._velocityX = (this._currentTouchX - this._previousTouchX) / timeOffset;
			this._velocityY = (this._currentTouchY - this._previousTouchY) / timeOffset;
			this._previousTouchTime = now;
			this._previousTouchX = this._currentTouchX;
			this._previousTouchY = this._currentTouchY;
		}
		var horizontalInchesMoved:Float = Math.abs(this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
		var verticalInchesMoved:Float = Math.abs(this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
		var exclusiveTouch:ExclusiveTouch;
		if((this._horizontalScrollPolicy == SCROLL_POLICY_ON ||
			(this._horizontalScrollPolicy == SCROLL_POLICY_AUTO && this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition)) &&
			!this._isDraggingHorizontally && horizontalInchesMoved >= this._minimumDragDistance)
		{
			if(this.horizontalScrollBar != null)
			{
				this.revealHorizontalScrollBar();
			}
			this._startTouchX = this._currentTouchX;
			this._startHorizontalScrollPosition = this._horizontalScrollPosition;
			this._isDraggingHorizontally = true;
			//if we haven't already started dragging in the other direction,
			//we need to dispatch the event that says we're starting.
			if(!this._isDraggingVertically)
			{
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
				exclusiveTouch = ExclusiveTouch.forStage(this.stage);
				exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
				exclusiveTouch.claimTouch(this._touchPointID, this);
				this.startScroll();
			}
		}
		if((this._verticalScrollPolicy == SCROLL_POLICY_ON ||
			(this._verticalScrollPolicy == SCROLL_POLICY_AUTO && this._minVerticalScrollPosition != this._maxVerticalScrollPosition)) &&
			!this._isDraggingVertically && verticalInchesMoved >= this._minimumDragDistance)
		{
			if(this.verticalScrollBar != null)
			{
				this.revealVerticalScrollBar();
			}
			this._startTouchY = this._currentTouchY;
			this._startVerticalScrollPosition = this._verticalScrollPosition;
			this._isDraggingVertically = true;
			if(!this._isDraggingHorizontally)
			{
				exclusiveTouch = ExclusiveTouch.forStage(this.stage);
				exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
				exclusiveTouch.claimTouch(this._touchPointID, this);
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
				this.startScroll();
			}
		}
		if(this._isDraggingHorizontally && this._horizontalAutoScrollTween == null)
		{
			this.updateHorizontalScrollFromTouchPosition(this._currentTouchX);
		}
		if(this._isDraggingVertically && this._verticalAutoScrollTween == null)
		{
			this.updateVerticalScrollFromTouchPosition(this._currentTouchY);
		}
	}

	/**
	 * @private
	 */
	private function stage_touchHandler(event:TouchEvent):Void
	{
		var touch:Touch = event.getTouch(this.stage, null, this._touchPointID);
		if(touch == null)
		{
			return;
		}

		if(touch.phase == TouchPhase.MOVED)
		{
			//we're saving these to use in the enter frame handler because
			//that provides a longer time offset
			touch.getLocation(this, HELPER_POINT);
			this._currentTouchX = HELPER_POINT.x;
			this._currentTouchY = HELPER_POINT.y;
		}
		else if(touch.phase == TouchPhase.ENDED)
		{
			if(!this._isDraggingHorizontally && !this._isDraggingVertically)
			{
				ExclusiveTouch.forStage(this.stage).removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
			}
			this.removeEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			this._touchPointID = -1;
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
			var isFinishingHorizontally:Bool = false;
			var isFinishingVertically:Bool = false;
			if(this._horizontalScrollPosition < this._minHorizontalScrollPosition ||
				this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				isFinishingHorizontally = true;
				this.finishScrollingHorizontally();
			}
			if(this._verticalScrollPosition < this._minVerticalScrollPosition ||
				this._verticalScrollPosition > this._maxVerticalScrollPosition)
			{
				isFinishingVertically = true;
				this.finishScrollingVertically();
			}

			if(isFinishingHorizontally && isFinishingVertically)
			{
				return;
			}

			var sum:Float;
			var velocityCount:Int;
			var totalWeight:Float;
			var weight:Float;
			if(!isFinishingHorizontally && this._isDraggingHorizontally)
			{
				//take the average for more accuracy
				sum = this._velocityX * CURRENT_VELOCITY_WEIGHT;
				velocityCount = this._previousVelocityX.length;
				totalWeight = CURRENT_VELOCITY_WEIGHT;
				for(i in 0 ... velocityCount)
				{
					weight = VELOCITY_WEIGHTS[i];
					sum += this._previousVelocityX.shift() * weight;
					totalWeight += weight;
				}
				this.throwHorizontally(sum / totalWeight);
			}
			else
			{
				this.hideHorizontalScrollBar();
			}

			if(!isFinishingVertically && this._isDraggingVertically)
			{
				sum = this._velocityY * CURRENT_VELOCITY_WEIGHT;
				velocityCount = this._previousVelocityY.length;
				totalWeight = CURRENT_VELOCITY_WEIGHT;
				for(i in 0 ... velocityCount)
				{
					weight = VELOCITY_WEIGHTS[i];
					sum += this._previousVelocityY.shift() * weight;
					totalWeight += weight;
				}
				this.throwVertically(sum / totalWeight);
			}
			else
			{
				this.hideVerticalScrollBar();
			}
		}
	}

	/**
	 * @private
	 */
	private function exclusiveTouch_changeHandler(event:Event, touchID:Int):Void
	{
		if(this._touchPointID < 0 || this._touchPointID != touchID || this._isDraggingHorizontally || this._isDraggingVertically)
		{
			return;
		}
		var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
		if(exclusiveTouch.getClaim(touchID) == this)
		{
			return;
		}

		this._touchPointID = -1;
		this.removeEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);
		this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
		this.dispatchEventWith(FeathersEventType.END_INTERACTION);
	}

	/**
	 * @private
	 */
	private function nativeStage_mouseWheelHandler(event:MouseEvent):Void
	{
		if(!this._isEnabled)
		{
			this._touchPointID = -1;
			return;
		}
		if((this._verticalMouseWheelScrollDirection == MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL && (this._maxVerticalScrollPosition == this._minVerticalScrollPosition || this._verticalScrollPolicy == SCROLL_POLICY_OFF)) ||
			(this._verticalMouseWheelScrollDirection == MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL && (this._maxHorizontalScrollPosition == this._minHorizontalScrollPosition || this._horizontalScrollPolicy == SCROLL_POLICY_OFF)))
		{
			return;
		}

		var nativeScaleFactor:Float = 1;
		#if flash
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
		#end
		var starlingViewPort:Rectangle = Starling.current.viewPort;
		var scaleFactor:Float = nativeScaleFactor / Starling.current.contentScaleFactor;
		HELPER_POINT.x = (event.stageX - starlingViewPort.x) * scaleFactor;
		HELPER_POINT.y = (event.stageY - starlingViewPort.y) * scaleFactor;
		if(this.contains(this.stage.hitTest(HELPER_POINT, true)))
		{
			this.globalToLocal(HELPER_POINT, HELPER_POINT);
			var localMouseX:Float = HELPER_POINT.x;
			var localMouseY:Float = HELPER_POINT.y;
			if(localMouseX < this._leftViewPortOffset || localMouseY < this._topViewPortOffset ||
				localMouseX >= this.actualWidth - this._rightViewPortOffset ||
				localMouseY >= this.actualHeight - this._bottomViewPortOffset)
			{
				return;
			}
			var targetHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			var targetVerticalScrollPosition:Number = this._verticalScrollPosition;
			var scrollStep:Number = this._verticalMouseWheelScrollStep;
			if(this._verticalMouseWheelScrollDirection == MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL)
			{
				if(scrollStep != scrollStep) //isNaN
				{
					scrollStep = this.actualHorizontalScrollStep;
				}
				targetHorizontalScrollPosition -= event.delta * scrollStep;
				if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
				}
				else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
				}
			}
			else //vertical
			{
				if(scrollStep != scrollStep) //isNaN
				{
					scrollStep = this.actualVerticalScrollStep;
				}
				targetVerticalScrollPosition -= event.delta * scrollStep;
				if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
				{
					targetVerticalScrollPosition = this._minVerticalScrollPosition;
				}
				else if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
				{
					targetVerticalScrollPosition = this._maxVerticalScrollPosition;
				}
			}
			this.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, this._mouseWheelScrollDuration);
		}
	}

	/**
	 * @private
	 */
	private function nativeStage_orientationChangeHandler(event:openfl.events.Event):Void
	{
		if(this._touchPointID < 0)
		{
			return;
		}
		this._startTouchX = this._previousTouchX = this._currentTouchX;
		this._startTouchY = this._previousTouchY = this._currentTouchY;
		this._startHorizontalScrollPosition = this._horizontalScrollPosition;
		this._startVerticalScrollPosition = this._verticalScrollPosition;
	}

	/**
	 * @private
	 */
	private function horizontalScrollBar_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._horizontalScrollBarTouchPointID = -1;
			return;
		}

		var displayHorizontalScrollBar:DisplayObject = cast(event.currentTarget, DisplayObject);
		var touch:Touch;
		if(this._horizontalScrollBarTouchPointID >= 0)
		{
			touch = event.getTouch(displayHorizontalScrollBar, TouchPhase.ENDED, this._horizontalScrollBarTouchPointID);
			if(touch == null)
			{
				return;
			}

			this._horizontalScrollBarTouchPointID = -1;
			touch.getLocation(displayHorizontalScrollBar, HELPER_POINT);
			var isInBounds:Bool = this.horizontalScrollBar.hitTest(HELPER_POINT, true) != null;
			if(!isInBounds)
			{
				this.hideHorizontalScrollBar();
			}
		}
		else
		{
			touch = event.getTouch(displayHorizontalScrollBar, TouchPhase.BEGAN);
			if(touch != null)
			{
				this._horizontalScrollBarTouchPointID = touch.id;
				return;
			}
			if(this._isScrolling)
			{
				return;
			}
			touch = event.getTouch(displayHorizontalScrollBar, TouchPhase.HOVER);
			if(touch != null)
			{
				this.revealHorizontalScrollBar();
				return;
			}

			//end hover
			this.hideHorizontalScrollBar();
		}
	}

	/**
	 * @private
	 */
	private function verticalScrollBar_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._verticalScrollBarTouchPointID = -1;
			return;
		}

		var displayVerticalScrollBar:DisplayObject = cast(event.currentTarget, DisplayObject);
		var touch:Touch;
		if(this._verticalScrollBarTouchPointID >= 0)
		{
			touch = event.getTouch(displayVerticalScrollBar, TouchPhase.ENDED, this._verticalScrollBarTouchPointID);
			if(touch == null)
			{
				return;
			}

			this._verticalScrollBarTouchPointID = -1;
			touch.getLocation(displayVerticalScrollBar, HELPER_POINT);
			var isInBounds:Bool = this.verticalScrollBar.hitTest(HELPER_POINT, true) != null;
			if(!isInBounds)
			{
				this.hideVerticalScrollBar();
			}
		}
		else
		{
			touch = event.getTouch(displayVerticalScrollBar, TouchPhase.BEGAN);
			if(touch != null)
			{
				this._verticalScrollBarTouchPointID = touch.id;
				return;
			}
			if(this._isScrolling)
			{
				return;
			}
			touch = event.getTouch(displayVerticalScrollBar, TouchPhase.HOVER);
			if(touch != null)
			{
				this.revealVerticalScrollBar();
				return;
			}

			//end hover
			this.hideVerticalScrollBar();
		}
	}

	/**
	 * @private
	 */
	private function scroller_addedToStageHandler(event:Event):Void
	{
		Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler, false, 0, true);
		Starling.current.nativeStage.addEventListener("orientationChange", nativeStage_orientationChangeHandler, false, 0, true);
	}

	/**
	 * @private
	 */
	private function scroller_removedFromStageHandler(event:Event):Void
	{
		Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler);
		Starling.current.nativeStage.removeEventListener("orientationChange", nativeStage_orientationChangeHandler);
		if(this._touchPointID >= 0)
		{
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
		}
		this._touchPointID = -1;
		this._horizontalScrollBarTouchPointID = -1;
		this._verticalScrollBarTouchPointID = -1;
		this._velocityX = 0;
		this._velocityY = 0;
		this._previousVelocityX.splice(0, this._previousVelocityX.length);
		this._previousVelocityY.splice(0, this._previousVelocityY.length);
		this._horizontalScrollBarIsScrolling = false;
		this._verticalScrollBarIsScrolling = false;
		this.removeEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);
		this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		if(this._verticalAutoScrollTween != null)
		{
			Starling.current.juggler.remove(this._verticalAutoScrollTween);
			this._verticalAutoScrollTween = null;
		}
		if(this._horizontalAutoScrollTween != null)
		{
			Starling.current.juggler.remove(this._horizontalAutoScrollTween);
			this._horizontalAutoScrollTween = null;
		}

		//if we stopped the animation while the list was outside the scroll
		//bounds, then let's account for that
		var oldHorizontalScrollPosition:Float = this._horizontalScrollPosition;
		var oldVerticalScrollPosition:Float = this._verticalScrollPosition;
		if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
		{
			this._horizontalScrollPosition = this._minHorizontalScrollPosition;
		}
		else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
		{
			this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
		}
		if(this._verticalScrollPosition < this._minVerticalScrollPosition)
		{
			this._verticalScrollPosition = this._minVerticalScrollPosition;
		}
		else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
		{
			this._verticalScrollPosition = this._maxVerticalScrollPosition;
		}
		if(oldHorizontalScrollPosition != this._horizontalScrollPosition ||
			oldVerticalScrollPosition != this._verticalScrollPosition)
		{
			this.dispatchEventWith(Event.SCROLL);
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
	private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.keyCode == Keyboard.HOME)
		{
			this.verticalScrollPosition = this._minVerticalScrollPosition;
		}
		else if(event.keyCode == Keyboard.END)
		{
			this.verticalScrollPosition = this._maxVerticalScrollPosition;
		}
		else if(event.keyCode == Keyboard.PAGE_UP)
		{
			this.verticalScrollPosition = Math.max(this._minVerticalScrollPosition, this._verticalScrollPosition - this.viewPort.visibleHeight);
		}
		else if(event.keyCode == Keyboard.PAGE_DOWN)
		{
			this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition, this._verticalScrollPosition + this.viewPort.visibleHeight);
		}
		else if(event.keyCode == Keyboard.UP)
		{
			this.verticalScrollPosition = Math.max(this._minVerticalScrollPosition, this._verticalScrollPosition - this.verticalScrollStep);
		}
		else if(event.keyCode == Keyboard.DOWN)
		{
			this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition, this._verticalScrollPosition + this.verticalScrollStep);
		}
		else if(event.keyCode == Keyboard.LEFT)
		{
			this.horizontalScrollPosition = Math.max(this._maxHorizontalScrollPosition, this._horizontalScrollPosition - this.horizontalScrollStep);
		}
		else if(event.keyCode == Keyboard.RIGHT)
		{
			this.horizontalScrollPosition = Math.min(this._maxHorizontalScrollPosition, this._horizontalScrollPosition + this.horizontalScrollStep);
		}
	}
}
