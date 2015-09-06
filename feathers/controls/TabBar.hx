/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.PropertyProxy;
import feathers.core.ToggleGroup;
import feathers.data.ListCollection;
import feathers.events.CollectionEventType;
import feathers.layout.HorizontalLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.VerticalLayout;
import feathers.layout.ViewPortBounds;
import feathers.skins.IStyleProvider;

import starling.display.DisplayObject;
import starling.events.Event;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SELECTED;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STATE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;

/**
 * Dispatched when the selected tab changes.
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
 */
#if 0
[Event(name="change",type="starling.events.Event")]
#end

/**
 * A line of tabs (vertical or horizontal), where one may be selected at a
 * time.
 *
 * <p>The following example sets the data provider, selects the second tab,
 * and listens for when the selection changes:</p>
 *
 * <listing version="3.0">
 * var tabs:TabBar = new TabBar();
 * tabs.dataProvider = new ListCollection(
 * [
 *     { label: "One" },
 *     { label: "Two" },
 *     { label: "Three" },
 * ]);
 * tabs.selectedIndex = 1;
 * tabs.addEventListener( Event.CHANGE, tabs_changeHandler );
 * this.addChild( tabs );</listing>
 *
 * @see ../../../help/tab-bar.html How to use the Feathers TabBar component
 */
class TabBar extends FeathersControl
{
	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_TAB_FACTORY:String = "tabFactory";

	/**
	 * @private
	 */
	private static var DEFAULT_TAB_FIELDS:Array<String> = 
	[
		"defaultIcon",
		"upIcon",
		"downIcon",
		"hoverIcon",
		"disabledIcon",
		"defaultSelectedIcon",
		"selectedUpIcon",
		"selectedDownIcon",
		"selectedHoverIcon",
		"selectedDisabledIcon",
		"isEnabled"
	];

	/**
	 * The tabs are displayed in order from left to right.
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * The tabs are displayed in order from top to bottom.
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_VERTICAL:String = "vertical";

	/**
	 * The tabs will be aligned horizontally to the left edge of the tab
	 * bar.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * The tabs will be aligned horizontally to the center of the tab bar.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * The tabs will be aligned horizontally to the right edge of the tab
	 * bar.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * If the direction is vertical, each tab will fill the entire width of
	 * the tab bar, and if the direction is horizontal, the alignment will
	 * behave the same as <code>HORIZONTAL_ALIGN_LEFT</code>.
	 *
	 * @see #horizontalAlign
	 * @see #direction
	 */
	inline public static var HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * The tabs will be aligned vertically to the top edge of the tab bar.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * The tabs will be aligned vertically to the middle of the tab bar.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * The tabs will be aligned vertically to the bottom edge of the tab
	 * bar.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * If the direction is horizontal, each tab will fill the entire height
	 * of the tab bar. If the direction is vertical, the alignment will
	 * behave the same as <code>VERTICAL_ALIGN_TOP</code>.
	 *
	 * @see #verticalAlign
	 * @see #direction
	 */
	inline public static var VERTICAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * The default value added to the <code>styleNameList</code> of the tabs.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_TAB:String = "feathers-tab-bar-tab";

	/**
	 * DEPRECATED: Replaced by <code>TabBar.DEFAULT_CHILD_STYLE_NAME_TAB</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see TabBar#DEFAULT_CHILD_STYLE_NAME_TAB
	 */
	inline public static var DEFAULT_CHILD_NAME_TAB:String = DEFAULT_CHILD_STYLE_NAME_TAB;

