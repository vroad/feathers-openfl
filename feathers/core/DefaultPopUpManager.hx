/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import feathers.events.FeathersEventType;
import haxe.ds.WeakMap;
import openfl.errors.ArgumentError;

#if 0
import openfl.utils.Dictionary;
#end

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.display.Stage;
import starling.events.Event;
import starling.events.ResizeEvent;

/**
 * The default <code>IPopUpManager</code> implementation.
 *
 * @see PopUpManager
 */
class DefaultPopUpManager implements IPopUpManager
{
	/**
	 * @copy PopUpManager#defaultOverlayFactory()
	 */
	public static function defaultOverlayFactory():DisplayObject
	{
		var quad:Quad = new Quad(100, 100, 0x000000);
		quad.alpha = 0;
		return quad;
	}

	/**
	 * Constructor.
	 */
	public function new(root:DisplayObjectContainer = null)
	{
		this.root = root;
	}

	/**
	 * @private
	 */
	private var _popUps:Array<DisplayObject> = new Array();

	/**
	 * @private
	 */
#if flash
	private var _popUpToOverlay:WeakMap<DisplayObject, DisplayObject> = new WeakMap();
#else
	private var _popUpToOverlay:Map<DisplayObject, DisplayObject> = new Map();
#end
	/**
	 * @private
	 */
#if flash
	private var _popUpToFocusManager:WeakMap<DisplayObject, IFocusManager> = new WeakMap();
#else
	private var _popUpToFocusManager:Map<DisplayObject, IFocusManager> = new Map();
#end
	/**
	 * @private
	 */
	private var _centeredPopUps:Array<DisplayObject> = new Array();

	/**
	 * @private
	 */
	private var _overlayFactory:Dynamic = defaultOverlayFactory;

	/**
	 * @copy PopUpManager#overlayFactory
	 */
	public var overlayFactory(get, set):Dynamic;
	public function get_overlayFactory():Dynamic
	{
		return this._overlayFactory;
	}

	/**
	 * @private
	 */
	public function set_overlayFactory(value:Dynamic):Dynamic
	{
		return this._overlayFactory = value;
	}

	/**
	 * @private
	 */
	private var _ignoreRemoval:Bool = false;

	/**
	 * @private
	 */
	private var _root:DisplayObjectContainer;

	/**
	 * @copy PopUpManager#root
	 */
	public var root(get, set):DisplayObjectContainer;
	public function get_root():DisplayObjectContainer
	{
		return this._root;
	}

	/**
	 * @private
	 */
	public function set_root(value:DisplayObjectContainer):DisplayObjectContainer
	{
		if(this._root == value)
		{
			return this._root;
		}
		var popUpCount:Int = this._popUps.length;
		var oldIgnoreRemoval:Bool = this._ignoreRemoval; //just in case
		this._ignoreRemoval = true;
		for(i in 0 ... popUpCount)
		{
			var popUp:DisplayObject = this._popUps[i];
			var overlay:DisplayObject = _popUpToOverlay.get(popUp);
			popUp.removeFromParent(false);
			if(overlay != null)
			{
				overlay.removeFromParent(false);
			}
		}
		this._ignoreRemoval = oldIgnoreRemoval;
		this._root = value;
		//for(i = 0; i < popUpCount; i++)
		for(i in 0 ... popUpCount)
		{
			var popUp:DisplayObject = this._popUps[i];
			var overlay:DisplayObject = _popUpToOverlay.get(popUp);
			if(overlay != null)
			{
				this._root.addChild(overlay);
			}
			this._root.addChild(popUp);
		}
		return this._root;
	}

	/**
	 * @copy PopUpManager#addPopUp()
	 */
	public function addPopUp(popUp:DisplayObject, isModal:Bool = true, isCentered:Bool = true, customOverlayFactory:Void->DisplayObject = null):DisplayObject
	{
		if(isModal)
		{
			if(customOverlayFactory == null)
			{
				customOverlayFactory = this._overlayFactory;
			}
			if(customOverlayFactory == null)
			{
				customOverlayFactory = defaultOverlayFactory;
			}
			var overlay:DisplayObject = customOverlayFactory();
			overlay.width = this._root.stage.stageWidth;
			overlay.height = this._root.stage.stageHeight;
			this._root.addChild(overlay);
			this._popUpToOverlay.set(popUp, overlay);
		}

		this._popUps.push(popUp);
		this._root.addChild(popUp);
		//this listener needs to be added after the pop-up is added to the
		//root because the pop-up may not have been removed from its old
		//parent yet, which will trigger the listener if it is added first.
		popUp.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);

		if(this._popUps.length == 1)
		{
			this._root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}

