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
	function get visibleWidth():Float;
	function set visibleWidth(value:Float):Void;
	function get minVisibleWidth():Float;
	function set minVisibleWidth(value:Float):Void;
	function get maxVisibleWidth():Float;
	function set maxVisibleWidth(value:Float):Void;
	function get visibleHeight():Float;
	function set visibleHeight(value:Float):Void;
	function get minVisibleHeight():Float;
	function set minVisibleHeight(value:Float):Void;
	function get maxVisibleHeight():Float;
	function set maxVisibleHeight(value:Float):Void;

	function get contentX():Float;
	function get contentY():Float;

	function get horizontalScrollPosition():Float;
	function set horizontalScrollPosition(value:Float):Void;
	function get verticalScrollPosition():Float;
	function set verticalScrollPosition(value:Float):Void;
	function get horizontalScrollStep():Float;
	function get verticalScrollStep():Float;
}
