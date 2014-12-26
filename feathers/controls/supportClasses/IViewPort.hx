/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.core.IFeathersControl;

[ExcludeClass]
interface IViewPort extends IFeathersControl
{
	function get_visibleWidth():Float;
	function set_visibleWidth(value:Float):Void;
	function get_minVisibleWidth():Float;
	function set_minVisibleWidth(value:Float):Void;
	function get_maxVisibleWidth():Float;
	function set_maxVisibleWidth(value:Float):Void;
	function get_visibleHeight():Float;
	function set_visibleHeight(value:Float):Void;
	function get_minVisibleHeight():Float;
	function set_minVisibleHeight(value:Float):Void;
	function get_maxVisibleHeight():Float;
	function set_maxVisibleHeight(value:Float):Void;

	function get_contentX():Float;
	function get_contentY():Float;

	function get_horizontalScrollPosition():Float;
	function set_horizontalScrollPosition(value:Float):Void;
	function get_verticalScrollPosition():Float;
	function set_verticalScrollPosition(value:Float):Void;
	function get_horizontalScrollStep():Float;
	function get_verticalScrollStep():Float;
}
