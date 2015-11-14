/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import feathers.controls.supportClasses.LayoutViewPort;
import feathers.events.FeathersEventType;
#if 0
import feathers.utils.display.stageToStarling;
#else
import feathers.utils.display.FeathersDisplayUtil.stageToStarling;
#end

import openfl.display.InteractiveObject;
import openfl.display.Stage;
import openfl.events.FocusEvent;
import openfl.ui.Keyboard;
#if 0
import openfl.utils.Dictionary;
#end

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import openfl.display.Sprite;

import openfl.errors.ArgumentError;

#if flash
import haxe.ds.WeakMap;
#else
typedef WeakMap<K, V> = Map<K, V>;
#end

/**
 * The default <code>IPopUpManager</code> implementation.
 *
 * @see FocusManager
 */
class DefaultFocusManager implements IFocusManager
{
	/**
	 * @private
	 */
	private static var NATIVE_STAGE_TO_FOCUS_TARGET:WeakMap<Stage, NativeFocusTarget> = new WeakMap();

	/**
	 * Constructor.
	 */
	public function new(root:DisplayObjectContainer)
	{
		if(root.stage == null)
		{
			throw new ArgumentError("Focus manager root must be added to the stage.");
		}
		this._root = root;
		this._starling = stageToStarling(root.stage);
		this.setFocusManager(this._root);
	}

	/**
	 * @private
	 */
	private var _starling:Starling;

	/**
	 * @private
	 */
	private var _nativeFocusTarget:NativeFocusTarget;

	/**
	 * @private
	 */
	private var _root:DisplayObjectContainer;

	/**
	 * @inheritDoc
	 */
	public var root(get, never):DisplayObjectContainer;
	public function get_root():DisplayObjectContainer
	{
		return this._root;
	}

	/**
	 * @private
	 */
	private var _isEnabled:Bool = false;

	/**
	 * @inheritDoc
	 *
	 * @default false
	 */
	public var isEnabled(get, set):Bool;
	public function get_isEnabled():Bool
	{
		return this._isEnabled;
	}

