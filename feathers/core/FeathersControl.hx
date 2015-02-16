/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.controls.text.StageTextTextEditor;
import feathers.events.FeathersEventType;
import feathers.layout.ILayoutData;
import feathers.layout.ILayoutDisplayObject;
import feathers.skins.IStyleProvider;
import feathers.utils.display.getDisplayObjectDepthFromStage;

import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.MatrixUtil;

/**
 * Dispatched after <code>initialize()</code> has been called, but before
 * the first time that <code>draw()</code> has been called.
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
 * @eventType feathers.events.FeathersEventType.INITIALIZE
 */
//[Event(name="initialize",type="starling.events.Event")]

/**
 * Dispatched after the component has validated for the first time. Both
 * <code>initialize()</code> and <code>draw()</code> will have been called,
 * and all children will have been created.
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
 * @eventType feathers.events.FeathersEventType.CREATION_COMPLETE
 */
//[Event(name="creationComplete",type="starling.events.Event")]

/**
 * Dispatched when the width or height of the control changes.
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
 * @eventType feathers.events.FeathersEventType.RESIZE
 */
//[Event(name="resize",type="starling.events.Event")]

/**
 * Base class for all UI controls. Implements invalidation and sets up some
 * basic template functions like <code>initialize()</code> and
 * <code>draw()</code>.
 *
 * <p>For a base component class that supports layouts, see <code>LayoutGroup</code>.</p>
 *
 * @see feathers.controls.LayoutGroup
 */
class FeathersControl extends Sprite implements IFeathersControl, ILayoutDisplayObject
{
	/**
	 * @private
	 */
	inline private static var HELPER_MATRIX:Matrix = new Matrix();

	/**
	 * @private
	 */
	inline private static var HELPER_POINT:Point = new Point();

	/**
	 * Flag to indicate that everything is invalid and should be redrawn.
	 */
	inline public static var INVALIDATION_FLAG_ALL:String = "all";

	/**
	 * Invalidation flag to indicate that the state has changed. Used by
	 * <code>isEnabled</code>, but may be used for other control states too.
	 *
	 * @see #isEnabled
	 */
	inline public static var INVALIDATION_FLAG_STATE:String = "state";

	/**
	 * Invalidation flag to indicate that the dimensions of the UI control
	 * have changed.
	 */
	inline public static var INVALIDATION_FLAG_SIZE:String = "size";

	/**
	 * Invalidation flag to indicate that the styles or visual appearance of
	 * the UI control has changed.
	 */
	inline public static var INVALIDATION_FLAG_STYLES:String = "styles";

	/**
	 * Invalidation flag to indicate that the skin of the UI control has changed.
	 */
	inline public static var INVALIDATION_FLAG_SKIN:String = "skin";

	/**
	 * Invalidation flag to indicate that the layout of the UI control has
	 * changed.
	 */
	inline public static var INVALIDATION_FLAG_LAYOUT:String = "layout";

	/**
	 * Invalidation flag to indicate that the primary data displayed by the
	 * UI control has changed.
	 */
	inline public static var INVALIDATION_FLAG_DATA:String = "data";

	/**
	 * Invalidation flag to indicate that the scroll position of the UI
	 * control has changed.
	 */
	inline public static var INVALIDATION_FLAG_SCROLL:String = "scroll";

	/**
	 * Invalidation flag to indicate that the selection of the UI control
	 * has changed.
	 */
	inline public static var INVALIDATION_FLAG_SELECTED:String = "selected";

	/**
	 * Invalidation flag to indicate that the focus of the UI control has
	 * changed.
	 */
	inline public static var INVALIDATION_FLAG_FOCUS:String = "focus";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_TEXT_RENDERER:String = "textRenderer";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_TEXT_EDITOR:String = "textEditor";

	/**
	 * @private
	 */
	inline private static var ILLEGAL_WIDTH_ERROR:String = "A component's width cannot be NaN.";

	/**
	 * @private
	 */
	inline private static var ILLEGAL_HEIGHT_ERROR:String = "A component's height cannot be NaN.";

	/**
	 * @private
	 */
	inline private static var ABSTRACT_CLASS_ERROR:String = "FeathersControl is an abstract class. For a lightweight Feathers wrapper, use feathers.controls.LayoutGroup.";

	/**
	 * A function used by all UI controls that support text renderers to
	 * create an ITextRenderer instance. You may replace the default
	 * function with your own, if you prefer not to use the
	 * BitmapFontTextRenderer.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-renderers
	 * @see feathers.core.ITextRenderer
	 */
	public static var defaultTextRendererFactory:Dynamic = function():ITextRenderer
	{
		return new BitmapFontTextRenderer();
	}

	/**
	 * A function used by all UI controls that support text editor to
	 * create an <code>ITextEditor</code> instance. You may replace the
	 * default function with your own, if you prefer not to use the
	 * <code>StageTextTextEditor</code>.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ITextEditor</pre>
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-editors
	 * @see feathers.core.ITextEditor
	 */
	public static var defaultTextEditorFactory:Dynamic = function():ITextEditor
	{
		return new StageTextTextEditor();
	}

	/**
	 * Constructor.
	 */
	public function FeathersControl()
	{
		super();
		if(Object(this).constructor == FeathersControl)
		{
			throw new Error(ABSTRACT_CLASS_ERROR);
		}
		this._styleProvider = this.defaultStyleProvider;
		this.addEventListener(Event.ADDED_TO_STAGE, feathersControl_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, feathersControl_removedFromStageHandler);
		this.addEventListener(Event.FLATTEN, feathersControl_flattenHandler);
	}

	/**
	 * @private
	 */
	private var _validationQueue:ValidationQueue;

	/**
	 * The concatenated <code>styleNameList</code>, with values separated
	 * by spaces. Style names are somewhat similar to classes in CSS
	 * selectors. In Feathers, they are a non-unique identifier that can
	 * differentiate multiple styles of the same type of UI control. A
	 * single control may have many style names, and many controls can share
	 * a single style name. A <a href="http://wiki.starling-framework.org/feathers/themes">theme</a>
	 * or another skinning mechanism may use style names to provide a
	 * variety of visual appearances for a single component class.
	 *
	 * <p>In general, the <code>styleName</code> property should not be set
	 * directly on a Feathers component. You should add and remove style
	 * names from the <code>styleNameList</code> property instead.</p>
	 *
	 * @default ""
	 *
	 * @see #styleNameList
	 * @see http://wiki.starling-framework.org/feathers/themes
	 * @see http://wiki.starling-framework.org/feathers/extending-themes
	 */
	public var styleName(get, set):String;
	public function get_styleName():String
	{
		return this._styleNameList.value;
	}

