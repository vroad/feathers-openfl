/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.IFocusDisplayObject;
import feathers.core.ITextRenderer;
import feathers.core.IValidating;
import feathers.core.PropertyProxy;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.skins.StateWithToggleValueSelector;
import openfl.errors.ArgumentError;
import openfl.Lib.getTimer;
import starling.utils.Max;

import openfl.geom.Point;
import openfl.ui.Keyboard;
//import openfl.utils.getTimer;

import starling.core.RenderSupport;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the the user taps or clicks the button. The touch must
 * remain within the bounds of the button on release to register as a tap
 * or a click. If focus management is enabled, the button may also be
 * triggered by pressing the spacebar while the button has focus.
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
 * @eventType starling.events.Event.TRIGGERED
 */
//[Event(name="triggered",type="starling.events.Event")]

/**
 * Dispatched when the button is pressed for a long time. The property
 * <code>isLongPressEnabled</code> must be set to <code>true</code> before
 * this event will be dispatched.
 *
 * <p>The following example enables long presses:</p>
 *
 * <listing version="3.0">
 * button.isLongPressEnabled = true;
 * button.addEventListener( FeathersEventType.LONG_PRESS, function( event:Event ):Void
 * {
 *     // long press
 * });</listing>
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
 * @eventType feathers.events.FeathersEventType.LONG_PRESS
 * @see #isLongPressEnabled
 * @see #longPressDuration
 */
//[Event(name="longPress",type="starling.events.Event")]

/**
 * A push button control that may be triggered when pressed and released.
 *
 * <p>The following example creates a button, gives it a label and listens
 * for when the button is triggered:</p>
 *
 * <listing version="3.0">
 * var button:Button = new Button();
 * button.label = "Click Me";
 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
 * this.addChild( button );</listing>
 *
 * @see ../../../help/button.html How to use the Feathers Button component
 */
