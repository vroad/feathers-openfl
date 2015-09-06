/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import feathers.core.IFeathersControl;
import feathers.utils.type.SafeCast.safe_cast;

import openfl.errors.IllegalOperationError;
import openfl.geom.Point;

import starling.display.DisplayObject;
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
 * Positions and sizes items by anchoring their edges (or center points)
 * to their parent container or to other items.
 *
 * @see ../../../help/anchor-layout How to use AnchorLayout with Feathers containers
 * @see AnchorLayoutData
 */
class AnchorLayout extends EventDispatcher implements ILayout
{
	/**
	 * @private
	 */
	inline private static var CIRCULAR_REFERENCE_ERROR:String = "It is impossible to create this layout due to a circular reference in the AnchorLayoutData.";

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

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
	private var _helperVector1:Array<DisplayObject> = new Array();

	/**
	 * @private
	 */
	private var _helperVector2:Array<DisplayObject> = new Array();

	/**
	 * @inheritDoc
	 */
	public var requiresLayoutOnScroll(get, never):Bool;
	public function get_requiresLayoutOnScroll():Bool
	{
		return false;
	}

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

		var viewPortWidth:Float = explicitWidth;
		var viewPortHeight:Float = explicitHeight;

		var needsWidth:Bool = explicitWidth != explicitWidth; //isNaN
		var needsHeight:Bool = explicitHeight != explicitHeight; //isNaN
		if(needsWidth || needsHeight)
		{
			this.validateItems(items, true);
			this.measureViewPort(items, viewPortWidth, viewPortHeight, HELPER_POINT);
			if(needsWidth)
			{
				viewPortWidth = Math.min(maxWidth, Math.max(minWidth, HELPER_POINT.x));
			}
			if(needsHeight)
			{
				viewPortHeight = Math.min(maxHeight, Math.max(minHeight, HELPER_POINT.y));
			}
		}
		else
		{
			this.validateItems(items, false);
		}

		this.layoutWithBounds(items, boundsX, boundsY, viewPortWidth, viewPortHeight);

		this.measureContent(items, viewPortWidth, viewPortHeight, HELPER_POINT);

		if(result == null)
		{
			result = new LayoutBoundsResult();
		}
		result.contentWidth = HELPER_POINT.x;
		result.contentHeight = HELPER_POINT.y;
		result.viewPortWidth = viewPortWidth;
		result.viewPortHeight = viewPortHeight;
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function getNearestScrollPositionForIndex(index:Int, scrollX:Float, scrollY:Float, items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		return this.getScrollPositionForIndex(index, items, x, y, width, height, result);
	}

