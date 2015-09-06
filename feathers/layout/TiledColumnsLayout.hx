/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IValidating;
import openfl.errors.RangeError;

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
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Positions items as tiles (equal width and height) from top to bottom
 * in multiple columns. Constrained to the suggested height, the tiled
 * columns layout will change in width as the number of items increases or
 * decreases.
 *
 * @see ../../../help/tiled-columns-layout.html How to use TiledColumnsLayout with Feathers containers
 */
class TiledColumnsLayout extends EventDispatcher implements IVirtualLayout
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
	 * If an item height is smaller than the height of a tile, the item will
	 * be aligned to the top edge of the tile.
	 *
	 * @see #tileVerticalAlign
	 */
	inline public static var TILE_VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * If an item height is smaller than the height of a tile, the item will
	 * be aligned to the middle of the tile.
	 *
	 * @see #tileVerticalAlign
	 */
	inline public static var TILE_VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * If an item height is smaller than the height of a tile, the item will
	 * be aligned to the bottom edge of the tile.
	 *
	 * @see #tileVerticalAlign
	 */
	inline public static var TILE_VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * The item will be resized to fit the height of the tile.
	 *
	 * @see #tileVerticalAlign
	 */
	inline public static var TILE_VERTICAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * If an item width is smaller than the width of a tile, the item will
	 * be aligned to the left edge of the tile.
	 *
	 * @see #tileHorizontalAlign
	 */
	inline public static var TILE_HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * If an item width is smaller than the width of a tile, the item will
	 * be aligned to the center of the tile.
	 *
	 * @see #tileHorizontalAlign
	 */
	inline public static var TILE_HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * If an item width is smaller than the width of a tile, the item will
	 * be aligned to the right edge of the tile.
	 *
	 * @see #tileHorizontalAlign
	 */
	inline public static var TILE_HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * The item will be resized to fit the width of the tile.
	 *
	 * @see #tileHorizontalAlign
	 */
	inline public static var TILE_HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * The items will be positioned in pages horizontally from left to right.
	 *
	 * @see #paging
	 */
	inline public static var PAGING_HORIZONTAL:String = "horizontal";

	/**
	 * The items will be positioned in pages vertically from top to bottom.
	 *
	 * @see #paging
	 */
	inline public static var PAGING_VERTICAL:String = "vertical";

	/**
	 * The items will not be paged. In other words, they will be positioned
	 * in a continuous set of columns without gaps.
	 *
	 * @see #paging
	 */
	inline public static var PAGING_NONE:String = "none";

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
	private var _discoveredItemsCache:Array<DisplayObject> = new Array();

	/**
	 * Quickly sets both <code>horizontalGap</code> and <code>verticalGap</code>
	 * to the same value. The <code>gap</code> getter always returns the
	 * value of <code>verticalGap</code>, but the value of
	 * <code>horizontalGap</code> may be different.
	 *
	 * @default 0
	 *
	 * @see #horizontalGap
	 * @see #verticalGap
	 */
	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return this._verticalGap;
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
	 * The horizontal space, in pixels, between tiles.
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
	 * The vertical space, in pixels, between tiles.
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
	private var _requestedRowCount:Int = 0;

	/**
	 * Requests that the layout uses a specific number of rows in a column,
	 * if possible. Set to <code>0</code> to calculate the maximum of
	 * rows that will fit in the available space.
	 *
	 * <p>If the view port's explicit or maximum height is not large enough
	 * to fit the requested number of rows, it will use fewer. If the
	 * view port doesn't have an explicit height and the maximum height is
	 * equal to <code>Number.POSITIVE_INFINITY</code>, the height will be
	 * calculated automatically to fit the exact number of requested
	 * rows.</p>
	 *
	 * <p>If paging is enabled, this value will be used to calculate the
	 * number of rows in a page. If paging isn't enabled, this value will
	 * be used to calculate a minimum number of rows, even if there aren't
	 * enough items to fill each row.</p>
	 *
	 * @default 0
	 */
	public var requestedRowCount(get, set):Int;
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
	private var _requestedColumnCount:Int = 0;

	/**
	 * Requests that the layout uses a specific number of columns in a row,
	 * if possible. If the view port's explicit or maximum width is not large
	 * enough to fit the requested number of columns, it will use fewer. Set
	 * to <code>0</code> to calculate the number of columns automatically
	 * based on width and height.
	 *
	 * <p>If paging is enabled, this value will be used to calculate the
	 * number of columns in a page. If paging isn't enabled, this value will
	 * be used to calculate a minimum number of columns, even if there
	 * aren't enough items to fill each column.</p>
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
	private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

	//[Inspectable(type="String",enumeration="top,middle,bottom")]
	/**
	 * If the total column height is less than the bounds, the items in the
	 * column can be aligned vertically.
	 *
	 * @default TiledColumnsLayout.VERTICAL_ALIGN_TOP
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
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

	//[Inspectable(type="String",enumeration="left,center,right")]
	/**
	 * If the total row width is less than the bounds, the items in the row
	 * can be aligned horizontally.
	 *
	 * @default TiledColumnsLayout.HORIZONTAL_ALIGN_CENTER
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
	private var _tileVerticalAlign:String = TILE_VERTICAL_ALIGN_MIDDLE;

	//[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
	/**
	 * If an item's height is less than the tile bounds, the position of the
	 * item can be aligned vertically.
	 *
	 * @default TiledColumnsLayout.TILE_VERTICAL_ALIGN_MIDDLE
	 *
	 * @see #TILE_VERTICAL_ALIGN_TOP
	 * @see #TILE_VERTICAL_ALIGN_MIDDLE
	 * @see #TILE_VERTICAL_ALIGN_BOTTOM
	 * @see #TILE_VERTICAL_ALIGN_JUSTIFY
	 */
	public var tileVerticalAlign(get, set):String;
	public function get_tileVerticalAlign():String
	{
		return this._tileVerticalAlign;
	}

	/**
	 * @private
	 */
	public function set_tileVerticalAlign(value:String):String
	{
		if(this._tileVerticalAlign == value)
		{
			return get_tileVerticalAlign();
		}
		this._tileVerticalAlign = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_tileVerticalAlign();
	}

	/**
	 * @private
	 */
	private var _tileHorizontalAlign:String = TILE_HORIZONTAL_ALIGN_CENTER;

	//[Inspectable(type="String",enumeration="left,center,right,justify")]
	/**
	 * If the item's width is less than the tile bounds, the position of the
	 * item can be aligned horizontally.
	 *
	 * @default TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_CENTER
	 *
	 * @see #TILE_HORIZONTAL_ALIGN_LEFT
	 * @see #TILE_HORIZONTAL_ALIGN_CENTER
	 * @see #TILE_HORIZONTAL_ALIGN_RIGHT
	 * @see #TILE_HORIZONTAL_ALIGN_JUSTIFY
	 */
	public var tileHorizontalAlign(get, set):String;
	public function get_tileHorizontalAlign():String
	{
		return this._tileHorizontalAlign;
	}

	/**
	 * @private
	 */
	public function set_tileHorizontalAlign(value:String):String
	{
		if(this._tileHorizontalAlign == value)
		{
			return get_tileHorizontalAlign();
		}
		this._tileHorizontalAlign = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_tileHorizontalAlign();
	}

	/**
	 * @private
	 */
	private var _paging:String = PAGING_NONE;

	/**
	 * If the total combined width of the columns is larger than the width
	 * of the view port, the layout will be split into pages where each
	 * page is filled with the maximum number of columns that may be
	 * displayed without cutting off any items.
	 *
	 * @default TiledColumnsLayout.PAGING_NONE
	 *
	 * @see #PAGING_NONE
	 * @see #PAGING_HORIZONTAL
	 * @see #PAGING_VERTICAL
	 */
	public var paging(get, set):String;
	public function get_paging():String
	{
		return this._paging;
	}

	/**
	 * @private
	 */
	public function set_paging(value:String):String
	{
		if(this._paging == value)
		{
			return get_paging();
		}
		this._paging = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_paging();
	}

	/**
	 * @private
	 */
	private var _useSquareTiles:Bool = true;

	/**
	 * Determines if the tiles must be square or if their width and height
	 * may have different values.
	 *
	 * @default true
	 */
	public var useSquareTiles(get, set):Bool;
	public function get_useSquareTiles():Bool
	{
		return this._useSquareTiles;
	}

	/**
	 * @private
	 */
	public function set_useSquareTiles(value:Bool):Bool
	{
		if(this._useSquareTiles == value)
		{
			return get_useSquareTiles();
		}
		this._useSquareTiles = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_useSquareTiles();
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
		if(result == null)
		{
			result = new LayoutBoundsResult();
		}
		if(items.length == 0)
		{
			result.contentX = 0;
			result.contentY = 0;
			result.contentWidth = 0;
			result.contentHeight = 0;
			result.viewPortWidth = 0;
			result.viewPortHeight = 0;
			return result;
		}

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
			this.prepareTypicalItem();
			calculatedTypicalItemWidth = this._typicalItem != null ? this._typicalItem.width : 0;
			calculatedTypicalItemHeight = this._typicalItem != null ? this._typicalItem.height : 0;
		}
		this.validateItems(items);

		this._discoveredItemsCache.splice(0, this._discoveredItemsCache.length);
		var itemCount:Int = items.length;
		var tileWidth:Float = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
		var tileHeight:Float = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
		//a virtual layout assumes that all items are the same size as
		//the typical item, so we don't need to measure every item in
		//that case
		var item:DisplayObject;
		if(!this._useVirtualLayout)
		{
			for(i in 0 ... itemCount)
			{
				item = items[i];
				if(item == null)
				{
					continue;
				}
				if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
				{
					continue;
				}
				var itemWidth:Float = item.width;
				var itemHeight:Float = item.height;
				if(itemWidth > tileWidth)
				{
					tileWidth = itemWidth;
				}
				if(itemHeight > tileHeight)
				{
					tileHeight = itemHeight;
				}
			}
		}
		if(tileWidth < 0)
		{
			tileWidth = 0;
		}
		if(tileHeight < 0)
		{
			tileHeight = 0;
		}
		if(this._useSquareTiles)
		{
			if(tileWidth > tileHeight)
			{
				tileHeight = tileWidth;
			}
			else if(tileHeight > tileWidth)
			{
				tileWidth = tileHeight;
			}
		}

		var availableWidth:Float = Math.NaN;
		var availableHeight:Float = Math.NaN;

		var verticalTileCount:Int;
		if(explicitHeight == explicitHeight) //!isNaN
		{
			availableHeight = explicitHeight;
			verticalTileCount = Std.int((explicitHeight - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap));
		}
		else if(maxHeight == maxHeight && //!isNaN
			maxHeight < Math.POSITIVE_INFINITY)
		{
			availableHeight = maxHeight;
			verticalTileCount = Std.int((maxHeight - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap));
		}
		else if(this._requestedRowCount > 0)
		{
			verticalTileCount = this._requestedRowCount;
			availableHeight = this._paddingTop + this._paddingBottom + ((tileHeight + this._verticalGap) * verticalTileCount) - this._verticalGap;
		}
		else
		{
			//put everything in one column
			verticalTileCount = itemCount;
		}
		if(verticalTileCount < 1)
		{
			//we must have at least one tile per column
			verticalTileCount = 1;
		}
		else if(this._requestedRowCount > 0)
		{
			if(availableHeight != availableHeight) //isNaN
			{
				verticalTileCount = this._requestedRowCount;
				availableHeight = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap - this._paddingTop - this._paddingBottom;
			}
			else if(verticalTileCount > this._requestedRowCount)
			{
				verticalTileCount = this._requestedRowCount;
			}
		}
		var horizontalTileCount:Int;
		if(explicitWidth == explicitWidth) //!isNaN
		{
			availableWidth = explicitWidth;
			horizontalTileCount = Std.int((explicitWidth - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap));
		}
		else if(maxWidth == maxWidth && //!isNaN
			maxWidth < Math.POSITIVE_INFINITY)
		{
			availableWidth = maxWidth;
			horizontalTileCount = Std.int((maxWidth - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap));
		}
		else
		{
			//using the vertical tile count, calculate how many rows will
			//be required for the total number of items.
			horizontalTileCount = Math.ceil(itemCount / verticalTileCount);
		}
		if(horizontalTileCount < 1)
		{
			//we must have at least one tile per row
			horizontalTileCount = 1;
		}
		else if(this._requestedColumnCount > 0)
		{
			if(availableWidth != availableWidth) //isNaN
			{
				horizontalTileCount = this._requestedColumnCount;
				availableWidth = horizontalTileCount * (tileWidth + this._horizontalGap) - this._horizontalGap - this._paddingLeft - this._paddingRight;
			}
			else if(horizontalTileCount > this._requestedColumnCount)
			{
				horizontalTileCount = this._requestedColumnCount;
			}
		}

		var totalPageWidth:Float = horizontalTileCount * (tileWidth + this._horizontalGap) - this._horizontalGap + this._paddingLeft + this._paddingRight;
		var totalPageHeight:Float = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;
		var availablePageWidth:Float = availableWidth;
		if(availablePageWidth != availablePageWidth) //isNaN
		{
			availablePageWidth = totalPageWidth;
		}
		var availablePageHeight:Float = availableHeight;
		if(availablePageHeight != availablePageHeight) //isNaN
		{
			availablePageHeight = totalPageHeight;
		}

		var startX:Float = boundsX + this._paddingLeft;
		var startY:Float = boundsY + this._paddingTop;

		var perPage:Int = horizontalTileCount * verticalTileCount;
		var pageIndex:Int = 0;
		var nextPageStartIndex:Int = perPage;
		var pageStartY:Float = startY;
		var positionX:Float = startX;
		var positionY:Float = startY;
		var itemIndex:Int = 0;
		var discoveredItemsCachePushIndex:Int = 0;
		
		var discoveredItems:Array<DisplayObject>;
		var discoveredItemsFirstIndex:Int = 0;
		var discoveredItemsLastIndex:Int = 0;
		var i:Int = 0;
		while(i < itemCount)
		{
			item = items[i];
			if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
			{
				continue;
			}
			if(itemIndex != 0 && i % verticalTileCount == 0)
			{
				positionX += tileWidth + this._horizontalGap;
				positionY = pageStartY;
			}
			if(itemIndex == nextPageStartIndex)
			{
				//we're starting a new page, so handle alignment of the
				//items on the current page and update the positions
				if(this._paging != PAGING_NONE)
				{
					discoveredItems = this._useVirtualLayout ? this._discoveredItemsCache : items;
					discoveredItemsFirstIndex = this._useVirtualLayout ? 0 : (itemIndex - perPage);
					discoveredItemsLastIndex = this._useVirtualLayout ? (this._discoveredItemsCache.length - 1) : (itemIndex - 1);
					this.applyHorizontalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageWidth, availablePageWidth);
					this.applyVerticalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageHeight, availablePageHeight);
					this._discoveredItemsCache.splice(0, this._discoveredItemsCache.length);
					discoveredItemsCachePushIndex = 0;
				}
				pageIndex++;
				nextPageStartIndex += perPage;

				//we can use availableWidth and availableHeight here without
				//checking if they're NaN because we will never reach a
				//new page without them already being calculated.
				if(this._paging == PAGING_HORIZONTAL)
				{
					positionX = startX + availableWidth * pageIndex;
				}
				else if(this._paging == PAGING_VERTICAL)
				{
					positionX = startX;
					positionY = pageStartY = startY + availableHeight * pageIndex;
				}
			}
			if(item != null)
			{
				switch(this._tileHorizontalAlign)
				{
					case TILE_HORIZONTAL_ALIGN_JUSTIFY:
					{
						item.x = item.pivotX + positionX;
						item.width = tileWidth;
						//break;
					}
					case TILE_HORIZONTAL_ALIGN_LEFT:
					{
						item.x = item.pivotX + positionX;
						//break;
					}
					case TILE_HORIZONTAL_ALIGN_RIGHT:
					{
						item.x = item.pivotX + positionX + tileWidth - item.width;
						//break;
					}
					default: //center or unknown
					{
						item.x = item.pivotX + positionX + Math.round((tileWidth - item.width) / 2);
					}
				}
				switch(this._tileVerticalAlign)
				{
					case TILE_VERTICAL_ALIGN_JUSTIFY:
					{
						item.y = item.pivotY + positionY;
						item.height = tileHeight;
						//break;
					}
					case TILE_VERTICAL_ALIGN_TOP:
					{
						item.y = item.pivotY + positionY;
						//break;
					}
					case TILE_VERTICAL_ALIGN_BOTTOM:
					{
						item.y = item.pivotY + positionY + tileHeight - item.height;
						//break;
					}
					default: //middle or unknown
					{
						item.y = item.pivotY + positionY + Math.round((tileHeight - item.height) / 2);
					}
				}
				if(this._useVirtualLayout)
				{
					this._discoveredItemsCache[discoveredItemsCachePushIndex] = item;
					discoveredItemsCachePushIndex++;
				}
			}
			positionY += tileHeight + this._verticalGap;
			itemIndex++;
			
			i++;
		}
		//align the last page
		if(this._paging != PAGING_NONE)
		{
			discoveredItems = this._useVirtualLayout ? this._discoveredItemsCache : items;
			discoveredItemsFirstIndex = this._useVirtualLayout ? 0 : (nextPageStartIndex - perPage);
			discoveredItemsLastIndex = this._useVirtualLayout ? (this._discoveredItemsCache.length - 1) : (i - 1);
			this.applyHorizontalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageWidth, availablePageWidth);
			this.applyVerticalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageHeight, availablePageHeight);
		}

		var totalWidth:Float = positionX + tileWidth + this._paddingRight;
		if(availableWidth == availableWidth) //!isNaN
		{
			if(this._paging == PAGING_VERTICAL)
			{
				totalWidth = availableWidth;
			}
			else if(this._paging == PAGING_HORIZONTAL)
			{
				totalWidth = Math.ceil(itemCount / perPage) * availableWidth;
			}
		}
		var totalHeight:Float = totalPageHeight;
		if(availableHeight == availableHeight && //!isNaN
			this._paging == PAGING_VERTICAL)
		{
			totalHeight = Math.ceil(itemCount / perPage) * availableHeight;
		}

		if(availableWidth != availableWidth) //isNaN
		{
			availableWidth = totalWidth;
		}
		if(availableHeight != availableHeight) //isNaN
		{
			availableHeight = totalHeight;
		}
		if(availableWidth < minWidth)
		{
			availableWidth = minWidth;
		}
		if(availableHeight < minHeight)
		{
			availableHeight = minHeight;
		}

		if(this._paging == PAGING_NONE)
		{
			discoveredItems = this._useVirtualLayout ? this._discoveredItemsCache : items;
			discoveredItemsLastIndex = discoveredItems.length - 1;
			this.applyHorizontalAlign(discoveredItems, 0, discoveredItemsLastIndex, totalWidth, availableWidth);
			this.applyVerticalAlign(discoveredItems, 0, discoveredItemsLastIndex, totalHeight, availableHeight);
		}
		this._discoveredItemsCache.splice(0, this._discoveredItemsCache.length);

		if(result == null)
		{
			result = new LayoutBoundsResult();
		}
		result.contentX = 0;
		result.contentY = 0;
		result.contentWidth = totalWidth;
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
		var boundsX:Float = viewPortBounds != null ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds != null ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds != null ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds != null ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds != null ? viewPortBounds.maxWidth : Math.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds != null ? viewPortBounds.maxHeight : Math.POSITIVE_INFINITY;

		this.prepareTypicalItem();
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var tileWidth:Float = calculatedTypicalItemWidth;
		var tileHeight:Float = calculatedTypicalItemHeight;
		if(tileWidth < 0)
		{
			tileWidth = 0;
		}
		if(tileHeight < 0)
		{
			tileHeight = 0;
		}
		if(this._useSquareTiles)
		{
			if(tileWidth > tileHeight)
			{
				tileHeight = tileWidth;
			}
			else if(tileHeight > tileWidth)
			{
				tileWidth = tileHeight;
			}
		}
		var availableWidth:Float = Math.NaN;
		var availableHeight:Float = Math.NaN;

		var verticalTileCount:Int;
		if(explicitHeight == explicitHeight) //!isNaN
		{
			availableHeight = explicitHeight;
			verticalTileCount = Std.int((explicitHeight - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap));
		}
		else if(maxHeight == maxHeight && //!isNaN
			maxHeight < Math.POSITIVE_INFINITY)
		{
			availableHeight = maxHeight;
			verticalTileCount = Std.int((maxHeight - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap));
		}
		else if(this._requestedRowCount > 0)
		{
			verticalTileCount = this._requestedRowCount;
			availableHeight = this._paddingTop + this._paddingBottom + ((tileHeight + this._verticalGap) * verticalTileCount) - this._verticalGap;
		}
		else
		{
			verticalTileCount = itemCount;
		}
		if(verticalTileCount < 1)
		{
			verticalTileCount = 1;
		}
		else if(this._requestedRowCount > 0)
		{
			if(availableHeight != availableHeight) //isNaN
			{
				verticalTileCount = this._requestedRowCount;
				availableHeight = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap - this._paddingTop - this._paddingBottom;
			}
			else if(verticalTileCount > this._requestedRowCount)
			{
				verticalTileCount = this._requestedRowCount;
			}
		}
		var horizontalTileCount:Int;
		if(explicitWidth == explicitWidth) //!isNaN
		{
			availableWidth = explicitWidth;
			horizontalTileCount = Std.int((explicitWidth - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap));
		}
		else if(maxWidth == maxWidth && //!isNaN
			maxWidth < Math.POSITIVE_INFINITY)
		{
			availableWidth = maxWidth;
			horizontalTileCount = Std.int((maxWidth - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap));
		}
		else
		{
			horizontalTileCount = Math.ceil(itemCount / verticalTileCount);
		}
		if(horizontalTileCount < 1)
		{
			horizontalTileCount = 1;
		}
		else if(this._requestedColumnCount > 0)
		{
			if(availableWidth != availableWidth) //isNaN
			{
				horizontalTileCount = this._requestedColumnCount;
				availableWidth = horizontalTileCount * (tileWidth + this._horizontalGap) - this._horizontalGap - this._paddingLeft - this._paddingRight;
			}
			else if(horizontalTileCount > this._requestedColumnCount)
			{
				horizontalTileCount = this._requestedColumnCount;
			}
		}

		var totalPageHeight:Float = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;

		var startX:Float = boundsX + this._paddingLeft;

		var perPage:Int = horizontalTileCount * verticalTileCount;
		var pageIndex:Int = 0;
		var nextPageStartIndex:Int = perPage;
		var positionX:Float = startX;
		for(i in 0 ... itemCount)
		{
			if(i != 0 && i % verticalTileCount == 0)
			{
				positionX += tileWidth + this._horizontalGap;
			}
			if(i == nextPageStartIndex)
			{
				pageIndex++;
				nextPageStartIndex += perPage;

				//we can use availableWidth and availableHeight here without
				//checking if they're NaN because we will never reach a
				//new page without them already being calculated.
				if(this._paging == PAGING_HORIZONTAL)
				{
					positionX = startX + availableWidth * pageIndex;
				}
				else if(this._paging == PAGING_VERTICAL)
				{
					positionX = startX;
				}
			}
		}

		var totalWidth:Float = positionX + tileWidth + this._paddingRight;
		if(availableWidth == availableWidth) //!isNaN
		{
			if(this._paging == PAGING_VERTICAL)
			{
				totalWidth = availableWidth;
			}
			else if(this._paging == PAGING_HORIZONTAL)
			{
				totalWidth = Math.ceil(itemCount / perPage) * availableWidth;
			}
		}
		var totalHeight:Float = totalPageHeight;
		if(availableHeight == availableHeight && //!isNaN
			this._paging == PAGING_VERTICAL)
		{
			totalHeight = Math.ceil(itemCount / perPage) * availableHeight;
		}

		if(needsWidth)
		{
			var resultX:Float = totalWidth;
			if(resultX < minWidth)
			{
				resultX = minWidth;
			}
			else if(resultX > maxWidth)
			{
				resultX = maxWidth;
			}
			result.x = resultX;
		}
		else
		{
			result.x = explicitWidth;
		}
		if(needsHeight)
		{
			var resultY:Float = totalHeight;
			if(resultY < minHeight)
			{
				resultY = minHeight;
			}
			else if(resultY > maxHeight)
			{
				resultY = maxHeight;
			}
			result.y = resultY;
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
			result = new Array();
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.");
		}

		if(this._paging == PAGING_HORIZONTAL)
		{
			this.getVisibleIndicesAtScrollPositionWithHorizontalPaging(scrollX, scrollY, width, height, itemCount, result);
		}
		else if(this._paging == PAGING_VERTICAL)
		{
			this.getVisibleIndicesAtScrollPositionWithVerticalPaging(scrollX, scrollY, width, height, itemCount, result);
		}
		else
		{
			this.getVisibleIndicesAtScrollPositionWithoutPaging(scrollX, scrollY, width, height, itemCount, result);
		}

		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function getNearestScrollPositionForIndex(index:Int, scrollX:Float, scrollY:Float, items:Array<DisplayObject>,
		x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		return this.calculateScrollPositionForIndex(index, items, x, y, width, height, result, true, scrollX, scrollY);
	}

	/**
	 * @inheritDoc
	 */
	public function getScrollPositionForIndex(index:Int, items:Array<DisplayObject>,
		x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		return this.calculateScrollPositionForIndex(index, items, x, y, width, height, result, false);
	}

	/**
	 * @private
	 */
	private function applyHorizontalAlign(items:Array<DisplayObject>, startIndex:Int, endIndex:Int, totalItemWidth:Float, availableWidth:Float):Void
	{
		if(totalItemWidth >= availableWidth)
		{
			return;
		}
		var horizontalAlignOffsetX:Float = 0;
		if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
		{
			horizontalAlignOffsetX = availableWidth - totalItemWidth;
		}
		else if(this._horizontalAlign != HORIZONTAL_ALIGN_LEFT)
		{
			//we're going to default to center if we encounter an
			//unknown value
			horizontalAlignOffsetX = Math.round((availableWidth - totalItemWidth) / 2);
		}
		if(horizontalAlignOffsetX != 0)
		{
			//for(var i:Int = startIndex; i <= endIndex; i++)
			var i:Int = startIndex;
			while(i <= endIndex)
			{
				var item:DisplayObject = items[i];
				if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
				{
					continue;
				}
				item.x += horizontalAlignOffsetX;

				i++;
			}
		}
	}

	/**
	 * @private
	 */
	private function applyVerticalAlign(items:Array<DisplayObject>, startIndex:Int, endIndex:Int, totalItemHeight:Float, availableHeight:Float):Void
	{
		if(totalItemHeight >= availableHeight)
		{
			return;
		}
		var verticalAlignOffsetY:Float = 0;
		if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
		{
			verticalAlignOffsetY = availableHeight - totalItemHeight;
		}
		else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
		{
			verticalAlignOffsetY = Math.round((availableHeight - totalItemHeight) / 2);
		}
		if(verticalAlignOffsetY != 0)
		{
			//for(var i:Int = startIndex; i <= endIndex; i++)
			var i:Int = startIndex;
			while(i <= endIndex)
			{
				var item:DisplayObject = items[i];
				if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
				{
					continue;
				}
				item.y += verticalAlignOffsetY;
				
				i++;
			}
		}
	}

	/**
	 * @private
	 */
	private function getVisibleIndicesAtScrollPositionWithHorizontalPaging(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Array<Int>):Void
	{
		this.prepareTypicalItem();
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var tileWidth:Float = calculatedTypicalItemWidth;
		var tileHeight:Float = calculatedTypicalItemHeight;
		if(tileWidth < 0)
		{
			tileWidth = 0;
		}
		if(tileHeight < 0)
		{
			tileHeight = 0;
		}
		if(this._useSquareTiles)
		{
			if(tileWidth > tileHeight)
			{
				tileHeight = tileWidth;
			}
			else if(tileHeight > tileWidth)
			{
				tileWidth = tileHeight;
			}
		}
		var horizontalTileCount:Int = Std.int((width - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap));
		if(horizontalTileCount < 1)
		{
			horizontalTileCount = 1;
		}
		var verticalTileCount:Int = Std.int((height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap));
		if(verticalTileCount < 1)
		{
			verticalTileCount = 1;
		}
		else if(this._requestedRowCount > 0 && verticalTileCount > this._requestedRowCount)
		{
			verticalTileCount = this._requestedRowCount;
		}
		var perPage:Int = horizontalTileCount * verticalTileCount;
		var minimumItemCount:Int = perPage + 2 * verticalTileCount;
		if(minimumItemCount > itemCount)
		{
			minimumItemCount = itemCount;
		}

		var startPageIndex:Int = Math.round(scrollX / width);
		var minimum:Int = startPageIndex * perPage;
		var totalRowWidth:Float = horizontalTileCount * (tileWidth + this._horizontalGap) - this._horizontalGap;
		var leftSideOffset:Float = 0;
		var rightSideOffset:Float = 0;
		if(totalRowWidth < width)
		{
			if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				leftSideOffset = width - this._paddingLeft - this._paddingRight - totalRowWidth;
				rightSideOffset = 0;
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
			{
				leftSideOffset = rightSideOffset = Math.round((width - this._paddingLeft - this._paddingRight - totalRowWidth) / 2);
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
			{
				leftSideOffset = 0;
				rightSideOffset = width - this._paddingLeft - this._paddingRight - totalRowWidth;
			}
		}
		var columnOffset:Int = 0;
		var pageStartPosition:Float = startPageIndex * width;
		var partialPageSize:Float = scrollX - pageStartPosition;
		if(partialPageSize < 0)
		{
			partialPageSize = -partialPageSize - this._paddingRight - rightSideOffset;
			if(partialPageSize < 0)
			{
				partialPageSize = 0;
			}
			columnOffset = -Math.floor(partialPageSize / (tileWidth + this._horizontalGap)) - 1;
			minimum += columnOffset * verticalTileCount;
		}
		else if(partialPageSize > 0)
		{
			partialPageSize = partialPageSize - this._paddingLeft - leftSideOffset;
			if(partialPageSize < 0)
			{
				partialPageSize = 0;
			}
			columnOffset = Math.floor(partialPageSize / (tileWidth + this._horizontalGap));
			minimum += columnOffset * verticalTileCount;
		}
		if(minimum < 0)
		{
			minimum = 0;
			columnOffset = 0;
		}

		var maximum:Int = minimum + minimumItemCount;
		if(maximum > itemCount)
		{
			maximum = itemCount;
		}
		minimum = maximum - minimumItemCount;
		var resultPushIndex:Int = result.length;
		for(i in minimum ... maximum)
		{
			result[resultPushIndex] = i;
			resultPushIndex++;
		}
	}

	/**
	 * @private
	 */
	private function getVisibleIndicesAtScrollPositionWithVerticalPaging(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Array<Int>):Void
	{
		this.prepareTypicalItem();
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var tileWidth:Float = calculatedTypicalItemWidth;
		var tileHeight:Float = calculatedTypicalItemHeight;
		if(tileWidth < 0)
		{
			tileWidth = 0;
		}
		if(tileHeight < 0)
		{
			tileHeight = 0;
		}
		if(this._useSquareTiles)
		{
			if(tileWidth > tileHeight)
			{
				tileHeight = tileWidth;
			}
			else if(tileHeight > tileWidth)
			{
				tileWidth = tileHeight;
			}
		}
		var horizontalTileCount:Int = Std.int((width - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap));
		if(horizontalTileCount < 1)
		{
			horizontalTileCount = 1;
		}
		var verticalTileCount:Int = Std.int((height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap));
		if(verticalTileCount < 1)
		{
			verticalTileCount = 1;
		}
		else if(this._requestedRowCount > 0 && verticalTileCount > this._requestedRowCount)
		{
			verticalTileCount = this._requestedRowCount;
		}
		var perPage:Int = horizontalTileCount * verticalTileCount;
		var minimumItemCount:Int = perPage + 2 * verticalTileCount;
		if(minimumItemCount > itemCount)
		{
			minimumItemCount = itemCount;
		}

		var startPageIndex:Int = Math.round(scrollY / height);
		var minimum:Int = startPageIndex * perPage;
		var totalColumnHeight:Float = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap;
		var topSideOffset:Float = 0;
		var bottomSideOffset:Float = 0;
		if(totalColumnHeight < height)
		{
			if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				topSideOffset = height - this._paddingTop - this._paddingBottom - totalColumnHeight;
				bottomSideOffset = 0;
			}
			else if(this._horizontalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				topSideOffset = bottomSideOffset = Math.round((height - this._paddingTop - this._paddingBottom - totalColumnHeight) / 2);
			}
			else if(this._horizontalAlign == VERTICAL_ALIGN_TOP)
			{
				topSideOffset = 0;
				bottomSideOffset = height - this._paddingTop - this._paddingBottom - totalColumnHeight;
			}
		}
		var rowOffset:Int = 0;
		var pageStartPosition:Float = startPageIndex * height;
		var partialPageSize:Float = scrollY - pageStartPosition;
		if(partialPageSize < 0)
		{
			partialPageSize = -partialPageSize - this._paddingBottom - bottomSideOffset;
			if(partialPageSize < 0)
			{
				partialPageSize = 0;
			}
			rowOffset = -Math.floor(partialPageSize / (tileWidth + this._verticalGap)) - 1;
			minimum += -perPage + horizontalTileCount + rowOffset;
		}
		else if(partialPageSize > 0)
		{
			partialPageSize = partialPageSize - this._paddingTop - topSideOffset;
			if(partialPageSize < 0)
			{
				partialPageSize = 0;
			}
			rowOffset = Math.floor(partialPageSize / (tileWidth + this._verticalGap));
			minimum += rowOffset;
		}
		if(minimum < 0)
		{
			minimum = 0;
			rowOffset = 0;
		}

		if(minimum + minimumItemCount >= itemCount)
		{
			//an optimized path when we're on or near the last page
			minimum = itemCount - minimumItemCount;
			var resultPushIndex:Int = result.length;
			for(i in minimum ... itemCount)
			{
				result[resultPushIndex] = i;
				resultPushIndex++;
			}
		}
		else
		{
			var columnIndex:Int = 0;
			var rowIndex:Int = (verticalTileCount + rowOffset) % verticalTileCount;
			var pageStart:Int = Std.int(minimum / perPage) * perPage;
			var i:Int = minimum;
			var resultLength:Int = 0;
			do
			{
				if(i < itemCount)
				{
					result[resultLength] = i;
					resultLength++;
				}
				columnIndex++;
				if(columnIndex == horizontalTileCount)
				{
					columnIndex = 0;
					rowIndex++;
					if(rowIndex == verticalTileCount)
					{
						rowIndex = 0;
						pageStart += perPage;
					}
					i = pageStart + rowIndex - verticalTileCount;
				}
				i += verticalTileCount;
			}
			while(resultLength < minimumItemCount && pageStart < itemCount);
		}
	}

	/**
	 * @private
	 */
	private function getVisibleIndicesAtScrollPositionWithoutPaging(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Array<Int>):Void
	{
		this.prepareTypicalItem();
		var calculatedTypicalItemWidth:Float = this._typicalItem != null ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem != null ? this._typicalItem.height : 0;

		var tileWidth:Float = calculatedTypicalItemWidth;
		var tileHeight:Float = calculatedTypicalItemHeight;
		if(tileWidth < 0)
		{
			tileWidth = 0;
		}
		if(tileHeight < 0)
		{
			tileHeight = 0;
		}
		if(this._useSquareTiles)
		{
			if(tileWidth > tileHeight)
			{
				tileHeight = tileWidth;
			}
			else if(tileHeight > tileWidth)
			{
				tileWidth = tileHeight;
			}
		}
		var verticalTileCount:Int = Std.int((height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap));
		if(verticalTileCount < 1)
		{
			verticalTileCount = 1;
		}
		else if(this._requestedRowCount > 0 && verticalTileCount > this._requestedRowCount)
		{
			verticalTileCount = this._requestedRowCount;
		}
		var horizontalTileCount:Int = Math.ceil((width + this._horizontalGap) / (tileWidth + this._horizontalGap)) + 1;
		var minimumItemCount:Int = verticalTileCount * horizontalTileCount;
		if(minimumItemCount > itemCount)
		{
			minimumItemCount = itemCount;
		}
		var columnIndexOffset:Int = 0;
		var totalColumnWidth:Float = Math.ceil(itemCount / verticalTileCount) * (tileWidth + this._horizontalGap) - this._horizontalGap;
		if(totalColumnWidth < width)
		{
			if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				columnIndexOffset = Math.ceil((width - totalColumnWidth) / (tileWidth + this._horizontalGap));
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				columnIndexOffset = Math.ceil((width - totalColumnWidth) / (tileWidth + this._horizontalGap) / 2);
			}
		}
		var columnIndex:Int = -columnIndexOffset + Math.floor((scrollX - this._paddingLeft + this._horizontalGap) / (tileWidth + this._horizontalGap));
		var minimum:Int = columnIndex * verticalTileCount;
		if(minimum < 0)
		{
			minimum = 0;
		}
		var maximum:Int = minimum + minimumItemCount;
		if(maximum > itemCount)
		{
			maximum = itemCount;
		}
		minimum = maximum - minimumItemCount;
		var resultPushIndex:Int = result.length;
		for(i in minimum ... maximum)
		{
			result[resultPushIndex] = i;
			resultPushIndex++;
		}
	}

	/**
	 * @private
	 */
	private function validateItems(items:Array<DisplayObject>):Void
	{
		var itemCount:Int = items.length;
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = items[i];
			if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
			{
				continue;
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
	private function prepareTypicalItem():Void
	{
		if(this._typicalItem == null)
		{
			return;
		}
		if(this._resetTypicalItemDimensionsOnMeasure)
		{
			this._typicalItem.width = this._typicalItemWidth;
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
	private function calculateScrollPositionForIndex(index:Int, items:Array<DisplayObject>, x:Float, y:Float,
		width:Float, height:Float, result:Point = null, nearest:Bool = false, scrollX:Float = 0, scrollY:Float = 0):Point
	{
		if(result == null)
		{
			result = new Point();
		}
		var calculatedTypicalItemWidth:Float = Math.NaN;
		var calculatedTypicalItemHeight:Float = Math.NaN;
		if(this._useVirtualLayout)
		{
			this.prepareTypicalItem();
			calculatedTypicalItemWidth = this._typicalItem != null ? this._typicalItem.width : 0;
			calculatedTypicalItemHeight = this._typicalItem != null ? this._typicalItem.height : 0;
		}

		var itemCount:Int = items.length;
		var tileWidth:Float = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
		var tileHeight:Float = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
		//a virtual layout assumes that all items are the same size as
		//the typical item, so we don't need to measure every item in
		//that case
		if(!this._useVirtualLayout)
		{
			//for(var i:Int = 0; i < itemCount; i++)
			for(i in 0 ... itemCount)
			{
				var item:DisplayObject = items[i];
				if(item == null)
				{
					continue;
				}
				if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
				{
					continue;
				}
				var itemWidth:Float = item.width;
				var itemHeight:Float = item.height;
				if(itemWidth > tileWidth)
				{
					tileWidth = itemWidth;
				}
				if(itemHeight > tileHeight)
				{
					tileHeight = itemHeight;
				}
			}
		}
		if(tileWidth < 0)
		{
			tileWidth = 0;
		}
		if(tileHeight < 0)
		{
			tileHeight = 0;
		}
		if(this._useSquareTiles)
		{
			if(tileWidth > tileHeight)
			{
				tileHeight = tileWidth;
			}
			else if(tileHeight > tileWidth)
			{
				tileWidth = tileHeight;
			}
		}
		var verticalTileCount:Int = Std.int((height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap));
		if(verticalTileCount < 1)
		{
			verticalTileCount = 1;
		}
		else if(this._requestedRowCount > 0 && verticalTileCount > this._requestedRowCount)
		{
			verticalTileCount = this._requestedRowCount;
		}
		if(this._paging != PAGING_NONE)
		{
			var horizontalTileCount:Int = Std.int((width - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap));
			if(horizontalTileCount < 1)
			{
				horizontalTileCount = 1;
			}
			var perPage:Float = horizontalTileCount * verticalTileCount;
			var pageIndex:Int = Std.int(index / perPage);
			if(this._paging == PAGING_HORIZONTAL)
			{
				result.x = pageIndex * width;
				result.y = 0;
			}
			else
			{
				result.x = 0;
				result.y = pageIndex * height;
			}
		}
		else
		{
			var resultX:Float = this._paddingLeft + ((tileWidth + this._horizontalGap) * Std.int(index / verticalTileCount));
			if(nearest)
			{
				var rightPosition:Float = resultX - (width - tileWidth);
				if(scrollX >= rightPosition && scrollX <= resultX)
				{
					//keep the current scroll position because the item is already
					//fully visible
					resultX = scrollX;
				}
				else
				{
					var leftDifference:Float = Math.abs(resultX - scrollX);
					var rightDifference:Float = Math.abs(rightPosition - scrollX);
					if(rightDifference < leftDifference)
					{
						resultX = rightPosition;
					}
				}
			}
			else
			{
				resultX -= Math.round((width - tileWidth) / 2);
			}
			result.x = resultX;
			result.y = 0;
		}
		return result;
	}
}
