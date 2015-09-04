/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import feathers.events.CollectionEventType;
import feathers.utils.type.AcceptEither;

import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Dispatched when the underlying data source changes and the ui will
 * need to redraw the data.
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
 * Dispatched when the collection has changed drastically, such as when
 * the underlying data source is replaced completely.
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
 * @eventType feathers.events.CollectionEventType.RESET
 */
//[Event(name="reset",type="starling.events.Event")]

/**
 * Dispatched when an item is added to the collection.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The index path of the item that has
 * been added. It is of type <code>Array</code> and contains objects of
 * type <code>Int</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.CollectionEventType.ADD_ITEM
 */
//[Event(name="addItem",type="starling.events.Event")]

/**
 * Dispatched when an item is removed from the collection.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The index path of the item that has
 * been removed. It is of type <code>Array</code> and contains objects of
 * type <code>Int</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.CollectionEventType.REMOVE_ITEM
 */
//[Event(name="removeItem",type="starling.events.Event")]

/**
 * Dispatched when an item is replaced in the collection.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The index path of the item that has
 * been re[;aced. It is of type <code>Array</code> and contains objects of
 * type <code>Int</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.CollectionEventType.REPLACE_ITEM
 */
//[Event(name="replaceItem",type="starling.events.Event")]

/**
 * Dispatched when a property of an item in the collection has changed
 * and the item doesn't have its own change event or signal. This event
 * is only dispatched when the <code>updateItemAt()</code> function is
 * called on the <code>HierarchicalCollection</code>.
 *
 * <p>In general, it's better for the items themselves to dispatch events
 * or signals when their properties change.</p>
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The index path of the item that has
 * been updated. It is of type <code>Array</code> and contains objects of
 * type <code>Int</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.CollectionEventType.UPDATE_ITEM
 */
//[Event(name="updateItem",type="starling.events.Event")]

/**
 * Wraps a two-dimensional data source with a common API for use with UI
 * controls that support this type of data.
 */
class HierarchicalCollection extends EventDispatcher
{
	public function new(data:Dynamic = null)
	{
		super();
		if(data == null)
		{
			//default to an array if no data is provided
			data = [];
		}
		this.data = data;
	}

	/**
	 * @private
	 */
	private var _data:Dynamic;

	/**
	 * The data source for this collection. May be any type of data, but a
	 * <code>dataDescriptor</code> needs to be provided to translate from
	 * the data source's APIs to something that can be understood by
	 * <code>HierarchicalCollection</code>.
	 */
	public var data(get, set):Dynamic;
	public function get_data():Dynamic
	{
		return _data;
	}

	/**
	 * @private
	 */
	public function set_data(value:Dynamic):Dynamic
	{
		if(this._data == value)
		{
			return get_data();
		}
		this._data = value;
		this.dispatchEventWith(CollectionEventType.RESET);
		this.dispatchEventWith(Event.CHANGE);
		return get_data();
	}

	/**
	 * @private
	 */
	private var _dataDescriptor:IHierarchicalCollectionDataDescriptor = new ArrayChildrenHierarchicalCollectionDataDescriptor();

	/**
	 * Describes the underlying data source by translating APIs.
	 */
	public var dataDescriptor(get, set):IHierarchicalCollectionDataDescriptor;
	public function get_dataDescriptor():IHierarchicalCollectionDataDescriptor
	{
		return this._dataDescriptor;
	}

	/**
	 * @private
	 */
	public function set_dataDescriptor(value:IHierarchicalCollectionDataDescriptor):IHierarchicalCollectionDataDescriptor
	{
		if(this._dataDescriptor == value)
		{
			return get_dataDescriptor();
		}
		this._dataDescriptor = value;
		this.dispatchEventWith(CollectionEventType.RESET);
		this.dispatchEventWith(Event.CHANGE);
		return get_dataDescriptor();
	}

	/**
	 * Determines if a node from the data source is a branch.
	 */
	public function isBranch(node:Dynamic):Bool
	{
		return this._dataDescriptor.isBranch(node);
	}

	/**
	 * The number of items at the specified location in the collection.
	 */
	public function getLength(index:AcceptEither<Int, Array<Int>> = null):Int
	{
		return this._dataDescriptor.getLength(this._data, index);
	}

