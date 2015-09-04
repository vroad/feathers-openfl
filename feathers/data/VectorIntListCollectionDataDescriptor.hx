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
 * An <code>IListCollectionDataDescriptor</code> implementation for Vector.&lt;int&gt;.
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
	public function getLength(data:Object):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Int>).length;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemAt(data:Object, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Int>)[index];
	}
	
	/**
	 * @inheritDoc
	 */
	public function setItemAt(data:Object, item:Object, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Int>)[index] = item as Int;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addItemAt(data:Object, item:Object, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Int>).splice(index, 0, item as Int);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeItemAt(data:Object, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Int>).splice(index, 1)[0];
	}

	/**
	 * @inheritDoc
	 */
	public function removeAll(data:Object):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Int>).length = 0;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemIndex(data:Object, item:Object):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Int>).indexOf(item as Int);
	}
	
	/**
	 * @private
	 */
	private function checkForCorrectDataType(data:Object):Void
	{
		if(!(data is Array<Int>))
		{
			throw new IllegalOperationError("Expected Vector.<int>. Received " + Object(data).constructor + " instead.");
		}
	}
}
}