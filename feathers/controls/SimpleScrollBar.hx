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

import starling.display.Quad;
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
 * Dispatched when the user starts dragging the scroll bar's thumb.
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
 * Dispatched when the user stops dragging the scroll bar's thumb.
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
 * a physical range. This type of scroll bar does not have a visible track,
 * and it does not have increment and decrement buttons. It is ideal for
 * mobile applications where the scroll bar is often simply a visual element
 * to indicate the scroll position. For a more feature-rich scroll bar,
 * see the <code>ScrollBar</code> component.
 *
 * <p>The following example updates a list to use simple scroll bars:</p>
 *
 * <listing version="3.0">
 * list.horizontalScrollBarFactory = function():IScrollBar
 * {
 *     var scrollBar:SimpleScrollBar = new SimpleScrollBar();
 *     scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
 *     return scrollBar;
 * };
 * list.verticalScrollBarFactory = function():IScrollBar
 * {
 *     var scrollBar:SimpleScrollBar = new SimpleScrollBar();
 *     scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
 *     return scrollBar;
 * };</listing>
 *
 * @see ../../../help/simple-scroll-bar.html How to use the Feathers SimpleScrollBar component
 * @see feathers.controls.ScrollBar
 */
class SimpleScrollBar extends FeathersControl implements IDirectionalScrollBar
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
	 * The default value added to the <code>styleNameList</code> of the thumb.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-simple-scroll-bar-thumb";

	/**
	 * DEPRECATED: Replaced by <code>Scroller.DEFAULT_CHILD_STYLE_NAME_THUMB</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Scroller#DEFAULT_CHILD_STYLE_NAME_THUMB
	 */
	inline public static var DEFAULT_CHILD_NAME_THUMB:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

	/**
	 * The default <code>IStyleProvider</code> for all <code>SimpleScrollBar</code>
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
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
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
	 * @private
	 */
	private var thumbOriginalWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var thumbOriginalHeight:Float = Math.NaN;

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
	 * @private
	 */
	private var track:Quad;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return SimpleScrollBar.globalStyleProvider;
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
	 * scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;</listing>
	 *
	 * @default SimpleScrollBar.DIRECTION_HORIZONTAL
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
		this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		return get_direction();
	}

	/**
	 * Determines if the value should be clamped to the range between the
	 * minimum and maximum. If <code>false</code> and the value is outside of the range,
	 * the thumb will shrink as if the range were increasing.
	 *
	 * <p>In the following example, the clamping behavior is updated:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.clampToRange = true;</listing>
	 *
	 * @default false
	 */
	public var clampToRange:Bool = false;

	/**
	 * @private
	 */
	private var _value:Float = 0;

	/**
	 * @inheritDoc
	 *
	 * @default 0
	 *
	 * @see #maximum
	 * @see #minimum
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
		if(this.clampToRange)
		{
			newValue = clamp(newValue, this._minimum, this._maximum);
		}
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
	 * The minimum space, in pixels, above the thumb.
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
	 * The minimum space, in pixels, to the right of the thumb.
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
	 * The minimum space, in pixels, below the thumb.
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
	 * The minimum space, in pixels, to the left of the thumb.
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
	public var thumbFactory(get, set):Dynamic;
	public function get_thumbFactory():Dynamic
	{
		return this._thumbFactory;
	}

	/**
	 * @private
	 */
	public function set_thumbFactory(value:Dynamic):Dynamic
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
		if(this.track == null)
		{
			this.track = new Quad(10, 10, 0xff00ff);
			this.track.alpha = 0;
			this.track.addEventListener(TouchEvent.TOUCH, track_touchHandler);
			this.addChild(this.track);
		}
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
		var thumbFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);

		if(thumbFactoryInvalid)
		{
			this.createThumb();
		}

		if(thumbFactoryInvalid || stylesInvalid)
		{
			this.refreshThumbStyles();
		}

		if(dataInvalid || thumbFactoryInvalid || stateInvalid)
		{
			this.thumb.isEnabled = this._isEnabled && this._maximum > this._minimum;
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
		if(this.thumbOriginalWidth != this.thumbOriginalWidth ||
			this.thumbOriginalHeight != this.thumbOriginalHeight) //isNaN
		{
			this.thumb.validate();
			this.thumbOriginalWidth = this.thumb.width;
			this.thumbOriginalHeight = this.thumb.height;
		}

		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}

		var range:Float = this._maximum - this._minimum;
		var adjustedPage:Float = this._page;
		if(adjustedPage === 0)
		{
			//fall back to using step!
			adjustedPage = this._step;
		}
		if(adjustedPage > range)
		{
			adjustedPage = range;
		}
		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				newWidth = this.thumbOriginalWidth;
			}
			else //horizontal
			{
				if(adjustedPage === 0)
				{
					newWidth = this.thumbOriginalWidth;
				}
				else
				{
					newWidth = this.thumbOriginalWidth * range / adjustedPage;
					if(newWidth < this.thumbOriginalWidth)
					{
						newWidth = this.thumbOriginalWidth;
					}
				}
			}
			newWidth += this._paddingLeft + this._paddingRight;
		}
		if(needsHeight)
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				if(adjustedPage === 0)
				{
					newHeight = this.thumbOriginalHeight;
				}
				else
				{
					newHeight = this.thumbOriginalHeight * range / adjustedPage;
					if(newHeight < this.thumbOriginalHeight)
					{
						newHeight = this.thumbOriginalHeight;
					}
				}
			}
			else //horizontal
			{
				newHeight = this.thumbOriginalHeight;
			}
			newHeight += this._paddingTop + this._paddingBottom;
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
		this.thumb.isFocusEnabled = false;
		this.thumb.keepDownStateOnRollOut = true;
		this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
		this.addChild(this.thumb);
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
	}

	/**
	 * @private
	 */
	private function layout():Void
	{
		this.track.width = this.actualWidth;
		this.track.height = this.actualHeight;

		var range:Float = this._maximum - this._minimum;
		this.thumb.visible = range > 0;
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
		else if(adjustedPage > range)
		{
			adjustedPage = range;
		}
		var valueOffset:Float = 0;
		if(this._value < this._minimum)
		{
			valueOffset = (this._minimum - this._value);
		}
		if(this._value > this._maximum)
		{
			valueOffset = (this._value - this._maximum);
		}
		if(this._direction == DIRECTION_VERTICAL)
		{
			this.thumb.width = this.thumbOriginalWidth;
			var thumbMinHeight:Float = this.thumb.minHeight > 0 ? this.thumb.minHeight : this.thumbOriginalHeight;
			var thumbHeight:Float = contentHeight * adjustedPage / range;
			var heightOffset:Float = contentHeight - thumbHeight;
			if(heightOffset > thumbHeight)
			{
				heightOffset = thumbHeight;
			}
			heightOffset *=  valueOffset / (range * thumbHeight / contentHeight);
			thumbHeight -= heightOffset;
			if(thumbHeight < thumbMinHeight)
			{
				thumbHeight = thumbMinHeight;
			}
			this.thumb.height = thumbHeight;
			this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
			var trackScrollableHeight:Float = contentHeight - this.thumb.height;
			var thumbY:Float = trackScrollableHeight * (this._value - this._minimum) / range;
			if(thumbY > trackScrollableHeight)
			{
				thumbY = trackScrollableHeight;
			}
			else if(thumbY < 0)
			{
				thumbY = 0;
			}
			this.thumb.y = this._paddingTop + thumbY;
		}
		else //horizontal
		{
			var thumbMinWidth:Float = this.thumb.minWidth > 0 ? this.thumb.minWidth : this.thumbOriginalWidth;
			var thumbWidth:Float = contentWidth * adjustedPage / range;
			var widthOffset:Float = contentWidth - thumbWidth;
			if(widthOffset > thumbWidth)
			{
				widthOffset = thumbWidth;
			}
			widthOffset *= valueOffset / (range * thumbWidth / contentWidth);
			thumbWidth -= widthOffset;
			if(thumbWidth < thumbMinWidth)
			{
				thumbWidth = thumbMinWidth;
			}
			this.thumb.width = thumbWidth;
			this.thumb.height = this.thumbOriginalHeight;
			var trackScrollableWidth:Float = contentWidth - this.thumb.width;
			var thumbX:Float = trackScrollableWidth * (this._value - this._minimum) / range;
			if(thumbX > trackScrollableWidth)
			{
				thumbX = trackScrollableWidth;
			}
			else if(thumbX < 0)
			{
				thumbX = 0;
			}
			this.thumb.x = this._paddingLeft + thumbX;
			this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
		}

		//final validation to avoid juggler next frame issues
		this.thumb.validate();
	}

	/**
	 * @private
	 */
	private function locationToValue(location:Point):Float
	{
		var percentage:Float = 0;
		if(this._direction == DIRECTION_VERTICAL)
		{
			var trackScrollableHeight:Float = this.actualHeight - this.thumb.height - this._paddingTop - this._paddingBottom;
			if(trackScrollableHeight > 0)
			{
				var yOffset:Float = location.y - this._touchStartY - this._paddingTop;
				var yPosition:Float = Math.min(Math.max(0, this._thumbStartY + yOffset), trackScrollableHeight);
				percentage = yPosition / trackScrollableHeight;
			}
		}
		else //horizontal
		{
			var trackScrollableWidth:Float = this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight;
			if(trackScrollableWidth > 0)
			{
				var xOffset:Float = location.x - this._touchStartX - this._paddingLeft;
				var xPosition:Float = Math.min(Math.max(0, this._thumbStartX + xOffset), trackScrollableWidth);
				percentage = xPosition / trackScrollableWidth;
			}
		}

		return this._minimum + percentage * (this._maximum - this._minimum);
	}

	/**
	 * @private
	 */
	private function adjustPage():Void
	{
		var range:Float = this._maximum - this._minimum;
		var adjustedPage:Float = this._page;
		if(adjustedPage === 0)
		{
			adjustedPage = this._step;
		}
		if(adjustedPage > range)
		{
			adjustedPage = range;
		}
		if(this._touchValue < this._value)
		{
			var newValue:Float = Math.max(this._touchValue, this._value - adjustedPage);
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

		var touch:Touch;
		if(this._touchPointID >= 0)
		{
			touch = event.getTouch(this.track, TouchPhase.ENDED, this._touchPointID);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = -1;
			this._repeatTimer.stop();
		}
		else
		{
			touch = event.getTouch(this.track, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = touch.id;
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
	private function repeatTimer_timerHandler(event:TimerEvent):Void
	{
		if(this._repeatTimer.currentCount < 5)
		{
			return;
		}
		this.currentRepeatAction();
	}
}
