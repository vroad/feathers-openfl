/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.IValidating;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.ISpinnerLayout;
import feathers.layout.VerticalSpinnerLayout;
import feathers.skins.IStyleProvider;
import openfl.errors.ArgumentError;
import starling.utils.Max;

import flash.ui.Keyboard;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.KeyboardEvent;

import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;
import feathers.controls.List.SCROLL_POLICY_AUTO;
import feathers.controls.List.SCROLL_POLICY_ON;
import feathers.controls.List.SCROLL_BAR_DISPLAY_MODE_FIXED;
import feathers.controls.List.SCROLL_BAR_DISPLAY_MODE_NONE;

/**
 * A customized <code>List</code> component where scrolling updates the
 * the selected item. Layouts may loop infinitely.
 *
 * <p>The following example creates a list, gives it a data provider, tells
 * the item renderer how to interpret the data, and listens for when the
 * selection changes:</p>
 *
 * <listing version="3.0">
 * var list:SpinnerList = new SpinnerList();
 * 
 * list.dataProvider = new ListCollection(
 * [
 *     { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
 *     { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
 *     { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
 *     { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
 * ]);
 * 
 * list.itemRendererFactory = function():IListItemRenderer
 * {
 *     var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
 *     renderer.labelField = "text";
 *     renderer.iconSourceField = "thumbnail";
 *     return renderer;
 * };
 * 
 * list.addEventListener( Event.CHANGE, list_changeHandler );
 * 
 * this.addChild( list );</listing>
 *
 * @see ../../../help/spinner-list.html How to use the Feathers SpinnerList component
 */
class SpinnerList extends List
{
	/**
	 * The default <code>IStyleProvider</code> for all <code>SpinnerList</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this._scrollBarDisplayMode = SCROLL_BAR_DISPLAY_MODE_NONE;
		this._snapToPages = true;
		this._snapOnComplete = true;
		this.decelerationRate = Scroller.DECELERATION_RATE_FAST;
		this.addEventListener(Event.TRIGGERED, spinnerList_triggeredHandler);
		this.addEventListener(FeathersEventType.SCROLL_COMPLETE, spinnerList_scrollCompleteHandler);
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		if(SpinnerList.globalStyleProvider != null)
		{
			return SpinnerList.globalStyleProvider;
		}
		return List.globalStyleProvider;
	}

	/**
	 * <code>SpinnerList</code> requires that the <code>snapToPages</code>
	 * property is set to <code>true</code>. Attempts to set it to
	 * <code>false</code> will result in a runtime error.
	 *
	 * @throws ArgumentError SpinnerList requires snapToPages to be true.
	 */
	override public function set_snapToPages(value:Bool):Bool
	{
		if(!value)
		{
			throw new ArgumentError("SpinnerList requires snapToPages to be true.");
		}
		super.snapToPages = value;
		return get_snapToPages();
	}

	/**
	 * <code>SpinnerList</code> requires that the <code>allowMultipleSelection</code>
	 * property is set to <code>false</code>. Attempts to set it to
	 * <code>true</code> will result in a runtime error.
	 *
	 * @throws ArgumentError SpinnerList requires allowMultipleSelection to be false.
	 */
	override public function set_allowMultipleSelection(value:Bool):Bool
	{
		if(value)
		{
			throw new ArgumentError("SpinnerList requires allowMultipleSelection to be false.");
		}
		super.allowMultipleSelection = value;
		return get_allowMultipleSelection();
	}

	/**
	 * <code>SpinnerList</code> requires that the <code>isSelectable</code>
	 * property is set to <code>true</code>. Attempts to set it to
	 * <code>false</code> will result in a runtime error.
	 *
	 * @throws ArgumentError SpinnerList requires isSelectable to be true.
	 */
	override public function set_isSelectable(value:Bool):Bool
	{
		if(!value)
		{
			throw new ArgumentError("SpinnerList requires isSelectable to be true.");
		}
		super.snapToPages = value;
		return get_isSelectable();
	}

	/**
	 * @private
	 */
	override public function set_layout(value:ILayout):ILayout
	{
		if(value != null && !Std.is(value, ISpinnerLayout))
		{
			throw new ArgumentError("SpinnerList requires layouts to implement the ISpinnerLayout interface.");
		}
		super.layout = value;
		return get_layout();
	}

	/**
	 * @private
	 */
	override public function set_selectedIndex(value:Int):Int
	{
		if(this._selectedIndex != value)
		{
			this.scrollToDisplayIndex(value, 0);
		}
		super.selectedIndex = value;
		return get_selectedIndex();
	}

