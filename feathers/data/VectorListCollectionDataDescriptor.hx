/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
import flash.errors.IllegalOperationError;

/**
 * An <code>IListCollectionDataDescriptor</code> implementation for Vectors.
 * 
 * @see ListCollection
 * @see IListCollectionDataDescriptor
 */
class VectorListCollectionDataDescriptor implements IListCollectionDataDescriptor
{
	/**
	 * Constructor.
	 */
	public function VectorListCollectionDataDescriptor()
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function getLength(data:Object):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array<*>).length;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemAt(data:Object, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return (data as Array<*>)[index];
	}
	
	/**
	 * @inheritDoc
	 */
	public function setItemAt(data:Object, item:Object, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<*>)[index] = item;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addItemAt(data:Object, item:Object, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<*>).splice(index, 0, item);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeItemAt(data:Object, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return (data as Array<*>).splice(index, 1)[0];
	}

	/**
	 * @inheritDoc
	 */
	public function removeAll(data:Object):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<*>).length = 0;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemIndex(data:Object, item:Object):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array<*>).indexOf(item);
	}
	
	/**
	 * @private
	 */
	private function checkForCorrectDataType(data:Object):Void
	{
		if(!(data is Array<*>))
		{
			throw new IllegalOperationError("Expected Vector. Received " + Object(data).constructor + " instead.");
		}
	}
}
}