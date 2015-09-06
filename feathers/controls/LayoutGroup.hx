/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.IValidating;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.ILayoutDisplayObject;
import feathers.layout.IVirtualLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.ViewPortBounds;
import feathers.skins.IStyleProvider;

import flash.geom.Point;
import flash.geom.Rectangle;

import starling.core.RenderSupport;
import starling.display.DisplayObject;
import starling.events.Event;

import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_LAYOUT;

/**
 * A generic container that supports layout. For a container that supports
 * scrolling and more robust skinning options, see <code>ScrollContainer</code>.
 *
 * <p>The following example creates a layout group with a horizontal
 * layout and adds two buttons to it:</p>
 *
 * <listing version="3.0">
 * var group:LayoutGroup = new LayoutGroup();
 * var layout:HorizontalLayout = new HorizontalLayout();
 * layout.gap = 20;
 * layout.padding = 20;
 * group.layout = layout;
 * this.addChild( group );
 * 
 * var yesButton:Button = new Button();
 * yesButton.label = "Yes";
 * group.addChild( yesButton );
 * 
 * var noButton:Button = new Button();
 * noButton.label = "No";
 * group.addChild( noButton );</listing>
 *
 * @see ../../../help/layout-group.html How to use the Feathers LayoutGroup component
 * @see feathers.controls.ScrollContainer
 */
class LayoutGroup extends FeathersControl
{
	/**
	 * @private
	 */
	private static var HELPER_RECTANGLE:Rectangle = new Rectangle();

	/**
	 * Flag to indicate that the clipping has changed.
	 */
	inline private static var INVALIDATION_FLAG_CLIPPING:String = "clipping";

	/**
	 * The layout group will auto size itself to fill the entire stage.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_STAGE:String = "stage";

	/**
	 * The layout group will auto size itself to fit its content.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_CONTENT:String = "content";

	/**
	 * An alternate style name to use with <code>LayoutGroup</code> to
	 * allow a theme to give it a toolbar style. If a theme does not provide
	 * a style for the toolbar container, the theme will automatically fall
	 * back to using the default scroll container skin.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the toolbar style is applied to a layout
	 * group:</p>
	 *
	 * <listing version="3.0">
	 * var group:LayoutGroup = new LayoutGroup();
	 * group.styleNameList.add( LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR );
	 * this.addChild( group );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-layout-group";

	/**
	 * The default <code>IStyleProvider</code> for all <code>LayoutGroup</code>
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
		this.addEventListener(Event.ADDED_TO_STAGE, layoutGroup_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, layoutGroup_removedFromStageHandler);
	}

	/**
	 * The items added to the group.
	 */
	private var items:Array<DisplayObject> = new Array();

	/**
	 * The view port bounds result object passed to the layout. Its values
	 * should be set in <code>refreshViewPortBounds()</code>.
	 */
	private var viewPortBounds:ViewPortBounds = new ViewPortBounds();

	/**
	 * @private
	 */
	private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return LayoutGroup.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _layout:ILayout;

	/**
	 * Controls the way that the group's children are positioned and sized.
	 *
	 * <p>The following example tells the group to use a horizontal layout:</p>
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
		if(this._layout != null)
		{
			this._layout.removeEventListener(Event.CHANGE, layout_changeHandler);
		}
		this._layout = value;
		if(this._layout != null)
		{
			if(Std.is(this._layout, IVirtualLayout))
			{
				cast(this._layout, IVirtualLayout).useVirtualLayout = false;
			}
			this._layout.addEventListener(Event.CHANGE, layout_changeHandler);
			//if we don't have a layout, nothing will need to be redrawn
			this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_layout();
	}

	/**
	 * @private
	 */
	private var _clipContent:Bool = false;

	/**
	 * If true, the group will be clipped to its bounds. In other words,
	 * anything appearing beyond the edges of the group will be masked or
	 * hidden.
	 *
	 * <p>Since <code>LayoutGroup</code> is designed to be a light
	 * container focused on performance, clipping is disabled by default.</p>
	 *
	 * <p>In the following example, clipping is enabled:</p>
	 *
	 * <listing version="3.0">
	 * group.clipContent = true;</listing>
	 *
	 * @default false
	 */
	public var clipContent(get, set):Bool;
	public function get_clipContent():Bool
	{
		return this._clipContent;
	}

