/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers;
import feathers.controls.GroupedList;
import feathers.core.IFeathersControl;

/**
 * Interface to implement a renderer for a grouped list header or footer.
 */
interface IGroupedListHeaderOrFooterRenderer extends IFeathersControl
{
	/**
	 * Data for a header or footer from the grouped list's data provider.
	 * The data may change if this renderer is reused for a new header or
	 * footer because it's no longer needed for the original data.
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
	 * The index of the group within the data provider of the grouped list.
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
	 * The grouped list that contains this header or footer renderer.
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