	/**
	 * The default <code>IStyleProvider</code> for all <code>TabBar</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * @private
	 */
	private static function defaultTabFactory():ToggleButton
	{
		return new ToggleButton();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		_tabInitializer = defaultTabInitializer;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the tabs. This
	 * variable is <code>protected</code> so that sub-classes can customize
	 * the tab style name in their constructors instead of using the default
	 * style name defined by <code>DEFAULT_CHILD_STYLE_NAME_TAB</code>.
	 *
	 * <p>To customize the tab style name without subclassing, see
	 * <code>customTabStyleName</code>.</p>
	 *
	 * @see #customTabStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var tabStyleName:String = DEFAULT_CHILD_STYLE_NAME_TAB;

	/**
	 * DEPRECATED: Replaced by <code>tabStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #tabStyleName
	 */
	private var tabName(get, set):String;
	private function get_tabName():String
	{
		return this.tabStyleName;
	}

	/**
	 * @private
	 */
	private function set_tabName(value:String):String
	{
		this.tabStyleName = value;
		return get_tabName();
	}

	/**
	 * The value added to the <code>styleNameList</code> of the first tab.
	 * This variable is <code>protected</code> so that sub-classes can
	 * customize the first tab style name in their constructors instead of
	 * using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_TAB</code>.
	 *
	 * <p>To customize the first tab name without subclassing, see
	 * <code>customFirstTabName</code>.</p>
	 *
	 * @see #customFirstTabName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var firstTabStyleName:String = DEFAULT_CHILD_STYLE_NAME_TAB;

	/**
	 * DEPRECATED: Replaced by <code>firstTabStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #firstTabStyleName
	 */
	private var firstTabName(get, set):String;
	private function get_firstTabName():String
	{
		return this.firstTabStyleName;
	}

	/**
	 * @private
	 */
	private function set_firstTabName(value:String):String
	{
		this.firstTabStyleName = value;
		return get_firstTabName();
	}

	/**
	 * The value added to the <code>styleNameList</code> of the last tab.
	 * This variable is <code>protected</code> so that sub-classes can
	 * customize the last tab style name in their constructors instead of
	 * using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_TAB</code>.
	 *
	 * <p>To customize the last tab name without subclassing, see
	 * <code>customLastTabName</code>.</p>
	 *
	 * @see #customLastTabName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var lastTabStyleName:String = DEFAULT_CHILD_STYLE_NAME_TAB;

	/**
	 * DEPRECATED: Replaced by <code>lastTabStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #lastTabStyleName
	 */
	private var lastTabName(get, set):String;
	private function get_lastTabName():String
	{
		return this.lastTabStyleName;
	}

	/**
	 * @private
	 */
	private function set_lastTabName(value:String):String
	{
		this.lastTabStyleName = value;
		return get_lastTabName();
	}

	/**
	 * The toggle group.
	 */
	private var toggleGroup:ToggleGroup;

	/**
	 * @private
	 */
	private var activeFirstTab:ToggleButton;

	/**
	 * @private
	 */
	private var inactiveFirstTab:ToggleButton;

	/**
	 * @private
	 */
	private var activeLastTab:ToggleButton;

	/**
	 * @private
	 */
	private var inactiveLastTab:ToggleButton;

	/**
	 * @private
	 */
	private var _layoutItems:Array<DisplayObject> = new Array<DisplayObject>();

	/**
	 * @private
	 */
	private var activeTabs:Array<ToggleButton> = new Array<ToggleButton>();

	/**
	 * @private
	 */
	private var inactiveTabs:Array<ToggleButton> = new Array<ToggleButton>();

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return TabBar.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _dataProvider:ListCollection;

	/**
	 * The collection of data to be displayed with tabs. The default
	 * <em>tab initializer</em> interprets this data to customize the tabs
	 * with various fields available to buttons, including the following:
	 *
	 * <ul>
	 *     <li>label</li>
	 *     <li>defaultIcon</li>
	 *     <li>upIcon</li>
	 *     <li>downIcon</li>
	 *     <li>hoverIcon</li>
	 *     <li>disabledIcon</li>
	 *     <li>defaultSelectedIcon</li>
	 *     <li>selectedUpIcon</li>
	 *     <li>selectedDownIcon</li>
	 *     <li>selectedHoverIcon</li>
	 *     <li>selectedDisabledIcon</li>
	 *     <li>isEnabled</li>
	 * </ul>
	 *
	 * <p>The following example passes in a data provider:</p>
	 *
	 * <listing version="3.0">
	 * list.dataProvider = new ListCollection(
	 * [
	 *     { label: "General", defaultIcon: new Image( generalTexture ) },
	 *     { label: "Security", defaultIcon: new Image( securityTexture ) },
	 *     { label: "Advanced", defaultIcon: new Image( advancedTexture ) },
	 * ]);</listing>
	 *
	 * @default null
	 *
	 * @see #tabInitializer
	 */
	public var dataProvider(get, set):ListCollection;
	public function get_dataProvider():ListCollection
	{
		return this._dataProvider;
	}

	/**
	 * @private
	 */
	public function set_dataProvider(value:ListCollection):ListCollection
	{
		if(this._dataProvider == value)
		{
			return get_dataProvider();
		}
		var oldSelectedIndex:Int = this.selectedIndex;
		var oldSelectedItem:Dynamic = this.selectedItem;
		if(this._dataProvider != null)
		{
			this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
			this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
			this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
			this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
			this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
		}
		this._dataProvider = value;
		if(this._dataProvider != null)
		{
			this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
			this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
			this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
			this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
			this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
		}
		if(this._dataProvider == null || this._dataProvider.length == 0)
		{
			this.selectedIndex = -1;
		}
		else
		{
			this.selectedIndex = 0;
		}
		//this ensures that Event.CHANGE will dispatch for selectedItem
		//changing, even if selectedIndex has not changed.
		if(this.selectedIndex == oldSelectedIndex && this.selectedItem != oldSelectedItem)
		{
			this.dispatchEventWith(Event.CHANGE);
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_dataProvider();
	}

	/**
	 * @private
	 */
	private var verticalLayout:VerticalLayout;

	/**
	 * @private
	 */
	private var horizontalLayout:HorizontalLayout;

	/**
	 * @private
	 */
	private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

	/**
	 * @private
	 */
	private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

	/**
	 * @private
	 */
	private var _direction:String = DIRECTION_HORIZONTAL;

	#if 0
	[Inspectable(type="String",enumeration="horizontal,vertical")]
	#end
	/**
	 * The tab bar layout is either vertical or horizontal.
	 *
	 * <p>In the following example, the tab bar's direction is set to
	 * vertical:</p>
	 *
	 * <listing version="3.0">
	 * tabs.direction = TabBar.DIRECTION_VERTICAL;</listing>
	 *
	 * @default TabBar.DIRECTION_HORIZONTAL
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_direction();
	}

	/**
	 * @private
	 */
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_JUSTIFY;

	#if 0
	[Inspectable(type="String",enumeration="left,center,right,justify")]
	#end
	/**
	 * Determines how the tabs are horizontally aligned within the bounds
	 * of the tab bar (on the x-axis).
	 *
	 * <p>The following example aligns the tabs to the left:</p>
	 *
	 * <listing version="3.0">
	 * tabs.horizontalAlign = TabBar.HORIZONTAL_ALIGN_LEFT;</listing>
	 *
	 * @default TabBar.HORIZONTAL_ALIGN_JUSTIFY
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 * @see #HORIZONTAL_ALIGN_JUSTIFY
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_horizontalAlign();
	}

	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_JUSTIFY;

	#if 0
	[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
	#end
	/**
	 * Determines how the tabs are vertically aligned within the bounds
	 * of the tab bar (on the y-axis).
	 *
	 * <p>The following example aligns the tabs to the top:</p>
	 *
	 * <listing version="3.0">
	 * tabs.verticalAlign = TabBar.VERTICAL_ALIGN_TOP;</listing>
	 *
	 * @default TabBar.VERTICAL_ALIGN_JUSTIFY
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #VERTICAL_ALIGN_JUSTIFY
	 */
	public var verticalAlign(get, set):String;
	public function get_verticalAlign():String
	{
		return this._verticalAlign;
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_verticalAlign();
	}

	/**
	 * @private
	 */
	private var _distributeTabSizes:Bool = true;

	/**
	 * If <code>true</code>, the tabs will be equally sized in the direction
	 * of the layout. In other words, if the tab bar is horizontal, each tab
	 * will have the same width, and if the tab bar is vertical, each tab
	 * will have the same height. If <code>false</code>, the tabs will be
	 * sized to their ideal dimensions.
	 *
	 * <p>The following example aligns the tabs to the middle without distributing them:</p>
	 *
	 * <listing version="3.0">
	 * tabs.direction = TabBar.DIRECTION_VERTICAL;
	 * tabs.verticalAlign = TabBar.VERTICAL_ALIGN_MIDDLE;
	 * tabs.distributeTabSizes = false;</listing>
	 *
	 * @default true
	 */
	public var distributeTabSizes(get, set):Bool;
	public function get_distributeTabSizes():Bool
	{
		return this._distributeTabSizes;
	}

	/**
	 * @private
	 */
	public function set_distributeTabSizes(value:Bool):Bool
	{
		if(this._distributeTabSizes == value)
		{
			return get_distributeTabSizes();
		}
		this._distributeTabSizes = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_distributeTabSizes();
	}

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * Space, in pixels, between tabs.
	 *
	 * <p>In the following example, the tab bar's gap is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * tabs.gap = 20;</listing>
	 *
	 * @default 0
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_gap();
	}

	/**
	 * @private
	 */
	private var _firstGap:Float = Math.NaN;

	/**
	 * Space, in pixels, between the first two tabs. If <code>NaN</code>,
	 * the default <code>gap</code> property will be used.
	 *
	 * <p>The following example sets the gap between the first and second
	 * tab to a different value than the standard gap:</p>
	 *
	 * <listing version="3.0">
	 * tabs.firstGap = 30;
	 * tabs.gap = 20;</listing>
	 *
	 * @default NaN
	 *
	 * @see #gap
	 * @see #lastGap
	 */
	public var firstGap(get, set):Float;
	public function get_firstGap():Float
	{
		return this._firstGap;
	}

	/**
	 * @private
	 */
	public function set_firstGap(value:Float):Float
	{
		if(this._firstGap == value)
		{
			return get_firstGap();
		}
		this._firstGap = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_firstGap();
	}

	/**
	 * @private
	 */
	private var _lastGap:Float = Math.NaN;

	/**
	 * Space, in pixels, between the last two tabs. If <code>NaN</code>,
	 * the default <code>gap</code> property will be used.
	 *
	 * <p>The following example sets the gap between the last and next to last
	 * tab to a different value than the standard gap:</p>
	 *
	 * <listing version="3.0">
	 * tabs.lastGap = 30;
	 * tabs.gap = 20;</listing>
	 *
	 * @default NaN
	 *
	 * @see #gap
	 * @see #firstGap
	 */
	public var lastGap(get, set):Float;
	public function get_lastGap():Float
	{
		return this._lastGap;
	}

	/**
	 * @private
	 */
	public function set_lastGap(value:Float):Float
	{
		if(this._lastGap == value)
		{
			return get_lastGap();
		}
		this._lastGap = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_lastGap();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding of all sides of the tab bar
	 * is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * tabs.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the tab bar's top edge and the
	 * tabs.
	 *
	 * <p>In the following example, the padding on the top edge of the
	 * tab bar is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * tabs.paddingTop = 20;</listing>
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the tab bar's right edge and
	 * the tabs.
	 *
	 * <p>In the following example, the padding on the right edge of the
	 * tab bar is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * tabs.paddingRight = 20;</listing>
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the tab bar's bottom edge and
	 * the tabs.
	 *
	 * <p>In the following example, the padding on the bottom edge of the
	 * tab bar is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * tabs.paddingBottom = 20;</listing>
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the tab bar's left edge and the
	 * tabs.
	 *
	 * <p>In the following example, the padding on the left edge of the
	 * tab bar is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * tabs.paddingLeft = 20;</listing>
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
	}

	/**
	 * @private
	 */
	private var _tabFactory:Void->ToggleButton = defaultTabFactory;

	/**
	 * Creates a new tab. A tab must be an instance of <code>ToggleButton</code>.
	 * This factory can be used to change properties on the tabs when they
	 * are first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on a tab.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():ToggleButton</pre>
	 *
	 * <p>In the following example, a custom tab factory is passed to the
	 * tab bar:</p>
	 *
	 * <listing version="3.0">
	 * tabs.tabFactory = function():ToggleButton
	 * {
	 *     var tab:ToggleButton = new ToggleButton();
	 *     tab.defaultSkin = new Image( upTexture );
	 *     tab.defaultSelectedSkin = new Image( selectedTexture );
	 *     tab.downSkin = new Image( downTexture );
	 *     return tab;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.ToggleButton
	 * @see #firstTabFactory
	 * @see #lastTabFactory
	 */
	public var tabFactory(get, set):Void->ToggleButton;
	public function get_tabFactory():Void->ToggleButton
	{
		return this._tabFactory;
	}

	/**
	 * @private
	 */
	public function set_tabFactory(value:Void->ToggleButton):Void->ToggleButton
	{
		if(this._tabFactory == value)
		{
			return get_tabFactory();
		}
		this._tabFactory = value;
		this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		return get_tabFactory();
	}

	/**
	 * @private
	 */
	private var _firstTabFactory:Void->ToggleButton;

	/**
	 * Creates a new first tab. If the <code>firstTabFactory</code> is
	 * <code>null</code>, then the tab bar will use the <code>tabFactory</code>.
	 * The first tab must be an instance of <code>ToggleButton</code>. This
	 * factory can be used to change properties on the first tab when it
	 * is first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on the first tab.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():ToggleButton</pre>
	 *
	 * <p>In the following example, a custom first tab factory is passed to the
	 * tab bar:</p>
	 *
	 * <listing version="3.0">
	 * tabs.firstTabFactory = function():ToggleButton
	 * {
	 *     var tab:ToggleButton = new ToggleButton();
	 *     tab.defaultSkin = new Image( upTexture );
	 *     tab.defaultSelectedSkin = new Image( selectedTexture );
	 *     tab.downSkin = new Image( downTexture );
	 *     return tab;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.ToggleButton
	 * @see #tabFactory
	 * @see #lastTabFactory
	 */
	public var firstTabFactory(get, set):Void->ToggleButton;
	public function get_firstTabFactory():Void->ToggleButton
	{
		return this._firstTabFactory;
	}

	/**
	 * @private
	 */
	public function set_firstTabFactory(value:Void->ToggleButton):Void->ToggleButton
	{
		if(this._firstTabFactory == value)
		{
			return get_firstTabFactory();
		}
		this._firstTabFactory = value;
		this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		return get_firstTabFactory();
	}

	/**
	 * @private
	 */
	private var _lastTabFactory:Void->ToggleButton;

	/**
	 * Creates a new last tab. If the <code>lastTabFactory</code> is
	 * <code>null</code>, then the tab bar will use the <code>tabFactory</code>.
	 * The last tab must be an instance of <code>Button</code>. This
	 * factory can be used to change properties on the last tab when it
	 * is first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on the last tab.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():ToggleButton</pre>
	 *
	 * <p>In the following example, a custom last tab factory is passed to the
	 * tab bar:</p>
	 *
	 * <listing version="3.0">
	 * tabs.lastTabFactory = function():ToggleButton
	 * {
	 *     var tab:ToggleButton = new Button();
	 *     tab.defaultSkin = new Image( upTexture );
	 *     tab.defaultSelectedSkin = new Image( selectedTexture );
	 *     tab.downSkin = new Image( downTexture );
	 *     return tab;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.ToggleButton
	 * @see #tabFactory
	 * @see #firstTabFactory
	 */
	public var lastTabFactory(get, set):Void->ToggleButton;
	public function get_lastTabFactory():Void->ToggleButton
	{
		return this._lastTabFactory;
	}

	/**
	 * @private
	 */
	public function set_lastTabFactory(value:Void->ToggleButton):Void->ToggleButton
	{
		if(this._lastTabFactory == value)
		{
			return get_lastTabFactory();
		}
		this._lastTabFactory = value;
		this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		return get_lastTabFactory();
	}

	/**
	 * @private
	 */
	private var _tabInitializer:ToggleButton->Dynamic->Void/* = defaultTabInitializer*/;

	/**
	 * Modifies the properties of an individual tab, using an item from the
	 * data provider. The default initializer will set the tab's label and
	 * icons. A custom tab initializer can be provided to update additional
	 * properties or to use different field names in the data provider.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 * <pre>function( tab:ToggleButton, item:Object ):void</pre>
	 *
	 * <p>In the following example, a custom tab initializer is passed to the
	 * tab bar:</p>
	 *
	 * <listing version="3.0">
	 * tabs.tabInitializer = function( tab:ToggleButton, item:Object ):void
	 * {
	 *     tab.label = item.text;
	 *     tab.defaultIcon = item.icon;
	 * };</listing>
	 *
	 * @see #dataProvider
	 */
	public var tabInitializer(get, set):ToggleButton->Dynamic->Void;
	public function get_tabInitializer():ToggleButton->Dynamic->Void
	{
		return this._tabInitializer;
	}

	/**
	 * @private
	 */
	public function set_tabInitializer(value:ToggleButton->Dynamic->Void):ToggleButton->Dynamic->Void
	{
		if(this._tabInitializer == value)
		{
			return get_tabInitializer();
		}
		this._tabInitializer = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_tabInitializer();
	}

	/**
	 * @private
	 */
	private var _ignoreSelectionChanges:Bool = false;

	/**
	 * @private
	 */
	private var _selectedIndex:Int = -1;

	/**
	 * The index of the currently selected tab. Returns -1 if no tab is
	 * selected.
	 *
	 * <p>In the following example, the tab bar's selected index is changed:</p>
	 *
	 * <listing version="3.0">
	 * tabs.selectedIndex = 2;</listing>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected index:</p>
	 *
	 * <listing version="3.0">
	 * function tabs_changeHandler( event:Event ):void
	 * {
	 *     var tabs:TabBar = TabBar( event.currentTarget );
	 *     var index:int = tabs.selectedIndex;
	 *
	 * }
	 * tabs.addEventListener( Event.CHANGE, tabs_changeHandler );</listing>
	 *
	 * @default -1
	 *
	 * @see #selectedItem
	 */
	public var selectedIndex(get, set):Int;
	public function get_selectedIndex():Int
	{
		return this._selectedIndex;
	}

	/**
	 * @private
	 */
	public function set_selectedIndex(value:Int):Int
	{
		if(this._selectedIndex == value)
		{
			return get_selectedIndex();
		}
		this._selectedIndex = value;
		this.invalidate(INVALIDATION_FLAG_SELECTED);
		this.dispatchEventWith(Event.CHANGE);
		return get_selectedIndex();
	}

	/**
	 * The currently selected item from the data provider. Returns
	 * <code>null</code> if no item is selected.
	 *
	 * <p>In the following example, the tab bar's selected item is changed:</p>
	 *
	 * <listing version="3.0">
	 * tabs.selectedItem = tabs.dataProvider.getItemAt(2);</listing>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected item:</p>
	 *
	 * <listing version="3.0">
	 * function tabs_changeHandler( event:Event ):void
	 * {
	 *     var tabs:TabBar = TabBar( event.currentTarget );
	 *     var item:Object = tabs.selectedItem;
	 *
	 * }
	 * tabs.addEventListener( Event.CHANGE, tabs_changeHandler );</listing>
	 *
	 * @default null
	 *
	 * @see #selectedIndex
	 */
	public var selectedItem(get, set):Dynamic;
	public function get_selectedItem():Dynamic
	{
		var index:Int = this.selectedIndex;
		if(this._dataProvider == null || index < 0 || index >= this._dataProvider.length)
		{
			return null;
		}
		return this._dataProvider.getItemAt(index);
	}

	/**
	 * @private
	 */
	public function set_selectedItem(value:Dynamic):Dynamic
	{
		if(this._dataProvider == null)
		{
			this.selectedIndex = -1;
			return get_selectedItem();
		}
		this.selectedIndex = this._dataProvider.getItemIndex(value);
		return get_selectedItem();
	}

	/**
	 * @private
	 */
	private var _customTabStyleName:String;

	/**
	 * A style name to add to all tabs in this tab bar. Typically used by a
	 * theme to provide different styles to different tab bars.
	 *
	 * <p>In the following example, a custom tab style name is provided to
	 * the tab bar:</p>
	 *
	 * <listing version="3.0">
	 * tabs.customTabStyleName = "my-custom-tab";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( "my-custom-tab", setCustomTabStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_TAB
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var customTabStyleName(get, set):String;
	public function get_customTabStyleName():String
	{
		return this._customTabStyleName;
	}

	/**
	 * @private
	 */
	public function set_customTabStyleName(value:String):String
	{
		if(this._customTabStyleName == value)
		{
			return get_customTabStyleName();
		}
		this._customTabStyleName = value;
		this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		return get_customTabStyleName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customTabStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customTabStyleName
	 */
	public var customTabName(get, set):String;
	public function get_customTabName():String
	{
		return this.customTabStyleName;
	}

	/**
	 * @private
	 */
	public function set_customTabName(value:String):String
	{
		this.customTabStyleName = value;
		return get_customTabName();
	}

	/**
	 * @private
	 */
	private var _customFirstTabStyleName:String;

	/**
	 * A style name to add to the first tab in this tab bar. Typically used
	 * by a theme to provide different styles to the first tab.
	 *
	 * <p>In the following example, a custom first tab style name is
	 * provided to the tab bar:</p>
	 *
	 * <listing version="3.0">
	 * tabs.customFirstTabStyleName = "my-custom-first-tab";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( "my-custom-first-tab", setCustomFirstTabStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var customFirstTabStyleName(get, set):String;
	public function get_customFirstTabStyleName():String
	{
		return this._customFirstTabStyleName;
	}

	/**
	 * @private
	 */
	public function set_customFirstTabStyleName(value:String):String
	{
		if(this._customFirstTabStyleName == value)
		{
			return get_customFirstTabStyleName();
		}
		this._customFirstTabStyleName = value;
		this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		return get_customFirstTabStyleName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customFirstTabStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customFirstTabStyleName
	 */
	public var customFirstTabName(get, set):String;
	public function get_customFirstTabName():String
	{
		return this.customFirstTabStyleName;
	}

	/**
	 * @private
	 */
	public function set_customFirstTabName(value:String):String
	{
		this.customFirstTabStyleName = value;
		return get_customFirstTabName();
	}

	/**
	 * @private
	 */
	private var _customLastTabStyleName:String;

	/**
	 * A style name to add to the last tab in this tab bar. Typically used
	 * by a theme to provide different styles to the last tab.
	 *
	 * <p>In the following example, a custom last tab style name is provided
	 * to the tab bar:</p>
	 *
	 * <listing version="3.0">
	 * tabs.customLastTabStyleName = "my-custom-last-tab";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( "my-custom-last-tab", setCustomLastTabStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var customLastTabStyleName(get, set):String;
	public function get_customLastTabStyleName():String
	{
		return this._customLastTabStyleName;
	}

	/**
	 * @private
	 */
	public function set_customLastTabStyleName(value:String):String
	{
		if(this._customLastTabStyleName == value)
		{
			return get_customLastTabStyleName();
		}
		this._customLastTabStyleName = value;
		this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		return get_customLastTabStyleName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customLastTabStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customLastTabStyleName
	 */
	public var customLastTabName(get, set):String;
	public function get_customLastTabName():String
	{
		return this.customLastTabStyleName;
	}

	/**
	 * @private
	 */
	public function set_customLastTabName(value:String):String
	{
		this.customLastTabStyleName = value;
		return get_customLastTabName();
	}

	/**
	 * @private
	 */
	private var _tabProperties:PropertyProxy;

	/**
	 * An object that stores properties for all of the tab bar's tabs, and
	 * the properties will be passed down to every tab when the tab bar
	 * validates. For a list of available properties, refer to
	 * <a href="ToggleButton.html"><code>feathers.controls.ToggleButton</code></a>.
	 *
	 * <p>These properties are shared by every tab, so anything that cannot
	 * be shared (such as display objects, which cannot be added to multiple
	 * parents) should be passed to tabs using the <code>tabFactory</code>
	 * or in the theme.</p>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>tabFactory</code> function instead
	 * of using <code>tabProperties</code> will result in better
	 * performance.</p>
	 *
	 * <p>In the following example, the tab bar's tab properties are updated:</p>
	 *
	 * <listing version="3.0">
	 * tabs.tabProperties.iconPosition = Button.ICON_POSITION_RIGHT;</listing>
	 *
	 * @default null
	 *
	 * @see #tabFactory
	 * @see feathers.controls.ToggleButton
	 */
	public var tabProperties(get, set):PropertyProxy;
	public function get_tabProperties():PropertyProxy
	{
		if(this._tabProperties == null)
		{
			this._tabProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._tabProperties;
	}

	/**
	 * @private
	 */
	public function set_tabProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._tabProperties == value)
		{
			return get_tabProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value))
			{
				newValue.setProperty(propertyName, Reflect.field(value, propertyName));
			}
			value = newValue;
		}
		if(this._tabProperties != null)
		{
			this._tabProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._tabProperties = value;
		if(this._tabProperties != null)
		{
			this._tabProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_tabProperties();
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		//clearing selection now so that the data provider setter won't
		//cause a selection change that triggers events.
		this._selectedIndex = -1;
		this.dataProvider = null;
		super.dispose();
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this.toggleGroup = new ToggleGroup();
		this.toggleGroup.isSelectionRequired = true;
		this.toggleGroup.addEventListener(Event.CHANGE, toggleGroup_changeHandler);
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);
		var selectionInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SELECTED);
		var tabFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_TAB_FACTORY);
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);

