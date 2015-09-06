/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.supportClasses.BaseScreenNavigator;
import feathers.core.FeathersControl;
import feathers.core.IValidating;
import feathers.events.ExclusiveTouch;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.system.DeviceCapabilities;
import feathers.utils.display.FeathersDisplayUtil.getDisplayObjectDepthFromStage;
import feathers.utils.math.FeathersMathUtil.roundToNearest;

import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;
import openfl.Lib.getTimer;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.ResizeEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the user starts dragging the content to open or close a
 * drawer.
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
 */
//[Event(name="beginInteraction",type="starling.events.Event")]

/**
 * Dispatched when the user stops dragging the content to open or close a
 * drawer. The drawer may continue opening or closing after this event is
 * dispatched if the user interaction has also triggered an animation.
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
 */
//[Event(name="endInteraction",type="starling.events.Event")]

/**
 * Dispatched when a drawer has completed opening. The <code>data</code>
 * property of the event indicates which drawer is open.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The drawer that was opened.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.OPEN
 * @see #event:close starling.events.Event.CLOSE
 */
//[Event(name="open",type="starling.events.Event")]

/**
 * Dispatched when a drawer has completed closing. The <code>data</code>
 * property of the event indicates which drawer was closed.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The drawer that was closed.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.CLOSE
 * @see #event:open starling.events.Event.OPEN
 */
//[Event(name="close",type="starling.events.Event")]

/**
 * A container that displays primary content in the center surrounded by
 * optional "drawers" that can open and close on the edges. Useful for
 * mobile-style app menus that slide open from the side of the screen.
 *
 * <p>Additionally, each drawer may be individually "docked" in an
 * always-open state, making this a useful application-level layout
 * container even if the drawers never need to be hidden. Docking behavior
 * may be limited to either portrait or landscape, or a drawer may be docked
 * in both orientations. By default, a drawer is not docked.</p>
 *
 * <p>The following example creates an app with a slide out menu to the
 * left of the main content:</p>
 *
 * <listing version="3.0">
 * var navigator:StackScreenNavigator = new StackScreenNavigator();
 * var list:List = new List();
 * // the navigator's screens, the list's data provider, and additional
 * // properties should be set here.
 * 
 * var drawers:Drawers = new Drawers();
 * drawers.content = navigator;
 * drawers.leftDrawer = menu;
 * drawers.leftDrawerToggleEventType = Event.OPEN;
 * this.addChild( drawers );</listing>
 *
 * <p>In the example above, a screen in the <code>StackScreenNavigator</code>
 * component dispatches an event of type <code>Event.OPEN</code> when it
 * wants to display the slide out the <code>List</code> that is used as
 * the left drawer.</p>
 *
 * @see ../../../help/drawers.html How to use the Feathers Drawers component
 */
class Drawers extends FeathersControl
{
	/**
	 * The default <code>IStyleProvider</code> for all <code>Drawers</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * The drawer will be docked in portrait orientation, but it must be
	 * opened and closed explicitly in landscape orientation.
	 *
	 * @see #topDrawerDockMode
	 * @see #rightDrawerDockMode
	 * @see #bottomDrawerDockMode
	 * @see #leftDrawerDockMode
	 * @see #isTopDrawerDocked
	 * @see #isRightDrawerDocked
	 * @see #isBottomDrawerDocked
	 * @see #isLeftDrawerDocked
	 */
	inline public static var DOCK_MODE_PORTRAIT:String = "portrait";

	/**
	 * The drawer will be docked in landscape orientation, but it must be
	 * opened and closed explicitly in portrait orientation.
	 *
	 * @see #topDrawerDockMode
	 * @see #rightDrawerDockMode
	 * @see #bottomDrawerDockMode
	 * @see #leftDrawerDockMode
	 * @see #isTopDrawerDocked
	 * @see #isRightDrawerDocked
	 * @see #isBottomDrawerDocked
	 * @see #isLeftDrawerDocked
	 */
	inline public static var DOCK_MODE_LANDSCAPE:String = "landscape";

	/**
	 * The drawer will be docked in all orientations.
	 *
	 * @see #topDrawerDockMode
	 * @see #rightDrawerDockMode
	 * @see #bottomDrawerDockMode
	 * @see #leftDrawerDockMode
	 * @see #isTopDrawerDocked
	 * @see #isRightDrawerDocked
	 * @see #isBottomDrawerDocked
	 * @see #isLeftDrawerDocked
	 */
	inline public static var DOCK_MODE_BOTH:String = "both";

	/**
	 * The drawer won't be docked in any orientation. It must be opened and
	 * closed explicitly in all orientations.
	 *
	 * @see #topDrawerDockMode
	 * @see #rightDrawerDockMode
	 * @see #bottomDrawerDockMode
	 * @see #leftDrawerDockMode
	 * @see #isTopDrawerDocked
	 * @see #isRightDrawerDocked
	 * @see #isBottomDrawerDocked
	 * @see #isLeftDrawerDocked
	 */
	inline public static var DOCK_MODE_NONE:String = "none";

	/**
	 * The drawers container  will auto size itself to fill the entire stage.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_STAGE:String = "stage";

	/**
	 * The drawers container will auto size itself to fit its content.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_CONTENT:String = "content";

	/**
	 * A drawer will open by dragging the content starting from a certain
	 * physical distance (in inches) from the nearest edge of the content.
	 * To customize this distance, use the <code>openGestureDragContentEdgeDistance</code>
	 * property.
	 *
	 * @see #openGesture
	 * @see openGestureEdgeSize
	 */
	inline public static var OPEN_GESTURE_DRAG_CONTENT_EDGE:String = "dragContentEdge";

	/**
	 * A drawer will open by dragging the content from any location in the
	 * appropriate direction.
	 *
	 * @see #openGesture
	 */
	inline public static var OPEN_GESTURE_DRAG_CONTENT:String = "dragContent";

	/**
	 * The drawers container will only open using the toggle event types
	 * dispatched by the content. No gesture can be used to open a drawer.
	 *
	 * @see #openGesture
	 * @see #topDrawerToggleEventType
	 * @see #rightDrawerToggleEventType
	 * @see #bottomDrawerToggleEventType
	 * @see #leftDrawerToggleEventType
	 */
	inline public static var OPEN_GESTURE_NONE:String = "none";

	/**
	 * The field used to access the "content event dispatcher" of a
	 * <code>ScreenNavigator</code> component, which happens to be the
	 * currently active screen.
	 *
	 * @see #contentEventDispatcherField
	 * @see feathers.controls.ScreenNavigator
	 */
	inline private static var SCREEN_NAVIGATOR_CONTENT_EVENT_DISPATCHER_FIELD:String = "activeScreen";

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
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * Constructor.
	 */
	public function new(content:DisplayObject = null)
	{
		super();
		this.content = content;
		this.addEventListener(Event.ADDED_TO_STAGE, drawers_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, drawers_removedFromStageHandler);
		this.addEventListener(TouchEvent.TOUCH, drawers_touchHandler);
	}

	/**
	 * The event dispatcher that controls opening and closing drawers with
	 * events. Often, the event dispatcher is the content itself, but you
	 * may specify a <code>contentEventDispatcherField</code> to access a
	 * property of the content instead, or you may specify a
	 * <code>contentEventDispatcherFunction</code> to run some more complex
	 * code to access the event dispatcher.
	 *
	 * @see #contentEventDispatcherField
	 * @see #contentEventDispatcherFunction
	 */
	private var contentEventDispatcher:EventDispatcher;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Drawers.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _content:DisplayObject;

	/**
	 * The primary content displayed in the center of the container.
	 *
	 * <p>If the primary content is a container where you'd prefer to listen
	 * to events from its children, you may need to use properties like
	 * <code>contentEventDispatcherField</code>, <code>contentEventDispatcherFunction</code>,
	 * and <code>contentEventDispatcherChangeEventType</code> to ensure that
	 * open and close events for drawers are correctly mapped to the correct
	 * event dispatcher. If the content is dispatching the events, then those
	 * properties should be set to <code>null</code>.</p>
	 *
	 * <p>In the following example, a <code>ScreenNavigator</code> is added
	 * as the content:</p>
	 *
	 * <listing version="3.0">
	 * var navigator:ScreenNavigator = new ScreenNavigator();
	 * // additional code to add the screens can go here
	 * drawers.content = navigator;</listing>
	 *
	 * @default null
	 *
	 * @see #contentEventDispatcherField
	 * @see #contentEventDispatcherFunction
	 * @see #contentEventDispatcherChangeEventType
	 */
	public var content(get, set):DisplayObject;
	public function get_content():DisplayObject
	{
		return this._content;
	}

