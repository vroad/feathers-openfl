/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;

/**
 * Interface for pop-up management.
 *
 * @see feathers.core.PopUpManager
 */
interface IPopUpManager
{
	/**
	 * @copy PopUpManager#overlayFactory
	 */
	var overlayFactory(get, set):Dynamic;
	//function get_overlayFactory():Dynamic;

	/**
	 * @private
	 */
	//function set_overlayFactory(value:Dynamic):Void;

	/**
	 * @copy PopUpManager#root
	 */
	var root(get, set):DisplayObjectContainer;
	//function get_root():DisplayObjectContainer;

	/**
	 * @private
	 */
	//function set_root(value:DisplayObjectContainer):Void;

	/**
	 * @copy PopUpManager#addPopUp()
	 */
	function addPopUp(popUp:DisplayObject, isModal:Bool = true, isCentered:Bool = true, customOverlayFactory:Void->DisplayObject = null):DisplayObject;

	/**
	 * @copy PopUpManager#removePopUp()
	 */
	function removePopUp(popUp:DisplayObject, dispose:Bool = false):DisplayObject;

	/**
	 * @copy PopUpManager#isPopUp()
	 */
	function isPopUp(popUp:DisplayObject):Bool;

	/**
	 * @copy PopUpManager#isTopLevelPopUp()
	 */
	function isTopLevelPopUp(popUp:DisplayObject):Bool;

	/**
	 * @copy PopUpManager#centerPopUp()
	 */
	function centerPopUp(popUp:DisplayObject):Void;
}
