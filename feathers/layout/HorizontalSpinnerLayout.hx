/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IFeathersControl;
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
 * For use with the <code>SpinnerList</code> component, positions items from
 * left to right in a single row and repeats infinitely.
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
 * @see ../../../help/horizontal-spinner-layout.html How to use HorizontalSpinnerLayout with the Feathers SpinnerList component
 */
class HorizontalSpinnerLayout extends EventDispatcher implements ISpinnerLayout implements ITrimmedVirtualLayout
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
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * @private
	 */
	private var _discoveredItemsCache:Array<DisplayObject> = new Array<DisplayObject>();

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
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * @default 0
	 *
	 * @see #paddingTop
	 * @see #paddingBottom
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
		this.paddingBottom = value;
		return get_padding();
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
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, above the items.
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
	private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

	#if 0
	[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
	#end
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
	private var _requestedColumnCount:Int = 0;

	/**
	 * Requests that the layout set the view port dimensions to display a
	 * specific number of columns (plus gaps and padding), if possible. If
	 * the explicit width of the view port is set, then this value will be
	 * ignored. If the view port's minimum and/or maximum width are set,
	 * the actual number of visible columns may be adjusted to meet those
	 * requirements. Set this value to <code>0</code> to display as many
	 * columns as possible.
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
	 * @copy feathers.layout.ISpinnerLayout#snapInterval
	 */
	public var snapInterval(get, never):Float;
	public function get_snapInterval():Float
	{
		return this._typicalItem.width + this._gap;
	}

	/**
	 * @inheritDoc
	 */
	public var requiresLayoutOnScroll(get, never):Bool;
	public function get_requiresLayoutOnScroll():Bool
	{
		return true;
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
			this.prepareTypicalItem(explicitHeight - this._paddingTop - this._paddingBottom);
			calculatedTypicalItemWidth = this._typicalItem != null ? this._typicalItem.width : 0;
			calculatedTypicalItemHeight = this._typicalItem != null ? this._typicalItem.height : 0;
		}

		if(!this._useVirtualLayout || this._verticalAlign != VERTICAL_ALIGN_JUSTIFY ||
			explicitHeight != explicitHeight) //isNaN
		{
			//in some cases, we may need to validate all of the items so
			//that we can use their dimensions below.
			this.validateItems(items, explicitWidth, explicitHeight - this._paddingTop - this._paddingBottom);
		}

		//this section prepares some variables needed for the following loop
		var maxItemHeight:Float = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
		var positionX:Float = boundsX;
		var gap:Float = this._gap;
		var itemCount:Int = items.length;
		var totalItemCount:Int = itemCount;
		if(this._useVirtualLayout)
		{
			//if the layout is virtualized, and the items all have the same
			//width, we can make our loops smaller by skipping some items
			//at the beginning and end. this improves performance.
			totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
			positionX += (this._beforeVirtualizedItemCount * (calculatedTypicalItemWidth + gap));
		}
		//this cache is used to save non-null items in virtual layouts. by
		//using a smaller array, we can improve performance by spending less
		//time in the upcoming loops.
		this._discoveredItemsCache.splice(0, this._discoveredItemsCache.length);
		var discoveredItemsCacheLastIndex:Int = 0;

		//this first loop sets the x position of items, and it calculates
		//the total width of all items
		//for(var i:Int = 0; i < itemCount; i++)
		var item:DisplayObject;
		for(i in 0 ... itemCount)
		{
			item = items[i];
			if(item != null)
			{
				//we get here if the item isn't null. it is never null if
				//the layout isn't virtualized.
				if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
				{
					continue;
				}
				item.x = item.pivotX + positionX;
				item.width = calculatedTypicalItemWidth;
				var itemHeight:Float = item.height;
				//we compare with > instead of Math.max() because the rest
				//arguments on Math.max() cause extra garbage collection and
				//hurt performance
				if(itemHeight > maxItemHeight)
				{
					//we need to know the maximum height of the items in the
					//case where the height of the view port needs to be
					//calculated by the layout.
					maxItemHeight = itemHeight;
				}
				if(this._useVirtualLayout)
				{
					this._discoveredItemsCache[discoveredItemsCacheLastIndex] = item;
					discoveredItemsCacheLastIndex++;
				}
			}
			positionX += calculatedTypicalItemWidth + gap;
		}
		if(this._useVirtualLayout)
		{
			//finish the final calculation of the x position so that it can
			//be used for the total width of all items
			positionX += (this._afterVirtualizedItemCount * (calculatedTypicalItemWidth + gap));
		}

		//this array will contain all items that are not null. see the
		//comment above where the discoveredItemsCache is initialized for
		//details about why this is important.
		var discoveredItems:Array<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
		var discoveredItemCount:Int = discoveredItems.length;

		var totalHeight:Float = maxItemHeight + this._paddingTop + this._paddingBottom;
		//the available height is the height of the viewport. if the explicit
		//height is NaN, we need to calculate the viewport height ourselves
		//based on the total height of all items.
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

		//this is the total width of all items
		var totalWidth:Float = positionX - gap - boundsX;
		//the available width is the width of the viewport. if the explicit
		//width is NaN, we need to calculate the viewport width ourselves
		//based on the total width of all items.
		var availableWidth:Float = explicitWidth;
		if(availableWidth != availableWidth) //isNaN
		{
			if(this._requestedColumnCount > 0)
			{
				availableWidth = this._requestedColumnCount * (calculatedTypicalItemWidth + gap) - gap;
			}
			else
			{
				availableWidth = totalWidth;
			}
			if(availableWidth < minWidth)
			{
				availableWidth = minWidth;
			}
			else if(availableWidth > maxWidth)
			{
				availableWidth = maxWidth;
			}
		}
		
		var canRepeatItems:Bool = totalWidth > availableWidth;
		if(canRepeatItems)
		{
			totalWidth += gap;
		}

		//in this section, we handle vertical alignment. the selected item
		//needs to be centered vertically.
		var horizontalAlignOffsetX:Float = Math.round((availableWidth - calculatedTypicalItemWidth) / 2);
		if(!canRepeatItems)
		{
			totalWidth += 2 * horizontalAlignOffsetX;
		}
		//for(i = 0; i < discoveredItemCount; i++)
		for(i in 0 ... discoveredItemCount)
		{
			item = discoveredItems[i];
			if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
			{
				continue;
			}
			item.x += horizontalAlignOffsetX;
		}

		//for(i = 0; i < discoveredItemCount; i++)
		for(i in 0 ... discoveredItemCount)
		{
			item = discoveredItems[i];
			var layoutItem:ILayoutDisplayObject = cast(item, ILayoutDisplayObject);
			if(layoutItem != null && !layoutItem.includeInLayout)
			{
				continue;
			}

			//if we're repeating items, then we may need to adjust the x
			//position of some items so that they appear inside the viewport
			if(canRepeatItems)
			{
				var adjustedScrollX:Float = scrollX - horizontalAlignOffsetX;
				if(adjustedScrollX > 0)
				{
					item.x += totalWidth * Std.int((adjustedScrollX + availableWidth) / totalWidth);
					if(item.x >= (scrollX + availableWidth))
					{
						item.x -= totalWidth;
					}
				}
				else if(adjustedScrollX < 0)
				{
					item.x += totalWidth * (Std.int(adjustedScrollX / totalWidth) - 1);
					if((item.x + item.width) < scrollX)
					{
						item.x += totalWidth;
					}
				}
			}

			//in this section, we handle vertical alignment
			if(this._verticalAlign == VERTICAL_ALIGN_JUSTIFY)
			{
				//if we justify items vertically, we can skip percent height
				item.y = item.pivotY + boundsY + this._paddingTop;
				item.height = availableHeight - this._paddingTop - this._paddingBottom;
			}
			else
			{
				//handle all other vertical alignment values (we handled
				//justify already). the y position of all items is set here.
				var verticalAlignHeight:Float = availableHeight;
				if(totalHeight > verticalAlignHeight)
				{
					verticalAlignHeight = totalHeight;
				}
				switch(this._verticalAlign)
				{
					case VERTICAL_ALIGN_BOTTOM:
					{
						item.y = item.pivotY + boundsY + verticalAlignHeight - this._paddingBottom - item.height;
						break;
					}
					case VERTICAL_ALIGN_MIDDLE:
					{
						//round to the nearest pixel when dividing by 2 to
						//align in the middle
						item.y = item.pivotY + boundsY + this._paddingTop + Math.round((verticalAlignHeight - this._paddingTop - this._paddingBottom - item.height) / 2);
						break;
					}
					default: //top
					{
						item.y = item.pivotY + boundsY + this._paddingTop;
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
		if(canRepeatItems)
		{
			result.contentX = Math.NEGATIVE_INFINITY;
			result.contentWidth = Math.POSITIVE_INFINITY;
		}
		else
		{
			result.contentX = 0;
			result.contentWidth = totalWidth;
		}
		result.contentY = 0;
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

		this.prepareTypicalItem(explicitHeight - this._paddingTop - this._paddingBottom);
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var gap:Float = this._gap;
		var positionX:Float = 0;
		
		var maxItemHeight:Float = calculatedTypicalItemHeight;
		positionX += ((calculatedTypicalItemWidth + gap) * itemCount);
		positionX -= gap;

		if(needsWidth)
		{
			var resultWidth:Float;
			if(this._requestedColumnCount > 0)
			{
				resultWidth = (calculatedTypicalItemWidth + gap) * this._requestedColumnCount - gap;
			}
			else
			{
				resultWidth = positionX;
			}
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

		this.prepareTypicalItem(height - this._paddingTop - this._paddingBottom);
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var gap:Float = this._gap;
		
		var resultLastIndex:Int = 0;
		//we add one extra here because the first item renderer in view may
		//be partially obscured, which would reveal an extra item renderer.
		var maxVisibleTypicalItemCount:Int = Math.ceil(width / (calculatedTypicalItemWidth + gap)) + 1;
		
		var totalItemWidth:Float = itemCount * (calculatedTypicalItemWidth + gap) - gap;

		scrollX -= Math.round((width - calculatedTypicalItemWidth) / 2);

		var canRepeatItems:Bool = totalItemWidth > width;
		var minimum:Int;
		var maximum:Int;
		if(canRepeatItems)
		{
			scrollX %= totalItemWidth;
			if(scrollX < 0)
			{
				scrollX += totalItemWidth;
			}
			minimum = Std.int(scrollX / (calculatedTypicalItemWidth + gap));
			maximum = Std.int(minimum + maxVisibleTypicalItemCount);
		}
		else
		{
			minimum = Std.int(scrollX / (calculatedTypicalItemWidth + gap));
			if(minimum < 0)
			{
				minimum = 0;
			}
			//if we're scrolling beyond the final item, we should keep the
			//indices consistent so that items aren't destroyed and
			//recreated unnecessarily
			maximum = minimum + maxVisibleTypicalItemCount;
			if(maximum >= itemCount)
			{
				maximum = itemCount - 1;
			}
			minimum = maximum - maxVisibleTypicalItemCount;
			if(minimum < 0)
			{
				minimum = 0;
			}
		}
		//for(var i:Int = minimum; i <= maximum; i++)
		var i:Int = minimum;
		while(i <= maximum)
		{
			if(!canRepeatItems || (i >= 0 && i < itemCount))
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

	/**
	 * @inheritDoc
	 */
	public function getNearestScrollPositionForIndex(index:Int, scrollX:Float, scrollY:Float, items:Array<DisplayObject>,
		x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		//normally, this isn't acceptable, but because the selection is
		//based on the scroll position, it must work this way.
		return this.getScrollPositionForIndex(index, items, x, y, width, height, result);
	}

	/**
	 * @inheritDoc
	 */
	public function getScrollPositionForIndex(index:Int, items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		this.prepareTypicalItem(height - this._paddingTop - this._paddingBottom);
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;
		if(result == null)
		{
			result = new Point();
		}
		result.x = 0;
		result.y = calculatedTypicalItemHeight * index;
		return result;
	}

	/**
	 * @private
	 */
	private function validateItems(items:Array<DisplayObject>, distributedWidth:Float, justifyHeight:Float):Void
	{
		//if the alignment is justified, then we want to set the height of
		//each item before validating because setting one dimension may
		//cause the other dimension to change, and that will invalidate the
		//layout if it happens after validation, causing more invalidation
		var isJustified:Bool = this._verticalAlign == VERTICAL_ALIGN_JUSTIFY;
		var mustSetJustifyHeight:Bool = isJustified && justifyHeight == justifyHeight; //!isNaN
		var itemCount:Int = items.length;
		//for(var i:Int = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = items[i];
			if(item == null || (Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout))
			{
				continue;
			}
			if(mustSetJustifyHeight)
			{
				item.height = justifyHeight;
			}
			else if(isJustified && Std.is(item, IFeathersControl))
			{
				//the alignment is justified, but we don't yet have a height
				//to use, so we need to ensure that we accurately measure
				//the items instead of using an old justified height that
				//may be wrong now!
				item.height = Math.NaN;
			}
			if(Std.is(item, IValidating))
			{
				cast(item, IValidating).validate();
			}
		}
	}

	/**
	 * @private
	 */
	private function prepareTypicalItem(justifyHeight:Float):Void
	{
		if(this._typicalItem == null)
		{
			return;
		}
		if(this._resetTypicalItemDimensionsOnMeasure)
		{
			this._typicalItem.width = this._typicalItemWidth;
		}
		if(this._verticalAlign == VERTICAL_ALIGN_JUSTIFY &&
			justifyHeight == justifyHeight) //!isNaN
		{
			this._typicalItem.height = justifyHeight;
		}
		else if(this._resetTypicalItemDimensionsOnMeasure)
		{
			this._typicalItem.height = this._typicalItemHeight;
		}
		if(Std.is(this._typicalItem, IValidating))
		{
			cast(this._typicalItem, IValidating).validate();
		}
	}
}
