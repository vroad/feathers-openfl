/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IFeathersControl;
import feathers.core.IValidating;
import feathers.utils.type.SafeCast.safe_cast;

import openfl.errors.IllegalOperationError;
import openfl.errors.RangeError;
import openfl.geom.Point;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Dispatched when a property of the layout changes, indicating that a
 * redraw is probably needed.
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
//[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when the layout would like to adjust the container's scroll
 * position. Typically, this is used when the virtual dimensions of an item
 * differ from its real dimensions. This event allows the container to
 * adjust scrolling so that it appears smooth, without jarring jumps or
 * shifts when an item resizes.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>A <code>flash.geom.Point</code> object
 *   representing how much the scroll position should be adjusted in both
 *   horizontal and vertical directions. Measured in pixels.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.SCROLL
 */
#if 0
[Event(name="scroll",type="starling.events.Event")]
#end

/**
 * Positions items from top to bottom in a single column.
 *
 * @see ../../../help/vertical-layout.html How to use VerticalLayout with Feathers containers
 */
class VerticalLayout extends EventDispatcher implements IVariableVirtualLayout implements ITrimmedVirtualLayout
{
	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the top.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the middle.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the bottom.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * The items will be aligned to the left of the bounds.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * The items will be aligned to the center of the bounds.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * The items will be aligned to the right of the bounds.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * The items will fill the width of the bounds.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * @private
	 */
	private var _heightCache:Array<Null<Float>> = [];