	/**
	 * @inheritDoc
	 */
	public function getScrollPositionForIndex(index:Int, items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}
		result.x = 0;
		result.y = 0;
		return result;
	}

	/**
	 * @private
	 */
	private function measureViewPort(items:Array<DisplayObject>, viewPortWidth:Float, viewPortHeight:Float, result:Point = null):Point
	{
		this._helperVector1.splice(0, this._helperVector1.length);
		this._helperVector2.splice(0, this._helperVector2.length);
		HELPER_POINT.x = 0;
		HELPER_POINT.y = 0;
		var mainVector:Array<DisplayObject> = items;
		var otherVector:Array<DisplayObject> = this._helperVector1;
		this.measureVector(items, otherVector, HELPER_POINT);
		var currentLength:Float = otherVector.length;
		while(currentLength > 0)
		{
			if(otherVector == this._helperVector1)
			{
				mainVector = this._helperVector1;
				otherVector = this._helperVector2;
			}
			else
			{
				mainVector = this._helperVector2;
				otherVector = this._helperVector1;
			}
			this.measureVector(mainVector, otherVector, HELPER_POINT);
			var oldLength:Float = currentLength;
			currentLength = otherVector.length;
			if(oldLength == currentLength)
			{
				this._helperVector1.splice(0, this._helperVector1.length);
				this._helperVector2.splice(0, this._helperVector2.length);
				throw new IllegalOperationError(CIRCULAR_REFERENCE_ERROR);
			}
		}
		this._helperVector1.splice(0, this._helperVector1.length);
		this._helperVector2.splice(0, this._helperVector2.length);

		if(result == null)
		{
			result = HELPER_POINT.clone();
		}
		return result;
	}

	/**
	 * @private
	 */
	private function measureVector(items:Array<DisplayObject>, unpositionedItems:Array<DisplayObject>, result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}

		unpositionedItems.splice(0, unpositionedItems.length);
		var itemCount:Int = items.length;
		var pushIndex:Int = 0;
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = items[i];
			var layoutData:AnchorLayoutData = null;
			if(Std.is(item, ILayoutDisplayObject))
			{
				var layoutItem:ILayoutDisplayObject = cast(item, ILayoutDisplayObject);
				if(!layoutItem.includeInLayout)
				{
					continue;
				}
				layoutData = cast(layoutItem.layoutData, AnchorLayoutData);
			}
			var isReadyForLayout:Bool = layoutData == null || this.isReadyForLayout(layoutData, i, items, unpositionedItems);
			if(!isReadyForLayout)
			{
				unpositionedItems[pushIndex] = item;
				pushIndex++;
				continue;
			}

			this.measureItem(item, result);
		}

		return result;
	}

	/**
	 * @private
	 */
	private function measureItem(item:DisplayObject, result:Point):Void
	{
		var maxX:Float = result.x;
		var maxY:Float = result.y;
		var isAnchored:Bool = false;
		var measurement:Float;
		if(Std.is(item, ILayoutDisplayObject))
		{
			var layoutItem:ILayoutDisplayObject = cast(item, ILayoutDisplayObject);
			var layoutData:AnchorLayoutData = cast(layoutItem.layoutData, AnchorLayoutData);
			if(layoutData != null)
			{
				measurement = this.measureItemHorizontally(layoutItem, layoutData);
				if(measurement > maxX)
				{
					maxX = measurement;
				}
				measurement = this.measureItemVertically(layoutItem, layoutData);
				if(measurement > maxY)
				{
					maxY = measurement;
				}
				isAnchored = true;
			}
		}
		if(!isAnchored)
		{
			measurement = item.x - item.pivotX + item.width;
			if(measurement > maxX)
			{
				maxX = measurement;
			}
			measurement = item.y - item.pivotY + item.height;
			if(measurement > maxY)
			{
				maxY = measurement;
			}
		}

		result.x = maxX;
		result.y = maxY;
	}

	/**
	 * @private
	 */
	private function measureItemHorizontally(item:ILayoutDisplayObject, layoutData:AnchorLayoutData):Float
	{
		var itemWidth:Float = item.width;
		if(layoutData != null && Std.is(item, IFeathersControl))
		{
			var percentWidth:Float = layoutData.percentWidth;
			//for some reason, if we don't call a function right here,
			//compiling with the flex 4.6 SDK will throw a VerifyError
			//for a stack overflow.
			//we could change the == check back to !isNaN() instead, but
			//isNaN() can allocate an object, so we should call a different
			//function without allocation.
			this.doNothing();
			if(percentWidth == percentWidth) //!isNaN
			{
				itemWidth = cast(item, IFeathersControl).minWidth;
			}
		}
		var displayItem:DisplayObject = cast(item, DisplayObject);
		var left:Float = this.getLeftOffset(displayItem);
		var right:Float = this.getRightOffset(displayItem);
		return itemWidth + left + right;
	}

	/**
	 * @private
	 */
	private function measureItemVertically(item:ILayoutDisplayObject, layoutData:AnchorLayoutData):Float
	{
		var itemHeight:Float = item.height;
		if(layoutData != null && Std.is(item, IFeathersControl))
		{
			var percentHeight:Float = layoutData.percentHeight;
			//for some reason, if we don't call a function right here,
			//compiling with the flex 4.6 SDK will throw a VerifyError
			//for a stack overflow.
			//we could change the == check back to !isNaN() instead, but
			//isNaN() can allocate an object, so we should call a different
			//function without allocation.
			this.doNothing();
			if(percentHeight == percentHeight) //!isNaN
			{
				itemHeight = cast(item, IFeathersControl).minHeight;
			}
		}
		var displayItem:DisplayObject = cast(item, DisplayObject);
		var top:Float = this.getTopOffset(displayItem);
		var bottom:Float = this.getBottomOffset(displayItem);
		return itemHeight + top + bottom;
	}

	/**
	 * @private
	 * This function is here to work around a bug in the Flex 4.6 SDK
	 * compiler. For explanation, see the places where it gets called.
	 */
	private function doNothing():Void {}

	/**
	 * @private
	 */
	private function getTopOffset(item:DisplayObject):Float
	{
		if(Std.is(item, ILayoutDisplayObject))
		{
			var layoutItem:ILayoutDisplayObject = cast(item, ILayoutDisplayObject);
			var layoutData:AnchorLayoutData = cast(layoutItem.layoutData, AnchorLayoutData);
			if(layoutData != null)
			{
				var top:Float = layoutData.top;
				var hasTopPosition:Bool = top == top; //!isNaN
				if(hasTopPosition)
				{
					var topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
					if(topAnchorDisplayObject != null)
					{
						top += topAnchorDisplayObject.height + this.getTopOffset(topAnchorDisplayObject);
					}
					else
					{
						return top;
					}
				}
				else
				{
					top = 0;
				}
				var bottom:Float = layoutData.bottom;
				var hasBottomPosition:Bool = bottom == bottom; //!isNaN
				if(hasBottomPosition)
				{
					var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
					if(bottomAnchorDisplayObject != null)
					{
						top = Math.max(top, -bottomAnchorDisplayObject.height - bottom + this.getTopOffset(bottomAnchorDisplayObject));
					}
				}
				var verticalCenter:Float = layoutData.verticalCenter;
				var hasVerticalCenterPosition:Bool = verticalCenter == verticalCenter; //!isNaN
				if(hasVerticalCenterPosition)
				{
					var verticalCenterAnchorDisplayObject:DisplayObject = layoutData.verticalCenterAnchorDisplayObject;
					if(verticalCenterAnchorDisplayObject != null)
					{
						var verticalOffset:Float = verticalCenter - Math.round((item.height - verticalCenterAnchorDisplayObject.height) / 2);
						top = Math.max(top, verticalOffset + this.getTopOffset(verticalCenterAnchorDisplayObject));
					}
					else if(verticalCenter > 0)
					{
						return verticalCenter * 2;
					}
				}
				return top;
			}
		}
		return 0;
	}

	/**
	 * @private
	 */
	private function getRightOffset(item:DisplayObject):Float
	{
		if(Std.is(item, ILayoutDisplayObject))
		{
			var layoutItem:ILayoutDisplayObject = cast(item, ILayoutDisplayObject);
			var layoutData:AnchorLayoutData = cast(layoutItem.layoutData, AnchorLayoutData);
			if(layoutData != null)
			{
				var right:Float = layoutData.right;
				var hasRightPosition:Bool = right == right; //!isNaN
				if(hasRightPosition)
				{
					var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
					if(rightAnchorDisplayObject != null)
					{
						right += rightAnchorDisplayObject.width + this.getRightOffset(rightAnchorDisplayObject);
					}
					else
					{
						return right;
					}
				}
				else
				{
					right = 0;
				}
				var left:Float = layoutData.left;
				var hasLeftPosition:Bool = left == left; //!isNaN
				if(hasLeftPosition)
				{
					var leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
					if(leftAnchorDisplayObject != null)
					{
						right = Math.max(right, -leftAnchorDisplayObject.width - left + this.getRightOffset(leftAnchorDisplayObject));
					}
				}
				var horizontalCenter:Float = layoutData.horizontalCenter;
				var hasHorizontalCenterPosition:Bool = horizontalCenter == horizontalCenter; //!isNaN
				if(hasHorizontalCenterPosition)
				{
					var horizontalCenterAnchorDisplayObject:DisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
					if(horizontalCenterAnchorDisplayObject != null)
					{
						var horizontalOffset:Float = -horizontalCenter - Math.round((item.width - horizontalCenterAnchorDisplayObject.width) / 2);
						right = Math.max(right, horizontalOffset + this.getRightOffset(horizontalCenterAnchorDisplayObject));
					}
					else if(horizontalCenter < 0)
					{
						return -horizontalCenter * 2;
					}
				}
				return right;
			}
		}
		return 0;
	}

	/**
	 * @private
	 */
	private function getBottomOffset(item:DisplayObject):Float
	{
		if(Std.is(item, ILayoutDisplayObject))
		{
			var layoutItem:ILayoutDisplayObject = cast(item, ILayoutDisplayObject);
			var layoutData:AnchorLayoutData = cast(layoutItem.layoutData, AnchorLayoutData);
			if(layoutData != null)
			{
				var bottom:Float = layoutData.bottom;
				var hasBottomPosition:Bool = bottom == bottom; //!isNaN
				if(hasBottomPosition)
				{
					var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
					if(bottomAnchorDisplayObject != null)
					{
						bottom += bottomAnchorDisplayObject.height + this.getBottomOffset(bottomAnchorDisplayObject);
					}
					else
					{
						return bottom;
					}
				}
				else
				{
					bottom = 0;
				}
				var top:Float = layoutData.top;
				var hasTopPosition:Bool = top == top; //!isNaN
				if(hasTopPosition)
				{
					var topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
					if(topAnchorDisplayObject != null)
					{
						bottom = Math.max(bottom, -topAnchorDisplayObject.height - top + this.getBottomOffset(topAnchorDisplayObject));
					}
				}
				var verticalCenter:Float = layoutData.verticalCenter;
				var hasVerticalCenterPosition:Bool = verticalCenter == verticalCenter; //!isNaN
				if(hasVerticalCenterPosition)
				{
					var verticalCenterAnchorDisplayObject:DisplayObject = layoutData.verticalCenterAnchorDisplayObject;
					if(verticalCenterAnchorDisplayObject != null)
					{
						var verticalOffset:Float = -verticalCenter - Math.round((item.height - verticalCenterAnchorDisplayObject.height) / 2);
						bottom = Math.max(bottom, verticalOffset + this.getBottomOffset(verticalCenterAnchorDisplayObject));
					}
					else if(verticalCenter < 0)
					{
						return -verticalCenter * 2;
					}
				}
				return bottom;
			}
		}
		return 0;
	}

	/**
	 * @private
	 */
	private function getLeftOffset(item:DisplayObject):Float
	{
		if(Std.is(item, ILayoutDisplayObject))
		{
			var layoutItem:ILayoutDisplayObject = cast(item, ILayoutDisplayObject);
			var layoutData:AnchorLayoutData = cast(layoutItem.layoutData, AnchorLayoutData);
			if(layoutData != null)
			{
				var left:Float = layoutData.left;
				var hasLeftPosition:Bool = left == left; //!isNaN
				if(hasLeftPosition)
				{
					var leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
					if(leftAnchorDisplayObject != null)
					{
						left += leftAnchorDisplayObject.width + this.getLeftOffset(leftAnchorDisplayObject);
					}
					else
					{
						return left;
					}
				}
				else
				{
					left = 0;
				}
				var right:Float = layoutData.right;
				var hasRightPosition:Bool = right == right; //!isNaN;
				if(hasRightPosition)
				{
					var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
					if(rightAnchorDisplayObject != null)
					{
						left = Math.max(left, -rightAnchorDisplayObject.width - right + this.getLeftOffset(rightAnchorDisplayObject));
					}
				}
				var horizontalCenter:Float = layoutData.horizontalCenter;
				var hasHorizontalCenterPosition:Bool = horizontalCenter == horizontalCenter; //!isNaN
				if(hasHorizontalCenterPosition)
				{
					var horizontalCenterAnchorDisplayObject:DisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
					if(horizontalCenterAnchorDisplayObject != null)
					{
						var horizontalOffset:Float = horizontalCenter - Math.round((item.width - horizontalCenterAnchorDisplayObject.width) / 2);
						left = Math.max(left, horizontalOffset + this.getLeftOffset(horizontalCenterAnchorDisplayObject));
					}
					else if(horizontalCenter > 0)
					{
						return horizontalCenter * 2;
					}
				}
				return left;
			}
		}
		return 0;
	}

	/**
	 * @private
	 */
	private function layoutWithBounds(items:Array<DisplayObject>, x:Float, y:Float, width:Float, height:Float):Void
	{
		this._helperVector1.splice(0, this._helperVector1.length);
		this._helperVector2.splice(0, this._helperVector2.length);
		var mainVector:Array<DisplayObject> = items;
		var otherVector:Array<DisplayObject> = this._helperVector1;
		this.layoutVector(items, otherVector, x, y, width, height);
		var currentLength:Float = otherVector.length;
		while(currentLength > 0)
		{
			if(otherVector == this._helperVector1)
			{
				mainVector = this._helperVector1;
				otherVector = this._helperVector2;
			}
			else
			{
				mainVector = this._helperVector2;
				otherVector = this._helperVector1;
			}
			this.layoutVector(mainVector, otherVector, x, y, width, height);
			var oldLength:Float = currentLength;
			currentLength = otherVector.length;
			if(oldLength == currentLength)
			{
				this._helperVector1.splice(0, this._helperVector1.length);
				this._helperVector2.splice(0, this._helperVector2.length);
				throw new IllegalOperationError(CIRCULAR_REFERENCE_ERROR);
			}
		}
		this._helperVector1.splice(0, this._helperVector1.length);
		this._helperVector2.splice(0, this._helperVector2.length);
	}

	/**
	 * @private
	 */
	private function layoutVector(items:Array<DisplayObject>, unpositionedItems:Array<DisplayObject>, boundsX:Float, boundsY:Float, viewPortWidth:Float, viewPortHeight:Float):Void
	{
		unpositionedItems.splice(0, unpositionedItems.length);
		var itemCount:Int = items.length;
		var pushIndex:Int = 0;
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = items[i];
			var layoutItem:ILayoutDisplayObject = safe_cast(item, ILayoutDisplayObject);
			if(layoutItem == null || !layoutItem.includeInLayout)
			{
				continue;
			}
			var layoutData:AnchorLayoutData = safe_cast(layoutItem.layoutData, AnchorLayoutData);
			if(layoutData == null)
			{
				continue;
			}

			var isReadyForLayout:Bool = this.isReadyForLayout(layoutData, i, items, unpositionedItems);
			if(!isReadyForLayout)
			{
				unpositionedItems[pushIndex] = item;
				pushIndex++;
				continue;
			}
			this.positionHorizontally(layoutItem, layoutData, boundsX, boundsY, viewPortWidth, viewPortHeight);
			this.positionVertically(layoutItem, layoutData, boundsX, boundsY, viewPortWidth, viewPortHeight);
		}
	}

	/**
	 * @private
	 */
	private function positionHorizontally(item:ILayoutDisplayObject, layoutData:AnchorLayoutData, boundsX:Float, boundsY:Float, viewPortWidth:Float, viewPortHeight:Float):Void
	{
		var uiItem:IFeathersControl = cast(item, IFeathersControl);
		var percentWidth:Float = layoutData.percentWidth;
		var checkWidth:Bool = false;
		var itemWidth:Float;
		var minWidth:Float = 0;
		if(percentWidth == percentWidth) //!isNaN
		{
			if(percentWidth > 100)
			{
				percentWidth = 100;
			}
			itemWidth = percentWidth * 0.01 * viewPortWidth;
			if(uiItem != null)
			{
				minWidth = uiItem.minWidth;
				var maxWidth:Float = uiItem.maxWidth;
				if(itemWidth < minWidth)
				{
					itemWidth = minWidth;
				}
				else if(itemWidth > maxWidth)
				{
					itemWidth = maxWidth;
				}
			}
			item.width = itemWidth;
			checkWidth = true;
		}
		var left:Float = layoutData.left;
		var hasLeftPosition:Bool = left == left; //!isNaN
		var leftAnchorDisplayObject:DisplayObject = null;
		if(hasLeftPosition)
		{
			leftAnchorDisplayObject = layoutData.leftAnchorDisplayObject;
			if(leftAnchorDisplayObject != null)
			{
				item.x = item.pivotX + leftAnchorDisplayObject.x - leftAnchorDisplayObject.pivotX + leftAnchorDisplayObject.width + left;
			}
			else
			{
				item.x = item.pivotX + boundsX + left;
			}
		}
		var horizontalCenter:Float = layoutData.horizontalCenter;
		var hasHorizontalCenterPosition:Bool = horizontalCenter == horizontalCenter; //!isNaN
		var right:Float = layoutData.right;
		var hasRightPosition:Bool = right == right; //!isNaN
		var horizontalCenterAnchorDisplayObject:DisplayObject;
		var xPositionOfCenter:Float;
		if(hasRightPosition)
		{
			var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
			if(hasLeftPosition)
			{
				var leftRightWidth:Float = viewPortWidth;
				if(rightAnchorDisplayObject != null)
				{
					leftRightWidth = rightAnchorDisplayObject.x - rightAnchorDisplayObject.pivotX;
				}
				if(leftAnchorDisplayObject != null)
				{
					leftRightWidth -= (leftAnchorDisplayObject.x - leftAnchorDisplayObject.pivotX + leftAnchorDisplayObject.width);
				}
				checkWidth = false;
				item.width = leftRightWidth - right - left;
			}
			else if(hasHorizontalCenterPosition)
			{
				horizontalCenterAnchorDisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
				if(horizontalCenterAnchorDisplayObject != null)
				{
					xPositionOfCenter = horizontalCenterAnchorDisplayObject.x - horizontalCenterAnchorDisplayObject.pivotX + Math.round(horizontalCenterAnchorDisplayObject.width / 2) + horizontalCenter;
				}
				else
				{
					xPositionOfCenter = Math.round(viewPortWidth / 2) + horizontalCenter;
				}
				var xPositionOfRight:Float;
				if(rightAnchorDisplayObject != null)
				{
					xPositionOfRight = rightAnchorDisplayObject.x - rightAnchorDisplayObject.pivotX - right;
				}
				else
				{
					xPositionOfRight = viewPortWidth - right;
				}
				checkWidth = false;
				item.width = 2 * (xPositionOfRight - xPositionOfCenter);
				item.x = item.pivotX + viewPortWidth - right - item.width;
			}
			else
			{
				if(rightAnchorDisplayObject != null)
				{
					item.x = item.pivotX + rightAnchorDisplayObject.x - rightAnchorDisplayObject.pivotX - item.width - right;
				}
				else
				{
					item.x = item.pivotX + boundsX + viewPortWidth - right - item.width;
				}
			}
		}
		else if(hasHorizontalCenterPosition)
		{
			horizontalCenterAnchorDisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
			if(horizontalCenterAnchorDisplayObject != null)
			{
				xPositionOfCenter = horizontalCenterAnchorDisplayObject.x - horizontalCenterAnchorDisplayObject.pivotX + Math.round(horizontalCenterAnchorDisplayObject.width / 2) + horizontalCenter;
			}
			else
			{
				xPositionOfCenter = Math.round(viewPortWidth / 2) + horizontalCenter;
			}

			if(hasLeftPosition)
			{
				checkWidth = false;
				item.width = 2 * (xPositionOfCenter - item.x + item.pivotX);
			}
			else
			{
				item.x = item.pivotX + xPositionOfCenter - Math.round(item.width / 2);
			}
		}
		if(checkWidth)
		{
			var itemX:Float = item.x;
			itemWidth = item.width;
			if(itemX + itemWidth > viewPortWidth)
			{
				itemWidth = viewPortWidth - itemX;
				if(uiItem != null)
				{
					if(itemWidth < minWidth)
					{
						itemWidth = minWidth;
					}
				}
				item.width = itemWidth;
			}
		}
	}

	/**
	 * @private
	 */
	private function positionVertically(item:ILayoutDisplayObject, layoutData:AnchorLayoutData, boundsX:Float, boundsY:Float, viewPortWidth:Float, viewPortHeight:Float):Void
	{
		var uiItem:IFeathersControl = cast(item, IFeathersControl);
		var percentHeight:Float = layoutData.percentHeight;
		var checkHeight:Bool = false;
		var itemHeight:Float;
		var minHeight:Float = 0;
		if(percentHeight == percentHeight) //!isNaN
		{
			if(percentHeight > 100)
			{
				percentHeight = 100;
			}
			itemHeight = percentHeight * 0.01 * viewPortHeight;
			if(uiItem != null)
			{
				minHeight = uiItem.minHeight;
				var maxHeight:Float = uiItem.maxHeight;
				if(itemHeight < minHeight)
				{
					itemHeight = minHeight;
				}
				else if(itemHeight > maxHeight)
				{
					itemHeight = maxHeight;
				}
			}
			item.height = itemHeight;
			checkHeight = true;
		}
		var top:Float = layoutData.top;
		var hasTopPosition:Bool = top == top; //!isNaN
		var topAnchorDisplayObject:DisplayObject = null;
		if(hasTopPosition)
		{
			topAnchorDisplayObject = layoutData.topAnchorDisplayObject;
			if(topAnchorDisplayObject != null)
			{
				item.y = item.pivotY + topAnchorDisplayObject.y - topAnchorDisplayObject.pivotY + topAnchorDisplayObject.height + top;
			}
			else
			{
				item.y = item.pivotY + boundsY + top;
			}
		}
		var verticalCenter:Float = layoutData.verticalCenter;
		var hasVerticalCenterPosition:Bool = verticalCenter == verticalCenter; //!isNaN
		var bottom:Float = layoutData.bottom;
		var hasBottomPosition:Bool = bottom == bottom; //!isNaN
		var verticalCenterAnchorDisplayObject:DisplayObject;
		var yPositionOfCenter:Float;
		if(hasBottomPosition)
		{
			var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
			if(hasTopPosition)
			{
				var topBottomHeight:Float = viewPortHeight;
				if(bottomAnchorDisplayObject != null)
				{
					topBottomHeight = bottomAnchorDisplayObject.y - bottomAnchorDisplayObject.pivotY;
				}
				if(topAnchorDisplayObject != null)
				{
					topBottomHeight -= (topAnchorDisplayObject.y - topAnchorDisplayObject.pivotY + topAnchorDisplayObject.height);
				}
				checkHeight = false;
				item.height = topBottomHeight - bottom - top;
			}
			else if(hasVerticalCenterPosition)
			{
				verticalCenterAnchorDisplayObject = layoutData.verticalCenterAnchorDisplayObject;
				if(verticalCenterAnchorDisplayObject != null)
				{
					yPositionOfCenter = verticalCenterAnchorDisplayObject.y - verticalCenterAnchorDisplayObject.pivotY + Math.round(verticalCenterAnchorDisplayObject.height / 2) + verticalCenter;
				}
				else
				{
					yPositionOfCenter = Math.round(viewPortHeight / 2) + verticalCenter;
				}
				var yPositionOfBottom:Float;
				if(bottomAnchorDisplayObject != null)
				{
					yPositionOfBottom = bottomAnchorDisplayObject.y - bottomAnchorDisplayObject.pivotY - bottom;
				}
				else
				{
					yPositionOfBottom = viewPortHeight - bottom;
				}
				checkHeight = false;
				item.height = 2 * (yPositionOfBottom - yPositionOfCenter);
				item.y = item.pivotY + viewPortHeight - bottom - item.height;
			}
			else
			{
				if(bottomAnchorDisplayObject != null)
				{
					item.y = item.pivotY + bottomAnchorDisplayObject.y - bottomAnchorDisplayObject.pivotY - item.height - bottom;
				}
				else
				{
					item.y = item.pivotY + boundsY + viewPortHeight - bottom - item.height;
				}
			}
		}
		else if(hasVerticalCenterPosition)
		{
			verticalCenterAnchorDisplayObject = layoutData.verticalCenterAnchorDisplayObject;
			if(verticalCenterAnchorDisplayObject != null)
			{
				yPositionOfCenter = verticalCenterAnchorDisplayObject.y - verticalCenterAnchorDisplayObject.pivotY + Math.round(verticalCenterAnchorDisplayObject.height / 2) + verticalCenter;
			}
			else
			{
				yPositionOfCenter = Math.round(viewPortHeight / 2) + verticalCenter;
			}

			if(hasTopPosition)
			{
				checkHeight = false;
				item.height = 2 * (yPositionOfCenter - item.y + item.pivotY);
			}
			else
			{
				item.y = item.pivotY + yPositionOfCenter - Math.round(item.height / 2);
			}
		}
		if(checkHeight)
		{
			var itemY:Float = item.y;
			itemHeight = item.height;
			if(itemY + itemHeight > viewPortHeight)
			{
				itemHeight = viewPortHeight - itemY;
				if(uiItem != null)
				{
					if(itemHeight < minHeight)
					{
						itemHeight = minHeight;
					}
				}
				item.height = itemHeight;
			}
		}
	}

	/**
	 * @private
	 */
	private function measureContent(items:Array<DisplayObject>, viewPortWidth:Float, viewPortHeight:Float, result:Point = null):Point
	{
		var maxX:Float = viewPortWidth;
		var maxY:Float = viewPortHeight;
		var itemCount:Int = items.length;
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = items[i];
			var itemMaxX:Float = item.x - item.pivotX + item.width;
			var itemMaxY:Float = item.y - item.pivotY + item.height;
			if(itemMaxX == itemMaxX && //!isNaN
				itemMaxX > maxX)
			{
				maxX = itemMaxX;
			}
			if(itemMaxY == itemMaxY && //!isNaN
				itemMaxY > maxY)
			{
				maxY = itemMaxY;
			}
		}
		result.x = maxX;
		result.y = maxY;
		return result;
	}

	/**
	 * @private
	 */
	private function isReadyForLayout(layoutData:AnchorLayoutData, index:Int, items:Array<DisplayObject>, unpositionedItems:Array<DisplayObject>):Bool
	{
		var nextIndex:Int = index + 1;
		var leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
		if(leftAnchorDisplayObject != null && (items.indexOf(leftAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(leftAnchorDisplayObject) >= 0))
		{
			return false;
		}
		var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
		if(rightAnchorDisplayObject != null && (items.indexOf(rightAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(rightAnchorDisplayObject) >= 0))
		{
			return false;
		}
		var topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
		if(topAnchorDisplayObject != null && (items.indexOf(topAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(topAnchorDisplayObject) >= 0))
		{
			return false;
		}
		var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
		if(bottomAnchorDisplayObject != null && (items.indexOf(bottomAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(bottomAnchorDisplayObject) >= 0))
		{
			return false;
		}
		var horizontalCenterAnchorDisplayObject:DisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
		if(horizontalCenterAnchorDisplayObject != null && (items.indexOf(horizontalCenterAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(horizontalCenterAnchorDisplayObject) >= 0))
		{
			return false;
		}
		var verticalCenterAnchorDisplayObject:DisplayObject = layoutData.verticalCenterAnchorDisplayObject;
		if(verticalCenterAnchorDisplayObject != null && (items.indexOf(verticalCenterAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(verticalCenterAnchorDisplayObject) >= 0))
		{
			return false;
		}
		return true;
	}

	/**
	 * @private
	 */
	private function isReferenced(item:DisplayObject, items:Array<DisplayObject>):Bool
	{
		var itemCount:Int = items.length;
		for(i in 0 ... itemCount)
		{
			var otherItem:ILayoutDisplayObject = safe_cast(items[i], ILayoutDisplayObject);
			if(otherItem == null || cast(otherItem, DisplayObject) == item)
			{
				continue;
			}
			var layoutData:AnchorLayoutData = cast(otherItem.layoutData, AnchorLayoutData);
			if(layoutData == null)
			{
				continue;
			}
			if(layoutData.leftAnchorDisplayObject == item || layoutData.horizontalCenterAnchorDisplayObject == item ||
				layoutData.rightAnchorDisplayObject == item || layoutData.topAnchorDisplayObject == item ||
				layoutData.verticalCenterAnchorDisplayObject == item || layoutData.bottomAnchorDisplayObject == item)
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * @private
	 */
	private function validateItems(items:Array<DisplayObject>, force:Bool):Void
	{
		var itemCount:Int = items.length;
		for(i in 0 ... itemCount)
		{
			var control:IFeathersControl = safe_cast(items[i], IFeathersControl);
			if(control != null)
			{
				if(force)
				{
					control.validate();
					continue;
				}
				if(Std.is(control, ILayoutDisplayObject))
				{
					var layoutControl:ILayoutDisplayObject = cast control;
					if(!layoutControl.includeInLayout)
					{
						continue;
					}
					var layoutData:AnchorLayoutData = safe_cast(layoutControl.layoutData, AnchorLayoutData);
					if(layoutData != null)
					{
						var left:Float = layoutData.left;
						var hasLeftPosition:Bool = left == left; //!isNaN
						var right:Float = layoutData.right;
						var hasRightPosition:Bool = right == right; //!isNaN
						var horizontalCenter:Float = layoutData.horizontalCenter;
						var hasHorizontalCenterPosition:Bool = horizontalCenter == horizontalCenter; //!isNaN
						if((hasRightPosition && !hasLeftPosition && !hasHorizontalCenterPosition) ||
							hasHorizontalCenterPosition)
						{
							control.validate();
							continue;
						}
						var top:Float = layoutData.top;
						var hasTopPosition:Bool = top == top; //!isNaN
						var bottom:Float = layoutData.bottom;
						var hasBottomPosition:Bool = bottom == bottom; //!isNaN
						var verticalCenter:Float = layoutData.verticalCenter;
						var hasVerticalCenterPosition:Bool = verticalCenter == verticalCenter; //!isNaN
						if((hasBottomPosition && !hasTopPosition && !hasVerticalCenterPosition) ||
							hasVerticalCenterPosition)
						{
							control.validate();
							continue;
						}
					}
				}
				if(this.isReferenced(cast(control, DisplayObject), items))
				{
					control.validate();
				}
			}
		}
	}
}