	/**
	 * @private
	 */
	override public function set_dataProvider(value:ListCollection):ListCollection
	{
		super.dataProvider = value;
		if(this._dataProvider == null || this._dataProvider.length == 0)
		{
			this.selectedIndex = -1;
		}
		else
		{
			this.selectedIndex = 0;
		}
		return get_dataProvider();
	}

	/**
	 * @private
	 */
	private var _selectionOverlaySkin:DisplayObject;

	/**
	 * An optional skin to display in the horizontal or vertical center of
	 * the list to highlight the currently selected item. If the list
	 * scrolls vertically, the <code>selectionOverlaySkin</code> will fill
	 * the entire width of the list, and it will be positioned in the
	 * vertical center. If the list scrolls horizontally, the
	 * <code>selectionOverlaySkin</code> will fill the entire height of the
	 * list, and it will be positioned in the horizontal center.
	 *
	 * <p>The following example gives the spinner list a selection overlay
	 * skin:</p>
	 *
	 * <listing version="3.0">
	 * list.selectionOverlaySkin = new Scale9Image( textures );</listing>
	 *
	 * @default null
	 */
	public var selectionOverlaySkin(get, set):DisplayObject;
	public function get_selectionOverlaySkin():DisplayObject
	{
		return this._selectionOverlaySkin;
	}