	/**
	 * @private
	 */
	public function set_content(value:DisplayObject):DisplayObject
	{
		if(this._content == value)
		{
			return get_content();
		}
		if(this._content != null)
		{
			if(this._contentEventDispatcherChangeEventType != null)
			{
				this._content.removeEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
			}
			this._content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			if(this._content.parent == this)
			{
				this.removeChild(this._content, false);
			}
		}
		this._content = value;
		if(this._content != null)
		{
			if(Std.is(this._content, BaseScreenNavigator))
			{
				this.contentEventDispatcherField = SCREEN_NAVIGATOR_CONTENT_EVENT_DISPATCHER_FIELD;
				this.contentEventDispatcherChangeEventType = Event.CHANGE;
			}
			if(this._contentEventDispatcherChangeEventType != null)
			{
				this._content.addEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
			}
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || this.stage == null)
			{
				this._content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			//the content should appear under the overlay skin, if it exists
			if(this._overlaySkin != null)
			{
				this.addChildAt(this._content, this.getChildIndex(this._overlaySkin));
			}
			else
			{
				this.addChild(this._content);
			}
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_content();
	}

	/**
	 * @private
	 */
	private var _overlaySkinOriginalAlpha:Float = 1;

	/**
	 * @private
	 */
	private var _overlaySkin:DisplayObject;

	/**
	 * An optional display object that appears above the content when a
	 * drawer is open.
	 *
	 * <p>In the following example, a <code>Quad</code> is added as the
	 * overlay skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Quad = new Quad( 10, 10, 0x000000 );
	 * skin.alpha = 0.75;
	 * drawers.overlaySkin = skin;</listing>
	 *
	 * @default null
	 */
	public var overlaySkin(get, set):DisplayObject;
	public function get_overlaySkin():DisplayObject
	{
		return this._overlaySkin;
	}

	/**
	 * @private
	 */
	public function set_overlaySkin(value:DisplayObject):DisplayObject
	{
		if(this._overlaySkin == value)
		{
			return get_overlaySkin();
		}
		if(this._overlaySkin != null && this._overlaySkin.parent == this)
		{
			this.removeChild(this._overlaySkin, false);
		}
		this._overlaySkin = value;
		if(this._overlaySkin != null)
		{
			this._overlaySkinOriginalAlpha = this._overlaySkin.alpha;
			this._overlaySkin.visible = this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen;
			this.addChild(this._overlaySkin);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_overlaySkin();
	}

	/**
	 * @private
	 */
	private var _topDrawer:DisplayObject;

	/**
	 * The drawer that appears above the primary content.
	 *
	 * <p>In the following example, a <code>List</code> is added as the
	 * top drawer:</p>
	 *
	 * <listing version="3.0">
	 * var list:List = new List();
	 * // set data provider and other properties here
	 * drawers.topDrawer = list;</listing>
	 *
	 * @default null
	 *
	 * @see #topDrawerDockMode
	 * @see #topDrawerToggleEventType
	 */
	public var topDrawer(get, set):DisplayObject;
	public function get_topDrawer():DisplayObject
	{
		return this._topDrawer;
	}

	/**
	 * @private
	 */
	public function set_topDrawer(value:DisplayObject):DisplayObject
	{
		if(this._topDrawer == value)
		{
			return get_topDrawer();
		}
		if(this._topDrawer != null && this._topDrawer.parent == this)
		{
			this.removeChild(this._topDrawer, false);
		}
		this._topDrawer = value;
		if(this._topDrawer != null)
		{
			this._topDrawer.visible = false;
			this._topDrawer.addEventListener(FeathersEventType.RESIZE, drawer_resizeHandler);
			this.addChildAt(this._topDrawer, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_topDrawer();
	}

	/**
	 * @private
	 */
	private var _topDrawerDockMode:String = DOCK_MODE_NONE;

    #if 0
	[Inspectable(type="String",enumeration="portrait,landscape,both,none")]
    #end
	/**
	 * Determines if the top drawer is docked in all, some, or no stage
	 * orientations. The current stage orientation is determined by
	 * calculating the aspect ratio of the stage.
	 *
	 * <p>In the following example, the top drawer is docked in the
	 * landscape stage orientation:</p>
	 *
	 * <listing version="3.0">
	 * drawers.topDrawerDockMode = Drawers.DOCK_MODE_LANDSCAPE;</listing>
	 *
	 * @default Drawers.DOCK_MODE_NONE
	 *
	 * @see #DOCK_MODE_PORTRAIT
	 * @see #DOCK_MODE_LANDSCAPE
	 * @see #DOCK_MODE_NONE
	 * @see #DOCK_MODE_BOTH
	 * @see #topDrawer
	 */
	public var topDrawerDockMode(get, set):String;
	public function get_topDrawerDockMode():String
	{
		return this._topDrawerDockMode;
	}

	/**
	 * @private
	 */
	public function set_topDrawerDockMode(value:String):String
	{
		if(this._topDrawerDockMode == value)
		{
			return get_topDrawerDockMode();
		}
		this._topDrawerDockMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_topDrawerDockMode();
	}

	/**
	 * @private
	 */
	private var _topDrawerToggleEventType:String;

	/**
	 * When this event is dispatched by the content event dispatcher, the
	 * top drawer will toggle open and closed.
	 *
	 * <p>In the following example, the top drawer is toggled when the
	 * content dispatches an event of type <code>Event.OPEN</code>:</p>
	 *
	 * <listing version="3.0">
	 * drawers.topDrawerToggleEventType = Event.OPEN;</listing>
	 *
	 * @default null
	 *
	 * @see #content
	 * @see #topDrawer
	 */
	public var topDrawerToggleEventType(get, set):String;
	public function get_topDrawerToggleEventType():String
	{
		return this._topDrawerToggleEventType;
	}

	/**
	 * @private
	 */
	public function set_topDrawerToggleEventType(value:String):String
	{
		if(this._topDrawerToggleEventType == value)
		{
			return get_topDrawerToggleEventType();
		}
		if(this.contentEventDispatcher != null && this._topDrawerToggleEventType != null)
		{
			this.contentEventDispatcher.removeEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
		}
		this._topDrawerToggleEventType = value;
		if(this.contentEventDispatcher != null && this._topDrawerToggleEventType != null)
		{
			this.contentEventDispatcher.addEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
		}
		return get_topDrawerToggleEventType();
	}

	/**
	 * @private
	 */
	private var _isTopDrawerOpen:Bool = false;

	/**
	 * Indicates if the top drawer is currently open. If you want to check
	 * if the top drawer is docked, check <code>isTopDrawerDocked</code>
	 * instead.
	 *
	 * <p>To animate the top drawer open or closed, call
	 * <code>toggleTopDrawer()</code>. Setting <code>isTopDrawerOpen</code>
	 * will open or close the top drawer without animation.</p>
	 *
	 * <p>In the following example, we check if the top drawer is open:</p>
	 *
	 * <listing version="3.0">
	 * if( drawers.isTopDrawerOpen )
	 * {
	 *     // do something
	 * }</listing>
	 *
	 * @default false
	 *
	 * @see #isTopDrawerDocked
	 * @see #topDrawer
	 * @see #toggleTopDrawer()
	 */
	public var isTopDrawerOpen(get, set):Bool;
	public function get_isTopDrawerOpen():Bool
	{
		return this._topDrawer != null && this._isTopDrawerOpen;
	}

	/**
	 * @private
	 */
	public function set_isTopDrawerOpen(value:Bool):Bool
	{
		if(this.isTopDrawerDocked || this._isTopDrawerOpen == value)
		{
			return get_isTopDrawerOpen();
		}
		this._isTopDrawerOpen = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_isTopDrawerOpen();
	}

	/**
	 * Indicates if the top drawer is currently docked. Docking behavior of
	 * the top drawer is controlled with the <code>topDrawerDockMode</code>
	 * property. To check if the top drawer is open, but not docked, use
	 * the <code>isTopDrawerOpen</code> property.
	 *
	 * @see #topDrawer
	 * @see #topDrawerDockMode
	 * @see #isTopDrawerOpen
	 */
	public var isTopDrawerDocked(get, never):Bool;
	public function get_isTopDrawerDocked():Bool
	{
		if(this._topDrawer == null)
		{
			return false;
		}
		if(this._topDrawerDockMode == DOCK_MODE_BOTH)
		{
			return true;
		}
		if(this._topDrawerDockMode == DOCK_MODE_NONE)
		{
			return false;
		}
		var stage:Stage = this.stage;
		if(stage == null)
		{
			//fall back to the current stage, but it may be wrong...
			stage = Starling.current.stage;
		}
		if(stage.stageWidth > stage.stageHeight)
		{
			return this._topDrawerDockMode == DOCK_MODE_LANDSCAPE;
		}
		return this._topDrawerDockMode == DOCK_MODE_PORTRAIT;
	}

	/**
	 * @private
	 */
	private var _rightDrawer:DisplayObject;

	/**
	 * The drawer that appears to the right of the primary content.
	 *
	 * <p>In the following example, a <code>List</code> is added as the
	 * right drawer:</p>
	 *
	 * <listing version="3.0">
	 * var list:List = new List();
	 * // set data provider and other properties here
	 * drawers.rightDrawer = list;</listing>
	 *
	 * @default null
	 *
	 * @see #rightDrawerDockMode
	 * @see #rightDrawerToggleEventType
	 */
	public var rightDrawer(get, set):DisplayObject;
	public function get_rightDrawer():DisplayObject
	{
		return this._rightDrawer;
	}

	/**
	 * @private
	 */
	public function set_rightDrawer(value:DisplayObject):DisplayObject
	{
		if(this._rightDrawer == value)
		{
			return get_rightDrawer();
		}
		if(this._rightDrawer != null && this._rightDrawer.parent == this)
		{
			this.removeChild(this._rightDrawer, false);
		}
		this._rightDrawer = value;
		if(this._rightDrawer != null)
		{
			this._rightDrawer.visible = false;
			this._rightDrawer.addEventListener(FeathersEventType.RESIZE, drawer_resizeHandler);
			this.addChildAt(this._rightDrawer, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_rightDrawer();
	}

	/**
	 * @private
	 */
	private var _rightDrawerDockMode:String = DOCK_MODE_NONE;

    #if 0
	[Inspectable(type="String",enumeration="portrait,landscape,both,none")]
    #end
	/**
	 * Determines if the right drawer is docked in all, some, or no stage
	 * orientations. The current stage orientation is determined by
	 * calculating the aspect ratio of the stage.
	 *
	 * <p>In the following example, the right drawer is docked in the
	 * landscape stage orientation:</p>
	 *
	 * <listing version="3.0">
	 * drawers.rightDrawerDockMode = Drawers.DOCK_MODE_LANDSCAPE;</listing>
	 *
	 * @default Drawers.DOCK_MODE_NONE
	 *
	 * @see #DOCK_MODE_PORTRAIT
	 * @see #DOCK_MODE_LANDSCAPE
	 * @see #DOCK_MODE_NONE
	 * @see #DOCK_MODE_BOTH
	 * @see #rightDrawer
	 */
	public var rightDrawerDockMode(get, set):String;
	public function get_rightDrawerDockMode():String
	{
		return this._rightDrawerDockMode;
	}

	/**
	 * @private
	 */
	public function set_rightDrawerDockMode(value:String):String
	{
		if(this._rightDrawerDockMode == value)
		{
			return get_rightDrawerDockMode();
		}
		this._rightDrawerDockMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_rightDrawerDockMode();
	}

	/**
	 * @private
	 */
	private var _rightDrawerToggleEventType:String;

	/**
	 * When this event is dispatched by the content event dispatcher, the
	 * right drawer will toggle open and closed.
	 *
	 * <p>In the following example, the right drawer is toggled when the
	 * content dispatches an event of type <code>Event.OPEN</code>:</p>
	 *
	 * <listing version="3.0">
	 * drawers.rightDrawerToggleEventType = Event.OPEN;</listing>
	 *
	 * @default null
	 *
	 * @see #content
	 * @see #rightDrawer
	 */
	public var rightDrawerToggleEventType(get, set):String;
	public function get_rightDrawerToggleEventType():String
	{
		return this._rightDrawerToggleEventType;
	}

	/**
	 * @private
	 */
	public function set_rightDrawerToggleEventType(value:String):String
	{
		if(this._rightDrawerToggleEventType == value)
		{
			return get_rightDrawerToggleEventType();
		}
		if(this.contentEventDispatcher != null && this._rightDrawerToggleEventType != null)
		{
			this.contentEventDispatcher.removeEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
		}
		this._rightDrawerToggleEventType = value;
		if(this.contentEventDispatcher != null && this._rightDrawerToggleEventType != null)
		{
			this.contentEventDispatcher.addEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
		}
		return get_rightDrawerToggleEventType();
	}

	/**
	 * @private
	 */
	private var _isRightDrawerOpen:Bool = false;

	/**
	 * Indicates if the right drawer is currently open. If you want to check
	 * if the right drawer is docked, check <code>isRightDrawerDocked</code>
	 * instead.
	 *
	 * <p>To animate the right drawer open or closed, call
	 * <code>toggleRightDrawer()</code>. Setting <code>isRightDrawerOpen</code>
	 * will open or close the right drawer without animation.</p>
	 *
	 * <p>In the following example, we check if the right drawer is open:</p>
	 *
	 * <listing version="3.0">
	 * if( drawers.isRightDrawerOpen )
	 * {
	 *     // do something
	 * }</listing>
	 *
	 * @default false
	 *
	 * @see #rightDrawer
	 * @see #rightDrawerDockMode
	 * @see #toggleRightDrawer()
	 */
	public var isRightDrawerOpen(get, set):Bool;
	public function get_isRightDrawerOpen():Bool
	{
		return this._rightDrawer != null && this._isRightDrawerOpen;
	}

	/**
	 * @private
	 */
	public function set_isRightDrawerOpen(value:Bool):Bool
	{
		if(this.isRightDrawerDocked || this._isRightDrawerOpen == value)
		{
			return get_isRightDrawerOpen();
		}
		this._isRightDrawerOpen = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_isRightDrawerOpen();
	}

	/**
	 * Indicates if the right drawer is currently docked. Docking behavior of
	 * the right drawer is controlled with the <code>rightDrawerDockMode</code>
	 * property. To check if the right drawer is open, but not docked, use
	 * the <code>isRightDrawerOpen</code> property.
	 *
	 * @see #rightDrawer
	 * @see #rightDrawerDockMode
	 * @see #isRightDrawerOpen
	 */
	public var isRightDrawerDocked(get, never):Bool;
	public function get_isRightDrawerDocked():Bool
	{
		if(this._rightDrawer == null)
		{
			return false;
		}
		if(this._rightDrawerDockMode == DOCK_MODE_BOTH)
		{
			return true;
		}
		if(this._rightDrawerDockMode == DOCK_MODE_NONE)
		{
			return false;
		}
		var stage:Stage = this.stage;
		if(stage == null)
		{
			//fall back to the current stage, but it may be wrong...
			stage = Starling.current.stage;
		}
		if(stage.stageWidth > stage.stageHeight)
		{
			return this._rightDrawerDockMode == DOCK_MODE_LANDSCAPE;
		}
		return this._rightDrawerDockMode == DOCK_MODE_PORTRAIT;
	}

	/**
	 * @private
	 */
	private var _bottomDrawer:DisplayObject;

	/**
	 * The drawer that appears below the primary content.
	 *
	 * <p>In the following example, a <code>List</code> is added as the
	 * bottom drawer:</p>
	 *
	 * <listing version="3.0">
	 * var list:List = new List();
	 * // set data provider and other properties here
	 * drawers.bottomDrawer = list;</listing>
	 *
	 * @default null
	 *
	 * @see #bottomDrawerDockMode
	 * @see #bottomDrawerToggleEventType
	 */
	public var bottomDrawer(get, set):DisplayObject;
	public function get_bottomDrawer():DisplayObject
	{
		return this._bottomDrawer;
	}

	/**
	 * @private
	 */
	public function set_bottomDrawer(value:DisplayObject):DisplayObject
	{
		if(this._bottomDrawer == value)
		{
			return get_bottomDrawer();
		}
		if(this._bottomDrawer != null && this._bottomDrawer.parent == this)
		{
			this.removeChild(this._bottomDrawer, false);
		}
		this._bottomDrawer = value;
		if(this._bottomDrawer != null)
		{
			this._bottomDrawer.visible = false;
			this._bottomDrawer.addEventListener(FeathersEventType.RESIZE, drawer_resizeHandler);
			this.addChildAt(this._bottomDrawer, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_bottomDrawer();
	}

	/**
	 * @private
	 */
	private var _bottomDrawerDockMode:String = DOCK_MODE_NONE;

	#if 0
	[Inspectable(type="String",enumeration="portrait,landscape,both,none")]
	#end
	/**
	 * Determines if the bottom drawer is docked in all, some, or no stage
	 * orientations. The current stage orientation is determined by
	 * calculating the aspect ratio of the stage.
	 *
	 * <p>In the following example, the bottom drawer is docked in the
	 * landscape stage orientation:</p>
	 *
	 * <listing version="3.0">
	 * drawers.bottomDrawerDockMode = Drawers.DOCK_MODE_LANDSCAPE;</listing>
	 *
	 * @default Drawers.DOCK_MODE_NONE
	 *
	 * @see #DOCK_MODE_PORTRAIT
	 * @see #DOCK_MODE_LANDSCAPE
	 * @see #DOCK_MODE_NONE
	 * @see #DOCK_MODE_BOTH
	 * @see #bottomDrawer
	 */
	public var bottomDrawerDockMode(get, set):String;
	public function get_bottomDrawerDockMode():String
	{
		return this._bottomDrawerDockMode;
	}

	/**
	 * @private
	 */
	public function set_bottomDrawerDockMode(value:String):String
	{
		if(this._bottomDrawerDockMode == value)
		{
			return get_bottomDrawerDockMode();
		}
		this._bottomDrawerDockMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_bottomDrawerDockMode();
	}

	/**
	 * @private
	 */
	private var _bottomDrawerToggleEventType:String;

	/**
	 * When this event is dispatched by the content event dispatcher, the
	 * bottom drawer will toggle open and closed.
	 *
	 * <p>In the following example, the bottom drawer is toggled when the
	 * content dispatches an event of type <code>Event.OPEN</code>:</p>
	 *
	 * <listing version="3.0">
	 * drawers.bottomDrawerToggleEventType = Event.OPEN;</listing>
	 *
	 * @default null
	 *
	 * @see #content
	 * @see #bottomDrawer
	 */
	public var bottomDrawerToggleEventType(get, set):String;
	public function get_bottomDrawerToggleEventType():String
	{
		return this._bottomDrawerToggleEventType;
	}

	/**
	 * @private
	 */
	public function set_bottomDrawerToggleEventType(value:String):String
	{
		if(this._bottomDrawerToggleEventType == value)
		{
			return get_bottomDrawerToggleEventType();
		}
		if(this.contentEventDispatcher != null && this._bottomDrawerToggleEventType != null)
		{
			this.contentEventDispatcher.removeEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
		}
		this._bottomDrawerToggleEventType = value;
		if(this.contentEventDispatcher != null && this._bottomDrawerToggleEventType != null)
		{
			this.contentEventDispatcher.addEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
		}
		return get_bottomDrawerToggleEventType();
	}

	/**
	 * @private
	 */
	private var _isBottomDrawerOpen:Bool = false;

	/**
	 * Indicates if the bottom drawer is currently open. If you want to check
	 * if the bottom drawer is docked, check <code>isBottomDrawerDocked</code>
	 * instead.
	 *
	 * <p>To animate the bottom drawer open or closed, call
	 * <code>toggleBottomDrawer()</code>. Setting <code>isBottomDrawerOpen</code>
	 * will open or close the bottom drawer without animation.</p>
	 *
	 * <p>In the following example, we check if the bottom drawer is open:</p>
	 *
	 * <listing version="3.0">
	 * if( drawers.isBottomDrawerOpen )
	 * {
	 *     // do something
	 * }</listing>
	 *
	 * @default false
	 *
	 * @see #bottomDrawer
	 * @see #isBottomDrawerOpen
	 * @see #toggleBottomDrawer()
	 */
	public var isBottomDrawerOpen(get, set):Bool;
	public function get_isBottomDrawerOpen():Bool
	{
		return this._bottomDrawer != null && this._isBottomDrawerOpen;
	}

	/**
	 * @private
	 */
	public function set_isBottomDrawerOpen(value:Bool):Bool
	{
		if(this.isBottomDrawerDocked || this._isBottomDrawerOpen == value)
		{
			return get_isBottomDrawerOpen();
		}
		this._isBottomDrawerOpen = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_isBottomDrawerOpen();
	}

	/**
	 * Indicates if the bottom drawer is currently docked. Docking behavior of
	 * the bottom drawer is controlled with the <code>bottomDrawerDockMode</code>
	 * property. To check if the bottom drawer is open, but not docked, use
	 * the <code>isBottomDrawerOpen</code> property.
	 *
	 * @see #bottomDrawer
	 * @see #bottomDrawerDockMode
	 * @see #isBottomDrawerOpen
	 */
	public var isBottomDrawerDocked(get, never):Bool;
	public function get_isBottomDrawerDocked():Bool
	{
		if(this._bottomDrawer == null)
		{
			return false;
		}
		if(this._bottomDrawerDockMode == DOCK_MODE_BOTH)
		{
			return true;
		}
		if(this._bottomDrawerDockMode == DOCK_MODE_NONE)
		{
			return false;
		}
		var stage:Stage = this.stage;
		if(stage == null)
		{
			//fall back to the current stage, but it may be wrong...
			stage = Starling.current.stage;
		}
		if(stage.stageWidth > stage.stageHeight)
		{
			return this._bottomDrawerDockMode == DOCK_MODE_LANDSCAPE;
		}
		return this._bottomDrawerDockMode == DOCK_MODE_PORTRAIT;
	}

	/**
	 * @private
	 */
	private var _leftDrawer:DisplayObject;

	/**
	 * The drawer that appears below the primary content.
	 *
	 * <p>In the following example, a <code>List</code> is added as the
	 * left drawer:</p>
	 *
	 * <listing version="3.0">
	 * var list:List = new List();
	 * // set data provider and other properties here
	 * drawers.leftDrawer = list;</listing>
	 *
	 * @default null
	 *
	 * @see #leftDrawerDockMode
	 * @see #leftDrawerToggleEventType
	 */
	public var leftDrawer(get, set):DisplayObject;
	public function get_leftDrawer():DisplayObject
	{
		return this._leftDrawer;
	}

	/**
	 * @private
	 */
	public function set_leftDrawer(value:DisplayObject):DisplayObject
	{
		if(this._leftDrawer == value)
		{
			return get_leftDrawer();
		}
		if(this._leftDrawer != null && this._leftDrawer.parent == this)
		{
			this.removeChild(this._leftDrawer, false);
		}
		this._leftDrawer = value;
		if(this._leftDrawer != null)
		{
			this._leftDrawer.visible = false;
			this._leftDrawer.addEventListener(FeathersEventType.RESIZE, drawer_resizeHandler);
			this.addChildAt(this._leftDrawer, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_leftDrawer();
	}

	/**
	 * @private
	 */
	private var _leftDrawerDockMode:String = DOCK_MODE_NONE;

	#if 0
	[Inspectable(type="String",enumeration="portrait,landscape,both,none")]
	#end
	/**
	 * Determines if the left drawer is docked in all, some, or no stage
	 * orientations. The current stage orientation is determined by
	 * calculating the aspect ratio of the stage.
	 *
	 * <p>In the following example, the left drawer is docked in the
	 * landscape stage orientation:</p>
	 *
	 * <listing version="3.0">
	 * drawers.leftDrawerDockMode = Drawers.DOCK_MODE_LANDSCAPE;</listing>
	 *
	 * @default Drawers.DOCK_MODE_NONE
	 *
	 * @see #DOCK_MODE_PORTRAIT
	 * @see #DOCK_MODE_LANDSCAPE
	 * @see #DOCK_MODE_NONE
	 * @see #DOCK_MODE_BOTH
	 * @see #leftDrawer
	 */
	public var leftDrawerDockMode(get, set):String;
	public function get_leftDrawerDockMode():String
	{
		return this._leftDrawerDockMode;
	}

	/**
	 * @private
	 */
	public function set_leftDrawerDockMode(value:String):String
	{
		if(this._leftDrawerDockMode == value)
		{
			return get_leftDrawerDockMode();
		}
		this._leftDrawerDockMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_leftDrawerDockMode();
	}

	/**
	 * @private
	 */
	private var _leftDrawerToggleEventType:String;

	/**
	 * When this event is dispatched by the content event dispatcher, the
	 * left drawer will toggle open and closed.
	 *
	 * <p>In the following example, the left drawer is toggled when the
	 * content dispatches and event of type <code>Event.OPEN</code>:</p>
	 *
	 * <listing version="3.0">
	 * drawers.leftDrawerToggleEventType = Event.OPEN;</listing>
	 *
	 * @default null
	 *
	 * @see #content
	 * @see #leftDrawer
	 */
	public var leftDrawerToggleEventType(get, set):String;
	public function get_leftDrawerToggleEventType():String
	{
		return this._leftDrawerToggleEventType;
	}

	/**
	 * @private
	 */
	public function set_leftDrawerToggleEventType(value:String):String
	{
		if(this._leftDrawerToggleEventType == value)
		{
			return get_leftDrawerToggleEventType();
		}
		if(this.contentEventDispatcher != null && this._leftDrawerToggleEventType != null)
		{
			this.contentEventDispatcher.removeEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
		}
		this._leftDrawerToggleEventType = value;
		if(this.contentEventDispatcher != null && this._leftDrawerToggleEventType != null)
		{
			this.contentEventDispatcher.addEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
		}
		return get_leftDrawerToggleEventType();
	}

	/**
	 * @private
	 */
	private var _isLeftDrawerOpen:Bool = false;

	/**
	 * Indicates if the left drawer is currently open. If you want to check
	 * if the left drawer is docked, check <code>isLeftDrawerDocked</code>
	 * instead.
	 *
	 * <p>To animate the left drawer open or closed, call
	 * <code>toggleLeftDrawer()</code>. Setting <code>isLeftDrawerOpen</code>
	 * will open or close the left drawer without animation.</p>
	 *
	 * <p>In the following example, we check if the left drawer is open:</p>
	 *
	 * <listing version="3.0">
	 * if( drawers.isLeftDrawerOpen )
	 * {
	 *     // do something
	 * }</listing>
	 *
	 * @default false
	 *
	 * @see #leftDrawer
	 * @see #isLeftDrawerDocked
	 * @see #toggleLeftDrawer()
	 */
	public var isLeftDrawerOpen(get, set):Bool;
	public function get_isLeftDrawerOpen():Bool
	{
		return this._leftDrawer != null && this._isLeftDrawerOpen;
	}

	/**
	 * @private
	 */
	public function set_isLeftDrawerOpen(value:Bool):Bool
	{
		if(this.isLeftDrawerDocked || this._isLeftDrawerOpen == value)
		{
			return get_isLeftDrawerOpen();
		}
		this._isLeftDrawerOpen = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_isLeftDrawerOpen();
	}

	/**
	 * Indicates if the left drawer is currently docked. Docking behavior of
	 * the left drawer is controlled with the <code>leftDrawerDockMode</code>
	 * property. To check if the left drawer is open, but not docked, use
	 * the <code>isLeftDrawerOpen</code> property.
	 *
	 * @see #leftDrawer
	 * @see #leftDrawerDockMode
	 * @see #isLeftDrawerOpen
	 */
	public var isLeftDrawerDocked(get, never):Bool;
	public function get_isLeftDrawerDocked():Bool
	{
		if(this._leftDrawer == null)
		{
			return false;
		}
		if(this._leftDrawerDockMode == DOCK_MODE_BOTH)
		{
			return true;
		}
		if(this._leftDrawerDockMode == DOCK_MODE_NONE)
		{
			return false;
		}
		var stage:Stage = this.stage;
		if(stage == null)
		{
			//fall back to the current stage, but it may be wrong...
			stage = Starling.current.stage;
		}
		if(stage.stageWidth > stage.stageHeight)
		{
			return this._leftDrawerDockMode == DOCK_MODE_LANDSCAPE;
		}
		return this._leftDrawerDockMode == DOCK_MODE_PORTRAIT;
	}

	/**
	 * @private
	 */
	private var _autoSizeMode:String = AUTO_SIZE_MODE_STAGE;

	//[Inspectable(type="String",enumeration="stage,content")]
	/**
	 * Determines how the drawers container will set its own size when its
	 * dimensions (width and height) aren't set explicitly.
	 *
	 * <p>In the following example, the drawers container will be sized to
	 * match its content:</p>
	 *
	 * <listing version="3.0">
	 * drawers.autoSizeMode = Drawers.AUTO_SIZE_MODE_CONTENT;</listing>
	 *
	 * @default Drawers.AUTO_SIZE_MODE_STAGE
	 *
	 * @see #AUTO_SIZE_MODE_STAGE
	 * @see #AUTO_SIZE_MODE_CONTENT
	 */
	public var autoSizeMode(get, set):String;
	public function get_autoSizeMode():String
	{
		return this._autoSizeMode;
	}

	/**
	 * @private
	 */
	public function set_autoSizeMode(value:String):String
	{
		if(this._autoSizeMode == value)
		{
			return get_autoSizeMode();
		}
		this._autoSizeMode = value;
		if(this._content != null)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
			{
				this._content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			else
			{
				this._content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_autoSizeMode();
	}

	/**
	 * @private
	 */
	private var _clipDrawers:Bool = true;

	/**
	 * Determines if the drawers are clipped while opening or closing. If
	 * the content does not have a background, the drawers should
	 * generally be clipped so that the drawer does not show under the
	 * content. If the content has a fully opaque background that will
	 * conceal the drawers, then clipping may be disabled to potentially
	 * improve performance.
	 *
	 * <p>In the following example, clipping will be disabled:</p>
	 *
	 * <listing version="3.0">
	 * navigator.clipDrawers = false;</listing>
	 *
	 * @default true
	 *
	 * @see #topDrawer
	 * @see #rightDrawer
	 * @see #bottomDrawer
	 * @see #leftDrawer
	 */
	public var clipDrawers(get, set):Bool;
	public function get_clipDrawers():Bool
	{
		return this._clipDrawers;
	}

	/**
	 * @private
	 */
	public function set_clipDrawers(value:Bool):Bool
	{
		if(this._clipDrawers == value)
		{
			return get_clipDrawers();
		}
		this._clipDrawers = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_clipDrawers();
	}

	/**
	 * @private
	 */
	private var _openGesture:String = OPEN_GESTURE_DRAG_CONTENT_EDGE;

	#if 0
	[Inspectable(type="String",enumeration="dragContentEdge,dragContent,none")]
	#end
	/**
	 * An optional touch gesture used to open a drawer.
	 *
	 * <p>In the following example, the drawers are opened by dragging
	 * anywhere inside the content:</p>
	 *
	 * <listing version="3.0">
	 * drawers.openGesture = Drawers.OPEN_GESTURE_DRAG_CONTENT;</listing>
	 *
	 * @default Drawers.OPEN_GESTURE_DRAG_CONTENT_EDGE
	 *
	 * @see #OPEN_GESTURE_NONE
	 * @see #OPEN_GESTURE_DRAG_CONTENT
	 * @see #OPEN_GESTURE_DRAG_CONTENT_EDGE
	 */
	public var openGesture(get, set):String;
	public function get_openGesture():String
	{
		return this._openGesture;
	}

	/**
	 * @private
	 */
	public function set_openGesture(value:String):String
	{
		this._openGesture = value;
		return get_openGesture();
	}

	/**
	 * @private
	 */
	private var _minimumDragDistance:Float = 0.04;

	/**
	 * The minimum physical distance (in inches) that a touch must move
	 * before a drag gesture begins.
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
	private var _minimumDrawerThrowVelocity:Float = 5;

	/**
	 * The minimum physical velocity (in inches per second) that a touch
	 * must move before the a drawern can be "thrown" to open or close it.
	 * Otherwise, it will settle open or closed based on which state is
	 * closer when the touch ends.
	 *
	 * <p>In the following example, the minimum drawer throw velocity is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.minimumDrawerThrowVelocity = 2;</listing>
	 *
	 * @default 5
	 */
	public var minimumDrawerThrowVelocity(get, set):Float;
	public function get_minimumDrawerThrowVelocity():Float
	{
		return this._minimumDrawerThrowVelocity;
	}

	/**
	 * @private
	 */
	public function set_minimumDrawerThrowVelocity(value:Float):Float
	{
		this._minimumDrawerThrowVelocity = value;
		return get_minimumDrawerThrowVelocity();
	}

	/**
	 * @private
	 */
	private var _openGestureEdgeSize:Float = 0.1;

	/**
	 * The minimum physical distance (in inches) that a touch must move
	 * before a drag gesture begins.
	 *
	 * <p>In the following example, the open gesture edge size customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.openGestureEdgeSize = 0.25;</listing>
	 *
	 * @default 0.1
	 */
	public var openGestureEdgeSize(get, set):Float;
	public function get_openGestureEdgeSize():Float
	{
		return this._openGestureEdgeSize;
	}

	/**
	 * @private
	 */
	public function set_openGestureEdgeSize(value:Float):Float
	{
		this._openGestureEdgeSize = value;
		return get_openGestureEdgeSize();
	}

	/**
	 * @private
	 */
	private var _contentEventDispatcherChangeEventType:String;

	/**
	 * The event dispatched by the content to indicate that the content
	 * event dispatcher has changed. When this event is dispatched by the
	 * content, the drawers container will listen for the drawer toggle
	 * events from the new dispatcher that discovered using
	 * <code>contentEventDispatcherField</code> or
	 * <code>contentEventDispatcherFunction</code>.
	 *
	 * <p>For <code>StackScreenNavigator</code> and
	 * <code>ScreenNavigator</code> components, this value is automatically
	 * set to <code>Event.CHANGE</code>.</p>
	 *
	 * <p>In the following example, the drawers container will update its
	 * content event dispatcher when the content dispatches an event of type
	 * <code>Event.CHANGE</code>:</p>
	 *
	 * <listing version="3.0">
	 * drawers.contentEventDispatcherChangeEventType = Event.CHANGE;</listing>
	 *
	 * @default null
	 *
	 * @see #contentEventDispatcherField
	 * @see #contentEventDispatcherFunction
	 */
	public var contentEventDispatcherChangeEventType(get, set):String;
	public function get_contentEventDispatcherChangeEventType():String
	{
		return this._contentEventDispatcherChangeEventType;
	}

	/**
	 * @private
	 */
	public function set_contentEventDispatcherChangeEventType(value:String):String
	{
		if(this._contentEventDispatcherChangeEventType == value)
		{
			return get_contentEventDispatcherChangeEventType();
		}
		if(this._content != null && this._contentEventDispatcherChangeEventType != null)
		{
			this._content.removeEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
		}
		this._contentEventDispatcherChangeEventType = value;
		if(this._content != null && this._contentEventDispatcherChangeEventType != null)
		{
			this._content.addEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
		}
		return get_contentEventDispatcherChangeEventType();
	}

	/**
	 * @private
	 */
	private var _contentEventDispatcherField:String;

	/**
	 * A property of the <code>content</code> that references an event
	 * dispatcher that dispatches events to toggle drawers open and closed.
	 *
	 * <p>For <code>StackScreenNavigator</code> and
	 * <code>ScreenNavigator</code> components, this value is automatically
	 * set to <code>"activeScreen"</code> to listen for events from the
	 * currently active/visible screen.</p>
	 *
	 * <p>In the following example, the content event dispatcher field is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * drawers.contentEventDispatcherField = "selectedChild";</listing>
	 *
	 * @default null
	 *
	 * @see #contentEventDispatcherFunction
	 * @see #contentEventDispatcherChangeEventType
	 * @see #topDrawerToggleEventType
	 * @see #rightDrawerToggleEventType
	 * @see #bottomDrawerToggleEventType
	 * @see #leftDrawerToggleEventType
	 */
	public var contentEventDispatcherField(get, set):String;
	public function get_contentEventDispatcherField():String
	{
		return this._contentEventDispatcherField;
	}

	/**
	 * @private
	 */
	public function set_contentEventDispatcherField(value:String):String
	{
		if(this._contentEventDispatcherField == value)
		{
			return get_contentEventDispatcherField();
		}
		this._contentEventDispatcherField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_contentEventDispatcherField();
	}

	/**
	 * @private
	 */
	private var _contentEventDispatcherFunction:Dynamic->EventDispatcher;

	/**
	 * A function that returns an event dispatcher that dispatches events to
	 * toggle drawers open and closed.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function( content:DisplayObject ):EventDispatcher</pre>
	 *
	 * <p>In the following example, the content event dispatcher function is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * drawers.contentEventDispatcherField = function( content:CustomView ):Void
	 * {
	 *     return content.selectedChild;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #contentEventDispatcherField
	 * @see #contentEventDispatcherChangeEventType
	 * @see #topDrawerToggleEventType
	 * @see #rightDrawerToggleEventType
	 * @see #bottomDrawerToggleEventType
	 * @see #leftDrawerToggleEventType
	 */
	public var contentEventDispatcherFunction(get, set):Dynamic->EventDispatcher;
	public function get_contentEventDispatcherFunction():Dynamic->EventDispatcher
	{
		return this._contentEventDispatcherFunction;
	}

	/**
	 * @private
	 */
	public function set_contentEventDispatcherFunction(value:Dynamic->EventDispatcher):Dynamic->EventDispatcher
	{
		if(this._contentEventDispatcherFunction == value)
		{
			return get_contentEventDispatcherFunction();
		}
		this._contentEventDispatcherFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_contentEventDispatcherFunction();
	}

	/**
	 * @private
	 */
	private var _openOrCloseTween:Tween;

	/**
	 * @private
	 */
	private var _openOrCloseDuration:Float = 0.25;

	/**
	 * The duration, in seconds, of the animation when a drawer opens or
	 * closes.
	 *
	 * <p>In the following example, the duration of the animation that opens
	 * or closes a drawer is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.openOrCloseDuration = 0.5;</listing>
	 *
	 * @default 0.25
	 *
	 * @see #openOrCloseEase
	 */
	public var openOrCloseDuration(get, set):Float;
	public function get_openOrCloseDuration():Float
	{
		return this._openOrCloseDuration;
	}

	/**
	 * @private
	 */
	public function set_openOrCloseDuration(value:Float):Float
	{
		this._openOrCloseDuration = value;
		return get_openOrCloseDuration();
	}

	/**
	 * @private
	 */
	private var _openOrCloseEase:Dynamic = Transitions.EASE_OUT;

	/**
	 * The easing function used for opening or closing the drawers.
	 *
	 * <p>In the following example, the ease of the animation that opens and
	 * closes a drawer is customized:</p>
	 *
	 * <listing version="3.0">
	 * drawrs.openOrCloseEase = Transitions.EASE_IN_OUT;</listing>
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 *
	 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
	 * @see #openOrCloseDuration
	 */
	public var openOrCloseEase(get, set):Dynamic;
	public function get_openOrCloseEase():Dynamic
	{
		return this._openOrCloseEase;
	}

	/**
	 * @private
	 */
	public function set_openOrCloseEase(value:Dynamic):Dynamic
	{
		this._openOrCloseEase = value;
		return get_openOrCloseEase();
	}

	/**
	 * @private
	 */
	private var isToggleTopDrawerPending:Bool = false;

	/**
	 * @private
	 */
	private var isToggleRightDrawerPending:Bool = false;

	/**
	 * @private
	 */
	private var isToggleBottomDrawerPending:Bool = false;

	/**
	 * @private
	 */
	private var isToggleLeftDrawerPending:Bool = false;

	/**
	 * @private
	 */
	private var pendingToggleDuration:Float;

	/**
	 * @private
	 */
	private var touchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _isDragging:Bool = false;

	/**
	 * @private
	 */
	private var _isDraggingTopDrawer:Bool = false;

	/**
	 * @private
	 */
	private var _isDraggingRightDrawer:Bool = false;

	/**
	 * @private
	 */
	private var _isDraggingBottomDrawer:Bool = false;

	/**
	 * @private
	 */
	private var _isDraggingLeftDrawer:Bool = false;

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
	override public function hitTest(localPoint:Point, forTouch:Bool = false):DisplayObject
	{
		var result:DisplayObject = super.hitTest(localPoint, forTouch);
		if(result != null)
		{
			if(!forTouch)
			{
				return result;
			}
			if(this._isDragging)
			{
				return this;
			}
			if(this.isTopDrawerOpen && result != this._topDrawer && !(Std.is(this._topDrawer, DisplayObjectContainer) && cast(this._topDrawer, DisplayObjectContainer).contains(result)))
			{
				return this;
			}
			else if(this.isRightDrawerOpen && result != this._rightDrawer && !(Std.is(this._rightDrawer, DisplayObjectContainer) && cast(this._rightDrawer, DisplayObjectContainer).contains(result)))
			{
				return this;
			}
			else if(this.isBottomDrawerOpen && result != this._bottomDrawer && !(Std.is(this._bottomDrawer, DisplayObjectContainer) && cast(this._bottomDrawer, DisplayObjectContainer).contains(result)))
			{
				return this;
			}
			else if(this.isLeftDrawerOpen && result != this._leftDrawer && !(Std.is(this._leftDrawer, DisplayObjectContainer) && cast(this._leftDrawer, DisplayObjectContainer).contains(result)))
			{
				return this;
			}
			return result;
		}
		//we want to register touches in our hitArea as a last resort
		if(forTouch && (!this.visible || !this.touchable))
		{
			return null;
		}
		return this._hitArea.contains(localPoint.x, localPoint.y) ? this : null;
	}

	/**
	 * Opens or closes the top drawer. If the <code>duration</code> argument
	 * is <code>NaN</code>, the default <code>openOrCloseDuration</code> is
	 * used. The default value of the <code>duration</code> argument is
	 * <code>NaN</code>. Otherwise, this value is the duration of the
	 * animation, in seconds.
	 *
	 * <p>To open or close the top drawer without animation, set the
	 * <code>isTopDrawerOpen</code> property.</p>
	 *
	 * @see #isTopDrawerOpen
	 * @see #openOrCloseDuration
	 * @see #openOrCloseEase
	 */
	public function toggleTopDrawer(duration:Null<Float> = null):Void
	{
		if (duration == null) duration = Math.NaN;
		if(this._topDrawer == null || this.isTopDrawerDocked)
		{
			return;
		}
		this.pendingToggleDuration = duration;
		if(this.isToggleTopDrawerPending)
		{
			return;
		}
		this.isToggleTopDrawerPending = true;
		this.isToggleRightDrawerPending = false;
		this.isToggleBottomDrawerPending = false;
		this.isToggleLeftDrawerPending = false;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * Opens or closes the right drawer. If the <code>duration</code> argument
	 * is <code>NaN</code>, the default <code>openOrCloseDuration</code> is
	 * used. The default value of the <code>duration</code> argument is
	 * <code>NaN</code>. Otherwise, this value is the duration of the
	 * animation, in seconds.
	 *
	 * <p>To open or close the right drawer without animation, set the
	 * <code>isRightDrawerOpen</code> property.</p>
	 *
	 * @see #isRightDrawerOpen
	 * @see #openOrCloseDuration
	 * @see #openOrCloseEase
	 */
	public function toggleRightDrawer(duration:Null<Float> = null):Void
	{
		if (duration == null) duration = Math.NaN;
		if(this._rightDrawer == null || this.isRightDrawerDocked)
		{
			return;
		}
		this.pendingToggleDuration = duration;
		if(this.isToggleRightDrawerPending)
		{
			return;
		}
		this.isToggleTopDrawerPending = false;
		this.isToggleRightDrawerPending = true;
		this.isToggleBottomDrawerPending = false;
		this.isToggleLeftDrawerPending = false;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * Opens or closes the bottom drawer. If the <code>duration</code> argument
	 * is <code>NaN</code>, the default <code>openOrCloseDuration</code> is
	 * used. The default value of the <code>duration</code> argument is
	 * <code>NaN</code>. Otherwise, this value is the duration of the
	 * animation, in seconds.
	 *
	 * <p>To open or close the bottom drawer without animation, set the
	 * <code>isBottomDrawerOpen</code> property.</p>
	 *
	 * @see #isBottomDrawerOpen
	 * @see #openOrCloseDuration
	 * @see #openOrCloseEase
	 */
	public function toggleBottomDrawer(duration:Null<Float> = null):Void
	{
		if (duration == null) duration = Math.NaN;
		if(this._bottomDrawer == null || this.isBottomDrawerDocked)
		{
			return;
		}
		this.pendingToggleDuration = duration;
		if(this.isToggleBottomDrawerPending)
		{
			return;
		}
		this.isToggleTopDrawerPending = false;
		this.isToggleRightDrawerPending = false;
		this.isToggleBottomDrawerPending = true;
		this.isToggleLeftDrawerPending = false;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * Opens or closes the left drawer. If the <code>duration</code> argument
	 * is <code>NaN</code>, the default <code>openOrCloseDuration</code> is
	 * used. The default value of the <code>duration</code> argument is
	 * <code>NaN</code>. Otherwise, this value is the duration of the
	 * animation, in seconds.
	 *
	 * <p>To open or close the left drawer without animation, set the
	 * <code>isLeftDrawerOpen</code> property.</p>
	 *
	 * @see #isLeftDrawerOpen
	 * @see #openOrCloseDuration
	 * @see #openOrCloseEase
	 */
	public function toggleLeftDrawer(duration:Null<Float> = null):Void
	{
		if (duration == null) duration = Math.NaN;
		if(this._leftDrawer == null || this.isLeftDrawerDocked)
		{
			return;
		}
		this.pendingToggleDuration = duration;
		if(this.isToggleLeftDrawerPending)
		{
			return;
		}
		this.isToggleTopDrawerPending = false;
		this.isToggleRightDrawerPending = false;
		this.isToggleBottomDrawerPending = false;
		this.isToggleLeftDrawerPending = true;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var layoutInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_LAYOUT);

		if(dataInvalid)
		{
			this.refreshCurrentEventTarget();
		}

		if(sizeInvalid || layoutInvalid)
		{
			this.refreshDrawerStates();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layoutChildren();

		this.handlePendingActions();
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

		if((this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || this.stage == null) &&
			Std.is(this._content, IValidating))
		{
			cast(this._content, IValidating).validate();
			var isTopDrawerDocked:Bool = this.isTopDrawerDocked;
			if(isTopDrawerDocked && Std.is(this._topDrawer, IValidating))
			{
				cast(this._topDrawer, IValidating).validate();
			}
			var isRightDrawerDocked:Bool = this.isRightDrawerDocked;
			if(isRightDrawerDocked && Std.is(this._rightDrawer, IValidating))
			{
				cast(this._rightDrawer, IValidating).validate();
			}
			var isBottomDrawerDocked:Bool = this.isBottomDrawerDocked;
			if(isBottomDrawerDocked && Std.is(this._bottomDrawer, IValidating))
			{
				cast(this._bottomDrawer, IValidating).validate();
			}
			var isLeftDrawerDocked:Bool = this.isLeftDrawerDocked;
			if(isLeftDrawerDocked && Std.is(this._leftDrawer, IValidating))
			{
				cast(this._leftDrawer, IValidating).validate();
			}
		}

		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || this.stage == null)
			{
				newWidth = this._content != null ? this._content.width : 0;
				if(isLeftDrawerDocked)
				{
					newWidth += this._leftDrawer.width;
				}
				if(isRightDrawerDocked)
				{
					newWidth += this._rightDrawer.width;
				}
			}
			else
			{
				newWidth = this.stage.stageWidth;
			}
		}

		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || this.stage == null)
			{
				newHeight = this._content != null ? this._content.height : 0;
				if(isTopDrawerDocked)
				{
					newHeight += this._topDrawer.width;
				}
				if(isBottomDrawerDocked)
				{
					newHeight += this._bottomDrawer.width;
				}
			}
			else
			{
				newHeight = this.stage.stageHeight;
			}
		}

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Positions and sizes the children.
	 */
	private function layoutChildren():Void
	{
		if(Std.is(this._topDrawer, IValidating))
		{
			cast(this._topDrawer, IValidating).validate();
		}
		if(Std.is(this._rightDrawer, IValidating))
		{
			cast(this._rightDrawer, IValidating).validate();
		}
		if(Std.is(this._bottomDrawer, IValidating))
		{
			cast(this._bottomDrawer, IValidating).validate();
		}
		if(Std.is(this._leftDrawer, IValidating))
		{
			cast(this._leftDrawer, IValidating).validate();
		}
		var isTopDrawerOpen:Bool = this.isTopDrawerOpen;
		var isRightDrawerOpen:Bool = this.isRightDrawerOpen;
		var isBottomDrawerOpen:Bool = this.isBottomDrawerOpen;
		var isLeftDrawerOpen:Bool = this.isLeftDrawerOpen;
		var isTopDrawerDocked:Bool = this.isTopDrawerDocked;
		var isRightDrawerDocked:Bool = this.isRightDrawerDocked;
		var isBottomDrawerDocked:Bool = this.isBottomDrawerDocked;
		var isLeftDrawerDocked:Bool = this.isLeftDrawerDocked;
		var topDrawerHeight:Float = this._topDrawer != null ? this._topDrawer.height : 0;
		var rightDrawerWidth:Float = this._rightDrawer != null ? this._rightDrawer.width : 0;
		var bottomDrawerHeight:Float = this._bottomDrawer != null ? this._bottomDrawer.height : 0;
		var leftDrawerWidth:Float = this._leftDrawer != null ? this._leftDrawer.width : 0;

		var contentWidth:Float = this.actualWidth;
		if(isLeftDrawerDocked)
		{
			contentWidth -= leftDrawerWidth;
		}
		if(isRightDrawerDocked)
		{
			contentWidth -= rightDrawerWidth;
		}
		var contentHeight:Float = this.actualHeight;
		if(isTopDrawerDocked)
		{
			contentHeight -= topDrawerHeight;
		}
		if(isBottomDrawerDocked)
		{
			contentHeight -= bottomDrawerHeight;
		}

		if(isRightDrawerOpen)
		{
			var contentX:Float = -rightDrawerWidth;
			if(isLeftDrawerDocked)
			{
				contentX += leftDrawerWidth;
			}
			this._content.x = contentX;
		}
		else if(isLeftDrawerOpen || isLeftDrawerDocked)
		{
			this._content.x = leftDrawerWidth;
		}
		else
		{
			this._content.x = 0;
		}
		if(isBottomDrawerOpen)
		{
			var contentY:Float = -bottomDrawerHeight;
			if(isTopDrawerDocked)
			{
				contentY += topDrawerHeight;
			}
			this._content.y = contentY;
		}
		else if(isTopDrawerOpen || isTopDrawerDocked)
		{
			this._content.y = topDrawerHeight;
		}
		else
		{
			this._content.y = 0;
		}
		if(this._autoSizeMode != AUTO_SIZE_MODE_CONTENT)
		{
			this._content.width = contentWidth;
			this._content.height = contentHeight;

			//final validation to avoid juggler next frame issues
			if(Std.is(this._content, IValidating))
			{
				cast(this._content, IValidating).validate();
			}
		}

		if(this._topDrawer != null)
		{
			var topDrawerX:Float = 0;
			var topDrawerY:Float = 0;
			if(isTopDrawerDocked)
			{
				if(isBottomDrawerOpen)
				{
					topDrawerY -= bottomDrawerHeight;
				}
				if(!isLeftDrawerDocked)
				{
					topDrawerX = this._content.x;
				}
			}
			this._topDrawer.x = topDrawerX;
			this._topDrawer.y = topDrawerY;
			this._topDrawer.width = this.actualWidth;
			this._topDrawer.visible = isTopDrawerOpen || isTopDrawerDocked;

			//final validation to avoid juggler next frame issues
			if(Std.is(this._topDrawer, IValidating))
			{
				cast(this._topDrawer, IValidating).validate();
			}
		}

		if(this._rightDrawer != null)
		{
			var rightDrawerX:Float = this.actualWidth - rightDrawerWidth;
			var rightDrawerY:Float = 0;
			var rightDrawerHeight:Float = this.actualHeight;
			if(isRightDrawerDocked)
			{
				rightDrawerX = this._content.x + this._content.width;
				if(isTopDrawerDocked)
				{
					rightDrawerHeight -= topDrawerHeight;
				}
				if(isBottomDrawerDocked)
				{
					rightDrawerHeight -= bottomDrawerHeight;
				}
				rightDrawerY = this._content.y;
			}
			this._rightDrawer.x = rightDrawerX;
			this._rightDrawer.y = rightDrawerY;
			this._rightDrawer.height = rightDrawerHeight;
			this._rightDrawer.visible = isRightDrawerOpen || isRightDrawerDocked;

			//final validation to avoid juggler next frame issues
			if(Std.is(this._rightDrawer, IValidating))
			{
				cast(this._rightDrawer, IValidating).validate();
			}
		}

		if(this._bottomDrawer != null)
		{
			var bottomDrawerX:Float = 0;
			var bottomDrawerY:Float = this.actualHeight - bottomDrawerHeight;
			if(isBottomDrawerDocked)
			{
				if(!isLeftDrawerDocked)
				{
					bottomDrawerX = this._content.x;
				}
				bottomDrawerY = this._content.y + this._content.height;
			}
			this._bottomDrawer.x = bottomDrawerX;
			this._bottomDrawer.y = bottomDrawerY;
			this._bottomDrawer.width = this.actualWidth;
			this._bottomDrawer.visible = isBottomDrawerOpen || isBottomDrawerDocked;

			//final validation to avoid juggler next frame issues
			if(Std.is(this._bottomDrawer, IValidating))
			{
				cast(this._bottomDrawer, IValidating).validate();
			}
		}

		if(this._leftDrawer != null)
		{
			var leftDrawerX:Float = 0;
			var leftDrawerY:Float = 0;
			var leftDrawerHeight:Float = this.actualHeight;
			if(isLeftDrawerDocked)
			{
				if(isRightDrawerOpen)
				{
					leftDrawerX -= rightDrawerWidth;
				}
				if(isTopDrawerDocked)
				{
					leftDrawerHeight -= topDrawerHeight;
				}
				if(isBottomDrawerDocked)
				{
					leftDrawerHeight -= bottomDrawerHeight;
				}
				leftDrawerY = this._content.y;
			}
			this._leftDrawer.x = leftDrawerX;
			this._leftDrawer.y = leftDrawerY;
			this._leftDrawer.height = leftDrawerHeight;
			this._leftDrawer.visible = isLeftDrawerOpen || isLeftDrawerDocked;

			//final validation to avoid juggler next frame issues
			if(Std.is(this._leftDrawer, IValidating))
			{
				cast(this._leftDrawer, IValidating).validate();
			}
		}

		if(this._overlaySkin != null)
		{
			this.positionOverlaySkin();
			this._overlaySkin.width = this.actualWidth;
			this._overlaySkin.height = this.actualHeight;

			//final validation to avoid juggler next frame issues
			if(Std.is(this._overlaySkin, IValidating))
			{
				cast(this._overlaySkin, IValidating).validate();
			}
		}
	}

	/**
	 * @private
	 */
	private function handlePendingActions():Void
	{
		if(this.isToggleTopDrawerPending)
		{
			this._isTopDrawerOpen = !this._isTopDrawerOpen;
			this.isToggleTopDrawerPending = false;
			this.openOrCloseTopDrawer();
		}
		else if(this.isToggleRightDrawerPending)
		{
			this._isRightDrawerOpen = !this._isRightDrawerOpen;
			this.isToggleRightDrawerPending = false;
			this.openOrCloseRightDrawer();
		}
		else if(this.isToggleBottomDrawerPending)
		{
			this._isBottomDrawerOpen = !this._isBottomDrawerOpen;
			this.isToggleBottomDrawerPending = false;
			this.openOrCloseBottomDrawer();
		}
		else if(this.isToggleLeftDrawerPending)
		{
			this._isLeftDrawerOpen = !this._isLeftDrawerOpen;
			this.isToggleLeftDrawerPending = false;
			this.openOrCloseLeftDrawer();
		}
	}

	/**
	 * @private
	 */
	private function openOrCloseTopDrawer():Void
	{
		if(this._topDrawer == null || this.isTopDrawerDocked)
		{
			return;
		}
		if(this._openOrCloseTween != null)
		{
			this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
			Starling.current.juggler.remove(this._openOrCloseTween);
			this._openOrCloseTween = null;
		}
		this.applyTopClipRect();
		if(this._overlaySkin != null)
		{
			this._overlaySkin.visible = true;
			if(this._isTopDrawerOpen)
			{
				this._overlaySkin.alpha = 0;
			}
			else
			{
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
			}
		}
		this._topDrawer.visible = true;
		var targetPosition:Float = this._isTopDrawerOpen ? this._topDrawer.height : 0;
		var duration:Float = this.pendingToggleDuration;
		if(duration != duration) //isNaN
		{
			duration = this._openOrCloseDuration;
		}
		this.pendingToggleDuration = Math.NaN;
		this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
		this._openOrCloseTween.animate("y", targetPosition);
		this._openOrCloseTween.onUpdate = topDrawerOpenOrCloseTween_onUpdate;
		this._openOrCloseTween.onComplete = topDrawerOpenOrCloseTween_onComplete;
		Starling.current.juggler.add(this._openOrCloseTween);
	}

	/**
	 * @private
	 */
	private function openOrCloseRightDrawer():Void
	{
		if(this._rightDrawer == null || this.isRightDrawerDocked)
		{
			return;
		}
		if(this._openOrCloseTween != null)
		{
			this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
			Starling.current.juggler.remove(this._openOrCloseTween);
			this._openOrCloseTween = null;
		}
		this.applyRightClipRect();
		if(this._overlaySkin != null)
		{
			this._overlaySkin.visible = true;
			if(this._isRightDrawerOpen)
			{
				this._overlaySkin.alpha = 0;
			}
			else
			{
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
			}
		}
		this._rightDrawer.visible = true;
		var targetPosition:Float = 0;
		if(this._isRightDrawerOpen)
		{
			targetPosition = -this._rightDrawer.width;
		}
		if(this.isLeftDrawerDocked)
		{
			targetPosition += this._leftDrawer.width;
		}
		var duration:Float = this.pendingToggleDuration;
		if(duration != duration) //isNaN
		{
			duration = this._openOrCloseDuration;
		}
		this.pendingToggleDuration = Math.NaN;
		this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
		this._openOrCloseTween.animate("x", targetPosition);
		this._openOrCloseTween.onUpdate = rightDrawerOpenOrCloseTween_onUpdate;
		this._openOrCloseTween.onComplete = rightDrawerOpenOrCloseTween_onComplete;
		Starling.current.juggler.add(this._openOrCloseTween);
	}

	/**
	 * @private
	 */
	private function openOrCloseBottomDrawer():Void
	{
		if(this._bottomDrawer == null || this.isBottomDrawerDocked)
		{
			return;
		}
		if(this._openOrCloseTween != null)
		{
			this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
			Starling.current.juggler.remove(this._openOrCloseTween);
			this._openOrCloseTween = null;
		}
		this.applyBottomClipRect();
		if(this._overlaySkin != null)
		{
			this._overlaySkin.visible = true;
			if(this._isBottomDrawerOpen)
			{
				this._overlaySkin.alpha = 0;
			}
			else
			{
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
			}
		}
		this._bottomDrawer.visible = true;
		var targetPosition:Float = 0;
		if(this._isBottomDrawerOpen)
		{
			targetPosition = -this._bottomDrawer.height;
		}
		if(this.isTopDrawerDocked)
		{
			targetPosition += this._topDrawer.height;
		}
		var duration:Float = this.pendingToggleDuration;
		if(duration != duration) //isNaN
		{
			duration = this._openOrCloseDuration;
		}
		this.pendingToggleDuration = Math.NaN;
		this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
		this._openOrCloseTween.animate("y", targetPosition);
		this._openOrCloseTween.onUpdate = bottomDrawerOpenOrCloseTween_onUpdate;
		this._openOrCloseTween.onComplete = bottomDrawerOpenOrCloseTween_onComplete;
		Starling.current.juggler.add(this._openOrCloseTween);
	}

	/**
	 * @private
	 */
	private function openOrCloseLeftDrawer():Void
	{
		if(this._leftDrawer == null || this.isLeftDrawerDocked)
		{
			return;
		}
		if(this._openOrCloseTween != null)
		{
			this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
			Starling.current.juggler.remove(this._openOrCloseTween);
			this._openOrCloseTween = null;
		}
		this.applyLeftClipRect();
		if(this._overlaySkin != null)
		{
			this._overlaySkin.visible = true;
			if(this._isLeftDrawerOpen)
			{
				this._overlaySkin.alpha = 0;
			}
			else
			{
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
			}
		}
		this._leftDrawer.visible = true;
		var targetPosition:Float = this._isLeftDrawerOpen ? this._leftDrawer.width : 0;
		var duration:Float = this.pendingToggleDuration;
		if(duration != duration) //isNaN
		{
			duration = this._openOrCloseDuration;
		}
		this.pendingToggleDuration = Math.NaN;
		this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
		this._openOrCloseTween.animate("x", targetPosition);
		this._openOrCloseTween.onUpdate = leftDrawerOpenOrCloseTween_onUpdate;
		this._openOrCloseTween.onComplete = leftDrawerOpenOrCloseTween_onComplete;
		Starling.current.juggler.add(this._openOrCloseTween);
	}

	/**
	 * @private
	 */
	private function applyTopClipRect():Void
	{
		if(!this._clipDrawers || !Std.is(this._topDrawer, Sprite))
		{
			return;
		}
		var topSprite:Sprite = cast this._topDrawer;
		if(topSprite.clipRect == null)
		{
			topSprite.clipRect = new Rectangle(0, 0, this.actualWidth, this._content.y);
		}
	}

	/**
	 * @private
	 */
	private function applyRightClipRect():Void
	{
		if(!this._clipDrawers || !Std.is(this._rightDrawer, Sprite))
		{
			return;
		}
		var rightSprite:Sprite = cast this._rightDrawer;
		if(rightSprite.clipRect == null)
		{
			rightSprite.clipRect = new Rectangle(0, 0, -this._content.x, this.actualHeight);
		}
	}

	/**
	 * @private
	 */
	private function applyBottomClipRect():Void
	{
		if(!this._clipDrawers || !Std.is(this._bottomDrawer, Sprite))
		{
			return;
		}
		var bottomSprite:Sprite = cast this._bottomDrawer;
		if(bottomSprite.clipRect == null)
		{
			bottomSprite.clipRect = new Rectangle(0, 0, this.actualWidth, -this._content.y);
		}
	}

	/**
	 * @private
	 */
	private function applyLeftClipRect():Void
	{
		if(!this._clipDrawers || !Std.is(this._leftDrawer, Sprite))
		{
			return;
		}
		var leftSprite:Sprite = cast this._leftDrawer;
		if(leftSprite.clipRect == null)
		{
			leftSprite.clipRect = new Rectangle(0, 0, this._content.x, this.actualHeight);
		}
	}

	/**
	 * Uses the content event dispatcher fields and functions to generate a
	 * content event dispatcher icon for the content.
	 *
	 * <p>All of the content event dispatcher fields and functions, ordered
	 * by priority:</p>
	 * <ol>
	 *     <li><code>contentEventDispatcherFunction</code></li>
	 *     <li><code>contentEventDispatcherField</code></li>
	 * </ol>
	 *
	 * @see #content
	 * @see #contentEventDispatcherField
	 * @see #contentEventDispatcherFunction
	 * @see #contentEventDispatcherChangeEventType
	 */
	private function contentToContentEventDispatcher():EventDispatcher
	{
		if(this._contentEventDispatcherFunction != null)
		{
			return this._contentEventDispatcherFunction(this._content);
		}
		else if(this._contentEventDispatcherField != null && this._content != null && Reflect.getProperty(this._content, this._contentEventDispatcherField) != null)
		{
			return cast(Reflect.getProperty(this._content, this._contentEventDispatcherField), EventDispatcher);
		}
		return this._content;
	}

	/**
	 * @private
	 */
	private function refreshCurrentEventTarget():Void
	{
		if(this.contentEventDispatcher != null)
		{
			if(this._topDrawerToggleEventType != null)
			{
				this.contentEventDispatcher.removeEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
			}
			if(this._rightDrawerToggleEventType != null)
			{
				this.contentEventDispatcher.removeEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
			}
			if(this._bottomDrawerToggleEventType != null)
			{
				this.contentEventDispatcher.removeEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
			}
			if(this._leftDrawerToggleEventType != null)
			{
				this.contentEventDispatcher.removeEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
			}
		}
		this.contentEventDispatcher = this.contentToContentEventDispatcher();
		if(this.contentEventDispatcher != null)
		{
			if(this._topDrawerToggleEventType != null)
			{
				this.contentEventDispatcher.addEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
			}
			if(this._rightDrawerToggleEventType != null)
			{
				this.contentEventDispatcher.addEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
			}
			if(this._bottomDrawerToggleEventType != null)
			{
				this.contentEventDispatcher.addEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
			}
			if(this._leftDrawerToggleEventType != null)
			{
				this.contentEventDispatcher.addEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshDrawerStates():Void
	{
		var needsToHideOverlay:Bool = false;
		if(this.isTopDrawerDocked && this._isTopDrawerOpen)
		{
			this._isTopDrawerOpen = false;
			needsToHideOverlay = true;
		}
		if(this.isRightDrawerDocked && this._isRightDrawerOpen)
		{
			this._isRightDrawerOpen = false;
			needsToHideOverlay = true;
		}
		if(this.isBottomDrawerDocked && this._isBottomDrawerOpen)
		{
			this._isBottomDrawerOpen = false;
			needsToHideOverlay = true;
		}
		if(this.isLeftDrawerDocked && this._isLeftDrawerOpen)
		{
			this._isLeftDrawerOpen = false;
			needsToHideOverlay = true;
		}
		if(needsToHideOverlay && this._overlaySkin != null)
		{
			this._overlaySkin.alpha = 0;
			this._overlaySkin.visible = false;
		}
	}

	/**
	 * @private
	 */
	private function handleTapToClose(touch:Touch):Void
	{
		touch.getLocation(this.stage, HELPER_POINT);
		if(this != this.stage.hitTest(HELPER_POINT, true))
		{
			return;
		}

		if(this.isTopDrawerOpen)
		{
			this._isTopDrawerOpen = false;
			this.openOrCloseTopDrawer();
		}
		else if(this.isRightDrawerOpen)
		{
			this._isRightDrawerOpen = false;
			this.openOrCloseRightDrawer();
		}
		else if(this.isBottomDrawerOpen)
		{
			this._isBottomDrawerOpen = false;
			this.openOrCloseBottomDrawer();
		}
		else if(this.isLeftDrawerOpen)
		{
			this._isLeftDrawerOpen = false;
			this.openOrCloseLeftDrawer();
		}
	}

	/**
	 * @private
	 */
	private function handleTouchBegan(touch:Touch):Void
	{
		var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
		if(exclusiveTouch.getClaim(touch.id) != null)
		{
			//already claimed
			return;
		}

		touch.getLocation(this, HELPER_POINT);
		var localX:Float = HELPER_POINT.x;
		var localY:Float = HELPER_POINT.y;
		if(!this.isTopDrawerOpen && !this.isRightDrawerOpen && !this.isBottomDrawerOpen && !this.isLeftDrawerOpen)
		{
			if(this._openGesture == OPEN_GESTURE_NONE)
			{
				return;
			}
			if(this._openGesture == OPEN_GESTURE_DRAG_CONTENT_EDGE)
			{
				var isNearAnyEdge:Bool = false;
				if(this._topDrawer != null && !this.isTopDrawerDocked)
				{
					var topInches:Float = localY / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
					if(topInches >= 0 && topInches <= this._openGestureEdgeSize)
					{
						isNearAnyEdge = true;
					}
				}
				if(!isNearAnyEdge)
				{
					if(this._rightDrawer != null && !this.isRightDrawerDocked)
					{
						var rightInches:Float = (this.actualWidth - localX) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
						if(rightInches >= 0 && rightInches <= this._openGestureEdgeSize)
						{
							isNearAnyEdge = true;
						}
					}
					if(!isNearAnyEdge)
					{
						if(this._bottomDrawer != null && !this.isBottomDrawerDocked)
						{
							var bottomInches:Float = (this.actualHeight - localY) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
							if(bottomInches >= 0 && bottomInches <= this._openGestureEdgeSize)
							{
								isNearAnyEdge = true;
							}
						}
						if(!isNearAnyEdge)
						{
							if(this._leftDrawer != null && !this.isLeftDrawerDocked)
							{
								var leftInches:Float = localX / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
								if(leftInches >= 0 && leftInches <= this._openGestureEdgeSize)
								{
									isNearAnyEdge = true;
								}
							}
						}
					}
				}
				if(!isNearAnyEdge)
				{
					return;
				}
			}
		}
		else if(touch.target != this && !touch.isTouching(this._content) &&
			!(this.isTopDrawerDocked && touch.isTouching(this._topDrawer)) &&
			!(this.isRightDrawerDocked && touch.isTouching(this._rightDrawer)) &&
			!(this.isBottomDrawerDocked && touch.isTouching(this._bottomDrawer)) &&
			!(this.isLeftDrawerDocked && touch.isTouching(this._leftDrawer)))
		{
			//a drawer is open, let's only work with touches over the
			//content or other drawers that are docked
			return;
		}

		this.touchPointID = touch.id;
		this._velocityX = 0;
		this._velocityY = 0;
		this._previousVelocityX.splice(0, this._previousVelocityX.length);
		this._previousVelocityY.splice(0, this._previousVelocityY.length);
		this._previousTouchTime = getTimer();
		this._previousTouchX = this._startTouchX = this._currentTouchX = localX;
		this._previousTouchY = this._startTouchY = this._currentTouchY = localY;
		this._isDragging = false;
		this._isDraggingTopDrawer = false;
		this._isDraggingRightDrawer = false;
		this._isDraggingBottomDrawer = false;
		this._isDraggingLeftDrawer = false;

		exclusiveTouch.addEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
	}

	/**
	 * @private
	 */
	private function handleTouchMoved(touch:Touch):Void
	{
		touch.getLocation(this, HELPER_POINT);
		this._currentTouchX = HELPER_POINT.x;
		this._currentTouchY = HELPER_POINT.y;
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
	}

	/**
	 * @private
	 */
	private function handleDragEnd():Void
	{
		//take the average for more accuracy
		var sum:Float = this._velocityX * CURRENT_VELOCITY_WEIGHT;
		var velocityCount:Int = this._previousVelocityX.length;
		var totalWeight:Float = CURRENT_VELOCITY_WEIGHT;
		var weight:Float;
		for(i in 0 ... velocityCount)
		{
			weight = VELOCITY_WEIGHTS[i];
			sum += this._previousVelocityX.shift() * weight;
			totalWeight += weight;
		}
		var inchesPerSecondX:Float = 1000 * (sum / totalWeight) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);

		sum = this._velocityY * CURRENT_VELOCITY_WEIGHT;
		velocityCount = this._previousVelocityY.length;
		totalWeight = CURRENT_VELOCITY_WEIGHT;
		for(i in 0 ... velocityCount)
		{
			weight = VELOCITY_WEIGHTS[i];
			sum += this._previousVelocityY.shift() * weight;
			totalWeight += weight;
		}
		var inchesPerSecondY:Float = 1000 * (sum / totalWeight) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);

		this._isDragging = false;
		var positionToCheck:Float;
		if(this._isDraggingTopDrawer)
		{
			this._isDraggingTopDrawer = false;
			if(!this._isTopDrawerOpen && inchesPerSecondY > this._minimumDrawerThrowVelocity)
			{
				this._isTopDrawerOpen = true;
			}
			else if(this._isTopDrawerOpen && inchesPerSecondY < -this._minimumDrawerThrowVelocity)
			{
				this._isTopDrawerOpen = false;
			}
			else
			{
				this._isTopDrawerOpen = roundToNearest(this._content.y, this._topDrawer.height) != 0;
			}
			this.openOrCloseTopDrawer();
		}
		else if(this._isDraggingRightDrawer)
		{
			this._isDraggingRightDrawer = false;
			if(!this._isRightDrawerOpen && inchesPerSecondX < -this._minimumDrawerThrowVelocity)
			{
				this._isRightDrawerOpen = true;
			}
			else if(this._isRightDrawerOpen && inchesPerSecondX > this._minimumDrawerThrowVelocity)
			{
				this._isRightDrawerOpen = false;
			}
			else
			{
				positionToCheck = 0;
				if(this.isLeftDrawerDocked)
				{
					positionToCheck = this._leftDrawer.width;
				}
				this._isRightDrawerOpen = roundToNearest(this._content.x, this._rightDrawer.width) != positionToCheck;
			}
			this.openOrCloseRightDrawer();
		}
		else if(this._isDraggingBottomDrawer)
		{
			this._isDraggingBottomDrawer = false;
			if(!this._isBottomDrawerOpen && inchesPerSecondY < -this._minimumDrawerThrowVelocity)
			{
				this._isBottomDrawerOpen = true;
			}
			else if(this._isBottomDrawerOpen && inchesPerSecondY > this._minimumDrawerThrowVelocity)
			{
				this._isBottomDrawerOpen = false;
			}
			else
			{
				positionToCheck = 0;
				if(this.isTopDrawerDocked)
				{
					positionToCheck = this._topDrawer.height;
				}
				this._isBottomDrawerOpen = roundToNearest(this._content.y, this._bottomDrawer.height) != positionToCheck;
			}
			this.openOrCloseBottomDrawer();
		}
		else if(this._isDraggingLeftDrawer)
		{
			this._isDraggingLeftDrawer = false;
			if(!this._isLeftDrawerOpen && inchesPerSecondX > this._minimumDrawerThrowVelocity)
			{
				this._isLeftDrawerOpen = true;
			}
			else if(this._isLeftDrawerOpen && inchesPerSecondX < -this._minimumDrawerThrowVelocity)
			{
				this._isLeftDrawerOpen = false;
			}
			else
			{
				this._isLeftDrawerOpen = roundToNearest(this._content.x, this._leftDrawer.width) != 0;
			}
			this.openOrCloseLeftDrawer();
		}
	}

	/**
	 * @private
	 */
	private function handleDragMove():Void
	{
		var contentX:Float = 0;
		var contentY:Float = 0;
		if(this.isLeftDrawerDocked)
		{
			contentX = this._leftDrawer.width;
		}
		if(this.isTopDrawerDocked)
		{
			contentY = this._topDrawer.height;
		}
		if(this._isDraggingLeftDrawer)
		{
			var leftDrawerWidth:Float = this._leftDrawer.width;
			if(this.isLeftDrawerOpen)
			{
				contentX = leftDrawerWidth + this._currentTouchX - this._startTouchX;
			}
			else
			{
				contentX = this._currentTouchX - this._startTouchX;
			}
			if(contentX < 0)
			{
				contentX = 0;
			}
			if(contentX > leftDrawerWidth)
			{
				contentX = leftDrawerWidth;
			}
		}
		else if(this._isDraggingRightDrawer)
		{
			var rightDrawerWidth:Float = this._rightDrawer.width;
			if(this.isRightDrawerOpen)
			{
				contentX = -rightDrawerWidth + this._currentTouchX - this._startTouchX;
			}
			else
			{
				contentX = this._currentTouchX - this._startTouchX;
			}
			if(contentX < -rightDrawerWidth)
			{
				contentX = -rightDrawerWidth;
			}
			if(contentX > 0)
			{
				contentX = 0;
			}
			if(this.isLeftDrawerDocked)
			{
				contentX += this._leftDrawer.width;
			}
		}
		else if(this._isDraggingTopDrawer)
		{
			var topDrawerHeight:Float = this._topDrawer.height;
			if(this.isTopDrawerOpen)
			{
				contentY = topDrawerHeight + this._currentTouchY - this._startTouchY;
			}
			else
			{
				contentY = this._currentTouchY - this._startTouchY;
			}
			if(contentY < 0)
			{
				contentY = 0;
			}
			if(contentY > topDrawerHeight)
			{
				contentY = topDrawerHeight;
			}
			this._content.y = contentY;
		}
		else if(this._isDraggingBottomDrawer)
		{
			var bottomDrawerHeight:Float = this._bottomDrawer.height;
			if(this.isBottomDrawerOpen)
			{
				contentY = -bottomDrawerHeight + this._currentTouchY - this._startTouchY;
			}
			else
			{
				contentY = this._currentTouchY - this._startTouchY;
			}
			if(contentY < -bottomDrawerHeight)
			{
				contentY = -bottomDrawerHeight;
			}
			if(contentY > 0)
			{
				contentY = 0;
			}
			if(this.isTopDrawerDocked)
			{
				contentY += this._topDrawer.height;
			}
		}
		this._content.x = contentX;
		this._content.y = contentY;
		if(this._isDraggingTopDrawer)
		{
			this.topDrawerOpenOrCloseTween_onUpdate();
		}
		else if(this._isDraggingRightDrawer)
		{
			this.rightDrawerOpenOrCloseTween_onUpdate();
		}
		else if(this._isDraggingBottomDrawer)
		{
			this.bottomDrawerOpenOrCloseTween_onUpdate();
		}
		else if(this._isDraggingLeftDrawer)
		{
			this.leftDrawerOpenOrCloseTween_onUpdate();
		}
	}

	/**
	 * @private
	 */
	private function checkForDragToClose():Void
	{
		var horizontalInchesMoved:Float = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
		var verticalInchesMoved:Float = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
		if(this.isLeftDrawerOpen && horizontalInchesMoved <= -this._minimumDragDistance)
		{
			this._isDragging = true;
			this._isDraggingLeftDrawer = true;
			this.applyLeftClipRect();
		}
		else if(this.isRightDrawerOpen && horizontalInchesMoved >= this._minimumDragDistance)
		{
			this._isDragging = true;
			this._isDraggingRightDrawer = true;
			this.applyRightClipRect();
		}
		else if(this.isTopDrawerOpen && verticalInchesMoved <= -this._minimumDragDistance)
		{
			this._isDragging = true;
			this._isDraggingTopDrawer = true;
			this.applyTopClipRect();
		}
		else if(this.isBottomDrawerOpen && verticalInchesMoved >= this._minimumDragDistance)
		{
			this._isDragging = true;
			this._isDraggingBottomDrawer = true;
			this.applyBottomClipRect();
		}

		if(this._isDragging)
		{
			if(this._overlaySkin != null)
			{
				this._overlaySkin.visible = true;
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
			}
			this._startTouchY = this._currentTouchY;
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
			exclusiveTouch.claimTouch(this.touchPointID, this);
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
		}
	}

	/**
	 * @private
	 */
	private function checkForDragToOpen():Void
	{
		var horizontalInchesMoved:Float = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
		var verticalInchesMoved:Float = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.current.contentScaleFactor);
		if(this._leftDrawer != null && !this.isLeftDrawerDocked && horizontalInchesMoved >= this._minimumDragDistance)
		{
			this._isDragging = true;
			this._isDraggingLeftDrawer = true;
			this._leftDrawer.visible = true;
			this.applyLeftClipRect();
		}
		else if(this._rightDrawer != null && !this.isRightDrawerDocked && horizontalInchesMoved <= -this._minimumDragDistance)
		{
			this._isDragging = true;
			this._isDraggingRightDrawer = true;
			this._rightDrawer.visible = true;
			this.applyRightClipRect();
		}
		else if(this._topDrawer != null && !this.isTopDrawerDocked && verticalInchesMoved >= this._minimumDragDistance)
		{
			this._isDragging = true;
			this._isDraggingTopDrawer = true;
			this._topDrawer.visible = true;
			this.applyTopClipRect();
		}
		else if(this._bottomDrawer != null && !this.isBottomDrawerDocked && verticalInchesMoved <= -this._minimumDragDistance)
		{
			this._isDragging = true;
			this._isDraggingBottomDrawer = true;
			this._bottomDrawer.visible = true;
			this.applyBottomClipRect();
		}

		if(this._isDragging)
		{
			if(this._overlaySkin != null)
			{
				this._overlaySkin.visible = true;
				this._overlaySkin.alpha = 0;
			}
			this._startTouchY = this._currentTouchY;
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			exclusiveTouch.claimTouch(this.touchPointID, this);
			exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
		}
	}

	/**
	 * @private
	 */
	private function positionOverlaySkin():Void
	{
		if(this._overlaySkin != null)
		{
			if(this.isLeftDrawerDocked)
			{
				this._overlaySkin.x = this._leftDrawer.x;
			}
			else
			{
				this._overlaySkin.x = this._content.x;
			}
			if(this.isTopDrawerDocked)
			{
				this._overlaySkin.y = this._topDrawer.y;
			}
			else
			{
				this._overlaySkin.y = this._content.y;
			}
		}
	}

	/**
	 * @private
	 */
	private function topDrawerOpenOrCloseTween_onUpdate():Void
	{
		if(this._overlaySkin != null)
		{
			this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * (this._content.y / this._topDrawer.height);
		}
		this.openOrCloseTween_onUpdate();
	}

	/**
	 * @private
	 */
	private function rightDrawerOpenOrCloseTween_onUpdate():Void
	{
		if(this._overlaySkin != null)
		{
			this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * (this.actualWidth - this._content.x - this._content.width) / this._rightDrawer.width;
		}
		this.openOrCloseTween_onUpdate();
	}

	/**
	 * @private
	 */
	private function bottomDrawerOpenOrCloseTween_onUpdate():Void
	{
		if(this._overlaySkin != null)
		{
			this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * (this.actualHeight - this._content.y - this._content.height) / this._bottomDrawer.height;
		}
		this.openOrCloseTween_onUpdate();
	}

	/**
	 * @private
	 */
	private function leftDrawerOpenOrCloseTween_onUpdate():Void
	{
		if(this._overlaySkin != null)
		{
			this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * (this._content.x / this._leftDrawer.width);
		}
		this.openOrCloseTween_onUpdate();
	}

	/**
	 * @private
	 */
	private function openOrCloseTween_onUpdate():Void
	{
		if(this._clipDrawers)
		{
			var isTopDrawerDocked:Bool = this.isTopDrawerDocked;
			var isRightDrawerDocked:Bool = this.isRightDrawerDocked;
			var isBottomDrawerDocked:Bool = this.isBottomDrawerDocked;
			var isLeftDrawerDocked:Bool = this.isLeftDrawerDocked;
			var sprite:Sprite;
			var clipRect:Rectangle;
			if(Std.is(this._topDrawer, Sprite))
			{
				sprite = cast this._topDrawer;
				clipRect = sprite.clipRect;
				if(clipRect != null)
				{
					clipRect.height = this._content.y;
				}
			}
			if(Std.is(this._rightDrawer, Sprite))
			{
				sprite = cast this._rightDrawer;
				clipRect = sprite.clipRect;
				if(clipRect != null)
				{
					var rightClipWidth:Float = -this._content.x;
					if(isLeftDrawerDocked)
					{
						rightClipWidth += this.leftDrawer.width;
					}
					clipRect.x = this._rightDrawer.width - rightClipWidth;
					clipRect.width = rightClipWidth;
				}
			}
			if(Std.is(this._bottomDrawer, Sprite))
			{
				sprite = cast this._bottomDrawer;
				clipRect = sprite.clipRect;
				if(clipRect != null)
				{
					var bottomClipHeight:Float = -this._content.y;
					if(isTopDrawerDocked)
					{
						bottomClipHeight += this.topDrawer.height;
					}
					clipRect.y = this._bottomDrawer.height - bottomClipHeight;
					clipRect.height = bottomClipHeight;
				}
			}
			if(Std.is(this._leftDrawer, Sprite))
			{
				sprite = cast this._leftDrawer;
				clipRect = sprite.clipRect;
				if(clipRect != null)
				{
					clipRect.width = this._content.x;
				}
			}
			var contentX:Float = this._content.x;
			var contentY:Float = this._content.y;
			if(isTopDrawerDocked)
			{
				if(isLeftDrawerDocked)
				{
					this._topDrawer.x = contentX - this._leftDrawer.width;
				}
				else
				{
					this._topDrawer.x = contentX;
				}
				this._topDrawer.y = contentY - this._topDrawer.height;
			}
			if(isRightDrawerDocked)
			{
				this._rightDrawer.x = contentX + this._content.width;
				this._rightDrawer.y = contentY;
			}
			if(isBottomDrawerDocked)
			{
				if(isLeftDrawerDocked)
				{
					this._bottomDrawer.x = contentX - this._leftDrawer.width;
				}
				else
				{
					this._bottomDrawer.x = contentX;
				}
				this._bottomDrawer.y = contentY + this._content.height;
			}
			if(isLeftDrawerDocked)
			{
				this._leftDrawer.x = contentX - this._leftDrawer.width;
				this._leftDrawer.y = contentY;
			}
		}

		if(this._overlaySkin != null)
		{
			this.positionOverlaySkin();
		}
	}

	/**
	 * @private
	 */
	private function topDrawerOpenOrCloseTween_onComplete():Void
	{
		if(this._overlaySkin != null)
		{
			this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
		}
		this._openOrCloseTween = null;
		if(Std.is(this._topDrawer, Sprite))
		{
			cast(this._topDrawer, Sprite).clipRect = null;
		}
		var isTopDrawerOpen:Bool = this.isTopDrawerOpen;
		var isTopDrawerDocked:Bool = this.isTopDrawerDocked;
		this._topDrawer.visible = isTopDrawerOpen || isTopDrawerDocked;
		if(this._overlaySkin != null)
		{
			this._overlaySkin.visible = isTopDrawerOpen;
		}
		if(isTopDrawerOpen)
		{
			this.dispatchEventWith(Event.OPEN, false, this._topDrawer);
		}
		else
		{
			this.dispatchEventWith(Event.CLOSE, false, this._topDrawer);
		}
	}

	/**
	 * @private
	 */
	private function rightDrawerOpenOrCloseTween_onComplete():Void
	{
		this._openOrCloseTween = null;
		if(Std.is(this._rightDrawer, Sprite))
		{
			cast(this._rightDrawer, Sprite).clipRect = null;
		}
		var isRightDrawerOpen:Bool = this.isRightDrawerOpen;
		var isRightDrawerDocked:Bool = this.isRightDrawerDocked;
		this._rightDrawer.visible = isRightDrawerOpen || isRightDrawerDocked;
		if(this._overlaySkin != null)
		{
			this._overlaySkin.visible = isRightDrawerOpen;
		}
		if(isRightDrawerOpen)
		{
			this.dispatchEventWith(Event.OPEN, false, this._rightDrawer);
		}
		else
		{
			this.dispatchEventWith(Event.CLOSE, false, this._rightDrawer);
		}
	}

	/**
	 * @private
	 */
	private function bottomDrawerOpenOrCloseTween_onComplete():Void
	{
		this._openOrCloseTween = null;
		if(Std.is(this._bottomDrawer, Sprite))
		{
			cast(this._bottomDrawer, Sprite).clipRect = null;
		}
		var isBottomDrawerOpen:Bool = this.isBottomDrawerOpen;
		var isBottomDrawerDocked:Bool = this.isBottomDrawerDocked;
		this._bottomDrawer.visible = isBottomDrawerOpen || isBottomDrawerDocked;
		if(this._overlaySkin != null)
		{
			this._overlaySkin.visible = isBottomDrawerOpen;
		}
		if(isBottomDrawerOpen)
		{
			this.dispatchEventWith(Event.OPEN, false, this._bottomDrawer);
		}
		else
		{
			this.dispatchEventWith(Event.CLOSE, false, this._bottomDrawer);
		}
	}

	/**
	 * @private
	 */
	private function leftDrawerOpenOrCloseTween_onComplete():Void
	{
		this._openOrCloseTween = null;
		if(Std.is(this._leftDrawer, Sprite))
		{
			cast(this._leftDrawer, Sprite).clipRect = null;
		}
		var isLeftDrawerOpen:Bool = this.isLeftDrawerOpen;
		var isLeftDrawerDocked:Bool = this.isLeftDrawerDocked;
		this._leftDrawer.visible = isLeftDrawerOpen || isLeftDrawerDocked;
		if(this._overlaySkin != null)
		{
			this._overlaySkin.visible = isLeftDrawerOpen;
		}
		if(isLeftDrawerOpen)
		{
			this.dispatchEventWith(Event.OPEN, false, this._leftDrawer);
		}
		else
		{
			this.dispatchEventWith(Event.CLOSE, false, this._leftDrawer);
		}
	}

	/**
	 * @private
	 */
	private function content_eventDispatcherChangeHandler(event:Event):Void
	{
		this.refreshCurrentEventTarget();
	}

	/**
	 * @private
	 */
	private function drawers_addedToStageHandler(event:Event):Void
	{
		this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		//using priority here is a hack so that objects higher up in the
		//display list have a chance to cancel the event first.
		var priority:Int = -getDisplayObjectDepthFromStage(this);
		Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, drawers_nativeStage_keyDownHandler, false, priority, true);
	}

	/**
	 * @private
	 */
	private function drawers_removedFromStageHandler(event:Event):Void
	{
		if(this.touchPointID >= 0)
		{
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
		}
		this.touchPointID = -1;
		this._isDragging = false;
		this._isDraggingTopDrawer = false;
		this._isDraggingRightDrawer = false;
		this._isDraggingBottomDrawer = false;
		this._isDraggingLeftDrawer = false;
		this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, drawers_nativeStage_keyDownHandler);
	}

	/**
	 * @private
	 */
	private function drawers_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled || this._openOrCloseTween != null)
		{
			this.touchPointID = -1;
			return;
		}
		var touch:Touch;
		if(this.touchPointID >= 0)
		{
			touch = event.getTouch(this, null, this.touchPointID);
			if(touch == null)
			{
				return;
			}
			if(touch.phase == TouchPhase.MOVED)
			{
				this.handleTouchMoved(touch);

				if(!this._isDragging)
				{
					if(this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen)
					{
						this.checkForDragToClose();
					}
					else
					{
						this.checkForDragToOpen();
					}
				}
				if(this._isDragging)
				{
					this.handleDragMove();
				}
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.touchPointID = -1;
				if(this._isDragging)
				{
					this.handleDragEnd();
					this.dispatchEventWith(FeathersEventType.END_INTERACTION);
				}
				else
				{
					ExclusiveTouch.forStage(this.stage).removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
					if(this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen)
					{
						//there is no drag, so we may have a tap
						this.handleTapToClose(touch);
					}
				}

			}
		}
		else
		{
			touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}

			this.handleTouchBegan(touch);
		}
	}

	/**
	 * @private
	 */
	private function exclusiveTouch_changeHandler(event:Event, touchID:Int):Void
	{
		if(this.touchPointID < 0 || this.touchPointID != touchID || this._isDragging)
		{
			return;
		}

		var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
		if(exclusiveTouch.getClaim(touchID) == this)
		{
			return;
		}

		this.touchPointID = -1;

	}

	/**
	 * @private
	 */
	private function stage_resizeHandler(event:ResizeEvent):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function drawers_nativeStage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.isDefaultPrevented())
		{
			//someone else already handled this one
			return;
		}
		#if flash
		if(event.keyCode == Keyboard.BACK)
		{
			var isAnyDrawerOpen:Bool = false;
			if(this.isTopDrawerOpen)
			{
				this.toggleTopDrawer();
				isAnyDrawerOpen = true;
			}
			else if(this.isRightDrawerOpen)
			{
				this.toggleRightDrawer();
				isAnyDrawerOpen = true;
			}
			else if(this.isBottomDrawerOpen)
			{
				this.toggleBottomDrawer();
				isAnyDrawerOpen = true;
			}
			else if(this.isLeftDrawerOpen)
			{
				this.toggleLeftDrawer();
				isAnyDrawerOpen = true;
			}
			if(isAnyDrawerOpen)
			{
				event.preventDefault();
			}
		}
		#end
	}

	/**
	 * @private
	 */
	private function content_topDrawerToggleEventTypeHandler(event:Event):Void
	{
		if(this._topDrawer == null || this.isTopDrawerDocked)
		{
			return;
		}
		this._isTopDrawerOpen = !this._isTopDrawerOpen;
		this.openOrCloseTopDrawer();
	}

	/**
	 * @private
	 */
	private function content_rightDrawerToggleEventTypeHandler(event:Event):Void
	{
		if(this._rightDrawer == null || this.isRightDrawerDocked)
		{
			return;
		}
		this._isRightDrawerOpen = !this._isRightDrawerOpen;
		this.openOrCloseRightDrawer();
	}

	/**
	 * @private
	 */
	private function content_bottomDrawerToggleEventTypeHandler(event:Event):Void
	{
		if(this._bottomDrawer == null || this.isBottomDrawerDocked)
		{
			return;
		}
		this._isBottomDrawerOpen = !this._isBottomDrawerOpen;
		this.openOrCloseBottomDrawer();
	}

	/**
	 * @private
	 */
	private function content_leftDrawerToggleEventTypeHandler(event:Event):Void
	{
		if(this._leftDrawer == null || this.isLeftDrawerDocked)
		{
			return;
		}
		this._isLeftDrawerOpen = !this._isLeftDrawerOpen;
		this.openOrCloseLeftDrawer();
	}

	/**
	 * @private
	 */
	private function content_resizeHandler(event:Event):Void
	{
		if(this._isValidating || this._autoSizeMode != AUTO_SIZE_MODE_CONTENT)
		{
			return;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function drawer_resizeHandler(event:Event):Void
	{
		if(this._isValidating)
		{
			return;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}
}
