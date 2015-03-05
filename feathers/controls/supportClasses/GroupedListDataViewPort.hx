/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.controls.GroupedList;
import feathers.controls.Scroller;
import feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer;
import feathers.controls.renderers.IGroupedListItemRenderer;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.PropertyProxy;
import feathers.data.HierarchicalCollection;
import feathers.events.CollectionEventType;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.IVariableVirtualLayout;
import feathers.layout.IVirtualLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.ViewPortBounds;
#if flash
import feathers.utils.type.UnionWeakMap;
#end
import feathers.utils.type.SafeCast.safe_cast;
import feathers.utils.type.UnionMap;
import openfl.errors.ArgumentError;

import openfl.errors.IllegalOperationError;
import openfl.geom.Point;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * @private
 * Used internally by GroupedList. Not meant to be used on its own.
 */
class GroupedListDataViewPort extends FeathersControl implements IViewPort
{
	inline private static var INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";

	private static var HELPER_POINT:Point = new Point();
	private static var HELPER_VECTOR:Array<Int> = new Array();

	public function new()
	{
		super();
		this.addEventListener(TouchEvent.TOUCH, touchHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
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
			return get_minVisibleWidth();
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleWidth cannot be Math.NaN");
		}
		this._minVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_minVisibleWidth();
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
			return get_maxVisibleWidth();
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleWidth cannot be Math.NaN");
		}
		this._maxVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_maxVisibleWidth();
	}

	private var actualVisibleWidth:Float = Math.NaN;

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
			return get_visibleWidth();
		}
		this.explicitVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_visibleWidth();
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
			return get_minVisibleHeight();
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleHeight cannot be Math.NaN");
		}
		this._minVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_minVisibleHeight();
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
			return get_maxVisibleHeight();
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleHeight cannot be Math.NaN");
		}
		this._maxVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_maxVisibleHeight();
	}

	private var actualVisibleHeight:Float;

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
			return get_visibleHeight();
		}
		this.explicitVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_visibleHeight();
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

	public var horizontalScrollStep(get, never):Float;
	public function get_horizontalScrollStep():Float
	{
		var renderers:Array<IGroupedListItemRenderer> = this._activeItemRenderers;
		if(renderers == null || renderers.length == 0)
		{
			renderers = this._activeFirstItemRenderers;
		}
		if(renderers == null || renderers.length == 0)
		{
			renderers = this._activeLastItemRenderers;
		}
		if(renderers == null || renderers.length == 0)
		{
			renderers = this._activeSingleItemRenderers;
		}
		if(renderers == null || renderers.length == 0)
		{
			return 0;
		}
		var itemRenderer:IGroupedListItemRenderer = renderers[0];
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
		var renderers:Array<IGroupedListItemRenderer> = this._activeItemRenderers;
		if(renderers == null || renderers.length == 0)
		{
			renderers = this._activeFirstItemRenderers;
		}
		if(renderers == null || renderers.length == 0)
		{
			renderers = this._activeLastItemRenderers;
		}
		if(renderers == null || renderers.length == 0)
		{
			renderers = this._activeSingleItemRenderers;
		}
		if(renderers == null || renderers.length == 0)
		{
			return 0;
		}
		var itemRenderer:IGroupedListItemRenderer = renderers[0];
		var itemRendererWidth:Float = itemRenderer.width;
		var itemRendererHeight:Float = itemRenderer.height;
		if(itemRendererWidth < itemRendererHeight)
		{
			return itemRendererWidth;
		}
		return itemRendererHeight;
	}

	private var _layoutItems:Array<DisplayObject> = new Array();

	private var _typicalItemIsInDataProvider:Bool = false;
	private var _typicalItemRenderer:IGroupedListItemRenderer;

	private var _unrenderedItems:Array<Int> = new Array();
	private var _inactiveItemRenderers:Array<IGroupedListItemRenderer> = new Array();
	private var _activeItemRenderers:Array<IGroupedListItemRenderer> = new Array();
	#if flash
	private var _itemRendererMap:UnionWeakMap<IGroupedListItemRenderer> = new UnionWeakMap();
	#else
	private var _itemRendererMap:UnionMap<IGroupedListItemRenderer> = new UnionMap();
	#end

	private var _unrenderedFirstItems:Array<Int>;
	private var _inactiveFirstItemRenderers:Array<IGroupedListItemRenderer>;
	private var _activeFirstItemRenderers:Array<IGroupedListItemRenderer>;
	#if flash
	private var _firstItemRendererMap:UnionWeakMap<IGroupedListItemRenderer> = new UnionWeakMap();
	#else
	private var _firstItemRendererMap:UnionMap<IGroupedListItemRenderer> = new UnionMap();
	#end

	private var _unrenderedLastItems:Array<Int>;
	private var _inactiveLastItemRenderers:Array<IGroupedListItemRenderer>;
	private var _activeLastItemRenderers:Array<IGroupedListItemRenderer>;
	private var _lastItemRendererMap:UnionMap<IGroupedListItemRenderer>;

	private var _unrenderedSingleItems:Array<Int>;
	private var _inactiveSingleItemRenderers:Array<IGroupedListItemRenderer>;
	private var _activeSingleItemRenderers:Array<IGroupedListItemRenderer>;
	private var _singleItemRendererMap:UnionMap<IGroupedListItemRenderer>;

	private var _unrenderedHeaders:Array<Int> = new Array();
	private var _inactiveHeaderRenderers:Array<IGroupedListHeaderOrFooterRenderer> = new Array();
	private var _activeHeaderRenderers:Array<IGroupedListHeaderOrFooterRenderer> = new Array();
	#if flash
	private var _headerRendererMap:UnionWeakMap<IGroupedListHeaderOrFooterRenderer> = new UnionWeakMap();
	#else
	private var _headerRendererMap:UnionMap<IGroupedListHeaderOrFooterRenderer> = new UnionMap();
	#end

	private var _unrenderedFooters:Array<Int> = new Array();
	private var _inactiveFooterRenderers:Array<IGroupedListHeaderOrFooterRenderer> = new Array();
	private var _activeFooterRenderers:Array<IGroupedListHeaderOrFooterRenderer> = new Array();
	#if flash
	private var _footerRendererMap:UnionWeakMap<IGroupedListHeaderOrFooterRenderer> = new UnionWeakMap();
	#else
	private var _footerRendererMap:UnionMap<IGroupedListHeaderOrFooterRenderer> = new UnionMap();
	#end

	private var _headerIndices:Array<Int> = new Array();
	private var _footerIndices:Array<Int> = new Array();

	private var _isScrolling:Bool = false;

	private var _owner:GroupedList;

	public var owner(get, set):GroupedList;
	public function get_owner():GroupedList
	{
		return this._owner;
	}

	public function set_owner(value:GroupedList):GroupedList
	{
		if(this._owner == value)
		{
			return get_owner();
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
		return get_owner();
	}

	private var _updateForDataReset:Bool = false;

	private var _dataProvider:HierarchicalCollection;

	public var dataProvider(get, set):HierarchicalCollection;
	public function get_dataProvider():HierarchicalCollection
	{
		return this._dataProvider;
	}

	public function set_dataProvider(value:HierarchicalCollection):HierarchicalCollection
	{
		if(this._dataProvider == value)
		{
			return get_dataProvider();
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
		return get_dataProvider();
	}

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
			return get_isSelectable();
		}
		this._isSelectable = value;
		if(!this._isSelectable)
		{
			this.setSelectedLocation(-1, -1);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_isSelectable();
	}

	private var _selectedGroupIndex:Int = -1;

	public var selectedGroupIndex(get, never):Int;
	public function get_selectedGroupIndex():Int
	{
		return this._selectedGroupIndex;
	}

	private var _selectedItemIndex:Int = -1;

	public var selectedItemIndex(get, never):Int;
	public function get_selectedItemIndex():Int
	{
		return this._selectedItemIndex;
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
			return get_itemRendererType();
		}

		this._itemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_itemRendererType();
	}

	private var _itemRendererFactory:Void->IGroupedListItemRenderer;

	public var itemRendererFactory(get, set):Void->IGroupedListItemRenderer;
	public function get_itemRendererFactory():Void->IGroupedListItemRenderer
	{
		return this._itemRendererFactory;
	}

	public function set_itemRendererFactory(value:Void->IGroupedListItemRenderer):Void->IGroupedListItemRenderer
	{
		if(this._itemRendererFactory == value)
		{
			return get_itemRendererFactory();
		}

		this._itemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_itemRendererFactory();
	}

	private var _itemRendererName:String;

	public var itemRendererName(get, set):String;
	public function get_itemRendererName():String
	{
		return this._itemRendererName;
	}

	public function set_itemRendererName(value:String):String
	{
		if(this._itemRendererName == value)
		{
			return get_itemRendererName();
		}
		this._itemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_itemRendererName();
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
			return get_typicalItem();
		}
		this._typicalItem = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_typicalItem();
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
			return get_itemRendererProperties();
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
		return get_itemRendererProperties();
	}

	private var _firstItemRendererType:Class<Dynamic>;

	public var firstItemRendererType(get, set):Class<Dynamic>;
	public function get_firstItemRendererType():Class<Dynamic>
	{
		return this._firstItemRendererType;
	}

	public function set_firstItemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._firstItemRendererType == value)
		{
			return get_firstItemRendererType();
		}

		this._firstItemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_firstItemRendererType();
	}

	private var _firstItemRendererFactory:Void->IGroupedListItemRenderer;

	public var firstItemRendererFactory(get, set):Void->IGroupedListItemRenderer;
	public function get_firstItemRendererFactory():Void->IGroupedListItemRenderer
	{
		return this._firstItemRendererFactory;
	}

	public function set_firstItemRendererFactory(value:Void->IGroupedListItemRenderer):Void->IGroupedListItemRenderer
	{
		if(this._firstItemRendererFactory == value)
		{
			return get_firstItemRendererFactory();
		}

		this._firstItemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_firstItemRendererFactory();
	}

	private var _firstItemRendererName:String;

	public var firstItemRendererName(get, set):String;
	public function get_firstItemRendererName():String
	{
		return this._firstItemRendererName;
	}

	public function set_firstItemRendererName(value:String):String
	{
		if(this._firstItemRendererName == value)
		{
			return get_firstItemRendererName();
		}
		this._firstItemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_firstItemRendererName();
	}

	private var _lastItemRendererType:Class<Dynamic>;

	public var lastItemRendererType(get, set):Class<Dynamic>;
	public function get_lastItemRendererType():Class<Dynamic>
	{
		return this._lastItemRendererType;
	}

	public function set_lastItemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._lastItemRendererType == value)
		{
			return get_lastItemRendererType();
		}

		this._lastItemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_lastItemRendererType();
	}

	private var _lastItemRendererFactory:Void->IGroupedListItemRenderer;

	public var lastItemRendererFactory(get, set):Void->IGroupedListItemRenderer;
	public function get_lastItemRendererFactory():Void->IGroupedListItemRenderer
	{
		return this._lastItemRendererFactory;
	}

	public function set_lastItemRendererFactory(value:Void->IGroupedListItemRenderer):Void->IGroupedListItemRenderer
	{
		if(this._lastItemRendererFactory == value)
		{
			return get_lastItemRendererFactory();
		}

		this._lastItemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_lastItemRendererFactory();
	}

	private var _lastItemRendererName:String;

	public var lastItemRendererName(get, set):String;
	public function get_lastItemRendererName():String
	{
		return this._lastItemRendererName;
	}

	public function set_lastItemRendererName(value:String):String
	{
		if(this._lastItemRendererName == value)
		{
			return get_lastItemRendererName();
		}
		this._lastItemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_lastItemRendererName();
	}

	private var _singleItemRendererType:Class<Dynamic>;

	public var singleItemRendererType(get, set):Class<Dynamic>;
	public function get_singleItemRendererType():Class<Dynamic>
	{
		return this._singleItemRendererType;
	}

	public function set_singleItemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._singleItemRendererType == value)
		{
			return get_singleItemRendererType();
		}

		this._singleItemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_singleItemRendererType();
	}

	private var _singleItemRendererFactory:Void->IGroupedListItemRenderer;

	public var singleItemRendererFactory(get, set):Void->IGroupedListItemRenderer;
	public function get_singleItemRendererFactory():Void->IGroupedListItemRenderer
	{
		return this._singleItemRendererFactory;
	}

	public function set_singleItemRendererFactory(value:Void->IGroupedListItemRenderer):Void->IGroupedListItemRenderer
	{
		if(this._singleItemRendererFactory == value)
		{
			return get_singleItemRendererFactory();
		}

		this._singleItemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_singleItemRendererFactory();
	}

	private var _singleItemRendererName:String;

	public var singleItemRendererName(get, set):String;
	public function get_singleItemRendererName():String
	{
		return this._singleItemRendererName;
	}

	public function set_singleItemRendererName(value:String):String
	{
		if(this._singleItemRendererName == value)
		{
			return get_singleItemRendererName();
		}
		this._singleItemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_singleItemRendererName();
	}

	private var _headerRendererType:Class<Dynamic>;

	public var headerRendererType(get, set):Class<Dynamic>;
	public function get_headerRendererType():Class<Dynamic>
	{
		return this._headerRendererType;
	}

	public function set_headerRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._headerRendererType == value)
		{
			return get_headerRendererType();
		}

		this._headerRendererType = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_headerRendererType();
	}

	private var _headerRendererFactory:Void->IGroupedListHeaderOrFooterRenderer;

	public var headerRendererFactory(get, set):Void->IGroupedListHeaderOrFooterRenderer;
	public function get_headerRendererFactory():Void->IGroupedListHeaderOrFooterRenderer
	{
		return this._headerRendererFactory;
	}

	public function set_headerRendererFactory(value:Void->IGroupedListHeaderOrFooterRenderer):Void->IGroupedListHeaderOrFooterRenderer
	{
		if(this._headerRendererFactory == value)
		{
			return get_headerRendererFactory();
		}

		this._headerRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_headerRendererFactory();
	}

	private var _headerRendererName:String;

	public var headerRendererName(get, set):String;
	public function get_headerRendererName():String
	{
		return this._headerRendererName;
	}

	public function set_headerRendererName(value:String):String
	{
		if(this._headerRendererName == value)
		{
			return get_headerRendererName();
		}
		this._headerRendererName = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_headerRendererName();
	}

	private var _headerRendererProperties:PropertyProxy;

	public var headerRendererProperties(get, set):PropertyProxy;
	public function get_headerRendererProperties():PropertyProxy
	{
		return this._headerRendererProperties;
	}

	public function set_headerRendererProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._headerRendererProperties == value)
		{
			return get_headerRendererProperties();
		}
		if(this._headerRendererProperties != null)
		{
			this._headerRendererProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._headerRendererProperties = value;
		if(this._headerRendererProperties != null)
		{
			this._headerRendererProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_headerRendererProperties();
	}

	private var _footerRendererType:Class<Dynamic>;

	public var footerRendererType(get, set):Class<Dynamic>;
	public function get_footerRendererType():Class<Dynamic>
	{
		return this._footerRendererType;
	}

	public function set_footerRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._footerRendererType == value)
		{
			return get_footerRendererType();
		}

		this._footerRendererType = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_footerRendererType();
	}

	private var _footerRendererFactory:Void->IGroupedListHeaderOrFooterRenderer;

	public var footerRendererFactory(get, set):Void->IGroupedListHeaderOrFooterRenderer;
	public function get_footerRendererFactory():Void->IGroupedListHeaderOrFooterRenderer
	{
		return this._footerRendererFactory;
	}

	public function set_footerRendererFactory(value:Void->IGroupedListHeaderOrFooterRenderer):Void->IGroupedListHeaderOrFooterRenderer
	{
		if(this._footerRendererFactory == value)
		{
			return get_footerRendererFactory();
		}

		this._footerRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_footerRendererFactory();
	}

	private var _footerRendererName:String;

	public var footerRendererName(get, set):String;
	public function get_footerRendererName():String
	{
		return this._footerRendererName;
	}

	public function set_footerRendererName(value:String):String
	{
		if(this._footerRendererName == value)
		{
			return get_footerRendererName();
		}
		this._footerRendererName = value;
		this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		return get_footerRendererName();
	}

	private var _footerRendererProperties:PropertyProxy;

	public var footerRendererProperties(get, set):PropertyProxy;
	public function get_footerRendererProperties():PropertyProxy
	{
		return this._footerRendererProperties;
	}

	public function set_footerRendererProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._footerRendererProperties == value)
		{
			return get_footerRendererProperties();
		}
		if(this._footerRendererProperties != null)
		{
			this._footerRendererProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._footerRendererProperties = value;
		if(this._footerRendererProperties != null)
		{
			this._footerRendererProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_footerRendererProperties();
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
			this._layout.removeEventListener(Event.CHANGE, layout_changeHandler);
		}
		this._layout = value;
		if(this._layout != null)
		{
			if(Std.is(this._layout, IVariableVirtualLayout))
			{
				var variableVirtualLayout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
				variableVirtualLayout.hasVariableItemDimensions = true;
				variableVirtualLayout.resetVariableVirtualCache();
			}
			this._layout.addEventListener(Event.CHANGE, layout_changeHandler);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_layout();
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
			return get_horizontalScrollPosition();
		}
		this._horizontalScrollPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return get_horizontalScrollPosition();
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
			return get_verticalScrollPosition();
		}
		this._verticalScrollPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return get_verticalScrollPosition();
	}

	private var _minimumItemCount:Int;
	private var _minimumHeaderCount:Int;
	private var _minimumFooterCount:Int;
	private var _minimumFirstAndLastItemCount:Int;
	private var _minimumSingleItemCount:Int;

	private var _ignoreSelectionChanges:Bool = false;

	public function setSelectedLocation(groupIndex:Int, itemIndex:Int):Void
	{
		if(this._selectedGroupIndex == groupIndex && this._selectedItemIndex == itemIndex)
		{
			return;
		}
		if((groupIndex < 0 && itemIndex >= 0) || (groupIndex >= 0 && itemIndex < 0))
		{
			throw new ArgumentError("To deselect items, group index and item index must both be < 0.");
		}
		this._selectedGroupIndex = groupIndex;
		this._selectedItemIndex = itemIndex;

		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		this.dispatchEventWith(Event.CHANGE);
	}

	public function getScrollPositionForIndex(groupIndex:Int, itemIndex:Int, result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}

		var displayIndex:Int = this.locationToDisplayIndex(groupIndex, itemIndex);
		return this._layout.getScrollPositionForIndex(displayIndex, this._layoutItems, 0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
	}

	override public function dispose():Void
	{
		this.owner = null;
		this.dataProvider = null;
		this.layout = null;
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
			this.refreshHeaderRendererStyles();
			this.refreshFooterRendererStyles();
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

		this._layout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);

		this._ignoreRendererResizing = oldIgnoreRendererResizing;

		this._contentX = this._layoutResult.contentX;
		this._contentY = this._layoutResult.contentY;
		this.setSizeInternal(this._layoutResult.contentWidth, this._layoutResult.contentHeight, false);
		this.actualVisibleWidth = this._layoutResult.viewPortWidth;
		this.actualVisibleHeight = this._layoutResult.viewPortHeight;

		//final validation to avoid juggler next frame issues
		this.validateRenderers();
	}

	private function validateRenderers():Void
	{
		var rendererCount:Int = this._activeFirstItemRenderers != null ? this._activeFirstItemRenderers.length : 0;
		var renderer:IGroupedListItemRenderer;
		for(i in 0 ... rendererCount)
		{
			renderer = this._activeFirstItemRenderers[i];
			renderer.validate();
		}
		rendererCount = this._activeLastItemRenderers != null ? this._activeLastItemRenderers.length : 0;
		for(i in 0 ... rendererCount)
		{
			renderer = this._activeLastItemRenderers[i];
			renderer.validate();
		}
		rendererCount = this._activeSingleItemRenderers != null ? this._activeSingleItemRenderers.length : 0;
		for(i in 0 ... rendererCount)
		{
			renderer = this._activeSingleItemRenderers[i];
			renderer.validate();
		}
		rendererCount = this._activeItemRenderers.length;
		for(i in 0 ... rendererCount)
		{
			renderer = this._activeItemRenderers[i];
			renderer.validate();
		}
		rendererCount = this._activeHeaderRenderers.length;
		var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer;
		for(i in 0 ... rendererCount)
		{
			headerOrFooterRenderer = this._activeHeaderRenderers[i];
			headerOrFooterRenderer.validate();
		}
		rendererCount = this._activeFooterRenderers.length;
		for(i in 0 ... rendererCount)
		{
			headerOrFooterRenderer = this._activeFooterRenderers[i];
			headerOrFooterRenderer.validate();
		}
	}

	private function refreshEnabled():Void
	{
		var rendererCount:Int = this._activeItemRenderers.length;
		var renderer:DisplayObject;
		for(i in 0 ... rendererCount)
		{
			renderer = cast(this._activeItemRenderers[i], DisplayObject);
			if(Std.is(renderer, IFeathersControl))
			{
				cast(renderer, IFeathersControl).isEnabled = this._isEnabled;
			}
		}
		if(this._activeFirstItemRenderers != null)
		{
			rendererCount = this._activeFirstItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				renderer = cast(this._activeFirstItemRenderers[i], DisplayObject);
				if(Std.is(renderer, IFeathersControl))
				{
					cast(renderer, IFeathersControl).isEnabled = this._isEnabled;
				}
			}
		}
		if(this._activeLastItemRenderers != null)
		{
			rendererCount = this._activeLastItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				renderer = cast(this._activeLastItemRenderers[i], DisplayObject);
				if(Std.is(renderer, IFeathersControl))
				{
					cast(renderer, IFeathersControl).isEnabled = this._isEnabled;
				}
			}
		}
		if(this._activeSingleItemRenderers != null)
		{
			rendererCount = this._activeSingleItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				renderer = cast(this._activeSingleItemRenderers[i], DisplayObject);
				if(Std.is(renderer, IFeathersControl))
				{
					cast(renderer, IFeathersControl).isEnabled = this._isEnabled;
				}
			}
		}
		rendererCount = this._activeHeaderRenderers.length;
		for(i in 0 ... rendererCount)
		{
			renderer = cast(this._activeHeaderRenderers[i], DisplayObject);
			if(Std.is(renderer, IFeathersControl))
			{
				cast(renderer, IFeathersControl).isEnabled = this._isEnabled;
			}
		}
		rendererCount = this._activeFooterRenderers.length;
		for(i in 0 ... rendererCount)
		{
			renderer = cast(this._activeFooterRenderers[i], DisplayObject);
			if(Std.is(renderer, IFeathersControl))
			{
				cast(renderer, IFeathersControl).isEnabled = this._isEnabled;
			}
		}
	}

	private function invalidateParent(flag:String = FeathersControl.INVALIDATION_FLAG_ALL):Void
	{
		cast(this.parent, Scroller).invalidate(flag);
	}

	private function refreshLayoutTypicalItem():Void
	{
		var virtualLayout:IVirtualLayout = cast(this._layout, IVirtualLayout);
		if(virtualLayout == null || !virtualLayout.useVirtualLayout)
		{
			if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer != null)
			{
				//the old layout was virtual, but this one isn't
				this.destroyItemRenderer(this._typicalItemRenderer);
				this._typicalItemRenderer = null;
			}
			return;
		}

		var hasCustomFirstItemRenderer:Bool = this._firstItemRendererType != null || this._firstItemRendererFactory != null || this._firstItemRendererName != null;
		var hasCustomSingleItemRenderer:Bool = this._singleItemRendererType != null || this._singleItemRendererFactory != null || this._singleItemRendererName != null;

		var newTypicalItemIsInDataProvider:Bool = false;
		var typicalItem:Dynamic = this._typicalItem;
		var groupCount:Int = 0;
		var firstGroupLength:Int = 0;
		var typicalItemGroupIndex:Int = 0;
		var typicalItemItemIndex:Int = 0;
		if(this._dataProvider != null)
		{
			if(!typicalItem)
			{
				groupCount = this._dataProvider.getLength();
				if(groupCount > 0)
				{
					firstGroupLength = this._dataProvider.getLength(0);
					if(firstGroupLength > 0)
					{
						newTypicalItemIsInDataProvider = true;
						typicalItem = this._dataProvider.getItemAt([0, 0]);
					}
				}
			}
			else if(typicalItem)
			{
				this._dataProvider.getItemLocation(typicalItem, HELPER_VECTOR);
				if(HELPER_VECTOR.length > 1)
				{
					newTypicalItemIsInDataProvider = true;
					typicalItemGroupIndex = HELPER_VECTOR[0];
					typicalItemItemIndex = HELPER_VECTOR[1];
				}
			}
		}

		var typicalItemRenderer:IGroupedListItemRenderer = null;
		if(typicalItem)
		{
			var isFirst:Bool = false;
			var isSingle:Bool = false;
			if(hasCustomSingleItemRenderer && firstGroupLength == 1)
			{
				if(this._singleItemRendererMap != null)
				{
					typicalItemRenderer = safe_cast(this._singleItemRendererMap.get(typicalItem), IGroupedListItemRenderer);
				}
				isSingle = true;
			}
			else if(hasCustomFirstItemRenderer && firstGroupLength > 1)
			{
				if(this._firstItemRendererMap != null)
				{
					typicalItemRenderer = safe_cast(this._firstItemRendererMap.get(typicalItem), IGroupedListItemRenderer);
				}
				isFirst = true;
			}
			else
			{
				typicalItemRenderer = safe_cast(this._itemRendererMap.get(typicalItem), IGroupedListItemRenderer);
			}
			if(typicalItemRenderer == null && !newTypicalItemIsInDataProvider && this._typicalItemRenderer != null)
			{
				//can use reuse the old item renderer instance
				//since it is not in the data provider, we don't need to mess
				//with the renderer map dictionary.
				typicalItemRenderer = this._typicalItemRenderer;
				typicalItemRenderer.data = typicalItem;
				typicalItemRenderer.groupIndex = typicalItemGroupIndex;
				typicalItemRenderer.itemIndex = typicalItemItemIndex;
			}
			if(typicalItemRenderer == null)
			{
				var activeRenderers:Array<IGroupedListItemRenderer>;
				var inactiveRenderers:Array<IGroupedListItemRenderer>;
				var type:Class<Dynamic>;
				var factory:Void->IGroupedListItemRenderer;
				if(isFirst)
				{
					activeRenderers = this._activeFirstItemRenderers;
					inactiveRenderers = this._inactiveFirstItemRenderers;
					type = this._firstItemRendererType != null ? this._firstItemRendererType : this._itemRendererType;
					factory = this._firstItemRendererFactory != null ? this._firstItemRendererFactory : this._itemRendererFactory;
					var name:String = this._firstItemRendererName != null ? this._firstItemRendererName : this._itemRendererName;
					typicalItemRenderer = this.createItemRenderer(inactiveRenderers,
						activeRenderers, this._firstItemRendererMap, type, factory,
						name, typicalItem, 0, 0, 0, false, !newTypicalItemIsInDataProvider);
				}
				else if(isSingle)
				{
					activeRenderers = this._activeSingleItemRenderers;
					inactiveRenderers = this._inactiveSingleItemRenderers;
					type = this._singleItemRendererType != null ? this._singleItemRendererType : this._itemRendererType;
					factory = this._singleItemRendererFactory != null ? this._singleItemRendererFactory : this._itemRendererFactory;
					name = this._singleItemRendererName != null ? this._singleItemRendererName : this._itemRendererName;
					typicalItemRenderer = this.createItemRenderer(inactiveRenderers,
						activeRenderers, this._singleItemRendererMap, type, factory,
						name, typicalItem, 0, 0, 0, false, !newTypicalItemIsInDataProvider);
				}
				else
				{
					activeRenderers = this._activeItemRenderers;
					inactiveRenderers = this._inactiveItemRenderers;
					typicalItemRenderer = this.createItemRenderer(inactiveRenderers,
						activeRenderers, this._itemRendererMap, this._itemRendererType, this._itemRendererFactory,
						this._itemRendererName, typicalItem, 0, 0, 0, false, !newTypicalItemIsInDataProvider);
				}
				//can't be in a last item renderer

				if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer != null)
				{
					//get rid of the old one if it isn't needed anymore
					//since it is not in the data provider, we don't need to mess
					//with the renderer map dictionary.
					this.destroyItemRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
				}
			}
		}

		virtualLayout.typicalItem = cast(typicalItemRenderer, DisplayObject);
		this._typicalItemRenderer = typicalItemRenderer;
		this._typicalItemIsInDataProvider = newTypicalItemIsInDataProvider;
	}

	private function refreshItemRendererStyles():Void
	{
		for (renderer in this._activeItemRenderers)
		{
			this.refreshOneItemRendererStyles(renderer);
		}
		if(this._activeFirstItemRenderers != null)
		{
			for (renderer in this._activeFirstItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
		}
		if(this._activeLastItemRenderers != null)
		{
			for (renderer in this._activeLastItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
		}
		if(this._activeSingleItemRenderers != null)
		{
			for (renderer in this._activeSingleItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
		}
	}

	private function refreshHeaderRendererStyles():Void
	{
		for (renderer in this._activeHeaderRenderers)
		{
			this.refreshOneHeaderRendererStyles(renderer);
		}
	}

	private function refreshFooterRendererStyles():Void
	{
		for (renderer in this._activeFooterRenderers)
		{
			this.refreshOneFooterRendererStyles(renderer);
		}
	}

	private function refreshOneItemRendererStyles(renderer:IGroupedListItemRenderer):Void
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

	private function refreshOneHeaderRendererStyles(renderer:IGroupedListHeaderOrFooterRenderer):Void
	{
		if (this._headerRendererProperties == null)
			return;
		var displayRenderer:DisplayObject = cast(renderer, DisplayObject);
		for(propertyName in Reflect.fields(this._headerRendererProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._headerRendererProperties.storage, propertyName);
			Reflect.setProperty(displayRenderer, propertyName, propertyValue);
		}
	}

	private function refreshOneFooterRendererStyles(renderer:IGroupedListHeaderOrFooterRenderer):Void
	{
		if (this._footerRendererProperties == null)
			return;
		var displayRenderer:DisplayObject = cast(renderer, DisplayObject);
		for(propertyName in Reflect.fields(this._footerRendererProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.getProperty(this._footerRendererProperties.storage, propertyName);
			Reflect.setProperty(displayRenderer, propertyName, propertyValue);
		}
	}

	private function refreshSelection():Void
	{
		var rendererCount:Int = this._activeItemRenderers.length;
		var renderer:IGroupedListItemRenderer;
		for(i in 0 ... rendererCount)
		{
			renderer = this._activeItemRenderers[i];
			renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
				renderer.itemIndex == this._selectedItemIndex;
		}
		if(this._activeFirstItemRenderers != null)
		{
			rendererCount = this._activeFirstItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				renderer = this._activeFirstItemRenderers[i];
				renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
					renderer.itemIndex == this._selectedItemIndex;
			}
		}
		if(this._activeLastItemRenderers != null)
		{
			rendererCount = this._activeLastItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				renderer = this._activeLastItemRenderers[i];
				renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
					renderer.itemIndex == this._selectedItemIndex;
			}
		}
		if(this._activeSingleItemRenderers != null)
		{
			rendererCount = this._activeSingleItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				renderer = this._activeSingleItemRenderers[i];
				renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
					renderer.itemIndex == this._selectedItemIndex;
			}
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
		var temp:Array<IGroupedListItemRenderer> = this._inactiveItemRenderers;
		this._inactiveItemRenderers = this._activeItemRenderers;
		this._activeItemRenderers = temp;
		if(this._activeItemRenderers.length > 0)
		{
			throw new IllegalOperationError("GroupedListDataViewPort: active item renderers should be empty.");
		}
		if(this._inactiveFirstItemRenderers != null)
		{
			temp = this._inactiveFirstItemRenderers;
			this._inactiveFirstItemRenderers = this._activeFirstItemRenderers;
			this._activeFirstItemRenderers = temp;
			if(this._activeFirstItemRenderers.length > 0)
			{
				throw new IllegalOperationError("GroupedListDataViewPort: active first renderers should be empty.");
			}
		}
		if(this._inactiveLastItemRenderers != null)
		{
			temp = this._inactiveLastItemRenderers;
			this._inactiveLastItemRenderers = this._activeLastItemRenderers;
			this._activeLastItemRenderers = temp;
			if(this._activeLastItemRenderers.length > 0)
			{
				throw new IllegalOperationError("GroupedListDataViewPort: active last renderers should be empty.");
			}
		}
		if(this._inactiveSingleItemRenderers != null)
		{
			temp = this._inactiveSingleItemRenderers;
			this._inactiveSingleItemRenderers = this._activeSingleItemRenderers;
			this._activeSingleItemRenderers = temp;
			if(this._activeSingleItemRenderers.length > 0)
			{
				throw new IllegalOperationError("GroupedListDataViewPort: active single renderers should be empty.");
			}
		}
		var temp2:Array<IGroupedListHeaderOrFooterRenderer> = this._inactiveHeaderRenderers;
		this._inactiveHeaderRenderers = this._activeHeaderRenderers;
		this._activeHeaderRenderers = temp2;
		if(this._activeHeaderRenderers.length > 0)
		{
			throw new IllegalOperationError("GroupedListDataViewPort: active header renderers should be empty.");
		}
		temp2 = this._inactiveFooterRenderers;
		this._inactiveFooterRenderers = this._activeFooterRenderers;
		this._activeFooterRenderers = temp2;
		if(this._activeFooterRenderers.length > 0)
		{
			throw new IllegalOperationError("GroupedListDataViewPort: active footer renderers should be empty.");
		}
		if(itemRendererTypeIsInvalid)
		{
			this.recoverInactiveRenderers();
			this.freeInactiveRenderers();
			if(this._typicalItemRenderer != null)
			{
				if(this._typicalItemIsInDataProvider)
				{
					this._itemRendererMap.remove(this._typicalItemRenderer.data);
					if(this._firstItemRendererMap != null)
					{
						this._firstItemRendererMap.remove(this._typicalItemRenderer.data);
					}
					if(this._singleItemRendererMap != null)
					{
						this._singleItemRendererMap.remove(this._typicalItemRenderer.data);
					}
					//can't be in last item renderers
				}
				this.destroyItemRenderer(this._typicalItemRenderer);
				this._typicalItemRenderer = null;
				this._typicalItemIsInDataProvider = false;
			}
		}

		this._headerIndices.splice(0, this._headerIndices.length);
		this._footerIndices.splice(0, this._footerIndices.length);

		var hasCustomFirstItemRenderer:Bool = this._firstItemRendererType != null || this._firstItemRendererFactory != null || this._firstItemRendererName != null;
		if(hasCustomFirstItemRenderer)
		{
			if(this._firstItemRendererMap == null)
			{
				this._firstItemRendererMap = new UnionMap();
			}
			if(this._inactiveFirstItemRenderers == null)
			{
				this._inactiveFirstItemRenderers = new Array();
			}
			if(this._activeFirstItemRenderers == null)
			{
				this._activeFirstItemRenderers = new Array();
			}
			if(this._unrenderedFirstItems == null)
			{
				this._unrenderedFirstItems = new Array();
			}
		}
		else
		{
			this._firstItemRendererMap = null;
			this._inactiveFirstItemRenderers = null;
			this._activeFirstItemRenderers = null;
			this._unrenderedFirstItems = null;
		}
		var hasCustomLastItemRenderer:Bool = this._lastItemRendererType != null || this._lastItemRendererFactory != null || this._lastItemRendererName != null;
		if(hasCustomLastItemRenderer)
		{
			if(this._lastItemRendererMap == null)
			{
				this._lastItemRendererMap = new UnionMap();
			}
			if(this._inactiveLastItemRenderers == null)
			{
				this._inactiveLastItemRenderers = new Array();
			}
			if(this._activeLastItemRenderers == null)
			{
				this._activeLastItemRenderers = new Array();
			}
			if(this._unrenderedLastItems == null)
			{
				this._unrenderedLastItems = new Array();
			}
		}
		else
		{
			this._lastItemRendererMap = null;
			this._inactiveLastItemRenderers = null;
			this._activeLastItemRenderers = null;
			this._unrenderedLastItems = null;
		}
		var hasCustomSingleItemRenderer:Bool = this._singleItemRendererType != null || this._singleItemRendererFactory != null || this._singleItemRendererName != null;
		if(hasCustomSingleItemRenderer)
		{
			if(this._singleItemRendererMap == null)
			{
				#if flash
				this._singleItemRendererMap = new UnionWeakMap();
				#else
				this._singleItemRendererMap = new UnionMap();
				#end
			}
			if(this._inactiveSingleItemRenderers == null)
			{
				this._inactiveSingleItemRenderers = new Array();
			}
			if(this._activeSingleItemRenderers == null)
			{
				this._activeSingleItemRenderers = new Array();
			}
			if(this._unrenderedSingleItems == null)
			{
				this._unrenderedSingleItems = new Array();
			}
		}
		else
		{
			this._singleItemRendererMap = null;
			this._inactiveSingleItemRenderers = null;
			this._activeSingleItemRenderers = null;
			this._unrenderedSingleItems = null;
		}
	}

	private function refreshRenderers():Void
	{
		if(this._typicalItemRenderer != null)
		{
			if(this._typicalItemIsInDataProvider)
			{
				var typicalItem:Dynamic = this._typicalItemRenderer.data;
				var inactiveIndex:Int;
				var activeRenderersCount:Int;
				if(safe_cast(this._itemRendererMap.get(typicalItem), IGroupedListItemRenderer) == this._typicalItemRenderer)
				{
					//this renderer is already is use by the typical item, so we
					//don't want to allow it to be used by other items.
					inactiveIndex = this._inactiveItemRenderers.indexOf(this._typicalItemRenderer);
					if(inactiveIndex >= 0)
					{
						this._inactiveItemRenderers.splice(inactiveIndex, 1);
					}
					//if refreshLayoutTypicalItem() was called, it will have already
					//added the typical item renderer to the active renderers. if
					//not, we need to do it here.
					activeRenderersCount = this._activeItemRenderers.length;
					if(activeRenderersCount == 0)
					{
						this._activeItemRenderers[activeRenderersCount] = this._typicalItemRenderer;
					}
				}
				else if(this._firstItemRendererMap != null && safe_cast(this._firstItemRendererMap.get(typicalItem), IGroupedListItemRenderer) == this._typicalItemRenderer)
				{
					inactiveIndex = this._inactiveFirstItemRenderers.indexOf(this._typicalItemRenderer);
					if(inactiveIndex >= 0)
					{
						this._inactiveFirstItemRenderers.splice(inactiveIndex, 1);
					}
					activeRenderersCount = this._activeFirstItemRenderers.length;
					if(activeRenderersCount == 0)
					{
						this._activeFirstItemRenderers[activeRenderersCount] = this._typicalItemRenderer;
					}
				}
				else if(this._singleItemRendererMap != null && safe_cast(this._singleItemRendererMap.get(typicalItem), IGroupedListItemRenderer) == this._typicalItemRenderer)
				{
					inactiveIndex = this._inactiveSingleItemRenderers.indexOf(this._typicalItemRenderer);
					if(inactiveIndex >= 0)
					{
						this._inactiveSingleItemRenderers.splice(inactiveIndex, 1);
					}
					activeRenderersCount = this._activeSingleItemRenderers.length;
					if(activeRenderersCount == 0)
					{
						this._activeSingleItemRenderers[activeRenderersCount] = this._typicalItemRenderer;
					}
				}
				//no else... can't be in last item renderers
			}
			//we need to set the typical item renderer's properties here
			//because they may be needed for proper measurement in a virtual
			//layout.
			this.refreshOneItemRendererStyles(this._typicalItemRenderer);
		}

		this.findUnrenderedData();
		this.recoverInactiveRenderers();
		this.renderUnrenderedData();
		this.freeInactiveRenderers();
		this._updateForDataReset = false;
	}

	private function findUnrenderedData():Void
	{
		var groupCount:Int = this._dataProvider != null ? this._dataProvider.getLength() : 0;
		var totalLayoutCount:Int = 0;
		var totalHeaderCount:Int = 0;
		var totalFooterCount:Int = 0;
		var totalSingleItemCount:Int = 0;
		var averageItemsPerGroup:Int = 0;
		var group:Dynamic;
		var currentItemCount:Int;
		for(i in 0 ... groupCount)
		{
			group = this._dataProvider.getItemAt(i);
			if(this._owner.groupToHeaderData(group) != null)
			{
				this._headerIndices.push(totalLayoutCount);
				totalLayoutCount++;
				totalHeaderCount++;
			}
			currentItemCount = this._dataProvider.getLength(i);
			totalLayoutCount += currentItemCount;
			averageItemsPerGroup += currentItemCount;
			if(currentItemCount == 0)
			{
				totalSingleItemCount++;
			}
			if(this._owner.groupToFooterData(group) != null)
			{
				this._footerIndices.push(totalLayoutCount);
				totalLayoutCount++;
				totalFooterCount++;
			}
		}
		this._layoutItems.splice(totalLayoutCount, this._layoutItems.length - totalLayoutCount);
		var virtualLayout:IVirtualLayout = cast(this._layout, IVirtualLayout);
		var useVirtualLayout:Bool = virtualLayout != null && virtualLayout.useVirtualLayout;
		if(useVirtualLayout)
		{
			virtualLayout.measureViewPort(totalLayoutCount, this._viewPortBounds, HELPER_POINT);
			var viewPortWidth:Float = HELPER_POINT.x;
			var viewPortHeight:Float = HELPER_POINT.y;
			virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, viewPortWidth, viewPortHeight, totalLayoutCount, HELPER_VECTOR);

			averageItemsPerGroup = Std.int(averageItemsPerGroup / groupCount);

			if(this._typicalItemRenderer != null)
			{
				var minimumTypicalItemEdge:Float = this._typicalItemRenderer.height;
				if(this._typicalItemRenderer.width < minimumTypicalItemEdge)
				{
					minimumTypicalItemEdge = this._typicalItemRenderer.width;
				}

				var maximumViewPortEdge:Float = viewPortWidth;
				if(viewPortHeight > viewPortWidth)
				{
					maximumViewPortEdge = viewPortHeight;
				}
				this._minimumFirstAndLastItemCount = this._minimumSingleItemCount = this._minimumHeaderCount = this._minimumFooterCount = Math.ceil(maximumViewPortEdge / (minimumTypicalItemEdge * averageItemsPerGroup));
				this._minimumHeaderCount = Std.int(Math.min(this._minimumHeaderCount, totalHeaderCount));
				this._minimumFooterCount = Std.int(Math.min(this._minimumFooterCount, totalFooterCount));
				this._minimumSingleItemCount = Std.int(Math.min(this._minimumSingleItemCount, totalSingleItemCount));

				//assumes that zero headers/footers might be visible
				this._minimumItemCount = Math.ceil(maximumViewPortEdge / minimumTypicalItemEdge) + 1;
			}
			else
			{
				this._minimumFirstAndLastItemCount = 1;
				this._minimumHeaderCount = 1;
				this._minimumFooterCount = 1;
				this._minimumSingleItemCount = 1;
				this._minimumItemCount = 1;
			}
		}
		var hasCustomFirstItemRenderer:Bool = this._firstItemRendererType != null || this._firstItemRendererFactory != null || this._firstItemRendererName != null;
		var hasCustomLastItemRenderer:Bool = this._lastItemRendererType != null || this._lastItemRendererFactory != null || this._lastItemRendererName != null;
		var hasCustomSingleItemRenderer:Bool = this._singleItemRendererType != null || this._singleItemRendererFactory != null || this._singleItemRendererName != null;
		var currentIndex:Int = 0;
		var unrenderedHeadersLastIndex:Int = this._unrenderedHeaders.length;
		var unrenderedFootersLastIndex:Int = this._unrenderedFooters.length;
		var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer;
		for(i in 0 ... groupCount)
		{
			group = this._dataProvider.getItemAt(i);
			var header:Dynamic = this._owner.groupToHeaderData(group);
			if(header != null)
			{
				//the end index is included in the visible items
				if(useVirtualLayout && HELPER_VECTOR.indexOf(currentIndex) < 0)
				{
					this._layoutItems[currentIndex] = null;
				}
				else
				{
					headerOrFooterRenderer = safe_cast(this._headerRendererMap.get(header), IGroupedListHeaderOrFooterRenderer);
					if(headerOrFooterRenderer != null)
					{
						headerOrFooterRenderer.layoutIndex = currentIndex;
						headerOrFooterRenderer.groupIndex = i;
						if(this._updateForDataReset)
						{
							//see comments in findRendererForItem()
							headerOrFooterRenderer.data = null;
							headerOrFooterRenderer.data = header;
						}
						this._activeHeaderRenderers.push(headerOrFooterRenderer);
						this._inactiveHeaderRenderers.splice(this._inactiveHeaderRenderers.indexOf(headerOrFooterRenderer), 1);
						headerOrFooterRenderer.visible = true;
						this._layoutItems[currentIndex] = cast(headerOrFooterRenderer, DisplayObject);
					}
					else
					{
						this._unrenderedHeaders[unrenderedHeadersLastIndex] = i;
						unrenderedHeadersLastIndex++;
						this._unrenderedHeaders[unrenderedHeadersLastIndex] = currentIndex;
						unrenderedHeadersLastIndex++;
					}
				}
				currentIndex++;
			}
			currentItemCount = this._dataProvider.getLength(i);
			var currentGroupLastIndex:Int = currentItemCount - 1;
			for(j in 0 ... currentItemCount)
			{
				if(useVirtualLayout && HELPER_VECTOR.indexOf(currentIndex) < 0)
				{
					this._layoutItems[currentIndex] = null;
				}
				else
				{
					var item:Dynamic = this._dataProvider.getItemAt([i, j]);
					if(hasCustomSingleItemRenderer && j == 0 && j == currentGroupLastIndex)
					{
						this.findRendererForItem(item, i, j, currentIndex, this._singleItemRendererMap, this._inactiveSingleItemRenderers,
							this._activeSingleItemRenderers, this._unrenderedSingleItems);
					}
					else if(hasCustomFirstItemRenderer && j == 0)
					{
						this.findRendererForItem(item, i, j, currentIndex, this._firstItemRendererMap, this._inactiveFirstItemRenderers,
							this._activeFirstItemRenderers, this._unrenderedFirstItems);
					}
					else if(hasCustomLastItemRenderer && j == currentGroupLastIndex)
					{
						this.findRendererForItem(item, i, j, currentIndex, this._lastItemRendererMap, this._inactiveLastItemRenderers,
							this._activeLastItemRenderers, this._unrenderedLastItems);
					}
					else
					{
						this.findRendererForItem(item, i, j, currentIndex, this._itemRendererMap, this._inactiveItemRenderers,
							this._activeItemRenderers, this._unrenderedItems);
					}
				}
				currentIndex++;
			}
			var footer:Dynamic = this._owner.groupToFooterData(group);
			if(footer != null)
			{
				if(useVirtualLayout && HELPER_VECTOR.indexOf(currentIndex) < 0)
				{
					this._layoutItems[currentIndex] = null;
				}
				else
				{
					headerOrFooterRenderer = this._footerRendererMap.get(footer);
					if(headerOrFooterRenderer != null)
					{
						headerOrFooterRenderer.groupIndex = i;
						headerOrFooterRenderer.layoutIndex = currentIndex;
						if(this._updateForDataReset)
						{
							//see comments in findRendererForItem()
							headerOrFooterRenderer.data = null;
							headerOrFooterRenderer.data = footer;
						}
						this._activeFooterRenderers.push(headerOrFooterRenderer);
						this._inactiveFooterRenderers.splice(this._inactiveFooterRenderers.indexOf(headerOrFooterRenderer), 1);
						headerOrFooterRenderer.visible = true;
						this._layoutItems[currentIndex] = cast(headerOrFooterRenderer, DisplayObject);
					}
					else
					{
						this._unrenderedFooters[unrenderedFootersLastIndex] = i;
						unrenderedFootersLastIndex++;
						this._unrenderedFooters[unrenderedFootersLastIndex] = currentIndex;
						unrenderedFootersLastIndex++;
					}
				}
				currentIndex++;
			}
		}
		//update the typical item renderer's visibility
		if(this._typicalItemRenderer != null)
		{
			if(useVirtualLayout && this._typicalItemIsInDataProvider)
			{
				var index:Int = HELPER_VECTOR.indexOf(this._typicalItemRenderer.layoutIndex);
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

	private function findRendererForItem(item:Dynamic, groupIndex:Int, itemIndex:Int, layoutIndex:Int,
		rendererMap:UnionMap<IGroupedListItemRenderer>, inactiveRenderers:Array<IGroupedListItemRenderer>,
		activeRenderers:Array<IGroupedListItemRenderer>, unrenderedItems:Array<Int>):Void
	{
		var itemRenderer:IGroupedListItemRenderer = rendererMap.get(item);
		if(itemRenderer != null)
		{
			//the indices may have changed if data was added or removed
			itemRenderer.groupIndex = groupIndex;
			itemRenderer.itemIndex = itemIndex;
			itemRenderer.layoutIndex = layoutIndex;
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
				itemRenderer.data = null;
				itemRenderer.data = item;
			}

			//the typical item renderer is a special case, and we will
			//have already put it into the active renderers, so we don't
			//want to do it again!
			if(this._typicalItemRenderer != itemRenderer)
			{
				activeRenderers.push(itemRenderer);
				var inactiveIndex:Int = inactiveRenderers.indexOf(itemRenderer);
				if(inactiveIndex >= 0)
				{
					inactiveRenderers.splice(inactiveIndex, 1);
				}
				else
				{
					throw new IllegalOperationError("GroupedListDataViewPort: renderer map contains bad data.");
				}
			}
			itemRenderer.visible = true;
			this._layoutItems[layoutIndex] = cast(itemRenderer, DisplayObject);
		}
		else
		{
			unrenderedItems.push(groupIndex);
			unrenderedItems.push(itemIndex);
			unrenderedItems.push(layoutIndex);
		}
	}

	private function renderUnrenderedData():Void
	{
		var rendererCount:Int = this._unrenderedItems.length;
		//for(var i:Int = 0; i < rendererCount; i += 3)
		var i:Int = 0;
		var groupIndex:Int;
		var itemIndex:Int;
		var layoutIndex:Int;
		var item:Dynamic;
		var itemRenderer:IGroupedListItemRenderer;
		while(i < rendererCount)
		{
			groupIndex = this._unrenderedItems.shift();
			itemIndex = this._unrenderedItems.shift();
			layoutIndex = this._unrenderedItems.shift();
			item = this._dataProvider.getItemAt([groupIndex, itemIndex]);
			itemRenderer = this.createItemRenderer(this._inactiveItemRenderers,
				this._activeItemRenderers, this._itemRendererMap, this._itemRendererType, this._itemRendererFactory,
				this._itemRendererName, item, groupIndex, itemIndex, layoutIndex, true, false);
			this._layoutItems[layoutIndex] = cast(itemRenderer, DisplayObject);
			
			i += 3;
		}

		var factory:Void->IGroupedListItemRenderer;
		var type:Class<Dynamic>;
		if(this._unrenderedFirstItems != null)
		{
			rendererCount = this._unrenderedFirstItems.length;
			//for(i = 0; i < rendererCount; i += 3)
			i = 0;
			while(i < rendererCount)
			{
				groupIndex = this._unrenderedFirstItems.shift();
				itemIndex = this._unrenderedFirstItems.shift();
				layoutIndex = this._unrenderedFirstItems.shift();
				item = this._dataProvider.getItemAt([groupIndex, itemIndex]);
				type = this._firstItemRendererType != null ? this._firstItemRendererType : this._itemRendererType;
				factory = this._firstItemRendererFactory != null ? this._firstItemRendererFactory : this._itemRendererFactory;
				var name:String = this._firstItemRendererName != null ? this._firstItemRendererName : this._itemRendererName;
				itemRenderer = this.createItemRenderer(this._inactiveFirstItemRenderers, this._activeFirstItemRenderers,
					this._firstItemRendererMap, type, factory, name, item, groupIndex, itemIndex, layoutIndex, true, false);
				this._layoutItems[layoutIndex] = cast(itemRenderer, DisplayObject);
				
				i += 3;
			}
		}

		if(this._unrenderedLastItems != null)
		{
			rendererCount = this._unrenderedLastItems.length;
			//for(i = 0; i < rendererCount; i += 3)
			i = 0;
			while(i < rendererCount)
			{
				groupIndex = this._unrenderedLastItems.shift();
				itemIndex = this._unrenderedLastItems.shift();
				layoutIndex = this._unrenderedLastItems.shift();
				item = this._dataProvider.getItemAt([groupIndex, itemIndex]);
				type = this._lastItemRendererType != null ? this._lastItemRendererType : this._itemRendererType;
				factory = this._lastItemRendererFactory != null ? this._lastItemRendererFactory : this._itemRendererFactory;
				name = this._lastItemRendererName != null ? this._lastItemRendererName : this._itemRendererName;
				itemRenderer = this.createItemRenderer(this._inactiveLastItemRenderers, this._activeLastItemRenderers,
					this._lastItemRendererMap, type,  factory,  name, item, groupIndex, itemIndex, layoutIndex, true, false);
				this._layoutItems[layoutIndex] = cast(itemRenderer, DisplayObject);
				
				i += 3;
			}
		}

		if(this._unrenderedSingleItems != null)
		{
			rendererCount = this._unrenderedSingleItems.length;
			//for(i = 0; i < rendererCount; i += 3)
			i = 0;
			while(i < rendererCount)
			{
				groupIndex = this._unrenderedSingleItems.shift();
				itemIndex = this._unrenderedSingleItems.shift();
				layoutIndex = this._unrenderedSingleItems.shift();
				item = this._dataProvider.getItemAt([groupIndex, itemIndex]);
				type = this._singleItemRendererType != null ? this._singleItemRendererType : this._itemRendererType;
				factory = this._singleItemRendererFactory != null ? this._singleItemRendererFactory : this._itemRendererFactory;
				name = this._singleItemRendererName != null ? this._singleItemRendererName : this._itemRendererName;
				itemRenderer = this.createItemRenderer(this._inactiveSingleItemRenderers, this._activeSingleItemRenderers,
					this._singleItemRendererMap, type,  factory,  name, item, groupIndex, itemIndex, layoutIndex, true, false);
				this._layoutItems[layoutIndex] = cast(itemRenderer, DisplayObject);
				
				i += 3;
			}
		}

		rendererCount = this._unrenderedHeaders.length;
		i = 0;
		var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer;
		//for(i = 0; i < rendererCount; i += 2)
		while(i < rendererCount)
		{
			groupIndex = this._unrenderedHeaders.shift();
			layoutIndex = this._unrenderedHeaders.shift();
			item = this._dataProvider.getItemAt(groupIndex);
			item = this._owner.groupToHeaderData(item);
			headerOrFooterRenderer = this.createHeaderRenderer(item, groupIndex, layoutIndex, false);
			this._layoutItems[layoutIndex] = cast(headerOrFooterRenderer, DisplayObject);
			
			i += 2;
		}

		rendererCount = this._unrenderedFooters.length;
		//for(i = 0; i < rendererCount; i += 2)
		i = 0;
		while(i < rendererCount)
		{
			groupIndex = this._unrenderedFooters.shift();
			layoutIndex = this._unrenderedFooters.shift();
			item = this._dataProvider.getItemAt(groupIndex);
			item = this._owner.groupToFooterData(item);
			headerOrFooterRenderer = this.createFooterRenderer(item, groupIndex, layoutIndex, false);
			this._layoutItems[layoutIndex] = cast(headerOrFooterRenderer, DisplayObject);
			
			i += 2;
		}
	}

	private function recoverInactiveRenderers():Void
	{
		var rendererCount:Int = this._inactiveItemRenderers.length;
		var itemRenderer:IGroupedListItemRenderer;
		for(i in 0 ... rendererCount)
		{
			itemRenderer = this._inactiveItemRenderers[i];
			if(itemRenderer == null || itemRenderer.groupIndex < 0)
			{
				continue;
			}
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
			this._itemRendererMap.remove(itemRenderer.data);
		}

		if(this._inactiveFirstItemRenderers != null)
		{
			rendererCount = this._inactiveFirstItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				itemRenderer = this._inactiveFirstItemRenderers[i];
				if(itemRenderer == null)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
				this._firstItemRendererMap.remove(itemRenderer.data);
			}
		}

		if(this._inactiveLastItemRenderers != null)
		{
			rendererCount = this._inactiveLastItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				itemRenderer = this._inactiveLastItemRenderers[i];
				if(itemRenderer == null)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
				this._lastItemRendererMap.remove(itemRenderer.data);
			}
		}

		if(this._inactiveSingleItemRenderers != null)
		{
			rendererCount = this._inactiveSingleItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				itemRenderer = this._inactiveSingleItemRenderers[i];
				if(itemRenderer == null)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
				this._singleItemRendererMap.remove(itemRenderer.data);
			}
		}

		rendererCount = this._inactiveHeaderRenderers.length;
		var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer;
		for(i in 0 ... rendererCount)
		{
			headerOrFooterRenderer = this._inactiveHeaderRenderers[i];
			if(headerOrFooterRenderer == null)
			{
				continue;
			}
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, headerOrFooterRenderer);
			this._headerRendererMap.remove(headerOrFooterRenderer.data);
		}

		rendererCount = this._inactiveFooterRenderers.length;
		for(i in 0 ... rendererCount)
		{
			headerOrFooterRenderer = this._inactiveFooterRenderers[i];
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, headerOrFooterRenderer);
			this._footerRendererMap.remove(headerOrFooterRenderer.data);
		}
	}

	private function freeInactiveRenderers():Void
	{
		//we may keep around some extra renderers to avoid too much
		//allocation and garbage collection. they'll be hidden.
		var keepCount:Int = Std.int(Math.min(this._minimumItemCount - this._activeItemRenderers.length, this._inactiveItemRenderers.length));
		var itemRenderer:IGroupedListItemRenderer;
		for(i in 0 ... keepCount)
		{
			itemRenderer = this._inactiveItemRenderers.shift();
			itemRenderer.data = null;
			itemRenderer.groupIndex = -1;
			itemRenderer.itemIndex = -1;
			itemRenderer.layoutIndex = -1;
			itemRenderer.visible = false;
			this._activeItemRenderers.push(itemRenderer);
		}
		var rendererCount:Int = this._inactiveItemRenderers.length;
		for(i in 0 ... rendererCount)
		{
			itemRenderer = this._inactiveItemRenderers.shift();
			if(itemRenderer == null)
			{
				continue;
			}
			this.destroyItemRenderer(itemRenderer);
		}

		if(this._activeFirstItemRenderers != null)
		{
			keepCount = Std.int(Math.min(this._minimumFirstAndLastItemCount - this._activeFirstItemRenderers.length, this._inactiveFirstItemRenderers.length));
			for(i in 0 ... keepCount)
			{
				itemRenderer = this._inactiveFirstItemRenderers.shift();
				itemRenderer.data = null;
				itemRenderer.groupIndex = -1;
				itemRenderer.itemIndex = -1;
				itemRenderer.layoutIndex = -1;
				itemRenderer.visible = false;
				this._activeFirstItemRenderers.push(itemRenderer);
			}
			rendererCount = this._inactiveFirstItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				itemRenderer = this._inactiveFirstItemRenderers.shift();
				if(itemRenderer == null)
				{
					continue;
				}
				this.destroyItemRenderer(itemRenderer);
			}
		}

		if(this._activeLastItemRenderers != null)
		{
			keepCount = Std.int(Math.min(this._minimumFirstAndLastItemCount - this._activeLastItemRenderers.length, this._inactiveLastItemRenderers.length));
			for(i in 0 ... keepCount)
			{
				itemRenderer = this._inactiveLastItemRenderers.shift();
				itemRenderer.data = null;
				itemRenderer.groupIndex = -1;
				itemRenderer.itemIndex = -1;
				itemRenderer.layoutIndex = -1;
				itemRenderer.visible = false;
				this._activeLastItemRenderers.push(itemRenderer);
			}
			rendererCount = this._inactiveLastItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				itemRenderer = this._inactiveLastItemRenderers.shift();
				if(itemRenderer == null)
				{
					continue;
				}
				this.destroyItemRenderer(itemRenderer);
			}
		}

		if(this._activeSingleItemRenderers != null)
		{
			keepCount = Std.int(Math.min(this._minimumSingleItemCount - this._activeSingleItemRenderers.length, this._inactiveSingleItemRenderers.length));
			for(i in 0 ... keepCount)
			{
				itemRenderer = this._inactiveSingleItemRenderers.shift();
				itemRenderer.data = null;
				itemRenderer.groupIndex = -1;
				itemRenderer.itemIndex = -1;
				itemRenderer.layoutIndex = -1;
				itemRenderer.visible = false;
				this._activeSingleItemRenderers.push(itemRenderer);
			}
			rendererCount = this._inactiveSingleItemRenderers.length;
			for(i in 0 ... rendererCount)
			{
				itemRenderer = this._inactiveSingleItemRenderers.shift();
				if(itemRenderer == null)
				{
					continue;
				}
				this.destroyItemRenderer(itemRenderer);
			}
		}

		keepCount = Std.int(Math.min(this._minimumHeaderCount - this._activeHeaderRenderers.length, this._inactiveHeaderRenderers.length));
		var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer;
		for(i in 0 ... keepCount)
		{
			headerOrFooterRenderer = this._inactiveHeaderRenderers.shift();
			headerOrFooterRenderer.visible = false;
			headerOrFooterRenderer.data = null;
			headerOrFooterRenderer.groupIndex = -1;
			headerOrFooterRenderer.layoutIndex = -1;
			this._activeHeaderRenderers.push(headerOrFooterRenderer);
		}
		rendererCount = this._inactiveHeaderRenderers.length;
		for(i in 0 ... rendererCount)
		{
			headerOrFooterRenderer = this._inactiveHeaderRenderers.shift();
			if(headerOrFooterRenderer == null)
			{
				continue;
			}
			this.destroyHeaderRenderer(headerOrFooterRenderer);
		}

		keepCount = Std.int(Math.min(this._minimumFooterCount - this._activeFooterRenderers.length, this._inactiveFooterRenderers.length));
		for(i in 0 ... keepCount)
		{
			headerOrFooterRenderer = this._inactiveFooterRenderers.shift();
			headerOrFooterRenderer.visible = false;
			headerOrFooterRenderer.data = null;
			headerOrFooterRenderer.groupIndex = -1;
			headerOrFooterRenderer.layoutIndex = -1;
			this._activeFooterRenderers.push(headerOrFooterRenderer);
		}
		rendererCount = this._inactiveFooterRenderers.length;
		for(i in 0 ... rendererCount)
		{
			headerOrFooterRenderer = this._inactiveFooterRenderers.shift();
			if(headerOrFooterRenderer == null)
			{
				continue;
			}
			this.destroyFooterRenderer(headerOrFooterRenderer);
		}
	}

	private function createItemRenderer(inactiveRenderers:Array<IGroupedListItemRenderer>,
		activeRenderers:Array<IGroupedListItemRenderer>, rendererMap:UnionMap<IGroupedListItemRenderer>,
		type:Class<Dynamic>, factory:Void->IGroupedListItemRenderer, name:String, item:Dynamic, groupIndex:Int, itemIndex:Int,
		layoutIndex:Int, useCache:Bool, isTemporary:Bool):IGroupedListItemRenderer
	{
		var renderer:IGroupedListItemRenderer;
		if(!useCache || isTemporary || inactiveRenderers.length == 0)
		{
			if(factory != null)
			{
				renderer = factory();
			}
			else
			{
				renderer = Type.createInstance(type, []);
			}
			var uiRenderer:IFeathersControl = cast(renderer, IFeathersControl);
			if(name != null && name.length > 0)
			{
				uiRenderer.styleNameList.add(name);
			}
			this.addChild(cast(renderer, DisplayObject));
		}
		else
		{
			renderer = inactiveRenderers.shift();
		}
		renderer.data = item;
		renderer.groupIndex = groupIndex;
		renderer.itemIndex = itemIndex;
		renderer.layoutIndex = layoutIndex;
		renderer.owner = this._owner;
		renderer.visible = true;

		if(!isTemporary)
		{
			rendererMap.set(item, renderer);
			activeRenderers.push(renderer);
			renderer.addEventListener(Event.CHANGE, renderer_changeHandler);
			renderer.addEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, renderer);
		}

		return renderer;
	}

	private function createHeaderRenderer(header:Dynamic, groupIndex:Int, layoutIndex:Int, isTemporary:Bool = false):IGroupedListHeaderOrFooterRenderer
	{
		var renderer:IGroupedListHeaderOrFooterRenderer;
		if(isTemporary || this._inactiveHeaderRenderers.length == 0)
		{
			if(this._headerRendererFactory != null)
			{
				renderer = this._headerRendererFactory();
			}
			else
			{
				renderer = Type.createInstance(this._headerRendererType, []);
			}
			var uiRenderer:IFeathersControl = cast(renderer, IFeathersControl);
			if(this._headerRendererName != null && this._headerRendererName.length > 0)
			{
				uiRenderer.styleNameList.add(this._headerRendererName);
			}
			this.addChild(cast(renderer, DisplayObject));
		}
		else
		{
			renderer = this._inactiveHeaderRenderers.shift();
		}
		renderer.data = header;
		renderer.groupIndex = groupIndex;
		renderer.layoutIndex = layoutIndex;
		renderer.owner = this._owner;
		renderer.visible = true;

		if(!isTemporary)
		{
			this._headerRendererMap.set(header, renderer);
			this._activeHeaderRenderers.push(renderer);
			renderer.addEventListener(FeathersEventType.RESIZE, headerOrFooterRenderer_resizeHandler);
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, renderer);
		}

		return renderer;
	}

	private function createFooterRenderer(footer:Dynamic, groupIndex:Int, layoutIndex:Int, isTemporary:Bool = false):IGroupedListHeaderOrFooterRenderer
	{
		var renderer:IGroupedListHeaderOrFooterRenderer;
		if(isTemporary || this._inactiveFooterRenderers.length == 0)
		{
			if(this._footerRendererFactory != null)
			{
				renderer = this._footerRendererFactory();
			}
			else
			{
				renderer = Type.createInstance(this._footerRendererType, []);
			}
			var uiRenderer:IFeathersControl = cast(renderer, IFeathersControl);
			if(this._footerRendererName != null && this._footerRendererName.length > 0)
			{
				uiRenderer.styleNameList.add(this._footerRendererName);
			}
			this.addChild(cast(renderer, DisplayObject));
		}
		else
		{
			renderer = this._inactiveFooterRenderers.shift();
		}
		renderer.data = footer;
		renderer.groupIndex = groupIndex;
		renderer.layoutIndex = layoutIndex;
		renderer.owner = this._owner;
		renderer.visible = true;

		if(!isTemporary)
		{
			this._footerRendererMap.set(footer, renderer);
			this._activeFooterRenderers.push(renderer);
			renderer.addEventListener(FeathersEventType.RESIZE, headerOrFooterRenderer_resizeHandler);
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, renderer);
		}

		return renderer;
	}

	private function destroyItemRenderer(renderer:IGroupedListItemRenderer):Void
	{
		renderer.removeEventListener(Event.CHANGE, renderer_changeHandler);
		renderer.removeEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
		renderer.owner = null;
		renderer.data = null;
		this.removeChild(cast(renderer, DisplayObject), true);
	}

	private function destroyHeaderRenderer(renderer:IGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.removeEventListener(FeathersEventType.RESIZE, headerOrFooterRenderer_resizeHandler);
		renderer.owner = null;
		renderer.data = null;
		this.removeChild(cast(renderer, DisplayObject), true);
	}

	private function destroyFooterRenderer(renderer:IGroupedListHeaderOrFooterRenderer):Void
	{
		renderer.removeEventListener(FeathersEventType.RESIZE, headerOrFooterRenderer_resizeHandler);
		renderer.owner = null;
		renderer.data = null;
		this.removeChild(cast(renderer, DisplayObject), true);
	}

	private function groupToHeaderDisplayIndex(groupIndex:Int):Int
	{
		var group:Dynamic = this._dataProvider.getItemAt(groupIndex);
		var header:Dynamic = this._owner.groupToHeaderData(group);
		if(!header)
		{
			return -1;
		}
		var displayIndex:Int = 0;
		var groupCount:Int = this._dataProvider.getLength();
		for(i in 0 ... groupCount)
		{
			group = this._dataProvider.getItemAt(i);
			header = this._owner.groupToHeaderData(group);
			if(header)
			{
				if(groupIndex == i)
				{
					return displayIndex;
				}
				displayIndex++;
			}
			var groupLength:Int = this._dataProvider.getLength(i);
			for(j in 0 ... groupLength)
			{
				displayIndex++;
			}
			var footer:Dynamic = this._owner.groupToFooterData(group);
			if(footer)
			{
				displayIndex++;
			}
		}
		return -1;
	}

	private function groupToFooterDisplayIndex(groupIndex:Int):Int
	{
		var group:Dynamic = this._dataProvider.getItemAt(groupIndex);
		var footer:Dynamic = this._owner.groupToFooterData(group);
		if(!footer)
		{
			return -1;
		}
		var displayIndex:Int = 0;
		var groupCount:Int = this._dataProvider.getLength();
		for(i in 0 ... groupCount)
		{
			group = this._dataProvider.getItemAt(i);
			var header:Dynamic = this._owner.groupToHeaderData(group);
			if(header)
			{
				displayIndex++;
			}
			var groupLength:Int = this._dataProvider.getLength(i);
			for(j in 0 ... groupLength)
			{
				displayIndex++;
			}
			footer = this._owner.groupToFooterData(group);
			if(footer)
			{
				if(groupIndex == i)
				{
					return displayIndex;
				}
				displayIndex++;
			}
		}
		return -1;
	}

	private function locationToDisplayIndex(groupIndex:Int, itemIndex:Int):Int
	{
		var displayIndex:Int = 0;
		var groupCount:Int = this._dataProvider.getLength();
		for(i in 0 ... groupCount)
		{
			var group:Dynamic = this._dataProvider.getItemAt(i);
			var header:Dynamic = this._owner.groupToHeaderData(group);
			if(header)
			{
				displayIndex++;
			}
			var groupLength:Int = this._dataProvider.getLength(i);
			for(j in 0 ... groupLength)
			{
				if(groupIndex == i && itemIndex == j)
				{
					return displayIndex;
				}
				displayIndex++;
			}
			var footer:Dynamic = this._owner.groupToFooterData(group);
			if(footer)
			{
				displayIndex++;
			}
		}
		return -1;
	}

	private function getMappedItemRenderer(item:Dynamic):IGroupedListItemRenderer
	{
		var renderer:IGroupedListItemRenderer = item != null ? this._itemRendererMap.get(item) : null;
		if(renderer != null)
		{
			return renderer;
		}
		if(this._firstItemRendererMap != null)
		{
			renderer = this._firstItemRendererMap.get(item);
			if(renderer != null)
			{
				return renderer;
			}
		}
		if(this._singleItemRendererMap != null)
		{
			renderer = this._singleItemRendererMap.get(item);
			if(renderer != null)
			{
				return renderer;
			}
		}
		if(this._lastItemRendererMap != null)
		{
			renderer = this._lastItemRendererMap.get(item);
			if(renderer != null)
			{
				return renderer;
			}
		}
		return null;
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

	private function dataProvider_addItemHandler(event:Event, indices:Array<Int>):Void
	{
		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		var groupIndex:Int = indices[0];
		if(indices.length > 1) //adding an item
		{
			var itemIndex:Int = indices[1];
			var itemDisplayIndex:Int = this.locationToDisplayIndex(groupIndex, itemIndex);
			layout.addToVariableVirtualCacheAtIndex(itemDisplayIndex);
		}
		else //adding a whole group
		{
			var headerDisplayIndex:Int = this.groupToHeaderDisplayIndex(groupIndex);
			if(headerDisplayIndex >= 0)
			{
				layout.addToVariableVirtualCacheAtIndex(headerDisplayIndex);
			}
			var groupLength:Int = this._dataProvider.getLength(groupIndex);
			if(groupLength > 0)
			{
				var displayIndex:Int = headerDisplayIndex;
				if(displayIndex < 0)
				{
					displayIndex = this.locationToDisplayIndex(groupIndex, 0);
				}
				groupLength += displayIndex;
				for(i in displayIndex ... groupLength)
				{
					layout.addToVariableVirtualCacheAtIndex(displayIndex);
				}
			}
			var footerDisplayIndex:Int = this.groupToFooterDisplayIndex(groupIndex);
			if(footerDisplayIndex >= 0)
			{
				layout.addToVariableVirtualCacheAtIndex(footerDisplayIndex);
			}
		}
	}

	private function dataProvider_removeItemHandler(event:Event, indices:Array<Int>):Void
	{
		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		var groupIndex:Int = indices[0];
		if(indices.length > 1) //removing an item
		{
			var itemIndex:Int = indices[1];
			var displayIndex:Int = this.locationToDisplayIndex(groupIndex, itemIndex);
			layout.removeFromVariableVirtualCacheAtIndex(displayIndex);
		}
		else //removing a whole group
		{
			//TODO: figure out the length of the previous group so that we
			//don't need to reset the whole cache
			layout.resetVariableVirtualCache();
		}
	}

	private function dataProvider_replaceItemHandler(event:Event, indices:Array<Int>):Void
	{
		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		var groupIndex:Int = indices[0];
		if(indices.length > 1) //replacing an item
		{
			var itemIndex:Int = indices[1];
			var displayIndex:Int = this.locationToDisplayIndex(groupIndex, itemIndex);
			layout.resetVariableVirtualCacheAtIndex(displayIndex);
		}
		else //replacing a whole group
		{
			//TODO: figure out the length of the previous group so that we
			//don't need to reset the whole cache
			layout.resetVariableVirtualCache();
		}
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

	private function dataProvider_updateItemHandler(event:Event, indices:Array<Int>):Void
	{
		var groupIndex:Int = indices[0];
		var item:Dynamic;
		var itemRenderer:IGroupedListItemRenderer;
		if(indices.length > 1) //updating a single item
		{
			var itemIndex:Int = indices[1];
			item = this._dataProvider.getItemAt([groupIndex, itemIndex]);
			itemRenderer = this.getMappedItemRenderer(item);
			if(itemRenderer != null)
			{
				itemRenderer.data = null;
				itemRenderer.data = item;
			}
		}
		else //updating a whole group
		{
			var groupLength:Int = this._dataProvider.getLength(groupIndex);
			for(i in 0 ... groupLength)
			{
				item = this._dataProvider.getItemAt([groupIndex, i]);
				if(item)
				{
					itemRenderer = this.getMappedItemRenderer(item);
					if(itemRenderer != null)
					{
						itemRenderer.data = null;
						itemRenderer.data = item;
					}
				}
			}
			var group:Dynamic = this._dataProvider.getItemAt(groupIndex);
			item = this._owner.groupToHeaderData(group);
			var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer;
			if(item)
			{
				headerOrFooterRenderer = this._headerRendererMap.get(item);
				if(headerOrFooterRenderer != null)
				{
					headerOrFooterRenderer.data = null;
					headerOrFooterRenderer.data = item;
				}
			}
			item = this._owner.groupToFooterData(group);
			if(item)
			{
				headerOrFooterRenderer = this._footerRendererMap.get(item);
				if(headerOrFooterRenderer != null)
				{
					headerOrFooterRenderer.data = null;
					headerOrFooterRenderer.data = item;
				}
			}

			//we need to invalidate because the group may have more or fewer items
			this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);

			var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
			if(layout == null || !layout.hasVariableItemDimensions)
			{
				return;
			}
			//TODO: figure out the length of the previous group so that we
			//don't need to reset the whole cache
			layout.resetVariableVirtualCache();
		}
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

	private function itemRenderer_resizeHandler(event:Event):Void
	{
		if(this._ignoreRendererResizing)
		{
			return;
		}
		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		var renderer:IGroupedListItemRenderer = cast(event.currentTarget, IGroupedListItemRenderer);
		if(renderer.layoutIndex < 0)
		{
			return;
		}
		layout.resetVariableVirtualCacheAtIndex(renderer.layoutIndex, cast(renderer, DisplayObject));
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		this.invalidateParent(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	private function headerOrFooterRenderer_resizeHandler(event:Event):Void
	{
		if(this._ignoreRendererResizing)
		{
			return;
		}
		var layout:IVariableVirtualLayout = cast(this._layout, IVariableVirtualLayout);
		if(layout == null || !layout.hasVariableItemDimensions)
		{
			return;
		}
		var renderer:IGroupedListHeaderOrFooterRenderer = cast(event.currentTarget, IGroupedListHeaderOrFooterRenderer);
		if(renderer.layoutIndex < 0)
		{
			return;
		}
		layout.resetVariableVirtualCacheAtIndex(renderer.layoutIndex, cast(renderer, DisplayObject));
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		this.invalidateParent(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	private function renderer_changeHandler(event:Event):Void
	{
		if(this._ignoreSelectionChanges)
		{
			return;
		}
		var renderer:IGroupedListItemRenderer = cast(event.currentTarget, IGroupedListItemRenderer);
		if(!this._isSelectable || this._isScrolling)
		{
			renderer.isSelected = false;
			return;
		}
		if(renderer.isSelected)
		{
			this.setSelectedLocation(renderer.groupIndex, renderer.itemIndex);
		}
		else
		{
			this.setSelectedLocation(-1, -1);
		}
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

		var touch:Touch;
		if(this.touchPointID >= 0)
		{
			touch = event.getTouch(this, TouchPhase.ENDED, this.touchPointID);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = -1;
		}
		else
		{
			touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = touch.id;
			this._isScrolling = false;
		}
	}
}
