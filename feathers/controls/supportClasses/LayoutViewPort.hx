/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.controls.LayoutGroup;
import feathers.core.IValidating;

import starling.display.DisplayObject;

/**
 * @private
 * Used internally by ScrollContainer. Not meant to be used on its own.
 */
class LayoutViewPort extends LayoutGroup implements IViewPort
{
	public function LayoutViewPort()
	{
	}

	private var _minVisibleWidth:Float = 0;

	public function get_minVisibleWidth():Float
	{
		return this._minVisibleWidth;
	}

	public function set_minVisibleWidth(value:Float):Void
	{
		if(this._minVisibleWidth == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleWidth cannot be NaN");
		}
		this._minVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	private var _maxVisibleWidth:Float = Number.POSITIVE_INFINITY;

	public function get_maxVisibleWidth():Float
	{
		return this._maxVisibleWidth;
	}

	public function set_maxVisibleWidth(value:Float):Void
	{
		if(this._maxVisibleWidth == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleWidth cannot be NaN");
		}
		this._maxVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	private var _actualVisibleWidth:Float = 0;

	private var _explicitVisibleWidth:Float = NaN;

	public function get_visibleWidth():Float
	{
		if(this._explicitVisibleWidth != this._explicitVisibleWidth) //isNaN
		{
			return this._actualVisibleWidth;
		}
		return this._explicitVisibleWidth;
	}

	public function set_visibleWidth(value:Float):Void
	{
		if(this._explicitVisibleWidth == value ||
			(value != value && this._explicitVisibleWidth != this._explicitVisibleWidth)) //isNaN
		{
			return;
		}
		this._explicitVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	private var _minVisibleHeight:Float = 0;

	public function get_minVisibleHeight():Float
	{
		return this._minVisibleHeight;
	}

	public function set_minVisibleHeight(value:Float):Void
	{
		if(this._minVisibleHeight == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleHeight cannot be NaN");
		}
		this._minVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	private var _maxVisibleHeight:Float = Number.POSITIVE_INFINITY;

	public function get_maxVisibleHeight():Float
	{
		return this._maxVisibleHeight;
	}

	public function set_maxVisibleHeight(value:Float):Void
	{
		if(this._maxVisibleHeight == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleHeight cannot be NaN");
		}
		this._maxVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	private var _actualVisibleHeight:Float = 0;

	private var _explicitVisibleHeight:Float = NaN;

	public function get_visibleHeight():Float
	{
		if(this._explicitVisibleHeight != this._explicitVisibleHeight) //isNaN
		{
			return this._actualVisibleHeight;
		}
		return this._explicitVisibleHeight;
	}

	public function set_visibleHeight(value:Float):Void
	{
		if(this._explicitVisibleHeight == value ||
			(value != value && this._explicitVisibleHeight != this._explicitVisibleHeight)) //isNaN
		{
			return;
		}
		this._explicitVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	private var _contentX:Float = 0;

	public function get_contentX():Float
	{
		return this._contentX;
	}

	private var _contentY:Float = 0;

	public function get_contentY():Float
	{
		return this._contentY;
	}

	public function get_horizontalScrollStep():Float
	{
		if(this.actualWidth < this.actualHeight)
		{
			return this.actualWidth / 10;
		}
		return this.actualHeight / 10;
	}

	public function get_verticalScrollStep():Float
	{
		if(this.actualWidth < this.actualHeight)
		{
			return this.actualWidth / 10;
		}
		return this.actualHeight / 10;
	}

	private var _horizontalScrollPosition:Float = 0;

	public function get_horizontalScrollPosition():Float
	{
		return this._horizontalScrollPosition;
	}

	public function set_horizontalScrollPosition(value:Float):Void
	{
		if(this._horizontalScrollPosition == value)
		{
			return;
		}
		this._horizontalScrollPosition = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL);
	}

	private var _verticalScrollPosition:Float = 0;

	public function get_verticalScrollPosition():Float
	{
		return this._verticalScrollPosition;
	}

	public function set_verticalScrollPosition(value:Float):Void
	{
		if(this._verticalScrollPosition == value)
		{
			return;
		}
		this._verticalScrollPosition = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL);
	}

	override public function dispose():Void
	{
		this.layout = null;
		super.dispose();
	}

	override private function draw():Void
	{
		var layoutInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);
		var scrollInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SCROLL);

		super.draw();

		if(scrollInvalid || sizeInvalid || layoutInvalid)
		{
			if(this._layout)
			{
				this._contentX = this._layoutResult.contentX;
				this._contentY = this._layoutResult.contentY;
				this._actualVisibleWidth = this._layoutResult.viewPortWidth;
				this._actualVisibleHeight = this._layoutResult.viewPortHeight;
			}
		}
	}

	override private function refreshViewPortBounds():Void
	{
		this.viewPortBounds.x = 0;
		this.viewPortBounds.y = 0;
		this.viewPortBounds.scrollX = this._horizontalScrollPosition;
		this.viewPortBounds.scrollY = this._verticalScrollPosition;
		this.viewPortBounds.explicitWidth = this._explicitVisibleWidth;
		this.viewPortBounds.explicitHeight = this._explicitVisibleHeight;
		this.viewPortBounds.minWidth = this._minVisibleWidth;
		this.viewPortBounds.minHeight = this._minVisibleHeight;
		this.viewPortBounds.maxWidth = this._maxVisibleWidth;
		this.viewPortBounds.maxHeight = this._maxVisibleHeight;
	}

	override private function handleManualLayout():Void
	{
		var minX:Float = 0;
		var minY:Float = 0;
		var explicitViewPortWidth:Float = this.viewPortBounds.explicitWidth;
		var maxX:Float = explicitViewPortWidth;
		if(maxX != maxX) //isNaN
		{
			maxX = 0;
		}
		var explicitViewPortHeight:Float = this.viewPortBounds.explicitHeight;
		var maxY:Float = explicitViewPortHeight;
		if(maxY != maxY) //isNaN
		{
			maxY = 0;
		}
		this._ignoreChildChanges = true;
		var itemCount:Int = this.items.length;
		for(var i:Int = 0; i < itemCount; i++)
		{
			var item:DisplayObject = this.items[i];
			if(item is IValidating)
			{
				IValidating(item).validate();
			}
			var itemX:Float = item.x;
			var itemY:Float = item.y;
			var itemMaxX:Float = itemX + item.width;
			var itemMaxY:Float = itemY + item.height;
			if(itemX === itemX && //!isNaN
				itemX < minX)
			{
				minX = itemX;
			}
			if(itemY === itemY && //!isNaN
				itemY < minY)
			{
				minY = itemY;
			}
			if(itemMaxX === itemMaxX && //!isNaN
				itemMaxX > maxX)
			{
				maxX = itemMaxX;
			}
			if(itemMaxY === itemMaxY && //!isNaN
				itemMaxY > maxY)
			{
				maxY = itemMaxY;
			}
		}
		this._contentX = minX;
		this._contentY = minY;
		var minWidth:Float = this.viewPortBounds.minWidth;
		var maxWidth:Float = this.viewPortBounds.maxWidth;
		var minHeight:Float = this.viewPortBounds.minHeight;
		var maxHeight:Float = this.viewPortBounds.maxHeight;
		var calculatedWidth:Float = maxX - minX;
		if(calculatedWidth < minWidth)
		{
			calculatedWidth = minWidth;
		}
		else if(calculatedWidth > maxWidth)
		{
			calculatedWidth = maxWidth;
		}
		var calculatedHeight:Float = maxY - minY;
		if(calculatedHeight < minHeight)
		{
			calculatedHeight = minHeight;
		}
		else if(calculatedHeight > maxHeight)
		{
			calculatedHeight = maxHeight;
		}
		this._ignoreChildChanges = false;
		if(explicitViewPortWidth != explicitViewPortWidth) //isNaN
		{
			this._actualVisibleWidth = calculatedWidth;
		}
		else
		{
			this._actualVisibleWidth = explicitViewPortWidth;
		}
		if(explicitViewPortHeight != explicitViewPortHeight) //isNaN
		{
			this._actualVisibleHeight = calculatedHeight;
		}
		else
		{
			this._actualVisibleHeight = explicitViewPortHeight;
		}
		this._layoutResult.contentX = 0;
		this._layoutResult.contentY = 0;
		this._layoutResult.contentWidth = calculatedWidth;
		this._layoutResult.contentHeight = calculatedHeight;
		this._layoutResult.viewPortWidth = this._actualVisibleWidth;
		this._layoutResult.viewPortHeight = this._actualVisibleHeight;
	}
}
