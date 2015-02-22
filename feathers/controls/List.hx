/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.supportClasses.ListDataViewPort;
import feathers.core.IFocusDisplayObject;
import feathers.core.PropertyProxy;
import feathers.data.ListCollection;
import feathers.events.CollectionEventType;
import feathers.layout.ILayout;
import feathers.layout.VerticalLayout;
import feathers.skins.IStyleProvider;

import openfl.geom.Point;
import openfl.ui.Keyboard;

import starling.events.Event;
import starling.events.KeyboardEvent;

/**
 * Dispatched when the selected item changes.
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
//[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when an item renderer is added to the list. When the layout is
 * virtualized, item renderers may not exist for every item in the data
 * provider. This event can be used to track which items currently have
 * renderers.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The item renderer that was added.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.RENDERER_ADD
 */
//[Event(name="rendererAdd",type="starling.events.Event")]

/**
 * Dispatched when an item renderer is removed from the list. When the layout is
 * virtualized, item renderers may not exist for every item in the data
 * provider. This event can be used to track which items currently have
 * renderers.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The item renderer that was removed.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.RENDERER_REMOVE
 */
//[Event(name="rendererRemove",type="starling.events.Event")]

[DefaultProperty("dataProvider")]
/**
 * Displays a one-dimensional list of items. Supports scrolling, custom
 * item renderers, and custom layouts.
 *
 * <p>Layouts may be, and are highly encouraged to be, <em>virtual</em>,
 * meaning that the List is capable of creating a limited number of item
 * renderers to display a subset of the data provider instead of creating a
 * renderer for every single item. This allows for optimal performance with
 * very large data providers.</p>
 *
 * <p>The following example creates a list, gives it a data provider, tells
 * the item renderer how to interpret the data, and listens for when the
 * selection changes:</p>
 *
 * <listing version="3.0">
 * var list:List = new List();
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
 * @see http://wiki.starling-framework.org/feathers/list
 * @see GroupedList
 */
class List extends Scroller implements IFocusDisplayObject
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_AUTO:String = "auto";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_ON:String = "on";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_OFF:String = "off";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

	/**
	 * The vertical scroll bar will be positioned on the right.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

	/**
	 * The vertical scroll bar will be positioned on the left.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH:String = "touch";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_MOUSE:String = "mouse";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_NORMAL:Float = 0.998;

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_FAST:Float = 0.99;

	/**
	 * The default <code>IStyleProvider</code> for all <code>List</code>
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
		this._selectedIndices.addEventListener(Event.CHANGE, selectedIndices_changeHandler);
	}

	/**
	 * @private
	 * The guts of the List's functionality. Handles layout and selection.
	 */
	private var dataViewPort:ListDataViewPort;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return List.globalStyleProvider;
	}

	/**
	 * @private
	 */
	override public var isFocusEnabled(get, set):Bool;
