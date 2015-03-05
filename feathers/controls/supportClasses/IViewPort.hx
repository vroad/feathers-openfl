/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.core.IFeathersControl;

//[ExcludeClass]
interface IViewPort extends IFeathersControl
{
	var visibleWidth(get, set):Float;
	//function get_visibleWidth():Float;
	//function set_visibleWidth(value:Float):Void;
	var minVisibleWidth(get, set):Float;
	//function get_minVisibleWidth():Float;
	//function set_minVisibleWidth(value:Float):Void;
	var maxVisibleWidth(get, set):Float;
	//function get_maxVisibleWidth():Float;
	//function set_maxVisibleWidth(value:Float):Void;
	var visibleHeight(get, set):Float;
	//function get_visibleHeight():Float;
	//function set_visibleHeight(value:Float):Void;
	var minVisibleHeight(get, set):Float;
	//function get_minVisibleHeight():Float;
	//function set_minVisibleHeight(value:Float):Void;
	var maxVisibleHeight(get, set):Float;
	//function get_maxVisibleHeight():Float;
	//function set_maxVisibleHeight(value:Float):Void;

	var contentX(get, never):Float;
	//function get_contentX():Float;
	var contentY(get, never):Float;
	//function get_contentY():Float;

	var horizontalScrollPosition(get, set):Float;
	//function get_horizontalScrollPosition():Float;
	//function set_horizontalScrollPosition(value:Float):Void;
	var verticalScrollPosition(get, set):Float;
	//function get_verticalScrollPosition():Float;
	//function set_verticalScrollPosition(value:Float):Void;
	var horizontalScrollStep(get, never):Float;
	//function get_horizontalScrollStep():Float;
	var verticalScrollStep(get, never):Float;
	//function get_verticalScrollStep():Float;
}