	/**
	 * @private
	 */
	public function set_styleName(value:String):String
	{
		this._styleNameList.value = value;
	}

	/**
	 * @private
	 */
	private var _styleNameList:TokenList = new TokenList();

	/**
	 * Contains a list of all "styles" assigned to this control. Names are
	 * like classes in CSS selectors. They are a non-unique identifier that
	 * can differentiate multiple styles of the same type of UI control. A
	 * single control may have many names, and many controls can share a
	 * single name. A <a href="http://wiki.starling-framework.org/feathers/themes">theme</a>
	 * or another skinning mechanism may use style names to provide a
	 * variety of visual appearances for a single component class.
	 *
	 * <p>Names may be added, removed, or toggled on the
	 * <code>styleNameList</code>. Names cannot contain spaces.</p>
	 *
	 * <p>In the following example, a name is added to the name list:</p>
	 *
	 * <listing version="3.0">
	 * control.styleNameList.add( "custom-component-name" );</listing>
	 *
	 * @see #styleName
	 * @see http://wiki.starling-framework.org/feathers/themes
	 * @see http://wiki.starling-framework.org/feathers/extending-themes
	 */
	public var styleNameList(get, set):TokenList;
	public function get_styleNameList():TokenList
	{
		return this._styleNameList;
	}

	/**
	 * DEPRECATED: Replaced by the <code>styleNameList</code>
	 * property.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.0. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>.</p>
	 *
	 * @see #styleNameList
	 */
	public var nameList(get, set):TokenList;
	public function get_nameList():TokenList
	{
		return this._styleNameList;
	}

	/**
	 * @private
	 */
	private var _styleProvider:IStyleProvider;

	/**
	 * After the component initializes, it may be passed to a style provider
	 * to set skin and style properties.
	 *
	 * @default null
	 *
	 * @see #styleName
	 * @see #styleNameList
	 * @see http://wiki.starling-framework.org/feathers/themes
	 */
	public var styleProvider(get, set):IStyleProvider;
	public function get_styleProvider():IStyleProvider
	{
		return this._styleProvider;
	}

	/**
	 * @private
	 */
	public function set_styleProvider(value:IStyleProvider):IStyleProvider
	{
		if(this.isInitialized)
		{
			throw new IllegalOperationError("The styleProvider property cannot be changed after a component is initialized.");
		}
		this._styleProvider = value;
	}

	/**
	 * When the <code>FeathersControl</code> constructor is called, the
	 * <code>globalStyleProvider</code> property is set to this value. May be
	 * <code>null</code>.
	 *
	 * <p>Typically, a subclass of <code>FeathersControl</code> will
	 * override this function to return its static <code>globalStyleProvider</code>
	 * value. For instance, <code>feathers.controls.Button</code> overrides
	 * this function, and its implementation looks like this:</p>
	 *
	 * <listing version="3.0">
	 * override private function get_defaultStyleProvider():IStyleProvider
	 * {
	 *     return Button.globalStyleProvider;
	 * }</listing>
	 *
	 * @see #styleProvider
	 */
	private function get_defaultStyleProvider():IStyleProvider
	{
		return null;
	}

	/**
	 * @private
	 */
	private var _isQuickHitAreaEnabled:Bool = false;

	/**
	 * Similar to <code>mouseChildren</code> on the classic display list. If
	 * <code>true</code>, children cannot dispatch touch events, but hit
	 * tests will be much faster. Easier than overriding
	 * <code>hitTest()</code>.
	 *
	 * <p>In the following example, the quick hit area is enabled:</p>
	 *
	 * <listing version="3.0">
	 * control.isQuickHitAreaEnabled = true;</listing>
	 *
	 * @default false
	 */
	public var isQuickHitAreaEnabled(get, set):Bool;
	public function get_isQuickHitAreaEnabled():Bool
	{
		return this._isQuickHitAreaEnabled;
	}

	/**
	 * @private
	 */
	public function set_isQuickHitAreaEnabled(value:Bool):Bool
	{
		this._isQuickHitAreaEnabled = value;
	}

	/**
	 * @private
	 */
	private var _hitArea:Rectangle = new Rectangle();

	/**
	 * @private
	 */
	private var _isInitialized:Bool = false;

	/**
	 * Determines if the component has been initialized yet. The
	 * <code>initialize()</code> function is called one time only, when the
	 * Feathers UI control is added to the display list for the first time.
	 *
	 * <p>In the following example, we check if the component is initialized
	 * or not, and we listen for an event if it isn't:</p>
	 *
	 * <listing version="3.0">
	 * if( !control.isInitialized )
	 * {
	 *     control.addEventListener( FeathersEventType.INITIALIZE, initializeHandler );
	 * }</listing>
	 *
	 * @see #event:initialize
	 * @see #isCreated
	 */
	public var isInitialized(get, set):Bool;
	public function get_isInitialized():Bool
	{
		return this._isInitialized;
	}

	/**
	 * @private
	 * A flag that indicates that everything is invalid. If true, no other
	 * flags will need to be tracked.
	 */
	private var _isAllInvalid:Bool = false;

	/**
	 * @private
	 */
	private var _invalidationFlags:Dynamic = {};

	/**
	 * @private
	 */
	private var _delayedInvalidationFlags:Dynamic = {};

	/**
	 * @private
	 */
	private var _isEnabled:Bool = true;

	/**
	 * Indicates whether the control is interactive or not.
	 *
	 * <p>In the following example, the control is disabled:</p>
	 *
	 * <listing version="3.0">
	 * control.isEnabled = false;</listing>
	 *
	 * @default true
	 */
	public var isEnabled(get, set):Bool;
	public function get_isEnabled():Bool
	{
		return _isEnabled;
	}

	/**
	 * @private
	 */
	public function set_isEnabled(value:Bool):Bool
	{
		if(this._isEnabled == value)
		{
			return;
		}
		this._isEnabled = value;
		this.invalidate(INVALIDATION_FLAG_STATE);
	}

	/**
	 * The width value explicitly set by calling the width setter or
	 * setSize().
	 */
	private var explicitWidth:Float = NaN;

