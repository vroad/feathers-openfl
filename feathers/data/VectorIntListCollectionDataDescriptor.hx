/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import flash.errors.IllegalOperationError;

/**
 * An <code>IListCollectionDataDescriptor</code> implementation for Vector.&lt;Int&gt;.
 * 
 * @see ListCollection
 * @see IListCollectionDataDescriptor
 */
class VectorIntListCollectionDataDescriptor implements IListCollectionDataDescriptor
{
	/**
	 * Constructor.
	 */
	public function VectorIntListCollectionDataDescriptor()
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function getLength(data:Dynamic):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Int>).length;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemAt(data:Dynamic, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Int>)[index];
	}
	
	/**
	 * @inheritDoc
	 */
	public function setItemAt(data:Dynamic, item:Dynamic, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Int>)[index] = item as Int;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addItemAt(data:Dynamic, item:Dynamic, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Int>).splice(index, 0, item);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeItemAt(data:Dynamic, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Int>).splice(index, 1)[0];
	}

	/**
	 * @inheritDoc
	 */
	public function removeAll(data:Dynamic):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Int>).length = 0;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemIndex(data:Dynamic, item:Dynamic):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Int>).indexOfcast(item, Int);
	}
	
	/**
	 * @private
	 */
	private function checkForCorrectDataType(data:Dynamic):Void
	{
		if(!(data is Array<Int>))
		{
			throw new IllegalOperationError("Expected Array<Int>. Received " + Object(data).constructor + " instead.");
		}
	}
}