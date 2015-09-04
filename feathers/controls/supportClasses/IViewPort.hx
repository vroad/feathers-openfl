/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
import feathers.core.IFeathersControl;

[ExcludeClass]
public interface IViewPort extends IFeathersControl
{
	function get_visibleWidth():Float;
	function set_visibleWidth(value:Float):Float;
	function get_minVisibleWidth():Float;
	function set_minVisibleWidth(value:Float):Float;
	function get_maxVisibleWidth():Float;
	function set_maxVisibleWidth(value:Float):Float;
	function get_visibleHeight():Float;
	function set_visibleHeight(value:Float):Float;
	function get_minVisibleHeight():Float;
	function set_minVisibleHeight(value:Float):Float;
	function get_maxVisibleHeight():Float;
	function set_maxVisibleHeight(value:Float):Float;

	function get_contentX():Float;
	function get_contentY():Float;

	function get_horizontalScrollPosition():Float;
	function set_horizontalScrollPosition(value:Float):Float;
	function get_verticalScrollPosition():Float;
	function set_verticalScrollPosition(value:Float):Float;
	function get_horizontalScrollStep():Float;
	function get_verticalScrollStep():Float;
}
}
