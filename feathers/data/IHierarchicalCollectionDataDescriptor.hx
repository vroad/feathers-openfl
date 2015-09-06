/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import feathers.utils.type.AcceptEither;
/**
 * An adapter interface to support any kind of data source in
 * hierarchical collections.
 *
 * @see HierarchicalCollection
 */
interface IHierarchicalCollectionDataDescriptor
{
	/**
	 * Determines if a node from the data source is a branch.
	 */
	function isBranch(node:Dynamic):Bool;

	/**
	 * The number of items at the specified location in the data source.
	 *
	 * <p>The rest arguments are the indices that make up the location. If
	 * a location is omitted, the length returned will be for the root level
	 * of the collection.</p>
	 */
	function getLength(data:Dynamic, indices:AcceptEither<Int, Array<Int>>):Int;

	/**
	 * Returns the item at the specified location in the data source.
	 *
	 * <p>The rest arguments are the indices that make up the location.</p>
	 */
	function getItemAt(data:Dynamic, indices:AcceptEither<Int, Array<Int>>):Dynamic;

	/**
	 * Replaces the item at the specified location with a new item.
	 *
	 * <p>The rest arguments are the indices that make up the location.</p>
	 */
	function setItemAt(data:Dynamic, item:Dynamic, indices:AcceptEither<Int, Array<Int>>):Void;

	/**
	 * Adds an item to the data source, at the specified location.
	 *
	 * <p>The rest arguments are the indices that make up the location.</p>
	 */
	function addItemAt(data:Dynamic, item:Dynamic, indices:AcceptEither<Int, Array<Int>>):Void;

	/**
	 * Removes the item at the specified location from the data source and
	 * returns it.
	 *
	 * <p>The rest arguments are the indices that make up the location.</p>
	 */
	function removeItemAt(data:Dynamic, indices:AcceptEither<Int, Array<Int>>):Dynamic;

	/**
	 * Removes all items from the data source.
	 */
	function removeAll(data:Dynamic):Void;

	/**
	 * Determines which location the item appears at within the data source.
	 * If the item isn't in the data source, returns an empty <code>Vector.&lt;Int&gt;</code>.
	 *
	 * <p>The <code>rest</code> arguments are optional indices to narrow
	 * the search.</p>
	 */
	function getItemLocation(data:Dynamic, item:Dynamic, result:Array<Int> = null, indices:AcceptEither<Int, Array<Int>> = null):Array<Int>;
}
