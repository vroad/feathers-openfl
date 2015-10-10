/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IValidating;

import flash.errors.IllegalOperationError;
import flash.geom.Point;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

import feathers.utils.type.SafeCast.safe_cast;

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
 * Positions items of different dimensions from left to right in multiple
 * rows. When the width of a row reaches the width of the container, a new
 * row will be started. Constrained to the suggested width, the flow layout
 * will change in height as the number of items increases or decreases.
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
 * @see ../../../help/flow-layout.html How to use FlowLayout with Feathers containers
 */
class FlowLayout extends EventDispatcher implements IVariableVirtualLayout
{
	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the top.
	 *
	 * @see #rowVerticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the middle.
	 *
	 * @see #rowVerticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the bottom.
	 *
	 * @see #rowVerticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

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
	public function new()
	{
		super();
	}

	/**
	 * @private
	 */
	private var _rowItems:Array<DisplayObject> = new Array<DisplayObject>();

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
	 * The horizontal space, in pixels, between items.
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
	 * The vertical space, in pixels, between items.
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
	 * The space, in pixels, above of items.
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
	 * The space, in pixels, to the right of the items.
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
	 * The space, in pixels, below the items.
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
	 * The space, in pixels, to the left of the items.
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
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

	#if 0
	[Inspectable(type="String",enumeration="left,center,right")]
	#end
	/**
	 * If the total row width is less than the bounds, the items in the row
	 * can be aligned horizontally.
	 *
	 * @default FlowLayout.HORIZONTAL_ALIGN_LEFT
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 * @see #verticalAlign
	 * @see #rowVerticalAlign
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
	private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

	#if 0
	[Inspectable(type="String",enumeration="top,middle,bottom")]
	#end
	/**
	 * If the total height of the content is less than the bounds, the
	 * content may be aligned vertically.
	 *
	 * @default FlowLayout.VERTICAL_ALIGN_TOP
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #horizontalAlign
	 * @see #rowVerticalAlign
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
	private var _rowVerticalAlign:String = VERTICAL_ALIGN_TOP;

	#if 0
	[Inspectable(type="String",enumeration="top,middle,bottom")]
	#end
	/**
	 * If the height of an item is less than the height of a row, it can be
	 * aligned vertically.
	 *
	 * @default FlowLayout.VERTICAL_ALIGN_TOP
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #horizontalAlign
	 * @see #verticalAlign
	 */
	public var rowVerticalAlign(get, set):String;
	public function get_rowVerticalAlign():String
	{
		return this._rowVerticalAlign;
	}

