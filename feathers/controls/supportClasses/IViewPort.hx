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
	function get_visibleWidth():Number;
	function set_visibleWidth(value:Number):Number;
	function get_minVisibleWidth():Number;
	function set_minVisibleWidth(value:Number):Number;
	function get_maxVisibleWidth():Number;
	function set_maxVisibleWidth(value:Number):Number;
	function get_visibleHeight():Number;
	function set_visibleHeight(value:Number):Number;
	function get_minVisibleHeight():Number;
	function set_minVisibleHeight(value:Number):Number;
	function get_maxVisibleHeight():Number;
	function set_maxVisibleHeight(value:Number):Number;

	function get_contentX():Number;
	function get_contentY():Number;

	function get_horizontalScrollPosition():Number;
	function set_horizontalScrollPosition(value:Number):Number;
	function get_verticalScrollPosition():Number;
	function set_verticalScrollPosition(value:Number):Number;
	function get_horizontalScrollStep():Number;
	function get_verticalScrollStep():Number;
}
}