	/**
	 * The final width value that should be used for layout. If the width
	 * has been explicitly set, then that value is used. If not, the actual
	 * width will be calculated automatically. Each component has different
	 * automatic sizing behavior, but it's usually based on the component's
	 * skin or content, including text or subcomponents.
	 */
	private var actualWidth:Float = 0;

	/**
	 * @private
	 * The <code>actualWidth</code> value that accounts for
	 * <code>scaleX</code>. Not intended to be used for layout since layout
	 * uses unscaled values. This is the value exposed externally through
	 * the <code>width</code> getter.
	 */
	private var scaledActualWidth:Float = 0;

	/**
	 * The width of the component, in pixels. This could be a value that was
	 * set explicitly, or the component will automatically resize if no
	 * explicit width value is provided. Each component has a different
	 * automatic sizing behavior, but it's usually based on the component's
	 * skin or content, including text or subcomponents.
	 * 
	 * <p><strong>Note:</strong> Values of the <code>width</code> and
	 * <code>height</code> properties may not be accurate until after
	 * validation. If you are seeing <code>width</code> or <code>height</code>
	 * values of <code>0</code>, but you can see something on the screen and
	 * know that the value should be larger, it may be because you asked for
	 * the dimensions before the component had validated. Call
	 * <code>validate()</code> to tell the component to immediately redraw
	 * and calculate an accurate values for the dimensions.</p>
	 *
	 * <p>In the following example, the width is set to 120 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.width = 120;</listing>
	 *
	 * <p>In the following example, the width is cleared so that the
	 * component can automatically measure its own width:</p>
	 *
	 * <listing version="3.0">
	 * control.width = NaN;</listing>
	 * 
	 * @see feathers.core.FeathersControl#validate()
	 */
	override public var width(get, set):Float;
public function get_width():Float
	{
		return this.scaledActualWidth;
	}

