/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.supportClasses.LayoutViewPort;
import feathers.core.IFeathersControl;
import feathers.core.IFocusContainer;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.ILayoutDisplayObject;
import feathers.layout.IVirtualLayout;
import feathers.skins.IStyleProvider;

import openfl.errors.ArgumentError;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;

import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_LAYOUT;

/**
 * Dispatched when the container is scrolled.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.SCROLL
 *///[Event(name="change",type="starling.events.Event")]

/**
 * A generic container that supports layout, scrolling, and a background
 * skin. For a lighter container, see <code>LayoutGroup</code>, which
 * focuses specifically on layout without scrolling.
 *
 * <p>The following example creates a scroll container with a horizontal
 * layout and adds two buttons to it:</p>
 *
 * <listing version="3.0">
 * var container:ScrollContainer = new ScrollContainer();
 * var layout:HorizontalLayout = new HorizontalLayout();
 * layout.gap = 20;
 * layout.padding = 20;
 * container.layout = layout;
 * this.addChild( container );
 * 
 * var yesButton:Button = new Button();
 * yesButton.label = "Yes";
 * container.addChild( yesButton );
 * 
 * var noButton:Button = new Button();
 * noButton.label = "No";
 * container.addChild( noButton );</listing>
 *
 * @see ../../../help/scroll-container.html How to use the Feathers ScrollContainer component
 * @see feathers.controls.LayoutGroup
 */
class ScrollContainer extends Scroller implements IScrollContainer implements IFocusContainer
{
	/**
	 * An alternate style name to use with <code>ScrollContainer</code> to
	 * allow a theme to give it a toolbar style. If a theme does not provide
	 * a style for the toolbar container, the theme will automatically fall
	 * back to using the default scroll container skin.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the toolbar style is applied to a scroll
	 * container:</p>
	 *
	 * <listing version="3.0">
	 * var container:ScrollContainer = new ScrollContainer();
	 * container.styleNameList.add( ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR );
	 * this.addChild( container );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-scroll-container";

	/**
	 * DEPRECATED: Replaced by <code>ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see ScrollContainer#ALTERNATE_STYLE_NAME_TOOLBAR
	 */
	inline public static var ALTERNATE_NAME_TOOLBAR:String = ALTERNATE_STYLE_NAME_TOOLBAR;

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_AUTO:String = "auto";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_ON:String = "on";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_OFF:String = "off";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT:String = "fixedFloat";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

	/**
	 * The vertical scroll bar will be positioned on the right.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

	/**
	 * The vertical scroll bar will be positioned on the left.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH:String = "touch";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_MOUSE:String = "mouse";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

	/**
	 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

	/**
	 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_NORMAL:Float = 0.998;

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_FAST:Float = 0.99;

	/**
	 * The container will auto size itself to fill the entire stage.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_STAGE:String = "stage";

	/**
	 * The container will auto size itself to fit its content.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_CONTENT:String = "content";

	/**
	 * The default <code>IStyleProvider</code> for all <code>ScrollContainer</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.layoutViewPort = new LayoutViewPort();
		this.viewPort = this.layoutViewPort;
		this.addEventListener(Event.ADDED_TO_STAGE, scrollContainer_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, scrollContainer_removedFromStageHandler);
	}

	/**
	 * A flag that indicates if the display list functions like <code>addChild()</code>
	 * and <code>removeChild()</code> will be passed to the internal view
	 * port.
	 */
	private var displayListBypassEnabled:Bool = true;

	/**
	 * @private
	 */
	private var layoutViewPort:LayoutViewPort;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ScrollContainer.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _isChildFocusEnabled:Bool = true;

	/**
	 * @copy feathers.core.IFocusContainer#isChildFocusEnabled
	 *
	 * @default true
	 *
	 * @see #isFocusEnabled
	 */
	public var isChildFocusEnabled(get, set):Bool;
	public function get_isChildFocusEnabled():Bool
	{
		return this._isEnabled && this._isChildFocusEnabled;
	}

	/**
	 * @private
	 */
	public function set_isChildFocusEnabled(value:Bool):Bool
	{
		this._isChildFocusEnabled = value;
		return get_isChildFocusEnabled();
	}

	/**
	 * @private
	 */
	private var _layout:ILayout;

	/**
	 * Controls the way that the container's children are positioned and
	 * sized.
	 *
	 * <p>The following example tells the container to use a horizontal layout:</p>
	 *
	 * <listing version="3.0">
	 * var layout:HorizontalLayout = new HorizontalLayout();
	 * layout.gap = 20;
	 * layout.padding = 20;
	 * container.layout = layout;</listing>
	 *
	 * @default null
	 */
	public var layout(get, set):ILayout;
	public function get_layout():ILayout
	{
		return this._layout;
	}

