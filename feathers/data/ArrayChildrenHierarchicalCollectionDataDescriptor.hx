/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import feathers.utils.type.AcceptEither;
/**
 * A hierarchical data descriptor where children are defined as arrays in a
 * property defined on each branch. The property name defaults to <code>"children"</code>,
 * but it may be customized.
 *
 * <p>The basic structure of the data source takes the following form. The
 * root must always be an Array.</p>
 * <pre>
 * [
 *     {
 *         text: "Branch 1",
 *         children:
 *         [
 *             { text: "Child 1-1" },
 *             { text: "Child 1-2" }
 *         ]
 *     },
 *     {
 *         text: "Branch 2",
 *         children:
 *         [
 *             { text: "Child 2-1" },
 *             { text: "Child 2-2" },
 *             { text: "Child 2-3" }
 *         ]
 *     }
 * ]</pre>
 */
class ArrayChildrenHierarchicalCollectionDataDescriptor implements IHierarchicalCollectionDataDescriptor
{
	/**
	 * Constructor.
	 */
	public function new()
	{
	}

	/**
	 * The field used to access the Array of a branch's children.
	 */
	public var childrenField:String = "children";

	/**
	 * @inheritDoc
	 */
	public function getLength(data:Dynamic, indices:AcceptEither<Int, Array<Int>>):Int
	{
		var branch:Array<Dynamic> = cast(data, Array<Dynamic>);
		var rest:Array<Int> = getIndicesFromEither(indices);
		var indexCount:Int = rest.length;
		for(i in 0 ... indexCount)
		{
			var index:Int = rest[i];
			branch = cast(Reflect.getProperty(branch[index], childrenField), Array<Dynamic>);
		}

		return branch.length;
	}

	/**
	 * @inheritDoc
	 */
	public function getItemAt(data:Dynamic, indices:AcceptEither<Int, Array<Int>>):Dynamic
	{
		var rest:Array<Int> = getIndicesFromEither(indices);
		var index:Int;
		var branch:Array<Dynamic> = cast(data, Array<Dynamic>);
		var indexCount:Int = rest.length - 1;
		for(i in 0 ... indexCount)
		{
			index = rest[i];
			branch = cast(Reflect.getProperty(branch[index], childrenField), Array<Dynamic>);
		}
		var lastIndex:Int = rest[indexCount];
		return branch[lastIndex];
	}

	/**
	 * @inheritDoc
	 */
	public function setItemAt(data:Dynamic, item:Dynamic, indices:AcceptEither<Int, Array<Int>>):Void
	{
		var rest:Array<Int> = getIndicesFromEither(indices);
		var index:Int;
		var branch:Array<Dynamic> = cast(data, Array<Dynamic>);
		var indexCount:Int = rest.length - 1;
		for(i in 0 ... indexCount)
		{
			index = rest[i];
			branch = cast(Reflect.getProperty(branch[index], childrenField), Array<Dynamic>);
		}
		var lastIndex:Int = rest[indexCount];
		branch[lastIndex] = item;
	}

	/**
	 * @inheritDoc
	 */
	public function addItemAt(data:Dynamic, item:Dynamic, indices:AcceptEither<Int, Array<Int>>):Void
	{
		var rest:Array<Int> = getIndicesFromEither(indices);
		var index:Int;
		var branch:Array<Dynamic> = cast(data, Array<Dynamic>);
		var indexCount:Int = rest.length - 1;
		for(i in 0 ... indexCount)
		{
			index = rest[i];
			branch = cast(Reflect.getProperty(branch[index], childrenField), Array<Dynamic>);
		}
		var lastIndex:Int = rest[indexCount];
		branch.insert(lastIndex, item);
	}

	/**
	 * @inheritDoc
	 */
	public function removeItemAt(data:Dynamic, indices:AcceptEither<Int, Array<Int>>):Dynamic
	{
		var rest:Array<Int> = getIndicesFromEither(indices);
		var index:Int;
		var branch:Array<Dynamic> = cast(data, Array<Dynamic>);
		var indexCount:Int = rest.length - 1;
		for(i in 0 ... indexCount)
		{
			index = rest[i];
			branch = cast(Reflect.getProperty(branch[index], childrenField), Array<Dynamic>);
		}
		var lastIndex:Int = rest[indexCount];
		var item:Dynamic = branch[lastIndex];
		branch.splice(lastIndex, 1);
		return item;
	}

	/**
	 * @inheritDoc
	 */
	public function removeAll(data:Dynamic):Void
	{
		var branch:Array<Dynamic> = cast(data, Array<Dynamic>);
		branch.splice(0, branch.length);
	}

	/**
	 * @inheritDoc
	 */
	public function getItemLocation(data:Dynamic, item:Dynamic, result:Array<Int> = null, indices:AcceptEither<Int, Array<Int>> = null):Array<Int>
	{
		if(result == null)
		{
			result = new Array();
		}
		else
		{
			result.splice(0, result.length);
		}
		var rest:Array<Int> = getIndicesFromEither(indices);
		var branch:Array<Dynamic> = cast(data, Array<Dynamic>);
		var restCount:Int = rest.length;
		for(i in 0 ... restCount)
		{
			var index:Int = rest[i];
			result[i] = index;
			branch = cast(Reflect.getProperty(branch[index], childrenField), Array<Dynamic>);
		}

		var isFound:Bool = this.findItemInBranch(branch, item, result);
		if(!isFound)
		{
			result.splice(0, result.length);
		}
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function isBranch(node:Dynamic):Bool
	{
		return Std.is(Reflect.getProperty(node, this.childrenField), Array);
	}

	/**
	 * @private
	 */
	private function findItemInBranch(branch:Array<Dynamic>, item:Dynamic, result:Array<Int>):Bool
	{
		var index:Int = branch.indexOf(item);
		if(index >= 0)
		{
			result.push(index);
			return true;
		}

		var branchLength:Int = branch.length;
		for(i in 0 ... branchLength)
		{
			var branchItem:Dynamic = branch[i];
			if(this.isBranch(branchItem))
			{
				result.push(i);
				var isFound:Bool = this.findItemInBranch(cast(Reflect.getProperty(branchItem, childrenField), Array<Dynamic>), item, result);
				if(isFound)
				{
					return true;
				}
				result.pop();
			}
		}
		return false;
	}
	
	private static function getIndicesFromEither(index:AcceptEither<Int, Array<Int>>)
	{
		var rest:Array<Int> = [];
		if(index != null)
			switch index.type {
				case Left(intIndex) : rest = [intIndex];
				case Right(indices) : rest = indices;
			}
		return rest;
	}
}
