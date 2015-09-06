/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.core.IFeathersControl;

#if 0
[ExcludeClass]
#end
interface IViewPort extends IFeathersControl
{
	var visibleWidth(get, set):Float;
	var minVisibleWidth(get, set):Float;
	var maxVisibleWidth(get, set):Float;
	var visibleHeight(get, set):Float;
	var minVisibleHeight(get, set):Float;
	var maxVisibleHeight(get, set):Float;

	var contentX(get, never):Float;
	var contentY(get, never):Float;

	var horizontalScrollPosition(get, set):Float;
	var verticalScrollPosition(get, set):Float;
	var horizontalScrollStep(get, never):Float;
	var verticalScrollStep(get, never):Float;
}
