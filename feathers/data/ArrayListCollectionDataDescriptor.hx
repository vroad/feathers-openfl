/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import openfl.errors.IllegalOperationError;

/**
 * An <code>IListCollectionDataDescriptor</code> implementation for Arrays.
 * 
 * @see ListCollection
 * @see IListCollectionDataDescriptor
 */
class ArrayListCollectionDataDescriptor implements IListCollectionDataDescriptor
{
	/**
	 * Constructor.
	 */
	public function new()
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function getLength(data:Dynamic):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array).length;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemAt(data:Dynamic, index:Int):Dynamic
	{
		this.checkForCorrectDataType(data);
		return (data as Array)[index];
	}
	
	/**
	 * @inheritDoc
	 */
	public function setItemAt(data:Dynamic, item:Dynamic, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array)[index] = item;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addItemAt(data:Dynamic, item:Dynamic, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array).splice(index, 0, item);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeItemAt(data:Dynamic, index:Int):Dynamic
	{
		this.checkForCorrectDataType(data);
		return (data as Array).splice(index, 1)[0];
	}

	/**
	 * @inheritDoc
	 */
	public function removeAll(data:Dynamic):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array).length = 0;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemIndex(data:Dynamic, item:Dynamic):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array).indexOf(item);
	}
	
	/**
	 * @private
	 */
	private function checkForCorrectDataType(data:Dynamic):Void
	{
		if(!(Std.is(data, Array)))
		{
			throw new IllegalOperationError("Expected Array. Received " + Object(data).constructor + " instead.");
		}
	}
}