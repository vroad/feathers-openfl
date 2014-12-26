/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import flash.errors.IllegalOperationError;

/**
 * An <code>IListCollectionDataDescriptor</code> implementation for Vector.&lt;Number&gt;.
 * 
 * @see ListCollection
 * @see IListCollectionDataDescriptor
 */
class VectorNumberListCollectionDataDescriptor implements IListCollectionDataDescriptor
{
	/**
	 * Constructor.
	 */
	public function VectorNumberListCollectionDataDescriptor()
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function getLength(data:Object):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Number>).length;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemAt(data:Object, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Number>)[index];
	}
	
	/**
	 * @inheritDoc
	 */
	public function setItemAt(data:Object, item:Object, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Number>)[index] = item as Number;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addItemAt(data:Object, item:Object, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Number>).splice(index, 0, item);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeItemAt(data:Object, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Number>).splice(index, 1)[0];
	}

	/**
	 * @inheritDoc
	 */
	public function removeAll(data:Object):Void
	{
		this.checkForCorrectDataType(data);
		(data as Array<Number>).length = 0;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemIndex(data:Object, item:Object):Int
	{
		this.checkForCorrectDataType(data);
		return (data as Array<Number>).indexOf(item as Number);
	}
	
	/**
	 * @private
	 */
	private function checkForCorrectDataType(data:Object):Void
	{
		if(!(data is Array<Number>))
		{
			throw new IllegalOperationError("Expected Array<Number>. Received " + Object(data).constructor + " instead.");
		}
	}
}