/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.core.IFeathersControl;

[ExcludeClass]
public interface IViewPort extends IFeathersControl
{
	function get visibleWidth():Number;
	function set visibleWidth(value:Number):Void;
	function get minVisibleWidth():Number;
	function set minVisibleWidth(value:Number):Void;
	function get maxVisibleWidth():Number;
	function set maxVisibleWidth(value:Number):Void;
	function get visibleHeight():Number;
	function set visibleHeight(value:Number):Void;
	function get minVisibleHeight():Number;
	function set minVisibleHeight(value:Number):Void;
	function get maxVisibleHeight():Number;
	function set maxVisibleHeight(value:Number):Void;

	function get contentX():Number;
	function get contentY():Number;

	function get horizontalScrollPosition():Number;
	function set horizontalScrollPosition(value:Number):Void;
	function get verticalScrollPosition():Number;
	function set verticalScrollPosition(value:Number):Void;
	function get horizontalScrollStep():Number;
	function get verticalScrollStep():Number;
}
