/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IFeathersControl;
import feathers.core.IValidating;

import flash.errors.IllegalOperationError;
import flash.geom.Point;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Dispatched when a property of the layout changes, indicating that a
 * redraw is probably needed.
 *
 * @eventType starling.events.Event.CHANGE
 */
[Event(name="change",type="starling.events.Event")]

/**
 * Positions items from left to right in a single row.
 *
 * @see http://wiki.starling-framework.org/feathers/horizontal-layout
 */
class HorizontalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
{
	/**
	 * The items will be aligned to the top of the bounds.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * The items will be aligned to the middle of the bounds.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * The items will be aligned to the bottom of the bounds.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * The items will fill the height of the bounds.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the left.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the center.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the right.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * Constructor.
	 */
	public function HorizontalLayout()
	{
	}

	/**
	 * @private
	 */
	private var _widthCache:Array = [];

	/**
	 * @private
	 */
	private var _discoveredItemsCache:Vector.<DisplayObject> = new <DisplayObject>[];

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * The space, in pixels, between items.
	 *
	 * @default 0
	 */
	public function get gap():Float
	{
		return this._gap;
	}

	/**
	 * @private
	 */
	public function set gap(value:Float):Void
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
	public function get firstGap():Float
	{
		return this._firstGap;
	}

	/**
	 * @private
	 */
	public function set firstGap(value:Float):Void
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
	public function get lastGap():Float
	{
		return this._lastGap;
	}

	/**
	 * @private
	 */
	public function set lastGap(value:Float):Void
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
	public function get padding():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set padding(value:Float):Void
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
	 * The minimum space, in pixels, above the items.
	 *
	 * @default 0
	 */
	public function get paddingTop():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set paddingTop(value:Float):Void
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
	 * The space, in pixels, that appears to the right, after the last item.
	 *
	 * @default 0
	 */
	public function get paddingRight():Float
	{
		return this._paddingRight;
	}

	/**
	 * @private
	 */
	public function set paddingRight(value:Float):Void
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
	 * The minimum space, in pixels, above the items.
	 *
	 * @default 0
	 */
	public function get paddingBottom():Float
	{
		return this._paddingBottom;
	}

	/**
	 * @private
	 */
	public function set paddingBottom(value:Float):Void
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
	 * The space, in pixels, that appears to the left, before the first
	 * item.
	 *
	 * @default 0
	 */
	public function get paddingLeft():Float
	{
		return this._paddingLeft;
	}

	/**
	 * @private
	 */
	public function set paddingLeft(value:Float):Void
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