public function get_isFocusEnabled():Bool
	{
		return this._isSelectable && this._isEnabled && this._isFocusEnabled;
	}

	/**
	 * @private
	 */
	private var _layout:ILayout;

	/**
	 * The layout algorithm used to position and, optionally, size the
	 * list's items.
	 *
	 * <p>By default, if no layout is provided by the time that the list
	 * initializes, a vertical layout with options targeted at touch screens
	 * is created.</p>
	 *
	 * <p>The following example tells the list to use a horizontal layout:</p>
	 *
	 * <listing version="3.0">
	 * var layout:HorizontalLayout = new HorizontalLayout();
	 * layout.gap = 20;
	 * layout.padding = 20;
	 * list.layout = layout;</listing>
	 *
	 * @default null
	 */
	public var layout(get, set):ILayout;
	public function get_layout():ILayout
	{
		return this._layout;
	}

	/**
	 * @private
	 */
	public function set_layout(value:ILayout):ILayout
	{
		if(this._layout == value)
		{
			return;
		}
		this._layout = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}
	
	/**
	 * @private
	 */
	private var _dataProvider:ListCollection;
	
	/**
	 * The collection of data displayed by the list. Changing this property
	 * to a new value is considered a drastic change to the list's data, so
	 * the horizontal and vertical scroll positions will be reset, and the
	 * list's selection will be cleared.
	 *
	 * <p>The following example passes in a data provider and tells the item
	 * renderer how to interpret the data:</p>
	 *
	 * <listing version="3.0">
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
	 * };</listing>
	 *
	 * <p><em>Warning:</em> A list's data provider cannot contain duplicate
	 * items. To display the same item in multiple item renderers, you must
	 * create separate objects with the same properties. This limitation
	 * exists because it significantly improves performance.</p>
	 *
	 * <p><em>Warning:</em> If the data provider contains display objects,
	 * concrete textures, or anything that needs to be disposed, those
	 * objects will not be automatically disposed when the list is disposed.
	 * Similar to how <code>starling.display.Image</code> cannot
	 * automatically dispose its texture because the texture may be used
	 * by other display objects, a list cannot dispose its data provider
	 * because the data provider may be used by other lists. See the
	 * <code>dispose()</code> function on <code>ListCollection</code> to
	 * see how the data provider can be disposed properly.</p>
	 *
	 * @default null
	 *
	 * @see feathers.data.ListCollection#dispose()
	 */
	public var dataProvider(get, set):ListCollection;
	public function get_dataProvider():ListCollection
	{
		return this._dataProvider;
	}
	
	/**
	 * @private
	 */
	public function set_dataProvider(value:ListCollection):ListCollection
	{
		if(this._dataProvider == value)
		{
			return;
		}
		if(this._dataProvider)
		{
			this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
		}
		this._dataProvider = value;
		if(this._dataProvider)
		{
			this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
		}

		//reset the scroll position because this is a drastic change and
		//the data is probably completely different
		this.horizontalScrollPosition = 0;
		this.verticalScrollPosition = 0;

		//clear the selection for the same reason
		this.selectedIndex = -1;

		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}
	
	/**
	 * @private
	 */
	private var _isSelectable:Bool = true;
	
	/**
	 * Determines if items in the list may be selected. By default only a
	 * single item may be selected at any given time. In other words, if
	 * item A is selected, and the user selects item B, item A will be
	 * deselected automatically. Set <code>allowMultipleSelection</code>
	 * to <code>true</code> to select more than one item without
	 * automatically deselecting other items.
	 *
	 * <p>The following example disables selection:</p>
	 *
	 * <listing version="3.0">
	 * list.isSelectable = false;</listing>
	 *
	 * @default true
	 *
	 * @see #allowMultipleSelection
	 */
	public var isSelectable(get, set):Bool;
	public function get_isSelectable():Bool
	{
		return this._isSelectable;
	}
	
	/**
	 * @private
	 */
	public function set_isSelectable(value:Bool):Bool
	{
		if(this._isSelectable == value)
		{
			return;
		}
		this._isSelectable = value;
		if(!this._isSelectable)
		{
			this.selectedIndex = -1;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}
	
	/**
	 * @private
	 */
	private var _selectedIndex:Int = -1;
	
	/**
	 * The index of the currently selected item. Returns <code>-1</code> if
	 * no item is selected.
	 *
	 * <p>The following example selects an item by its index:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedIndex = 2;</listing>
	 *
	 * <p>The following example clears the selected index:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedIndex = -1;</listing>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected index:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:List = List( event.currentTarget );
	 *     var index:Int = list.selectedIndex;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @default -1
	 *
	 * @see #selectedItem
	 * @see #allowMultipleSelection
	 * @see #selectedItems
	 * @see #selectedIndices
	 */
	public var selectedIndex(get, set):Int;
	public function get_selectedIndex():Int
	{
		return this._selectedIndex;
	}
	
	/**
	 * @private
	 */
	public function set_selectedIndex(value:Int):Int
	{
		if(this._selectedIndex == value)
		{
			return;
		}
		if(value >= 0)
		{
			this._selectedIndices.data = new <Int>[value];
		}
		else
		{
			this._selectedIndices.removeAll();
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * The currently selected item. Returns <code>null</code> if no item is
	 * selected.
	 *
	 * <p>The following example changes the selected item:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedItem = list.dataProvider.getItemAt(0);</listing>
	 *
	 * <p>The following example clears the selected item:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedItem = null;</listing>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected item:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:List = List( event.currentTarget );
	 *     var item:Dynamic = list.selectedItem;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @default null
	 *
	 * @see #selectedIndex
	 * @see #allowMultipleSelection
	 * @see #selectedItems
	 * @see #selectedIndices
	 */
	public var selectedItem(get, set):Dynamic;
	public function get_selectedItem():Dynamic
	{
		if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
		{
			return null;
		}

		return this._dataProvider.getItemAt(this._selectedIndex);
	}

	/**
	 * @private
	 */
	public function set_selectedItem(value:Dynamic):Dynamic
	{
		if(!this._dataProvider)
		{
			this.selectedIndex = -1;
			return;
		}
		this.selectedIndex = this._dataProvider.getItemIndex(value);
	}

	/**
	 * @private
	 */
	private var _allowMultipleSelection:Bool = false;

	/**
	 * If <code>true</code> multiple items may be selected at a time. If
	 * <code>false</code>, then only a single item may be selected at a
	 * time, and if the selection changes, other items are deselected. Has
	 * no effect if <code>isSelectable</code> is <code>false</code>.
	 *
	 * <p>In the following example, multiple selection is enabled:</p>
	 *
	 * <listing version="3.0">
	 * list.allowMultipleSelection = true;</listing>
	 *
	 * @default false
	 *
	 * @see #isSelectable
	 * @see #selectedIndices
	 * @see #selectedItems
	 */
	public var allowMultipleSelection(get, set):Bool;
	public function get_allowMultipleSelection():Bool
	{
		return this._allowMultipleSelection;
	}

	/**
	 * @private
	 */
	public function set_allowMultipleSelection(value:Bool):Bool
	{
		if(this._allowMultipleSelection == value)
		{
			return;
		}
		this._allowMultipleSelection = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * @private
	 */
	private var _selectedIndices:ListCollection = new ListCollection(new Array());

	/**
	 * The indices of the currently selected items. Returns an empty <code>Vector.&lt;Int&gt;</code>
	 * if no items are selected. If <code>allowMultipleSelection</code> is
	 * <code>false</code>, only one item may be selected at a time.
	 *
	 * <p>The following example selects two items by their indices:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedIndices = new &lt;Int&gt;[ 2, 3 ];</listing>
	 *
	 * <p>The following example clears the selected indices:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedIndices = null;</listing>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected indices:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:List = List( event.currentTarget );
	 *     var indices:Vector.&lt;Int&gt; = list.selectedIndices;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @see #allowMultipleSelection
	 * @see #selectedItems
	 * @see #selectedIndex
	 * @see #selectedItem
	 */
	public var selectedIndices(get, set):Array<Int>;
	public function get_selectedIndices():Array<Int>
	{
		return this._selectedIndices.data as Array<Int>;
	}

	/**
	 * @private
	 */
	public function set_selectedIndices(value:Array<Int>):Array<Int>
	{
		var oldValue:Array<Int> = this._selectedIndices.data as Array<Int>;
		if(oldValue == value)
		{
			return;
		}
		if(!value)
		{
			if(this._selectedIndices.length == 0)
			{
				return;
			}
			this._selectedIndices.removeAll();
		}
		else
		{
			if(!this._allowMultipleSelection && value.length > 0)
			{
				value.length = 1;
			}
			this._selectedIndices.data = value;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * The currently selected item. The getter returns an empty
	 * <code>Vector.&lt;Object&gt;</code> if no item is selected. If any
	 * items are selected, the getter creates a new
	 * <code>Vector.&lt;Object&gt;</code> to return a list of selected
	 * items.
	 *
	 * <p>The following example selects two items:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedItems = new &lt;Object&gt;[ list.dataProvider.getItemAt(2) , list.dataProvider.getItemAt(3) ];</listing>
	 *
	 * <p>The following example clears the selected items:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedItems = null;</listing>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected items:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:List = List( event.currentTarget );
	 *     var items:Vector.&lt;Object&gt; = list.selectedItems;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @see #allowMultipleSelection
	 * @see #selectedIndices
	 * @see #selectedIndex
	 * @see #selectedItem
	 */
	public var selectedItems(get, set):Array<Object>;
	public function get_selectedItems():Array<Object>
	{
		return this.getSelectedItems(new Array());
	}

	/**
	 * @private
	 */
	public function set_selectedItems(value:Array<Object>):Array<Object>
	{
		if(!value || !this._dataProvider)
		{
			this.selectedIndex = -1;
			return;
		}
		var indices:Array<Int> = new Array();
		var itemCount:Int = value.length;
		for(var i:Int = 0; i < itemCount; i++)
		{
			var item:Dynamic = value[i];
			var index:Int = this._dataProvider.getItemIndex(item);
			if(index >= 0)
			{
				indices.push(index);
			}
		}
		this.selectedIndices = indices;
	}

	/**
	 * Returns the selected items, with the ability to pass in an optional
	 * result vector. Better for performance than the <code>selectedItems</code>
	 * getter because it can avoid the allocation, and possibly garbage
	 * collection, of the result object.
	 *
	 * @see #selectedItems
	 */
	public function getSelectedItems(result:Array<Object> = null):Array<Object>
	{
		if(result)
		{
			result.length = 0;
		}
		else
		{
			result = new Array();
		}
		if(!this._dataProvider)
		{
			return result;
		}
		var indexCount:Int = this._selectedIndices.length;
		for(var i:Int = 0; i < indexCount; i++)
		{
			var index:Int = this._selectedIndices.getItemAt(i) as Int;
			var item:Dynamic = this._dataProvider.getItemAt(index);
			result[i] = item;
		}
		return result;
	}
	
	/**
	 * @private
	 */
	private var _itemRendererType:Class<Dynamic> = DefaultListItemRenderer;
	
	/**
	 * The class used to instantiate item renderers. Must implement the
	 * <code>IListItemRenderer</code> interface.
	 *
	 * <p>To customize properties on the item renderer, use
	 * <code>itemRendererFactory</code> instead.</p>
	 *
	 * <p>The following example changes the item renderer type:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererType = CustomItemRendererClass;</listing>
	 *
	 * @default feathers.controls.renderers.DefaultListItemRenderer
	 *
	 * @see feathers.controls.renderers.IListItemRenderer
	 * @see #itemRendererFactory
	 */
	public var itemRendererType(get, set):Class;
	public function get_itemRendererType():Class
	{
		return this._itemRendererType;
	}
	
	/**
	 * @private
	 */
	public function set_itemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._itemRendererType == value)
		{
			return;
		}
		
		this._itemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}
	
	/**
	 * @private
	 */
	private var _itemRendererFactory:Dynamic;
	
	/**
	 * A function called that is expected to return a new item renderer. Has
	 * a higher priority than <code>itemRendererType</code>. Typically, you
	 * would use an <code>itemRendererFactory</code> instead of an
	 * <code>itemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IListItemRenderer</pre>
	 *
	 * <p>The following example provides a factory for the item renderer:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererFactory = function():IListItemRenderer
	 * {
	 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
	 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
	 *     return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderers.IListItemRenderer
	 * @see #itemRendererType
	 */
	public var itemRendererFactory(get, set):Dynamic;
	public function get_itemRendererFactory():Dynamic
	{
		return this._itemRendererFactory;
	}
	
	/**
	 * @private
	 */
	public function set_itemRendererFactory(value:Dynamic):Dynamic
	{
		if(this._itemRendererFactory == value)
		{
			return;
		}
		
		this._itemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}
	
	/**
	 * @private
	 */
	private var _typicalItem:Dynamic = null;
	
	/**
	 * Used to auto-size the list when a virtualized layout is used. If the
	 * list's width or height is unknown, the list will try to automatically
	 * pick an ideal size. This item is used to create a sample item
	 * renderer to measure item renderers that are virtual and not visible
	 * in the viewport.
	 *
	 * <p>The following example provides a typical item:</p>
	 *
	 * <listing version="3.0">
	 * list.typicalItem = { text: "A typical item", thumbnail: texture };
	 * list.itemRendererProperties.labelField = "text";
	 * list.itemRendererProperties.iconSourceField = "thumbnail";</listing>
	 *
	 * @default null
	 */
	public var typicalItem(get, set):Dynamic;
	public function get_typicalItem():Dynamic
	{
		return this._typicalItem;
	}
	
	/**
	 * @private
	 */
	public function set_typicalItem(value:Dynamic):Dynamic
	{
		if(this._typicalItem == value)
		{
			return;
		}
		this._typicalItem = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _itemRendererName:String;

	/**
	 * A name to add to all item renderers in this list. Typically used by a
	 * theme to provide different skins to different lists.
	 *
	 * <p>The following example sets the item renderer name:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererName = "my-custom-item-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultListItemRenderer ).setFunctionForStyleName( "my-custom-item-renderer", setCustomItemRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var itemRendererName(get, set):String;
	public function get_itemRendererName():String
	{
		return this._itemRendererName;
	}

	/**
	 * @private
	 */
	public function set_itemRendererName(value:String):String
	{
		if(this._itemRendererName == value)
		{
			return;
		}
		this._itemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _itemRendererProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to all of the list's item
	 * renderers. These values are shared by each item renderer, so values
	 * that cannot be shared (such as display objects that need to be added
	 * to the display list) should be passed to the item renderers using an
	 * <code>itemRendererFactory</code> or with a theme. The item renderers
	 * are instances of <code>IListItemRenderer</code>. The available
	 * properties depend on which <code>IListItemRenderer</code>
	 * implementation is returned by <code>itemRendererFactory</code>.
	 *
	 * <p>The following example customizes some item renderer properties
	 * (this example assumes that the item renderer's label text renderer
	 * is a <code>BitmapFontTextRenderer</code>):</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererProperties.&#64;defaultLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
	 * list.itemRendererProperties.padding = 20;</listing>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>itemRendererFactory</code> function
	 * instead of using <code>itemRendererProperties</code> will result in
	 * better performance.</p>
	 *
	 * @default null
	 *
	 * @see #itemRendererFactory
	 * @see feathers.controls.renderers.IListItemRenderer
	 * @see feathers.controls.renderers.DefaultListItemRenderer
	 */
	public var itemRendererProperties(get, set):Dynamic;
	public function get_itemRendererProperties():Dynamic
	{
		if(!this._itemRendererProperties)
		{
			this._itemRendererProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._itemRendererProperties;
	}

	/**
	 * @private
	 */
	public function set_itemRendererProperties(value:Dynamic):Dynamic
	{
		if(this._itemRendererProperties == value)
		{
			return;
		}
		if(!value)
		{
			value = new PropertyProxy();
		}
		if(!(value is PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for(var propertyName:String in value)
			{
				newValue[propertyName] = value[propertyName];
			}
			value = newValue;
		}
		if(this._itemRendererProperties)
		{
			this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._itemRendererProperties = PropertyProxy(value);
		if(this._itemRendererProperties)
		{
			this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * The pending item index to scroll to after validating. A value of
	 * <code>-1</code> means that the scroller won't scroll to an item after
	 * validating.
	 */
	private var pendingItemIndex:Int = -1;

	/**
	 * @private
	 */
	override public function scrollToPosition(horizontalScrollPosition:Float, verticalScrollPosition:Float, animationDuration:Float = Math.NaN):Void
	{
		this.pendingItemIndex = -1;
		super.scrollToPosition(horizontalScrollPosition, verticalScrollPosition, animationDuration);
	}

	/**
	 * @private
	 */
	override public function scrollToPageIndex(horizontalPageIndex:Int, verticalPageIndex:Int, animationDuration:Float = Math.NaN):Void
	{
		this.pendingItemIndex = -1;
		super.scrollToPageIndex(horizontalPageIndex, verticalPageIndex, animationDuration);
	}
	
	/**
	 * Scrolls the list so that the specified item is visible. If
	 * <code>animationDuration</code> is greater than zero, the scroll will
	 * animate. The duration is in seconds.
	 *
	 * <p>If the layout is virtual with variable item dimensions, this
	 * function may not accurately scroll to the exact correct position. A
	 * virtual layout with variable item dimensions is often forced to
	 * estimate positions, so the results aren't guaranteed to be accurate.</p>
	 *
	 * <p>If you want to scroll to the end of the list, it is better to use
	 * <code>scrollToPosition()</code> with <code>maxHorizontalScrollPosition</code>
	 * or <code>maxVerticalScrollPosition</code>.</p>
	 *
	 * <p>In the following example, the list is scrolled to display index 10:</p>
	 *
	 * <listing version="3.0">
	 * list.scrollToDisplayIndex( 10 );</listing>
	 * 
	 * @param index The integer index of an item from the data provider.
	 * @param animationDuration The length of time, in seconds, of the animation. May be zero to scroll instantly.
	 *
	 * @see #scrollToPosition()
	 */
	public function scrollToDisplayIndex(index:Int, animationDuration:Float = 0):Void
	{
		this.pendingHorizontalPageIndex = -1;
		this.pendingVerticalPageIndex = -1;
		this.pendingHorizontalScrollPosition = Math.NaN;
		this.pendingVerticalScrollPosition = Math.NaN;
		if(this.pendingItemIndex == index &&
			this.pendingScrollDuration == animationDuration)
		{
			return;
		}
		this.pendingItemIndex = index;
		this.pendingScrollDuration = animationDuration;
		this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		//clearing selection now so that the data provider setter won't
		//cause a selection change that triggers events.
		this._selectedIndices.removeEventListeners();
		this._selectedIndex = -1;
		this.dataProvider = null;
		super.dispose();
	}
	
	/**
	 * @private
	 */
	override private function initialize():Void
	{
		var hasLayout:Bool = this._layout != null;

		super.initialize();
		
		if(!this.dataViewPort)
		{
			this.viewPort = this.dataViewPort = new ListDataViewPort();
			this.dataViewPort.owner = this;
			this.viewPort = this.dataViewPort;
		}

		if(!hasLayout)
		{
			if(this._hasElasticEdges &&
				this._verticalScrollPolicy == SCROLL_POLICY_AUTO &&
				this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				//so that the elastic edges work even when the max scroll
				//position is 0, similar to iOS.
				this.verticalScrollPolicy = SCROLL_POLICY_ON;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = 0;
			layout.gap = 0;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			this._layout = layout;
		}
	}
	
	/**
	 * @private
	 */
	override private function draw():Void
	{
		this.refreshDataViewPortProperties();
		super.draw();
		this.refreshFocusIndicator();
	}

	/**
	 * @private
	 */
	private function refreshDataViewPortProperties():Void
	{
		this.dataViewPort.isSelectable = this._isSelectable;
		this.dataViewPort.allowMultipleSelection = this._allowMultipleSelection;
		this.dataViewPort.selectedIndices = this._selectedIndices;
		this.dataViewPort.dataProvider = this._dataProvider;
		this.dataViewPort.itemRendererType = this._itemRendererType;
		this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
		this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
		this.dataViewPort.itemRendererName = this._itemRendererName;
		this.dataViewPort.typicalItem = this._typicalItem;
		this.dataViewPort.layout = this._layout;
	}

	/**
	 * @private
	 */
	override private function handlePendingScroll():Void
	{
		if(this.pendingItemIndex >= 0)
		{
			var item:Dynamic = this._dataProvider.getItemAt(this.pendingItemIndex);
			if(item is Object)
			{
				this.dataViewPort.getScrollPositionForIndex(this.pendingItemIndex, HELPER_POINT);
				this.pendingItemIndex = -1;

				var targetHorizontalScrollPosition:Float = HELPER_POINT.x;
				if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
				}
				else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
				}
				var targetVerticalScrollPosition:Float = HELPER_POINT.y;
				if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
				{
					targetVerticalScrollPosition = this._minVerticalScrollPosition;
				}
				else if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
				{
					targetVerticalScrollPosition = this._maxVerticalScrollPosition;
				}
				this.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, this.pendingScrollDuration);
			}
		}
		super.handlePendingScroll();
	}

	/**
	 * @private
	 */
	override private function focusInHandler(event:Event):Void
	{
		super.focusInHandler(event);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
	}

	/**
	 * @private
	 */
	override private function focusOutHandler(event:Event):Void
	{
		super.focusOutHandler(event);
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
	}

	/**
	 * @private
	 */
	private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(!this._dataProvider)
		{
			return;
		}
		if(event.keyCode == Keyboard.HOME)
		{
			if(this._dataProvider.length > 0)
			{
				this.selectedIndex = 0;
			}
		}
		else if(event.keyCode == Keyboard.END)
		{
			this.selectedIndex = this._dataProvider.length - 1;
		}
		else if(event.keyCode == Keyboard.UP)
		{
			this.selectedIndex = Math.max(0, this._selectedIndex - 1);
		}
		else if(event.keyCode == Keyboard.DOWN)
		{
			this.selectedIndex = Math.min(this._dataProvider.length - 1, this._selectedIndex + 1);
		}
	}

	/**
	 * @private
	 */
	private function dataProvider_changeHandler(event:Event):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private function dataProvider_resetHandler(event:Event):Void
	{
		this.horizontalScrollPosition = 0;
		this.verticalScrollPosition = 0;
	}
	
	/**
	 * @private
	 */
	private function selectedIndices_changeHandler(event:Event):Void
	{
		if(this._selectedIndices.length > 0)
		{
			this._selectedIndex = this._selectedIndices.getItemAt(0) as Int;
		}
		else
		{
			if(this._selectedIndex < 0)
			{
				//no change
				return;
			}
			this._selectedIndex = -1;
		}
		this.dispatchEventWith(Event.CHANGE);
	}
}