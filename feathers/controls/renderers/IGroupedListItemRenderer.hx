/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers;
import feathers.controls.*;
import feathers.core.IToggle;

/**
 * Interface to implement a renderer for a grouped list item.
 */
interface IGroupedListItemRenderer extends IToggle
{
	/**
	 * An item from the grouped list's data provider. The data may change if
	 * this item renderer is reused for a new item because it's no longer
	 * needed for the original item.
	 *
	 * <p>This property is set by the list, and should not be set manually.</p>
	 */
	var data(get, set):Dynamic;
	//function get_data():Dynamic;
	
	/**
	 * @private
	 */
	//function set_data(value:Dynamic):Void;
	
	/**
	 * The index of the item's parent group within the data provider of the
	 * grouped list.
	 *
	 * <p>This property is set by the list, and should not be set manually.</p>
	 */
	var groupIndex(get, set):Int;
	//function get_groupIndex():Int;
	
	/**
	 * @private
	 */
	//function set_groupIndex(value:Int):Void;

	/**
	 * The index of the item within its parent group.
	 *
	 * <p>This property is set by the list, and should not be set manually.</p>
	 */
	var itemIndex(get, set):Int;
	//function get_itemIndex():Int;

	/**
	 * @private
	 */
	//function set_itemIndex(value:Int):Void;

	/**
	 * The index of the item within the layout.
	 *
	 * <p>This property is set by the list, and should not be set manually.</p>
	 */
	var layoutIndex(get, set):Int;
	//function get_layoutIndex():Int;

	/**
	 * @private
	 */
	//function set_layoutIndex(value:Int):Void;
	
	/**
	 * The grouped list that contains this item renderer.
	 *
	 * <p>This property is set by the list, and should not be set manually.</p>
	 */
	var owner(get, set):GroupedList;
	//function get_owner():GroupedList;
	
	/**
	 * @private
	 */
	//function set_owner(value:GroupedList):Void;
}