	/**
	 * If an item doesn't dispatch an event or signal to indicate that it
	 * has changed, you can manually tell the collection about the change,
	 * and the collection will dispatch the <code>CollectionEventType.UPDATE_ITEM</code>
	 * event to manually notify the component that renders the data.
	 */
	public function updateItemAt(index:AcceptEither<Int, Array<Int>>):Void
	{
		this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, getIndicesFromEither(index));
	}

	/**
	 * Returns the item at the specified location in the collection.
	 */
	public function getItemAt(index:AcceptEither<Int, Array<Int>>):Dynamic
	{
		return this._dataDescriptor.getItemAt(this._data, index);
	}

	/**
	 * Determines which location the item appears at within the collection. If
	 * the item isn't in the collection, returns <code>null</code>.
	 */
	public function getItemLocation(item:Dynamic, result:Array<Int> = null):Array<Int>
	{
		return this._dataDescriptor.getItemLocation(this._data, item, result);
	}

	/**
	 * Adds an item to the collection, at the specified location.
	 */
	public function addItemAt(item:Dynamic, index:AcceptEither<Int, Array<Int>>):Void
	{
		this._dataDescriptor.addItemAt(this._data, item, index);
		this.dispatchEventWith(Event.CHANGE);
		this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, getIndicesFromEither(index));
	}

	/**
	 * Removes the item at the specified location from the collection and
	 * returns it.
	 */
	public function removeItemAt(index:AcceptEither<Int, Array<Int>>):Dynamic
	{
		var item:Dynamic = this._dataDescriptor.removeItemAt(this._data, index);
		this.dispatchEventWith(Event.CHANGE);
		this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, getIndicesFromEither(index));
		return item;
	}

	/**
	 * Removes a specific item from the collection.
	 */
	public function removeItem(item:Dynamic):Void
	{
		var location:Array<Int> = this.getItemLocation(item);
		if(location != null)
		{
			//this is hacky. a future version probably won't use rest args.
			var locationAsArray:Array<Int> = [];
			var indexCount:Int = location.length;
			//for(var i:Int = 0; i < indexCount; i++)
			for(i in 0 ... indexCount)
			{
				locationAsArray.push(location[i]);
			}
			this.removeItemAt(locationAsArray);
		}
	}

	/**
	 * Removes all items from the collection.
	 */
	public function removeAll():Void
	{
		if(this.getLength() == 0)
		{
			return;
		}
		this._dataDescriptor.removeAll(this._data);
		this.dispatchEventWith(Event.CHANGE);
		this.dispatchEventWith(CollectionEventType.RESET, false);
	}

	/**
	 * Replaces the item at the specified location with a new item.
	 */
	public function setItemAt(item:Dynamic, index:AcceptEither<Int, Array<Int>>):Void
	{
		this._dataDescriptor.setItemAt(this._data, item, index);
		this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, getIndicesFromEither(index));
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * Calls a function for each group in the collection and another
	 * function for each item in a group, where each function handles any
	 * properties that require disposal on these objects. For example,
	 * display objects or textures may need to be disposed. You may pass in
	 * a value of <code>null</code> for either function if you don't have
	 * anything to dispose in one or the other.
	 *
	 * <p>The function to dispose a group is expected to have the following signature:</p>
	 * <pre>function( group:Dynamic ):Void</pre>
	 *
	 * <p>The function to dispose an item is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Void</pre>
	 *
	 * <p>In the following example, the items in the collection are disposed:</p>
	 *
	 * <listing version="3.0">
	 * collection.dispose( function( group:Dynamic ):Void
	 * {
	 *     var content:DisplayObject = DisplayObject(group.content);
	 *     content.dispose();
	 * },
	 * function( item:Dynamic ):Void
	 * {
	 *     var accessory:DisplayObject = DisplayObject(item.accessory);
	 *     accessory.dispose();
	 * },)</listing>
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() starling.display.DisplayObject.dispose()
	 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html#dispose() starling.textures.Texture.dispose()
	 */
	public function dispose(disposeGroup:Dynamic, disposeItem:Dynamic):Void
	{
		var groupCount:Int = this.getLength(null);
		var path:Array<Int> = [];
		//for(var i:Int = 0; i < groupCount; i++)
		for(i in 0 ... groupCount)
		{
			var group:Dynamic = this.getItemAt(i);
			path[0] = i;
			this.disposeGroupInternal(group, path, disposeGroup, disposeItem);
			path.splice(0, path.length);
		}
	}

	/**
	 * @private
	 */
	private function disposeGroupInternal(group:Dynamic, path:Array<Int>, disposeGroup:Dynamic, disposeItem:Dynamic):Void
	{
		if(disposeGroup != null)
		{
			disposeGroup(group);
		}

		var itemCount:Int = this.getLength(path);
		//for(var i:Int = 0; i < itemCount; i++)
		for(i in 0 ... itemCount)
		{
			path[path.length] = i;
			var item:Dynamic = this.getItemAt(path);
			if(this.isBranch(item))
			{
				this.disposeGroupInternal(item, path, disposeGroup, disposeItem);
			}
			else if(disposeItem != null)
			{
				disposeItem(item);
			}
			path.splice(path.length - 1, 1);
		}
	}
	
	private static function getIndicesFromEither(index:AcceptEither<Int, Array<Int>>):Array<Int>
	{
		var ret:Array<Int> = [];
		if(index != null)
			switch index.type {
				case Left(intIndex) : ret = [intIndex];
				case Right(indices) : ret = indices;
			}
		return ret;
	}
}