	/**
	 * @private
	 */
	public function set_rowVerticalAlign(value:String):String
	{
		if(this._rowVerticalAlign == value)
		{
			return get_rowVerticalAlign();
		}
		this._rowVerticalAlign = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_rowVerticalAlign();
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
	 * have variable width and height values. If false, the items will all
	 * share the same dimensions with the typical item.
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
	private var _widthCache:Array<Null<Float>> = [];

	/**
	 * @private
	 */
	private var _heightCache:Array<Null<Float>> = [];

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
		var boundsX:Float = viewPortBounds != null ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds != null ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds != null ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds != null ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds != null ? viewPortBounds.maxWidth : Math.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds != null ? viewPortBounds.maxHeight : Math.POSITIVE_INFINITY;
		var explicitWidth:Float = viewPortBounds != null ? viewPortBounds.explicitWidth : Math.NaN;
		var explicitHeight:Float = viewPortBounds != null ? viewPortBounds.explicitHeight : Math.NaN;
		
		//let's figure out if we can show multiple rows
		var supportsMultipleRows:Bool = true;
		var availableRowWidth:Float = explicitWidth;
		if(availableRowWidth != availableRowWidth) //isNaN
		{
			availableRowWidth = maxWidth;
			if(availableRowWidth == Math.POSITIVE_INFINITY)
			{
				supportsMultipleRows = false;
			}
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

		var i:Int = 0;
		var itemCount:Int = items.length;
		var positionY:Float = boundsY + this._paddingTop;
		var maxItemHeight:Float = 0;
		var horizontalGap:Float = this._horizontalGap;
		var verticalGap:Float = this._verticalGap;
		var item:DisplayObject;
		do
		{
			if(i > 0)
			{
				positionY += maxItemHeight + verticalGap;
			}
			//this section prepares some variables needed for the following loop
			maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
			var positionX:Float = boundsX + this._paddingLeft;
			//we save the items in this row to align them later.
			this._rowItems.splice(0, this._rowItems.length);
			var rowItemCount:Int = 0;
			
			//this first loop sets the x position of items, and it calculates
			//the total width of all items
			//for(; i < itemCount; i++)
			while(i < itemCount)
			{
				item = items[i];

				var cachedWidth:Float = Math.NaN;
				var cachedHeight:Float = Math.NaN;
				var itemWidth:Float;
				var itemHeight:Float;
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					cachedWidth = this._widthCache[i];
					cachedHeight = this._heightCache[i];
				}
				if(this._useVirtualLayout && item == null)
				{
					//the item is null, and the layout is virtualized, so we
					//need to estimate the width of the item.
					
					if(this._hasVariableItemDimensions)
					{
						if(cachedWidth != cachedWidth)
						{
							itemWidth = calculatedTypicalItemWidth;
						}
						else
						{
							itemWidth = cachedWidth;
						}
						if(cachedHeight != cachedHeight)
						{
							itemHeight = calculatedTypicalItemHeight;
						}
						else
						{
							itemHeight = cachedHeight;
						}
					}
					else
					{
						itemWidth = calculatedTypicalItemWidth;
						itemHeight = calculatedTypicalItemHeight;
					}
				}
				else
				{
					//we get here if the item isn't null. it is never null if
					//the layout isn't virtualized.
					if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
					{
						i++;
						continue;
					}
					if(Std.is(item, IValidating))
					{
						cast(item, IValidating).validate();
					}
					itemWidth = item.width;
					itemHeight = item.height;
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(itemWidth != cachedWidth)
							{
								//update the cache if needed. this will notify
								//the container that the virtualized layout has
								//changed, and it the view port may need to be
								//re-measured.
								this._widthCache[i] = itemWidth;
								this.dispatchEventWith(Event.CHANGE);
							}
							if(itemHeight != cachedHeight)
							{
								this._heightCache[i] = itemHeight;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else
						{
							if(calculatedTypicalItemWidth >= 0)
							{
								item.width = itemWidth = calculatedTypicalItemWidth;
							}
							if(calculatedTypicalItemHeight >= 0)
							{
								item.height = itemHeight = calculatedTypicalItemHeight;
							}
						}
					}
				}
				if(supportsMultipleRows && rowItemCount > 0 && (positionX + itemWidth) > (availableRowWidth - this._paddingRight))
				{
					//we've reached the end of the row, so go to next
					break;
				}
				if(item != null)
				{
					this._rowItems[this._rowItems.length] = item;
					item.x = item.pivotX + positionX;
				}
				positionX += itemWidth + horizontalGap;
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
				rowItemCount++;
				
				i++;
			}

			//this is the total width of all items in the row
			var totalRowWidth:Float = positionX - horizontalGap + this._paddingRight - boundsX;
			rowItemCount = this._rowItems.length;

			if(supportsMultipleRows)
			{
				//in this section, we handle horizontal alignment.
				var horizontalAlignOffsetX:Float = 0;
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					horizontalAlignOffsetX = availableRowWidth - totalRowWidth;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					horizontalAlignOffsetX = Math.round((availableRowWidth - totalRowWidth) / 2);
				}
				if(horizontalAlignOffsetX != 0)
				{
					//for(var j:Int = 0; j < rowItemCount; j++)
					for(j in 0 ... rowItemCount)
					{
						item = this._rowItems[j];
						if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
						{
							continue;
						}
						item.x += horizontalAlignOffsetX;
					}
				}
			}

			//for(j = 0; j < rowItemCount; j++)
			for(j in 0 ... rowItemCount)
			{
				item = this._rowItems[j];
				var layoutItem:ILayoutDisplayObject = safe_cast(item, ILayoutDisplayObject);
				if(layoutItem != null && !layoutItem.includeInLayout)
				{
					continue;
				}
				//handle all other vertical alignment values. the y position
				//of all items is set here.
				switch(this._rowVerticalAlign)
				{
					case VERTICAL_ALIGN_BOTTOM:
					{
						item.y = item.pivotY + positionY + maxItemHeight - item.height;
						break;
					}
					case VERTICAL_ALIGN_MIDDLE:
					{
						//round to the nearest pixel when dividing by 2 to
						//align in the middle
						item.y = item.pivotY + positionY + Math.round((maxItemHeight - item.height) / 2);
						break;
					}
					default: //top
					{
						item.y = item.pivotY + positionY;
					}
				}
			}
		}
		while(i < itemCount);
		//we don't want to keep a reference to any of the items, so clear
		//this cache
		this._rowItems.splice(0, this._rowItems.length);

