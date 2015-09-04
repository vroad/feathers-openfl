/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.controls.List;
import feathers.controls.Scroller;
import feathers.controls.renderers.IListItemRenderer;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.PropertyProxy;
import feathers.data.ListCollection;
import feathers.events.CollectionEventType;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.ITrimmedVirtualLayout;
import feathers.layout.IVariableVirtualLayout;
import feathers.layout.IVirtualLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.ViewPortBounds;
import feathers.utils.type.UnionMap;
import feathers.utils.type.UnionWeakMap;
import feathers.utils.type.SafeCast.safe_cast;
import haxe.ds.WeakMap;
import openfl.utils.Object;
import starling.core.RenderSupport;

import openfl.errors.ArgumentError;
import openfl.errors.IllegalOperationError;
import openfl.geom.Point;
import openfl.utils.Dictionary;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * @private
 * Used internally by List. Not meant to be used on its own.
 */
class ListDataViewPort extends FeathersControl implements IViewPort
{
	inline private static var INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";

	private static var HELPER_POINT:Point = new Point();
	private static var HELPER_VECTOR:Array<Int> = new Array();

	public function new()
	{
		super();
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		this.addEventListener(TouchEvent.TOUCH, touchHandler);
	}

	private var touchPointID:Int = -1;

	private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

	private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

	private var _minVisibleWidth:Float = 0;

	public var minVisibleWidth(get, set):Float;
	public function get_minVisibleWidth():Float
	{
		return this._minVisibleWidth;
	}

	public function set_minVisibleWidth(value:Float):Float
	{
		if(this._minVisibleWidth == value)
		{
			return this._minVisibleWidth;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleWidth cannot be NaN");
		}
		this._minVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._minVisibleWidth;
	}

	private var _maxVisibleWidth:Float = Math.POSITIVE_INFINITY;

	public var maxVisibleWidth(get, set):Float;
	public function get_maxVisibleWidth():Float
	{
		return this._maxVisibleWidth;
	}

	public function set_maxVisibleWidth(value:Float):Float
	{
		if(this._maxVisibleWidth == value)
		{
			return this._maxVisibleWidth;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleWidth cannot be NaN");
		}
		this._maxVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._maxVisibleWidth;
	}

	private var actualVisibleWidth:Float = 0;

	private var explicitVisibleWidth:Float = Math.NaN;

	public var visibleWidth(get, set):Float;
	public function get_visibleWidth():Float
	{
		return this.actualVisibleWidth;
	}

	public function set_visibleWidth(value:Float):Float
	{
		if(this.explicitVisibleWidth == value ||
			(value != value && this.explicitVisibleWidth != this.explicitVisibleWidth)) //isNaN
		{
			return this.actualVisibleWidth;
		}
		this.explicitVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this.actualVisibleWidth;
	}

	private var _minVisibleHeight:Float = 0;

	public var minVisibleHeight(get, set):Float;
	public function get_minVisibleHeight():Float
	{
		return this._minVisibleHeight;
	}

	public function set_minVisibleHeight(value:Float):Float
	{
		if(this._minVisibleHeight == value)
		{
			return this._minVisibleHeight;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleHeight cannot be NaN");
		}
		this._minVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._minVisibleHeight;
	}

	private var _maxVisibleHeight:Float = Math.POSITIVE_INFINITY;

	public var maxVisibleHeight(get, set):Float;
	public function get_maxVisibleHeight():Float
	{
		return this._maxVisibleHeight;
	}

	public function set_maxVisibleHeight(value:Float):Float
	{
		if(this._maxVisibleHeight == value)
		{
			return this._maxVisibleHeight;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleHeight cannot be NaN");
		}
		this._maxVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._maxVisibleHeight;
	}

	private var actualVisibleHeight:Float = 0;

	private var explicitVisibleHeight:Float = Math.NaN;

	public var visibleHeight(get, set):Float;
	public function get_visibleHeight():Float
	{
		return this.actualVisibleHeight;
	}

	public function set_visibleHeight(value:Float):Float
	{
		if(this.explicitVisibleHeight == value ||
			(value != value && this.explicitVisibleHeight != this.explicitVisibleHeight)) //isNaN
		{
			return this.actualVisibleHeight;
		}
		this.explicitVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this.actualVisibleHeight;
	}

	private var _contentX:Float = 0;

	public var contentX(get, never):Float;
	public function get_contentX():Float
	{
		return this._contentX;
	}

	private var _contentY:Float = 0;

	public var contentY(get, never):Float;
	public function get_contentY():Float
	{
		return this._contentY;
	}