	/**
	 * @private
	 */
	public function set_layout(value:ILayout):ILayout
	{
		if(this._layout == value)
		{
			return get_layout();
		}
		this._layout = value;
		this.invalidate(INVALIDATION_FLAG_LAYOUT);
		return get_layout();
	}

	/**
	 * @private
	 */
	private var _autoSizeMode:String = AUTO_SIZE_MODE_CONTENT;

	#if 0
	[Inspectable(type="String",enumeration="stage,content")]
	#end
	/**
	 * Determines how the container will set its own size when its
	 * dimensions (width and height) aren't set explicitly.
	 *
	 * <p>In the following example, the container will be sized to
	 * match the stage:</p>
	 *
	 * <listing version="3.0">
	 * container.autoSizeMode = ScrollContainer.AUTO_SIZE_MODE_STAGE;</listing>
	 *
	 * @default ScrollContainer.AUTO_SIZE_MODE_CONTENT
	 *
	 * @see #AUTO_SIZE_MODE_STAGE
	 * @see #AUTO_SIZE_MODE_CONTENT
	 */
	public function get_autoSizeMode():String
	{
		return this._autoSizeMode;
	}

	/**
	 * @private
	 */
	public function set_autoSizeMode(value:String):String
	{
		if(this._autoSizeMode == value)
		{
			return get_autoSizeMode();
		}
		this._autoSizeMode = value;
		this._measureViewPort = this._autoSizeMode != AUTO_SIZE_MODE_STAGE;
		if(this.stage != null)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
			{
				this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			}
			else
			{
				this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
			}
		}
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return get_autoSizeMode();
	}

	/**
	 * @private
	 */
	private var _ignoreChildChanges:Bool = false;

	/**
	 * @private
	 */
	override public function get_numChildren():Int
	{
		if(!this.displayListBypassEnabled)
		{
			return super.numChildren;
		}
		return cast(this.viewPort, DisplayObjectContainer).numChildren;
	}

	/**
	 * @inheritDoc
	 */
	public var numRawChildren(get, never):Int;
	public function get_numRawChildren():Int
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var result:Int = super.numChildren;
		this.displayListBypassEnabled = oldBypass;
		return result;
	}

	/**
	 * @private
	 */
	override public function getChildByName(name:String):DisplayObject
	{
		if(!this.displayListBypassEnabled)
		{
			return super.getChildByName(name);
		}
		return cast(this.viewPort, DisplayObjectContainer).getChildByName(name);
	}

	/**
	 * @inheritDoc
	 */
	public function getRawChildByName(name:String):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var child:DisplayObject = super.getChildByName(name);
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @private
	 */
	override public function getChildAt(index:Int):DisplayObject
	{
		if(!this.displayListBypassEnabled)
		{
			return super.getChildAt(index);
		}
		return cast(this.viewPort, DisplayObjectContainer).getChildAt(index);
	}

	/**
	 * @inheritDoc
	 */
	public function getRawChildAt(index:Int):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var child:DisplayObject = super.getChildAt(index);
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @inheritDoc
	 */
	public function addRawChild(child:DisplayObject):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		if(child.parent == this)
		{
			super.setChildIndex(child, super.numChildren);
		}
		else
		{
			child = super.addChildAt(child, super.numChildren);
		}
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @private
	 */
	override public function addChild(child:DisplayObject):DisplayObject
	{
		return this.addChildAt(child, this.numChildren);
	}

	/**
	 * @private
	 */
	override public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		if(!this.displayListBypassEnabled)
		{
			return super.addChildAt(child, index);
		}
		var result:DisplayObject = cast(this.viewPort, DisplayObjectContainer).addChildAt(child, index);
		if(Std.is(result, IFeathersControl))
		{
			result.addEventListener(Event.RESIZE, child_resizeHandler);
		}
		if(Std.is(result, ILayoutDisplayObject))
		{
			result.addEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
		}
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function addRawChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		child = super.addChildAt(child, index);
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @inheritDoc
	 */
	public function removeRawChild(child:DisplayObject, dispose:Bool = false):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var index:Int = super.getChildIndex(child);
		if(index >= 0)
		{
			super.removeChildAt(index, dispose);
		}
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @private
	 */
	override public function removeChildAt(index:Int, dispose:Bool = false):DisplayObject
	{
		if(!this.displayListBypassEnabled)
		{
			return super.removeChildAt(index, dispose);
		}
		var result:DisplayObject = cast(this.viewPort, DisplayObjectContainer).removeChildAt(index, dispose);
		if(Std.is(result, IFeathersControl))
		{
			result.removeEventListener(Event.RESIZE, child_resizeHandler);
		}
		if(Std.is(result, ILayoutDisplayObject))
		{
			result.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
		}
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function removeRawChildAt(index:Int, dispose:Bool = false):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var child:DisplayObject =  super.removeChildAt(index, dispose);
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @private
	 */
	override public function getChildIndex(child:DisplayObject):Int
	{
		if(!this.displayListBypassEnabled)
		{
			return super.getChildIndex(child);
		}
		return cast(this.viewPort, DisplayObjectContainer).getChildIndex(child);
	}

	/**
	 * @inheritDoc
	 */
	public function getRawChildIndex(child:DisplayObject):Int
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var index:Int = super.getChildIndex(child);
		this.displayListBypassEnabled = oldBypass;
		return index;
	}

	/**
	 * @private
	 */
	override public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		if(!this.displayListBypassEnabled)
		{
			super.setChildIndex(child, index);
			return;
		}
		cast(this.viewPort, DisplayObjectContainer).setChildIndex(child, index);
	}

	/**
	 * @inheritDoc
	 */
	public function setRawChildIndex(child:DisplayObject, index:Int):Void
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		super.setChildIndex(child, index);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * @inheritDoc
	 */
	public function swapRawChildren(child1:DisplayObject, child2:DisplayObject):Void
	{
		var index1:Int = this.getRawChildIndex(child1);
		var index2:Int = this.getRawChildIndex(child2);
		if(index1 < 0 || index2 < 0)
		{
			throw new ArgumentError("Not a child of this container");
		}
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		this.swapRawChildrenAt(index1, index2);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * @private
	 */
	override public function swapChildrenAt(index1:Int, index2:Int):Void
	{
		if(!this.displayListBypassEnabled)
		{
			super.swapChildrenAt(index1, index2);
			return;
		}
		cast(this.viewPort, DisplayObjectContainer).swapChildrenAt(index1, index2);
	}

	/**
	 * @inheritDoc
	 */
	public function swapRawChildrenAt(index1:Int, index2:Int):Void
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		super.swapChildrenAt(index1, index2);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * @private
	 */
	override public function sortChildren(compareFunction:Dynamic):Void
	{
		if(!this.displayListBypassEnabled)
		{
			super.sortChildren(compareFunction);
			return;
		}
		cast(this.viewPort, DisplayObjectContainer).sortChildren(compareFunction);
	}

	/**
	 * @inheritDoc
	 */
	public function sortRawChildren(compareFunction:Dynamic):Void
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		super.sortChildren(compareFunction);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * Readjusts the layout of the container according to its current
	 * content. Call this method when changes to the content cannot be
	 * automatically detected by the container. For instance, Feathers
	 * components dispatch <code>FeathersEventType.RESIZE</code> when their
	 * width and height values change, but standard Starling display objects
	 * like <code>Sprite</code> and <code>Image</code> do not.
	 */
	public function readjustLayout():Void
	{
		this.layoutViewPort.readjustLayout();
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var layoutInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

		if(layoutInvalid)
		{
			if(Std.is(this._layout, IVirtualLayout))
			{
				cast(this._layout, IVirtualLayout).useVirtualLayout = false;
			}
			this.layoutViewPort.layout = this._layout;
		}

		var oldIgnoreChildChanges:Bool = this._ignoreChildChanges;
		this._ignoreChildChanges = true;
		super.draw();
		this._ignoreChildChanges = oldIgnoreChildChanges;
	}

	/**
	 * @private
	 */
	override private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
		{
			return this.setSizeInternal(this.stage.stageWidth, this.stage.stageHeight, false);
		}
		return super.autoSizeIfNeeded();
	}

	/**
	 * @private
	 */
	private function scrollContainer_addedToStageHandler(event:Event):Void
	{
		if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
		{
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
	}

	/**
	 * @private
	 */
	private function scrollContainer_removedFromStageHandler(event:Event):Void
	{
		this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
	}

	/**
	 * @private
	 */
	private function child_resizeHandler(event:Event):Void
	{
		if(this._ignoreChildChanges)
		{
			return;
		}
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function child_layoutDataChangeHandler(event:Event):Void
	{
		if(this._ignoreChildChanges)
		{
			return;
		}
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function stage_resizeHandler(event:Event):Void
	{
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}
}