		var totalHeight:Float = positionY + maxItemHeight + this._paddingBottom;
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
		
		if(totalHeight < availableHeight &&
			this._verticalAlign != VERTICAL_ALIGN_TOP)
		{
			var verticalAlignOffset:Float = availableHeight - totalHeight;
			if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				verticalAlignOffset /= 2;
			}
			//for(i = 0; i < itemCount; i++)
			for(i in 0 ... itemCount)
			{
				item = items[i];
				if(item == null || (Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout))
				{
					continue;
				}
				item.y += verticalAlignOffset;
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
		result.contentWidth = availableRowWidth;
		result.contentY = 0;
		result.contentHeight = totalHeight;
		result.viewPortWidth = availableRowWidth;
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
		//this function is very long because it may be called every frame,
		//in some situations. testing revealed that splitting this function
		//into separate, smaller functions affected performance.
		//since the SWC compiler cannot inline functions, we can't use that
		//feature either.

		//since viewPortBounds can be null, we may need to provide some defaults
		var boundsX:Float = viewPortBounds != null ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds != null ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds != null ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds != null ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds != null ? viewPortBounds.maxWidth : Math.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds != null ? viewPortBounds.maxHeight : Math.POSITIVE_INFINITY;
		var explicitWidth:Float = viewPortBounds != null ? viewPortBounds.explicitWidth : Math.NaN;
		var explicitHeight:Float = viewPortBounds != null ? viewPortBounds.explicitHeight : Math.NaN;

		//let's figure out if we can show multiple rows
		var supportsMultipleRows:Bool = true;
		var availableRowWidth:Float = explicitWidth;
		if(availableRowWidth != availableRowWidth) //isNaN
		{
			availableRowWidth = maxWidth;
			if(availableRowWidth == Math.POSITIVE_INFINITY)
			{
				supportsMultipleRows = false;
			}
		}
		
		if(Std.is(this._typicalItem, IValidating))
		{
			cast(this._typicalItem, IValidating).validate();
		}
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var i:Int = 0;
		var positionY:Float = boundsY + this._paddingTop;
		var maxItemHeight:Float = 0;
		var horizontalGap:Float = this._horizontalGap;
		var verticalGap:Float = this._verticalGap;
		do
		{
			if(i > 0)
			{
				positionY += maxItemHeight + verticalGap;
			}
			//this section prepares some variables needed for the following loop
			maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
			var positionX:Float = boundsX + this._paddingLeft;
			var rowItemCount:Int = 0;

			//this first loop sets the x position of items, and it calculates
			//the total width of all items
			//for(; i < itemCount; i++)
			while(i < itemCount)
			{
				var itemWidth:Float;
				var itemHeight:Float;
				if(this._hasVariableItemDimensions)
				{
					var cachedWidth:Float = this._widthCache[i];
					var cachedHeight:Float = this._heightCache[i];
					if(cachedWidth != cachedWidth)
					{
						itemWidth = calculatedTypicalItemWidth;
					}
					else
					{
						itemWidth = cachedWidth;
					}
					if(cachedHeight != cachedHeight)
					{
						itemHeight = calculatedTypicalItemHeight;
					}
					else
					{
						itemHeight = cachedHeight;
					}
				}
				else
				{
					itemWidth = calculatedTypicalItemWidth;
					itemHeight = calculatedTypicalItemHeight;
				}
				if(supportsMultipleRows && rowItemCount > 0 && (positionX + itemWidth) > (availableRowWidth - this._paddingRight))
				{
					//we've reached the end of the row, so go to next
					break;
				}
				positionX += itemWidth + horizontalGap;
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
				rowItemCount++;
				
				i++;
			}
		}
		while(i < itemCount);
		
		var totalHeight:Float = positionY + maxItemHeight + this._paddingBottom;
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

		result.x = availableRowWidth;
		result.y = availableHeight;
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function getNearestScrollPositionForIndex(index:Int, scrollX:Float, scrollY:Float, items:Array<DisplayObject>,
		x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		result = this.calculateMaxScrollYAndRowHeightOfIndex(index, items, x, y, width, height, result);
		var maxScrollY:Float = result.x;
		var rowHeight:Float = result.y;
		
		result.x = 0;
		
		var bottomPosition:Float = maxScrollY - (height - rowHeight);
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
		result = this.calculateMaxScrollYAndRowHeightOfIndex(index, items, x, y, width, height, result);
		var maxScrollY:Float = result.x;
		var rowHeight:Float = result.y;

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
	 * @inheritDoc
	 */
	public function resetVariableVirtualCache():Void
	{
		this._widthCache.splice(0, this._widthCache.length);
		this._heightCache.splice(0, this._heightCache.length);
	}

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		#if 0
		delete this._widthCache[index];
		delete this._heightCache[index];
		#else
		this._widthCache.splice(index, 1);
		this._heightCache.splice(index, 1);
		#end
		if(item != null)
		{
			this._widthCache[index] = item.width;
			this._heightCache[index] = item.height;
			this.dispatchEventWith(Event.CHANGE);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function addToVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		var widthValue:Null<Float> = item != null ? item.width: null;
		this._widthCache.insert(index, widthValue);
		
		var heightValue:Null<Float> = item != null ? item.height : null;
		this._heightCache.insert(index, heightValue);
	}

	/**
	 * @inheritDoc
	 */
	public function removeFromVariableVirtualCacheAtIndex(index:Int):Void
	{
		this._widthCache.splice(index, 1);
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

		var resultLastIndex:Int = 0;

		var i:Int = 0;
		var positionY:Float = this._paddingTop;
		var maxItemHeight:Float = 0;
		var horizontalGap:Float = this._horizontalGap;
		var verticalGap:Float = this._verticalGap;
		var maxPositionY:Float = scrollY + height;
		do
		{
			if(i > 0)
			{
				positionY += maxItemHeight + verticalGap;
				if(positionY >= maxPositionY)
				{
					//the following rows will not be visible, so we can stop
					break;
				}
			}
			//this section prepares some variables needed for the following loop
			maxItemHeight = calculatedTypicalItemHeight;
			var positionX:Float = this._paddingLeft;
			var rowItemCount:Int = 0;

			//this first loop sets the x position of items, and it calculates
			//the total width of all items
			//for(; i < itemCount; i++)
			while(i < itemCount)
			{
				var cachedWidth:Float = Math.NaN;
				var cachedHeight:Float = Math.NaN;
				if(this._hasVariableItemDimensions)
				{
					cachedWidth = this._widthCache[i];
					cachedHeight = this._heightCache[i];
				}
				var itemWidth:Float;
				var itemHeight:Float;
				if(this._hasVariableItemDimensions)
				{
					if(cachedWidth != cachedWidth)
					{
						itemWidth = calculatedTypicalItemWidth;
					}
					else
					{
						itemWidth = cachedWidth;
					}
					if(cachedHeight != cachedHeight)
					{
						itemHeight = calculatedTypicalItemHeight;
					}
					else
					{
						itemHeight = cachedHeight;
					}
				}
				else
				{
					itemWidth = calculatedTypicalItemWidth;
					itemHeight = calculatedTypicalItemHeight;
				}
				if(rowItemCount > 0 && (positionX + itemWidth) > (width - this._paddingRight))
				{
					//we've reached the end of the row, so go to next
					break;
				}
				if((positionY + itemHeight) > scrollY)
				{
					result[resultLastIndex] = i;
					resultLastIndex++;
				}
				positionX += itemWidth + horizontalGap;
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
				rowItemCount++;
				
				i++;
			}
		}
		while(i < itemCount);
		return result;
	}

	/**
	 * @private
	 */
	private function calculateMaxScrollYAndRowHeightOfIndex(index:Int, items:Array<DisplayObject>,
		x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
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

		var horizontalGap:Float = this._horizontalGap;
		var verticalGap:Float = this._verticalGap;
		var maxItemHeight:Float = 0;
		var positionY:Float = y + this._paddingTop;
		var i:Int = 0;
		var itemCount:Int = items.length;
		var isLastRow:Bool = false;
		do
		{
			if(isLastRow)
			{
				break;
			}
			if(i > 0)
			{
				positionY += maxItemHeight + verticalGap;
			}
			//this section prepares some variables needed for the following loop
			maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
			var positionX:Float = x + this._paddingLeft;
			var rowItemCount:Int = 0;
			//for(; i < itemCount; i++)
			while(i < itemCount)
			{
				var item:DisplayObject = items[i];

				var cachedWidth:Float = Math.NaN;
				var cachedHeight:Float = Math.NaN;
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					cachedWidth = this._widthCache[i];
					cachedHeight = this._heightCache[i];
				}
				var itemWidth:Float;
				var itemHeight:Float;
				if(this._useVirtualLayout && item == null)
				{
					//the item is null, and the layout is virtualized, so we
					//need to estimate the width of the item.
					if(this._hasVariableItemDimensions)
					{
						if(cachedWidth != cachedWidth) //isNaN
						{
							itemWidth = calculatedTypicalItemWidth;
						}
						else
						{
							itemWidth = cachedWidth;
						}
						if(cachedHeight != cachedHeight) //isNaN
						{
							itemHeight = calculatedTypicalItemHeight;
						}
						else
						{
							itemHeight = cachedHeight;
						}
					}
					else
					{
						itemWidth = calculatedTypicalItemWidth;
						itemHeight = calculatedTypicalItemHeight;
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
					if(Std.is(item, IValidating))
					{
						cast(item, IValidating).validate();
					}
					itemWidth = item.width;
					itemHeight = item.height;
					if(this._useVirtualLayout && this._hasVariableItemDimensions)
					{
						if(this._hasVariableItemDimensions)
						{
							if(itemWidth != cachedWidth)
							{
								this._widthCache[i] = itemWidth;
								this.dispatchEventWith(Event.CHANGE);
							}
							if(itemHeight != cachedHeight)
							{
								this._heightCache[i] = itemHeight;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else
						{
							if(calculatedTypicalItemWidth >= 0)
							{
								itemWidth = calculatedTypicalItemWidth;
							}
							if(calculatedTypicalItemHeight >= 0)
							{
								itemHeight = calculatedTypicalItemHeight;
							}
						}
					}
				}
				if(rowItemCount > 0 && (positionX + itemWidth) > (width - this._paddingRight))
				{
					//we've reached the end of the row, so go to next
					break;
				}
				//we don't check this at the beginning of the loop because
				//it may break to start a new row and then redo this item
				if(i == index)
				{
					isLastRow = true;
				}
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
				positionX += itemWidth + horizontalGap;
				rowItemCount++;
				
				i++;
			}
		}
		while(i < itemCount);
		result.setTo(positionY, maxItemHeight);
		return result;
	}
}