class Button extends FeathersControl implements IFocusDisplayObject
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * The default value added to the <code>styleNameList</code> of the label.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-button-label";

	/**
	 * DEPRECATED: Replaced by <code>Button.DEFAULT_CHILD_STYLE_NAME_LABEL</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Button#DEFAULT_CHILD_STYLE_NAME_LABEL
	 */
	inline public static var DEFAULT_CHILD_NAME_LABEL:String = DEFAULT_CHILD_STYLE_NAME_LABEL;

	/**
	 * An alternate style name to use with <code>Button</code> to allow a
	 * theme to give it a more prominent, "call-to-action" style. If a theme
	 * does not provide a style for a call-to-action button, the theme will
	 * automatically fall back to using the default button style.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the call-to-action style is applied to
	 * a button:</p>
	 *
	 * <listing version="3.0">
	 * var button:Button = new Button();
	 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON );
	 * this.addChild( button );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON:String = "feathers-call-to-action-button";

	/**
	 * DEPRECATED: Replaced by <code>Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Button#ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON
	 */
	inline public static var ALTERNATE_NAME_CALL_TO_ACTION_BUTTON:String = ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON;

	/**
	 * An alternate style name to use with <code>Button</code> to allow a
	 * theme to give it a less prominent, "quiet" style. If a theme does not
	 * provide a style for a quiet button, the theme will automatically fall
	 * back to using the default button style.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the quiet button style is applied to
	 * a button:</p>
	 *
	 * <listing version="3.0">
	 * var button:Button = new Button();
	 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON );
	 * this.addChild( button );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_STYLE_NAME_QUIET_BUTTON:String = "feathers-quiet-button";

	/**
	 * DEPRECATED: Replaced by <code>Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Button#ALTERNATE_STYLE_NAME_QUIET_BUTTON
	 */
	inline public static var ALTERNATE_NAME_QUIET_BUTTON:String = ALTERNATE_STYLE_NAME_QUIET_BUTTON;

	/**
	 * An alternate style name to use with <code>Button</code> to allow a
	 * theme to give it a highly prominent, "danger" style. An example would
	 * be a delete button or some other button that has a destructive action
	 * that cannot be undone if the button is triggered. If a theme does not
	 * provide a style for the danger button, the theme will automatically
	 * fall back to using the default button style.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the danger button style is applied to
	 * a button:</p>
	 *
	 * <listing version="3.0">
	 * var button:Button = new Button();
	 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON );
	 * this.addChild( button );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_STYLE_NAME_DANGER_BUTTON:String = "feathers-danger-button";

	/**
	 * DEPRECATED: Replaced by <code>Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Button#ALTERNATE_STYLE_NAME_DANGER_BUTTON
	 */
	inline public static var ALTERNATE_NAME_DANGER_BUTTON:String = ALTERNATE_STYLE_NAME_DANGER_BUTTON;

	/**
	 * An alternate style name to use with <code>Button</code> to allow a
	 * theme to give it a "back button" style, perhaps with an arrow
	 * pointing backward. If a theme does not provide a style for a back
	 * button, the theme will automatically fall back to using the default
	 * button skin.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the back button style is applied to
	 * a button:</p>
	 *
	 * <listing version="3.0">
	 * var button:Button = new Button();
	 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_BACK_BUTTON );
	 * this.addChild( button );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_STYLE_NAME_BACK_BUTTON:String = "feathers-back-button";

	/**
	 * DEPRECATED: Replaced by <code>Button.ALTERNATE_STYLE_NAME_BACK_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Button#ALTERNATE_STYLE_NAME_BACK_BUTTON
	 */
	inline public static var ALTERNATE_NAME_BACK_BUTTON:String = ALTERNATE_STYLE_NAME_BACK_BUTTON;

	/**
	 * An alternate style name to use with <code>Button</code> to allow a
	 * theme to give it a "forward" button style, perhaps with an arrow
	 * pointing forward. If a theme does not provide a style for a forward
	 * button, the theme will automatically fall back to using the default
	 * button style.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the forward button style is applied to
	 * a button:</p>
	 *
	 * <listing version="3.0">
	 * var button:Button = new Button();
	 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
	 * this.addChild( button );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_STYLE_NAME_FORWARD_BUTTON:String = "feathers-forward-button";

	/**
	 * DEPRECATED: Replaced by <code>Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Button#ALTERNATE_STYLE_NAME_FORWARD_BUTTON
	 */
	inline public static var ALTERNATE_NAME_FORWARD_BUTTON:String = ALTERNATE_STYLE_NAME_FORWARD_BUTTON;
	
	/**
	 * Identifier for the button's up state. Can be used for styling purposes.
	 *
	 * @see #stateToSkinFunction
	 * @see #stateToIconFunction
	 * @see #stateToLabelPropertiesFunction
	 */
	inline public static var STATE_UP:String = "up";
	
	/**
	 * Identifier for the button's down state. Can be used for styling purposes.
	 *
	 * @see #stateToSkinFunction
	 * @see #stateToIconFunction
	 * @see #stateToLabelPropertiesFunction
	 */
	inline public static var STATE_DOWN:String = "down";

	/**
	 * Identifier for the button's hover state. Can be used for styling purposes.
	 *
	 * @see #stateToSkinFunction
	 * @see #stateToIconFunction
	 * @see #stateToLabelPropertiesFunction
	 */
	inline public static var STATE_HOVER:String = "hover";
	
	/**
	 * Identifier for the button's disabled state. Can be used for styling purposes.
	 *
	 * @see #stateToSkinFunction
	 * @see #stateToIconFunction
	 * @see #stateToLabelPropertiesFunction
	 */
	inline public static var STATE_DISABLED:String = "disabled";
	
	/**
	 * The icon will be positioned above the label.
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_TOP:String = "top";
	
	/**
	 * The icon will be positioned to the right of the label.
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_RIGHT:String = "right";
	
	/**
	 * The icon will be positioned below the label.
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_BOTTOM:String = "bottom";
	
	/**
	 * The icon will be positioned to the left of the label.
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_LEFT:String = "left";

	/**
	 * The icon will be positioned manually with no relation to the position
	 * of the label. Use <code>iconOffsetX</code> and <code>iconOffsetY</code>
	 * to set the icon's position.
	 *
	 * @see #iconPosition
	 * @see #iconOffsetX
	 * @see #iconOffsetY
	 */
	inline public static var ICON_POSITION_MANUAL:String = "manual";
	
	/**
	 * The icon will be positioned to the left the label, and the bottom of
	 * the icon will be aligned to the baseline of the label text.
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";
	
	/**
	 * The icon will be positioned to the right the label, and the bottom of
	 * the icon will be aligned to the baseline of the label text.
	 *
	 * @see #iconPosition
	 */
	inline public static var ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";
	
	/**
	 * The icon and label will be aligned horizontally to the left edge of the button.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";
	
	/**
	 * The icon and label will be aligned horizontally to the center of the button.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";
	
	/**
	 * The icon and label will be aligned horizontally to the right edge of the button.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";
	
	/**
	 * The icon and label will be aligned vertically to the top edge of the button.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";
	
	/**
	 * The icon and label will be aligned vertically to the middle of the button.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";
	
	/**
	 * The icon and label will be aligned vertically to the bottom edge of the button.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * The default <code>IStyleProvider</code> for all <code>Button</code>
	 * components.
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
		this.isQuickHitAreaEnabled = true;
		this.addEventListener(TouchEvent.TOUCH, button_touchHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, button_removedFromStageHandler);
	}

	/**
	 * The value added to the <code>styleNameList</code> of the label text
	 * renderer. This variable is <code>protected</code> so that sub-classes
	 * can customize the label text renderer style name in their
	 * constructors instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_LABEL</code>.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var labelStyleName:String = DEFAULT_CHILD_STYLE_NAME_LABEL;

	/**
	 * DEPRECATED: Replaced by <code>labelStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #labelStyleName
	 */
	private function get_labelName():String
	{
		return this.labelStyleName;
	}

	/**
	 * @private
	 */
	private function set_labelName(value:String):String
	{
		this.labelStyleName = value;
	}
	
	/**
	 * The text renderer for the button's label.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #label
	 * @see #labelFactory
	 * @see #createLabel()
	 */
	private var labelTextRenderer:ITextRenderer;
	
	/**
	 * The currently visible skin. The value will be <code>null</code> if
	 * there is no currently visible skin.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var currentSkin:DisplayObject;
	
	/**
	 * The currently visible icon. The value will be <code>null</code> if
	 * there is no currently visible icon.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var currentIcon:DisplayObject;
	
	/**
	 * The saved ID of the currently active touch. The value will be
	 * <code>-1</code> if there is no currently active touch.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var touchPointID:Int = -1;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Button.globalStyleProvider;
	}
	
	/**
	 * @private
	 */
	override public function set_isEnabled(value:Bool):Bool
	{
		if(this._isEnabled == value)
		{
			return get_isEnabled();
		}
		super.isEnabled = value;
		if(!this._isEnabled)
		{
			this.touchable = false;
			this.currentState = STATE_DISABLED;
			this.touchPointID = -1;
		}
		else
		{
			//might be in another state for some reason
			//let's only change to up if needed
			if(this.currentState == STATE_DISABLED)
			{
				this.currentState = STATE_UP;
			}
			this.touchable = true;
		}
		return get_isEnabled();
	}
	
	/**
	 * @private
	 */
	private var _currentState:String = STATE_UP;
	
	/**
	 * The current touch state of the button.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var currentState(get, set):String;
	private function get_currentState():String
	{
		return this._currentState;
	}
	
	/**
	 * @private
	 */
	private function set_currentState(value:String):String
	{
		if(this._currentState == value)
		{
			return get_currentState();
		}
		if(this.stateNames.indexOf(value) < 0)
		{
			throw new ArgumentError("Invalid state: " + value + ".");
		}
		this._currentState = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STATE);
		return get_currentState();
	}
	
	/**
	 * @private
	 */
	private var _label:String = null;
	
	/**
	 * The text displayed on the button.
	 *
	 * <p>The following example gives the button some label text:</p>
	 *
	 * <listing version="3.0">
	 * button.label = "Click Me";</listing>
	 *
	 * @default null
	 */
	public var label(get, set):String;
	public function get_label():String
	{
		return this._label;
	}
	
	/**
	 * @private
	 */
	public function set_label(value:String):String
	{
		if(this._label == value)
		{
			return get_label();
		}
		this._label = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_label();
	}

	/**
	 * @private
	 */
	private var _hasLabelTextRenderer:Bool = true;

	/**
	 * Determines if the button's label text renderer is created or not.
	 * Useful for button sub-components that may not display text, like
	 * slider thumbs and tracks, or similar sub-components on scroll bars.
	 *
	 * <p>The following example removed the label text renderer:</p>
	 *
	 * <listing version="3.0">
	 * button.hasLabelTextRenderer = false;</listing>
	 *
	 * @default true
	 */
	public var hasLabelTextRenderer(get, set):Bool;
	public function get_hasLabelTextRenderer():Bool
	{
		return this._hasLabelTextRenderer;
	}

	/**
	 * @private
	 */
	public function set_hasLabelTextRenderer(value:Bool):Bool
	{
		if(this._hasLabelTextRenderer == value)
		{
			return get_hasLabelTextRenderer();
		}
		this._hasLabelTextRenderer = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_TEXT_RENDERER);
		return get_hasLabelTextRenderer();
	}
	
	/**
	 * @private
	 */
	private var _iconPosition:String = ICON_POSITION_LEFT;

	//[Inspectable(type="String",enumeration="top,right,bottom,left,rightBaseline,leftBaseline,manual")]
	/**
	 * The location of the icon, relative to the label.
	 *
	 * <p>The following example positions the icon to the right of the
	 * label:</p>
	 *
	 * <listing version="3.0">
	 * button.label = "Click Me";
	 * button.defaultIcon = new Image( texture );
	 * button.iconPosition = Button.ICON_POSITION_RIGHT;</listing>
	 *
	 * @default Button.ICON_POSITION_LEFT
	 *
	 * @see #ICON_POSITION_TOP
	 * @see #ICON_POSITION_RIGHT
	 * @see #ICON_POSITION_BOTTOM
	 * @see #ICON_POSITION_LEFT
	 * @see #ICON_POSITION_RIGHT_BASELINE
	 * @see #ICON_POSITION_LEFT_BASELINE
	 * @see #ICON_POSITION_MANUAL
	 */
	public var iconPosition(get, set):String;
	public function get_iconPosition():String
	{
		return this._iconPosition;
	}
	
	/**
	 * @private
	 */
	public function set_iconPosition(value:String):String
	{
		if(this._iconPosition == value)
		{
			return get_iconPosition();
		}
		this._iconPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_iconPosition();
	}
	
	/**
	 * @private
	 */
	private var _gap:Float = 0;
	
	/**
	 * The space, in pixels, between the icon and the label. Applies to
	 * either horizontal or vertical spacing, depending on the value of
	 * <code>iconPosition</code>.
	 * 
	 * <p>If <code>gap</code> is set to <code>Math.POSITIVE_INFINITY</code>,
	 * the label and icon will be positioned as far apart as possible. In
	 * other words, they will be positioned at the edges of the button,
	 * adjusted for padding.</p>
	 *
	 * <p>The following example creates a gap of 50 pixels between the label
	 * and the icon:</p>
	 *
	 * <listing version="3.0">
	 * button.label = "Click Me";
	 * button.defaultIcon = new Image( texture );
	 * button.gap = 50;</listing>
	 *
	 * @default 0
	 * 
	 * @see #iconPosition
	 * @see #minGap
	 */
	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return this._gap;
	}
	
	/**
	 * @private
	 */
	public function set_gap(value:Float):Float
	{
		if(this._gap == value)
		{
			return get_gap();
		}
		this._gap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_gap();
	}

	/**
	 * @private
	 */
	private var _minGap:Float = 0;

	/**
	 * If the value of the <code>gap</code> property is
	 * <code>Math.POSITIVE_INFINITY</code>, meaning that the gap will
	 * fill as much space as possible, the final calculated value will not be
	 * smaller than the value of the <code>minGap</code> property.
	 *
	 * <p>The following example ensures that the gap is never smaller than
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.gap = Math.POSITIVE_INFINITY;
	 * button.minGap = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #gap
	 */
	public var minGap(get, set):Float;
	public function get_minGap():Float
	{
		return this._minGap;
	}

	/**
	 * @private
	 */
	public function set_minGap(value:Float):Float
	{
		if(this._minGap == value)
		{
			return get_minGap();
		}
		this._minGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_minGap();
	}
	
	/**
	 * @private
	 */
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

	//[Inspectable(type="String",enumeration="left,center,right")]
	/**
	 * The location where the button's content is aligned horizontally (on
	 * the x-axis).
	 *
	 * <p>The following example aligns the button's content to the left:</p>
	 *
	 * <listing version="3.0">
	 * button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;</listing>
	 *
	 * @default Button.HORIZONTAL_ALIGN_CENTER
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 */
	public var horizontalAlign(get, set):String;
	public function get_horizontalAlign():String
	{
		return this._horizontalAlign;
	}
	
	/**
	 * @private
	 */
	public function set_horizontalAlign(value:String):String
	{
		if(this._horizontalAlign == value)
		{
			return get_horizontalAlign();
		}
		this._horizontalAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_horizontalAlign();
	}
	
	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;

	//[Inspectable(type="String",enumeration="top,middle,bottom")]
	/**
	 * The location where the button's content is aligned vertically (on
	 * the y-axis).
	 *
	 * <p>The following example aligns the button's content to the top:</p>
	 *
	 * <listing version="3.0">
	 * button.verticalAlign = Button.VERTICAL_ALIGN_TOP;</listing>
	 *
	 * @default Button.VERTICAL_ALIGN_MIDDLE
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 */
	public var verticalAlign(get, set):String;
	public function get_verticalAlign():String
	{
		return _verticalAlign;
	}
	
	/**
	 * @private
	 */
	public function set_verticalAlign(value:String):String
	{
		if(this._verticalAlign == value)
		{
			return get_verticalAlign();
		}
		this._verticalAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_verticalAlign();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>The following example gives the button 20 pixels of padding on all
	 * sides:</p>
	 *
	 * <listing version="3.0">
	 * button.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the button's top edge and the
	 * button's content.
	 *
	 * <p>The following example gives the button 20 pixels of padding on the
	 * top edge only:</p>
	 *
	 * <listing version="3.0">
	 * button.paddingTop = 20;</listing>
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
	 * The minimum space, in pixels, between the button's right edge and the
	 * button's content.
	 *
	 * <p>The following example gives the button 20 pixels of padding on the
	 * right edge only:</p>
	 *
	 * <listing version="3.0">
	 * button.paddingRight = 20;</listing>
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
	 * The minimum space, in pixels, between the button's bottom edge and
	 * the button's content.
	 *
	 * <p>The following example gives the button 20 pixels of padding on the
	 * bottom edge only:</p>
	 *
	 * <listing version="3.0">
	 * button.paddingBottom = 20;</listing>
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
	 * The minimum space, in pixels, between the button's left edge and the
	 * button's content.
	 *
	 * <p>The following example gives the button 20 pixels of padding on the
	 * left edge only:</p>
	 *
	 * <listing version="3.0">
	 * button.paddingLeft = 20;</listing>
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
	private var _labelOffsetX:Float = 0;

	/**
	 * Offsets the x position of the label by a certain number of pixels.
	 * This does not affect the measurement of the button. The button will
	 * measure itself as if the label were not offset from its original
	 * position.
	 *
	 * <p>The following example offsets the x position of the button's label
	 * by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.labelOffsetX = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #labelOffsetY
	 */
	public var labelOffsetX(get, set):Float;
	public function get_labelOffsetX():Float
	{
		return this._labelOffsetX;
	}

	/**
	 * @private
	 */
	public function set_labelOffsetX(value:Float):Float
	{
		if(this._labelOffsetX == value)
		{
			return get_labelOffsetX();
		}
		this._labelOffsetX = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_labelOffsetX();
	}

	/**
	 * @private
	 */
	private var _labelOffsetY:Float = 0;

	/**
	 * Offsets the y position of the label by a certain number of pixels.
	 * This does not affect the measurement of the button. The button will
	 * measure itself as if the label were not offset from its original
	 * position.
	 *
	 * <p>The following example offsets the y position of the button's label
	 * by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.labelOffsetY = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #labelOffsetX
	 */
	public var labelOffsetY(get, set):Float;
	public function get_labelOffsetY():Float
	{
		return this._labelOffsetY;
	}

	/**
	 * @private
	 */
	public function set_labelOffsetY(value:Float):Float
	{
		if(this._labelOffsetY == value)
		{
			return get_labelOffsetY();
		}
		this._labelOffsetY = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_labelOffsetY();
	}

	/**
	 * @private
	 */
	private var _iconOffsetX:Float = 0;

	/**
	 * Offsets the x position of the icon by a certain number of pixels.
	 * This does not affect the measurement of the button. The button will
	 * measure itself as if the icon were not offset from its original
	 * position.
	 *
	 * <p>The following example offsets the x position of the button's icon
	 * by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.iconOffsetX = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #iconOffsetY
	 */
	public var iconOffsetX(get, set):Float;
	public function get_iconOffsetX():Float
	{
		return this._iconOffsetX;
	}

	/**
	 * @private
	 */
	public function set_iconOffsetX(value:Float):Float
	{
		if(this._iconOffsetX == value)
		{
			return get_iconOffsetX();
		}
		this._iconOffsetX = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_iconOffsetX();
	}

	/**
	 * @private
	 */
	private var _iconOffsetY:Float = 0;

	/**
	 * Offsets the y position of the icon by a certain number of pixels.
	 * This does not affect the measurement of the button. The button will
	 * measure itself as if the icon were not offset from its original
	 * position.
	 *
	 * <p>The following example offsets the y position of the button's icon
	 * by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.iconOffsetY = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #iconOffsetX
	 */
	public var iconOffsetY(get, set):Float;
	public function get_iconOffsetY():Float
	{
		return this._iconOffsetY;
	}

	/**
	 * @private
	 */
	public function set_iconOffsetY(value:Float):Float
	{
		if(this._iconOffsetY == value)
		{
			return get_iconOffsetY();
		}
		this._iconOffsetY = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_iconOffsetY();
	}
	
	/**
	 * Determines if a pressed button should remain in the down state if a
	 * touch moves outside of the button's bounds. Useful for controls like
	 * <code>Slider</code> and <code>ToggleSwitch</code> to keep a thumb in
	 * the down state while it is dragged around.
	 *
	 * <p>The following example ensures that the button's down state remains
	 * active when the button is pressed but the touch moves outside the
	 * button's bounds:</p>
	 *
	 * <listing version="3.0">
	 * button.keepDownStateOnRollOut = true;</listing>
	 */
	public var keepDownStateOnRollOut:Bool = false;

	/**
	 * @private
	 */
	private var _stateNames:Array<String> =
	[
		STATE_UP, STATE_DOWN, STATE_HOVER, STATE_DISABLED
	];

	/**
	 * A list of all valid touch state names for use with <code>currentState</code>.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #currentState
	 */
	private var stateNames(get, never):Array<String>;
	private function get_stateNames():Array<String>
	{
		return this._stateNames;
	}

	/**
	 * @private
	 */
	private var _originalSkinWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _originalSkinHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _stateToSkinFunction:Dynamic->String->Dynamic->Dynamic;

	/**
	 * Returns a skin for the current state. Can be used instead of
	 * individual skin properties for different states, like
	 * <code>upSkin</code> or <code>hoverSkin</code>, to reuse the same
	 * display object for all states. The function should simply change the
	 * display object's properties. For example, a function could reuse the
	 * the same <code>starling.display.Image</code> instance among all
	 * button states, and change its texture for each state.
	 *
	 * <p>The following function signature is expected:</p>
	 * <pre>function(target:Button, state:Dynamic, oldSkin:DisplayObject = null):DisplayObject</pre>
	 *
	 * @default null
	 */
	public var stateToSkinFunction(get, set):Dynamic->String->Dynamic->Dynamic;
	public function get_stateToSkinFunction():Dynamic->String->Dynamic->Dynamic
	{
		return this._stateToSkinFunction;
	}

	/**
	 * @private
	 */
	public function set_stateToSkinFunction(value:Dynamic->String->Dynamic->Dynamic):Dynamic->String->Dynamic->Dynamic
	{
		if(this._stateToSkinFunction == value)
		{
			return get_stateToSkinFunction();
		}
		this._stateToSkinFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_stateToSkinFunction();
	}

	/**
	 * @private
	 */
	private var _stateToIconFunction:Dynamic->String->Dynamic->Dynamic;

	/**
	 * Returns an icon for the current state. Can be used instead of
	 * individual icon properties for different states, like
	 * <code>upIcon</code> or <code>hoverIcon</code>, to reuse the same
	 * display object for all states. the function should simply change the
	 * display object's properties. For example, a function could reuse the
	 * the same <code>starling.display.Image</code> instance among all
	 * button states, and change its texture for each state.
	 *
	 * <p>The following function signature is expected:</p>
	 * <pre>function(target:Button, state:Dynamic, oldIcon:DisplayObject = null):DisplayObject</pre>
	 *
	 * @default null
	 */
	public var stateToIconFunction(get, set):Dynamic->String->Dynamic->Dynamic;
	public function get_stateToIconFunction():Dynamic->String->Dynamic->Dynamic
	{
		return this._stateToIconFunction;
	}

	/**
	 * @private
	 */
	public function set_stateToIconFunction(value:Dynamic->String->Dynamic->Dynamic):Dynamic->String->Dynamic->Dynamic
	{
		if(this._stateToIconFunction == value)
		{
			return get_stateToIconFunction();
		}
		this._stateToIconFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_stateToIconFunction();
	}

	/**
	 * @private
	 */
	private var _stateToLabelPropertiesFunction:Button->String->PropertyProxy;

	/**
	 * Returns a text format for the current state.
	 *
	 * <p>The following function signature is expected:</p>
	 * <pre>function(target:Button, state:Dynamic):Dynamic</pre>
	 *
	 * @default null
	 */
	public var stateToLabelPropertiesFunction(get, set):Button->String->PropertyProxy;
	public function get_stateToLabelPropertiesFunction():Button->String->PropertyProxy
	{
		return this._stateToLabelPropertiesFunction;
	}

	/**
	 * @private
	 */
	public function set_stateToLabelPropertiesFunction(value:Button->String->PropertyProxy):Button->String->PropertyProxy
	{
		if(this._stateToLabelPropertiesFunction == value)
		{
			return get_stateToLabelPropertiesFunction();
		}
		this._stateToLabelPropertiesFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_stateToLabelPropertiesFunction();
	}

	/**
	 * @private
	 * Chooses an appropriate skin based on the state and the selection.
	 */
	private var _skinSelector:StateWithToggleValueSelector<DisplayObject> = new StateWithToggleValueSelector();
	
	/**
	 * The skin used when no other skin is defined for the current state.
	 * Intended to be used when multiple states should share the same skin.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a default skin to use for
	 * all states when no specific skin is available:</p>
	 *
	 * <listing version="3.0">
	 * button.defaultSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #stateToSkinFunction
	 * @see #upSkin
	 * @see #downSkin
	 * @see #hoverSkin
	 * @see #disabledSkin
	 */
	public var defaultSkin(get, set):DisplayObject;
	public function get_defaultSkin():DisplayObject
	{
		return this._skinSelector.defaultValue;
	}
	
	/**
	 * @private
	 */
	public function set_defaultSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.defaultValue == value)
		{
			return get_defaultSkin();
		}
		this._skinSelector.defaultValue = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_defaultSkin();
	}
	
	/**
	 * The skin used for the button's up state. If <code>null</code>, then
	 * <code>defaultSkin</code> is used instead.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a skin for the up state:</p>
	 *
	 * <listing version="3.0">
	 * button.upSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #defaultSkin
	 * @see #STATE_UP
	 */
	public var upSkin(get, set):DisplayObject;
	public function get_upSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(STATE_UP, false);
	}
	
	/**
	 * @private
	 */
	public function set_upSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(STATE_UP, false) == value)
		{
			return get_upSkin();
		}
		this._skinSelector.setValueForState(value, STATE_UP, false);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_upSkin();
	}
	
	/**
	 * The skin used for the button's down state. If <code>null</code>, then
	 * <code>defaultSkin</code> is used instead.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a skin for the down state:</p>
	 *
	 * <listing version="3.0">
	 * button.downSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #defaultSkin
	 * @see #STATE_DOWN
	 */
	public var downSkin(get, set):DisplayObject;
	public function get_downSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(STATE_DOWN, false);
	}
	
	/**
	 * @private
	 */
	public function set_downSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(STATE_DOWN, false) == value)
		{
			return get_downSkin();
		}
		this._skinSelector.setValueForState(value, STATE_DOWN, false);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_downSkin();
	}

	/**
	 * The skin used for the button's hover state. If <code>null</code>, then
	 * <code>defaultSkin</code> is used instead.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a skin for the hover state:</p>
	 *
	 * <listing version="3.0">
	 * button.hoverSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultSkin
	 * @see #STATE_HOVER
	 */
	public var hoverSkin(get, set):DisplayObject;
	public function get_hoverSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(STATE_HOVER, false);
	}

	/**
	 * @private
	 */
	public function set_hoverSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(STATE_HOVER, false) == value)
		{
			return get_hoverSkin();
		}
		this._skinSelector.setValueForState(value, STATE_HOVER, false);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_hoverSkin();
	}
	
	/**
	 * The skin used for the button's disabled state. If <code>null</code>,
	 * then <code>defaultSkin</code> is used instead.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a skin for the disabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.disabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #defaultSkin
	 * @see #STATE_DISABLED
	 */
	public var disabledSkin(get, set):DisplayObject;
	public function get_disabledSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(STATE_DISABLED, false);
	}
	
	/**
	 * @private
	 */
	public function set_disabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(STATE_DISABLED, false) == value)
		{
			return get_disabledSkin();
		}
		this._skinSelector.setValueForState(value, STATE_DISABLED, false);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_disabledSkin();
	}

	/**
	 * @private
	 */
	private var _labelFactory:Void->ITextRenderer;

	/**
	 * A function used to instantiate the button's label text renderer
	 * sub-component. By default, the button will use the global text
	 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
	 * to create the label text renderer. The label text renderer must be an
	 * instance of <code>ITextRenderer</code>. To change properties on the
	 * label text renderer, see <code>defaultLabelProperties</code> and the
	 * other "<code>LabelProperties</code>" properties for each button
	 * state.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * <p>The following example gives the button a custom factory for the
	 * label text renderer:</p>
	 *
	 * <listing version="3.0">
	 * button.labelFactory = function():ITextRenderer
	 * {
	 *     return new TextFieldTextRenderer();
	 * }</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 */
	public var labelFactory(get, set):Void->ITextRenderer;
	public function get_labelFactory():Void->ITextRenderer
	{
		return this._labelFactory;
	}

	/**
	 * @private
	 */
	public function set_labelFactory(value:Void->ITextRenderer):Void->ITextRenderer
	{
		if(this._labelFactory == value)
		{
			return get_labelFactory();
		}
		this._labelFactory = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_TEXT_RENDERER);
		return get_labelFactory();
	}
	
	/**
	 * @private
	 */
	private var _labelPropertiesSelector:StateWithToggleValueSelector<PropertyProxy> = new StateWithToggleValueSelector();
	
	/**
	 * An object that stores properties for the button's label text renderer
	 * when no specific properties are defined for the button's current
	 * state, and the properties will be passed down to the label text
	 * renderer when the button validates. The available properties depend
	 * on which <code>ITextRenderer</code> implementation is returned by
	 * <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button default label properties to
	 * use for all states when no specific label properties are available
	 * (this example assumes that the label text renderer is a
	 * <code>BitmapFontTextRenderer</code>):</p>
	 *
	 * <listing version="3.0">
	 * button.defaultLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
	 * button.defaultLabelProperties.wordWrap = true;</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #stateToLabelPropertiesFunction
	 */
	public var defaultLabelProperties(get, set):PropertyProxy;
	public function get_defaultLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.defaultValue;
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.defaultValue = value;
		}
		return value;
	}
	
	/**
	 * @private
	 */
	public function set_defaultLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!Std.is(value, PropertyProxy))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.defaultValue;
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.defaultValue = value;
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_defaultLabelProperties();
	}
	
	/**
	 * An object that stores properties for the button's label text renderer
	 * when the button is in the <code>Button.STATE_UP</code> state, and the
	 * properties will be passed down to the label text renderer when the
	 * button validates. The available properties depend on which
	 * <code>ITextRenderer</code> implementation is returned by
	 * <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button label properties for the
	 * up state:</p>
	 *
	 * <listing version="3.0">
	 * button.upLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 * @see #STATE_UP
	 */
	public function get_upLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.getValueForState(STATE_UP, false);
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.setValueForState(value, STATE_UP, false);
		}
		return value;
	}
	
	/**
	 * @private
	 */
	public function set_upLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!Std.is(value, PropertyProxy))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.getValueForState(STATE_UP, false);
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.setValueForState(value, STATE_UP, false);
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_upLabelProperties();
	}
	
	/**
	 * An object that stores properties for the button's label text renderer
	 * when the button is in the <code>Button.STATE_DOWN</code> state, and
	 * the properties will be passed down to the label text renderer when
	 * the button validates. The available properties depend on which
	 * <code>ITextRenderer</code> implementation is returned by
	 * <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button label properties for the
	 * down state:</p>
	 *
	 * <listing version="3.0">
	 * button.downLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 * @see #STATE_DOWN
	 */
	public var downLabelProperties(get, set):PropertyProxy;
	public function get_downLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.getValueForState(STATE_DOWN, false);
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.setValueForState(value, STATE_DOWN, false);
		}
		return value;
	}
	
	/**
	 * @private
	 */
	public function set_downLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!Std.is(value, PropertyProxy))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.getValueForState(STATE_DOWN, false);
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.setValueForState(value, STATE_DOWN, false);
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_downLabelProperties();
	}

	/**
	 * An object that stores properties for the button's label text renderer
	 * when the button is in the <code>Button.STATE_HOVER</code> state, and
	 * the properties will be passed down to the label text renderer when
	 * the button validates. The available properties depend on which
	 * <code>ITextRenderer</code> implementation is returned by
	 * <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button label properties for the
	 * hover state:</p>
	 *
	 * <listing version="3.0">
	 * button.hoverLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 * @see #STATE_HOVER
	 */
	public var hoverLabelProperties(get, set):PropertyProxy;
	public function get_hoverLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.getValueForState(STATE_HOVER, false);
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.setValueForState(value, STATE_HOVER, false);
		}
		return value;
	}

	/**
	 * @private
	 */
	public function set_hoverLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!Std.is(value, PropertyProxy))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.getValueForState(STATE_HOVER, false);
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.setValueForState(value, STATE_HOVER, false);
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_hoverLabelProperties();
	}
	
	/**
	 * An object that stores properties for the button's label text renderer
	 * when the button is in the <code>Button.STATE_DISABLED</code> state,
	 * and the properties will be passed down to the label text renderer
	 * when the button validates. The available properties depend on which
	 * <code>ITextRenderer</code> implementation is returned by
	 * <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button label properties for the
	 * disabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.disabledLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 * @see #STATE_DISABLED
	 */
	public var disabledLabelProperties(get, set):PropertyProxy;
	public function get_disabledLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.getValueForState(STATE_DISABLED, false);
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.setValueForState(value, STATE_DISABLED, false);
		}
		return value;
	}
	
	/**
	 * @private
	 */
	public function set_disabledLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!Std.is(value, PropertyProxy))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.getValueForState(STATE_DISABLED, false);
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.setValueForState(value, STATE_DISABLED, false);
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_disabledLabelProperties();
	}
	
	/**
	 * @private
	 */
	private var _iconSelector:StateWithToggleValueSelector<DisplayObject> = new StateWithToggleValueSelector();
	
	/**
	 * The icon used when no other icon is defined for the current state.
	 * Intended to be used when multiple states should share the same icon.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a default icon to use for
	 * all states when no specific icon is available:</p>
	 *
	 * <listing version="3.0">
	 * button.defaultIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #stateToIconFunction
	 * @see #upIcon
	 * @see #downIcon
	 * @see #hoverIcon
	 * @see #disabledIcon
	 */
	public var defaultIcon(get, set):DisplayObject;
	public function get_defaultIcon():DisplayObject
	{
		return this._iconSelector.defaultValue;
	}
	
	/**
	 * @private
	 */
	public function set_defaultIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.defaultValue == value)
		{
			return get_defaultIcon();
		}
		this._iconSelector.defaultValue = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_defaultIcon();
	}
	
	/**
	 * The icon used for the button's up state. If <code>null</code>, then
	 * <code>defaultIcon</code> is used instead.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button an icon for the up state:</p>
	 *
	 * <listing version="3.0">
	 * button.upIcon = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #defaultIcon
	 * @see #STATE_UP
	 */
	public var upIcon(get, set):DisplayObject;
	public function get_upIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(STATE_UP, false);
	}
	
	/**
	 * @private
	 */
	public function set_upIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(STATE_UP, false) == value)
		{
			return get_upIcon();
		}
		this._iconSelector.setValueForState(value, STATE_UP, false);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_upIcon();
	}
	
	/**
	 * The icon used for the button's down state. If <code>null</code>, then
	 * <code>defaultIcon</code> is used instead.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button an icon for the down state:</p>
	 *
	 * <listing version="3.0">
	 * button.downIcon = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #defaultIcon
	 * @see #STATE_DOWN
	 */
	public var downIcon(get, set):DisplayObject;
	public function get_downIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(STATE_DOWN, false);
	}
	
	/**
	 * @private
	 */
	public function set_downIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(STATE_DOWN, false) == value)
		{
			return get_downIcon();
		}
		this._iconSelector.setValueForState(value, STATE_DOWN, false);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_downIcon();
	}

	/**
	 * The icon used for the button's hover state. If <code>null</code>, then
	 * <code>defaultIcon</code> is used instead.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button an icon for the hover state:</p>
	 *
	 * <listing version="3.0">
	 * button.hoverIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #STATE_HOVER
	 */
	public var hoverIcon(get, set):DisplayObject;
	public function get_hoverIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(STATE_HOVER, false);
	}

	/**
	 * @private
	 */
	public function set_hoverIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(STATE_HOVER, false) == value)
		{
			return get_hoverIcon();
		}
		this._iconSelector.setValueForState(value, STATE_HOVER, false);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_hoverIcon();
	}
	
	/**
	 * The icon used for the button's disabled state. If <code>null</code>, then
	 * <code>defaultIcon</code> is used instead.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button an icon for the disabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.disabledIcon = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #defaultIcon
	 * @see #STATE_DISABLED
	 */
	public var disabledIcon(get, set):DisplayObject;
	public function get_disabledIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(STATE_DISABLED, false);
	}
	
	/**
	 * @private
	 */
	public function set_disabledIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(STATE_DISABLED, false) == value)
		{
			return get_disabledIcon();
		}
		this._iconSelector.setValueForState(value, STATE_DISABLED, false);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_disabledIcon();
	}

	/**
	 * @private
	 * Used for determining the duration of a long press.
	 */
	private var _touchBeginTime:Int;

	/**
	 * @private
	 */
	private var _hasLongPressed:Bool = false;

	/**
	 * @private
	 */
	private var _longPressDuration:Float = 0.5;

	/**
	 * The duration, in seconds, of a long press.
	 *
	 * <p>The following example changes the long press duration to one full second:</p>
	 *
	 * <listing version="3.0">
	 * button.longPressDuration = 1.0;</listing>
	 *
	 * @default 0.5
	 *
	 * @see #event:longPress
	 * @see #isLongPressEnabled
	 */
	public var longPressDuration(get, set):Float;
	public function get_longPressDuration():Float
	{
		return this._longPressDuration;
	}

	/**
	 * @private
	 */
	public function set_longPressDuration(value:Float):Float
	{
		return this._longPressDuration = value;
	}

	/**
	 * @private
	 */
	private var _isLongPressEnabled:Bool = false;

	/**
	 * Determines if <code>FeathersEventType.LONG_PRESS</code> will be
	 * dispatched.
	 *
	 * <p>The following example enables long presses:</p>
	 *
	 * <listing version="3.0">
	 * button.isLongPressEnabled = true;
	 * button.addEventListener( FeathersEventType.LONG_PRESS, function( event:Event ):Void
	 * {
	 *     // long press
	 * });</listing>
	 *
	 * @default false
	 *
	 * @see #event:longPress
	 * @see #longPressDuration
	 */
	public var isLongPressEnabled(get, set):Bool;
	public function get_isLongPressEnabled():Bool
	{
		return this._isLongPressEnabled;
	}

	/**
	 * @private
	 */
	public function set_isLongPressEnabled(value:Bool):Bool
	{
		this._isLongPressEnabled = value;
		if(!value)
		{
			this.removeEventListener(Event.ENTER_FRAME, longPress_enterFrameHandler);
		}
		return get_isLongPressEnabled();
	}

	/**
	 * @private
	 */
	private var _scaleWhenDown:Number = 1;

	/**
	 * The button renders at this scale in the down state.
	 *
	 * <p>The following example scales the button in the down state:</p>
	 *
	 * <listing version="3.0">
	 * button.scaleWhenDown = 0.9;</listing>
	 *
	 * @default 1
	 */
	public function get_scaleWhenDown():Number
	{
		return this._scaleWhenDown;
	}

	/**
	 * @private
	 */
	public function set_scaleWhenDown(value:Number):Number
	{
		this._scaleWhenDown = value;
	}

	/**
	 * @private
	 */
	private var _scaleWhenHovering:Number = 1;

	/**
	 * The button renders at this scale in the hover state.
	 *
	 * <p>The following example scales the button in the hover state:</p>
	 *
	 * <listing version="3.0">
	 * button.scaleWhenHovering = 0.9;</listing>
	 *
	 * @default 1
	 */
	public function get_scaleWhenHovering():Number
	{
		return this._scaleWhenHovering;
	}

	/**
	 * @private
	 */
	public function set_scaleWhenHovering(value:Number):Number
	{
		this._scaleWhenHovering = value;
	}

	/**
	 * @private
	 */
	private var _ignoreIconResizes:Boolean = false;

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Number):void
	{
		var scale:Number = 1;
		if(this._currentState == STATE_DOWN)
		{
			scale = this._scaleWhenDown;
		}
		else if(this._currentState == STATE_HOVER)
		{
			scale = this._scaleWhenHovering;
		}
		if(scale !== 1)
		{
			support.scaleMatrix(scale, scale);
			support.translateMatrix(Math.round((1 - scale) / 2 * this.actualWidth),
				Math.round((1 - scale) / 2 * this.actualHeight));
		}
		super.render(support, parentAlpha);
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
		var textRendererInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_TEXT_RENDERER);
		var focusInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_FOCUS);

		if(textRendererInvalid)
		{
			this.createLabel();
		}
		
		if(textRendererInvalid || stateInvalid || dataInvalid)
		{
			this.refreshLabel();
		}

		if(stylesInvalid || stateInvalid)
		{
			this.refreshSkin();
			this.refreshIcon();
		}

		if(textRendererInvalid || stylesInvalid || stateInvalid)
		{
			this.refreshLabelStyles();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
		
		if(stylesInvalid || stateInvalid || sizeInvalid)
		{
			this.scaleSkin();
		}
		
		if(textRendererInvalid || stylesInvalid || stateInvalid || dataInvalid || sizeInvalid)
		{
			this.layoutContent();
		}

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
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		this.refreshMaxLabelSize(true);
		if(this.labelTextRenderer != null)
		{
			this.labelTextRenderer.measureText(HELPER_POINT);
		}
		else
		{
			HELPER_POINT.setTo(0, 0);
		}
		var newWidth:Float = this.explicitWidth;
		var adjustedGap:Float;
		if(needsWidth)
		{
			if(this.currentIcon != null && this.label != null)
			{
				if(this._iconPosition != ICON_POSITION_TOP && this._iconPosition != ICON_POSITION_BOTTOM &&
					this._iconPosition != ICON_POSITION_MANUAL)
				{
					adjustedGap = this._gap;
					if(adjustedGap == Math.POSITIVE_INFINITY)
					{
						adjustedGap = this._minGap;
					}
					newWidth = this.currentIcon.width + adjustedGap + HELPER_POINT.x;
				}
				else
				{
					newWidth = Math.max(this.currentIcon.width, HELPER_POINT.x);
				}
			}
			else if(this.currentIcon != null)
			{
				newWidth = this.currentIcon.width;
			}
			else if(this.label != null)
			{
				newWidth = HELPER_POINT.x;
			}
			newWidth += this._paddingLeft + this._paddingRight;
			if(newWidth != newWidth) //isNaN
			{
				newWidth = this._originalSkinWidth;
				if(newWidth != newWidth)
				{
					newWidth = 0;
				}
			}
			else if(this._originalSkinWidth == this._originalSkinWidth) //!isNaN
			{
				if(this._originalSkinWidth > newWidth)
				{
					newWidth = this._originalSkinWidth;
				}
			}
		}

		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			if(this.currentIcon != null && this.label != null)
			{
				if(this._iconPosition == ICON_POSITION_TOP || this._iconPosition == ICON_POSITION_BOTTOM)
				{
					adjustedGap = this._gap;
					if(adjustedGap == Math.POSITIVE_INFINITY)
					{
						adjustedGap = this._minGap;
					}
					newHeight = this.currentIcon.height + adjustedGap + HELPER_POINT.y;
				}
				else
				{
					newHeight = Math.max(this.currentIcon.height, HELPER_POINT.y);
				}
			}
			else if(this.currentIcon != null)
			{
				newHeight = this.currentIcon.height;
			}
			else if(this.label != null)
			{
				newHeight = HELPER_POINT.y;
			}
			newHeight += this._paddingTop + this._paddingBottom;
			if(newHeight != newHeight)
			{
				newHeight = this._originalSkinHeight;
				if(newHeight != newHeight)
				{
					newHeight = 0;
				}
			}
			else if(this._originalSkinHeight == this._originalSkinHeight) //!isNaN
			{
				if(this._originalSkinHeight > newHeight)
				{
					newHeight = this._originalSkinHeight;
				}
			}
		}

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates the label text renderer sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #labelTextRenderer
	 * @see #labelFactory
	 */
	private function createLabel():Void
	{
		if(this.labelTextRenderer != null)
		{
			this.removeChild(cast(this.labelTextRenderer, DisplayObject), true);
			this.labelTextRenderer = null;
		}

		if(this._hasLabelTextRenderer)
		{
			var factory:Void->ITextRenderer = this._labelFactory != null ? this._labelFactory : FeathersControl.defaultTextRendererFactory;
			this.labelTextRenderer = factory();
			this.labelTextRenderer.styleNameList.add(this.labelName);
			this.addChild(cast(this.labelTextRenderer, DisplayObject));
		}
	}

	/**
	 * @private
	 */
	private function refreshLabel():Void
	{
		if(this.labelTextRenderer == null)
		{
			return;
		}
		this.labelTextRenderer.text = this._label;
		this.labelTextRenderer.visible = this._label != null && this._label.length > 0;
		this.labelTextRenderer.isEnabled = this._isEnabled;
	}

	/**
	 * Sets the <code>currentSkin</code> property.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private function refreshSkin():Void
	{
		var oldSkin:DisplayObject = this.currentSkin;
		if(this._stateToSkinFunction != null)
		{
			this.currentSkin = this._stateToSkinFunction(this, this._currentState, oldSkin);
		}
		else
		{
			this.currentSkin = this._skinSelector.updateValue(this, this._currentState, this.currentSkin);
		}
		if(this.currentSkin != oldSkin)
		{
			if(oldSkin != null)
			{
				this.removeChild(oldSkin, false);
			}
			if(this.currentSkin != null)
			{
				this.addChildAt(this.currentSkin, 0);
			}
		}
		if(this.currentSkin != null &&
			(this._originalSkinWidth != this._originalSkinWidth || //isNaN
			this._originalSkinHeight != this._originalSkinHeight))
		{
			if(Std.is(this.currentSkin, IValidating))
			{
				cast(this.currentSkin, IValidating).validate();
			}
			this._originalSkinWidth = this.currentSkin.width;
			this._originalSkinHeight = this.currentSkin.height;
		}
	}
	
	/**
	 * Sets the <code>currentIcon</code> property.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private function refreshIcon():Void
	{
		var oldIcon:DisplayObject = this.currentIcon;
		if(this._stateToIconFunction != null)
		{
			this.currentIcon = this._stateToIconFunction(this, this._currentState, oldIcon);
		}
		else
		{
			this.currentIcon = this._iconSelector.updateValue(this, this._currentState, this.currentIcon);
		}
		if(Std.is(this.currentIcon, IFeathersControl))
		{
			cast(this.currentIcon, IFeathersControl).isEnabled = this._isEnabled;
		}
		if(this.currentIcon != oldIcon)
		{
			if(oldIcon != null)
			{
				if(oldIcon is IFeathersControl)
				{
					IFeathersControl(oldIcon).removeEventListener(FeathersEventType.RESIZE, currentIcon_resizeHandler);
				}
				this.removeChild(oldIcon, false);
			}
			if(this.currentIcon != null)
			{
				//we want the icon to appear below the label text renderer
				var index:Int = this.numChildren;
				if(this.labelTextRenderer != null)
				{
					index = this.getChildIndex(cast(this.labelTextRenderer, DisplayObject));
				}
				this.addChildAt(this.currentIcon, index);
				if(this.currentIcon is IFeathersControl)
				{
					IFeathersControl(this.currentIcon).addEventListener(FeathersEventType.RESIZE, currentIcon_resizeHandler);
				}
			}
		}
	}
	
	/**
	 * @private
	 */
	private function refreshLabelStyles():Void
	{
		if(this.labelTextRenderer == null)
		{
			return;
		}
		var properties:PropertyProxy;
		if(this._stateToLabelPropertiesFunction != null)
		{
			properties = this._stateToLabelPropertiesFunction(this, this._currentState);
		}
		else
		{
			properties = this._labelPropertiesSelector.updateValue(this, this._currentState);
		}
		if (properties == null)
			return;
		for(propertyName in Reflect.fields(properties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(properties.storage, propertyName);
			Reflect.setProperty(this.labelTextRenderer, propertyName, propertyValue);
		}
	}
	
	/**
	 * @private
	 */
	private function scaleSkin():Void
	{
		if(this.currentSkin == null)
		{
			return;
		}
		this.currentSkin.x = 0;
		this.currentSkin.y = 0;
		if(this.currentSkin.width != this.actualWidth)
		{
			this.currentSkin.width = this.actualWidth;
		}
		if(this.currentSkin.height != this.actualHeight)
		{
			this.currentSkin.height = this.actualHeight;
		}
		if(Std.is(this.currentSkin, IValidating))
		{
			cast(this.currentSkin, IValidating).validate();
		}
	}
	
	/**
	 * Positions and sizes the button's content.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private function layoutContent():Void
	{
		var oldIgnoreIconResizes:Boolean = this._ignoreIconResizes;
		this._ignoreIconResizes = true;
		this.refreshMaxLabelSize(false);
		if(this._label != null && this.labelTextRenderer != null && this.currentIcon != null)
		{
			this.labelTextRenderer.validate();
			this.positionSingleChild(cast(this.labelTextRenderer, DisplayObject));
			if(this._iconPosition != ICON_POSITION_MANUAL)
			{
				this.positionLabelAndIcon();
			}

		}
		else if(this._label != null && this.labelTextRenderer != null && this.currentIcon == null)
		{
			this.labelTextRenderer.validate();
			this.positionSingleChild(cast(this.labelTextRenderer, DisplayObject));
		}
		else if((this._label == null || this.labelTextRenderer == null) && this.currentIcon != null && this._iconPosition != ICON_POSITION_MANUAL)
		{
			this.positionSingleChild(this.currentIcon);
		}

		if(this.currentIcon != null)
		{
			if(this._iconPosition == ICON_POSITION_MANUAL)
			{
				this.currentIcon.x = this._paddingLeft;
				this.currentIcon.y = this._paddingTop;
			}
			this.currentIcon.x += this._iconOffsetX;
			this.currentIcon.y += this._iconOffsetY;
		}
		if(this._label != null && this.labelTextRenderer != null)
		{
			this.labelTextRenderer.x += this._labelOffsetX;
			this.labelTextRenderer.y += this._labelOffsetY;
		}
		this._ignoreIconResizes = oldIgnoreIconResizes;
	}

	/**
	 * @private
	 */
	private function refreshMaxLabelSize(forMeasurement:Boolean):void
	{
		if(Std.is(this.currentIcon, IValidating))
		{
			cast(this.currentIcon, IValidating).validate();
		}
		var calculatedWidth:Number = this.actualWidth;
		var calculatedHeight:Number = this.actualHeight;
		if(forMeasurement)
		{
			calculatedWidth = this.explicitWidth;
			if(calculatedWidth != calculatedWidth) //isNaN
			{
				calculatedWidth = this._maxWidth;
			}
			calculatedHeight = this.explicitHeight;
			if(calculatedHeight !== calculatedHeight) //isNaN
			{
				calculatedHeight = this._maxHeight;
			}
		}
		if(this._label && this.labelTextRenderer)
		{
			this.labelTextRenderer.maxWidth = calculatedWidth - this._paddingLeft - this._paddingRight;
			this.labelTextRenderer.maxHeight = calculatedHeight - this._paddingTop - this._paddingBottom;
			if(this.currentIcon)
			{
				var adjustedGap:Float = this._gap;
				if(adjustedGap == Math.POSITIVE_INFINITY)
				{
					adjustedGap = this._minGap;
				}
				if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE ||
					this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
				{
					this.labelTextRenderer.maxWidth -= (this.currentIcon.width + adjustedGap);
				}
				if(this._iconPosition == ICON_POSITION_TOP || this._iconPosition == ICON_POSITION_BOTTOM)
				{
					this.labelTextRenderer.maxHeight -= (this.currentIcon.height + adjustedGap);
				}
			}
		}
	}
	
	/**
	 * @private
	 */
	private function positionSingleChild(displayObject:DisplayObject):Void
	{
		if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
		{
			displayObject.x = this._paddingLeft;
		}
		else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
		{
			displayObject.x = this.actualWidth - this._paddingRight - displayObject.width;
		}
		else //center
		{
			displayObject.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - displayObject.width) / 2);
		}
		if(this._verticalAlign == VERTICAL_ALIGN_TOP)
		{
			displayObject.y = this._paddingTop;
		}
		else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
		{
			displayObject.y = this.actualHeight - this._paddingBottom - displayObject.height;
		}
		else //middle
		{
			displayObject.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - displayObject.height) / 2);
		}
	}
	
	/**
	 * @private
	 */
	private function positionLabelAndIcon():Void
	{
		if(this._iconPosition == ICON_POSITION_TOP)
		{
			if(this._gap == Math.POSITIVE_INFINITY)
			{
				this.currentIcon.y = this._paddingTop;
				this.labelTextRenderer.y = this.actualHeight - this._paddingBottom - this.labelTextRenderer.height;
			}
			else
			{
				if(this._verticalAlign == VERTICAL_ALIGN_TOP)
				{
					this.labelTextRenderer.y += this.currentIcon.height + this._gap;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					this.labelTextRenderer.y += Math.round((this.currentIcon.height + this._gap) / 2);
				}
				this.currentIcon.y = this.labelTextRenderer.y - this.currentIcon.height - this._gap;
			}
		}
		else if(this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
		{
			if(this._gap == Math.POSITIVE_INFINITY)
			{
				this.labelTextRenderer.x = this._paddingLeft;
				this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
			}
			else
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					this.labelTextRenderer.x -= this.currentIcon.width + this._gap;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					this.labelTextRenderer.x -= Math.round((this.currentIcon.width + this._gap) / 2);
				}
				this.currentIcon.x = this.labelTextRenderer.x + this.labelTextRenderer.width + this._gap;
			}
		}
		else if(this._iconPosition == ICON_POSITION_BOTTOM)
		{
			if(this._gap == Math.POSITIVE_INFINITY)
			{
				this.labelTextRenderer.y = this._paddingTop;
				this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
			}
			else
			{
				if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					this.labelTextRenderer.y -= this.currentIcon.height + this._gap;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					this.labelTextRenderer.y -= Math.round((this.currentIcon.height + this._gap) / 2);
				}
				this.currentIcon.y = this.labelTextRenderer.y + this.labelTextRenderer.height + this._gap;
			}
		}
		else if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE)
		{
			if(this._gap == Math.POSITIVE_INFINITY)
			{
				this.currentIcon.x = this._paddingLeft;
				this.labelTextRenderer.x = this.actualWidth - this._paddingRight - this.labelTextRenderer.width;
			}
			else
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
				{
					this.labelTextRenderer.x += this._gap + this.currentIcon.width;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					this.labelTextRenderer.x += Math.round((this._gap + this.currentIcon.width) / 2);
				}
				this.currentIcon.x = this.labelTextRenderer.x - this._gap - this.currentIcon.width;
			}
		}
		
		if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_RIGHT)
		{
			if(this._verticalAlign == VERTICAL_ALIGN_TOP)
			{
				this.currentIcon.y = this._paddingTop;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
			}
			else
			{
				this.currentIcon.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2);
			}
		}
		else if(this._iconPosition == ICON_POSITION_LEFT_BASELINE || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
		{
			this.currentIcon.y = this.labelTextRenderer.y + (this.labelTextRenderer.baseline) - this.currentIcon.height;
		}
		else //top or bottom
		{
			if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
			{
				this.currentIcon.x = this._paddingLeft;
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
			}
			else
			{
				this.currentIcon.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - this.currentIcon.width) / 2);
			}
		}
	}

	/**
	 * @private
	 */
	private function resetTouchState(touch:Touch = null):Void
	{
		this.touchPointID = -1;
		this.removeEventListener(Event.ENTER_FRAME, longPress_enterFrameHandler);
		if(this._isEnabled)
		{
			this.currentState = STATE_UP;
		}
		else
		{
			this.currentState = STATE_DISABLED;
		}
	}

	/**
	 * Triggers the button.
	 */
	private function trigger():Void
	{
		this.dispatchEventWith(Event.TRIGGERED);
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
	override private function focusInHandler(event:Event):Void
	{
		super.focusInHandler(event);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		this.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
	}

	/**
	 * @private
	 */
	override private function focusOutHandler(event:Event):Void
	{
		super.focusOutHandler(event);
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		this.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);

		if(this.touchPointID >= 0)
		{
			this.touchPointID = -1;
			if(this._isEnabled)
			{
				this.currentState = STATE_UP;
			}
			else
			{
				this.currentState = STATE_DISABLED;
			}
		}
	}

	/**
	 * @private
	 */
	private function button_removedFromStageHandler(event:Event):Void
	{
		this.resetTouchState();
	}
	
	/**
	 * @private
	 */
	private function button_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
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
				//this should never happen
				return;
			}

			touch.getLocation(this.stage, HELPER_POINT);
			var isInBounds:Bool = this.contains(this.stage.hitTest(HELPER_POINT, true));
			if(touch.phase == TouchPhase.MOVED)
			{
				if(isInBounds || this.keepDownStateOnRollOut)
				{
					this.currentState = STATE_DOWN;
				}
				else
				{
					this.currentState = STATE_UP;
				}
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.resetTouchState(touch);
				//we we dispatched a long press, then triggered and change
				//won't be able to happen until the next touch begins
				if(!this._hasLongPressed && isInBounds)
				{
					this.trigger();
				}
			}
			return;
		}
		else //if we get here, we don't have a saved touch ID yet
		{
			touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch != null)
			{
				this.currentState = STATE_DOWN;
				this.touchPointID = touch.id;
				if(this._isLongPressEnabled)
				{
					this._touchBeginTime = getTimer();
					this._hasLongPressed = false;
					this.addEventListener(Event.ENTER_FRAME, longPress_enterFrameHandler);
				}
				return;
			}
			touch = event.getTouch(this, TouchPhase.HOVER);
			if(touch != null)
			{
				this.currentState = STATE_HOVER;
				return;
			}

			//end of hover
			this.currentState = STATE_UP;
		}
	}

	/**
	 * @private
	 */
	private function longPress_enterFrameHandler(event:Event):Void
	{
		var accumulatedTime:Float = (getTimer() - this._touchBeginTime) / 1000;
		if(accumulatedTime >= this._longPressDuration)
		{
			this.removeEventListener(Event.ENTER_FRAME, longPress_enterFrameHandler);
			this._hasLongPressed = true;
			this.dispatchEventWith(FeathersEventType.LONG_PRESS);
		}
	}

	/**
	 * @private
	 */
	private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.keyCode == Keyboard.ESCAPE)
		{
			this.touchPointID = -1;
			this.currentState = STATE_UP;
		}
		if(this.touchPointID >= 0 || event.keyCode != Keyboard.SPACE)
		{
			return;
		}
		this.touchPointID = Max.INT_MAX_VALUE;
		this.currentState = STATE_DOWN;
	}

	/**
	 * @private
	 */
	private function stage_keyUpHandler(event:KeyboardEvent):Void
	{
		if(this.touchPointID != Max.INT_MAX_VALUE || event.keyCode != Keyboard.SPACE)
		{
			return;
		}
		this.resetTouchState();
		this.trigger();
	}

	/**
	 * @private
	 */
	private function currentIcon_resizeHandler():void
	{
		if(this._ignoreIconResizes)
		{
			return;
		}
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}
}
}