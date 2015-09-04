/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
/**
 * An adapter interface to support any kind of data source in
 * <code>ListCollection</code>.
 * 
 * @see ListCollection
 */
interface IListCollectionDataDescriptor
{
	/**
	 * The number of items in the data source.
	 */
	function getLength(data:Dynamic):Int;
	
	/**
	 * Returns the item at the specified index in the data source.
	 */
	function getItemAt(data:Dynamic, index:Int):Dynamic;
	
	/**
	 * Replaces the item at the specified index with a new item.
	 */
	function setItemAt(data:Dynamic, item:Dynamic, index:Int):Void;
	
	/**
	 * Adds an item to the data source, at the specified index.
	 */
	function addItemAt(data:Dynamic, item:Dynamic, index:Int):Void;
	
	/**
	 * Removes the item at the specified index from the data source and
	 * returns it.
	 */
	function removeItemAt(data:Dynamic, index:Int):Dynamic;
	
	/**
	 * Determines which index the item appears at within the data source. If
	 * the item isn't in the data source, returns <code>-1</code>.
	 */
	function getItemIndex(data:Dynamic, item:Dynamic):Int;

	/**
	 * Removes all items from the data source.
	 */
	function removeAll(data:Dynamic):Void;
}