	/**
	 * @private
	 */
	override public function set_width(value:Float):Float
	{
		if(this.explicitWidth == value)
		{
			return;
		}
		var valueIsNaN:Bool = value != value; //isNaN
		if(valueIsNaN && this.explicitWidth != this.explicitWidth)
		{
			return;
		}
		this.explicitWidth = value;
		if(valueIsNaN)
		{
			this.actualWidth = this.scaledActualWidth = 0;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		else
		{
			this.setSizeInternal(value, this.actualHeight, true);
		}
	}

	/**
	 * The height value explicitly set by calling the height setter or
	 * setSize().
	 */
	private var explicitHeight:Float = NaN;

	/**
	 * The final height value that should be used for layout. If the height
	 * has been explicitly set, then that value is used. If not, the actual
	 * height will be calculated automatically. Each component has different
	 * automatic sizing behavior, but it's usually based on the component's
	 * skin or content, including text or subcomponents.
	 */
	private var actualHeight:Float = 0;

	/**
	 * @private
	 * The <code>actualHeight</code> value that accounts for
	 * <code>scaleY</code>. Not intended to be used for layout since layout
	 * uses unscaled values. This is the value exposed externally through
	 * the <code>height</code> getter.
	 */
	private var scaledActualHeight:Float = 0;

	/**
	 * The height of the component, in pixels. This could be a value that
	 * was set explicitly, or the component will automatically resize if no
	 * explicit height value is provided. Each component has a different
	 * automatic sizing behavior, but it's usually based on the component's
	 * skin or content, including text or subcomponents.
	 * 
	 * <p><strong>Note:</strong> Values of the <code>width</code> and
	 * <code>height</code> properties may not be accurate until after
	 * validation. If you are seeing <code>width</code> or <code>height</code>
	 * values of <code>0</code>, but you can see something on the screen and
	 * know that the value should be larger, it may be because you asked for
	 * the dimensions before the component had validated. Call
	 * <code>validate()</code> to tell the component to immediately redraw
	 * and calculate an accurate values for the dimensions.</p>
	 *
	 * <p>In the following example, the height is set to 120 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.height = 120;</listing>
	 *
	 * <p>In the following example, the height is cleared so that the
	 * component can automatically measure its own height:</p>
	 *
	 * <listing version="3.0">
	 * control.height = NaN;</listing>
	 * 
	 * @see feathers.core.FeathersControl#validate()
	 */
	override public var height(get, set):Float;
public function get_height():Float
	{
		return this.scaledActualHeight;
	}

	/**
	 * @private
	 */
	override public function set_height(value:Float):Float
	{
		if(this.explicitHeight == value)
		{
			return;
		}
		var valueIsNaN:Bool = value != value; //isNaN
		if(valueIsNaN && this.explicitHeight != this.explicitHeight)
		{
			return;
		}
		this.explicitHeight = value;
		if(valueIsNaN)
		{
			this.actualHeight = this.scaledActualHeight = 0;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		else
		{
			this.setSizeInternal(this.actualWidth, value, true);
		}
	}

	/**
	 * @private
	 */
	private var _minTouchWidth:Float = 0;

	/**
	 * If using <code>isQuickHitAreaEnabled</code>, and the hit area's
	 * width is smaller than this value, it will be expanded.
	 *
	 * <p>In the following example, the minimum width of the hit area is
	 * set to 120 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.minTouchWidth = 120;</listing>
	 *
	 * @default 0
	 */
	public var minTouchWidth(get, set):Float;
	public function get_minTouchWidth():Float
	{
		return this._minTouchWidth;
	}

	/**
	 * @private
	 */
	public function set_minTouchWidth(value:Float):Float
	{
		if(this._minTouchWidth == value)
		{
			return;
		}
		this._minTouchWidth = value;
		this.refreshHitAreaX();
	}

	/**
	 * @private
	 */
	private var _minTouchHeight:Float = 0;

	/**
	 * If using <code>isQuickHitAreaEnabled</code>, and the hit area's
	 * height is smaller than this value, it will be expanded.
	 *
	 * <p>In the following example, the minimum height of the hit area is
	 * set to 120 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.minTouchHeight = 120;</listing>
	 *
	 * @default 0
	 */
	public var minTouchHeight(get, set):Float;
	public function get_minTouchHeight():Float
	{
		return this._minTouchHeight;
	}

	/**
	 * @private
	 */
	public function set_minTouchHeight(value:Float):Float
	{
		if(this._minTouchHeight == value)
		{
			return;
		}
		this._minTouchHeight = value;
		this.refreshHitAreaY();
	}

	/**
	 * @private
	 */
	private var _minWidth:Float = 0;

	/**
	 * The minimum recommended width to be used for self-measurement and,
	 * optionally, by any code that is resizing this component. This value
	 * is not strictly enforced in all cases. An explicit width value that
	 * is smaller than <code>minWidth</code> may be set and will not be
	 * affected by the minimum.
	 *
	 * <p>In the following example, the minimum width of the control is
	 * set to 120 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.minWidth = 120;</listing>
	 *
	 * @default 0
	 */
	public var minWidth(get, set):Float;
	public function get_minWidth():Float
	{
		return this._minWidth;
	}

	/**
	 * @private
	 */
	public function set_minWidth(value:Float):Float
	{
		if(this._minWidth == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minWidth cannot be NaN");
		}
		this._minWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _minHeight:Float = 0;

	/**
	 * The minimum recommended height to be used for self-measurement and,
	 * optionally, by any code that is resizing this component. This value
	 * is not strictly enforced in all cases. An explicit height value that
	 * is smaller than <code>minHeight</code> may be set and will not be
	 * affected by the minimum.
	 *
	 * <p>In the following example, the minimum height of the control is
	 * set to 120 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.minHeight = 120;</listing>
	 *
	 * @default 0
	 */
	public var minHeight(get, set):Float;
	public function get_minHeight():Float
	{
		return this._minHeight;
	}

	/**
	 * @private
	 */
	public function set_minHeight(value:Float):Float
	{
		if(this._minHeight == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minHeight cannot be NaN");
		}
		this._minHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _maxWidth:Float = Float.POSITIVE_INFINITY;

	/**
	 * The maximum recommended width to be used for self-measurement and,
	 * optionally, by any code that is resizing this component. This value
	 * is not strictly enforced in all cases. An explicit width value that
	 * is larger than <code>maxWidth</code> may be set and will not be
	 * affected by the maximum.
	 *
	 * <p>In the following example, the maximum width of the control is
	 * set to 120 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.maxWidth = 120;</listing>
	 *
	 * @default Float.POSITIVE_INFINITY
	 */
	public var maxWidth(get, set):Float;
	public function get_maxWidth():Float
	{
		return this._maxWidth;
	}

	/**
	 * @private
	 */
	public function set_maxWidth(value:Float):Float
	{
		if(this._maxWidth == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxWidth cannot be NaN");
		}
		this._maxWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _maxHeight:Float = Float.POSITIVE_INFINITY;

	/**
	 * The maximum recommended height to be used for self-measurement and,
	 * optionally, by any code that is resizing this component. This value
	 * is not strictly enforced in all cases. An explicit height value that
	 * is larger than <code>maxHeight</code> may be set and will not be
	 * affected by the maximum.
	 *
	 * <p>In the following example, the maximum width of the control is
	 * set to 120 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.maxWidth = 120;</listing>
	 *
	 * @default Float.POSITIVE_INFINITY
	 */
	public var maxHeight(get, set):Float;
	public function get_maxHeight():Float
	{
		return this._maxHeight;
	}

	/**
	 * @private
	 */
	public function set_maxHeight(value:Float):Float
	{
		if(this._maxHeight == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxHeight cannot be NaN");
		}
		this._maxHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	override public function set_scaleX(value:Float):Float
	{
		super.scaleX = value;
		this.setSizeInternal(this.actualWidth, this.actualHeight, false);
	}

	/**
	 * @private
	 */
	override public function set_scaleY(value:Float):Float
	{
		super.scaleY = value;
		this.setSizeInternal(this.actualWidth, this.actualHeight, false);
	}

	/**
	 * @private
	 */
	private var _includeInLayout:Bool = true;

	/**
	 * @inheritDoc
	 *
	 * @default true
	 */
	public var includeInLayout(get, set):Bool;
	public function get_includeInLayout():Bool
	{
		return this._includeInLayout;
	}

	/**
	 * @private
	 */
	public function set_includeInLayout(value:Bool):Bool
	{
		if(this._includeInLayout == value)
		{
			return;
		}
		this._includeInLayout = value;
		this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
	}

	/**
	 * @private
	 */
	private var _layoutData:ILayoutData;

	/**
	 * @inheritDoc
	 *
	 * @default null
	 */
	public var layoutData(get, set):ILayoutData;
	public function get_layoutData():ILayoutData
	{
		return this._layoutData;
	}

	/**
	 * @private
	 */
	public function set_layoutData(value:ILayoutData):ILayoutData
	{
		if(this._layoutData == value)
		{
			return;
		}
		if(this._layoutData)
		{
			this._layoutData.removeEventListener(Event.CHANGE, layoutData_changeHandler);
		}
		this._layoutData = value;
		if(this._layoutData)
		{
			this._layoutData.addEventListener(Event.CHANGE, layoutData_changeHandler);
		}
		this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
	}

	/**
	 * @private
	 */
	private var _focusManager:IFocusManager;

	/**
	 * @copy feathers.core.IFocusDisplayObject#focusManager
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * @default null
	 */
	public var focusManager(get, set):IFocusManager;
	public function get_focusManager():IFocusManager
	{
		return this._focusManager;
	}

	/**
	 * @private
	 */
	public function set_focusManager(value:IFocusManager):IFocusManager
	{
		if(!(this is IFocusDisplayObject))
		{
			throw new IllegalOperationError("Cannot pass a focus manager to a component that does not implement feathers.core.IFocusDisplayObject");
		}
		if(this._focusManager == value)
		{
			return;
		}
		this._focusManager = value;
		if(this._focusManager)
		{
			this.addEventListener(FeathersEventType.FOCUS_IN, focusInHandler);
			this.addEventListener(FeathersEventType.FOCUS_OUT, focusOutHandler);
		}
		else
		{
			this.removeEventListener(FeathersEventType.FOCUS_IN, focusInHandler);
			this.removeEventListener(FeathersEventType.FOCUS_OUT, focusOutHandler);
		}
	}

	/**
	 * @private
	 */
	private var _focusOwner:IFocusDisplayObject;

	/**
	 * @copy feathers.core.IFocusDisplayObject#focusOwner
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * @default null
	 */
	public var focusOwner(get, set):IFocusDisplayObject;
	public function get_focusOwner():IFocusDisplayObject
	{
		return this._focusOwner;
	}

	/**
	 * @private
	 */
	public function set_focusOwner(value:IFocusDisplayObject):IFocusDisplayObject
	{
		this._focusOwner = value;
	}

	/**
	 * @private
	 */
	private var _isFocusEnabled:Bool = true;

	/**
	 * @copy feathers.core.IFocusDisplayObject#isFocusEnabled
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * @default true
	 */
	public var isFocusEnabled(get, set):Bool;
	public function get_isFocusEnabled():Bool
	{
		return this._isEnabled && this._isFocusEnabled;
	}

	/**
	 * @private
	 */
	public function set_isFocusEnabled(value:Bool):Bool
	{
		if(!(this is IFocusDisplayObject))
		{
			throw new IllegalOperationError("Cannot enable focus on a component that does not implement feathers.core.IFocusDisplayObject");
		}
		if(this._isFocusEnabled == value)
		{
			return;
		}
		this._isFocusEnabled = value;
	}

	/**
	 * @private
	 */
	private var _nextTabFocus:IFocusDisplayObject;

	/**
	 * @copy feathers.core.IFocusDisplayObject#nextTabFocus
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * @default null
	 */
	public var nextTabFocus(get, set):IFocusDisplayObject;
	public function get_nextTabFocus():IFocusDisplayObject
	{
		return this._nextTabFocus;
	}

	/**
	 * @private
	 */
	public function set_nextTabFocus(value:IFocusDisplayObject):IFocusDisplayObject
	{
		if(!(this is IFocusDisplayObject))
		{
			throw new IllegalOperationError("Cannot set next tab focus on a component that does not implement feathers.core.IFocusDisplayObject");
		}
		this._nextTabFocus = value;
	}

	/**
	 * @private
	 */
	private var _previousTabFocus:IFocusDisplayObject;

	/**
	 * @copy feathers.core.IFocusDisplayObject#previousTabFocus
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * @default null
	 */
	public var previousTabFocus(get, set):IFocusDisplayObject;
	public function get_previousTabFocus():IFocusDisplayObject
	{
		return this._previousTabFocus;
	}

	/**
	 * @private
	 */
	public function set_previousTabFocus(value:IFocusDisplayObject):IFocusDisplayObject
	{
		if(!(this is IFocusDisplayObject))
		{
			throw new IllegalOperationError("Cannot set previous tab focus on a component that does not implement feathers.core.IFocusDisplayObject");
		}
		this._previousTabFocus = value;
	}

	/**
	 * @private
	 */
	private var _focusIndicatorSkin:DisplayObject;

	/**
	 * If this component supports focus, this optional skin will be
	 * displayed above the component when <code>showFocus()</code> is
	 * called. The focus indicator skin is not always displayed when the
	 * component has focus. Typically, if the component receives focus from
	 * a touch, the focus indicator is not displayed.
	 *
	 * <p>The <code>touchable</code> of this skin will always be set to
	 * <code>false</code> so that it does not "steal" touches from the
	 * component or its sub-components. This skin will not affect the
	 * dimensions of the component or its hit area. It is simply a visual
	 * indicator of focus.</p>
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * <p>In the following example, the focus indicator skin is set:</p>
	 *
	 * <listing version="3.0">
	 * control.focusIndicatorSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var focusIndicatorSkin(get, set):DisplayObject;
	public function get_focusIndicatorSkin():DisplayObject
	{
		return this._focusIndicatorSkin;
	}

	/**
	 * @private
	 */
	public function set_focusIndicatorSkin(value:DisplayObject):DisplayObject
	{
		if(!(this is IFocusDisplayObject))
		{
			throw new IllegalOperationError("Cannot set focus indicator skin on a component that does not implement feathers.core.IFocusDisplayObject");
		}
		if(this._focusIndicatorSkin == value)
		{
			return;
		}
		if(this._focusIndicatorSkin && this._focusIndicatorSkin.parent)
		{
			this._focusIndicatorSkin.removeFromParent(false);
		}
		this._focusIndicatorSkin = value;
		if(this._focusIndicatorSkin)
		{
			this._focusIndicatorSkin.touchable = false;
		}
		if(this._focusManager && this._focusManager.focus == this)
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}

	/**
	 * Quickly sets all focus padding properties to the same value. The
	 * <code>focusPadding</code> getter always returns the value of
	 * <code>focusPaddingTop</code>, but the other focus padding values may
	 * be different.
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * <p>The following example gives the button 2 pixels of focus padding
	 * on all sides:</p>
	 *
	 * <listing version="3.0">
	 * control.focusPadding = 2;</listing>
	 *
	 * @default 0
	 *
	 * @see #focusPaddingTop
	 * @see #focusPaddingRight
	 * @see #focusPaddingBottom
	 * @see #focusPaddingLeft
	 */
	public var focusPadding(get, set):Float;
	public function get_focusPadding():Float
	{
		return this._focusPaddingTop;
	}

	/**
	 * @private
	 */
	public function set_focusPadding(value:Float):Float
	{
		this.focusPaddingTop = value;
		this.focusPaddingRight = value;
		this.focusPaddingBottom = value;
		this.focusPaddingLeft = value;
	}

	/**
	 * @private
	 */
	private var _focusPaddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the object's top edge and the
	 * top edge of the focus indicator skin. A negative value may be used
	 * to expand the focus indicator skin outside the bounds of the object.
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * <p>The following example gives the focus indicator skin -2 pixels of
	 * padding on the top edge only:</p>
	 *
	 * <listing version="3.0">
	 * control.focusPaddingTop = -2;</listing>
	 *
	 * @default 0
	 */
	public var focusPaddingTop(get, set):Float;
	public function get_focusPaddingTop():Float
	{
		return this._focusPaddingTop;
	}

	/**
	 * @private
	 */
	public function set_focusPaddingTop(value:Float):Float
	{
		if(this._focusPaddingTop == value)
		{
			return;
		}
		this._focusPaddingTop = value;
		this.invalidate(INVALIDATION_FLAG_FOCUS);
	}

	/**
	 * @private
	 */
	private var _focusPaddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the object's right edge and the
	 * right edge of the focus indicator skin. A negative value may be used
	 * to expand the focus indicator skin outside the bounds of the object.
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * <p>The following example gives the focus indicator skin -2 pixels of
	 * padding on the right edge only:</p>
	 *
	 * <listing version="3.0">
	 * control.focusPaddingRight = -2;</listing>
	 *
	 * @default 0
	 */
	public var focusPaddingRight(get, set):Float;
	public function get_focusPaddingRight():Float
	{
		return this._focusPaddingRight;
	}

	/**
	 * @private
	 */
	public function set_focusPaddingRight(value:Float):Float
	{
		if(this._focusPaddingRight == value)
		{
			return;
		}
		this._focusPaddingRight = value;
		this.invalidate(INVALIDATION_FLAG_FOCUS);
	}

	/**
	 * @private
	 */
	private var _focusPaddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the object's bottom edge and the
	 * bottom edge of the focus indicator skin. A negative value may be used
	 * to expand the focus indicator skin outside the bounds of the object.
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * <p>The following example gives the focus indicator skin -2 pixels of
	 * padding on the bottom edge only:</p>
	 *
	 * <listing version="3.0">
	 * control.focusPaddingBottom = -2;</listing>
	 *
	 * @default 0
	 */
	public var focusPaddingBottom(get, set):Float;
	public function get_focusPaddingBottom():Float
	{
		return this._focusPaddingBottom;
	}

	/**
	 * @private
	 */
	public function set_focusPaddingBottom(value:Float):Float
	{
		if(this._focusPaddingBottom == value)
		{
			return;
		}
		this._focusPaddingBottom = value;
		this.invalidate(INVALIDATION_FLAG_FOCUS);
	}

	/**
	 * @private
	 */
	private var _focusPaddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the object's left edge and the
	 * left edge of the focus indicator skin. A negative value may be used
	 * to expand the focus indicator skin outside the bounds of the object.
	 *
	 * <p>The implementation of this property is provided for convenience,
	 * but it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 *
	 * <p>The following example gives the focus indicator skin -2 pixels of
	 * padding on the right edge only:</p>
	 *
	 * <listing version="3.0">
	 * control.focusPaddingLeft = -2;</listing>
	 *
	 * @default 0
	 */
	public var focusPaddingLeft(get, set):Float;
	public function get_focusPaddingLeft():Float
	{
		return this._focusPaddingLeft;
	}

	/**
	 * @private
	 */
	public function set_focusPaddingLeft(value:Float):Float
	{
		if(this._focusPaddingLeft == value)
		{
			return;
		}
		this._focusPaddingLeft = value;
		this.invalidate(INVALIDATION_FLAG_FOCUS);
	}

	/**
	 * @private
	 */
	private var _hasFocus:Bool = false;

	/**
	 * @private
	 */
	private var _showFocus:Bool = false;

	/**
	 * @private
	 * Flag to indicate that the control is currently validating.
	 */
	private var _isValidating:Bool = false;

	/**
	 * @private
	 * Flag to indicate that the control has validated at least once.
	 */
	private var _hasValidated:Bool = false;

	/**
	 * Determines if the component has been initialized and validated for
	 * the first time.
	 *
	 * <p>In the following example, we check if the component is created or
	 * not, and we listen for an event if it isn't:</p>
	 *
	 * <listing version="3.0">
	 * if( !control.isCreated )
	 * {
	 *     control.addEventListener( FeathersEventType.CREATION_COMPLETE, creationCompleteHandler );
	 * }</listing>
	 *
	 * @see #event:creationComplete
	 * @see #isInitialized
	 */
	public var isCreated(get, set):Bool;
	public function get_isCreated():Bool
	{
		return this._hasValidated;
	}

	/**
	 * @private
	 */
	private var _depth:Int = -1;

	/**
	 * @copy feathers.core.IValidating#depth
	 */
	public var depth(get, set):Int;
	public function get_depth():Int
	{
		return this._depth;
	}

	/**
	 * @private
	 */
	private var _invalidateCount:Int = 0;

	/**
	 * @private
	 */
	override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
	{
		if(!resultRect)
		{
			resultRect = new Rectangle();
		}

		var minX:Float = Float.MAX_VALUE, maxX:Float = -Float.MAX_VALUE;
		var minY:Float = Float.MAX_VALUE, maxY:Float = -Float.MAX_VALUE;

		if (targetSpace == this) // optimization
		{
			minX = 0;
			minY = 0;
			maxX = this.actualWidth;
			maxY = this.actualHeight;
		}
		else
		{
			this.getTransformationMatrix(targetSpace, HELPER_MATRIX);

			MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
			minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
			maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
			minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
			maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

			MatrixUtil.transformCoords(HELPER_MATRIX, 0, this.actualHeight, HELPER_POINT);
			minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
			maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
			minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
			maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

			MatrixUtil.transformCoords(HELPER_MATRIX, this.actualWidth, 0, HELPER_POINT);
			minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
			maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
			minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
			maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

			MatrixUtil.transformCoords(HELPER_MATRIX, this.actualWidth, this.actualHeight, HELPER_POINT);
			minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
			maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
			minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
			maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;
		}

		resultRect.x = minX;
		resultRect.y = minY;
		resultRect.width  = maxX - minX;
		resultRect.height = maxY - minY;

		return resultRect;
	}

	/**
	 * @private
	 */
	override public function hitTest(localPoint:Point, forTouch:Bool=false):DisplayObject
	{
		if(this._isQuickHitAreaEnabled)
		{
			if(forTouch && (!this.visible || !this.touchable))
			{
				return null;
			}
			var clipRect:Rectangle = this.clipRect;
			if(clipRect && !clipRect.containsPoint(localPoint))
			{
				return null;
			}
			return this._hitArea.containsPoint(localPoint) ? this : null;
		}
		return super.hitTest(localPoint, forTouch);
	}

	/**
	 * @private
	 */
	private var _isDisposed:Bool = false;

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		this._isDisposed = true;
		this._validationQueue = null;
		super.dispose();
	}

	/**
	 * Call this function to tell the UI control that a redraw is pending.
	 * The redraw will happen immediately before Starling renders the UI
	 * control to the screen. The validation system exists to ensure that
	 * multiple properties can be set together without redrawing multiple
	 * times in between each property change.
	 * 
	 * <p>If you cannot wait until later for the validation to happen, you
	 * can call <code>validate()</code> to redraw immediately. As an example,
	 * you might want to validate immediately if you need to access the
	 * correct <code>width</code> or <code>height</code> values of the UI
	 * control, since these values are calculated during validation.</p>
	 * 
	 * @see feathers.core.FeathersControl#validate()
	 */
	public function invalidate(flag:String = INVALIDATION_FLAG_ALL):Void
	{
		var isAlreadyInvalid:Bool = this.isInvalid();
		var isAlreadyDelayedInvalid:Bool = false;
		if(this._isValidating)
		{
			for(var otherFlag:String in this._delayedInvalidationFlags)
			{
				isAlreadyDelayedInvalid = true;
				break;
			}
		}
		if(!flag || flag == INVALIDATION_FLAG_ALL)
		{
			if(this._isValidating)
			{
				this._delayedInvalidationFlags[INVALIDATION_FLAG_ALL] = true;
			}
			else
			{
				this._isAllInvalid = true;
			}
		}
		else
		{
			if(this._isValidating)
			{
				this._delayedInvalidationFlags[flag] = true;
			}
			else if(flag != INVALIDATION_FLAG_ALL && !this._invalidationFlags.hasOwnProperty(flag))
			{
				this._invalidationFlags[flag] = true;
			}
		}
		if(!this._validationQueue || !this._isInitialized)
		{
			//we'll add this component to the queue later, after it has been
			//added to the stage.
			return;
		}
		if(this._isValidating)
		{
			if(isAlreadyDelayedInvalid)
			{
				return;
			}
			this._invalidateCount++;
			this._validationQueue.addControl(this, this._invalidateCount >= 10);
			return;
		}
		if(isAlreadyInvalid)
		{
			return;
		}
		this._invalidateCount = 0;
		this._validationQueue.addControl(this, false);
	}

	/**
	 * @copy feathers.core.IValidating#validate()
	 *
	 * <p>Additionally, a Feathers component cannot validate until it
	 * initializes. A component initializes after it has been added to the
	 * stage. If the component has been added to its parent before the
	 * parent has access to the stage, the component may not initialize
	 * until after its parent's <code>Event.ADDED_TO_STAGE</code> has been
	 * dispatched to all listeners.</p>
	 * 
	 * @see #invalidate()
	 * @see #initialize()
	 * @see #event:initialize feathers.events.FeathersEventType.INITIALIZE
	 */
	public function validate():Void
	{
		if(this._isDisposed)
		{
			//disposed components have no reason to validate, but they may
			//have been left in the queue.
			return;
		}
		if(!this._isInitialized)
		{
			this.initializeInternal();
		}
		if(!this.isInvalid())
		{
			return;
		}
		if(this._isValidating)
		{
			//we were already validating, and something else told us to
			//validate. that's bad...
			if(this._validationQueue)
			{
				//...so we'll just try to do it later
				this._validationQueue.addControl(this, true);
			}
			return;
		}
		this._isValidating = true;
		this.draw();
		for(var flag:String in this._invalidationFlags)
		{
			delete this._invalidationFlags[flag];
		}
		this._isAllInvalid = false;
		for(flag in this._delayedInvalidationFlags)
		{
			if(flag == INVALIDATION_FLAG_ALL)
			{
				this._isAllInvalid = true;
			}
			else
			{
				this._invalidationFlags[flag] = true;
			}
			delete this._delayedInvalidationFlags[flag];
		}
		this._isValidating = false;
		if(!this._hasValidated)
		{
			this._hasValidated = true;
			this.dispatchEventWith(FeathersEventType.CREATION_COMPLETE);
		}
	}

	/**
	 * Indicates whether the control is pending validation or not. By
	 * default, returns <code>true</code> if any invalidation flag has been
	 * set. If you pass in a specific flag, returns <code>true</code> only
	 * if that flag has been set (others may be set too, but it checks the
	 * specific flag only. If all flags have been marked as invalid, always
	 * returns <code>true</code>.
	 */
	public function isInvalid(flag:String = null):Bool
	{
		if(this._isAllInvalid)
		{
			return true;
		}
		if(!flag) //return true if any flag is set
		{
			for(flag in this._invalidationFlags)
			{
				return true;
			}
			return false;
		}
		return this._invalidationFlags[flag];
	}

	/**
	 * Sets both the width and the height of the control.
	 */
	public function setSize(width:Float, height:Float):Void
	{
		this.explicitWidth = width;
		var widthIsNaN:Bool = width != width;
		if(widthIsNaN)
		{
			this.actualWidth = this.scaledActualWidth = 0;
		}
		this.explicitHeight = height;
		var heightIsNaN:Bool = height != height;
		if(heightIsNaN)
		{
			this.actualHeight = this.scaledActualHeight = 0;
		}

		if(widthIsNaN || heightIsNaN)
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		else
		{
			this.setSizeInternal(width, height, true);
		}
	}

	/**
	 * @copy feathers.core.IFocusDisplayObject#showFocus()
	 *
	 * <p>The implementation of this method is provided for convenience, but
	 * it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 */
	public function showFocus():Void
	{
		if(!this._hasFocus || !this._focusIndicatorSkin)
		{
			return;
		}

		this._showFocus = true;
		this.invalidate(INVALIDATION_FLAG_FOCUS);
	}

	/**
	 * @copy feathers.core.IFocusDisplayObject#hideFocus()
	 *
	 * <p>The implementation of this method is provided for convenience, but
	 * it cannot be used unless a subclass implements the
	 * <code>IFocusDisplayObject</code> interface.</p>
	 */
	public function hideFocus():Void
	{
		if(!this._hasFocus || !this._focusIndicatorSkin)
		{
			return;
		}

		this._showFocus = false;
		this.invalidate(INVALIDATION_FLAG_FOCUS);
	}

	/**
	 * Sets the width and height of the control, with the option of
	 * invalidating or not. Intended to be used when the <code>width</code>
	 * and <code>height</code> values have not been set explicitly, and the
	 * UI control needs to measure itself and choose an "ideal" size.
	 */
	private function setSizeInternal(width:Float, height:Float, canInvalidate:Bool):Bool
	{
		if(this.explicitWidth == this.explicitWidth) //!isNaN
		{
			width = this.explicitWidth;
		}
		else
		{
			if(width < this._minWidth)
			{
				width = this._minWidth;
			}
			else if(width > this._maxWidth)
			{
				width = this._maxWidth;
			}
		}
		if(this.explicitHeight == this.explicitHeight) //!isNaN
		{
			height = this.explicitHeight;
		}
		else
		{
			if(height < this._minHeight)
			{
				height = this._minHeight;
			}
			else if(height > this._maxHeight)
			{
				height = this._maxHeight;
			}
		}
		if(width != width) //isNaN
		{
			throw new ArgumentError(ILLEGAL_WIDTH_ERROR);
		}
		if(height != height) //isNaN
		{
			throw new ArgumentError(ILLEGAL_HEIGHT_ERROR);
		}
		var resized:Bool = false;
		if(this.actualWidth != width)
		{
			this.actualWidth = width;
			this.refreshHitAreaX();
			resized = true;
		}
		if(this.actualHeight != height)
		{
			this.actualHeight = height;
			this.refreshHitAreaY();
			resized = true;
		}
		width = this.scaledActualWidth;
		height = this.scaledActualHeight;
		this.scaledActualWidth = this.actualWidth * Math.abs(this.scaleX);
		this.scaledActualHeight = this.actualHeight * Math.abs(this.scaleY);
		if(width != this.scaledActualWidth || height != this.scaledActualHeight)
		{
			resized = true;
		}
		if(resized)
		{
			if(canInvalidate)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			this.dispatchEventWith(FeathersEventType.RESIZE);
		}
		return resized;
	}

	/**
	 * Called the first time that the UI control is added to the stage, and
	 * you should override this function to customize the initialization
	 * process. Do things like create children and set up event listeners.
	 * After this function is called, <code>FeathersEventType.INITIALIZE</code>
	 * is dispatched.
	 *
	 * @see #event:initialize feathers.events.FeathersEventType.INITIALIZE
	 */
	private function initialize():Void
	{

	}

	/**
	 * Override to customize layout and to adjust properties of children.
	 * Called when the component validates, if any flags have been marked
	 * to indicate that validation is pending.
	 */
	private function draw():Void
	{

	}

	/**
	 * Sets an invalidation flag. This will not add the component to the
	 * validation queue. It only sets the flag. A subclass might use
	 * this function during <code>draw()</code> to manipulate the flags that
	 * its superclass sees.
	 */
	private function setInvalidationFlag(flag:String):Void
	{
		if(this._invalidationFlags.hasOwnProperty(flag))
		{
			return;
		}
		this._invalidationFlags[flag] = true;
	}

	/**
	 * Clears an invalidation flag. This will not remove the component from
	 * the validation queue. It only clears the flag. A subclass might use
	 * this function during <code>draw()</code> to manipulate the flags that
	 * its superclass sees.
	 */
	private function clearInvalidationFlag(flag:String):Void
	{
		delete this._invalidationFlags[flag];
	}

	/**
	 * Updates the focus indicator skin by showing or hiding it and
	 * adjusting its position and dimensions. This function is not called
	 * automatically. Components that support focus should call this
	 * function at an appropriate point within the <code>draw()</code>
	 * function. This function may be overridden if the default behavior is
	 * not desired.
	 */
	private function refreshFocusIndicator():Void
	{
		if(this._focusIndicatorSkin)
		{
			if(this._hasFocus && this._showFocus)
			{
				if(this._focusIndicatorSkin.parent != this)
				{
					this.addChild(this._focusIndicatorSkin);
				}
				else
				{
					this.setChildIndex(this._focusIndicatorSkin, this.numChildren - 1);
				}
			}
			else if(this._focusIndicatorSkin.parent)
			{
				this._focusIndicatorSkin.removeFromParent(false);
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
	private function refreshHitAreaX():Void
	{
		if(this.actualWidth < this._minTouchWidth)
		{
			this._hitArea.width = this._minTouchWidth;
		}
		else
		{
			this._hitArea.width = this.actualWidth;
		}
		var hitAreaX:Float = (this.actualWidth - this._hitArea.width) / 2;
		if(hitAreaX != hitAreaX) //isNaN
		{
			this._hitArea.x = 0;
		}
		else
		{
			this._hitArea.x = hitAreaX;
		}
	}

	/**
	 * @private
	 */
	private function refreshHitAreaY():Void
	{
		if(this.actualHeight < this._minTouchHeight)
		{
			this._hitArea.height = this._minTouchHeight;
		}
		else
		{
			this._hitArea.height = this.actualHeight;
		}
		var hitAreaY:Float = (this.actualHeight - this._hitArea.height) / 2;
		if(hitAreaY != hitAreaY) //isNaN
		{
			this._hitArea.y = 0;
		}
		else
		{
			this._hitArea.y = hitAreaY;
		}
	}

	/**
	 * @private
	 */
	private function initializeInternal():Void
	{
		if(this._isInitialized)
		{
			return;
		}
		this.initialize();
		this.invalidate(); //invalidate everything
		this._isInitialized = true;
		this.dispatchEventWith(FeathersEventType.INITIALIZE);

		if(this._styleProvider)
		{
			this._styleProvider.applyStyles(this);
		}
	}

	/**
	 * Default event handler for <code>FeathersEventType.FOCUS_IN</code>
	 * that may be overridden in subclasses to perform additional actions
	 * when the component receives focus.
	 */
	private function focusInHandler(event:Event):Void
	{
		this._hasFocus = true;
		this.invalidate(INVALIDATION_FLAG_FOCUS);
	}

	/**
	 * Default event handler for <code>FeathersEventType.FOCUS_OUT</code>
	 * that may be overridden in subclasses to perform additional actions
	 * when the component loses focus.
	 */
	private function focusOutHandler(event:Event):Void
	{
		this._hasFocus = false;
		this._showFocus = false;
		this.invalidate(INVALIDATION_FLAG_FOCUS);
	}

	/**
	 * @private
	 */
	private function feathersControl_flattenHandler(event:Event):Void
	{
		if(!this.stage || !this._isInitialized)
		{
			throw new IllegalOperationError("Cannot flatten this component until it is initialized and has access to the stage.");
		}
		this.validate();
	}

	/**
	 * @private
	 * Initialize the control, if it hasn't been initialized yet. Then,
	 * invalidate. If already initialized, check if invalid and put back
	 * into queue.
	 */
	private function feathersControl_addedToStageHandler(event:Event):Void
	{
		this._depth = getDisplayObjectDepthFromStage(this);
		this._validationQueue = ValidationQueue.forStarling(Starling.current);
		if(!this._isInitialized)
		{
			this.initializeInternal();
		}
		if(this.isInvalid())
		{
			this._invalidateCount = 0;
			//add to validation queue, if required
			this._validationQueue.addControl(this, false);
		}
	}

	/**
	 * @private
	 */
	private function feathersControl_removedFromStageHandler(event:Event):Void
	{
		this._depth = -1;
		this._validationQueue = null;
	}

	/**
	 * @private
	 */
	private function layoutData_changeHandler(event:Event):Void
	{
		this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
	}
}