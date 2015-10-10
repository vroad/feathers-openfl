/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IValidating;
import openfl.errors.RangeError;

import flash.errors.IllegalOperationError;
import flash.geom.Point;

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
#if 0
[Event(name="change",type="starling.events.Event")]
#end

/**
 * A layout with multiple columns of equal width where items may have
 * variable heights. Items are added to the layout in order, but they may be
 * added to any of the available columns. The layout selects the column
 * where the column's height plus the item's height will result in the
 * smallest possible total height.
 *
 * <p><strong>Beta Layout:</strong> This is a new layout, and its APIs
 * may need some changes between now and the next version of Feathers to
 * account for overlooked requirements or other issues. Upgrading to future
 * versions of Feathers may involve manual changes to your code that uses
 * this layout. The
 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>
 * will not go into effect until this component's status is upgraded from
 * beta to stable.</p>
 *
 * @see ../../../help/waterfall-layout.html How to use WaterfallLayout with Feathers containers
 */
class WaterfallLayout extends EventDispatcher implements IVariableVirtualLayout
{
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
	 * Constructor.
	 */
	public function WaterfallLayout()
	{
	}

	/**
	 * Quickly sets both <code>horizontalGap</code> and <code>verticalGap</code>
	 * to the same value. The <code>gap</code> getter always returns the
	 * value of <code>horizontalGap</code>, but the value of
	 * <code>verticalGap</code> may be different.
	 *
	 * @default 0
	 *
	 * @see #horizontalGap
	 * @see #verticalGap
	 */
	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return this._horizontalGap;
	}

	/**
	 * @private
	 */
	public function set_gap(value:Float):Float
	{
		this.horizontalGap = value;
		this.verticalGap = value;
		return get_gap();
	}

	/**
	 * @private
	 */
	private var _horizontalGap:Float = 0;

	/**
	 * The horizontal space, in pixels, between columns.
	 *
	 * @default 0
	 */
	public var horizontalGap(get, set):Float;
	public function get_horizontalGap():Float
	{
		return this._horizontalGap;
	}

	/**
	 * @private
	 */
	public function set_horizontalGap(value:Float):Float
	{
		if(this._horizontalGap == value)
		{
			return get_horizontalGap();
		}
		this._horizontalGap = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_horizontalGap();
	}

	/**
	 * @private
	 */
	private var _verticalGap:Float = 0;

	/**
	 * The vertical space, in pixels, between items in a column.
	 *
	 * @default 0
	 */
	public var verticalGap(get, set):Float;
	public function get_verticalGap():Float
	{
		return this._verticalGap;
	}

	/**
	 * @private
	 */
	public function set_verticalGap(value:Float):Float
	{
		if(this._verticalGap == value)
		{
			return get_verticalGap();
		}
		this._verticalGap = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_verticalGap();
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
	 * The space, in pixels, that appears on top, above the items.
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
	 * The space, in pixels, that appears on the bottom, below the items.
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
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

	#if 0
	[Inspectable(type="String",enumeration="left,center,right")]
	#end
	/**
	 * The alignment of the items horizontally, on the x-axis.
	 *
	 * @default WaterfallLayout.HORIZONTAL_ALIGN_CENTER
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
		this.dispatchEventWith(Event.CHANGE);
		return get_horizontalAlign();
	}

	/**
	 * @private
	 */
	private var _requestedColumnCount:Int = 0;

	/**
	 * Requests that the layout uses a specific number of columns, if
	 * possible. Set to <code>0</code> to calculate the maximum of columns
	 * that will fit in the available space.
	 *
	 * <p>If the view port's explicit or maximum width is not large enough
	 * to fit the requested number of columns, it will use fewer. If the
	 * view port doesn't have an explicit width and the maximum width is
	 * equal to <code>Number.POSITIVE_INFINITY</code>, the width will be
	 * calculated automatically to fit the exact number of requested
	 * columns.</p>
	 *
	 * @default 0
	 */
	public var requestedColumnCount(get, set):Int;
	public function get_requestedColumnCount():Int
	{
		return this._requestedColumnCount;
	}

	/**
	 * @private
	 */
	public function set_requestedColumnCount(value:Int):Int
	{
		if(value < 0)
		{
			throw new RangeError("requestedColumnCount requires a value >= 0");
		}
		if(this._requestedColumnCount == value)
		{
			return get_requestedColumnCount();
		}
		this._requestedColumnCount = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_requestedColumnCount();
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
	private var _typicalItem:DisplayObject;

	/**
	 * @inheritDoc
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
	private var _hasVariableItemDimensions:Bool = true;

	/**
	 * When the layout is virtualized, and this value is true, the items may
	 * have variable height values. If false, the items will all share the
	 * same height value with the typical item.
	 *
	 * @default true
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
	 * @inheritDoc
	 */
	public var requiresLayoutOnScroll(get, never):Bool;
	public function get_requiresLayoutOnScroll():Bool
	{
		return this._useVirtualLayout;
	}

	/**
	 * @private
	 */
	private var _heightCache:Array<Null<Float>> = [];

	/**
	 * @inheritDoc
	 */
	public function layout(items:Array<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
	{
		var boundsX:Float = viewPortBounds != null ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds != null ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds != null ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds != null ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds != null ? viewPortBounds.maxWidth : Math.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds != null ? viewPortBounds.maxHeight : Math.POSITIVE_INFINITY;
		var explicitWidth:Float = viewPortBounds != null ? viewPortBounds.explicitWidth : Math.NaN;
		var explicitHeight:Float = viewPortBounds != null ? viewPortBounds.explicitHeight : Math.NaN;

		var needsWidth:Bool = explicitWidth != explicitWidth; //isNaN
		var needsHeight:Bool = explicitHeight != explicitHeight; //isNaN

		var calculatedTypicalItemWidth:Float = Math.NaN;
		var calculatedTypicalItemHeight:Float = Math.NaN;
		if(this._useVirtualLayout)
		{
			//if the layout is virtualized, we'll need the dimensions of the
			//typical item so that we have fallback values when an item is null
			if(Std.is(this._typicalItem, IValidating))
			{
				cast(this._typicalItem, IValidating).validate();
			}
			calculatedTypicalItemWidth = this._typicalItem != null ? this._typicalItem.width : 0;
			calculatedTypicalItemHeight = this._typicalItem != null ? this._typicalItem.height : 0;
		}

		var columnWidth:Float = 0;
		var item:DisplayObject;
		if(this._useVirtualLayout)
		{
			columnWidth = calculatedTypicalItemWidth;
		}
		else if(items.length > 0)
		{
			item = items[0];
			if(Std.is(item, IValidating))
			{
				cast(item, IValidating).validate();
			}
			columnWidth = item.width;
		}
		var availableWidth:Float = explicitWidth;
		if(needsWidth)
		{
			if(maxWidth < Math.POSITIVE_INFINITY)
			{
				availableWidth = maxWidth;
			}
			else if(this._requestedColumnCount > 0)
			{
				availableWidth = ((columnWidth + this._horizontalGap) * this._requestedColumnCount) - this._horizontalGap;
			}
			else
			{
				availableWidth = columnWidth;
			}
			availableWidth += this._paddingLeft + this._paddingRight;
			if(availableWidth < minWidth)
			{
				availableWidth = minWidth;
			}
			else if(availableWidth > maxWidth)
			{
				availableWidth = maxWidth;
			}
		}
		var columnCount:Int = Std.int((availableWidth + this._horizontalGap - this._paddingLeft - this._paddingRight) / (columnWidth + this._horizontalGap));
		if(this._requestedColumnCount > 0 && columnCount > this._requestedColumnCount)
		{
			columnCount = this._requestedColumnCount;
		}
		else if(columnCount < 1)
		{
			columnCount = 1;
		}
		var columnHeights:Array<Float> = new Array<Float>();
		//for(var i:Int = 0; i < columnCount; i++)
		for(i in 0 ... columnCount)
		{
			columnHeights[i] = this._paddingTop;
		}
		#if 0
		columnHeights.fixed = true;
		#end

		var horizontalAlignOffset:Float = 0;
		if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
		{
			horizontalAlignOffset = (availableWidth - this._paddingLeft - this._paddingRight) - ((columnCount * (columnWidth + this._horizontalGap)) - this._horizontalGap);
		}
		else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
		{
			horizontalAlignOffset = Math.round(((availableWidth - this._paddingLeft - this._paddingRight) - ((columnCount * (columnWidth + this._horizontalGap)) - this._horizontalGap)) / 2);
		}

		var itemCount:Int = items.length;
		var targetColumnIndex:Int = 0;
		var targetColumnHeight:Float = columnHeights[targetColumnIndex];
		var columnHeight:Float;
		//for(i = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			item = items[i];
			var cachedHeight:Float = Math.NaN;
			if(this._useVirtualLayout && this._hasVariableItemDimensions)
			{
				cachedHeight = this._heightCache[i];
			}
			var itemHeight:Float;
			if(this._useVirtualLayout && item == null)
			{
				if(!this._hasVariableItemDimensions ||
					cachedHeight != cachedHeight) //isNaN
				{
					//if all items must have the same height, we will
					//use the height of the typical item (calculatedTypicalItemHeight).

					//if items may have different heights, we first check
					//the cache for a height value. if there isn't one, then
					//we'll use calculatedTypicalItemHeight as a fallback.
					itemHeight = calculatedTypicalItemHeight;
				}
				else
				{
					itemHeight = cachedHeight;
				}
			}
			else
			{
				if(Std.is(item, ILayoutDisplayObject))
				{
					var layoutItem:ILayoutDisplayObject = cast item;
					if(!layoutItem.includeInLayout)
					{
						continue;
					}
				}
				if(Std.is(item, IValidating))
				{
					cast(item, IValidating).validate();
				}
				//first, scale the items to fit into the column width
				var scaleFactor:Float = columnWidth / item.width;
				item.width *= scaleFactor;
				if(Std.is(item, IValidating))
				{
					//if we changed the width, we need to recalculate the
					//height.
					cast(item, IValidating).validate();
				}
				if(this._useVirtualLayout)
				{
					if(this._hasVariableItemDimensions)
					{
						itemHeight = item.height;
						if(itemHeight != cachedHeight)
						{
							//update the cache if needed. this will notify
							//the container that the virtualized layout has
							//changed, and it the view port may need to be
							//re-measured.
							this._heightCache[i] = itemHeight;
							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else
					{
						item.height = itemHeight = calculatedTypicalItemHeight;
					}
				}
				else
				{
					itemHeight = item.height;
				}
			}
			targetColumnHeight += itemHeight;
			//for(var j:Int = 0; j < columnCount; j++)
			for(j in 0 ... columnCount)
			{
				if(j == targetColumnIndex)
				{
					continue;
				}
				columnHeight = columnHeights[j] + itemHeight;
				if(columnHeight < targetColumnHeight)
				{
					targetColumnIndex = j;
					targetColumnHeight = columnHeight;
				}
			}
			if(item != null)
			{
				item.x = item.pivotX + boundsX + horizontalAlignOffset + this._paddingLeft + targetColumnIndex * (columnWidth + this._horizontalGap);
				item.y = item.pivotY + boundsY + targetColumnHeight - itemHeight;
			}
			targetColumnHeight += this._verticalGap;
			columnHeights[targetColumnIndex] = targetColumnHeight;
		}
		var totalHeight:Float = columnHeights[0];
		//for(i = 1; i < columnCount; i++)
		for(i in 1 ... columnCount)
		{
			columnHeight = columnHeights[i];
			if(columnHeight > totalHeight)
			{
				totalHeight = columnHeight;
			}
		}
		totalHeight -= this._verticalGap;
		totalHeight += this._paddingBottom;
		if(totalHeight < 0)
		{
			totalHeight = 0;
		}

		var availableHeight:Float = explicitHeight;
		if(needsHeight)
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

		//finally, we want to calculate the result so that the container
		//can use it to adjust its viewport and determine the minimum and
		//maximum scroll positions (if needed)
		if(result == null)
		{
			result = new LayoutBoundsResult();
		}
		result.contentX = 0;
		result.contentWidth = availableWidth;
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

		if(Std.is(this._typicalItem, IValidating))
		{
			cast(this._typicalItem, IValidating).validate();
		}
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var columnWidth:Float = calculatedTypicalItemWidth;
		var availableWidth:Float = explicitWidth;
		if(needsWidth)
		{
			if(maxWidth < Math.POSITIVE_INFINITY)
			{
				availableWidth = maxWidth;
			}
			else if(this._requestedColumnCount > 0)
			{
				availableWidth = ((columnWidth + this._horizontalGap) * this._requestedColumnCount) - this._horizontalGap;
			}
			else
			{
				availableWidth = columnWidth;
			}
			availableWidth += this._paddingLeft + this._paddingRight;
			if(availableWidth < minWidth)
			{
				availableWidth = minWidth;
			}
			else if(availableWidth > maxWidth)
			{
				availableWidth = maxWidth;
			}
		}
		var columnCount:Int = Std.int((availableWidth + this._horizontalGap - this._paddingLeft - this._paddingRight) / (columnWidth + this._horizontalGap));
		if(this._requestedColumnCount > 0 && columnCount > this._requestedColumnCount)
		{
			columnCount = this._requestedColumnCount;
		}
		else if(columnCount < 1)
		{
			columnCount = 1;
		}

		if(needsWidth)
		{
			result.x = this._paddingLeft + this._paddingRight + (columnCount * (columnWidth + this._horizontalGap)) - this._horizontalGap;
		}
		else
		{
			result.x = explicitWidth;
		}

		if(needsHeight)
		{
			if(this._hasVariableItemDimensions)
			{
				var columnHeights:Array<Float> = new Array<Float>();
				//for(var i:Int = 0; i < columnCount; i++)
				for(i in 0 ... columnCount)
				{
					columnHeights[i] = this._paddingTop;
				}
				#if 0
				columnHeights.fixed = true;
				#end

				var targetColumnIndex:Int = 0;
				var targetColumnHeight:Float = columnHeights[targetColumnIndex];
				var columnHeight:Float;
				//for(i = 0; i < itemCount; i++)
				for(i in 0 ... itemCount)
				{
					var itemHeight:Float;
					if(this._hasVariableItemDimensions)
					{
						itemHeight = this._heightCache[i];
						if(itemHeight != itemHeight) //isNaN
						{
							itemHeight = calculatedTypicalItemHeight;
						}
					}
					else
					{
						itemHeight = calculatedTypicalItemHeight;
					}
					targetColumnHeight += itemHeight;
					//for(var j:Int = 0; j < columnCount; j++)
					for(j in 0 ... columnCount)
					{
						if(j == targetColumnIndex)
						{
							continue;
						}
						columnHeight = columnHeights[j] + itemHeight;
						if(columnHeight < targetColumnHeight)
						{
							targetColumnIndex = j;
							targetColumnHeight = columnHeight;
						}
					}
					targetColumnHeight += this._verticalGap;
					columnHeights[targetColumnIndex] = targetColumnHeight;
				}
				var totalHeight:Float = columnHeights[0];
				//for(i = 1; i < columnCount; i++)
				for(i in 1 ... columnCount)
				{
					columnHeight = columnHeights[i];
					if(columnHeight > totalHeight)
					{
						totalHeight = columnHeight;
					}
				}
				totalHeight -= this._verticalGap;
				totalHeight += this._paddingBottom;
				if(totalHeight < 0)
				{
					totalHeight = 0;
				}
				if(totalHeight < minHeight)
				{
					totalHeight = minHeight;
				}
				else if(totalHeight > maxHeight)
				{
					totalHeight = maxHeight;
				}
				result.y = totalHeight;
			}
			else
			{
				result.y = this._paddingTop + this._paddingBottom + (Math.ceil(itemCount / columnCount) * (calculatedTypicalItemHeight + this._verticalGap)) - this._verticalGap;
			}
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
	public function getVisibleIndicesAtScrollPosition(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Array<Int> = null):Array<Int>
	{
		if(result != null)
		{
			result.splice(0, result.length);
		}
		else
		{
			result = new Array<Int>();
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.");
		}

		if(Std.is(this._typicalItem, IValidating))
		{
			cast(this._typicalItem, IValidating).validate();
		}
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var columnWidth:Float = calculatedTypicalItemWidth;
		var columnCount:Int = Std.int((width + this._horizontalGap - this._paddingLeft - this._paddingRight) / (columnWidth + this._horizontalGap));
		if(this._requestedColumnCount > 0 && columnCount > this._requestedColumnCount)
		{
			columnCount = this._requestedColumnCount;
		}
		else if(columnCount < 1)
		{
			columnCount = 1;
		}
		var resultLastIndex:Int = 0;
		if(this._hasVariableItemDimensions)
		{
			var columnHeights:Array<Float> = new Array<Float>();
			//for(var i:Int = 0; i < columnCount; i++)
			for(i in 0 ... columnCount)
			{
				columnHeights[i] = this._paddingTop;
			}
			#if 0
			columnHeights.fixed = true;
			#end

			var maxPositionY:Float = scrollY + height;
			var targetColumnIndex:Int = 0;
			var targetColumnHeight:Float = columnHeights[targetColumnIndex];
			//for(i = 0; i < itemCount; i++)
			for(i in 0 ... itemCount)
			{
				var itemHeight:Float;
				if(this._hasVariableItemDimensions)
				{
					itemHeight = this._heightCache[i];
					if(itemHeight != itemHeight) //isNaN
					{
						itemHeight = calculatedTypicalItemHeight;
					}
				}
				else
				{
					itemHeight = calculatedTypicalItemHeight;
				}
				targetColumnHeight += itemHeight;
				//for(var j:Int = 0; j < columnCount; j++)
				for(j in 0 ... columnCount)
				{
					if(j == targetColumnIndex)
					{
						continue;
					}
					var columnHeight:Float = columnHeights[j] + itemHeight;
					if(columnHeight < targetColumnHeight)
					{
						targetColumnIndex = j;
						targetColumnHeight = columnHeight;
					}
				}
				if(targetColumnHeight > scrollY && (targetColumnHeight - itemHeight) < maxPositionY)
				{
					result[resultLastIndex] = i;
					resultLastIndex++;
				}
				targetColumnHeight += this._verticalGap;
				columnHeights[targetColumnIndex] = targetColumnHeight;
			}
			return result;
		}
		//this case can be optimized because we know that every item has
		//the same height

		//we add one extra here because the first item renderer in view may
		//be partially obscured, which would reveal an extra item renderer.
		var maxVisibleTypicalItemCount:Int = Math.ceil(height / (calculatedTypicalItemHeight + this._verticalGap)) + 1;
		//we're calculating the minimum and maximum rows
		var minimum:Int = Std.int((scrollY - this._paddingTop) / (calculatedTypicalItemHeight + this._verticalGap));
		if(minimum < 0)
		{
			minimum = 0;
		}
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
		//for(i = minimum; i <= maximum; i++)
		var i:Int = minimum;
		while(i <= maximum)
		{
			//for(j = 0; j < columnCount; j++)
			for(j in 0 ... columnCount)
			{
				var index:Int = (i * columnCount) + j;
				if(index >= 0 && i < itemCount)
				{
					result[resultLastIndex] = index;
				}
				else if(index < 0)
				{
					result[resultLastIndex] = itemCount + index;
				}
				else if(index >= itemCount)
				{
					result[resultLastIndex] = index - itemCount;
				}
				resultLastIndex++;
			}
			
			i++;
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
		this._heightCache.splice(index, 1);
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
	public function getNearestScrollPositionForIndex(index:Int, scrollX:Float, scrollY:Float, items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		var maxScrollY:Float = this.calculateMaxScrollYOfIndex(index, items, x, y, width, height);

		var itemHeight:Float;
		if(this._useVirtualLayout)
		{
			if(this._hasVariableItemDimensions)
			{
				itemHeight = this._heightCache[index];
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
				itemHeight = this._heightCache[index];
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
		result.y = maxScrollY - Math.round((height - itemHeight) / 2);
		return result;
	}

	/**
	 * @private
	 */
	private function calculateMaxScrollYOfIndex(index:Int, items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float):Float
	{
		if(items.length == 0)
		{
			return 0;
		}

		var calculatedTypicalItemWidth:Float = Math.NaN;
		var calculatedTypicalItemHeight:Float = Math.NaN;
		if(this._useVirtualLayout)
		{
			//if the layout is virtualized, we'll need the dimensions of the
			//typical item so that we have fallback values when an item is null
			if(Std.is(this._typicalItem, IValidating))
			{
				cast(this._typicalItem, IValidating).validate();
			}
			calculatedTypicalItemWidth = this._typicalItem != null ? this._typicalItem.width : 0;
			calculatedTypicalItemHeight = this._typicalItem != null ? this._typicalItem.height : 0;
		}

		var columnWidth:Float = 0;
		var item:DisplayObject;
		if(this._useVirtualLayout)
		{
			columnWidth = calculatedTypicalItemWidth;
		}
		else if(items.length > 0)
		{
			item = items[0];
			if(Std.is(item, IValidating))
			{
				cast(item, IValidating).validate();
			}
			columnWidth = item.width;
		}

		var columnCount:Int = Std.int((width + this._horizontalGap - this._paddingLeft - this._paddingRight) / (columnWidth + this._horizontalGap));
		if(this._requestedColumnCount > 0 && columnCount > this._requestedColumnCount)
		{
			columnCount = this._requestedColumnCount;
		}
		else if(columnCount < 1)
		{
			columnCount = 1;
		}
		var columnHeights:Array<Float> = new Array<Float>();
		//for(var i:Int = 0; i < columnCount; i++)
		for(i in 0 ... columnCount)
		{
			columnHeights[i] = this._paddingTop;
		}
		#if 0
		columnHeights.fixed = true;
		#end

		var itemCount:Int = items.length;
		var targetColumnIndex:Int = 0;
		var targetColumnHeight:Float = columnHeights[targetColumnIndex];
		var columnHeight:Float;
		//for(i = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			item = items[i];
			var cachedHeight:Float = Math.NaN;
			if(this._useVirtualLayout && this._hasVariableItemDimensions)
			{
				cachedHeight = this._heightCache[i];
			}
			var itemHeight:Float;
			if(this._useVirtualLayout && item == null)
			{
				if(!this._hasVariableItemDimensions ||
					cachedHeight != cachedHeight) //isNaN
				{
					//if all items must have the same height, we will
					//use the height of the typical item (calculatedTypicalItemHeight).

					//if items may have different heights, we first check
					//the cache for a height value. if there isn't one, then
					//we'll use calculatedTypicalItemHeight as a fallback.
					itemHeight = calculatedTypicalItemHeight;
				}
				else
				{
					itemHeight = cachedHeight;
				}
			}
			else
			{
				if(Std.is(item, ILayoutDisplayObject))
				{
					var layoutItem:ILayoutDisplayObject = cast item;
					if(!layoutItem.includeInLayout)
					{
						continue;
					}
				}
				if(Std.is(item, IValidating))
				{
					cast(item, IValidating).validate();
				}
				//first, scale the items to fit into the column width
				var scaleFactor:Float = columnWidth / item.width;
				item.width *= scaleFactor;
				if(Std.is(item, IValidating))
				{
					cast(item, IValidating).validate();
				}
				if(this._useVirtualLayout)
				{
					if(this._hasVariableItemDimensions)
					{
						itemHeight = item.height;
						if(itemHeight != cachedHeight)
						{
							this._heightCache[i] = itemHeight;
							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else
					{
						item.height = itemHeight = calculatedTypicalItemHeight;
					}
				}
				else
				{
					itemHeight = item.height;
				}
			}
			targetColumnHeight += itemHeight;
			//for(var j:Int = 0; j < columnCount; j++)
			for(j in 0 ... columnCount)
			{
				if(j == targetColumnIndex)
				{
					continue;
				}
				columnHeight = columnHeights[j] + itemHeight;
				if(columnHeight < targetColumnHeight)
				{
					targetColumnIndex = j;
					targetColumnHeight = columnHeight;
				}
			}
			if(i == index)
			{
				return targetColumnHeight - itemHeight;
			}
			targetColumnHeight += this._verticalGap;
			columnHeights[targetColumnIndex] = targetColumnHeight;
		}
		var totalHeight:Float = columnHeights[0];
		//for(i = 1; i < columnCount; i++)
		for(i in 1 ... columnCount)
		{
			columnHeight = columnHeights[i];
			if(columnHeight > totalHeight)
			{
				totalHeight = columnHeight;
			}
		}
		totalHeight -= this._verticalGap;
		totalHeight += this._paddingBottom;
		//subtracting the height gives us the maximum scroll position
		totalHeight -= height;
		if(totalHeight < 0)
		{
			totalHeight = 0;
		}
		return totalHeight;
	}
}