	/**
	 * @private
	 */
	public function set_clipContent(value:Bool):Bool
	{
		if(this._clipContent == value)
		{
			return get_clipContent();
		}
		this._clipContent = value;
		if(!value)
		{
			this.clipRect = null;
		}
		this.invalidate(INVALIDATION_FLAG_CLIPPING);
		return get_clipContent();
	}

	/**
	 * @private
	 */
	private var originalBackgroundWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var originalBackgroundHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var currentBackgroundSkin:DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * The default background to display behind all content. The background
	 * skin is resized to fill the full width and height of the layout
	 * group.
	 *
	 * <p>In the following example, the group is given a background skin:</p>
	 *
	 * <listing version="3.0">
	 * group.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundSkin(get, set):DisplayObject;
	public function get_backgroundSkin():DisplayObject
	{
		return this._backgroundSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundSkin == value)
		{
			return get_backgroundSkin();
		}
		if(value != null && value.parent != null)
		{
			value.removeFromParent();
		}
		this._backgroundSkin = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_backgroundSkin();
	}

	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * The background to display behind all content when the layout group is
	 * disabled. The background skin is resized to fill the full width and
	 * height of the layout group.
	 *
	 * <p>In the following example, the group is given a background skin:</p>
	 *
	 * <listing version="3.0">
	 * group.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundDisabledSkin(get, set):DisplayObject;
	public function get_backgroundDisabledSkin():DisplayObject
	{
		return this._backgroundDisabledSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundDisabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundDisabledSkin == value)
		{
			return get_backgroundDisabledSkin();
		}
		if(value != null && value.parent != null)
		{
			value.removeFromParent();
		}
		this._backgroundDisabledSkin = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_backgroundDisabledSkin();
	}

	/**
	 * @private
	 */
	private var _autoSizeMode:String = AUTO_SIZE_MODE_CONTENT;

	#if 0
	[Inspectable(type="String",enumeration="stage,content")]
	#end
	/**
	 * Determines how the layout group will set its own size when its
	 * dimensions (width and height) aren't set explicitly.
	 *
	 * <p>In the following example, the layout group will be sized to
	 * match the stage:</p>
	 *
	 * <listing version="3.0">
	 * group.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;</listing>
	 *
	 * @default LayoutGroup.AUTO_SIZE_MODE_CONTENT
	 *
	 * @see #AUTO_SIZE_MODE_STAGE
	 * @see #AUTO_SIZE_MODE_CONTENT
	 */
	public var autoSizeMode(get, set):String;
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
	override public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		if(Std.is(child, IFeathersControl))
		{
			child.addEventListener(FeathersEventType.RESIZE, child_resizeHandler);
		}
		if(Std.is(child, ILayoutDisplayObject))
		{
			child.addEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
		}
		var oldIndex:Int = this.items.indexOf(child);
		if(oldIndex == index)
		{
			return child;
		}
		if(oldIndex >= 0)
		{
			this.items.splice(oldIndex, 1);
		}
		var itemCount:Int = this.items.length;
		if(index == itemCount)
		{
			//faster than splice because it avoids gc
			this.items[index] = child;
		}
		else
		{
			this.items.insert(index, child);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return super.addChildAt(child, index);
	}

	/**
	 * @private
	 */
	override public function removeChildAt(index:Int, dispose:Bool = false):DisplayObject
	{
		var child:DisplayObject = super.removeChildAt(index, dispose);
		if(Std.is(child, IFeathersControl))
		{
			child.removeEventListener(FeathersEventType.RESIZE, child_resizeHandler);
		}
		if(Std.is(child, ILayoutDisplayObject))
		{
			child.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
		}
		this.items.splice(index, 1);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return child;
	}

	/**
	 * @private
	 */
	override public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		super.setChildIndex(child, index);
		var oldIndex:Int = this.items.indexOf(child);
		if(oldIndex == index)
		{
			return;
		}

		//the super function already checks if oldIndex < 0, and throws an
		//appropriate error, so no need to do it again!

		this.items.splice(oldIndex, 1);
		this.items.insert(index, child);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	/**
	 * @private
	 */
	override public function swapChildrenAt(index1:Int, index2:Int):Void
	{
		super.swapChildrenAt(index1, index2);
		var child1:DisplayObject = this.items[index1];
		var child2:DisplayObject = this.items[index2];
		this.items[index1] = child2;
		this.items[index2] = child1;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	/**
	 * @private
	 */
	override public function sortChildren(compareFunction:Dynamic):Void
	{
		super.sortChildren(compareFunction);
		this.items.sort(compareFunction);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	/**
	 * @private
	 */
	override public function hitTest(localPoint:Point, forTouch:Bool = false):DisplayObject
	{
		var localX:Float = localPoint.x;
		var localY:Float = localPoint.y;
		var result:DisplayObject = super.hitTest(localPoint, forTouch);
		if(result != null)
		{
			if(!this._isEnabled)
			{
				return this;
			}
			return result;
		}
		if(forTouch && (!this.visible || !this.touchable))
		{
			return null;
		}
		if(this.currentBackgroundSkin != null && this._hitArea.contains(localX, localY))
		{
			return this;
		}
		return null;
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		if(this.currentBackgroundSkin != null && this.currentBackgroundSkin.hasVisibleArea)
		{
			var clipRect:Rectangle = this.clipRect;
			if(clipRect != null)
			{
				clipRect = support.pushClipRect(this.getClipRect(stage, HELPER_RECTANGLE));
				if(clipRect.isEmpty())
				{
					// empty clipping bounds - no need to render children.
					support.popClipRect();
					return;
				}
			}
			var blendMode:String = this.blendMode;
			support.pushMatrix();
			support.transformMatrix(this.currentBackgroundSkin);
			support.blendMode = this.currentBackgroundSkin.blendMode;
			this.currentBackgroundSkin.render(support, parentAlpha * this.alpha);
			support.blendMode = blendMode;
			support.popMatrix();
			if(clipRect != null)
			{
				support.popClipRect();
			}
		}
		super.render(support, parentAlpha);
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		this.layout = null;
		super.dispose();
	}

	/**
	 * Readjusts the layout of the group according to its current content.
	 * Call this method when changes to the content cannot be automatically
	 * detected by the container. For instance, Feathers components dispatch
	 * <code>FeathersEventType.RESIZE</code> when their width and height
	 * values change, but standard Starling display objects like
	 * <code>Sprite</code> and <code>Image</code> do not.
	 */
	public function readjustLayout():Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var layoutInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var clippingInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
		//we don't have scrolling, but a subclass might
		var scrollInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SCROLL);
		var skinInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SKIN);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);

		//scrolling only affects the layout is requiresLayoutOnScroll is true
		if(!layoutInvalid && scrollInvalid && this._layout != null && this._layout.requiresLayoutOnScroll)
		{
			layoutInvalid = true;
		}

		if(skinInvalid || stateInvalid)
		{
			this.refreshBackgroundSkin();
		}

		if(sizeInvalid || layoutInvalid || skinInvalid || stateInvalid)
		{
			this.refreshViewPortBounds();
			if(this._layout != null)
			{
				var oldIgnoreChildChanges:Bool = this._ignoreChildChanges;
				this._ignoreChildChanges = true;
				this._layout.layout(this.items, this.viewPortBounds, this._layoutResult);
				this._ignoreChildChanges = oldIgnoreChildChanges;
			}
			else
			{
				this.handleManualLayout();
			}
			var width:Float = this._layoutResult.contentWidth;
			if(this.originalBackgroundWidth == this.originalBackgroundWidth && //!isNaN
				this.originalBackgroundWidth > width)
			{
				width = this.originalBackgroundWidth;
			}
			var height:Float = this._layoutResult.contentHeight;
			if(this.originalBackgroundHeight == this.originalBackgroundHeight && //!isNaN
				this.originalBackgroundHeight > height)
			{
				height = this.originalBackgroundHeight;
			}
			if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
			{
				width = this.stage.stageWidth;
				height = this.stage.stageHeight;
			}
			sizeInvalid = this.setSizeInternal(width, height, false) || sizeInvalid;
			if(this.currentBackgroundSkin != null)
			{
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
			}

			//final validation to avoid juggler next frame issues
			this.validateChildren();
		}

		if(sizeInvalid || clippingInvalid)
		{
			this.refreshClipRect();
		}
	}

	/**
	 * Choose the appropriate background skin based on the control's current
	 * state.
	 */
	private function refreshBackgroundSkin():Void
	{
		if(!this._isEnabled && this._backgroundDisabledSkin != null)
		{
			this.currentBackgroundSkin = this._backgroundDisabledSkin;
		}
		else
		{
			this.currentBackgroundSkin = this._backgroundSkin;
		}
		if(this.currentBackgroundSkin != null)
		{
			if(this.originalBackgroundWidth != this.originalBackgroundWidth ||
				this.originalBackgroundHeight != this.originalBackgroundHeight) //isNaN
			{
				if(Std.is(this.currentBackgroundSkin, IValidating))
				{
					cast(this.currentBackgroundSkin, IValidating).validate();
				}
				this.originalBackgroundWidth = this.currentBackgroundSkin.width;
				this.originalBackgroundHeight = this.currentBackgroundSkin.height;
			}
		}
	}

	/**
	 * Refreshes the values in the <code>viewPortBounds</code> variable that
	 * is passed to the layout.
	 */
	private function refreshViewPortBounds():Void
	{
		this.viewPortBounds.x = 0;
		this.viewPortBounds.y = 0;
		this.viewPortBounds.scrollX = 0;
		this.viewPortBounds.scrollY = 0;
		if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE &&
			this.explicitWidth != this.explicitWidth)
		{
			this.viewPortBounds.explicitWidth = this.stage.stageWidth;
		}
		else
		{
			this.viewPortBounds.explicitWidth = this.explicitWidth;
		}
		if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE &&
				this.explicitHeight != this.explicitHeight)
		{
			this.viewPortBounds.explicitHeight = this.stage.stageHeight;
		}
		else
		{
			this.viewPortBounds.explicitHeight = this.explicitHeight;
		}
		this.viewPortBounds.minWidth = this._minWidth;
		this.viewPortBounds.minHeight = this._minHeight;
		this.viewPortBounds.maxWidth = this._maxWidth;
		this.viewPortBounds.maxHeight = this._maxHeight;
	}

	/**
	 * @private
	 */
	private function handleManualLayout():Void
	{
		var maxX:Float = this.viewPortBounds.explicitWidth;
		if(maxX != maxX) //isNaN
		{
			maxX = 0;
		}
		var maxY:Float = this.viewPortBounds.explicitHeight;
		if(maxY != maxY) //isNaN
		{
			maxY = 0;
		}
		var oldIgnoreChildChanges:Bool = this._ignoreChildChanges;
		this._ignoreChildChanges = true;
		var itemCount:Int = this.items.length;
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = this.items[i];
			if(Std.is(item, ILayoutDisplayObject) && !cast(item, ILayoutDisplayObject).includeInLayout)
			{
				continue;
			}
			if(Std.is(item, IValidating))
			{
				cast(item, IValidating).validate();
			}
			var itemMaxX:Float = item.x + item.width;
			var itemMaxY:Float = item.y + item.height;
			if(itemMaxX == itemMaxX && //!isNaN
				itemMaxX > maxX)
			{
				maxX = itemMaxX;
			}
			if(itemMaxY == itemMaxY && //!isNaN
				itemMaxY > maxY)
			{
				maxY = itemMaxY;
			}
		}
		this._ignoreChildChanges = oldIgnoreChildChanges;
		this._layoutResult.contentX = 0;
		this._layoutResult.contentY = 0;
		this._layoutResult.contentWidth = maxX;
		this._layoutResult.contentHeight = maxY;
		this._layoutResult.viewPortWidth = maxX;
		this._layoutResult.viewPortHeight = maxY;
	}

	/**
	 * @private
	 */
	private function validateChildren():Void
	{
		if(Std.is(this.currentBackgroundSkin, IValidating))
		{
			cast(this.currentBackgroundSkin, IValidating).validate();
		}
		var itemCount:Int = this.items.length;
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = this.items[i];
			if(Std.is(item, IValidating))
			{
				cast(item, IValidating).validate();
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshClipRect():Void
	{
		if(!this._clipContent)
		{
			return;
		}

		var clipRect:Rectangle = this.clipRect;
		if(clipRect == null)
		{
			clipRect = new Rectangle();
		}
		clipRect.x = 0;
		clipRect.y = 0;
		clipRect.width = this.actualWidth;
		clipRect.height = this.actualHeight;
		this.clipRect = clipRect;
	}

	/**
	 * @private
	 */
	private function layoutGroup_addedToStageHandler(event:Event):Void
	{
		if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
		{
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
	}

	/**
	 * @private
	 */
	private function layoutGroup_removedFromStageHandler(event:Event):Void
	{
		this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
	}

	/**
	 * @private
	 */
	private function layout_changeHandler(event:Event):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	/**
	 * @private
	 */
	private function stage_resizeHandler(event:Event):Void
	{
		this.invalidate(INVALIDATION_FLAG_LAYOUT);
	}
}