	[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
	/**
	 * The alignment of the items vertically, on the y-axis.
	 *
	 * @default HorizontalLayout.VERTICAL_ALIGN_TOP
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #VERTICAL_ALIGN_JUSTIFY
	 */
	public function get verticalAlign():String
	{
		return this._verticalAlign;
	}

	/**
	 * @private
	 */
	public function set verticalAlign(value:String):Void
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

	[Inspectable(type="String",enumeration="left,center,right")]
	/**
	 * If the total item width is less than the bounds, the positions of
	 * the items can be aligned horizontally.
	 *
	 * @default HorizontalLayout.HORIZONTAL_ALIGN_LEFT
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 */
	public function get horizontalAlign():String
	{
		return this._horizontalAlign;
	}

	/**
	 * @private
	 */
	public function set horizontalAlign(value:String):Void
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
	private var _useVirtualLayout:Boolean = true;

	/**
	 * @inheritDoc
	 *
	 * @default true
	 */
	public function get useVirtualLayout():Boolean
	{
		return this._useVirtualLayout;
	}

	/**
	 * @private
	 */
	public function set useVirtualLayout(value:Boolean):Void
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
	private var _hasVariableItemDimensions:Boolean = false;

	/**
	 * When the layout is virtualized, and this value is true, the items may
	 * have variable height values. If false, the items will all share the
	 * same height value with the typical item.
	 *
	 * @default false
	 */
	public function get hasVariableItemDimensions():Boolean
	{
		return this._hasVariableItemDimensions;
	}

	/**
	 * @private
	 */
	public function set hasVariableItemDimensions(value:Boolean):Void
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
	private var _distributeWidths:Boolean = false;

	/**
	 * Distributes the width of the view port equally to each item. If the
	 * view port width needs to be measured, the largest item's width will
	 * be used for all items, subject to any specified minimum and maximum
	 * width values.
	 *
	 * @default false
	 */
	public function get distributeWidths():Boolean
	{
		return this._distributeWidths;
	}

	/**
	 * @private
	 */
	public function set distributeWidths(value:Boolean):Void
	{
		if(this._distributeWidths == value)
		{
			return;
		}
		this._distributeWidths = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _manageVisibility:Boolean = false;

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
	public function get manageVisibility():Boolean
	{
		return this._manageVisibility;
	}

	/**
	 * @private
	 */
	public function set manageVisibility(value:Boolean):Void
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
	public function get beforeVirtualizedItemCount():Int
	{
		return this._beforeVirtualizedItemCount;
	}

	/**
	 * @private
	 */
	public function set beforeVirtualizedItemCount(value:Int):Void
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
	public function get afterVirtualizedItemCount():Int
	{
		return this._afterVirtualizedItemCount;
	}

	/**
	 * @private
	 */
	public function set afterVirtualizedItemCount(value:Int):Void
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
	public function get typicalItem():DisplayObject
	{
		return this._typicalItem;
	}

	/**
	 * @private
	 */
	public function set typicalItem(value:DisplayObject):Void
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
	private var _resetTypicalItemDimensionsOnMeasure:Boolean = false;

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
	public function get resetTypicalItemDimensionsOnMeasure():Boolean
	{
		return this._resetTypicalItemDimensionsOnMeasure;
	}

	/**
	 * @private
	 */
	public function set resetTypicalItemDimensionsOnMeasure(value:Boolean):Void
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
	 * pass a valid <code>Number</code> value, the typical item's width will
	 * be set to a fixed size. May be used in combination with
	 * <code>typicalItemHeight</code>.</p>
	 *
	 * @default NaN
	 *
	 * @see #resetTypicalItemDimensionsOnMeasure
	 * @see #typicalItemHeight
	 * @see #typicalItem
	 */
	public function get typicalItemWidth():Float
	{
		return this._typicalItemWidth;
	}

	/**
	 * @private
	 */
	public function set typicalItemWidth(value:Float):Void
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
	 * pass a valid <code>Number</code> value, the typical item's height will
	 * be set to a fixed size. May be used in combination with
	 * <code>typicalItemWidth</code>.</p>
	 *
	 * @default NaN
	 *
	 * @see #resetTypicalItemDimensionsOnMeasure
	 * @see #typicalItemWidth
	 * @see #typicalItem
	 */
	public function get typicalItemHeight():Float
	{
		return this._typicalItemHeight;
	}

	/**
	 * @private
	 */
	public function set typicalItemHeight(value:Float):Void
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
	private var _scrollPositionHorizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

	[Inspectable(type="String",enumeration="left,center,right")]
	/**
	 * When the scroll position is calculated for an item, an attempt will
	 * be made to align the item to this position.
	 *
	 * @default HorizontalLayout.HORIZONTAL_ALIGN_CENTER
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 */
	public function get scrollPositionHorizontalAlign():String
	{
		return this._scrollPositionHorizontalAlign;
	}

	/**
	 * @private
	 */
	public function set scrollPositionHorizontalAlign(value:String):Void
	{
		this._scrollPositionHorizontalAlign = value;
	}

	/**
	 * @inheritDoc
	 */
	public function get requiresLayoutOnScroll():Boolean
	{
		return this._manageVisibility || this._useVirtualLayout;
	}

	/**
	 * @inheritDoc
	 */
	public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
	{
		var scrollX:Float = viewPortBounds ? viewPortBounds.scrollX : 0;
		var scrollY:Float = viewPortBounds ? viewPortBounds.scrollY : 0;
		var boundsX:Float = viewPortBounds ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
		var explicitWidth:Float = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
		var explicitHeight:Float = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

		if(this._useVirtualLayout)
		{
			this.prepareTypicalItem(explicitHeight - this._paddingTop - this._paddingBottom);
			var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;
		}

		if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeWidths ||
			this._verticalAlign != VERTICAL_ALIGN_JUSTIFY ||
			explicitHeight !== explicitHeight) //isNaN
		{
			this.validateItems(items, explicitHeight - this._paddingTop - this._paddingBottom, explicitWidth);
		}

		if(!this._useVirtualLayout)
		{
			this.applyPercentWidths(items, explicitWidth, minWidth, maxWidth);
		}

		var distributedWidth:Float;
		if(this._distributeWidths)
		{
			distributedWidth = this.calculateDistributedWidth(items, explicitWidth, minWidth, maxWidth);
		}
		var hasDistributedWidth:Boolean = distributedWidth === distributedWidth; //!isNaN

		this._discoveredItemsCache.length = 0;
		var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
		var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
		var maxItemHeight:Float = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
		var positionX:Float = boundsX + this._paddingLeft;
		var itemCount:Int = items.length;
		var totalItemCount:Int = itemCount;
		if(this._useVirtualLayout && !this._hasVariableItemDimensions)
		{
			totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
			positionX += (this._beforeVirtualizedItemCount * (calculatedTypicalItemWidth + this._gap));
			if(hasFirstGap && this._beforeVirtualizedItemCount > 0)
			{
				positionX = positionX - this._gap + this._firstGap;
			}
		}
		var secondToLastIndex:Int = totalItemCount - 2;
		var discoveredItemsCacheLastIndex:Int = 0;
		for(var i:Int = 0; i < itemCount; i++)
		{
			var item:DisplayObject = items[i];
			var iNormalized:Int = i + this._beforeVirtualizedItemCount;
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
				var cachedWidth:Float = this._widthCache[iNormalized];
			}
			if(this._useVirtualLayout && !item)
			{
				if(!this._hasVariableItemDimensions ||
					cachedWidth !== cachedWidth) //isNaN
				{
					positionX += calculatedTypicalItemWidth + gap;
				}
				else
				{
					positionX += cachedWidth + gap;
				}
			}
			else
			{
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				item.x = item.pivotX + positionX;
				var itemWidth:Float;
				if(hasDistributedWidth)
				{
					item.width = itemWidth = distributedWidth;
				}
				else
				{
					itemWidth = item.width;
				}
				var itemHeight:Float = item.height;
				if(this._useVirtualLayout)
				{
					if(this._hasVariableItemDimensions)
					{
						if(itemWidth != cachedWidth)
						{
							this._widthCache[iNormalized] = itemWidth;
							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else if(calculatedTypicalItemWidth >= 0)
					{
						item.width = itemWidth = calculatedTypicalItemWidth;
					}
				}
				positionX += itemWidth + gap;
				if(itemHeight > maxItemHeight)
				{
					maxItemHeight = itemHeight;
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
			positionX += (this._afterVirtualizedItemCount * (calculatedTypicalItemWidth + this._gap));
			if(hasLastGap && this._afterVirtualizedItemCount > 0)
			{
				positionX = positionX - this._gap + this._lastGap;
			}
		}

		var discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
		var discoveredItemCount:Int = discoveredItems.length;

		var totalHeight:Float = maxItemHeight + this._paddingTop + this._paddingBottom;
		var availableHeight:Float = explicitHeight;
		if(availableHeight !== availableHeight) //isNaN
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
		var totalWidth:Float = positionX - this._gap + this._paddingRight - boundsX;
		var availableWidth:Float = explicitWidth;
		if(availableWidth !== availableWidth) //isNaN
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

		if(totalWidth < availableWidth)
		{
			var horizontalAlignOffsetX:Float = 0;
			if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				horizontalAlignOffsetX = availableWidth - totalWidth;
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
			{
				horizontalAlignOffsetX = Math.round((availableWidth - totalWidth) / 2);
			}
			if(horizontalAlignOffsetX != 0)
			{
				for(i = 0; i < discoveredItemCount; i++)
				{
					item = discoveredItems[i];
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					item.x += horizontalAlignOffsetX;
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
			if(this._verticalAlign == VERTICAL_ALIGN_JUSTIFY)
			{
				item.y = item.pivotY + boundsY + this._paddingTop;
				item.height = availableHeight - this._paddingTop - this._paddingBottom;
			}
			else
			{
				if(layoutItem)
				{
					var layoutData:HorizontalLayoutData = layoutItem.layoutData as HorizontalLayoutData;
					if(layoutData)
					{
						var percentHeight:Float = layoutData.percentHeight;
						if(percentHeight === percentHeight) //!isNaN
						{
							if(percentHeight < 0)
							{
								percentHeight = 0;
							}
							if(percentHeight > 100)
							{
								percentHeight = 100;
							}
							itemHeight = percentHeight * (availableHeight - this._paddingTop - this._paddingBottom) / 100;
							if(item is IFeathersControl)
							{
								var feathersItem:IFeathersControl = IFeathersControl(item);
								var itemMinHeight:Float = feathersItem.minHeight;
								if(itemHeight < itemMinHeight)
								{
									itemHeight = itemMinHeight;
								}
								else
								{
									var itemMaxHeight:Float = feathersItem.maxHeight;
									if(itemHeight > itemMaxHeight)
									{
										itemHeight = itemMaxHeight;
									}
								}
							}
							item.height = itemHeight;
						}
					}
				}
				switch(this._verticalAlign)
				{
					case VERTICAL_ALIGN_BOTTOM:
					{
						item.y = item.pivotY + boundsY + availableHeight - this._paddingBottom - item.height;
						break;
					}
					case VERTICAL_ALIGN_MIDDLE:
					{
						item.y = item.pivotY + boundsY + this._paddingTop + Math.round((availableHeight - this._paddingTop - this._paddingBottom - item.height) / 2);
						break;
					}
					default: //top
					{
						item.y = item.pivotY + boundsY + this._paddingTop;
					}
				}
			}
			if(this.manageVisibility)
			{
				item.visible = ((item.x - item.pivotX + item.width) >= (boundsX + scrollX)) && ((item.x - item.pivotX) < (scrollX + availableWidth));
			}
		}
		this._discoveredItemsCache.length = 0;

		if(!result)
		{
			result = new LayoutBoundsResult();
		}
		result.contentWidth = totalWidth;
		result.contentHeight = this._verticalAlign == VERTICAL_ALIGN_JUSTIFY ? availableHeight : totalHeight;
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
		var needsWidth:Boolean = explicitWidth !== explicitWidth; //isNaN
		var needsHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			result.x = explicitWidth;
			result.y = explicitHeight;
			return result;
		}
		var minWidth:Float = viewPortBounds ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;

		this.prepareTypicalItem(explicitHeight - this._paddingTop - this._paddingBottom);
		var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;

		var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
		var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
		var positionX:Float;
		if(this._distributeWidths)
		{
			positionX = (calculatedTypicalItemWidth + this._gap) * itemCount;
		}
		else
		{
			positionX = 0;
			var maxItemHeight:Float = calculatedTypicalItemHeight;
			if(!this._hasVariableItemDimensions)
			{
				positionX += ((calculatedTypicalItemWidth + this._gap) * itemCount);
			}
			else
			{
				for(var i:Int = 0; i < itemCount; i++)
				{
					var cachedWidth:Float = this._widthCache[i];
					if(cachedWidth !== cachedWidth) //isNaN
					{
						positionX += calculatedTypicalItemWidth + this._gap;
					}
					else
					{
						positionX += cachedWidth + this._gap;
					}
				}
			}
		}
		positionX -= this._gap;
		if(hasFirstGap && itemCount > 1)
		{
			positionX = positionX - this._gap + this._firstGap;
		}
		if(hasLastGap && itemCount > 2)
		{
			positionX = positionX - this._gap + this._lastGap;
		}

		if(needsWidth)
		{
			var resultWidth:Float = positionX + this._paddingLeft + this._paddingRight;
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
			var resultHeight:Float = maxItemHeight + this._paddingTop + this._paddingBottom;
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
		this._widthCache.length = 0;
	}

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		delete this._widthCache[index];
		if(item)
		{
			this._widthCache[index] = item.width;
			this.dispatchEventWith(Event.CHANGE);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function addToVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		var widthValue:* = item ? item.width : undefined;
		this._widthCache.splice(index, 0, widthValue);
	}

	/**
	 * @inheritDoc
	 */
	public function removeFromVariableVirtualCacheAtIndex(index:Int):Void
	{
		this._widthCache.splice(index, 1);
	}

	/**
	 * @inheritDoc
	 */
	public function getVisibleIndicesAtScrollPosition(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Vector.<int> = null):Vector.<int>
	{
		if(result)
		{
			result.length = 0;
		}
		else
		{
			result = new <int>[];
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.")
		}

		this.prepareTypicalItem(height - this._paddingTop - this._paddingBottom);
		var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;

		var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
		var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
		var resultLastIndex:Int = 0;
		var visibleTypicalItemCount:Int = Math.ceil(width / (calculatedTypicalItemWidth + this._gap));
		if(!this._hasVariableItemDimensions)
		{
			//this case can be optimized because we know that every item has
			//the same width
			var totalItemWidth:Float = itemCount * (calculatedTypicalItemWidth + this._gap) - this._gap;
			if(hasFirstGap && itemCount > 1)
			{
				totalItemWidth = totalItemWidth - this._gap + this._firstGap;
			}
			if(hasLastGap && itemCount > 2)
			{
				totalItemWidth = totalItemWidth - this._gap + this._lastGap;
			}
			var indexOffset:Int = 0;
			if(totalItemWidth < width)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					indexOffset = Math.ceil((width - totalItemWidth) / (calculatedTypicalItemWidth + this._gap));
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					indexOffset = Math.ceil(((width - totalItemWidth) / (calculatedTypicalItemWidth + this._gap)) / 2);
				}
			}
			var minimum:Int = (scrollX - this._paddingLeft) / (calculatedTypicalItemWidth + this._gap);
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
		var maxPositionX:Float = scrollX + width;
		var positionX:Float = this._paddingLeft;
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
			var cachedWidth:Float = this._widthCache[i];
			if(cachedWidth !== cachedWidth) //isNaN
			{
				var itemWidth:Float = calculatedTypicalItemWidth;
			}
			else
			{
				itemWidth = cachedWidth;
			}
			var oldPositionX:Float = positionX;
			positionX += itemWidth + gap;
			if(positionX > scrollX && oldPositionX < maxPositionX)
			{
				result[resultLastIndex] = i;
				resultLastIndex++;
			}

			if(positionX >= maxPositionX)
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
		resultLastIndex = resultLength;
		visibleItemCountDifference = visibleTypicalItemCount - resultLength;
		if(visibleItemCountDifference > 0)
		{
			//add extra items after the last index
			var startIndex:Int = resultLength > 0 ? (result[resultLength - 1] + 1) : 0;
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
	public function getScrollPositionForIndex(index:Int, items:Vector.<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}

		if(this._useVirtualLayout)
		{
			this.prepareTypicalItem(height - this._paddingTop - this._paddingBottom);
			var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;
		}

		var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
		var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
		var positionX:Float = x + this._paddingLeft;
		var lastWidth:Float = 0;
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
				lastWidth = calculatedTypicalItemWidth;
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
				positionX += (endIndexOffset * (calculatedTypicalItemWidth + this._gap));
			}
			positionX += (startIndexOffset * (calculatedTypicalItemWidth + this._gap));
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
				var cachedWidth:Float = this._widthCache[iNormalized];
			}
			if(this._useVirtualLayout && !item)
			{
				if(!this._hasVariableItemDimensions ||
					cachedWidth !== cachedWidth) //isNaN
				{
					lastWidth = calculatedTypicalItemWidth;
				}
				else
				{
					lastWidth = cachedWidth;
				}
			}
			else
			{
				var itemWidth:Float = item.width;
				if(this._useVirtualLayout)
				{
					if(this._hasVariableItemDimensions)
					{
						if(itemWidth != cachedWidth)
						{
							this._widthCache[iNormalized] = itemWidth;
							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else if(calculatedTypicalItemWidth >= 0)
					{
						item.width = itemWidth = calculatedTypicalItemWidth;
					}
				}
				lastWidth = itemWidth;
			}
			positionX += lastWidth + gap;
		}
		positionX -= (lastWidth + gap);
		if(this._scrollPositionHorizontalAlign == HORIZONTAL_ALIGN_CENTER)
		{
			positionX -= Math.round((width - lastWidth) / 2);
		}
		else if(this._scrollPositionHorizontalAlign == HORIZONTAL_ALIGN_RIGHT)
		{
			positionX -= (width - lastWidth);
		}
		result.x = positionX;
		result.y = 0;

		return result;
	}

	/**
	 * @private
	 */
	private function validateItems(items:Vector.<DisplayObject>, justifyHeight:Float, distributedWidth:Float):Void
	{
		//if the alignment is justified, then we want to set the height of
		//each item before validating because setting one dimension may
		//cause the other dimension to change, and that will invalidate the
		//layout if it happens after validation, causing more invalidation
		var mustSetJustifyHeight:Boolean = this._verticalAlign == VERTICAL_ALIGN_JUSTIFY &&
			justifyHeight === justifyHeight; //!isNaN

		var itemCount:Int = items.length;
		for(var i:Int = 0; i < itemCount; i++)
		{
			var item:DisplayObject = items[i];
			if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
			{
				continue;
			}
			if(this._distributeWidths)
			{
				item.width = distributedWidth;
			}
			if(mustSetJustifyHeight)
			{
				item.height = justifyHeight;
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
	private function prepareTypicalItem(justifyHeight:Float):Void
	{
		if(!this._typicalItem)
		{
			return;
		}
		if(this._resetTypicalItemDimensionsOnMeasure)
		{
			this._typicalItem.width = this._typicalItemWidth;
		}
		if(this._verticalAlign == VERTICAL_ALIGN_JUSTIFY &&
			justifyHeight === justifyHeight) //!isNaN
		{
			this._typicalItem.height = justifyHeight;
		}
		else if(this._resetTypicalItemDimensionsOnMeasure)
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
	private function calculateDistributedWidth(items:Vector.<DisplayObject>, explicitWidth:Float, minWidth:Float, maxWidth:Float):Float
	{
		var itemCount:Int = items.length;
		if(explicitWidth !== explicitWidth) //isNaN
		{
			var maxItemWidth:Float = 0;
			for(var i:Int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				var itemWidth:Float = item.width;
				if(itemWidth > maxItemWidth)
				{
					maxItemWidth = itemWidth;
				}
			}
			explicitWidth = maxItemWidth * itemCount + this._paddingLeft + this._paddingRight + this._gap * (itemCount - 1);
			var needsRecalculation:Boolean = false;
			if(explicitWidth > maxWidth)
			{
				explicitWidth = maxWidth;
				needsRecalculation = true;
			}
			else if(explicitWidth < minWidth)
			{
				explicitWidth = minWidth;
				needsRecalculation = true;
			}
			if(!needsRecalculation)
			{
				return maxItemWidth;
			}
		}
		var availableSpace:Float = explicitWidth - this._paddingLeft - this._paddingRight - this._gap * (itemCount - 1);
		if(itemCount > 1 && this._firstGap === this._firstGap) //!isNaN
		{
			availableSpace += this._gap - this._firstGap;
		}
		if(itemCount > 2 && this._lastGap === this._lastGap) //!isNaN
		{
			availableSpace += this._gap - this._lastGap;
		}
		return availableSpace / itemCount;
	}

	/**
	 * @private
	 */
	private function applyPercentWidths(items:Vector.<DisplayObject>, explicitWidth:Float, minWidth:Float, maxWidth:Float):Void
	{
		var remainingWidth:Float = explicitWidth;
		this._discoveredItemsCache.length = 0;
		var totalExplicitWidth:Float = 0;
		var totalMinWidth:Float = 0;
		var totalPercentWidth:Float = 0;
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
				var layoutData:HorizontalLayoutData = layoutItem.layoutData as HorizontalLayoutData;
				if(layoutData)
				{
					var percentWidth:Float = layoutData.percentWidth;
					if(percentWidth === percentWidth) //!isNaN
					{
						if(layoutItem is IFeathersControl)
						{
							var feathersItem:IFeathersControl = IFeathersControl(layoutItem);
							totalMinWidth += feathersItem.minWidth;
						}
						totalPercentWidth += percentWidth;
						this._discoveredItemsCache[pushIndex] = item;
						pushIndex++;
						continue;
					}
				}
			}
			totalExplicitWidth += item.width;
		}
		totalExplicitWidth += this._gap * (itemCount - 1);
		if(this._firstGap === this._firstGap && itemCount > 1)
		{
			totalExplicitWidth += (this._firstGap - this._gap);
		}
		else if(this._lastGap === this._lastGap && itemCount > 2)
		{
			totalExplicitWidth += (this._lastGap - this._gap);
		}
		totalExplicitWidth += this._paddingLeft + this._paddingRight;
		if(totalPercentWidth < 100)
		{
			totalPercentWidth = 100;
		}
		if(remainingWidth !== remainingWidth) //isNaN
		{
			remainingWidth = totalExplicitWidth + totalMinWidth;
			if(remainingWidth < minWidth)
			{
				remainingWidth = minWidth;
			}
			else if(remainingWidth > maxWidth)
			{
				remainingWidth = maxWidth;
			}
		}
		remainingWidth -= totalExplicitWidth;
		if(remainingWidth < 0)
		{
			remainingWidth = 0;
		}
		do
		{
			var needsAnotherPass:Boolean = false;
			var percentToPixels:Float = remainingWidth / totalPercentWidth;
			for(i = 0; i < pushIndex; i++)
			{
				layoutItem = ILayoutDisplayObject(this._discoveredItemsCache[i]);
				if(!layoutItem)
				{
					continue;
				}
				layoutData = HorizontalLayoutData(layoutItem.layoutData);
				percentWidth = layoutData.percentWidth;
				var itemWidth:Float = percentToPixels * percentWidth;
				if(layoutItem is IFeathersControl)
				{
					feathersItem = IFeathersControl(layoutItem);
					var itemMinWidth:Float = feathersItem.minWidth;
					if(itemWidth < itemMinWidth)
					{
						itemWidth = itemMinWidth;
						remainingWidth -= itemWidth;
						totalPercentWidth -= percentWidth;
						this._discoveredItemsCache[i] = null;
						needsAnotherPass = true;
					}
					else
					{
						var itemMaxWidth:Float = feathersItem.maxWidth;
						if(itemWidth > itemMaxWidth)
						{
							itemWidth = itemMaxWidth;
							remainingWidth -= itemWidth;
							totalPercentWidth -= percentWidth;
							this._discoveredItemsCache[i] = null;
							needsAnotherPass = true;
						}
					}
				}
				layoutItem.width = itemWidth;
			}
		}
		while(needsAnotherPass)
		this._discoveredItemsCache.length = 0;
	}
}
