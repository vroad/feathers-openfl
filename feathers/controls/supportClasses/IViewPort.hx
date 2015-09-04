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
	function set visibleWidth(value:Number):void;
	function get_minVisibleWidth():Number;
	function set minVisibleWidth(value:Number):void;
	function get_maxVisibleWidth():Number;
	function set maxVisibleWidth(value:Number):void;
	function get_visibleHeight():Number;
	function set visibleHeight(value:Number):void;
	function get_minVisibleHeight():Number;
	function set minVisibleHeight(value:Number):void;
	function get_maxVisibleHeight():Number;
	function set maxVisibleHeight(value:Number):void;

	function get_contentX():Number;
	function get_contentY():Number;

	function get_horizontalScrollPosition():Number;
	function set horizontalScrollPosition(value:Number):void;
	function get_verticalScrollPosition():Number;
	function set verticalScrollPosition(value:Number):void;
	function get_horizontalScrollStep():Number;
	function get_verticalScrollStep():Number;
}
}
