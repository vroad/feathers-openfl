/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import flash.errors.IllegalOperationError;

/**
 * An <code>IListCollectionDataDescriptor</code> implementation for
 * XMLLists. Has some limitations due to certain things that cannot be done
 * to XMLLists.
 * 
 * @see ListCollection
 * @see IListCollectionDataDescriptor
 */
class XMLListListCollectionDataDescriptor implements IListCollectionDataDescriptor
{
	/**
	 * Constructor.
	 */
	public function XMLListListCollectionDataDescriptor()
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function getLength(data:Object):Int
	{
		this.checkForCorrectDataType(data);
		return cast(data, XMLList).length();
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemAt(data:Object, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		return data[index];
	}
	
	/**
	 * @inheritDoc
	 */
	public function setItemAt(data:Object, item:Object, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		data[index] = XML(item);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addItemAt(data:Object, item:Object, index:Int):Void
	{
		this.checkForCorrectDataType(data);
		
		//wow, this is weird. unless I have failed epicly, I can find no 
		//other way to insert an element into an XMLList at a specific index.
		var dataClone:XMLList = cast(data, XMLList).copy();
		data[index] = item;
		var listLength:Int = dataClone.length();
		for(i in index ... listLength)
		{
			data[i + 1] = dataClone[i];
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeItemAt(data:Object, index:Int):Object
	{
		this.checkForCorrectDataType(data);
		var item:XML = data[index];
		delete data[index];
		return item;
	}

	/**
	 * @inheritDoc
	 */
	public function removeAll(data:Object):Void
	{
		this.checkForCorrectDataType(data);
		var list:XMLList = data as XMLList;
		var listLength:Int = list.length();
		for(i in 0 ... listLength)
		{
			delete data[0];
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function getItemIndex(data:Object, item:Object):Int
	{
		this.checkForCorrectDataType(data);
		var list:XMLList = data as XMLList;
		var listLength:Int = list.length();
		for(i in 0 ... listLength)
		{
			var currentItem:XML = list[i];
			if(currentItem == item)
			{
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * @private
	 */
	private function checkForCorrectDataType(data:Object):Void
	{
		if(!(data is XMLList))
		{
			throw new IllegalOperationError("Expected XMLList. Received " + Object(data).constructor + " instead.");
		}
	}
}