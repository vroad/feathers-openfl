/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.events;
/**
 * Event <code>type</code> constants for collections. This class is
 * not a subclass of <code>starling.events.Event</code> because these
 * constants are meant to be used with <code>dispatchEventWith()</code> and
 * take advantage of the Starling's event object pooling. The object passed
 * to an event listener will be of type <code>starling.events.Event</code>.
 *
 * <listing version="3.0">
 * function listener( event:Event ):void
 * {
 *     trace( "add item" );
 * }
 * collection.addEventListener( CollectionEventType.ADD_ITEM, listener );</listing>
 */
class CollectionEventType
{
	/**
	 * Dispatched when the data provider's source is completely replaced.
	 */
	inline public static var RESET:String = "reset";

	/**
	 * Dispatched when an item is added to the collection.
	 */
	inline public static var ADD_ITEM:String = "addItem";

	/**
	 * Dispatched when an item is removed from the collection.
	 */
	inline public static var REMOVE_ITEM:String = "removeItem";

	/**
	 * Dispatched when an item is replaced in the collection with a
	 * different item.
	 */
	inline public static var REPLACE_ITEM:String = "replaceItem";

	/**
	 * Dispatched when an item in the collection has changed.
	 */
	inline public static var UPDATE_ITEM:String = "updateItem";
}
