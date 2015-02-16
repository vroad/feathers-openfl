/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IFeathersControl;
import feathers.core.IValidating;

import openfl.errors.IllegalOperationError;
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
 * Positions items from top to bottom in a single column.
 *
 * @see http://wiki.starling-framework.org/feathers/vertical-layout
 */
class VerticalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
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
	public function VerticalLayout()
	{
	}

	/**
	 * @private
	 */
	private var _heightCache:Array = [];

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
			return;
		}
		this._gap = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _firstGap:Float = NaN;

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
			return;
		}
		this._firstGap = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _lastGap:Float = NaN;

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
			return;
		}
		this._lastGap = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._paddingTop = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._paddingRight = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._paddingBottom = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._paddingLeft = value;
		this.dispatchEventWith(Event.CHANGE);
	}


	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

	[Inspectable(type="String",enumeration="top,middle,bottom")]
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
			return;
		}
		this._verticalAlign = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

	[Inspectable(type="String",enumeration="left,center,right,justify")]
	/**
	 * The alignment of the items horizontally, on the x-axis.
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
			return;
		}
		this._horizontalAlign = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._useVirtualLayout = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _hasVariableItemDimensions:Bool = false;

	/**
	 * When the layout is virtualized, and this value is true, the items may
	 * have variable width values. If false, the items will all share the
	 * same width value with the typical item.
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
			return;
		}
		this._hasVariableItemDimensions = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._distributeHeights = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _manageVisibility:Bool = false;

	/**
	 * Determines if items will be set invisible if they are outside the
	 * view port. If <code>true</code>, you will not be able to manually
	 * change the <code>visible</code> property of any items in the layout.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.0. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>.
	 * Originally, the <code>manageVisibility</code> property could be used
	 * to improve performance of non-virtual layouts by hiding items that
	 * were outside the view port. However, other performance improvements
	 * have made it so that setting <code>manageVisibility</code> can now
	 * sometimes hurt performance instead of improving it.</p>
	 *
	 * @default false
	 */
	public var manageVisibility(get, set):Bool;
	public function get_manageVisibility():Bool
	{
		return this._manageVisibility;
	}

	/**
	 * @private
	 */
	public function set_manageVisibility(value:Bool):Bool
	{
		if(this._manageVisibility == value)
		{
			return;
		}
		this._manageVisibility = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._beforeVirtualizedItemCount = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._afterVirtualizedItemCount = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._typicalItem = value;
		this.dispatchEventWith(Event.CHANGE);
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
			return;
		}
		this._resetTypicalItemDimensionsOnMeasure = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _typicalItemWidth:Float = NaN;

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
			return;
		}
		this._typicalItemWidth = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _typicalItemHeight:Float = NaN;

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
			return;
		}
		this._typicalItemHeight = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _scrollPositionVerticalAlign:String = VERTICAL_ALIGN_MIDDLE;

	[Inspectable(type="String",enumeration="top,middle,bottom")]
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
	}

	/**
	 * @inheritDoc
	 */
	public var requiresLayoutOnScroll(get, set):Bool;
	public function get_requiresLayoutOnScroll():Bool
	{
		return this._manageVisibility || this._useVirtualLayout;
	}

	/**
	 * @inheritDoc
	 */
	public function layout(items:Array<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
	{
		var scrollX:Float = viewPortBounds ? viewPortBounds.scrollX : 0;
		var scrollY:Float = viewPortBounds ? viewPortBounds.scrollY : 0;
		var boundsX:Float = viewPortBounds ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds ? viewPortBounds.maxWidth : Float.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds ? viewPortBounds.maxHeight : Float.POSITIVE_INFINITY;
		var explicitWidth:Float = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
		var explicitHeight:Float = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

		if(this._useVirtualLayout)
		{
			this.prepareTypicalItem(explicitWidth - this._paddingLeft - this._paddingRight);
			var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;
		}

		if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeHeights ||
			this._horizontalAlign != HORIZONTAL_ALIGN_JUSTIFY ||
			explicitWidth != explicitWidth) //isNaN
		{
			this.validateItems(items, explicitWidth - this._paddingLeft - this._paddingRight, explicitHeight);
		}

		if(!this._useVirtualLayout)
		{
			this.applyPercentHeights(items, explicitHeight, minHeight, maxHeight);
		}

		var distributedHeight:Float;
		if(this._distributeHeights)
		{
			distributedHeight = this.calculateDistributedHeight(items, explicitHeight, minHeight, maxHeight);
		}
		var hasDistributedHeight:Bool = distributedHeight == distributedHeight; //!isNaN

		this._discoveredItemsCache.length = 0;
		var hasFirstGap:Bool = this._firstGap == this._firstGap; //!isNaN
		var hasLastGap:Bool = this._lastGap == this._lastGap; //!isNaN
		var maxItemWidth:Float = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
		var positionY:Float = boundsY + this._paddingTop;
		var indexOffset:Int = 0;
		var itemCount:Int = items.length;
		var totalItemCount:Int = itemCount;
		if(this._useVirtualLayout && !this._hasVariableItemDimensions)
		{
			totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
			indexOffset = this._beforeVirtualizedItemCount;
			positionY += (this._beforeVirtualizedItemCount * (calculatedTypicalItemHeight + this._gap));
			if(hasFirstGap && this._beforeVirtualizedItemCount > 0)
			{
				positionY = positionY - this._gap + this._firstGap;
			}
		}
		var secondToLastIndex:Int = totalItemCount - 2;
		var discoveredItemsCacheLastIndex:Int = 0;
		for(var i:Int = 0; i < itemCount; i++)
		{
			var item:DisplayObject = items[i];
			var iNormalized:Int = i + indexOffset;
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
				var cachedHeight:Float = this._heightCache[iNormalized];
			}
			if(this._useVirtualLayout && !item)
			{
				if(!this._hasVariableItemDimensions ||
					cachedHeight != cachedHeight) //isNaN
				{
					positionY += calculatedTypicalItemHeight + gap;
				}
				else
				{
					positionY += cachedHeight + gap;
				}
			}
			else
			{
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				item.y = item.pivotY + positionY;
				var itemWidth:Float = item.width;
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
							this._heightCache[iNormalized] = itemHeight;
							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else if(calculatedTypicalItemHeight >= 0)
					{
						item.height = itemHeight = calculatedTypicalItemHeight;
					}
				}
				positionY += itemHeight + gap;
				if(itemWidth > maxItemWidth)
				{
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
			positionY += (this._afterVirtualizedItemCount * (calculatedTypicalItemHeight + this._gap));
			if(hasLastGap && this._afterVirtualizedItemCount > 0)
			{
				positionY = positionY - this._gap + this._lastGap;
			}
		}

		var discoveredItems:Array<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
		var totalWidth:Float = maxItemWidth + this._paddingLeft + this._paddingRight;
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
		var discoveredItemCount:Int = discoveredItems.length;

		var totalHeight:Float = positionY - this._gap + this._paddingBottom - boundsY;
		var availableHeight:Float = explicitHeight;
		if(availableHeight != availableHeight) //isNaN
		{
			availableHeight = totalHeight;
			if(availableHeight < minHeight)
			{
				availableHeight = minHeight;
			}
			else if(availableHeight > maxHeight)
			{
				availableHeight = maxHeight;
			}
		}
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
				for(i = 0; i < discoveredItemCount; i++)
				{
					item = discoveredItems[i];
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					item.y += verticalAlignOffsetY;
				}
			}
		}

		for(i = 0; i < discoveredItemCount; i++)
		{
			item = discoveredItems[i];
			var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
			if(layoutItem && !layoutItem.includeInLayout)
			{
				continue;
			}
			if(this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY)
			{
				item.x = item.pivotX + boundsX + this._paddingLeft;
				item.width = availableWidth - this._paddingLeft - this._paddingRight;
			}
			else
			{
				if(layoutItem)
				{
					var layoutData:VerticalLayoutData = layoutItem.layoutData as VerticalLayoutData;
					if(layoutData)
					{
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
							if(item is IFeathersControl)
							{
								var feathersItem:IFeathersControl = IFeathersControl(item);
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
				switch(this._horizontalAlign)
				{
					case HORIZONTAL_ALIGN_RIGHT:
					{
						item.x = item.pivotX + boundsX + availableWidth - this._paddingRight - item.width;
						break;
					}
					case HORIZONTAL_ALIGN_CENTER:
					{
						item.x = item.pivotX + boundsX + this._paddingLeft + Math.round((availableWidth - this._paddingLeft - this._paddingRight - item.width) / 2);
						break;
					}
					default: //left
					{
						item.x = item.pivotX + boundsX + this._paddingLeft;
					}
				}
			}
			if(this.manageVisibility)
			{
				item.visible = ((item.y - item.pivotY + item.height) >= (boundsY + scrollY)) && ((item.y - item.pivotY) < (scrollY + availableHeight));
			}
		}

		this._discoveredItemsCache.length = 0;

		if(!result)
		{
			result = new LayoutBoundsResult();
		}
		result.contentWidth = this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY ? availableWidth : totalWidth;
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
		if(!result)
		{
			result = new Point();
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.")
		}

		var explicitWidth:Float = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
		var explicitHeight:Float = viewPortBounds ? viewPortBounds.explicitHeight : NaN;
		var needsWidth:Bool = explicitWidth != explicitWidth; //isNaN
		var needsHeight:Bool = explicitHeight != explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			result.x = explicitWidth;
			result.y = explicitHeight;
			return result;
		}
		var minWidth:Float = viewPortBounds ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds ? viewPortBounds.maxWidth : Float.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds ? viewPortBounds.maxHeight : Float.POSITIVE_INFINITY;

		this.prepareTypicalItem(explicitWidth - this._paddingLeft - this._paddingRight);
		var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;

		var hasFirstGap:Bool = this._firstGap == this._firstGap; //!isNaN
		var hasLastGap:Bool = this._lastGap == this._lastGap; //!isNaN
		var positionY:Float;
		if(this._distributeHeights)
		{
			positionY = (calculatedTypicalItemHeight + this._gap) * itemCount;
		}
		else
		{
			positionY = 0;
			var maxItemWidth:Float = calculatedTypicalItemWidth;
			if(!this._hasVariableItemDimensions)
			{
				positionY += ((calculatedTypicalItemHeight + this._gap) * itemCount);
			}
			else
			{
				for(var i:Int = 0; i < itemCount; i++)
				{
					var cachedHeight:Float = this._heightCache[i];
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
			var resultHeight:Float = positionY + this._paddingTop + this._paddingBottom;
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
		this._heightCache.length = 0;
	}

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		delete this._heightCache[index];
		if(item)
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
		var heightValue:* = item ? item.height : undefined;
		this._heightCache.splice(index, 0, heightValue);
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
	public function getVisibleIndicesAtScrollPosition(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Array<int> = null):Array<int>
	{
		if(result)
		{
			result.length = 0;
		}
		else
		{
			result = new Array();
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.")
		}

		this.prepareTypicalItem(width - this._paddingLeft - this._paddingRight);
		var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;

		var hasFirstGap:Bool = this._firstGap == this._firstGap; //!isNaN
		var hasLastGap:Bool = this._lastGap == this._lastGap; //!isNaN
		var resultLastIndex:Int = 0;
		var visibleTypicalItemCount:Int = Math.ceil(height / (calculatedTypicalItemHeight + this._gap));
		if(!this._hasVariableItemDimensions)
		{
			//this case can be optimized because we know that every item has
			//the same height
			var indexOffset:Int = 0;
			var totalItemHeight:Float = itemCount * (calculatedTypicalItemHeight + this._gap) - this._gap;
			if(hasFirstGap && itemCount > 1)
			{
				totalItemHeight = totalItemHeight - this._gap + this._firstGap;
			}
			if(hasLastGap && itemCount > 2)
			{
				totalItemHeight = totalItemHeight - this._gap + this._lastGap;
			}
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
			var minimum:Int = (scrollY - this._paddingTop) / (calculatedTypicalItemHeight + this._gap);
			if(minimum < 0)
			{
				minimum = 0;
			}
			minimum -= indexOffset;
			//if we're scrolling beyond the final item, we should keep the
			//indices consistent so that items aren't destroyed and
			//recreated unnecessarily
			var maximum:Int = minimum + visibleTypicalItemCount;
			if(maximum >= itemCount)
			{
				maximum = itemCount - 1;
			}
			minimum = maximum - visibleTypicalItemCount;
			if(minimum < 0)
			{
				minimum = 0;
			}
			for(var i:Int = minimum; i <= maximum; i++)
			{
				result[resultLastIndex] = i;
				resultLastIndex++;
			}
			return result;
		}
		var secondToLastIndex:Int = itemCount - 2;
		var maxPositionY:Float = scrollY + height;
		var positionY:Float = this._paddingTop;
		for(i = 0; i < itemCount; i++)
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
			var cachedHeight:Float = this._heightCache[i];
			if(cachedHeight != cachedHeight) //isNaN
			{
				var itemHeight:Float = calculatedTypicalItemHeight;
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
		var visibleItemCountDifference:Int = visibleTypicalItemCount - resultLength;
		if(visibleItemCountDifference > 0 && resultLength > 0)
		{
			//add extra items before the first index
			var firstExistingIndex:Int = result[0];
			var lastIndexToAdd:Int = firstExistingIndex - visibleItemCountDifference;
			if(lastIndexToAdd < 0)
			{
				lastIndexToAdd = 0;
			}
			for(i = firstExistingIndex - 1; i >= lastIndexToAdd; i--)
			{
				result.unshift(i);
			}
		}
		resultLength = result.length;
		visibleItemCountDifference = visibleTypicalItemCount - resultLength;
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
			for(i = startIndex; i < endIndex; i++)
			{
				result[resultLastIndex] = i;
				resultLastIndex++;
			}
		}
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function getScrollPositionForIndex(index:Int, items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}

		if(this._useVirtualLayout)
		{
			this.prepareTypicalItem(width - this._paddingLeft - this._paddingRight);
			var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;
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
		index -= (startIndexOffset + endIndexOffset);
		var secondToLastIndex:Int = totalItemCount - 2;
		for(var i:Int = 0; i <= index; i++)
		{
			var item:DisplayObject = items[i];
			var iNormalized:Int = i + startIndexOffset;
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
				var cachedHeight:Float = this._heightCache[iNormalized];
			}
			if(this._useVirtualLayout && !item)
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
		}
		positionY -= (lastHeight + gap);
		if(this._scrollPositionVerticalAlign == VERTICAL_ALIGN_MIDDLE)
		{
			positionY -= Math.round((height - lastHeight) / 2);
		}
		else if(this._scrollPositionVerticalAlign == VERTICAL_ALIGN_BOTTOM)
		{
			positionY -= (height - lastHeight);
		}
		result.x = 0;
		result.y = positionY;

		return result;
	}

	/**
	 * @private
	 */
	private function validateItems(items:Array<DisplayObject>, justifyWidth:Float, distributedHeight:Float):Void
	{
		//if the alignment is justified, then we want to set the width of
		//each item before validating because setting one dimension may
		//cause the other dimension to change, and that will invalidate the
		//layout if it happens after validation, causing more invalidation
		var mustSetJustifyWidth:Bool = this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY &&
			justifyWidth == justifyWidth; //!isNaN
		var itemCount:Int = items.length;
		for(var i:Int = 0; i < itemCount; i++)
		{
			var item:DisplayObject = items[i];
			if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
			{
				continue;
			}
			if(mustSetJustifyWidth)
			{
				item.width = justifyWidth;
			}
			if(this._distributeHeights)
			{
				item.height = distributedHeight;
			}
			if(item is IValidating)
			{
				IValidating(item).validate()
			}
		}
	}

	/**
	 * @private
	 */
	private function prepareTypicalItem(justifyWidth:Float):Void
	{
		if(!this._typicalItem)
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
		if(this._typicalItem is IValidating)
		{
			IValidating(this._typicalItem).validate();
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
			for(var i:Int = 0; i < itemCount; i++)
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
		this._discoveredItemsCache.length = 0;
		var totalExplicitHeight:Float = 0;
		var totalMinHeight:Float = 0;
		var totalPercentHeight:Float = 0;
		var itemCount:Int = items.length;
		var pushIndex:Int = 0;
		for(var i:Int = 0; i < itemCount; i++)
		{
			var item:DisplayObject = items[i];
			if(item is ILayoutDisplayObject)
			{
				var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				if(!layoutItem.includeInLayout)
				{
					continue;
				}
				var layoutData:VerticalLayoutData = layoutItem.layoutData as VerticalLayoutData;
				if(layoutData)
				{
					var percentHeight:Float = layoutData.percentHeight;
					if(percentHeight == percentHeight) //!isNaN
					{
						if(layoutItem is IFeathersControl)
						{
							var feathersItem:IFeathersControl = IFeathersControl(layoutItem);
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
			var needsAnotherPass:Bool = false;
			var percentToPixels:Float = remainingHeight / totalPercentHeight;
			for(i = 0; i < pushIndex; i++)
			{
				layoutItem = ILayoutDisplayObject(this._discoveredItemsCache[i]);
				if(!layoutItem)
				{
					continue;
				}
				layoutData = VerticalLayoutData(layoutItem.layoutData);
				percentHeight = layoutData.percentHeight;
				var itemHeight:Float = percentToPixels * percentHeight;
				if(layoutItem is IFeathersControl)
				{
					feathersItem = IFeathersControl(layoutItem);
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
			}
		}
		while(needsAnotherPass)
		this._discoveredItemsCache.length = 0;
	}
}