	/**
	 * @private
	 */
	public function set_selectionOverlaySkin(value:DisplayObject):DisplayObject
	{
		if(this._selectionOverlaySkin == value)
		{
			return get_selectionOverlaySkin();
		}
		if(this._selectionOverlaySkin != null && this._selectionOverlaySkin.parent == this)
		{
			this.removeRawChildInternal(this._selectionOverlaySkin);
		}
		this._selectionOverlaySkin = value;
		if(this._selectionOverlaySkin != null)
		{
			this.addRawChildInternal(this._selectionOverlaySkin);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_selectionOverlaySkin();
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(this._layout == null)
		{
			if(this._hasElasticEdges &&
				this._verticalScrollPolicy == SCROLL_POLICY_AUTO &&
				this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				//so that the elastic edges work even when the max scroll
				//position is 0, similar to iOS.
				this.verticalScrollPolicy = SCROLL_POLICY_ON;
			}

			var layout:VerticalSpinnerLayout = new VerticalSpinnerLayout();
			layout.useVirtualLayout = true;
			layout.padding = 0;
			layout.gap = 0;
			layout.horizontalAlign = VerticalSpinnerLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.requestedRowCount = 5;
			this.layout = layout;
		}

		super.initialize();
	}

	/**
	 * @private
	 */
	override private function refreshMinAndMaxScrollPositions():Void
	{
		super.refreshMinAndMaxScrollPositions();
		if(this._maxVerticalScrollPosition != this._minVerticalScrollPosition)
		{
			this.actualPageHeight = cast(this._layout, ISpinnerLayout).snapInterval;
		}
		else if(this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition)
		{
			this.actualPageWidth = cast(this._layout, ISpinnerLayout).snapInterval;
		}
	}

	/**
	 * @private
	 */
	override private function handlePendingScroll():Void
	{
		if(this.pendingItemIndex >= 0)
		{
			var itemIndex:Int = this.pendingItemIndex;
			this.pendingItemIndex = -1;
			if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
			{
				this.pendingVerticalPageIndex = this.calculateNearestPageIndexForItem(itemIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
				this.hasPendingVerticalPageIndex = this.pendingVerticalPageIndex != this._verticalPageIndex;
			}
			else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
			{
				this.pendingHorizontalPageIndex = this.calculateNearestPageIndexForItem(itemIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
				this.hasPendingHorizontalPageIndex = this.pendingHorizontalPageIndex != this._horizontalPageIndex;
			}
		}
		super.handlePendingScroll();
	}

	/**
	 * @private
	 */
	override private function layoutChildren():Void
	{
		super.layoutChildren();

		if(this._selectionOverlaySkin != null)
		{
			if(Std.is(this._selectionOverlaySkin, IValidating))
			{
				cast(this._selectionOverlaySkin, IValidating).validate();
			}
			if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
			{
				this._selectionOverlaySkin.width = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
				this._selectionOverlaySkin.height = this.actualPageHeight;
				this._selectionOverlaySkin.x = this._leftViewPortOffset;
				this._selectionOverlaySkin.y = Math.round(this._topViewPortOffset + (this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset - this.actualPageHeight) / 2);
			}
			else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
			{
				this._selectionOverlaySkin.width = this.actualPageWidth;
				this._selectionOverlaySkin.height = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
				this._selectionOverlaySkin.x = Math.round(this._leftViewPortOffset + (this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset - this.actualPageWidth) / 2);
				this._selectionOverlaySkin.y = this._topViewPortOffset;
			}
		}
	}

	/**
	 * @private
	 */
	private function calculateNearestPageIndexForItem(itemIndex:Int, currentPageIndex:Int, maxPageIndex:Int):Int
	{
		if(maxPageIndex != Max.INT_MAX_VALUE)
		{
			return itemIndex;
		}
		var itemCount:Int = this._dataProvider.length;
		var fullDataProviderOffsets:Int = Std.int(currentPageIndex / itemCount);
		var currentItemIndex:Int = currentPageIndex % itemCount;
		var previousPageIndex:Float;
		var nextPageIndex:Float;
		if(itemIndex < currentItemIndex)
		{
			previousPageIndex = fullDataProviderOffsets * itemCount + itemIndex;
			nextPageIndex = (fullDataProviderOffsets + 1) * itemCount + itemIndex;
		}
		else
		{
			previousPageIndex = (fullDataProviderOffsets - 1) * itemCount + itemIndex;
			nextPageIndex = fullDataProviderOffsets * itemCount + itemIndex;
		}
		if((nextPageIndex - currentPageIndex) < (currentPageIndex - previousPageIndex))
		{
			return Std.int(nextPageIndex);
		}
		return Std.int(previousPageIndex);
	}

	/**
	 * @private
	 */
	private function spinnerList_scrollCompleteHandler(event:Event):Void
	{
		var itemCount:Int = this._dataProvider.length;
		var pageIndex:Int = 0;
		if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
		{
			pageIndex = this._verticalPageIndex % itemCount;
		}
		else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
		{
			pageIndex = this._horizontalPageIndex % itemCount;
		}
		if(pageIndex < 0)
		{
			pageIndex = itemCount + pageIndex;
		}
		this.selectedIndex = pageIndex;
	}

	/**
	 * @private
	 */
	private function spinnerList_triggeredHandler(event:Event, item:Dynamic):Void
	{
		var itemIndex:Int = this._dataProvider.getItemIndex(item);
		if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
		{
			itemIndex = this.calculateNearestPageIndexForItem(itemIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
			this.throwToPage(this._horizontalPageIndex, itemIndex, this._pageThrowDuration);
		}
		else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
		{
			itemIndex = this.calculateNearestPageIndexForItem(itemIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
			this.throwToPage(itemIndex, this._verticalPageIndex);
		}
	}

	/**
	 * @private
	 */
	override private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(this._dataProvider == null)
		{
			return;
		}
		var changedSelection:Bool = false;
		var newIndex:Int;
		if(event.keyCode == Keyboard.HOME)
		{
			if(this._dataProvider.length > 0)
			{
				this.selectedIndex = 0;
				changedSelection = true;
			}
		}
		else if(event.keyCode == Keyboard.END)
		{
			this.selectedIndex = this._dataProvider.length - 1;
			changedSelection = true;
		}
		else if(event.keyCode == Keyboard.UP)
		{
			newIndex = this._selectedIndex - 1;
			if(newIndex < 0)
			{
				newIndex = this._dataProvider.length + newIndex;
			}
			this.selectedIndex = newIndex;
			changedSelection = true;
		}
		else if(event.keyCode == Keyboard.DOWN)
		{
			newIndex = this._selectedIndex + 1;
			if(newIndex >= this._dataProvider.length)
			{
				newIndex -= this._dataProvider.length;
			}
			this.selectedIndex = newIndex;
			changedSelection = true;
		}
		if(changedSelection)
		{
			var pageIndex:Int;
			if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
			{
				pageIndex = this.calculateNearestPageIndexForItem(this._selectedIndex, this._verticalPageIndex, this._maxVerticalPageIndex);
				this.throwToPage(this._horizontalPageIndex, pageIndex, this._pageThrowDuration);
			}
			else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
			{
				pageIndex = this.calculateNearestPageIndexForItem(this._selectedIndex, this._horizontalPageIndex, this._maxHorizontalPageIndex);
				this.throwToPage(pageIndex, this._verticalPageIndex);
			}
		}
	}
}