		if(dataInvalid || tabFactoryInvalid)
		{
			this.refreshTabs(tabFactoryInvalid);
		}

		if(dataInvalid || tabFactoryInvalid || stylesInvalid)
		{
			this.refreshTabStyles();
		}

		if(dataInvalid || tabFactoryInvalid || selectionInvalid)
		{
			this.commitSelection();
		}

		if(dataInvalid || tabFactoryInvalid || stateInvalid)
		{
			this.commitEnabled();
		}

		if(stylesInvalid)
		{
			this.refreshLayoutStyles();
		}

		this.layoutTabs();
	}

	/**
	 * @private
	 */
	private function commitSelection():Void
	{
		this.toggleGroup.selectedIndex = this._selectedIndex;
	}

	/**
	 * @private
	 */
	private function commitEnabled():Void
	{
		for (tab in this.activeTabs)
		{
			tab.isEnabled = /*&&=*/ tab.isEnabled && this._isEnabled;
		}
	}

	/**
	 * @private
	 */
	private function refreshTabStyles():Void
	{
		if (this._tabProperties != null)
			for (propertyName in Reflect.fields(this._tabProperties.storage))
			{
				var propertyValue:Dynamic = Reflect.field(this._tabProperties.storage, propertyName);
				for (tab in this.activeTabs)
				{
					Reflect.setProperty(tab, propertyName, propertyValue);
				}
			}
	}

	/**
	 * @private
	 */
	private function refreshLayoutStyles():Void
	{
		if(this._direction == DIRECTION_VERTICAL)
		{
			if(this.horizontalLayout != null)
			{
				this.horizontalLayout = null;
			}
			if(this.verticalLayout == null)
			{
				this.verticalLayout = new VerticalLayout();
				this.verticalLayout.useVirtualLayout = false;
			}
			this.verticalLayout.distributeHeights = this._distributeTabSizes;
			this.verticalLayout.horizontalAlign = this._horizontalAlign;
			this.verticalLayout.verticalAlign = (this._verticalAlign == VERTICAL_ALIGN_JUSTIFY) ? VERTICAL_ALIGN_TOP : this._verticalAlign;
			this.verticalLayout.gap = this._gap;
			this.verticalLayout.firstGap = this._firstGap;
			this.verticalLayout.lastGap = this._lastGap;
			this.verticalLayout.paddingTop = this._paddingTop;
			this.verticalLayout.paddingRight = this._paddingRight;
			this.verticalLayout.paddingBottom = this._paddingBottom;
			this.verticalLayout.paddingLeft = this._paddingLeft;
		}
		else //horizontal
		{
			if(this.verticalLayout != null)
			{
				this.verticalLayout = null;
			}
			if(this.horizontalLayout == null)
			{
				this.horizontalLayout = new HorizontalLayout();
				this.horizontalLayout.useVirtualLayout = false;
			}
			this.horizontalLayout.distributeWidths = this._distributeTabSizes;
			this.horizontalLayout.horizontalAlign = (this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY) ? HORIZONTAL_ALIGN_LEFT : this._horizontalAlign;
			this.horizontalLayout.verticalAlign = this._verticalAlign;
			this.horizontalLayout.gap = this._gap;
			this.horizontalLayout.firstGap = this._firstGap;
			this.horizontalLayout.lastGap = this._lastGap;
			this.horizontalLayout.paddingTop = this._paddingTop;
			this.horizontalLayout.paddingRight = this._paddingRight;
			this.horizontalLayout.paddingBottom = this._paddingBottom;
			this.horizontalLayout.paddingLeft = this._paddingLeft;
		}
	}

	/**
	 * @private
	 */
	private function defaultTabInitializer(tab:ToggleButton, item:Dynamic):Void
	{
		//if(Std.is(item, Object))
		{
			var itemLabel = Reflect.getProperty(item, "label");
			if(itemLabel != null)
			{
				tab.label = itemLabel;
			}
			else
			{
				tab.label = item.toString();
			}
			for (field in DEFAULT_TAB_FIELDS)
			{
				var itemField = Reflect.getProperty(item, field);
				if(itemField != null)
				{
					Reflect.setProperty(tab, field, String);
				}
			}
		}
		#if 0
		else
		{
			tab.label = "";
		}
		#end

	}

	/**
	 * @private
	 */
	private function refreshTabs(isFactoryInvalid:Bool):Void
	{
		var oldIgnoreSelectionChanges:Bool = this._ignoreSelectionChanges;
		this._ignoreSelectionChanges = true;
		var oldSelectedIndex:Int = this.toggleGroup.selectedIndex;
		this.toggleGroup.removeAllItems();
		var temp:Array<ToggleButton> = this.inactiveTabs;
		this.inactiveTabs = this.activeTabs;
		this.activeTabs = temp;
		this.activeTabs.splice(0, this.activeTabs.length);
		this._layoutItems.splice(0, this._layoutItems.length);
		temp = null;
		if(isFactoryInvalid)
		{
			this.clearInactiveTabs();
		}
		else
		{
			if(this.activeFirstTab != null)
			{
				this.inactiveTabs.shift();
			}
			this.inactiveFirstTab = this.activeFirstTab;

			if(this.activeLastTab != null)
			{
				this.inactiveTabs.pop();
			}
			this.inactiveLastTab = this.activeLastTab;
		}
		this.activeFirstTab = null;
		this.activeLastTab = null;

		var pushIndex:Int = 0;
		var itemCount:Int = this._dataProvider != null ? this._dataProvider.length : 0;
		var lastItemIndex:Int = itemCount - 1;
		//for(var i:Int = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			var item:Dynamic = this._dataProvider.getItemAt(i);
			var tab:ToggleButton;
			if(i == 0)
			{
				tab = this.activeFirstTab = this.createFirstTab(item);
			}
			else if(i == lastItemIndex)
			{
				tab = this.activeLastTab = this.createLastTab(item);
			}
			else
			{
				tab = this.createTab(item);
			}
			this.toggleGroup.addItem(tab);
			this.activeTabs[pushIndex] = tab;
			this._layoutItems[pushIndex] = tab;
			pushIndex++;
		}

		this.clearInactiveTabs();
		this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
		if(oldSelectedIndex >= 0)
		{
			var newSelectedIndex:Int = this.activeTabs.length - 1;
			if(oldSelectedIndex < newSelectedIndex)
			{
				newSelectedIndex = oldSelectedIndex;
			}
			//removing all items from the ToggleGroup clears the selection,
			//so we need to set it back to the old value (or a new clamped
			//value). we want the change event to dispatch only if the old
			//value and the new value don't match.
			this._ignoreSelectionChanges = oldSelectedIndex == newSelectedIndex;
			this.toggleGroup.selectedIndex = newSelectedIndex;
			this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
		}
	}

	/**
	 * @private
	 */
	private function clearInactiveTabs():Void
	{
		var itemCount:Int = this.inactiveTabs.length;
		//for(var i:Int = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			var tab:ToggleButton = this.inactiveTabs.shift();
			this.destroyTab(tab);
		}

		if(this.inactiveFirstTab != null)
		{
			this.destroyTab(this.inactiveFirstTab);
			this.inactiveFirstTab = null;
		}

		if(this.inactiveLastTab != null)
		{
			this.destroyTab(this.inactiveLastTab);
			this.inactiveLastTab = null;
		}
	}

	/**
	 * @private
	 */
	private function createFirstTab(item:Dynamic):ToggleButton
	{
		var tab:ToggleButton;
		if(this.inactiveFirstTab != null)
		{
			tab = this.inactiveFirstTab;
			this.inactiveFirstTab = null;
		}
		else
		{
			var factory:Void->ToggleButton = this._firstTabFactory != null ? this._firstTabFactory : this._tabFactory;
			tab = factory();
			if(this._customFirstTabStyleName != null)
			{
				tab.styleNameList.add(this._customFirstTabStyleName);
			}
			else if(this._customTabStyleName != null)
			{
				tab.styleNameList.add(this._customTabStyleName);
			}
			else
			{
				tab.styleNameList.add(this.firstTabStyleName);
			}
			tab.isToggle = true;
			this.addChild(tab);
		}
		this._tabInitializer(tab, item);
		return tab;
	}

	/**
	 * @private
	 */
	private function createLastTab(item:Dynamic):ToggleButton
	{
		var tab:ToggleButton;
		if(this.inactiveLastTab != null)
		{
			tab = this.inactiveLastTab;
			this.inactiveLastTab = null;
		}
		else
		{
			var factory:Void->ToggleButton = this._lastTabFactory != null ? this._lastTabFactory : this._tabFactory;
			tab = factory();
			if(this._customLastTabStyleName != null)
			{
				tab.styleNameList.add(this._customLastTabStyleName);
			}
			else if(this._customTabStyleName != null)
			{
				tab.styleNameList.add(this._customTabStyleName);
			}
			else
			{
				tab.styleNameList.add(this.lastTabStyleName);
			}
			tab.isToggle = true;
			this.addChild(tab);
		}
		this._tabInitializer(tab, item);
		return tab;
	}

	/**
	 * @private
	 */
	private function createTab(item:Dynamic):ToggleButton
	{
		var tab:ToggleButton;
		if(this.inactiveTabs.length == 0)
		{
			tab = this._tabFactory();
			if(this._customTabStyleName != null)
			{
				tab.styleNameList.add(this._customTabStyleName);
			}
			else
			{
				tab.styleNameList.add(this.tabStyleName);
			}
			tab.isToggle = true;
			this.addChild(tab);
		}
		else
		{
			tab = this.inactiveTabs.shift();
		}
		this._tabInitializer(tab, item);
		return tab;
	}

	/**
	 * @private
	 */
	private function destroyTab(tab:ToggleButton):Void
	{
		this.toggleGroup.removeItem(tab);
		this.removeChild(tab, true);
	}

	/**
	 * @private
	 */
	private function layoutTabs():Void
	{
		this._viewPortBounds.x = 0;
		this._viewPortBounds.y = 0;
		this._viewPortBounds.scrollX = 0;
		this._viewPortBounds.scrollY = 0;
		this._viewPortBounds.explicitWidth = this.explicitWidth;
		this._viewPortBounds.explicitHeight = this.explicitHeight;
		this._viewPortBounds.minWidth = this._minWidth;
		this._viewPortBounds.minHeight = this._minHeight;
		this._viewPortBounds.maxWidth = this._maxWidth;
		this._viewPortBounds.maxHeight = this._maxHeight;
		if(this.verticalLayout != null)
		{
			this.verticalLayout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
		}
		else if(this.horizontalLayout != null)
		{
			this.horizontalLayout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
		}
		this.setSizeInternal(this._layoutResult.contentWidth, this._layoutResult.contentHeight, false);
		//final validation to avoid juggler next frame issues
		for (tab in this.activeTabs)
		{
			tab.validate();
		}
	}

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void
	{
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function toggleGroup_changeHandler(event:Event):Void
	{
		if(this._ignoreSelectionChanges)
		{
			return;
		}
		this.selectedIndex = this.toggleGroup.selectedIndex;
	}

	/**
	 * @private
	 */
	private function dataProvider_addItemHandler(event:Event, index:Int):Void
	{
		if(this._selectedIndex >= index)
		{
			//we're keeping the same selected item, but the selected index
			//will change, so we need to manually dispatch the change event
			this.selectedIndex += 1;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private function dataProvider_removeItemHandler(event:Event, index:Int):Void
	{
		if(this._selectedIndex > index)
		{
			//the same item is selected, but its index has changed.
			this.selectedIndex -= 1;
		}
		else if(this._selectedIndex == index)
		{
			var oldIndex:Int = this._selectedIndex;
			var newIndex:Int = oldIndex;
			var maxIndex:Int = this._dataProvider.length - 1;
			if(newIndex > maxIndex)
			{
				newIndex = maxIndex;
			}
			if(oldIndex == newIndex)
			{
				//we're keeping the same selected index, but the selected
				//item will change, so we need to manually dispatch the
				//change event
				this.invalidate(INVALIDATION_FLAG_SELECTED);
				this.dispatchEventWith(Event.CHANGE);
			}
			else
			{
				//we're selecting both a different index and a different
				//item, so we'll just call the selectedIndex setter
				this.selectedIndex = newIndex;
			}
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private function dataProvider_resetHandler(event:Event):Void
	{
		if(this._dataProvider.length > 0)
		{
			//the data provider has changed drastically. we should reset the
			//selection to the first item.
			if(this._selectedIndex != 0)
			{
				this.selectedIndex = 0;
			}
			else
			{
				//we're keeping the same selected index, but the selected
				//item will change, so we need to manually dispatch the
				//change event
				this.invalidate(INVALIDATION_FLAG_SELECTED);
				this.dispatchEventWith(Event.CHANGE);
			}
		}
		else if(this._selectedIndex >= 0)
		{
			this.selectedIndex = -1;
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private function dataProvider_replaceItemHandler(event:Event, index:Int):Void
	{
		if(this._selectedIndex == index)
		{
			//we're keeping the same selected index, but the selected
			//item will change, so we need to manually dispatch the
			//change event
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private function dataProvider_updateItemHandler(event:Event, index:Int):Void
	{
		//no need to dispatch a change event. the index and the item are the
		//same. the item's properties have changed, but that doesn't require
		//a change event.
		this.invalidate(INVALIDATION_FLAG_DATA);
	}
}
