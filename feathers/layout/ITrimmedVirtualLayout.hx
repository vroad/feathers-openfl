/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
/**
 * Optimizes a virtual layout by skipping a specific number of items before
 * and after the set that is passed to <code>layout()</code>.
 */
interface ITrimmedVirtualLayout extends IVirtualLayout
{
	/**
	 * Used internally by a component, such as <code>List</code>, to set the
	 * number of virtualized items that appear before the items passed to
	 * <code>layout()</code>. Allows the array of items to be smaller than
	 * the full size. Does not work if the layout has variable item
	 * dimensions.
	 *
	 * <p>This property is meant to be set by the <code>List</code> or other
	 * component that uses the virtual layout. If you're simply creating
	 * a layout for a <code>List</code> or another component, do not use
	 * this property. It is meant for developers creating custom components
	 * only.</p>
	 */
	var beforeVirtualizedItemCount(get, set):Int;
	//function get_beforeVirtualizedItemCount():Int;

	/**
	 * @private
	 */
	//function set_beforeVirtualizedItemCount(value:Int):Void;

	/**
	 * Used internally by a component, such as <code>List</code>, to set the
	 * number of virtualized items that appear after the items passed to
	 * <code>layout()</code>. Allows the array of items to be smaller than
	 * the full size. Does not work if the layout has variable item
	 * dimensions.
	 *
	 * <p>This property is meant to be set by the <code>List</code> or other
	 * component that uses the virtual layout. If you're simply creating
	 * a layout for a <code>List</code> or another component, do not use
	 * this property. It is meant for developers creating custom components
	 * only.</p>
	 */
	var afterVirtualizedItemCount(get, set):Int;
	//function get_afterVirtualizedItemCount():Int;

	/**
	 * @private
	 */
	//function set_afterVirtualizedItemCount(value:Int):Void;
}