	private var _typicalItemIsInDataProvider:Bool = false;
	private var _typicalItemRenderer:IListItemRenderer;
	private var _unrenderedData:Array = [];
	private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];
	private var _inactiveRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
	private var _activeRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
	private var _rendererMap:Dictionary = new Dictionary(true);
	private var _minimumItemCount:int;

	private var _layoutIndexOffset:Int = 0;

	private var _isScrolling:Bool = false;

	private var _owner:List;

	public var owner(get, set):List;
	public function get_owner():List
	{
		return this._owner;
	}

	public function set_owner(value:List):List
	{
		if(this._owner == value)
		{
			return this._owner;
		}
		if(this._owner != null)
		{
			this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
		}
		this._owner = value;
		if(this._owner != null)
		{
			this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
		}
		return this._owner;
	}

	private var _updateForDataReset:Bool = false;

	private var _dataProvider:ListCollection;

	public var dataProvider(get, set):ListCollection;
	public function get_dataProvider():ListCollection
	{
		return this._dataProvider;
	}

	public function set_dataProvider(value:ListCollection):ListCollection
	{
		if(this._dataProvider == value)
		{
			return this._dataProvider;
		}
		if(this._dataProvider != null)
		{
			this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
			this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
			this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
			this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
			this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
		}
		this._dataProvider = value;
		if(this._dataProvider != null)
		{
			this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
			this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
			this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
			this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
			this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
		}
		if(Std.is(this._layout, IVariableVirtualLayout))
		{
			cast(this._layout, IVariableVirtualLayout).resetVariableVirtualCache();
		}
		this._updateForDataReset = true;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._dataProvider;
	}

	private var _itemRendererType:Class<Dynamic>;

	public var itemRendererType(get, set):Class<Dynamic>;
	public function get_itemRendererType():Class<Dynamic>
	{
		return this._itemRendererType;
	}

	public function set_itemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._itemRendererType == value)
		{
			return this._itemRendererType;
		}

		this._itemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return this._itemRendererType;
	}

	private var _itemRendererFactory:Void->IListItemRenderer;

	public var itemRendererFactory(get, set):Void->IListItemRenderer;
	public function get_itemRendererFactory():Void->IListItemRenderer
	{
		return this._itemRendererFactory;
	}

	public function set_itemRendererFactory(value:Void->IListItemRenderer):Void->IListItemRenderer
	{
		if(this._itemRendererFactory == value)
		{
			return this._itemRendererFactory;
		}

		this._itemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return this._itemRendererFactory;
	}

	private var _customItemRendererStyleName:String;

	public function get_customItemRendererStyleName():String
	{
		return this._customItemRendererStyleName;
	}

	public function set_customItemRendererStyleName(value:String):String
	{
		if(this._customItemRendererStyleName == value)
		{
			return this._itemRendererName;
		}
		this._customItemRendererStyleName = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return this._itemRendererName;
	}

	private var _typicalItem:Dynamic = null;

	public var typicalItem(get, set):Dynamic;
	public function get_typicalItem():Dynamic
	{
		return this._typicalItem;
	}

	public function set_typicalItem(value:Dynamic):Dynamic
	{
		if(this._typicalItem == value)
		{
			return this._typicalItem;
		}
		this._typicalItem = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._typicalItem;
	}

	private var _itemRendererProperties:PropertyProxy;

	public var itemRendererProperties(get, set):PropertyProxy;
	public function get_itemRendererProperties():PropertyProxy
	{
		return this._itemRendererProperties;
	}

	public function set_itemRendererProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._itemRendererProperties == value)
		{
			return this._itemRendererProperties;
		}
		if(this._itemRendererProperties != null)
		{
			this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._itemRendererProperties = value;
		if(this._itemRendererProperties != null)
		{
			this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._itemRendererProperties;
	}

	private var _ignoreLayoutChanges:Bool = false;
	private var _ignoreRendererResizing:Bool = false;

	private var _layout:ILayout;

	public var layout(get, set):ILayout;
	public function get_layout():ILayout
	{
		return this._layout;
	}

	public function set_layout(value:ILayout):ILayout
	{
		if(this._layout == value)
		{
			return get_layout();
		}
		if(this._layout != null)
		{
			cast(this._layout, EventDispatcher).removeEventListener(Event.CHANGE, layout_changeHandler);
		}
		this._layout = value;
		if(this._layout != null)
		{
			if(Std.is(this._layout, IVariableVirtualLayout))
			{
				cast(this._layout, IVariableVirtualLayout).resetVariableVirtualCache();
			}
			cast(this._layout, EventDispatcher).addEventListener(Event.CHANGE, layout_changeHandler);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_layout();
	}

	public var horizontalScrollStep(get, never):Float;
	public function get_horizontalScrollStep():Float
	{
		if(this._activeRenderers.length == 0)
		{
			return 0;
		}
		var itemRenderer:IListItemRenderer = this._activeRenderers[0];
		var itemRendererWidth:Float = itemRenderer.width;
		var itemRendererHeight:Float = itemRenderer.height;
		if(itemRendererWidth < itemRendererHeight)
		{
			return itemRendererWidth;
		}
		return itemRendererHeight;
	}

	public var verticalScrollStep(get, never):Float;
	public function get_verticalScrollStep():Float
	{
		if(this._activeRenderers.length == 0)
		{
			return 0;
		}
		var itemRenderer:IListItemRenderer = this._activeRenderers[0];
		var itemRendererWidth:Float = itemRenderer.width;
		var itemRendererHeight:Float = itemRenderer.height;
		if(itemRendererWidth < itemRendererHeight)
		{
			return itemRendererWidth;
		}
		return itemRendererHeight;
	}

	private var _horizontalScrollPosition:Float = 0;

	public var horizontalScrollPosition(get, set):Float;
	public function get_horizontalScrollPosition():Float
	{
		return this._horizontalScrollPosition;
	}

	public function set_horizontalScrollPosition(value:Float):Float
	{
		if(this._horizontalScrollPosition == value)
		{
			return this._horizontalScrollPosition;
		}
		this._horizontalScrollPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return this._horizontalScrollPosition;
	}

	private var _verticalScrollPosition:Float = 0;

	public var verticalScrollPosition(get, set):Float;
	public function get_verticalScrollPosition():Float
	{
		return this._verticalScrollPosition;
	}

	public function set_verticalScrollPosition(value:Float):Float
	{
		if(this._verticalScrollPosition == value)
		{
			return this._verticalScrollPosition;
		}
		this._verticalScrollPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return this._verticalScrollPosition;
	}

	private var _ignoreSelectionChanges:Bool = false;

	private var _isSelectable:Bool = true;

	public var isSelectable(get, set):Bool;
	public function get_isSelectable():Bool
	{
		return this._isSelectable;
	}

	public function set_isSelectable(value:Bool):Bool
	{
		if(this._isSelectable == value)
		{
			return this._isSelectable;
		}
		this._isSelectable = value;
		if(!value)
		{
			this.selectedIndices = null;
		}
		return this._isSelectable;
	}

	private var _allowMultipleSelection:Bool = false;

	public var allowMultipleSelection(get, set):Bool;
	public function get_allowMultipleSelection():Bool
	{
		return this._allowMultipleSelection;
	}

	public function set_allowMultipleSelection(value:Bool):Bool
	{
		return this._allowMultipleSelection = value;
	}

	private var _selectedIndices:ListCollection;

	public var selectedIndices(get, set):ListCollection;
	public function get_selectedIndices():ListCollection
	{
		return this._selectedIndices;
	}

	public function set_selectedIndices(value:ListCollection):ListCollection
	{
		if(this._selectedIndices == value)
		{
			return this._selectedIndices;
		}
		if(this._selectedIndices != null)
		{
			this._selectedIndices.removeEventListener(Event.CHANGE, selectedIndices_changeHandler);
		}
		this._selectedIndices = value;
		if(this._selectedIndices != null)
		{
			this._selectedIndices.addEventListener(Event.CHANGE, selectedIndices_changeHandler);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return this._selectedIndices;
	}

	public function getScrollPositionForIndex(index:Int, result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}
		return this._layout.getScrollPositionForIndex(index, this._layoutItems,
			0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
	}

	public function getNearestScrollPositionForIndex(index:int, result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}
		return this._layout.getNearestScrollPositionForIndex(index,
			this._horizontalScrollPosition, this._verticalScrollPosition,
			this._layoutItems, 0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
	}

	override public function dispose():Void
	{
		this.owner = null;
		this.layout = null;
		this.dataProvider = null;
		super.dispose();
	}

	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var scrollInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SCROLL);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var selectionInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SELECTED);
		var itemRendererInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var layoutInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_LAYOUT);

		//scrolling only affects the layout is requiresLayoutOnScroll is true
		if(!layoutInvalid && scrollInvalid && this._layout != null && this._layout.requiresLayoutOnScroll)
		{
			layoutInvalid = true;
		}

		var basicsInvalid:Bool = sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid;

		var oldIgnoreRendererResizing:Bool = this._ignoreRendererResizing;
		this._ignoreRendererResizing = true;
		var oldIgnoreLayoutChanges:Bool = this._ignoreLayoutChanges;
		this._ignoreLayoutChanges = true;

		if(scrollInvalid || sizeInvalid)
		{
			this.refreshViewPortBounds();
		}
		if(basicsInvalid)
		{
			this.refreshInactiveRenderers(itemRendererInvalid);
		}
		if(dataInvalid || layoutInvalid || itemRendererInvalid)
		{
			this.refreshLayoutTypicalItem();
		}
		if(basicsInvalid)
		{
			this.refreshRenderers();
		}
		if(stylesInvalid || basicsInvalid)
		{
			this.refreshItemRendererStyles();
		}
		if(selectionInvalid || basicsInvalid)
		{
			//unlike resizing renderers and layout changes, we only want to
			//stop listening for selection changes when we're forcibly
			//updating selection. other property changes on item renderers
			//can validly change selection, and we need to detect that.
			var oldIgnoreSelectionChanges:Bool = this._ignoreSelectionChanges;
			this._ignoreSelectionChanges = true;
			this.refreshSelection();
			this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
		}
		if(stateInvalid || basicsInvalid)
		{
			this.refreshEnabled();
		}
		this._ignoreLayoutChanges = oldIgnoreLayoutChanges;

		if(stateInvalid || selectionInvalid || stylesInvalid || basicsInvalid)
		{
			this._layout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
		}

		this._ignoreRendererResizing = oldIgnoreRendererResizing;

		this._contentX = this._layoutResult.contentX;
		this._contentY = this._layoutResult.contentY;
		this.setSizeInternal(this._layoutResult.contentWidth, this._layoutResult.contentHeight, false);
		this.actualVisibleWidth = this._layoutResult.viewPortWidth;
		this.actualVisibleHeight = this._layoutResult.viewPortHeight;

		//final validation to avoid juggler next frame issues
		this.validateItemRenderers();
	}

	private function invalidateParent(flag:String = FeathersControl.INVALIDATION_FLAG_ALL):Void
	{
		cast(this.parent, Scroller).invalidate(flag);
	}

	private function validateItemRenderers():Void
	{
		var rendererCount:Int = this._activeRenderers.length;
		for(i in 0 ... rendererCount)
		{
			var renderer:IListItemRenderer = this._activeRenderers[i];
			renderer.validate();
		}
	}

	private function refreshLayoutTypicalItem():Void
	{
		var virtualLayout:IVirtualLayout = cast(this._layout, IVirtualLayout);
		if(virtualLayout == null || !virtualLayout.useVirtualLayout)
		{
			//the old layout was virtual, but this one isn't
			if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer != null)
			{
				//it's safe to destroy this renderer
				this.destroyRenderer(this._typicalItemRenderer);
				this._typicalItemRenderer = null;
			}
			return;
		}
		var typicalItemIndex:int = 0;
		var newTypicalItemIsInDataProvider:Bool = false;
		var typicalItem:Object = this._typicalItem;
		if(typicalItem != null)
		{
			if(this._dataProvider != null)
			{
				typicalItemIndex = this._dataProvider.getItemIndex(typicalItem);
				newTypicalItemIsInDataProvider = typicalItemIndex >= 0;
			}
			if(typicalItemIndex < 0)
			{
				typicalItemIndex = 0;
			}
		}
		else
		{
			newTypicalItemIsInDataProvider = true;
			if(this._dataProvider != null && this._dataProvider.length > 0)
			{
				typicalItem = this._dataProvider.getItemAt(0);
			}
		}

		if(typicalItem != null)
		{
			var typicalRenderer:IListItemRenderer = IListItemRenderer(this._rendererMap[typicalItem]);
			if(typicalRenderer)
			{
				//the index may have changed if items were added, removed or
				//reordered in the data provider
				typicalRenderer.index = typicalItemIndex;
			}
			if(!typicalRenderer && this._typicalItemRenderer)
			{
				//we can reuse the typical item renderer if the old typical item
				//wasn't in the data provider.
				var canReuse:Bool = !this._typicalItemIsInDataProvider;
				if(!canReuse)
				{
					//we can also reuse the typical item renderer if the old
					//typical item was in the data provider, but it isn't now.
					canReuse = this._dataProvider.getItemIndex(this._typicalItemRenderer.data) < 0;
				}
				if(canReuse)
				{
					//if the old typical item was in the data provider, remove
					//it from the renderer map.
					if(this._typicalItemIsInDataProvider)
					{
						this._rendererMap.remove(this._typicalItemRenderer.data);
					}
					typicalRenderer = this._typicalItemRenderer;
					typicalRenderer.data = typicalItem;
					typicalRenderer.index = typicalItemIndex;
					//if the new typical item is in the data provider, add it
					//to the renderer map.
					if(newTypicalItemIsInDataProvider)
					{
						this._rendererMap.set(typicalItem, typicalRenderer);
					}
				}
			}
			if(typicalRenderer == null)
			{
				//if we still don't have a typical item renderer, we need to
				//create a new one.
				typicalRenderer = this.createRenderer(typicalItem, typicalItemIndex, false, !newTypicalItemIsInDataProvider);
				if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer != null)
				{
					//get rid of the old typical item renderer if it isn't
					//needed anymore.  since it was not in the data provider, we
					//don't need to mess with the renderer map dictionary.
					this.destroyRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
				}
			}
		}

		virtualLayout.typicalItem = safe_cast(typicalRenderer, DisplayObject);
		this._typicalItemRenderer = typicalRenderer;
		this._typicalItemIsInDataProvider = newTypicalItemIsInDataProvider;
		if(this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
		{
			//we need to know if this item renderer resizes to adjust the
			//layout because the layout may use this item renderer to resize
			//the other item renderers
			this._typicalItemRenderer.addEventListener(FeathersEventType.RESIZE, renderer_resizeHandler);
		}
	}

	private function refreshItemRendererStyles():Void
	{
		for (renderer in this._activeRenderers)
		{
			this.refreshOneItemRendererStyles(renderer);
		}
	}

	private function refreshOneItemRendererStyles(renderer:IListItemRenderer):Void
	{
		if (this._itemRendererProperties == null)
			return;
		var displayRenderer:DisplayObject = cast(renderer, DisplayObject);
		for(propertyName in Reflect.fields(this._itemRendererProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._itemRendererProperties.storage, propertyName);
			Reflect.setProperty(displayRenderer, propertyName, propertyValue);
		}
	}

	private function refreshSelection():Void
	{
		var rendererCount:Int = this._activeRenderers.length;
		for(i in 0 ... rendererCount)
		{
			var renderer:IListItemRenderer = this._activeRenderers[i];
			renderer.isSelected = this._selectedIndices.getItemIndex(renderer.index) >= 0;
		}
	}

	private function refreshEnabled():Void
	{
		var rendererCount:Int = this._activeRenderers.length;
		for(i in 0 ... rendererCount)
		{
			var itemRenderer:IFeathersControl = cast(this._activeRenderers[i], IFeathersControl);
			itemRenderer.isEnabled = this._isEnabled;
		}
	}

	private function refreshViewPortBounds():Void
	{
		this._viewPortBounds.x = this._viewPortBounds.y = 0;
		this._viewPortBounds.scrollX = this._horizontalScrollPosition;
		this._viewPortBounds.scrollY = this._verticalScrollPosition;
		this._viewPortBounds.explicitWidth = this.explicitVisibleWidth;
		this._viewPortBounds.explicitHeight = this.explicitVisibleHeight;
		this._viewPortBounds.minWidth = this._minVisibleWidth;
		this._viewPortBounds.minHeight = this._minVisibleHeight;
		this._viewPortBounds.maxWidth = this._maxVisibleWidth;
		this._viewPortBounds.maxHeight = this._maxVisibleHeight;
	}

	private function refreshInactiveRenderers(itemRendererTypeIsInvalid:Bool):Void
	{
		var temp:Array<IListItemRenderer> = this._inactiveRenderers;
		this._inactiveRenderers = this._activeRenderers;
		this._activeRenderers = temp;
		if(this._activeRenderers.length > 0)
		{
			throw new IllegalOperationError("ListDataViewPort: active renderers should be empty.");
		}
		if(itemRendererTypeIsInvalid)
		{
			this.recoverInactiveRenderers();
			this.freeInactiveRenderers(false);
			if(this._typicalItemRenderer != null)
			{
				if(this._typicalItemIsInDataProvider)
				{
					this._rendererMap.remove(this._typicalItemRenderer.data);
				}
				this.destroyRenderer(this._typicalItemRenderer);
				this._typicalItemRenderer = null;
				this._typicalItemIsInDataProvider = false;
			}
		}

		this._layoutItems.splice(0, this._layoutItems.length);
	}

	private function refreshRenderers():Void
	{
		if(this._typicalItemRenderer != null)
		{
			if(this._typicalItemIsInDataProvider)
			{
				//this renderer is already is use by the typical item, so we
				//don't want to allow it to be used by other items.
				var inactiveIndex:Int = this._inactiveRenderers.indexOf(this._typicalItemRenderer);
				if(inactiveIndex >= 0)
				{
					this._inactiveRenderers[inactiveIndex] = null;
				}
				//if refreshLayoutTypicalItem() was called, it will have already
				//added the typical item renderer to the active renderers. if
				//not, we need to do it here.
				var activeRendererCount:Int = this._activeRenderers.length;
				if(activeRendererCount == 0)
				{
					this._activeRenderers[activeRendererCount] = this._typicalItemRenderer;
				}
			}
			//we need to set the typical item renderer's properties here
			//because they may be needed for proper measurement in a virtual
			//layout.
			this.refreshOneItemRendererStyles(this._typicalItemRenderer);
		}

		this.findUnrenderedData();
		this.recoverInactiveRenderers();
		this.renderUnrenderedData();
		this.freeInactiveRenderers(true);
		this._updateForDataReset = false;
	}

	private function findUnrenderedData():Void
	{
		var itemCount:Int = this._dataProvider != null ? this._dataProvider.length : 0;
		var virtualLayout:IVirtualLayout = cast(this._layout, IVirtualLayout);
		var useVirtualLayout:Bool = virtualLayout != null && virtualLayout.useVirtualLayout;
		if(useVirtualLayout)
		{
			virtualLayout.measureViewPort(itemCount, this._viewPortBounds, HELPER_POINT);
			virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, HELPER_POINT.x, HELPER_POINT.y, itemCount, HELPER_VECTOR);
		}

		var unrenderedItemCount:int = useVirtualLayout ? HELPER_VECTOR.length : itemCount;
		if(useVirtualLayout && this._typicalItemIsInDataProvider && this._typicalItemRenderer &&
			HELPER_VECTOR.indexOf(this._typicalItemRenderer.index) >= 0)
		{
			//add an extra item renderer if the typical item is from the
			//data provider and it is visible. this helps keep the number of
			//item renderers constant!
			this._minimumItemCount = unrenderedItemCount + 1;
		}
		else
		{
			this._minimumItemCount = unrenderedItemCount;
		}
		var canUseBeforeAndAfter:Bool = this._layout is ITrimmedVirtualLayout && useVirtualLayout &&
			(!(this._layout is IVariableVirtualLayout) || !IVariableVirtualLayout(this._layout).hasVariableItemDimensions) &&
			unrenderedItemCount > 0;
		var index:Int;
		if(canUseBeforeAndAfter)
		{
			var minIndex:Int = HELPER_VECTOR[0];
			var maxIndex:Int = minIndex;
			for(i in 1 ... unrenderedItemCount)
			{
				index = HELPER_VECTOR[i];
				if(index < minIndex)
				{
					minIndex = index;
				}
				if(index > maxIndex)
				{
					maxIndex = index;
				}
			}
			var beforeItemCount:Int = minIndex - 1;
			if(beforeItemCount < 0)
			{
				beforeItemCount = 0;
			}
			var afterItemCount:Int = itemCount - 1 - maxIndex;
			var sequentialVirtualLayout:ITrimmedVirtualLayout = cast(this._layout, ITrimmedVirtualLayout);
			sequentialVirtualLayout.beforeVirtualizedItemCount = beforeItemCount;
			sequentialVirtualLayout.afterVirtualizedItemCount = afterItemCount;
			var newLayoutItemLength = itemCount - beforeItemCount - afterItemCount;
			this._layoutItems.splice(newLayoutItemLength, this._layoutItems.length - newLayoutItemLength);
			this._layoutIndexOffset = -beforeItemCount;
		}
		else
		{
			this._layoutIndexOffset = 0;
			this._layoutItems.splice(itemCount, this._layoutItems.length - itemCount);
		}

		var activeRenderersLastIndex:Int = this._activeRenderers.length;
		var unrenderedDataLastIndex:Int = this._unrenderedData.length;
		for(i in 0 ... unrenderedItemCount)
		{
			index = useVirtualLayout ? HELPER_VECTOR[i] : i;
			if(index < 0 || index >= itemCount)
			{
				continue;
			}
			var item:Dynamic = this._dataProvider.getItemAt(index);
			var renderer:IListItemRenderer = safe_cast(this._rendererMap.get(item), IListItemRenderer);
			if(renderer != null)
			{
				//the index may have changed if items were added, removed or
				//reordered in the data provider
				renderer.index = index;
				//if this item renderer used to be the typical item
				//renderer, but it isn't anymore, it may have been set invisible!
				renderer.visible = true;
				if(this._updateForDataReset)
				{
					//similar to calling updateItemAt(), replacing the data
					//provider or resetting its source means that we should
					//trick the item renderer into thinking it has new data.
					//many developers seem to expect this behavior, so while
					//it's not the most optimal for performance, it saves on
					//support time in the forums. thankfully, it's still
					//somewhat optimized since the same item renderer will
					//receive the same data, and the children generally
					//won't have changed much, if at all.
					renderer.data = null;
					renderer.data = item;
				}

				//the typical item renderer is a special case, and we will
				//have already put it into the active renderers, so we don't
				//want to do it again!
				if(this._typicalItemRenderer != renderer)
				{
					this._activeRenderers[activeRenderersLastIndex] = renderer;
					activeRenderersLastIndex++;
					var inactiveIndex:Int = this._inactiveRenderers.indexOf(renderer);
					if(inactiveIndex >= 0)
					{
						this._inactiveRenderers[inactiveIndex] = null;
					}
					else
					{
						throw new IllegalOperationError("ListDataViewPort: renderer map contains bad data.");
					}
				}
				this._layoutItems[index + this._layoutIndexOffset] = cast(renderer, DisplayObject);
			}
			else
			{
				this._unrenderedData[unrenderedDataLastIndex] = item;
				unrenderedDataLastIndex++;
			}
		}
		//update the typical item renderer's visibility
		if(this._typicalItemRenderer != null)
		{
			if(useVirtualLayout && this._typicalItemIsInDataProvider)
			{
				index = HELPER_VECTOR.indexOf(this._typicalItemRenderer.index);
				if(index >= 0)
				{
					this._typicalItemRenderer.visible = true;
				}
				else
				{
					this._typicalItemRenderer.visible = false;

					//uncomment these lines to see a hidden typical item for
					//debugging purposes...
					/*this._typicalItemRenderer.visible = true;
					this._typicalItemRenderer.x = this._horizontalScrollPosition;
					this._typicalItemRenderer.y = this._verticalScrollPosition;*/
				}
			}
			else
			{
				this._typicalItemRenderer.visible = this._typicalItemIsInDataProvider;
			}
		}
		HELPER_VECTOR.splice(0, HELPER_VECTOR.length);
	}

	private function renderUnrenderedData():Void
	{
		var itemCount:Int = this._unrenderedData.length;
		for(i in 0 ... itemCount)
		{
			var item:Dynamic = this._unrenderedData.shift();
			var index:Int = this._dataProvider.getItemIndex(item);
			var renderer:IListItemRenderer = this.createRenderer(item, index, true, false);
			renderer.visible = true;
			this._layoutItems[index + this._layoutIndexOffset] = cast(renderer, DisplayObject);
		}
	}

	private function recoverInactiveRenderers():Void
	{
		var itemCount:Int = this._inactiveRenderers.length;
		for(i in 0 ... itemCount)
		{
			var renderer:IListItemRenderer = this._inactiveRenderers[i];
			if(renderer == null)
			{
				continue;
			}
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, renderer);
			this._rendererMap.remove(renderer.data);
		}
	}

	private function freeInactiveRenderers(allowKeep:Bool):Void
	{
		//we may keep around some extra renderers to avoid too much
		//allocation and garbage collection. they'll be hidden.
		var itemCount:int = this._inactiveRenderers.length;
		if(allowKeep)
		{
			var keepCount:int = this._minimumItemCount - this._activeRenderers.length;
		}
		else
		{
			keepCount = 0;
		}
		if(itemCount < keepCount)
		{
			keepCount = itemCount;
		}
		for(var i:int = 0; i < keepCount; i++)
		{
			var renderer:IListItemRenderer = this._inactiveRenderers.shift();
			if(renderer == null)
			{
				keepCount++;
				if(itemCount < keepCount)
				{
					keepCount = itemCount;
				}
				continue;
			}
			renderer.data = null;
			renderer.index = -1;
			renderer.visible = false;
			this._activeRenderers.push(renderer);
		}
		itemCount -= keepCount;
		for(i = 0; i < itemCount; i++)
		{
			renderer = this._inactiveRenderers.shift();
			if(!renderer)
			{
				continue;
			}
			this.destroyRenderer(renderer);
		}
	}

	private function createRenderer(item:Dynamic, index:Int, useCache:Bool, isTemporary:Bool):IListItemRenderer
	{
		var renderer:IListItemRenderer;
		do
		{
			if(!useCache || isTemporary || this._inactiveRenderers.length == 0)
			{
				if(this._itemRendererFactory != null)
				{
					renderer = this._itemRendererFactory();
				}
				else
				{
					renderer = Type.createInstance(this._itemRendererType, []);
				}
				var uiRenderer:IFeathersControl = IFeathersControl(renderer);
				if(this._customItemRendererStyleName && this._customItemRendererStyleName.length > 0)
				{
					uiRenderer.styleNameList.add(this._customItemRendererStyleName);
				}
				this.addChild(cast(renderer, DisplayObject));
			}
			else
			{
				renderer = this._inactiveRenderers.shift();
			}
			//wondering why this all is in a loop?
			//_inactiveRenderers.shift() may return null because we're
			//storing null values instead of calling splice() to improve
			//performance.
		}
		while (renderer == null);
		renderer.data = item;
		renderer.index = index;
		renderer.owner = this._owner;

		if(!isTemporary)
		{
			this._rendererMap.set(item, renderer);
			this._activeRenderers[this._activeRenderers.length] = renderer;
			renderer.addEventListener(Event.TRIGGERED, renderer_triggeredHandler);
			renderer.addEventListener(Event.CHANGE, renderer_changeHandler);
			renderer.addEventListener(FeathersEventType.RESIZE, renderer_resizeHandler);
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, renderer);
		}

		return renderer;
	}

	private function destroyRenderer(renderer:IListItemRenderer):Void
	{
		renderer.removeEventListener(Event.TRIGGERED, renderer_triggeredHandler);
		renderer.removeEventListener(Event.CHANGE, renderer_changeHandler);
		renderer.removeEventListener(FeathersEventType.RESIZE, renderer_resizeHandler);
		renderer.owner = null;
		renderer.data = null;
		this.removeChild(cast(renderer, DisplayObject), true);
	}

	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	private function owner_scrollStartHandler(event:Event):Void
	{
		this._isScrolling = true;
	}

	private function dataProvider_changeHandler(event:Event):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	private function dataProvider_addItemHandler(event:Event, index:Int):Void
	{
		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		layout.addToVariableVirtualCacheAtIndex(index);
	}

	private function dataProvider_removeItemHandler(event:Event, index:Int):Void
	{
		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		layout.removeFromVariableVirtualCacheAtIndex(index);
	}

	private function dataProvider_replaceItemHandler(event:Event, index:Int):Void
	{
		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		layout.resetVariableVirtualCacheAtIndex(index);
	}

	private function dataProvider_resetHandler(event:Event):Void
	{
		this._updateForDataReset = true;

		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		layout.resetVariableVirtualCache();
	}

	private function dataProvider_updateItemHandler(event:Event, index:Int):Void
	{
		var item:Dynamic = this._dataProvider.getItemAt(index);
		var renderer:IListItemRenderer = this._rendererMap.get(item);
		if(renderer == null)
		{
			return;
		}
		renderer.data = null;
		renderer.data = item;
	}

	private function layout_changeHandler(event:Event):Void
	{
		if(this._ignoreLayoutChanges)
		{
			return;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		this.invalidateParent(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	private function renderer_resizeHandler(event:Event):Void
	{
		if(this._ignoreRendererResizing)
		{
			return;
		}
		this.invalidate(INVALIDATION_FLAG_LAYOUT);
		this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
		if(event.currentTarget === this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
		{
			return;
		}
		var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
		if(!layout || !layout.hasVariableItemDimensions)
		{
			return;
		}
		var renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
		layout.resetVariableVirtualCacheAtIndex(renderer.index, DisplayObject(renderer));
	}

	private function renderer_triggeredHandler(event:Event):Void
	{
		var renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
		this.parent.dispatchEventWith(Event.TRIGGERED, false, renderer.data);
	}

	private function renderer_changeHandler(event:Event):Void
	{
		if(this._ignoreSelectionChanges)
		{
			return;
		}
		var renderer:IListItemRenderer = cast(event.currentTarget, IListItemRenderer);
		if(!this._isSelectable || this._isScrolling)
		{
			renderer.isSelected = false;
			return;
		}
		var isSelected:Bool = renderer.isSelected;
		var index:Int = renderer.index;
		if(this._allowMultipleSelection)
		{
			var indexOfIndex:Int = this._selectedIndices.getItemIndex(index);
			if(isSelected && indexOfIndex < 0)
			{
				this._selectedIndices.addItem(index);
			}
			else if(!isSelected && indexOfIndex >= 0)
			{
				this._selectedIndices.removeItemAt(indexOfIndex);
			}
		}
		else if(isSelected)
		{
			this._selectedIndices.data = [index];
		}
		else
		{
			this._selectedIndices.removeAll();
		}
	}

	private function selectedIndices_changeHandler(event:Event):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	private function removedFromStageHandler(event:Event):Void
	{
		this.touchPointID = -1;
	}

	private function touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this.touchPointID = -1;
			return;
		}

		if(this.touchPointID >= 0)
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED, this.touchPointID);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = -1;
		}
		else
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = touch.id;
			this._isScrolling = false;
		}
	}
}