		if(isModal && FocusManager.isEnabledForStage(this._root.stage) && Std.is(popUp, DisplayObjectContainer))
		{
			this._popUpToFocusManager.set(popUp, FocusManager.pushFocusManager(cast(popUp, DisplayObjectContainer)));
		}

		if(isCentered)
		{
			if(Std.is(popUp, IFeathersControl))
			{
				popUp.addEventListener(FeathersEventType.RESIZE, popUp_resizeHandler);
			}
			this._centeredPopUps.push(popUp);
			this.centerPopUp(popUp);
		}

		return popUp;
	}

	/**
	 * @copy PopUpManager#removePopUp()
	 */
	public function removePopUp(popUp:DisplayObject, dispose:Bool = false):DisplayObject
	{
		var index:Int = this._popUps.indexOf(popUp);
		if(index < 0)
		{
			throw new ArgumentError("Display object is not a pop-up.");
		}
		popUp.removeFromParent(dispose);
		return popUp;
	}

	/**
	 * @copy PopUpManager#isPopUp()
	 */
	public function isPopUp(popUp:DisplayObject):Bool
	{
		return this._popUps.indexOf(popUp) >= 0;
	}

	/**
	 * @copy PopUpManager#isTopLevelPopUp()
	 */
	public function isTopLevelPopUp(popUp:DisplayObject):Bool
	{
		var lastIndex:Int = this._popUps.length - 1;
		//for(var i:Int = lastIndex; i >= 0; i--)
		var i:Int = lastIndex;
		while(i >= 0)
		{
			var otherPopUp:DisplayObject = this._popUps[i];
			if(otherPopUp == popUp)
			{
				//we haven't encountered an overlay yet, so it is top-level
				return true;
			}
			var overlay:DisplayObject = this._popUpToOverlay.get(otherPopUp);
			if(overlay != null)
			{
				//this is the first overlay, and we haven't found the pop-up
				//yet, so it is not top-level
				return false;
			}
			i--;
		}
		//pop-up was not found at all, so obviously, not top-level
		return false;
	}

	/**
	 * @copy PopUpManager#centerPopUp()
	 */
	public function centerPopUp(popUp:DisplayObject):Void
	{
		var stage:Stage = this._root.stage;
		if(Std.is(popUp, IValidating))
		{
			cast(popUp, IValidating).validate();
		}
		popUp.x = Math.round((stage.stageWidth - popUp.width) / 2);
		popUp.y = Math.round((stage.stageHeight - popUp.height) / 2);
	}

	/**
	 * @private
	 */
	private function popUp_resizeHandler(event:Event):Void
	{
		var popUp:DisplayObject = cast(event.currentTarget, DisplayObject);
		var index:Int = this._centeredPopUps.indexOf(popUp);
		if(index < 0)
		{
			return;
		}
		this.centerPopUp(popUp);
	}

	/**
	 * @private
	 */
	private function popUp_removedFromStageHandler(event:Event):Void
	{
		if(this._ignoreRemoval)
		{
			return;
		}
		var popUp:DisplayObject = cast(event.currentTarget, DisplayObject);
		popUp.removeEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
		var index:Int = this._popUps.indexOf(popUp);
		this._popUps.splice(index, 1);
		var overlay:DisplayObject = this._popUpToOverlay.get(popUp);
		if(overlay != null)
		{
			overlay.removeFromParent(true);
			_popUpToOverlay.remove(popUp);
		}
		var focusManager:IFocusManager = this._popUpToFocusManager.get(popUp);
		if(focusManager != null)
		{
			this._popUpToFocusManager.remove(popUp);
			FocusManager.removeFocusManager(focusManager);
		}
		index = this._centeredPopUps.indexOf(popUp);
		if(index >= 0)
		{
			if(Std.is(popUp, IFeathersControl))
			{
				popUp.removeEventListener(FeathersEventType.RESIZE, popUp_resizeHandler);
			}
			this._centeredPopUps.splice(index, 1);
		}

		if(_popUps.length == 0)
		{
			this._root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}
	}

	/**
	 * @private
	 */
	private function stage_resizeHandler(event:ResizeEvent):Void
	{
		var stage:Stage = this._root.stage;
		var popUpCount:Int = this._popUps.length;
		for(i in 0 ... popUpCount)
		{
			var popUp:DisplayObject = this._popUps[i];
			var overlay:DisplayObject = this._popUpToOverlay.get(popUp);
			if(overlay != null)
			{
				overlay.width = stage.stageWidth;
				overlay.height = stage.stageHeight;
			}
		}
		popUpCount = this._centeredPopUps.length;
		//for(i = 0; i < popUpCount; i++)
		for(i in 0 ... popUpCount)
		{
			var popUp:DisplayObject = this._centeredPopUps[i];
			centerPopUp(popUp);
		}
	}
}