	/**
	 * @private
	 */
	private var _discoveredItemsCache:Array<DisplayObject> = new Array();

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * The space, in pixels, between items.
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
		this.dispatchEventWith(Event.CHANGE);
		return get_gap();
	}

	/**
	 * @private
	 */
	private var _firstGap:Float = Math.NaN;

	/**
	 * The space, in pixels, between the first and second items. If the
	 * value of <code>firstGap</code> is <code>NaN</code>, the value of the
	 * <code>gap</code> property will be used instead.
	 *
	 * @default NaN
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
		this.dispatchEventWith(Event.CHANGE);
		return get_firstGap();
	}

	/**
	 * @private
	 */
	private var _lastGap:Float = Math.NaN;

	/**
	 * The space, in pixels, between the last and second to last items. If
	 * the value of <code>lastGap</code> is <code>NaN</code>, the value of
	 * the <code>gap</code> property will be used instead.
	 *
	 * @default NaN
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
		this.dispatchEventWith(Event.CHANGE);
		return get_lastGap();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
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
	 * The space, in pixels, that appears on top, before the first item.
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
		this.dispatchEventWith(Event.CHANGE);
		return get_paddingTop();
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, to the right of the items.
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
		this.dispatchEventWith(Event.CHANGE);
		return get_paddingRight();
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The space, in pixels, that appears on the bottom, after the last
	 * item.
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
		this.dispatchEventWith(Event.CHANGE);
		return get_paddingBottom();
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, to the left of the items.
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
		this.dispatchEventWith(Event.CHANGE);
		return get_paddingLeft();
	}


	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

	//[Inspectable(type="String",enumeration="top,middle,bottom")]
	/**
	 * If the total item height is less than the bounds, the positions of
	 * the items can be aligned vertically.
	 *
	 * @default VerticalLayout.VERTICAL_ALIGN_TOP
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
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
		this.dispatchEventWith(Event.CHANGE);
		return get_verticalAlign();
	}

	/**
	 * @private
	 */
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

	//[Inspectable(type="String",enumeration="left,center,right,justify")]
	/**
	 * The alignment of the items horizontally, on the x-axis.
	 *
	 * <p>If the <code>horizontalAlign</code> property is set to
	 * <code>VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY</code>, the
	 * <code>width</code>, <code>minWidth</code>, and <code>maxWidth</code>
	 * properties of the items may be changed, and their original values
	 * ignored by the layout. In this situation, if the width needs to be
	 * constrained, the <code>width</code>, <code>minWidth</code>, or
	 * <code>maxWidth</code> properties should instead be set on the parent
	 * container using the layout.</p>
	 *
	 * @default VerticalLayout.HORIZONTAL_ALIGN_LEFT
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
		this.dispatchEventWith(Event.CHANGE);
		return get_horizontalAlign();
	}

	/**
	 * @private
	 */
	private var _useVirtualLayout:Bool = true;

	/**
	 * @inheritDoc
	 *
	 * @default true
	 */
	public var useVirtualLayout(get, set):Bool;
	public function get_useVirtualLayout():Bool
	{
		return this._useVirtualLayout;
	}

	/**
	 * @private
	 */
	public function set_useVirtualLayout(value:Bool):Bool
	{
		if(this._useVirtualLayout == value)
		{
			return get_useVirtualLayout();
		}
		this._useVirtualLayout = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_useVirtualLayout();
	}

	/**
	 * @private
	 */
	private var _hasVariableItemDimensions:Bool = false;

	/**
	 * When the layout is virtualized, and this value is true, the items may
	 * have variable height values. If false, the items will all share the
	 * same height value with the typical item.
	 *
	 * @default false
	 */
	public var hasVariableItemDimensions(get, set):Bool;
	public function get_hasVariableItemDimensions():Bool
	{
		return this._hasVariableItemDimensions;
	}

	/**
	 * @private
	 */
	public function set_hasVariableItemDimensions(value:Bool):Bool
	{
		if(this._hasVariableItemDimensions == value)
		{
			return get_hasVariableItemDimensions();
		}
		this._hasVariableItemDimensions = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_hasVariableItemDimensions();
	}

	/**
	 * @private
	 */
	private var _distributeHeights:Bool = false;

	/**
	 * Distributes the height of the view port equally to each item. If the
	 * view port height needs to be measured, the largest item's height will
	 * be used for all items, subject to any specified minimum and maximum
	 * height values.
	 *
	 * @default false
	 */
	public var distributeHeights(get, set):Bool;
	public function get_distributeHeights():Bool
	{
		return this._distributeHeights;
	}

	/**
	 * @private
	 */
	public function set_distributeHeights(value:Bool):Bool
	{
		if(this._distributeHeights == value)
		{
			return get_distributeHeights();
		}
		this._distributeHeights = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_distributeHeights();
	}

	/**
	 * @private
	 */
	private var _requestedRowCount:Int = 0;

	/**
	 * Requests that the layout set the view port dimensions to display a
	 * specific number of rows (plus gaps and padding), if possible. If the
	 * explicit height of the view port is set, then this value will be
	 * ignored. If the view port's minimum and/or maximum height are set,
	 * the actual number of visible rows may be adjusted to meet those
	 * requirements. Set this value to <code>0</code> to display as many
	 * rows as possible.
	 *
	 * @default 0
	 */
	public function get_requestedRowCount():Int
	{
		return this._requestedRowCount;
	}

	/**
	 * @private
	 */
	public function set_requestedRowCount(value:Int):Int
	{
		if(value < 0)
		{
			throw new RangeError("requestedRowCount requires a value >= 0");
		}
		if(this._requestedRowCount == value)
		{
			return get_requestedRowCount();
		}
		this._requestedRowCount = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_requestedRowCount();
	}

	/**
	 * @private
	 */
	private var _beforeVirtualizedItemCount:Int = 0;

	/**
	 * @inheritDoc
	 */
	public var beforeVirtualizedItemCount(get, set):Int;
	public function get_beforeVirtualizedItemCount():Int
	{
		return this._beforeVirtualizedItemCount;
	}

	/**
	 * @private
	 */
	public function set_beforeVirtualizedItemCount(value:Int):Int
	{
		if(this._beforeVirtualizedItemCount == value)
		{
			return get_beforeVirtualizedItemCount();
		}
		this._beforeVirtualizedItemCount = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_beforeVirtualizedItemCount();
	}

	/**
	 * @private
	 */
	private var _afterVirtualizedItemCount:Int = 0;

	/**
	 * @inheritDoc
	 */
	public var afterVirtualizedItemCount(get, set):Int;
	public function get_afterVirtualizedItemCount():Int
	{
		return this._afterVirtualizedItemCount;
	}

	/**
	 * @private
	 */
	public function set_afterVirtualizedItemCount(value:Int):Int
	{
		if(this._afterVirtualizedItemCount == value)
		{
			return get_afterVirtualizedItemCount();
		}
		this._afterVirtualizedItemCount = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_afterVirtualizedItemCount();
	}

	/**
	 * @private
	 */
	private var _typicalItem:DisplayObject;

	/**
	 * @inheritDoc
	 *
	 * @see #resetTypicalItemDimensionsOnMeasure
	 * @see #typicalItemWidth
	 * @see #typicalItemHeight
	 */
	public var typicalItem(get, set):DisplayObject;
	public function get_typicalItem():DisplayObject
	{
		return this._typicalItem;
	}

	/**
	 * @private
	 */
	public function set_typicalItem(value:DisplayObject):DisplayObject
	{
		if(this._typicalItem == value)
		{
			return get_typicalItem();
		}
		this._typicalItem = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_typicalItem();
	}

	/**
	 * @private
	 */
	private var _resetTypicalItemDimensionsOnMeasure:Bool = false;

	/**
	 * If set to <code>true</code>, the width and height of the
	 * <code>typicalItem</code> will be reset to <code>typicalItemWidth</code>
	 * and <code>typicalItemHeight</code>, respectively, whenever the
	 * typical item needs to be measured. The measured dimensions of the
	 * typical item are used to fill in the blanks of a virtualized layout
	 * for virtual items that don't have their own display objects to
	 * measure yet.
	 *
	 * @default false
	 *
	 * @see #typicalItemWidth
	 * @see #typicalItemHeight
	 * @see #typicalItem
	 */
	public var resetTypicalItemDimensionsOnMeasure(get, set):Bool;
	public function get_resetTypicalItemDimensionsOnMeasure():Bool
	{
		return this._resetTypicalItemDimensionsOnMeasure;
	}

	/**
	 * @private
	 */
	public function set_resetTypicalItemDimensionsOnMeasure(value:Bool):Bool
	{
		if(this._resetTypicalItemDimensionsOnMeasure == value)
		{
			return get_resetTypicalItemDimensionsOnMeasure();
		}
		this._resetTypicalItemDimensionsOnMeasure = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_resetTypicalItemDimensionsOnMeasure();
	}

	/**
	 * @private
	 */
	private var _typicalItemWidth:Float = Math.NaN;

	/**
	 * Used to reset the width, in pixels, of the <code>typicalItem</code>
	 * for measurement. The measured dimensions of the typical item are used
	 * to fill in the blanks of a virtualized layout for virtual items that
	 * don't have their own display objects to measure yet.
	 *
	 * <p>This value is only used when <code>resetTypicalItemDimensionsOnMeasure</code>
	 * is set to <code>true</code>. If <code>resetTypicalItemDimensionsOnMeasure</code>
	 * is set to <code>false</code>, this value will be ignored and the
	 * <code>typicalItem</code> dimensions will not be reset before
	 * measurement.</p>
	 *
	 * <p>If <code>typicalItemWidth</code> is set to <code>NaN</code>, the
	 * typical item will auto-size itself to its preferred width. If you
	 * pass a valid <code>Float</code> value, the typical item's width will
	 * be set to a fixed size. May be used in combination with
	 * <code>typicalItemHeight</code>.</p>
	 *
	 * @default NaN
	 *
	 * @see #resetTypicalItemDimensionsOnMeasure
	 * @see #typicalItemHeight
	 * @see #typicalItem
	 */
	public var typicalItemWidth(get, set):Float;
	public function get_typicalItemWidth():Float
	{
		return this._typicalItemWidth;
	}

	/**
	 * @private
	 */
	public function set_typicalItemWidth(value:Float):Float
	{
		if(this._typicalItemWidth == value)
		{
			return get_typicalItemWidth();
		}
		this._typicalItemWidth = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_typicalItemWidth();
	}

	/**
	 * @private
	 */
	private var _typicalItemHeight:Float = Math.NaN;

	/**
	 * Used to reset the height, in pixels, of the <code>typicalItem</code>
	 * for measurement. The measured dimensions of the typical item are used
	 * to fill in the blanks of a virtualized layout for virtual items that
	 * don't have their own display objects to measure yet.
	 *
	 * <p>This value is only used when <code>resetTypicalItemDimensionsOnMeasure</code>
	 * is set to <code>true</code>. If <code>resetTypicalItemDimensionsOnMeasure</code>
	 * is set to <code>false</code>, this value will be ignored and the
	 * <code>typicalItem</code> dimensions will not be reset before
	 * measurement.</p>
	 *
	 * <p>If <code>typicalItemHeight</code> is set to <code>NaN</code>, the
	 * typical item will auto-size itself to its preferred height. If you
	 * pass a valid <code>Float</code> value, the typical item's height will
	 * be set to a fixed size. May be used in combination with
	 * <code>typicalItemWidth</code>.</p>
	 *
	 * @default NaN
	 *
	 * @see #resetTypicalItemDimensionsOnMeasure
	 * @see #typicalItemWidth
	 * @see #typicalItem
	 */
	public var typicalItemHeight(get, set):Float;
	public function get_typicalItemHeight():Float
	{
		return this._typicalItemHeight;
	}

	/**
	 * @private
	 */
	public function set_typicalItemHeight(value:Float):Float
	{
		if(this._typicalItemHeight == value)
		{
			return get_typicalItemHeight();
		}
		this._typicalItemHeight = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_typicalItemHeight();
	}

	/**
	 * @private
	 */
	private var _scrollPositionVerticalAlign:String = VERTICAL_ALIGN_MIDDLE;

	//[Inspectable(type="String",enumeration="top,middle,bottom")]
	/**
	 * When the scroll position is calculated for an item, an attempt will
	 * be made to align the item to this position.
	 *
	 * @default VerticalLayout.VERTICAL_ALIGN_MIDDLE
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 */
	public var scrollPositionVerticalAlign(get, set):String;
	public function get_scrollPositionVerticalAlign():String
	{
		return this._scrollPositionVerticalAlign;
	}

	/**
	 * @private
	 */
	public function set_scrollPositionVerticalAlign(value:String):String
	{
		this._scrollPositionVerticalAlign = value;
		return get_scrollPositionVerticalAlign();
	}

	/**
	 * @inheritDoc
	 */
	public var requiresLayoutOnScroll(get, never):Bool;
	public function get_requiresLayoutOnScroll():Bool
	{
		return this._useVirtualLayout;
	}

	/**
	 * @inheritDoc
	 */
	public function layout(items:Array<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
	{
		//this function is very long because it may be called every frame,
		//in some situations. testing revealed that splitting this function
		//into separate, smaller functions affected performance.
		//since the SWC compiler cannot inline functions, we can't use that
		//feature either.

		//since viewPortBounds can be null, we may need to provide some defaults
		var scrollX:Float = viewPortBounds != null ? viewPortBounds.scrollX : 0;
		var scrollY:Float = viewPortBounds != null ? viewPortBounds.scrollY : 0;
		var boundsX:Float = viewPortBounds != null ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds != null ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds != null ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds != null ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds != null ? viewPortBounds.maxWidth : Math.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds != null ? viewPortBounds.maxHeight : Math.POSITIVE_INFINITY;
		var explicitWidth:Float = viewPortBounds != null ? viewPortBounds.explicitWidth : Math.NaN;
		var explicitHeight:Float = viewPortBounds != null ? viewPortBounds.explicitHeight : Math.NaN;
		
		var calculatedTypicalItemWidth:Float = Math.NaN;
		var calculatedTypicalItemHeight:Float = Math.NaN;

		if(this._useVirtualLayout)
		{
			//if the layout is virtualized, we'll need the dimensions of the
			//typical item so that we have fallback values when an item is null
			this.prepareTypicalItem(explicitWidth - this._paddingLeft - this._paddingRight);
			calculatedTypicalItemWidth = this._typicalItem != null ? this._typicalItem.width : 0;
			calculatedTypicalItemHeight = this._typicalItem != null ? this._typicalItem.height : 0;
		}

		if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeHeights ||
			this._horizontalAlign != HORIZONTAL_ALIGN_JUSTIFY ||
			explicitWidth != explicitWidth) //isNaN
		{
			//in some cases, we may need to validate all of the items so
			//that we can use their dimensions below.
			this.validateItems(items, explicitWidth - this._paddingLeft - this._paddingRight,
				minWidth - this._paddingLeft - this._paddingRight,
				maxWidth - this._paddingLeft - this._paddingRight,
				explicitHeight);
		}

		if(!this._useVirtualLayout)
		{
			//handle the percentHeight property from VerticalLayoutData,
			//if available.
			this.applyPercentHeights(items, explicitHeight, minHeight, maxHeight);
		}

		var distributedHeight:Float = Math.NaN;
		if(this._distributeHeights)
		{
			//distribute the height evenly among all items
			distributedHeight = this.calculateDistributedHeight(items, explicitHeight, minHeight, maxHeight);
		}
		var hasDistributedHeight:Bool = distributedHeight == distributedHeight; //!isNaN

		//this section prepares some variables needed for the following loop
		var hasFirstGap:Bool = this._firstGap == this._firstGap; //!isNaN
		var hasLastGap:Bool = this._lastGap == this._lastGap; //!isNaN
		var maxItemWidth:Float = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
		var positionY:Float = boundsY + this._paddingTop;
		var indexOffset:Int = 0;
		var itemCount:Int = items.length;
		var totalItemCount:Int = itemCount;
		if(this._useVirtualLayout && !this._hasVariableItemDimensions)
		{
			//if the layout is virtualized, and the items all have the same
			//height, we can make our loops smaller by skipping some items
			//at the beginning and end. this improves performance.
			totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
			indexOffset = this._beforeVirtualizedItemCount;
			positionY += (this._beforeVirtualizedItemCount * (calculatedTypicalItemHeight + this._gap));
			if(hasFirstGap && this._beforeVirtualizedItemCount > 0)
			{
				positionY = positionY - this._gap + this._firstGap;
			}
		}
		var secondToLastIndex:Int = totalItemCount - 2;
		//this cache is used to save non-null items in virtual layouts. by
		//using a smaller array, we can improve performance by spending less
		//time in the upcoming loops.
		this._discoveredItemsCache.splice(0, this._discoveredItemsCache.length);
		var discoveredItemsCacheLastIndex:Int = 0;
		
		var cachedHeight:Float = Math.NaN;
		var itemWidth:Float;
		var item:DisplayObject;

		//this first loop sets the y position of items, and it calculates
		//the total height of all items
		//for(var i:Int = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			item = items[i];
			//if we're trimming some items at the beginning, we need to
			//adjust i to account for the missing items in the array
			var iNormalized:Int = i + indexOffset;

			//pick the gap that will follow this item. the first and second
			//to last items may have different gaps.
			var gap:Float = this._gap;
			if(hasFirstGap && iNormalized == 0)
			{
				gap = this._firstGap;
			}
			else if(hasLastGap && iNormalized > 0 && iNormalized == secondToLastIndex)
			{
				gap = this._lastGap;
			}

			if(this._useVirtualLayout && this._hasVariableItemDimensions)
			{
				cachedHeight = getHeightFromCache(iNormalized);
			}
			if(this._useVirtualLayout && item == null)
			{
				//the item is null, and the layout is virtualized, so we
				//need to estimate the height of the item.

				if(!this._hasVariableItemDimensions ||
					cachedHeight != cachedHeight) //isNaN
				{
					//if all items must have the same height, we will
					//use the height of the typical item (calculatedTypicalItemHeight).

					//if items may have different heights, we first check
					//the cache for a height value. if there isn't one, then
					//we'll use calculatedTypicalItemHeight as a fallback.
					positionY += calculatedTypicalItemHeight + gap;
				}
				else
				{
					//if we have variable item heights, we should use a
					//cached height when there's one available. it will be
					//more accurate than the typical item's height.
					positionY += cachedHeight + gap;
				}
			}
			else
			{
				//we get here if the item isn't null. it is never null if
				//the layout isn't virtualized.
				if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
				{
					continue;
				}
				item.y = item.pivotY + positionY;
				itemWidth = item.width;
				var itemHeight:Float;
				if(hasDistributedHeight)
				{
					item.height = itemHeight = distributedHeight;
				}
				else
				{
					itemHeight = item.height;
				}
				if(this._useVirtualLayout)
				{
					if(this._hasVariableItemDimensions)
					{
						if(itemHeight != cachedHeight)
						{
							//update the cache if needed. this will notify
							//the container that the virtualized layout has
							//changed, and it the view port may need to be
							//re-measured.
							this._heightCache[iNormalized] = itemHeight;

							//attempt to adjust the scroll position so that
							//it looks like we're scrolling smoothly after
							//this item resizes.
							if(positionY < scrollY &&
								cachedHeight != cachedHeight && //isNaN
								itemHeight != calculatedTypicalItemHeight)
							{
								this.dispatchEventWith(Event.SCROLL, false, new Point(0, itemHeight - calculatedTypicalItemHeight));
							}

							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else if(calculatedTypicalItemHeight >= 0)
					{
						//if all items must have the same height, we will
						//use the height of the typical item (calculatedTypicalItemHeight).
						item.height = itemHeight = calculatedTypicalItemHeight;
					}
				}
				positionY += itemHeight + gap;
				//we compare with > instead of Math.max() because the rest
				//arguments on Math.max() cause extra garbage collection and
				//hurt performance
				if(itemWidth > maxItemWidth)
				{
					//we need to know the maximum width of the items in the
					//case where the width of the view port needs to be
					//calculated by the layout.
					maxItemWidth = itemWidth;
				}
				if(this._useVirtualLayout)
				{
					this._discoveredItemsCache[discoveredItemsCacheLastIndex] = item;
					discoveredItemsCacheLastIndex++;
				}
			}
		}
		if(this._useVirtualLayout && !this._hasVariableItemDimensions)
		{
			//finish the final calculation of the y position so that it can
			//be used for the total height of all items
			positionY += (this._afterVirtualizedItemCount * (calculatedTypicalItemHeight + this._gap));
			if(hasLastGap && this._afterVirtualizedItemCount > 0)
			{
				positionY = positionY - this._gap + this._lastGap;
			}
		}

		//this array will contain all items that are not null. see the
		//comment above where the discoveredItemsCache is initialized for
		//details about why this is important.
		var discoveredItems:Array<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
		var discoveredItemCount:Int = discoveredItems.length;

		var totalWidth:Float = maxItemWidth + this._paddingLeft + this._paddingRight;
		//the available width is the width of the viewport. if the explicit
		//width is NaN, we need to calculate the viewport width ourselves
		//based on the total width of all items.
		var availableWidth:Float = explicitWidth;
		if(availableWidth != availableWidth) //isNaN
		{
			availableWidth = totalWidth;
			if(availableWidth < minWidth)
			{
				availableWidth = minWidth;
			}
			else if(availableWidth > maxWidth)
			{
				availableWidth = maxWidth;
			}
		}

		//this is the total height of all items
		var totalHeight:Float = positionY - this._gap + this._paddingBottom - boundsY;
		//the available height is the height of the viewport. if the explicit
		//height is NaN, we need to calculate the viewport height ourselves
		//based on the total height of all items.
		var availableHeight:Float = explicitHeight;
		if(availableHeight != availableHeight) //isNaN
		{
			availableHeight = totalHeight;
			if(this._requestedRowCount > 0)
			{
				availableHeight = this._requestedRowCount * (calculatedTypicalItemHeight + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
			}
			else
			{
				availableHeight = totalHeight;
			}
			if(availableHeight < minHeight)
			{
				availableHeight = minHeight;
			}
			else if(availableHeight > maxHeight)
			{
				availableHeight = maxHeight;
			}
		}

		//in this section, we handle vertical alignment. items will be
		//aligned vertically if the total height of all items is less than
		//the available height of the view port.
		if(totalHeight < availableHeight)
		{
			var verticalAlignOffsetY:Float = 0;
			if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				verticalAlignOffsetY = availableHeight - totalHeight;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				verticalAlignOffsetY = Math.round((availableHeight - totalHeight) / 2);
			}
			if(verticalAlignOffsetY != 0)
			{
				//for(i = 0; i < discoveredItemCount; i++)
				for(i in 0 ... discoveredItemCount)
				{
					item = discoveredItems[i];
					if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
					{
						continue;
					}
					item.y += verticalAlignOffsetY;
				}
			}
		}

		//for(i = 0; i < discoveredItemCount; i++)
		for(i in 0 ... discoveredItemCount)
		{
			item = discoveredItems[i];
			var layoutItem:ILayoutDisplayObject = safe_cast(item, ILayoutDisplayObject);
			if(layoutItem != null && !layoutItem.includeInLayout)
			{
				continue;
			}

			//in this section, we handle horizontal alignment and percent
			//width from VerticalLayoutData
			if(this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY)
			{
				//if we justify items horizontally, we can skip percent width
				item.x = item.pivotX + boundsX + this._paddingLeft;
				item.width = availableWidth - this._paddingLeft - this._paddingRight;
			}
			else
			{
				if(layoutItem != null)
				{
					var layoutData:VerticalLayoutData = safe_cast(layoutItem.layoutData, VerticalLayoutData);
					if(layoutData != null)
					{
						//in this section, we handle percentage width if
						//VerticalLayoutData is available.
						var percentWidth:Float = layoutData.percentWidth;
						if(percentWidth == percentWidth) //!isNaN
						{
							if(percentWidth < 0)
							{
								percentWidth = 0;
							}
							if(percentWidth > 100)
							{
								percentWidth = 100;
							}
							itemWidth = percentWidth * (availableWidth - this._paddingLeft - this._paddingRight) / 100;
							if(Std.is(item, IFeathersControl))
							{
								var feathersItem:IFeathersControl = cast item;
								var itemMinWidth:Float = feathersItem.minWidth;
								if(itemWidth < itemMinWidth)
								{
									itemWidth = itemMinWidth;
								}
								else
								{
									var itemMaxWidth:Float = feathersItem.maxWidth;
									if(itemWidth > itemMaxWidth)
									{
										itemWidth = itemMaxWidth;
									}
								}
							}
							item.width = itemWidth;
						}
					}
				}
				//handle all other horizontal alignment values (we handled
				//justify already). the x position of all items is set.
				var horizontalAlignWidth:Float = availableWidth;
				if(totalWidth > horizontalAlignWidth)
				{
					horizontalAlignWidth = totalWidth;
				}
				switch(this._horizontalAlign)
				{
					case HORIZONTAL_ALIGN_RIGHT:
					{
						item.x = item.pivotX + boundsX + horizontalAlignWidth - this._paddingRight - item.width;
						//break;
					}
					case HORIZONTAL_ALIGN_CENTER:
					{
						//round to the nearest pixel when dividing by 2 to
						//align in the center
						item.x = item.pivotX + boundsX + this._paddingLeft + Math.round((horizontalAlignWidth - this._paddingLeft - this._paddingRight - item.width) / 2);
						//break;
					}
					default: //left
					{
						item.x = item.pivotX + boundsX + this._paddingLeft;
					}
				}
			}
		}
		//we don't want to keep a reference to any of the items, so clear
		//this cache
		this._discoveredItemsCache.splice(0, this._discoveredItemsCache.length);

		//finally, we want to calculate the result so that the container
		//can use it to adjust its viewport and determine the minimum and
		//maximum scroll positions (if needed)
		if(result == null)
		{
			result = new LayoutBoundsResult();
		}
		result.contentX = 0;
		result.contentWidth = this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY ? availableWidth : totalWidth;
		result.contentY = 0;
		result.contentHeight = totalHeight;
		result.viewPortWidth = availableWidth;
		result.viewPortHeight = availableHeight;
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function measureViewPort(itemCount:Int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
		}

		var explicitWidth:Float = viewPortBounds != null ? viewPortBounds.explicitWidth : Math.NaN;
		var explicitHeight:Float = viewPortBounds != null ? viewPortBounds.explicitHeight : Math.NaN;
		var needsWidth:Bool = explicitWidth != explicitWidth; //isNaN
		var needsHeight:Bool = explicitHeight != explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			result.x = explicitWidth;
			result.y = explicitHeight;
			return result;
		}
		var minWidth:Float = viewPortBounds != null ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds != null ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds != null ? viewPortBounds.maxWidth : Math.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds != null ? viewPortBounds.maxHeight : Math.POSITIVE_INFINITY;

		this.prepareTypicalItem(explicitWidth - this._paddingLeft - this._paddingRight);
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var hasFirstGap:Bool = this._firstGap == this._firstGap; //!isNaN
		var hasLastGap:Bool = this._lastGap == this._lastGap; //!isNaN
		var positionY:Float;
		var maxItemWidth:Float = Math.NaN;
		if(this._distributeHeights)
		{
			positionY = (calculatedTypicalItemHeight + this._gap) * itemCount;
		}
		else
		{
			positionY = 0;
			maxItemWidth = calculatedTypicalItemWidth;
			if(!this._hasVariableItemDimensions)
			{
				positionY += ((calculatedTypicalItemHeight + this._gap) * itemCount);
			}
			else
			{
				//for(var i:Int = 0; i < itemCount; i++)
				for(i in 0 ... itemCount)
				{
					var cachedHeight:Float = getHeightFromCache(i);
					if(cachedHeight != cachedHeight) //isNaN
					{
						positionY += calculatedTypicalItemHeight + this._gap;
					}
					else
					{
						positionY += cachedHeight + this._gap;
					}
				}
			}
		}
		positionY -= this._gap;
		if(hasFirstGap && itemCount > 1)
		{
			positionY = positionY - this._gap + this._firstGap;
		}
		if(hasLastGap && itemCount > 2)
		{
			positionY = positionY - this._gap + this._lastGap;
		}

		if(needsWidth)
		{
			var resultWidth:Float = maxItemWidth + this._paddingLeft + this._paddingRight;
			if(resultWidth < minWidth)
			{
				resultWidth = minWidth;
			}
			else if(resultWidth > maxWidth)
			{
				resultWidth = maxWidth;
			}
			result.x = resultWidth;
		}
		else
		{
			result.x = explicitWidth;
		}

		if(needsHeight)
		{
			var resultHeight:Float;
			if(this._requestedRowCount > 0)
			{
				resultHeight = (calculatedTypicalItemHeight + this._gap) * this._requestedRowCount - this._gap;
			}
			else
			{
				resultHeight = positionY;
			}
			resultHeight += this._paddingTop + this._paddingBottom;
			if(resultHeight < minHeight)
			{
				resultHeight = minHeight;
			}
			else if(resultHeight > maxHeight)
			{
				resultHeight = maxHeight;
			}
			result.y = resultHeight;
		}
		else
		{
			result.y = explicitHeight;
		}

		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCache():Void
	{
		this._heightCache.splice(0, this._heightCache.length);
	}

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		this._heightCache.remove(index);
		if(item != null)
		{
			this._heightCache[index] = item.height;
			this.dispatchEventWith(Event.CHANGE);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function addToVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		var heightValue:Null<Float> = item != null ? item.height : null;
		this._heightCache.insert(index, heightValue);
	}

	/**
	 * @inheritDoc
	 */
	public function removeFromVariableVirtualCacheAtIndex(index:Int):Void
	{
		this._heightCache.splice(index, 1);
	}

	/**
	 * @inheritDoc
	 */
	public function getVisibleIndicesAtScrollPosition(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Array<Int> = null):Array<Int>
	{
		if(result != null)
		{
			result.splice(0, result.length);
		}
		else
		{
			result = new Array();
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.");
		}

		this.prepareTypicalItem(width - this._paddingLeft - this._paddingRight);
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var hasFirstGap:Bool = this._firstGap == this._firstGap; //!isNaN
		var hasLastGap:Bool = this._lastGap == this._lastGap; //!isNaN
		var resultLastIndex:Int = 0;
		//we add one extra here because the first item renderer in view may
		//be partially obscured, which would reveal an extra item renderer.
		var maxVisibleTypicalItemCount:Int = Math.ceil(height / (calculatedTypicalItemHeight + this._gap)) + 1;
		if(!this._hasVariableItemDimensions)
		{
			//this case can be optimized because we know that every item has
			//the same height
			var totalItemHeight:Float = itemCount * (calculatedTypicalItemHeight + this._gap) - this._gap;
			if(hasFirstGap && itemCount > 1)
			{
				totalItemHeight = totalItemHeight - this._gap + this._firstGap;
			}
			if(hasLastGap && itemCount > 2)
			{
				totalItemHeight = totalItemHeight - this._gap + this._lastGap;
			}
			var indexOffset:Int = 0;
			if(totalItemHeight < height)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					indexOffset = Math.ceil((height - totalItemHeight) / (calculatedTypicalItemHeight + this._gap));
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					indexOffset = Math.ceil(((height - totalItemHeight) / (calculatedTypicalItemHeight + this._gap)) / 2);
				}
			}
			var minimum:Int = Std.int((scrollY - this._paddingTop) / (calculatedTypicalItemHeight + this._gap));
			if(minimum < 0)
			{
				minimum = 0;
			}
			minimum -= indexOffset;
			//if we're scrolling beyond the final item, we should keep the
			//indices consistent so that items aren't destroyed and
			//recreated unnecessarily
			var maximum:Int = minimum + maxVisibleTypicalItemCount;
			if(maximum >= itemCount)
			{
				maximum = itemCount - 1;
			}
			minimum = maximum - maxVisibleTypicalItemCount;
			if(minimum < 0)
			{
				minimum = 0;
			}
			//for(var i:Int = minimum; i <= maximum; i++)
			var i:Int = minimum;
			while(i <= maximum)
			{
				if(i >= 0 && i < itemCount)
				{
					result[resultLastIndex] = i;
				}
				else if(i < 0)
				{
					result[resultLastIndex] = itemCount + i;
				}
				else if(i >= itemCount)
				{
					result[resultLastIndex] = i - itemCount;
				}
				resultLastIndex++;
				i++;
			}
			return result;
		}
		var secondToLastIndex:Int = itemCount - 2;
		var maxPositionY:Float = scrollY + height;
		var positionY:Float = this._paddingTop;
		var itemHeight:Float;
		//for(i = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			var gap:Float = this._gap;
			if(hasFirstGap && i == 0)
			{
				gap = this._firstGap;
			}
			else if(hasLastGap && i > 0 && i == secondToLastIndex)
			{
				gap = this._lastGap;
			}
			var cachedHeight:Float = getHeightFromCache(i);
			if(cachedHeight != cachedHeight) //isNaN
			{
				itemHeight = calculatedTypicalItemHeight;
			}
			else
			{
				itemHeight = cachedHeight;
			}
			var oldPositionY:Float = positionY;
			positionY += itemHeight + gap;
			if(positionY > scrollY && oldPositionY < maxPositionY)
			{
				result[resultLastIndex] = i;
				resultLastIndex++;
			}

			if(positionY >= maxPositionY)
			{
				break;
			}
		}

		//similar to above, in order to avoid costly destruction and
		//creation of item renderers, we're going to fill in some extra
		//indices
		var resultLength:Int = result.length;
		var visibleItemCountDifference:Int = maxVisibleTypicalItemCount - resultLength;
		if(visibleItemCountDifference > 0 && resultLength > 0)
		{
			//add extra items before the first index
			var firstExistingIndex:Int = result[0];
			var lastIndexToAdd:Int = firstExistingIndex - visibleItemCountDifference;
			if(lastIndexToAdd < 0)
			{
				lastIndexToAdd = 0;
			}
			//for(i = firstExistingIndex - 1; i >= lastIndexToAdd; i--)
			var i:Int = firstExistingIndex - 1;
			while(i >= lastIndexToAdd)
			{
				result.unshift(i);
				i--;
			}
		}
		resultLength = result.length;
		visibleItemCountDifference = maxVisibleTypicalItemCount - resultLength;
		resultLastIndex = resultLength;
		if(visibleItemCountDifference > 0)
		{
			//add extra items after the last index
			var startIndex:Int = (resultLength > 0) ? (result[resultLength - 1] + 1) : 0;
			var endIndex:Int = startIndex + visibleItemCountDifference;
			if(endIndex > itemCount)
			{
				endIndex = itemCount;
			}
			//for(i = startIndex; i < endIndex; i++)
			var i:Int = startIndex;
			while(i < endIndex)
			{
				result[resultLastIndex] = i;
				resultLastIndex++;
				i++;
			}
		}
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function getNearestScrollPositionForIndex(index:Int, scrollX:Float, scrollY:Float, items:Array<DisplayObject>,
		x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		var maxScrollY:Float = this.calculateMaxScrollYOfIndex(index, items, x, y, width, height);

		var itemHeight:Float;
		if(this._useVirtualLayout)
		{
			if(this._hasVariableItemDimensions)
			{
				itemHeight = getHeightFromCache(index);
				if(itemHeight != itemHeight) //isNaN
				{
					itemHeight = this._typicalItem.height;
				}
			}
			else
			{
				itemHeight = this._typicalItem.height;
			}
		}
		else
		{
			itemHeight = items[index].height;
		}

		if(result == null)
		{
			result = new Point();
		}
		result.x = 0;

		var bottomPosition:Float = maxScrollY - (height - itemHeight);
		if(scrollY >= bottomPosition && scrollY <= maxScrollY)
		{
			//keep the current scroll position because the item is already
			//fully visible
			result.y = scrollY;
		}
		else
		{
			var topDifference:Float = Math.abs(maxScrollY - scrollY);
			var bottomDifference:Float = Math.abs(bottomPosition - scrollY);
			if(bottomDifference < topDifference)
			{
				result.y = bottomPosition;
			}
			else
			{
				result.y = maxScrollY;
			}
		}

		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function getScrollPositionForIndex(index:Int, items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		var maxScrollY:Float = this.calculateMaxScrollYOfIndex(index, items, x, y, width, height);

		var itemHeight:Float;
		if(this._useVirtualLayout)
		{
			if(this._hasVariableItemDimensions)
			{
				itemHeight = getHeightFromCache(index);
				if(itemHeight != itemHeight) //isNaN
				{
					itemHeight = this._typicalItem.height;
				}
			}
			else
			{
				itemHeight = this._typicalItem.height;
			}
		}
		else
		{
			itemHeight = items[index].height;
		}

		if(result == null)
		{
			result = new Point();
		}
		result.x = 0;

		if(this._scrollPositionVerticalAlign == VERTICAL_ALIGN_MIDDLE)
		{
			maxScrollY -= Math.round((height - itemHeight) / 2);
		}
		else if(this._scrollPositionVerticalAlign == VERTICAL_ALIGN_BOTTOM)
		{
			maxScrollY -= (height - itemHeight);
		}
		result.y = maxScrollY;

		return result;
	}

	/**
	 * @private
	 */
	private function validateItems(items:Array<DisplayObject>, explicitWidth:Float,
		minWidth:Float, maxWidth:Float, distributedHeight:Float):Void
	{
		//if the alignment is justified, then we want to set the width of
		//each item before validating because setting one dimension may
		//cause the other dimension to change, and that will invalidate the
		//layout if it happens after validation, causing more invalidation
		var isJustified:Bool = this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY;
		var itemCount:Int = items.length;
		//for(var i:Int = 0; i < itemCount; i++)
		var i:Int = 0;
		while(i < itemCount)
		{
			var item:DisplayObject = items[i];
			if(item == null || (Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout))
			{
				i++;
				continue;
			}
			if(isJustified)
			{
				//the alignment is justified, but we don't yet have a width
				//to use, so we need to ensure that we accurately measure
				//the items instead of using an old justified width that may
				//be wrong now!
				item.width = explicitWidth;
				if(Std.is(item, IFeathersControl))
				{
					var feathersItem:IFeathersControl = cast item;
					feathersItem.minWidth = minWidth;
					feathersItem.maxWidth = maxWidth;
				}
			}
			if(this._distributeHeights)
			{
				item.height = distributedHeight;
			}
			if(Std.is(item, IValidating))
			{
				cast(item, IValidating).validate();
			}
			
			i++;
		}
	}

	/**
	 * @private
	 */
	private function prepareTypicalItem(justifyWidth:Float):Void
	{
		if(this._typicalItem == null)
		{
			return;
		}
		if(this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY &&
			justifyWidth == justifyWidth) //!isNaN
		{
			this._typicalItem.width = justifyWidth;
		}
		else if(this._resetTypicalItemDimensionsOnMeasure)
		{
			this._typicalItem.width = this._typicalItemWidth;
		}
		if(this._resetTypicalItemDimensionsOnMeasure)
		{
			this._typicalItem.height = this._typicalItemHeight;
		}
		if(Std.is(this._typicalItem, IValidating))
		{
			cast(this._typicalItem, IValidating).validate();
		}
	}

	/**
	 * @private
	 */
	private function calculateDistributedHeight(items:Array<DisplayObject>, explicitHeight:Float, minHeight:Float, maxHeight:Float):Float
	{
		var itemCount:Int = items.length;
		if(explicitHeight != explicitHeight) //isNaN
		{
			var maxItemHeight:Float = 0;
			//for(var i:Int = 0; i < itemCount; i++)
			for(i in 0 ... itemCount)
			{
				var item:DisplayObject = items[i];
				var itemHeight:Float = item.height;
				if(itemHeight > maxItemHeight)
				{
					maxItemHeight = itemHeight;
				}
			}
			explicitHeight = maxItemHeight * itemCount + this._paddingTop + this._paddingBottom + this._gap * (itemCount - 1);
			var needsRecalculation:Bool = false;
			if(explicitHeight > maxHeight)
			{
				explicitHeight = maxHeight;
				needsRecalculation = true;
			}
			else if(explicitHeight < minHeight)
			{
				explicitHeight = minHeight;
				needsRecalculation = true;
			}
			if(!needsRecalculation)
			{
				return maxItemHeight;
			}
		}
		var availableSpace:Float = explicitHeight - this._paddingTop - this._paddingBottom - this._gap * (itemCount - 1);
		if(itemCount > 1 && this._firstGap == this._firstGap) //!isNaN
		{
			availableSpace += this._gap - this._firstGap;
		}
		if(itemCount > 2 && this._lastGap == this._lastGap) //!isNaN
		{
			availableSpace += this._gap - this._lastGap;
		}
		return availableSpace / itemCount;
	}

	/**
	 * @private
	 */
	private function applyPercentHeights(items:Array<DisplayObject>, explicitHeight:Float, minHeight:Float, maxHeight:Float):Void
	{
		var remainingHeight:Float = explicitHeight;
		this._discoveredItemsCache.splice(0, this._discoveredItemsCache.length);
		var totalExplicitHeight:Float = 0;
		var totalMinHeight:Float = 0;
		var totalPercentHeight:Float = 0;
		var itemCount:Int = items.length;
		var pushIndex:Int = 0;
		var layoutItem:ILayoutDisplayObject;
		var layoutData:VerticalLayoutData;
		var percentHeight:Float;
		var feathersItem:IFeathersControl;
		var needsAnotherPass:Bool = false;
		//for(var i:Int = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = items[i];
			if(Std.is(item, ILayoutDisplayObject))
			{
				layoutItem = cast item;
				if(!layoutItem.includeInLayout)
				{
					continue;
				}
				layoutData = safe_cast(layoutItem.layoutData, VerticalLayoutData);
				if(layoutData != null)
				{
					percentHeight = layoutData.percentHeight;
					if(percentHeight == percentHeight) //!isNaN
					{
						if(Std.is(layoutItem, IFeathersControl))
						{
							feathersItem = cast layoutItem;
							totalMinHeight += feathersItem.minHeight;
						}
						totalPercentHeight += percentHeight;
						this._discoveredItemsCache[pushIndex] = item;
						pushIndex++;
						continue;
					}
				}
			}
			totalExplicitHeight += item.height;
		}
		totalExplicitHeight += this._gap * (itemCount - 1);
		if(this._firstGap == this._firstGap && itemCount > 1)
		{
			totalExplicitHeight += (this._firstGap - this._gap);
		}
		else if(this._lastGap == this._lastGap && itemCount > 2)
		{
			totalExplicitHeight += (this._lastGap - this._gap);
		}
		totalExplicitHeight += this._paddingTop + this._paddingBottom;
		if(totalPercentHeight < 100)
		{
			totalPercentHeight = 100;
		}
		if(remainingHeight != remainingHeight) //isNaN
		{
			remainingHeight = totalExplicitHeight + totalMinHeight;
			if(remainingHeight < minHeight)
			{
				remainingHeight = minHeight;
			}
			else if(remainingHeight > maxHeight)
			{
				remainingHeight = maxHeight;
			}
		}
		remainingHeight -= totalExplicitHeight;
		if(remainingHeight < 0)
		{
			remainingHeight = 0;
		}
		do
		{
			needsAnotherPass = false;
			var percentToPixels:Float = remainingHeight / totalPercentHeight;
			//for(i = 0; i < pushIndex; i++)
			for(i in 0 ... pushIndex)
			{
				layoutItem = safe_cast(this._discoveredItemsCache[i], ILayoutDisplayObject);
				if(layoutItem == null)
				{
					continue;
				}
				layoutData = cast(layoutItem.layoutData, VerticalLayoutData);
				percentHeight = layoutData.percentHeight;
				var itemHeight:Float = percentToPixels * percentHeight;
				if(Std.is(layoutItem, IFeathersControl))
				{
					feathersItem = cast layoutItem;
					var itemMinHeight:Float = feathersItem.minHeight;
					if(itemHeight < itemMinHeight)
					{
						itemHeight = itemMinHeight;
						remainingHeight -= itemHeight;
						totalPercentHeight -= percentHeight;
						this._discoveredItemsCache[i] = null;
						needsAnotherPass = true;
					}
					else
					{
						var itemMaxHeight:Float = feathersItem.maxHeight;
						if(itemHeight > itemMaxHeight)
						{
							itemHeight = itemMaxHeight;
							remainingHeight -= itemHeight;
							totalPercentHeight -= percentHeight;
							this._discoveredItemsCache[i] = null;
							needsAnotherPass = true;
						}
					}
				}
				layoutItem.height = itemHeight;
				if(Std.is(layoutItem, IValidating))
				{
					//changing the height of the item may cause its width
					//to change, so we need to validate. the width is needed
					//for measurement.
					cast(layoutItem, IValidating).validate();
				}
			}
		}
		while(needsAnotherPass);
		this._discoveredItemsCache.splice(0, this._discoveredItemsCache.length);
	}

	/**
	 * @private
	 */
	private function calculateMaxScrollYOfIndex(index:Int, items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float):Float
	{
		var calculatedTypicalItemWidth:Float;
		var calculatedTypicalItemHeight:Float = Math.NaN;
		if(this._useVirtualLayout)
		{
			this.prepareTypicalItem(width - this._paddingLeft - this._paddingRight);
			calculatedTypicalItemWidth = this._typicalItem != null ? this._typicalItem.width : 0;
			calculatedTypicalItemHeight = this._typicalItem != null ? this._typicalItem.height : 0;
		}

		var hasFirstGap:Bool = this._firstGap == this._firstGap; //!isNaN
		var hasLastGap:Bool = this._lastGap == this._lastGap; //!isNaN
		var positionY:Float = y + this._paddingTop;
		var lastHeight:Float = 0;
		var gap:Float = this._gap;
		var startIndexOffset:Int = 0;
		var endIndexOffset:Float = 0;
		var itemCount:Int = items.length;
		var totalItemCount:Int = itemCount;
		if(this._useVirtualLayout && !this._hasVariableItemDimensions)
		{
			totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
			if(index < this._beforeVirtualizedItemCount)
			{
				//this makes it skip the loop below
				startIndexOffset = index + 1;
				lastHeight = calculatedTypicalItemHeight;
				gap = this._gap;
			}
			else
			{
				startIndexOffset = this._beforeVirtualizedItemCount;
				endIndexOffset = index - items.length - this._beforeVirtualizedItemCount + 1;
				if(endIndexOffset < 0)
				{
					endIndexOffset = 0;
				}
				positionY += (endIndexOffset * (calculatedTypicalItemHeight + this._gap));
			}
			positionY += (startIndexOffset * (calculatedTypicalItemHeight + this._gap));
		}
		index -= (startIndexOffset + Std.int(endIndexOffset));
		var secondToLastIndex:Int = totalItemCount - 2;
		//for(var i:Int = 0; i <= index; i++)
		var i:Int = 0;
		while(i <= index)
		{
			var item:DisplayObject = items[i];
			var iNormalized:Int = i + startIndexOffset;
			
			var cachedHeight:Float = Math.NaN;
			
			if(hasFirstGap && iNormalized == 0)
			{
				gap = this._firstGap;
			}
			else if(hasLastGap && iNormalized > 0 && iNormalized == secondToLastIndex)
			{
				gap = this._lastGap;
			}
			else
			{
				gap = this._gap;
			}
			if(this._useVirtualLayout && this._hasVariableItemDimensions)
			{
				cachedHeight = getHeightFromCache(iNormalized);
			}
			if(this._useVirtualLayout && item == null)
			{
				if(!this._hasVariableItemDimensions ||
					cachedHeight != cachedHeight) //isNaN
				{
					lastHeight = calculatedTypicalItemHeight;
				}
				else
				{
					lastHeight = cachedHeight;
				}
			}
			else
			{
				var itemHeight:Float = item.height;
				if(this._useVirtualLayout)
				{
					if(this._hasVariableItemDimensions)
					{
						if(itemHeight != cachedHeight)
						{
							this._heightCache[iNormalized] = itemHeight;
							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else if(calculatedTypicalItemHeight >= 0)
					{
						item.height = itemHeight = calculatedTypicalItemHeight;
					}
				}
				lastHeight = itemHeight;
			}
			positionY += lastHeight + gap;
			
			i++;
		}
		positionY -= (lastHeight + gap);
		return positionY;
	}
	
	private function getHeightFromCache(index:Int):Float
	{
		if (index >= this._heightCache.length) return Math.NaN;
		var itemHeight:Null<Float> = this._heightCache[index];
		return itemHeight != null ? itemHeight : Math.NaN;
	}
}