	/**
	 * @private
	 */
	public function set_isEnabled(value:Bool):Bool
	{
		if(this._isEnabled == value)
		{
			return this._isEnabled;
		}
		this._isEnabled = value;
		if(this._isEnabled)
		{
			this._nativeFocusTarget = NATIVE_STAGE_TO_FOCUS_TARGET.get(this._starling.nativeStage);
			if(this._nativeFocusTarget == null)
			{
				this._nativeFocusTarget = new NativeFocusTarget();
				this._starling.nativeOverlay.addChild(_nativeFocusTarget);
			}
			else
			{
				this._nativeFocusTarget.referenceCount++;
			}
			this._root.addEventListener(Event.ADDED, topLevelContainer_addedHandler);
			this._root.addEventListener(Event.REMOVED, topLevelContainer_removedHandler);
			this._root.addEventListener(TouchEvent.TOUCH, topLevelContainer_touchHandler);
			this._starling.nativeStage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, stage_keyFocusChangeHandler, false, 0, true);
			this._starling.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stage_mouseFocusChangeHandler, false, 0, true);
			this.focus = this._savedFocus;
			this._savedFocus = null;
		}
		else
		{
			this._nativeFocusTarget.referenceCount--;
			if(this._nativeFocusTarget.referenceCount <= 0)
			{
				this._nativeFocusTarget.parent.removeChild(this._nativeFocusTarget);
				NATIVE_STAGE_TO_FOCUS_TARGET.remove(this._starling.nativeStage);
			}
			this._nativeFocusTarget = null;
			this._root.removeEventListener(Event.ADDED, topLevelContainer_addedHandler);
			this._root.removeEventListener(Event.REMOVED, topLevelContainer_removedHandler);
			this._root.removeEventListener(TouchEvent.TOUCH, topLevelContainer_touchHandler);
			this._starling.nativeStage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, stage_keyFocusChangeHandler);
			this._starling.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stage_mouseFocusChangeHandler);
			var focusToSave:IFocusDisplayObject = this.focus;
			this.focus = null;
			this._savedFocus = focusToSave;
		}
		return this._isEnabled;
	}

	/**
	 * @private
	 */
	private var _savedFocus:IFocusDisplayObject;

	/**
	 * @private
	 */
	private var _focus:IFocusDisplayObject;

	/**
	 * @inheritDoc
	 *
	 * @default null
	 */
	public var focus(get, set):IFocusDisplayObject;
	public function get_focus():IFocusDisplayObject
	{
		return this._focus;
	}

	/**
	 * @private
	 */
	public function set_focus(value:IFocusDisplayObject):IFocusDisplayObject
	{
		if(this._focus == value)
		{
			return this._focus;
		}
		var oldFocus:IFeathersDisplayObject = this._focus;
		if(this._isEnabled && value != null && value.isFocusEnabled && value.focusManager == this)
		{
			this._focus = value;
		}
		else
		{
			this._focus = null;
		}
		if(oldFocus != null)
		{
			//this event should be dispatched after setting the new value of
			//_focus because we want to be able to access it in the event
			//listener
			oldFocus.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}
		if(this._isEnabled)
		{
			var nativeStage:Stage = this._starling.nativeStage;
			if(this._focus != null)
			{
				if(Std.is(this._focus, INativeFocusOwner))
				{
					nativeStage.focus = cast(this._focus, INativeFocusOwner).nativeFocus;
				}
				//an INativeFocusOwner may return null for its
				//nativeFocus property, so we still need to double-check
				//that the native stage has something in focus. that's
				//why there isn't an else here
				if(nativeStage.focus == null)
				{
					nativeStage.focus = this._nativeFocusTarget;
				}
				nativeStage.focus.addEventListener(FocusEvent.FOCUS_OUT, nativeFocus_focusOutHandler, false, 0, true);
				this._focus.dispatchEventWith(FeathersEventType.FOCUS_IN);
			}
			else
			{
				nativeStage.focus = null;
			}
		}
		else
		{
			this._savedFocus = value;
		}
		return this._focus;
	}

	/**
	 * @private
	 */
	private function setFocusManager(target:DisplayObject):Void
	{
		if(Std.is(target, IFocusDisplayObject))
		{
			var targetWithFocus:IFocusDisplayObject = cast target;
			targetWithFocus.focusManager = this;
		}
		if((Std.is(target, DisplayObjectContainer) && !Std.is(target, IFocusDisplayObject)) ||
			(Std.is(target, IFocusContainer) && cast(target, IFocusContainer).isChildFocusEnabled))
		{
			var container:DisplayObjectContainer = cast target;
			var childCount:Int = container.numChildren;
			for(i in 0 ... childCount)
			{
				var child:DisplayObject = container.getChildAt(i);
				this.setFocusManager(child);
			}
			if(Std.is(container, IFocusExtras))
			{
				var containerWithExtras:IFocusExtras = cast container;
				var extras:Array<DisplayObject> = containerWithExtras.focusExtrasBefore;
				if(extras != null)
				{
					childCount = extras.length;
					//for(i = 0; i < childCount; i++)
					for(i in 0 ... childCount)
					{
						var child:DisplayObject = extras[i];
						this.setFocusManager(child);
					}
				}
				extras = containerWithExtras.focusExtrasAfter;
				if(extras != null)
				{
					childCount = extras.length;
					//for(i = 0; i < childCount; i++)
					for(i in 0 ... childCount)
					{
						var child:DisplayObject = extras[i];
						this.setFocusManager(child);
					}
				}
			}
		}
	}

	/**
	 * @private
	 */
	private function clearFocusManager(target:DisplayObject):Void
	{
		if(Std.is(target, IFocusDisplayObject))
		{
			var targetWithFocus:IFocusDisplayObject = cast target;
			if(targetWithFocus.focusManager == this)
			{
				if(this._focus == targetWithFocus)
				{
					//change to focus owner, which falls back to null
					this.focus = targetWithFocus.focusOwner;
				}
				targetWithFocus.focusManager = null;
			}
		}
		if(Std.is(target, DisplayObjectContainer))
		{
			var container:DisplayObjectContainer = cast target;
			var childCount:Int = container.numChildren;
			var child:DisplayObject;
			for(i in 0 ... childCount)
			{
				child = container.getChildAt(i);
				this.clearFocusManager(child);
			}
			if(Std.is(container, IFocusExtras))
			{
				var containerWithExtras:IFocusExtras = cast container;
				var extras:Array<DisplayObject> = containerWithExtras.focusExtrasBefore;
				if(extras != null)
				{
					childCount = extras.length;
					//for(i = 0; i < childCount; i++)
					for(i in 0 ... childCount)
					{
						child = extras[i];
						this.clearFocusManager(child);
					}
				}
				extras = containerWithExtras.focusExtrasAfter;
				if(extras != null)
				{
					childCount = extras.length;
					//for(i = 0; i < childCount; i++)
					for(i in 0 ... childCount)
					{
						child = extras[i];
						this.clearFocusManager(child);
					}
				}
			}
		}
	}

	/**
	 * @private
	 */
	private function findPreviousContainerFocus(container:DisplayObjectContainer, beforeChild:DisplayObject, fallbackToGlobal:Bool):IFocusDisplayObject
	{
		if(Std.is(container, LayoutViewPort))
		{
			container = container.parent;
		}
		var hasProcessedBeforeChild:Bool = beforeChild == null;
		var startIndex:Int;
		var child:DisplayObject;
		var foundChild:IFocusDisplayObject;
		var extras:Array<DisplayObject>;
		var focusContainer:IFocusExtras = null;
		var skip:Bool;
		var focusWithExtras:IFocusExtras = null;
		if(Std.is(container, IFocusExtras))
		{
			focusWithExtras = cast container;
			var extras:Array<DisplayObject> = focusWithExtras.focusExtrasAfter;
			if(extras != null)
			{
				skip = false;
				if(beforeChild != null)
				{
					startIndex = extras.indexOf(beforeChild) - 1;
					hasProcessedBeforeChild = startIndex >= -1;
					skip = !hasProcessedBeforeChild;
				}
				else
				{
					startIndex = extras.length - 1;
				}
				if(!skip)
				{
					//for(var i:Int = startIndex; i >= 0; i--)
					var i:Int = startIndex;
					while(i >= 0)
					{
						child = extras[i];
						foundChild = this.findPreviousChildFocus(child);
						if(this.isValidFocus(foundChild))
						{
							return foundChild;
						}
						i--;
					}
				}
			}
		}
		if(beforeChild != null && !hasProcessedBeforeChild)
		{
			startIndex = container.getChildIndex(beforeChild) - 1;
			hasProcessedBeforeChild = startIndex >= -1;
		}
		else
		{
			startIndex = container.numChildren - 1;
		}
		//for(i = startIndex; i >= 0; i--)
		var i:Int = startIndex;
		while(i >= 0)
		{
			child = container.getChildAt(i);
			foundChild = this.findPreviousChildFocus(child);
			if(this.isValidFocus(foundChild))
			{
				return foundChild;
			}
			i--;
		}
		if(Std.is(container, IFocusExtras))
		{
			extras = focusWithExtras.focusExtrasBefore;
			if(extras != null)
			{
				skip = false;
				if(beforeChild != null && !hasProcessedBeforeChild)
				{
					startIndex = extras.indexOf(beforeChild) - 1;
					hasProcessedBeforeChild = startIndex >= -1;
					skip = !hasProcessedBeforeChild;
				}
				else
				{
					startIndex = extras.length - 1;
				}
				if(!skip)
				{
					//for(i = startIndex; i >= 0; i--)
					i = startIndex;
					while(i >= 0)
					{
						child = extras[i];
						foundChild = this.findPreviousChildFocus(child);
						if(this.isValidFocus(foundChild))
						{
							return foundChild;
						}
						i--;
					}
				}
			}
		}

		if(fallbackToGlobal && container != this._root)
		{
			//try the container itself before moving backwards
			if(Std.is(container, IFocusDisplayObject))
			{
				var focusContainer:IFocusDisplayObject = cast container;
				if(this.isValidFocus(focusContainer))
				{
					return focusContainer;
				}
			}
			return this.findPreviousContainerFocus(container.parent, container, true);
		}
		return null;
	}

	/**
	 * @private
	 */
	private function findNextContainerFocus(container:DisplayObjectContainer, afterChild:DisplayObject, fallbackToGlobal:Bool):IFocusDisplayObject
	{
		if(Std.is(container, LayoutViewPort))
		{
			container = container.parent;
		}
		var hasProcessedAfterChild:Bool = afterChild == null;
		
		var startIndex:Int;
		var childCount:Int;
		var child:DisplayObject;
		var foundChild:IFocusDisplayObject;
		var extras:Array<DisplayObject>;
		var focusContainer:IFocusExtras = null;
		var skip:Bool;
		var focusWithExtras:IFocusExtras = null;
		if(Std.is(container, IFocusExtras))
		{
			focusWithExtras = cast container;
			var extras:Array<DisplayObject> = focusWithExtras.focusExtrasBefore;
			if(extras != null)
			{
				skip = false;
				if(afterChild != null)
				{
					startIndex = extras.indexOf(afterChild) + 1;
					hasProcessedAfterChild = startIndex > 0;
					skip = !hasProcessedAfterChild;
				}
				else
				{
					startIndex = 0;
				}
				if(!skip)
				{
					childCount = extras.length;
					for(i in startIndex ... childCount)
					{
						child = extras[i];
						foundChild = this.findNextChildFocus(child);
						if(this.isValidFocus(foundChild))
						{
							return foundChild;
						}
					}
				}
			}
		}
		if(afterChild != null && !hasProcessedAfterChild)
		{
			startIndex = container.getChildIndex(afterChild) + 1;
			hasProcessedAfterChild = startIndex > 0;
		}
		else
		{
			startIndex = 0;
		}
		childCount = container.numChildren;
		//for(i = startIndex; i < childCount; i++)
		for(i in startIndex ... childCount)
		{
			child = container.getChildAt(i);
			foundChild = this.findNextChildFocus(child);
			if(this.isValidFocus(foundChild))
			{
				return foundChild;
			}
		}
		if(Std.is(container, IFocusExtras))
		{
			extras = focusWithExtras.focusExtrasAfter;
			if(extras != null)
			{
				skip = false;
				if(afterChild != null && !hasProcessedAfterChild)
				{
					startIndex = extras.indexOf(afterChild) + 1;
					hasProcessedAfterChild = startIndex > 0;
					skip = !hasProcessedAfterChild;
				}
				else
				{
					startIndex = 0;
				}
				if(!skip)
				{
					childCount = extras.length;
					//for(i = startIndex; i < childCount; i++)
					for(i in startIndex ... childCount)
					{
						child = extras[i];
						foundChild = this.findNextChildFocus(child);
						if(this.isValidFocus(foundChild))
						{
							return foundChild;
						}
					}
				}
			}
		}

		if(fallbackToGlobal && container != this._root)
		{
			return this.findNextContainerFocus(container.parent, container, true);
		}
		return null;
	}

	/**
	 * @private
	 */
	private function findPreviousChildFocus(child:DisplayObject):IFocusDisplayObject
	{
		if((Std.is(child, DisplayObjectContainer) && !Std.is(child, IFocusDisplayObject)) ||
			(Std.is(child, IFocusContainer) && cast(child, IFocusContainer).isChildFocusEnabled))
		{
			var childContainer:DisplayObjectContainer = cast child;
			var foundChild:IFocusDisplayObject = this.findPreviousContainerFocus(childContainer, null, false);
			if(foundChild != null)
			{
				return foundChild;
			}
		}
		{
			var childWithFocus:IFocusDisplayObject = cast child;
			if(this.isValidFocus(childWithFocus))
			{
				return childWithFocus;
			}
		}
		return null;
	}

	/**
	 * @private
	 */
	private function findNextChildFocus(child:DisplayObject):IFocusDisplayObject
	{
		if(Std.is(child, IFocusDisplayObject))
		{
			var childWithFocus:IFocusDisplayObject = cast child;
			if(this.isValidFocus(childWithFocus))
			{
				return childWithFocus;
			}
		}
		if((Std.is(child, DisplayObjectContainer) && !Std.is(child, IFocusDisplayObject)) ||
			(Std.is(child, IFocusContainer) && cast(child, IFocusContainer).isChildFocusEnabled))
		{
			var childContainer:DisplayObjectContainer = cast child;
			var foundChild:IFocusDisplayObject = this.findNextContainerFocus(childContainer, null, false);
			if(foundChild != null)
			{
				return foundChild;
			}
		}
		return null;
	}

	/**
	 * @private
	 */
	private function isValidFocus(child:IFocusDisplayObject):Bool
	{
		if(child != null || !child.isFocusEnabled || child.focusManager != this)
		{
			return false;
		}
		var uiChild:IFeathersControl = Std.is(child, IFeathersControl) ? cast(child, IFeathersControl) : null;
		if(uiChild != null && !uiChild.isEnabled)
		{
			return false;
		}
		return true;
	}

	/**
	 * @private
	 */
	private function stage_mouseFocusChangeHandler(event:FocusEvent):Void
	{
		if(event.relatedObject != null)
		{
			//we need to allow mouse focus to be passed to native display
			//objects. for instance, hyperlinks in TextField won't work
			//unless the TextField can be focused.
			this.focus = null;
			return;
		}
		event.preventDefault();
	}

	/**
	 * @private
	 */
	private function stage_keyFocusChangeHandler(event:FocusEvent):Void
	{
		//keyCode 0 is sent by IE, for some reason
		if(event.keyCode != Keyboard.TAB && event.keyCode != 0)
		{
			return;
		}

		var newFocus:IFocusDisplayObject = null;
		var currentFocus:IFocusDisplayObject = this._focus;
		if(currentFocus != null && currentFocus.focusOwner != null)
		{
			newFocus = currentFocus.focusOwner;
		}
		else if(event.shiftKey)
		{
			if(currentFocus != null)
			{
				if(currentFocus.previousTabFocus != null)
				{
					newFocus = currentFocus.previousTabFocus;
				}
				else
				{
					newFocus = this.findPreviousContainerFocus(currentFocus.parent, cast(currentFocus, DisplayObject), true);
				}
			}
			if(newFocus == null)
			{
				newFocus = this.findPreviousContainerFocus(this._root, null, false);
			}
		}
		else
		{
			if(currentFocus != null)
			{
				if(currentFocus.nextTabFocus != null)
				{
					newFocus = currentFocus.nextTabFocus;
				}
				else if(Std.is(currentFocus, IFocusContainer) && cast(currentFocus, IFocusContainer).isChildFocusEnabled)
				{
					newFocus = this.findNextContainerFocus(cast(currentFocus, DisplayObjectContainer), null, false);
				}
				else
				{
					newFocus = this.findNextContainerFocus(currentFocus.parent, cast(currentFocus, DisplayObject), true);
				}
			}
			if(newFocus == null)
			{
				newFocus = this.findNextContainerFocus(this._root, null, false);
			}
		}
		if(newFocus != null)
		{
#if flash
			event.preventDefault();
#end
		}
		this.focus = newFocus;
		if(this._focus != null)
		{
			this._focus.showFocus();
		}

	}

	/**
	 * @private
	 */
	private function topLevelContainer_addedHandler(event:Event):Void
	{
		this.setFocusManager(cast event.target);

	}

	/**
	 * @private
	 */
	private function topLevelContainer_removedHandler(event:Event):Void
	{
		this.clearFocusManager(cast event.target);
	}

	/**
	 * @private
	 */
	private function topLevelContainer_touchHandler(event:TouchEvent):Void
	{
		var touch:Touch = event.getTouch(this._root, TouchPhase.BEGAN);
		if(touch == null)
		{
			return;
		}

		var focusTarget:IFocusDisplayObject = null;
		var target:DisplayObject = touch.target;
		do
		{
			if(Std.is(target, IFocusDisplayObject))
			{
				var tempFocusTarget:IFocusDisplayObject = cast target;
				if(this.isValidFocus(tempFocusTarget))
				{
					if(focusTarget == null || !Std.is(tempFocusTarget, IFocusContainer) || !(cast(tempFocusTarget, IFocusContainer).isChildFocusEnabled))
					{
						focusTarget = tempFocusTarget;
					}
				}
			}
			target = target.parent;
		}
		while (target != null);
		this.focus = focusTarget;
	}

	/**
	 * @private
	 */
	private function nativeFocus_focusOutHandler(event:FocusEvent):Void
	{
		var nativeFocus:InteractiveObject = cast event.currentTarget;
		var nativeStage:Stage = this._starling.nativeStage;
		if(this._focus != null && nativeStage.focus == null)
		{
			//if there's still a feathers focus, but the native stage object has
			//lost focus for some reason, and there's no focus at all, force it
			//back into focus.
			//this can happen on app deactivate!
			nativeStage.focus = nativeFocus;
		}
		if(nativeFocus != nativeStage.focus)
		{
			//otherwise, we should stop listening for this event
			nativeFocus.removeEventListener(FocusEvent.FOCUS_OUT, nativeFocus_focusOutHandler);
		}
	}
}

class NativeFocusTarget extends Sprite
{
	public function new()
	{
		super();
		this.tabEnabled = true;
		this.mouseEnabled = false;
		this.mouseChildren = false;
		this.alpha = 0;
	}

	public var referenceCount:Int = 1;
}