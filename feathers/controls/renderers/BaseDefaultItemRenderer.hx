/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers;
import feathers.controls.Button;
import feathers.controls.ImageLoader;
import feathers.controls.Scroller;
import feathers.controls.ToggleButton;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.IFocusContainer;
import feathers.core.ITextRenderer;
import feathers.core.IValidating;
import feathers.core.PropertyProxy;
import feathers.events.FeathersEventType;
import feathers.utils.type.SafeCast.safe_cast;

import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.utils.Timer;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * An abstract class for item renderer implementations.
 */
public class BaseDefaultItemRenderer extends ToggleButton implements IFocusContainer
{
	/**
	 * The default value added to the <code>styleNameList</code> of the icon
	 * label, if it exists.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";

	/**
	 * DEPRECATED: Replaced by <code>BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ICON_LABEL</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_ICON_LABEL
	 */
	inline public static var DEFAULT_CHILD_NAME_ICON_LABEL:String = DEFAULT_CHILD_STYLE_NAME_ICON_LABEL;

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * accessory label, if it exists.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";

	/**
	 * DEPRECATED: Replaced by <code>BaseDefaultItemRenderer.DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see BaseDefaultItemRenderer#DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL
	 */
	inline public static var DEFAULT_CHILD_NAME_ACCESSORY_LABEL:String = DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL;

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_TOP
	 *
	 * @see feathers.controls.Button#iconPosition
	 */
	inline public static var ICON_POSITION_TOP:String = "top";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_RIGHT
	 *
	 * @see feathers.controls.Button#iconPosition
	 */
	inline public static var ICON_POSITION_RIGHT:String = "right";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_BOTTOM
	 *
	 * @see feathers.controls.Button#iconPosition
	 */
	inline public static var ICON_POSITION_BOTTOM:String = "bottom";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_LEFT
	 *
	 * @see feathers.controls.Button#iconPosition
	 */
	inline public static var ICON_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_MANUAL
	 *
	 * @see feathers.controls.Button#iconPosition
	 * @see feathers.controls.Button#iconOffsetX
	 * @see feathers.controls.Button#iconOffsetY
	 */
	inline public static var ICON_POSITION_MANUAL:String = "manual";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_LEFT_BASELINE
	 *
	 * @see feathers.controls.Button#iconPosition
	 */
	inline public static var ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";

	/**
	 * @copy feathers.controls.Button#ICON_POSITION_RIGHT_BASELINE
	 *
	 * @see feathers.controls.Button#iconPosition
	 */
	inline public static var ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";

	/**
	 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_LEFT
	 *
	 * @see feathers.controls.Button#horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_CENTER
	 *
	 * @see feathers.controls.Button#horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_RIGHT
	 *
	 * @see feathers.controls.Button#horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * @copy feathers.controls.Button#VERTICAL_ALIGN_TOP
	 *
	 * @see feathers.controls.Button#verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * @copy feathers.controls.Button#VERTICAL_ALIGN_MIDDLE
	 *
	 * @see feathers.controls.Button#verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * @copy feathers.controls.Button#VERTICAL_ALIGN_BOTTOM
	 *
	 * @see feathers.controls.Button#verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * The accessory will be positioned above its origin.
	 *
	 * @see #accessoryPosition
	 */
	inline public static var ACCESSORY_POSITION_TOP:String = "top";

	/**
	 * The accessory will be positioned to the right of its origin.
	 *
	 * @see #accessoryPosition
	 */
	inline public static var ACCESSORY_POSITION_RIGHT:String = "right";

	/**
	 * The accessory will be positioned below its origin.
	 *
	 * @see #accessoryPosition
	 */
	inline public static var ACCESSORY_POSITION_BOTTOM:String = "bottom";

	/**
	 * The accessory will be positioned to the left of its origin.
	 *
	 * @see #accessoryPosition
	 */
	inline public static var ACCESSORY_POSITION_LEFT:String = "left";

	/**
	 * The accessory will be positioned manually with no relation to another
	 * child. Use <code>accessoryOffsetX</code> and <code>accessoryOffsetY</code>
	 * to set the accessory position.
	 *
	 * <p>The <code>accessoryPositionOrigin</code> property will be ignored
	 * if <code>accessoryPosition</code> is set to <code>ACCESSORY_POSITION_MANUAL</code>.</p>
	 *
	 * @see #accessoryPosition
	 * @see #accessoryOffsetX
	 * @see #accessoryOffsetY
	 */
	inline public static var ACCESSORY_POSITION_MANUAL:String = "manual";

	/**
	 * The layout order will be the label first, then the accessory relative
	 * to the label, then the icon relative to both. Best used when the
	 * accessory should be between the label and the icon or when the icon
	 * position shouldn't be affected by the accessory.
	 *
	 * @see #layoutOrder
	 */
	inline public static var LAYOUT_ORDER_LABEL_ACCESSORY_ICON:String = "labelAccessoryIcon";

	/**
	 * The layout order will be the label first, then the icon relative to
	 * label, then the accessory relative to both.
	 *
	 * @see #layoutOrder
	 */
	inline public static var LAYOUT_ORDER_LABEL_ICON_ACCESSORY:String = "labelIconAccessory";

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	private static var DOWN_STATE_DELAY_MS:Int = 250;

	/**
	 * @private
	 */
	private static function defaultLoaderFactory():ImageLoader
	{
		return new ImageLoader();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.isFocusEnabled = false;
		this.isQuickHitAreaEnabled = false;
		this.addEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
	}

	/**
	 * The value added to the <code>styleNameList</code> of the icon label
	 * text renderer, if it exists.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var iconLabelStyleName:String = DEFAULT_CHILD_STYLE_NAME_ICON_LABEL;

	/**
	 * DEPRECATED: Replaced by <code>iconLabelStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #iconLabelStyleName
	 */
	private function get iconLabelName():String
	{
		return this.iconLabelStyleName;
	}

	/**
	 * @private
	 */
	private function set iconLabelName(value:String):void
	{
		this.iconLabelStyleName = value;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the accessory
	 * label text renderer, if it exists.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var accessoryLabelStyleName:String = DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL;

	/**
	 * DEPRECATED: Replaced by <code>accessoryLabelStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #accessoryLabelStyleName
	 */
	private function get accessoryLabelName():String
	{
		return this.accessoryLabelStyleName;
	}

	/**
	 * @private
	 */
	private function set accessoryLabelName(value:String):void
	{
		this.accessoryLabelStyleName = value;
	}

	/**
	 * @private
	 */
	private var _isChildFocusEnabled:Boolean = true;

	/**
	 * @copy feathers.core.IFocusContainer#isChildFocusEnabled
	 *
	 * @default true
	 *
	 * @see #isFocusEnabled
	 */
	public function get isChildFocusEnabled():Boolean
	{
		return this._isEnabled && this._isChildFocusEnabled;
	}

	/**
	 * @private
	 */
	public function set isChildFocusEnabled(value:Boolean):void
	{
		this._isChildFocusEnabled = value;
	}

	/**
	 * @private
	 */
	private var skinLoader:ImageLoader;

	/**
	 * @private
	 */
	private var iconLoader:ImageLoader;

	/**
	 * @private
	 */
	private var iconLabel:ITextRenderer;

	/**
	 * @private
	 */
	private var accessoryLoader:ImageLoader;

	/**
	 * @private
	 */
	private var accessoryLabel:ITextRenderer;

	/**
	 * @private
	 */
	private var accessory:DisplayObject;

	/**
	 * @private
	 */
	private var _skinIsFromItem:Bool = false;

	/**
	 * @private
	 */
	private var _iconIsFromItem:Bool = false;

	/**
	 * @private
	 */
	private var _accessoryIsFromItem:Bool = false;

	/**
	 * @private
	 */
	override public function set_defaultIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.defaultValue == value)
		{
			return get_defaultIcon();
		}
		this.replaceIcon(null);
		this._iconIsFromItem = false;
		super.defaultIcon = value;
		return get_defaultIcon();
	}

	/**
	 * @private
	 */
	override public function set_defaultSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.defaultValue == value)
		{
			return get_defaultSkin();
		}
		this.replaceSkin(null);
		this._skinIsFromItem = false;
		super.defaultSkin = value;
		return get_defaultSkin();
	}

	/**
	 * @private
	 */
	private var _data:Dynamic;

	/**
	 * The item displayed by this renderer. This property is set by the
	 * list, and should not be set manually.
	 */
	public var data(get, set):Dynamic;
	public function get_data():Dynamic
	{
		return this._data;
	}

	/**
	 * @private
	 */
	public function set_data(value:Dynamic):Dynamic
	{
		//we need to use strict equality here because the data can be
		//non-strictly equal to null
		if(this._data === value)
		{
			return this._data;
		}
		this._data = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._data;
	}

	/**
	 * @private
	 */
	private var _owner:Scroller;

	/**
	 * @private
	 */
	private var _delayedCurrentState:String;

	/**
	 * @private
	 */
	private var _stateDelayTimer:Timer;

	/**
	 * @private
	 */
	private var _useStateDelayTimer:Bool = true;

	/**
	 * If true, the down state (and subsequent state changes) will be
	 * delayed to make scrolling look nicer.
	 *
	 * <p>In the following example, the state delay timer is disabled:</p>
	 *
	 * <listing version="3.0">
	 * renderer.useStateDelayTimer = false;</listing>
	 *
	 * @default true
	 */
	public var useStateDelayTimer(get, set):Bool;
	public function get_useStateDelayTimer():Bool
	{
		return this._useStateDelayTimer;
	}

	/**
	 * @private
	 */
	public function set_useStateDelayTimer(value:Bool):Bool
	{
		return this._useStateDelayTimer = value;
	}

	/**
	 * Determines if the item renderer can be selected even if
	 * <code>isToggle</code> is set to <code>false</code>. Subclasses are
	 * expected to change this value, if required.
	 */
	private var isSelectableWithoutToggle:Bool = true;

	/**
	 * @private
	 */
	private var _itemHasLabel:Bool = true;

	/**
	 * If true, the label will come from the renderer's item using the
	 * appropriate field or function for the label. If false, the label may
	 * be set externally.
	 *
	 * <p>In the following example, the item doesn't have a label:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasLabel = false;</listing>
	 *
	 * @default true
	 */
	public var itemHasLabel(get, set):Bool;
	public function get_itemHasLabel():Bool
	{
		return this._itemHasLabel;
	}

	/**
	 * @private
	 */
	public function set_itemHasLabel(value:Bool):Bool
	{
		if(this._itemHasLabel == value)
		{
			return this._itemHasLabel;
		}
		this._itemHasLabel = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._itemHasLabel;
	}

	/**
	 * @private
	 */
	private var _itemHasIcon:Bool = true;

	/**
	 * If true, the icon will come from the renderer's item using the
	 * appropriate field or function for the icon. If false, the icon may
	 * be skinned for each state externally.
	 *
	 * <p>In the following example, the item doesn't have an icon:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasIcon = false;</listing>
	 *
	 * @default true
	 */
	public var itemHasIcon(get, set):Bool;
	public function get_itemHasIcon():Bool
	{
		return this._itemHasIcon;
	}

	/**
	 * @private
	 */
	public function set_itemHasIcon(value:Bool):Bool
	{
		if(this._itemHasIcon == value)
		{
			return this._itemHasIcon;
		}
		this._itemHasIcon = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._itemHasIcon;
	}

	/**
	 * @private
	 */
	private var _itemHasAccessory:Bool = true;

	/**
	 * If true, the accessory will come from the renderer's item using the
	 * appropriate field or function for the accessory. If false, the
	 * accessory may be set using other means.
	 *
	 * <p>In the following example, the item doesn't have an accessory:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasAccessory = false;</listing>
	 *
	 * @default true
	 */
	public var itemHasAccessory(get, set):Bool;
	public function get_itemHasAccessory():Bool
	{
		return this._itemHasAccessory;
	}

	/**
	 * @private
	 */
	public function set_itemHasAccessory(value:Bool):Bool
	{
		if(this._itemHasAccessory == value)
		{
			return this._itemHasAccessory;
		}
		this._itemHasAccessory = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._itemHasAccessory;
	}

	/**
	 * @private
	 */
	private var _itemHasSkin:Bool = false;

	/**
	 * If true, the skin will come from the renderer's item using the
	 * appropriate field or function for the skin. If false, the skin may
	 * be set for each state externally.
	 *
	 * <p>In the following example, the item has a skin:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasSkin = true;
	 * renderer.skinField = "background";</listing>
	 *
	 * @default false
	 */
	public var itemHasSkin(get, set):Bool;
	public function get_itemHasSkin():Bool
	{
		return this._itemHasSkin;
	}

	/**
	 * @private
	 */
	public function set_itemHasSkin(value:Bool):Bool
	{
		if(this._itemHasSkin == value)
		{
			return this._itemHasSkin;
		}
		this._itemHasSkin = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._itemHasSkin;
	}

	/**
	 * @private
	 */
	private var _itemHasSelectable:Bool = false;

	/**
	 * If true, the ability to select the renderer will come from the
	 * renderer's item using the appropriate field or function for
	 * selectable. If false, the renderer will be selectable if its owner
	 * is selectable.
	 *
	 * <p>In the following example, the item doesn't have an accessory:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasSelectable = true;</listing>
	 *
	 * @default false
	 */
	public var itemHasSelectable(get, set):Bool;
	public function get_itemHasSelectable():Bool
	{
		return this._itemHasSelectable;
	}

	/**
	 * @private
	 */
	public function set_itemHasSelectable(value:Bool):Bool
	{
		if(this._itemHasSelectable == value)
		{
			return this._itemHasSelectable;
		}
		this._itemHasSelectable = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._itemHasSelectable;
	}

	/**
	 * @private
	 */
	private var _itemHasEnabled:Bool = false;

	/**
	 * If true, the renderer's enabled state will come from the renderer's
	 * item using the appropriate field or function for enabled. If false,
	 * the renderer will be enabled if its owner is enabled.
	 *
	 * <p>In the following example, the item doesn't have an accessory:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasEnabled = true;</listing>
	 *
	 * @default false
	 */
	public var itemHasEnabled(get, set):Bool;
	public function get_itemHasEnabled():Bool
	{
		return this._itemHasEnabled;
	}

	/**
	 * @private
	 */
	public function set_itemHasEnabled(value:Bool):Bool
	{
		if(this._itemHasEnabled == value)
		{
			return this._itemHasEnabled;
		}
		this._itemHasEnabled = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._itemHasEnabled;
	}

	/**
	 * @private
	 */
	private var _accessoryPosition:String = ACCESSORY_POSITION_RIGHT;

	//[Inspectable(type="String",enumeration="top,right,bottom,left,manual")]
	/**
	 * The location of the accessory, relative to one of the other children.
	 * Use <code>ACCESSORY_POSITION_MANUAL</code> to position the accessory
	 * from the top-left corner.
	 *
	 * <p>In the following example, the accessory is placed on the bottom:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_BOTTOM;</listing>
	 *
	 * @default BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT
	 *
	 * @see #ACCESSORY_POSITION_TOP
	 * @see #ACCESSORY_POSITION_RIGHT
	 * @see #ACCESSORY_POSITION_BOTTOM
	 * @see #ACCESSORY_POSITION_LEFT
	 * @see #ACCESSORY_POSITION_MANUAL
	 * @see #layoutOrder
	 */
	public var accessoryPosition(get, set):String;
	public function get_accessoryPosition():String
	{
		return this._accessoryPosition;
	}

	/**
	 * @private
	 */
	public function set_accessoryPosition(value:String):String
	{
		if(this._accessoryPosition == value)
		{
			return this._accessoryPosition;
		}
		this._accessoryPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._accessoryPosition;
	}

	/**
	 * @private
	 */
	private var _layoutOrder:String = LAYOUT_ORDER_LABEL_ICON_ACCESSORY;

	//[Inspectable(type="String",enumeration="labelIconAccessory,labelAccessoryIcon")]
	/**
	 * The accessory's position will be based on which other child (the
	 * label or the icon) the accessory should be relative to.
	 *
	 * <p>The <code>accessoryPositionOrigin</code> property will be ignored
	 * if <code>accessoryPosition</code> is set to <code>ACCESSORY_POSITION_MANUAL</code>.</p>
	 *
	 * <p>In the following example, the layout order is changed:</p>
	 *
	 * <listing version="3.0">
	 * renderer.layoutOrder = BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON;</listing>
	 *
	 * @default BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ICON_ACCESSORY
	 *
	 * @see #LAYOUT_ORDER_LABEL_ICON_ACCESSORY
	 * @see #LAYOUT_ORDER_LABEL_ACCESSORY_ICON
	 * @see #accessoryPosition
	 * @see #iconPosition
	 */
	public var layoutOrder(get, set):String;
	public function get_layoutOrder():String
	{
		return this._layoutOrder;
	}

	/**
	 * @private
	 */
	public function set_layoutOrder(value:String):String
	{
		if(this._layoutOrder == value)
		{
			return this._layoutOrder;
		}
		this._layoutOrder = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._layoutOrder;
	}

	/**
	 * @private
	 */
	private var _accessoryOffsetX:Float = 0;

	/**
	 * Offsets the x position of the accessory by a certain number of pixels.
	 *
	 * <p>In the following example, the accessory x position is adjusted by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryOffsetX = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #accessoryOffsetY
	 */
	public var accessoryOffsetX(get, set):Float;
	public function get_accessoryOffsetX():Float
	{
		return this._accessoryOffsetX;
	}

	/**
	 * @private
	 */
	public function set_accessoryOffsetX(value:Float):Float
	{
		if(this._accessoryOffsetX == value)
		{
			return this._accessoryOffsetX;
		}
		this._accessoryOffsetX = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._accessoryOffsetX;
	}

	/**
	 * @private
	 */
	private var _accessoryOffsetY:Float = 0;

	/**
	 * Offsets the y position of the accessory by a certain number of pixels.
	 *
	 * <p>In the following example, the accessory y position is adjusted by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryOffsetY = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #accessoryOffsetX
	 */
	public var accessoryOffsetY(get, set):Float;
	public function get_accessoryOffsetY():Float
	{
		return this._accessoryOffsetY;
	}

	/**
	 * @private
	 */
	public function set_accessoryOffsetY(value:Float):Float
	{
		if(this._accessoryOffsetY == value)
		{
			return this._accessoryOffsetY;
		}
		this._accessoryOffsetY = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._accessoryOffsetY;
	}

	/**
	 * @private
	 */
	private var _accessoryGap:Float = Math.NaN;

	/**
	 * The space, in pixels, between the accessory and the other child it is
	 * positioned relative to. Applies to either horizontal or vertical
	 * spacing, depending on the value of <code>accessoryPosition</code>. If
	 * the value is <code>NaN</code>, the value of the <code>gap</code>
	 * property will be used instead.
	 *
	 * <p>If <code>accessoryGap</code> is set to <code>Math.POSITIVE_INFINITY</code>,
	 * the accessory and the component it is relative to will be positioned
	 * as far apart as possible.</p>
	 *
	 * <p>In the following example, the accessory gap is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryGap = 20;</listing>
	 *
	 * @default NaN
	 *
	 * @see #gap
	 * @see #accessoryPosition
	 */
	public var accessoryGap(get, set):Float;
	public function get_accessoryGap():Float
	{
		return this._accessoryGap;
	}

	/**
	 * @private
	 */
	public function set_accessoryGap(value:Float):Float
	{
		if(this._accessoryGap == value)
		{
			return this._accessoryGap;
		}
		this._accessoryGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._accessoryGap;
	}

	/**
	 * @private
	 */
	private var _minAccessoryGap:Float = Math.NaN;

	/**
	 * If the value of the <code>accessoryGap</code> property is
	 * <code>Math.POSITIVE_INFINITY</code>, meaning that the gap will
	 * fill as much space as possible, the final calculated value will not be
	 * smaller than the value of the <code>minAccessoryGap</code> property.
	 * If the value of <code>minAccessoryGap</code> is <code>NaN</code>, the
	 * value of the <code>minGap</code> property will be used instead.
	 *
	 * <p>The following example ensures that the gap is never smaller than
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.gap = Math.POSITIVE_INFINITY;
	 * button.minGap = 20;</listing>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryGap = 20;</listing>
	 *
	 * @default NaN
	 *
	 * @see #accessoryGap
	 */
	public var minAccessoryGap(get, set):Float;
	public function get_minAccessoryGap():Float
	{
		return this._minAccessoryGap;
	}

	/**
	 * @private
	 */
	public function set_minAccessoryGap(value:Float):Float
	{
		if(this._minAccessoryGap == value)
		{
			return this._minAccessoryGap;
		}
		this._minAccessoryGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._minAccessoryGap;
	}

	/**
	 * @private
	 */
	override private function set_currentState(value:String):String
	{
		if(this._isEnabled && !this._isToggle && (!this.isSelectableWithoutToggle || (this._itemHasSelectable && !this.itemToSelectable(this._data))))
		{
			value = Button.STATE_UP;
		}
		if(this._useStateDelayTimer)
		{
			if(this._stateDelayTimer != null && this._stateDelayTimer.running)
			{
				this._delayedCurrentState = value;
				return this._currentState;
			}

			if(value == Button.STATE_DOWN)
			{
				if(this._currentState == value)
				{
					return this._currentState;
				}
				this._delayedCurrentState = value;
				if(this._stateDelayTimer != null)
				{
					this._stateDelayTimer.reset();
				}
				else
				{
					this._stateDelayTimer = new Timer(DOWN_STATE_DELAY_MS, 1);
					this._stateDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
				}
				this._stateDelayTimer.start();
				return this._currentState;
			}
		}
		super.currentState = value;
		return this._currentState;
	}

	/**
	 * @private
	 */
	private var accessoryTouchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _stopScrollingOnAccessoryTouch:Bool = true;

	/**
	 * If enabled, calls owner.stopScrolling() when TouchEvents are
	 * dispatched by the accessory.
	 *
	 * <p>In the following example, the list won't stop scrolling when the
	 * accessory is touched:</p>
	 *
	 * <listing version="3.0">
	 * renderer.stopScrollingOnAccessoryTouch = false;</listing>
	 *
	 * @default true
	 */
	public var stopScrollingOnAccessoryTouch(get, set):Bool;
	public function get_stopScrollingOnAccessoryTouch():Bool
	{
		return this._stopScrollingOnAccessoryTouch;
	}

	/**
	 * @private
	 */
	public function set_stopScrollingOnAccessoryTouch(value:Bool):Bool
	{
		return this._stopScrollingOnAccessoryTouch = value;
	}

	/**
	 * @private
	 */
	private var _isSelectableOnAccessoryTouch:Bool = false;

	/**
	 * If enabled, the item renderer may be selected by touching the
	 * accessory. By default, the accessory will not trigger selection when
	 * using <code>accessoryField</code> or <code>accessoryFunction</code>.
	 *
	 * <p>In the following example, the item renderer can be selected when
	 * the accessory is touched:</p>
	 *
	 * <listing version="3.0">
	 * renderer.isSelectableOnAccessoryTouch = true;</listing>
	 *
	 * @default false
	 */
	public var isSelectableOnAccessoryTouch(get, set):Bool;
	public function get_isSelectableOnAccessoryTouch():Bool
	{
		return this._isSelectableOnAccessoryTouch;
	}

	/**
	 * @private
	 */
	public function set_isSelectableOnAccessoryTouch(value:Bool):Bool
	{
		return this._isSelectableOnAccessoryTouch = value;
	}

	/**
	 * @private
	 */
	private var _delayTextureCreationOnScroll:Bool = false;

	/**
	 * If enabled, automatically manages the <code>delayTextureCreation</code>
	 * property on accessory and icon <code>ImageLoader</code> instances
	 * when the owner scrolls. This applies to the loaders created when the
	 * following properties are set: <code>accessorySourceField</code>,
	 * <code>accessorySourceFunction</code>, <code>iconSourceField</code>,
	 * and <code>iconSourceFunction</code>.
	 *
	 * <p>In the following example, any loaded textures won't be uploaded to
	 * the GPU until the owner stops scrolling:</p>
	 *
	 * <listing version="3.0">
	 * renderer.delayTextureCreationOnScroll = true;</listing>
	 *
	 * @default false
	 */
	public var delayTextureCreationOnScroll(get, set):Bool;
	public function get_delayTextureCreationOnScroll():Bool
	{
		return this._delayTextureCreationOnScroll;
	}

	/**
	 * @private
	 */
	public function set_delayTextureCreationOnScroll(value:Bool):Bool
	{
		return this._delayTextureCreationOnScroll = value;
	}

	/**
	 * @private
	 */
	private var _labelField:String = "label";

	/**
	 * The field in the item that contains the label text to be displayed by
	 * the renderer. If the item does not have this field, and a
	 * <code>labelFunction</code> is not defined, then the renderer will
	 * default to calling <code>toString()</code> on the item. To omit the
	 * label completely, either provide a custom item renderer without a
	 * label or define a <code>labelFunction</code> that returns an empty
	 * string.
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>labelFunction</code></li>
	 *     <li><code>labelField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the label field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.labelField = "text";</listing>
	 *
	 * @default "label"
	 *
	 * @see #labelFunction
	 */
	public var labelField(get, set):String;
	public function get_labelField():String
	{
		return this._labelField;
	}

	/**
	 * @private
	 */
	public function set_labelField(value:String):String
	{
		if(this._labelField == value)
		{
			return this._labelField;
		}
		this._labelField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._labelField;
	}

	/**
	 * @private
	 */
	private var _labelFunction:Dynamic->String;

	/**
	 * A function used to generate label text for a specific item. If this
	 * function is not null, then the <code>labelField</code> will be
	 * ignored.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):String</pre>
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>labelFunction</code></li>
	 *     <li><code>labelField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the label function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.labelFunction = function( item:Dynamic ):String
	 * {
	 *    return item.firstName + " " + item.lastName;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #labelField
	 */
	public var labelFunction(get, set):Dynamic->String;
	public function get_labelFunction():Dynamic->String
	{
		return this._labelFunction;
	}

	/**
	 * @private
	 */
	public function set_labelFunction(value:Dynamic->String):Dynamic->String
	{
		if(this._labelFunction == value)
		{
			return this._labelFunction;
		}
		this._labelFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._labelFunction;
	}

	/**
	 * @private
	 */
	private var _iconField:String = "icon";

	/**
	 * The field in the item that contains a display object to be displayed
	 * as an icon or other graphic next to the label in the renderer.
	 *
	 * <p>Warning: It is your responsibility to dispose all icons
	 * included in the data provider and accessed with <code>iconField</code>,
	 * or any display objects returned by <code>iconFunction</code>.
	 * These display objects will not be disposed when the list is disposed.
	 * Not disposing an icon may result in a memory leak.</p>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconLabelFunction</code></li>
	 *     <li><code>iconLabelField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the icon field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.iconField = "photo";</listing>
	 *
	 * @default "icon"
	 *
	 * @see #itemHasIcon
	 * @see #iconFunction
	 * @see #iconSourceField
	 * @see #iconSourceFunction
	 */
	public var iconField(get, set):String;
	public function get_iconField():String
	{
		return this._iconField;
	}

	/**
	 * @private
	 */
	public function set_iconField(value:String):String
	{
		if(this._iconField == value)
		{
			return this._iconField;
		}
		this._iconField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._iconField;
	}

	/**
	 * @private
	 */
	private var _iconFunction:Dynamic;

	/**
	 * A function used to generate an icon for a specific item.
	 *
	 * <p>Note: As the list scrolls, this function will almost always be
	 * called more than once for each individual item in the list's data
	 * provider. Your function should not simply return a new icon every
	 * time. This will result in the unnecessary creation and destruction of
	 * many icons, which will overwork the garbage collector and hurt
	 * performance. It's better to return a new icon the first time this
	 * function is called for a particular item and then return the same
	 * icon if that item is passed to this function again.</p>
	 *
	 * <p>Warning: It is your responsibility to dispose all icons
	 * included in the data provider and accessed with <code>iconField</code>,
	 * or any display objects returned by <code>iconFunction</code>.
	 * These display objects will not be disposed when the list is disposed.
	 * Not disposing an icon may result in a memory leak.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):DisplayObject</pre>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconLabelFunction</code></li>
	 *     <li><code>iconLabelField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the icon function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.iconFunction = function( item:Dynamic ):DisplayObject
	 * {
	 *    if(item in cachedIcons)
	 *    {
	 *        return cachedIcons[item];
	 *    }
	 *    var icon:Image = new Image( textureAtlas.getTexture( item.textureName ) );
	 *    cachedIcons[item] = icon;
	 *    return icon;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #itemHasIcon
	 * @see #iconField
	 * @see #iconSourceField
	 * @see #iconSourceFunction
	 */
	public var iconFunction(get, set):Dynamic->DisplayObject;
	public function get_iconFunction():Dynamic->DisplayObject
	{
		return this._iconFunction;
	}

	/**
	 * @private
	 */
	public function set_iconFunction(value:Dynamic->DisplayObject):Dynamic->DisplayObject
	{
		if(this._iconFunction == value)
		{
			return this._iconFunction;
		}
		this._iconFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._iconFunction;
	}

	/**
	 * @private
	 */
	private var _iconSourceField:String = "iconSource";

	/**
	 * The field in the item that contains a <code>starling.textures.Texture</code>
	 * or a URL that points to a bitmap to be used as the item renderer's
	 * icon. The renderer will automatically manage and reuse an internal
	 * <code>ImageLoader</code> sub-component and this value will be passed
	 * to the <code>source</code> property. The <code>ImageLoader</code> may
	 * be customized by changing the <code>iconLoaderFactory</code>.
	 *
	 * <p>Using an icon source will result in better performance than
	 * passing in an <code>ImageLoader</code> or <code>Image</code> through
	 * a <code>iconField</code> or <code>iconFunction</code>
	 * because the renderer can avoid costly display list manipulation.</p>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconLabelFunction</code></li>
	 *     <li><code>iconLabelField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the icon source field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.iconSourceField = "texture";</listing>
	 *
	 * @default "iconSource"
	 *
	 * @see feathers.controls.ImageLoader#source
	 * @see #itemHasIcon
	 * @see #iconLoaderFactory
	 * @see #iconSourceFunction
	 * @see #iconField
	 * @see #iconFunction
	 */
	public var iconSourceField(get, set):String;
	public function get_iconSourceField():String
	{
		return this._iconSourceField;
	}

	/**
	 * @private
	 */
	public function set_iconSourceField(value:String):String
	{
		if(this._iconSourceField == value)
		{
			return this._iconSourceField;
		}
		this._iconSourceField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._iconSourceField;
	}

	/**
	 * @private
	 */
	private var _iconSourceFunction:Dynamic;

	/**
	 * A function used to generate a <code>starling.textures.Texture</code>
	 * or a URL that points to a bitmap to be used as the item renderer's
	 * icon. The renderer will automatically manage and reuse an internal
	 * <code>ImageLoader</code> sub-component and this value will be passed
	 * to the <code>source</code> property. The <code>ImageLoader</code> may
	 * be customized by changing the <code>iconLoaderFactory</code>.
	 *
	 * <p>Using an icon source will result in better performance than
	 * passing in an <code>ImageLoader</code> or <code>Image</code> through
	 * a <code>iconField</code> or <code>iconFunction</code>
	 * because the renderer can avoid costly display list manipulation.</p>
	 *
	 * <p>Note: As the list scrolls, this function will almost always be
	 * called more than once for each individual item in the list's data
	 * provider. Your function should not simply return a new texture every
	 * time. This will result in the unnecessary creation and destruction of
	 * many textures, which will overwork the garbage collector and hurt
	 * performance. Creating a new texture at all is dangerous, unless you
	 * are absolutely sure to dispose it when necessary because neither the
	 * list nor its item renderer will dispose of the texture for you. If
	 * you are absolutely sure that you are managing the texture memory with
	 * proper disposal, it's better to return a new texture the first
	 * time this function is called for a particular item and then return
	 * the same texture if that item is passed to this function again.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Dynamic</pre>
	 *
	 * <p>The return value is a valid value for the <code>source</code>
	 * property of an <code>ImageLoader</code> component.</p>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconLabelFunction</code></li>
	 *     <li><code>iconLabelField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the icon source function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.iconSourceFunction = function( item:Dynamic ):Dynamic
	 * {
	 *    return "http://www.example.com/thumbs/" + item.name + "-thumb.png";
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.ImageLoader#source
	 * @see #itemHasIcon
	 * @see #iconLoaderFactory
	 * @see #iconSourceField
	 * @see #iconField
	 * @see #iconFunction
	 */
	public var iconSourceFunction(get, set):Dynamic;
	public function get_iconSourceFunction():Dynamic
	{
		return this._iconSourceFunction;
	}

	/**
	 * @private
	 */
	public function set_iconSourceFunction(value:Dynamic):Dynamic
	{
		if(this._iconSourceFunction == value)
		{
			return this._iconSourceFunction;
		}
		this._iconSourceFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._iconSourceFunction;
	}

	/**
	 * @private
	 */
	private var _iconLabelField:String = "iconLabel";

	/**
	 * The field in the item that contains a string to be displayed in a
	 * renderer-managed <code>ITextRenderer</code> in the icon position of
	 * the renderer. The renderer will automatically reuse an internal
	 * <code>ITextRenderer</code> and swap the text when the data changes.
	 * This <code>ITextRenderer</code> may be skinned by changing the
	 * <code>iconLabelFactory</code>.
	 *
	 * <p>Using an icon label will result in better performance than
	 * passing in an <code>ITextRenderer</code> through a <code>iconField</code>
	 * or <code>iconFunction</code> because the renderer can avoid
	 * costly display list manipulation.</p>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconLabelFunction</code></li>
	 *     <li><code>iconLabelField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the icon label field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.iconLabelField = "text";</listing>
	 *
	 * @default "iconLabel"
	 *
	 * @see #itemHasIcon
	 * @see #iconLabelFactory
	 * @see #iconLabelFunction
	 * @see #iconField
	 * @see #iconFunction
	 * @see #iconySourceField
	 * @see #iconSourceFunction
	 */
	public var iconLabelField(get, set):String;
	public function get_iconLabelField():String
	{
		return this._iconLabelField;
	}

	/**
	 * @private
	 */
	public function set_iconLabelField(value:String):String
	{
		if(this._iconLabelField == value)
		{
			return this._iconLabelField;
		}
		this._iconLabelField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._iconLabelField;
	}

	/**
	 * @private
	 */
	private var _iconLabelFunction:Dynamic;

	/**
	 * A function that returns a string to be displayed in a
	 * renderer-managed <code>ITextRenderer</code> in the icon position of
	 * the renderer. The renderer will automatically reuse an internal
	 * <code>ITextRenderer</code> and swap the text when the data changes.
	 * This <code>ITextRenderer</code> may be skinned by changing the
	 * <code>iconLabelFactory</code>.
	 *
	 * <p>Using an icon label will result in better performance than
	 * passing in an <code>ITextRenderer</code> through a <code>iconField</code>
	 * or <code>iconFunction</code> because the renderer can avoid costly
	 * display list manipulation.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):String</pre>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconLabelFunction</code></li>
	 *     <li><code>iconLabelField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the icon label function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.iconLabelFunction = function( item:Dynamic ):String
	 * {
	 *    return item.firstName + " " + item.lastName;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #itemHasIcon
	 * @see #iconLabelFactory
	 * @see #iconLabelField
	 * @see #iconField
	 * @see #iconFunction
	 * @see #iconSourceField
	 * @see #iconSourceFunction
	 */
	public var iconLabelFunction(get, set):Dynamic->String;
	public function get_iconLabelFunction():Dynamic->String
	{
		return this._iconLabelFunction;
	}

	/**
	 * @private
	 */
	public function set_iconLabelFunction(value:Dynamic->String):Dynamic->String
	{
		if(this._iconLabelFunction == value)
		{
			return this._iconLabelFunction;
		}
		this._iconLabelFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._iconLabelFunction;
	}

	/**
	 * @private
	 */
	private var _accessoryField:String = "accessory";

	/**
	 * The field in the item that contains a display object to be positioned
	 * in the accessory position of the renderer. If you wish to display an
	 * <code>Image</code> in the accessory position, it's better for
	 * performance to use <code>accessorySourceField</code> instead.
	 *
	 * <p>Warning: It is your responsibility to dispose all accessories
	 * included in the data provider and accessed with <code>accessoryField</code>,
	 * or any display objects returned by <code>accessoryFunction</code>.
	 * These display objects will not be disposed when the list is disposed.
	 * Not disposing an accessory may result in a memory leak.</p>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessorySourceFunction</code></li>
	 *     <li><code>accessorySourceField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the accessory field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryField = "component";</listing>
	 *
	 * @default "accessory"
	 *
	 * @see #itemHasAccessory
	 * @see #accessorySourceField
	 * @see #accessoryFunction
	 * @see #accessorySourceFunction
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessoryField(get, set):String;
	public function get_accessoryField():String
	{
		return this._accessoryField;
	}

	/**
	 * @private
	 */
	public function set_accessoryField(value:String):String
	{
		if(this._accessoryField == value)
		{
			return this._accessoryField;
		}
		this._accessoryField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._accessoryField;
	}

	/**
	 * @private
	 */
	private var _accessoryFunction:Dynamic;

	/**
	 * A function that returns a display object to be positioned in the
	 * accessory position of the renderer. If you wish to display an
	 * <code>Image</code> in the accessory position, it's better for
	 * performance to use <code>accessorySourceFunction</code> instead.
	 *
	 * <p>Note: As the list scrolls, this function will almost always be
	 * called more than once for each individual item in the list's data
	 * provider. Your function should not simply return a new accessory
	 * every time. This will result in the unnecessary creation and
	 * destruction of many icons, which will overwork the garbage collector
	 * and hurt performance. It's better to return a new accessory the first
	 * time this function is called for a particular item and then return
	 * the same accessory if that item is passed to this function again.</p>
	 *
	 * <p>Warning: It is your responsibility to dispose all accessories
	 * included in the data provider and accessed with <code>accessoryField</code>,
	 * or any display objects returned by <code>accessoryFunction</code>.
	 * These display objects will not be disposed when the list is disposed.
	 * Not disposing an accessory may result in a memory leak.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):DisplayObject</pre>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessorySourceFunction</code></li>
	 *     <li><code>accessorySourceField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the accessory function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryFunction = function( item:Dynamic ):DisplayObject
	 * {
	 *    if(item in cachedAccessories)
	 *    {
	 *        return cachedAccessories[item];
	 *    }
	 *    var accessory:DisplayObject = createAccessoryForItem( item );
	 *    cachedAccessories[item] = accessory;
	 *    return accessory;
	 * };</listing>
	 *
	 * @default null
	 **
	 * @see #itemHasAccessory
	 * @see #accessoryField
	 * @see #accessorySourceField
	 * @see #accessorySourceFunction
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessoryFunction(get, set):Dynamic;
	public function get_accessoryFunction():Dynamic
	{
		return this._accessoryFunction;
	}

	/**
	 * @private
	 */
	public function set_accessoryFunction(value:Dynamic):Dynamic
	{
		if(this._accessoryFunction == value)
		{
			return this._accessoryFunction;
		}
		this._accessoryFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._accessoryFunction;
	}

	/**
	 * @private
	 */
	private var _accessorySourceField:String = "accessorySource";

	/**
	 * A field in the item that contains a <code>starling.textures.Texture</code>
	 * or a URL that points to a bitmap to be used as the item renderer's
	 * accessory. The renderer will automatically manage and reuse an internal
	 * <code>ImageLoader</code> sub-component and this value will be passed
	 * to the <code>source</code> property. The <code>ImageLoader</code> may
	 * be customized by changing the <code>accessoryLoaderFactory</code>.
	 *
	 * <p>Using an accessory source will result in better performance than
	 * passing in an <code>ImageLoader</code> or <code>Image</code> through
	 * a <code>accessoryField</code> or <code>accessoryFunction</code> because
	 * the renderer can avoid costly display list manipulation.</p>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessorySourceFunction</code></li>
	 *     <li><code>accessorySourceField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the accessory source field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessorySourceField = "texture";</listing>
	 *
	 * @default "accessorySource"
	 *
	 * @see feathers.controls.ImageLoader#source
	 * @see #itemHasAccessory
	 * @see #accessoryLoaderFactory
	 * @see #accessorySourceFunction
	 * @see #accessoryField
	 * @see #accessoryFunction
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessorySourceField(get, set):String;
	public function get_accessorySourceField():String
	{
		return this._accessorySourceField;
	}

	/**
	 * @private
	 */
	public function set_accessorySourceField(value:String):String
	{
		if(this._accessorySourceField == value)
		{
			return this._accessorySourceField;
		}
		this._accessorySourceField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._accessorySourceField;
	}

	/**
	 * @private
	 */
	private var _accessorySourceFunction:Dynamic->Dynamic;

	/**
	 * A function that generates a <code>starling.textures.Texture</code>
	 * or a URL that points to a bitmap to be used as the item renderer's
	 * accessory. The renderer will automatically manage and reuse an internal
	 * <code>ImageLoader</code> sub-component and this value will be passed
	 * to the <code>source</code> property. The <code>ImageLoader</code> may
	 * be customized by changing the <code>accessoryLoaderFactory</code>.
	 *
	 * <p>Using an accessory source will result in better performance than
	 * passing in an <code>ImageLoader</code> or <code>Image</code> through
	 * a <code>accessoryField</code> or <code>accessoryFunction</code>
	 * because the renderer can avoid costly display list manipulation.</p>
	 *
	 * <p>Note: As the list scrolls, this function will almost always be
	 * called more than once for each individual item in the list's data
	 * provider. Your function should not simply return a new texture every
	 * time. This will result in the unnecessary creation and destruction of
	 * many textures, which will overwork the garbage collector and hurt
	 * performance. Creating a new texture at all is dangerous, unless you
	 * are absolutely sure to dispose it when necessary because neither the
	 * list nor its item renderer will dispose of the texture for you. If
	 * you are absolutely sure that you are managing the texture memory with
	 * proper disposal, it's better to return a new texture the first
	 * time this function is called for a particular item and then return
	 * the same texture if that item is passed to this function again.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Dynamic</pre>
	 *
	 * <p>The return value is a valid value for the <code>source</code>
	 * property of an <code>ImageLoader</code> component.</p>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessorySourceFunction</code></li>
	 *     <li><code>accessorySourceField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the accessory source function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessorySourceFunction = function( item:Dynamic ):Dynamic
	 * {
	 *    return "http://www.example.com/thumbs/" + item.name + "-thumb.png";
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.ImageLoader#source
	 * @see #itemHasAccessory
	 * @see #accessoryLoaderFactory
	 * @see #accessorySourceField
	 * @see #accessoryField
	 * @see #accessoryFunction
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessorySourceFunction(get, set):Dynamic->Dynamic;
	public function get_accessorySourceFunction():Dynamic->Dynamic
	{
		return this._accessorySourceFunction;
	}

	/**
	 * @private
	 */
	public function set_accessorySourceFunction(value:Dynamic->Dynamic):Dynamic->Dynamic
	{
		if(this._accessorySourceFunction == value)
		{
			return this._accessorySourceFunction;
		}
		this._accessorySourceFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._accessorySourceFunction;
	}

	/**
	 * @private
	 */
	private var _accessoryLabelField:String = "accessoryLabel";

	/**
	 * The field in the item that contains a string to be displayed in a
	 * renderer-managed <code>ITextRenderer</code> in the accessory position
	 * of the renderer. The renderer will automatically reuse an internal
	 * <code>ITextRenderer</code> and swap the text when the data changes.
	 * This <code>ITextRenderer</code> may be skinned by changing the
	 * <code>accessoryLabelFactory</code>.
	 *
	 * <p>Using an accessory label will result in better performance than
	 * passing in a <code>ITextRenderer</code> through an <code>accessoryField</code>
	 * or <code>accessoryFunction</code> because the renderer can avoid
	 * costly display list manipulation.</p>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessorySourceFunction</code></li>
	 *     <li><code>accessorySourceField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the accessory label field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryLabelField = "text";</listing>
	 *
	 * @default "accessoryLabel"
	 **
	 * @see #itemHasAccessory
	 * @see #accessoryLabelFactory
	 * @see #accessoryLabelFunction
	 * @see #accessoryField
	 * @see #accessoryFunction
	 * @see #accessorySourceField
	 * @see #accessorySourceFunction
	 */
	public var accessoryLabelField(get, set):String;
	public function get_accessoryLabelField():String
	{
		return this._accessoryLabelField;
	}

	/**
	 * @private
	 */
	public function set_accessoryLabelField(value:String):String
	{
		if(this._accessoryLabelField == value)
		{
			return this._accessoryLabelField;
		}
		this._accessoryLabelField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._accessoryLabelField;
	}

	/**
	 * @private
	 */
	private var _accessoryLabelFunction:Dynamic;

	/**
	 * A function that returns a string to be displayed in a
	 * renderer-managed <code>ITextRenderer</code> in the accessory position
	 * of the renderer. The renderer will automatically reuse an internal
	 * <code>ITextRenderer</code> and swap the text when the data changes.
	 * This <code>ITextRenderer</code> may be skinned by changing the
	 * <code>accessoryLabelFactory</code>.
	 *
	 * <p>Using an accessory label will result in better performance than
	 * passing in an <code>ITextRenderer</code> through an <code>accessoryField</code>
	 * or <code>accessoryFunction</code> because the renderer can avoid
	 * costly display list manipulation.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):String</pre>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessorySourceFunction</code></li>
	 *     <li><code>accessorySourceField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the accessory label function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryLabelFunction = function( item:Dynamic ):String
	 * {
	 *    return item.firstName + " " + item.lastName;
	 * };</listing>
	 *
	 * @default null
	 **
	 * @see #itemHasAccessory
	 * @see #accessoryLabelFactory
	 * @see #accessoryLabelField
	 * @see #accessoryField
	 * @see #accessoryFunction
	 * @see #accessorySourceField
	 * @see #accessorySourceFunction
	 */
	public var accessoryLabelFunction(get, set):Dynamic;
	public function get_accessoryLabelFunction():Dynamic
	{
		return this._accessoryLabelFunction;
	}

	/**
	 * @private
	 */
	public function set_accessoryLabelFunction(value:Dynamic):Dynamic
	{
		if(this._accessoryLabelFunction == value)
		{
			return this._accessoryLabelFunction;
		}
		this._accessoryLabelFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._accessoryLabelFunction;
	}

	/**
	 * @private
	 */
	private var _skinField:String = "skin";

	/**
	 * The field in the item that contains a display object to be displayed
	 * as a background skin.
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>skinSourceFunction</code></li>
	 *     <li><code>skinSourceField</code></li>
	 *     <li><code>skinFunction</code></li>
	 *     <li><code>skinField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the skin field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasSkin = true;
	 * renderer.skinField = "background";</listing>
	 *
	 * @default "skin"
	 *
	 * @see #itemHasSkin
	 * @see #skinFunction
	 * @see #skinSourceField
	 * @see #skinSourceFunction
	 */
	public var skinField(get, set):String;
	public function get_skinField():String
	{
		return this._skinField;
	}

	/**
	 * @private
	 */
	public function set_skinField(value:String):String
	{
		if(this._skinField == value)
		{
			return this._skinField;
		}
		this._skinField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._skinField;
	}

	/**
	 * @private
	 */
	private var _skinFunction:Dynamic;

	/**
	 * A function used to generate a background skin for a specific item.
	 *
	 * <p>Note: As the list scrolls, this function will almost always be
	 * called more than once for each individual item in the list's data
	 * provider. Your function should not simply return a new display object
	 * every time. This will result in the unnecessary creation and
	 * destruction of many skins, which will overwork the garbage collector
	 * and hurt performance. It's better to return a new skin the first time
	 * this function is called for a particular item and then return the same
	 * skin if that item is passed to this function again.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):DisplayObject</pre>
	 *
	 * <p>All of the skin fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>skinSourceFunction</code></li>
	 *     <li><code>skinSourceField</code></li>
	 *     <li><code>skinFunction</code></li>
	 *     <li><code>skinField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the skin function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasSkin = true;
	 * renderer.skinFunction = function( item:Dynamic ):DisplayObject
	 * {
	 *    if(item in cachedSkin)
	 *    {
	 *        return cachedSkin[item];
	 *    }
	 *    var skin:Image = new Image( textureAtlas.getTexture( item.textureName ) );
	 *    cachedSkin[item] = skin;
	 *    return skin;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #itemHasSkin
	 * @see #skinField
	 * @see #skinSourceField
	 * @see #skinSourceFunction
	 */
	public var skinFunction(get, set):Dynamic->DisplayObject;
	public function get_skinFunction():Dynamic->DisplayObject
	{
		return this._skinFunction;
	}

	/**
	 * @private
	 */
	public function set_skinFunction(value:Dynamic->DisplayObject):Dynamic->DisplayObject
	{
		if(this._skinFunction == value)
		{
			return this._skinFunction;
		}
		this._skinFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._skinFunction;
	}

	/**
	 * @private
	 */
	private var _skinSourceField:String = "skinSource";

	/**
	 * The field in the item that contains a <code>starling.textures.Texture</code>
	 * or a URL that points to a bitmap to be used as the item renderer's
	 * skin. The renderer will automatically manage and reuse an internal
	 * <code>ImageLoader</code> sub-component and this value will be passed
	 * to the <code>source</code> property. The <code>ImageLoader</code> may
	 * be customized by changing the <code>skinLoaderFactory</code>.
	 *
	 * <p>Using a skin source will result in better performance than
	 * passing in an <code>ImageLoader</code> or <code>Image</code> through
	 * a <code>skinField</code> or <code>skinFunction</code>
	 * because the renderer can avoid costly display list manipulation.</p>
	 *
	 * <p>All of the skin fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>skinSourceFunction</code></li>
	 *     <li><code>skinSourceField</code></li>
	 *     <li><code>skinFunction</code></li>
	 *     <li><code>skinField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the skin source field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasSkin = true;
	 * renderer.skinSourceField = "texture";</listing>
	 *
	 * @default "skinSource"
	 *
	 * @see feathers.controls.ImageLoader#source
	 * @see #itemHasSkin
	 * @see #skinLoaderFactory
	 * @see #skinSourceFunction
	 * @see #skinField
	 * @see #skinFunction
	 */
	public var skinSourceField(get, set):String;
	public function get_skinSourceField():String
	{
		return this._skinSourceField;
	}

	/**
	 * @private
	 */
	public function set_skinSourceField(value:String):String
	{
		if(this._iconSourceField == value)
		{
			return this._skinSourceField;
		}
		this._skinSourceField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._skinSourceField;
	}

	/**
	 * @private
	 */
	private var _skinSourceFunction:Dynamic;

	/**
	 * A function used to generate a <code>starling.textures.Texture</code>
	 * or a URL that points to a bitmap to be used as the item renderer's
	 * skin. The renderer will automatically manage and reuse an internal
	 * <code>ImageLoader</code> sub-component and this value will be passed
	 * to the <code>source</code> property. The <code>ImageLoader</code> may
	 * be customized by changing the <code>skinLoaderFactory</code>.
	 *
	 * <p>Using a skin source will result in better performance than
	 * passing in an <code>ImageLoader</code> or <code>Image</code> through
	 * a <code>skinField</code> or <code>skinnFunction</code>
	 * because the renderer can avoid costly display list manipulation.</p>
	 *
	 * <p>Note: As the list scrolls, this function will almost always be
	 * called more than once for each individual item in the list's data
	 * provider. Your function should not simply return a new texture every
	 * time. This will result in the unnecessary creation and destruction of
	 * many textures, which will overwork the garbage collector and hurt
	 * performance. Creating a new texture at all is dangerous, unless you
	 * are absolutely sure to dispose it when necessary because neither the
	 * list nor its item renderer will dispose of the texture for you. If
	 * you are absolutely sure that you are managing the texture memory with
	 * proper disposal, it's better to return a new texture the first
	 * time this function is called for a particular item and then return
	 * the same texture if that item is passed to this function again.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Dynamic</pre>
	 *
	 * <p>The return value is a valid value for the <code>source</code>
	 * property of an <code>ImageLoader</code> component.</p>
	 *
	 * <p>All of the skin fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>skinSourceFunction</code></li>
	 *     <li><code>skinSourceField</code></li>
	 *     <li><code>skinFunction</code></li>
	 *     <li><code>skinField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the skin source function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasSkin = true;
	 * renderer.skinSourceFunction = function( item:Dynamic ):Dynamic
	 * {
	 *    return "http://www.example.com/images/" + item.name + "-skin.png";
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.ImageLoader#source
	 * @see #itemHasSkin
	 * @see #skinLoaderFactory
	 * @see #skinSourceField
	 * @see #skinField
	 * @see #skinFunction
	 */
	public var skinSourceFunction(get, set):Dynamic->Dynamic;
	public function get_skinSourceFunction():Dynamic->Dynamic
	{
		return this._skinSourceFunction;
	}

	/**
	 * @private
	 */
	public function set_skinSourceFunction(value:Dynamic->Dynamic):Dynamic->Dynamic
	{
		if(this._skinSourceFunction == value)
		{
			return this._skinSourceFunction;
		}
		this._skinSourceFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._skinSourceFunction;
	}

	/**
	 * @private
	 */
	private var _selectableField:String = "selectable";

	/**
	 * The field in the item that determines if the item renderer can be
	 * selected, if the list allows selection. If the item does not have
	 * this field, and a <code>selectableFunction</code> is not defined,
	 * then the renderer will default to being selectable.
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>selectableFunction</code></li>
	 *     <li><code>selectableField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the selectable field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasSelectable = true;
	 * renderer.selectableField = "isSelectable";</listing>
	 *
	 * @default "selectable"
	 *
	 * @see #selectableFunction
	 */
	public var selectableField(get, set):String;
	public function get_selectableField():String
	{
		return this._selectableField;
	}

	/**
	 * @private
	 */
	public function set_selectableField(value:String):String
	{
		if(this._selectableField == value)
		{
			return this._selectableField;
		}
		this._selectableField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._selectableField;
	}

	/**
	 * @private
	 */
	private var _selectableFunction:Dynamic;

	/**
	 * A function used to determine if a specific item is selectable. If this
	 * function is not null, then the <code>selectableField</code> will be
	 * ignored.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Bool</pre>
	 *
	 * <p>All of the selectable fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>selectableFunction</code></li>
	 *     <li><code>selectableField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the selectable function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasSelectable = true;
	 * renderer.selectableFunction = function( item:Dynamic ):Bool
	 * {
	 *    return item.isSelectable;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #selectableField
	 */
	public var selectableFunction(get, set):Dynamic->Bool;
	public function get_selectableFunction():Dynamic->Bool
	{
		return this._selectableFunction;
	}

	/**
	 * @private
	 */
	public function set_selectableFunction(value:Dynamic->Bool):Dynamic->Bool
	{
		if(this._selectableFunction == value)
		{
			return this._selectableFunction;
		}
		this._selectableFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._selectableFunction;
	}

	/**
	 * @private
	 */
	private var _enabledField:String = "enabled";

	/**
	 * The field in the item that determines if the item renderer is
	 * enabled, if the list is enabled. If the item does not have
	 * this field, and a <code>enabledFunction</code> is not defined,
	 * then the renderer will default to being enabled.
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>enabledFunction</code></li>
	 *     <li><code>enabledField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the enabled field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasEnabled = true;
	 * renderer.enabledField = "isEnabled";</listing>
	 *
	 * @default "enabled"
	 *
	 * @see #enabledFunction
	 */
	public var enabledField(get, set):String;
	public function get_enabledField():String
	{
		return this._enabledField;
	}

	/**
	 * @private
	 */
	public function set_enabledField(value:String):String
	{
		if(this._enabledField == value)
		{
			return this._enabledField;
		}
		this._enabledField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._enabledField;
	}

	/**
	 * @private
	 */
	private var _enabledFunction:Dynamic;

	/**
	 * A function used to determine if a specific item is enabled. If this
	 * function is not null, then the <code>enabledField</code> will be
	 * ignored.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Bool</pre>
	 *
	 * <p>All of the enabled fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>enabledFunction</code></li>
	 *     <li><code>enabledField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the enabled function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.itemHasEnabled = true;
	 * renderer.enabledFunction = function( item:Dynamic ):Bool
	 * {
	 *    return item.isEnabled;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #enabledField
	 */
	public var enabledFunction(get, set):Dynamic;
	public function get_enabledFunction():Dynamic
	{
		return this._enabledFunction;
	}

	/**
	 * @private
	 */
	public function set_enabledFunction(value:Dynamic):Dynamic
	{
		if(this._enabledFunction == value)
		{
			return this._enabledFunction;
		}
		this._enabledFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._enabledFunction;
	}

	/**
	 * @private
	 */
	private var _explicitIsToggle:Bool = false;

	/**
	 * @private
	 */
	override public function set_isToggle(value:Bool):Bool
	{
		if(this._explicitIsToggle == value)
		{
			return get_isToggle();
		}
		super.isToggle = value;
		this._explicitIsToggle = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_isToggle();
	}

	/**
	 * @private
	 */
	private var _explicitIsEnabled:Bool = false;

	/**
	 * @private
	 */
	override public function set_isEnabled(value:Bool):Bool
	{
		if(this._explicitIsEnabled == value)
		{
			return get_isEnabled();
		}
		this._explicitIsEnabled = value;
		super.isEnabled = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STATE);
		return get_isEnabled();
	}

	/**
	 * @private
	 */
	private var _iconLoaderFactory:Dynamic = defaultLoaderFactory;

	/**
	 * A function that generates an <code>ImageLoader</code> that uses the result
	 * of <code>iconSourceField</code> or <code>iconSourceFunction</code>.
	 * Useful for transforming the <code>ImageLoader</code> in some way. For
	 * example, you might want to scale the texture for current screen
	 * density or apply pixel snapping.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ImageLoader</pre>
	 *
	 * <p>In the following example, the loader factory is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.iconLoaderFactory = function():ImageLoader
	 * {
	 *    var loader:ImageLoader = new ImageLoader();
	 *    loader.snapToPixels = true;
	 *    return loader;
	 * };</listing>
	 *
	 * @default function():ImageLoader { return new ImageLoader(); }
	 *
	 * @see feathers.controls.ImageLoader
	 * @see #iconSourceField
	 * @see #iconSourceFunction
	 */
	public var iconLoaderFactory(get, set):Dynamic;
	public function get_iconLoaderFactory():Dynamic
	{
		return this._iconLoaderFactory;
	}

	/**
	 * @private
	 */
	public function set_iconLoaderFactory(value:Dynamic):Dynamic
	{
		if(this._iconLoaderFactory == value)
		{
			return this._iconLoaderFactory;
		}
		this._iconLoaderFactory = value;
		this._iconIsFromItem = false;
		this.replaceIcon(null);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._iconLoaderFactory;
	}

	/**
	 * @private
	 */
	private var _iconLabelFactory:Void->ITextRenderer;

	/**
	 * A function that generates <code>ITextRenderer</code> that uses the result
	 * of <code>iconLabelField</code> or <code>iconLabelFunction</code>.
	 * CAn be used to set properties on the <code>ITextRenderer</code>.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * <p>In the following example, the icon label factory is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.iconLabelFactory = function():ITextRenderer
	 * {
	 *    var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
	 *    renderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
	 *    renderer.embedFonts = true;
	 *    return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 * @see #iconLabelField
	 * @see #iconLabelFunction
	 */
	public var iconLabelFactory(get, set):Void->ITextRenderer;
	public function get_iconLabelFactory():Void->ITextRenderer
	{
		return this._iconLabelFactory;
	}

	/**
	 * @private
	 */
	public function set_iconLabelFactory(value:Void->ITextRenderer):Void->ITextRenderer
	{
		if(this._iconLabelFactory == value)
		{
			return this._iconLabelFactory;
		}
		this._iconLabelFactory = value;
		this._iconIsFromItem = false;
		this.replaceIcon(null);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._iconLabelFactory;
	}

	/**
	 * @private
	 */
	private var _iconLabelProperties:PropertyProxy;

	/**
	 * An object that stores properties for the icon label text renderer
	 * sub-component (if using <code>iconLabelField</code> or
	 * <code>iconLabelFunction</code>), and the properties will be passed
	 * down to the text renderer when this component validates. The
	 * available properties depend on which <code>ITextRenderer</code>
	 * implementation is returned by <code>iconLabelFactory</code>. Refer to
	 * <a href="../../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>iconLabelFactory</code>
	 * function instead of using <code>iconLabelProperties</code> will
	 * result in better performance.</p>
	 *
	 * <p>In the following example, the icon label properties are customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.&#64;iconLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
	 * renderer.&#64;iconLabelProperties.embedFonts = true;</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #iconLabelFactory
	 * @see #iconLabelField
	 * @see #iconLabelFunction
	 */
	public var iconLabelProperties(get, set):PropertyProxy;
	public function get_iconLabelProperties():PropertyProxy
	{
		if(this._iconLabelProperties == null)
		{
			this._iconLabelProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._iconLabelProperties;
	}

	/**
	 * @private
	 */
	public function set_iconLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._iconLabelProperties == value)
		{
			return this._iconLabelProperties;
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._iconLabelProperties != null)
		{
			this._iconLabelProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._iconLabelProperties = value;
		if(this._iconLabelProperties != null)
		{
			this._iconLabelProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._iconLabelProperties;
	}

	/**
	 * @private
	 */
	private var _accessoryLoaderFactory:Dynamic = defaultLoaderFactory;

	/**
	 * A function that generates an <code>ImageLoader</code> that uses the result
	 * of <code>accessorySourceField</code> or <code>accessorySourceFunction</code>.
	 * Useful for transforming the <code>ImageLoader</code> in some way. For
	 * example, you might want to scale the texture for current screen
	 * density or apply pixel snapping.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ImageLoader</pre>
	 *
	 * <p>In the following example, the loader factory is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryLoaderFactory = function():ImageLoader
	 * {
	 *    var loader:ImageLoader = new ImageLoader();
	 *    loader.snapToPixels = true;
	 *    return loader;
	 * };</listing>
	 *
	 * @default function():ImageLoader { return new ImageLoader(); }
	 *
	 * @see feathers.controls.ImageLoader
	 * @see #accessorySourceField;
	 * @see #accessorySourceFunction;
	 */
	public var accessoryLoaderFactory(get, set):Dynamic;
	public function get_accessoryLoaderFactory():Dynamic
	{
		return this._accessoryLoaderFactory;
	}

	/**
	 * @private
	 */
	public function set_accessoryLoaderFactory(value:Dynamic):Dynamic
	{
		if(this._accessoryLoaderFactory == value)
		{
			return this._accessoryLoaderFactory;
		}
		this._accessoryLoaderFactory = value;
		this._accessoryIsFromItem = false;
		this.replaceAccessory(null);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._accessoryLoaderFactory;
	}

	/**
	 * @private
	 */
	private var _accessoryLabelFactory:Void->ITextRenderer;

	/**
	 * A function that generates <code>ITextRenderer</code> that uses the result
	 * of <code>accessoryLabelField</code> or <code>accessoryLabelFunction</code>.
	 * CAn be used to set properties on the <code>ITextRenderer</code>.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * <p>In the following example, the accessory label factory is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.accessoryLabelFactory = function():ITextRenderer
	 * {
	 *    var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
	 *    renderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
	 *    renderer.embedFonts = true;
	 *    return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessoryLabelFactory(get, set):Void->ITextRenderer;
	public function get_accessoryLabelFactory():Void->ITextRenderer
	{
		return this._accessoryLabelFactory;
	}

	/**
	 * @private
	 */
	public function set_accessoryLabelFactory(value:Void->ITextRenderer):Void->ITextRenderer
	{
		if(this._accessoryLabelFactory == value)
		{
			return this._accessoryLabelFactory;
		}
		this._accessoryLabelFactory = value;
		this._accessoryIsFromItem = false;
		this.replaceAccessory(null);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._accessoryLabelFactory;
	}

	/**
	 * @private
	 */
	private var _accessoryLabelProperties:PropertyProxy;

	/**
	 * An object that stores properties for the accessory label text
	 * renderer sub-component (if using <code>accessoryLabelField</code> or
	 * <code>accessoryLabelFunction</code>), and the properties will be
	 * passed down to the text renderer when this component validates. The
	 * available properties depend on which <code>ITextRenderer</code>
	 * implementation is returned by <code>accessoryLabelFactory</code>.
	 * Refer to <a href="../../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>accessoryLabelFactory</code>
	 * function instead of using <code>accessoryLabelProperties</code> will
	 * result in better performance.</p>
	 *
	 * <p>In the following example, the accessory label properties are customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.&#64;accessoryLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
	 * renderer.&#64;accessoryLabelProperties.embedFonts = true;</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #accessoryLabelFactory
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessoryLabelProperties(get, set):PropertyProxy;
	public function get_accessoryLabelProperties():PropertyProxy
	{
		if(this._accessoryLabelProperties == null)
		{
			this._accessoryLabelProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._accessoryLabelProperties;
	}

	/**
	 * @private
	 */
	public function set_accessoryLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._accessoryLabelProperties == value)
		{
			return this._accessoryLabelProperties;
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._accessoryLabelProperties != null)
		{
			this._accessoryLabelProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._accessoryLabelProperties = value;
		if(this._accessoryLabelProperties != null)
		{
			this._accessoryLabelProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._accessoryLabelProperties;
	}

	/**
	 * @private
	 */
	private var _skinLoaderFactory:Void->ImageLoader = defaultLoaderFactory;

	/**
	 * A function that generates an <code>ImageLoader</code> that uses the result
	 * of <code>skinSourceField</code> or <code>skinSourceFunction</code>.
	 * Useful for transforming the <code>ImageLoader</code> in some way. For
	 * example, you might want to scale the texture for current screen
	 * density or apply pixel snapping.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ImageLoader</pre>
	 *
	 * <p>In the following example, the loader factory is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.skinLoaderFactory = function():ImageLoader
	 * {
	 *    var loader:ImageLoader = new ImageLoader();
	 *    loader.snapToPixels = true;
	 *    return loader;
	 * };</listing>
	 *
	 * @default function():ImageLoader { return new ImageLoader(); }
	 *
	 * @see feathers.controls.ImageLoader
	 * @see #skinSourceField
	 * @see #skinSourceFunction
	 */
	public var skinLoaderFactory(get, set):Void->ImageLoader;
	public function get_skinLoaderFactory():Void->ImageLoader
	{
		return this._skinLoaderFactory;
	}

	/**
	 * @private
	 */
	public function set_skinLoaderFactory(value:Void->ImageLoader):Void->ImageLoader
	{
		if(this._skinLoaderFactory == value)
		{
			return this._skinLoaderFactory;
		}
		this._skinLoaderFactory = value;
		this._skinIsFromItem = false;
		this.replaceSkin(null);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._skinLoaderFactory;
	}

	/**
	 * @private
	 */
	private var _ignoreAccessoryResizes:Bool = false;

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this._iconIsFromItem)
		{
			this.replaceIcon(null);
		}
		if(this._accessoryIsFromItem)
		{
			this.replaceAccessory(null);
		}
		if(this._skinIsFromItem)
		{
			this.replaceSkin(null);
		}
		if(this._stateDelayTimer != null)
		{
			if(this._stateDelayTimer.running)
			{
				this._stateDelayTimer.stop();
			}
			this._stateDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
			this._stateDelayTimer = null;
		}
		super.dispose();
	}

	/**
	 * Using <code>labelField</code> and <code>labelFunction</code>,
	 * generates a label from the item.
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>labelFunction</code></li>
	 *     <li><code>labelField</code></li>
	 * </ol>
	 */
	public function itemToLabel(item:Dynamic):String
	{
		var labelResult:Dynamic;
		if(this._labelFunction != null)
		{
			labelResult = this._labelFunction(item);
			if(Std.is(labelResult, String))
			{
				return cast(labelResult, String);
			}
			return labelResult.toString();
		}
		else if(this._labelField != null && item && item.hasOwnProperty(this._labelField))
		{
			labelResult = Reflect.getProperty(item, this._labelField);
			if(Std.is(labelResult, String))
			{
				return cast(labelResult, String);
			}
			return labelResult.toString();
		}
		else if(Std.is(item, String))
		{
			return cast(item, String);
		}
		else if(item !== null)
		{
			//we need to use strict equality here because the data can be
			//non-strictly equal to null
			return item.toString();
		}
		return "";
	}

	/**
	 * Uses the icon fields and functions to generate an icon for a specific
	 * item.
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconLabelFunction</code></li>
	 *     <li><code>iconLabelField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 */
	private function itemToIcon(item:Dynamic):DisplayObject
	{
		var source:Dynamic;
		var labelResult:Dynamic;
		if(this._iconSourceFunction != null)
		{
			source = this._iconSourceFunction(item);
			this.refreshIconSource(source);
			return this.iconLoader;
		}
		else if(this._iconSourceField != null && item && item.hasOwnProperty(this._iconSourceField))
		{
			source = Reflect.getProperty(item, this._iconSourceField);
			this.refreshIconSource(source);
			return this.iconLoader;
		}
		else if(this._iconLabelFunction != null)
		{
			labelResult = this._iconLabelFunction(item);
			if(Std.is(labelResult, String))
			{
				this.refreshIconLabel(cast(labelResult, String));
			}
			else
			{
				this.refreshIconLabel(labelResult.toString());
			}
			return cast(this.iconLabel, DisplayObject);
		}
		else if(this._iconLabelField != null && item && item.hasOwnProperty(this._iconLabelField))
		{
			labelResult = Reflect.getProperty(item, this._iconLabelField);
			if(Std.is(labelResult, String))
			{
				this.refreshIconLabel(cast(labelResult, String));
			}
			else
			{
				this.refreshIconLabel(labelResult.toString());
			}
			return cast(this.iconLabel, DisplayObject);
		}
		else if(this._iconFunction != null)
		{
			return cast(this._iconFunction(item), DisplayObject);
		}
		else if(this._iconField != null && item && item.hasOwnProperty(this._iconField))
		{
			return cast(Reflect.getProperty(item, this._iconField), DisplayObject);
		}

		return null;
	}

	/**
	 * Uses the accessory fields and functions to generate an accessory for
	 * a specific item.
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessorySourceFunction</code></li>
	 *     <li><code>accessorySourceField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 */
	private function itemToAccessory(item:Dynamic):DisplayObject
	{
		var source:Dynamic;
		var labelResult:Dynamic;
		if(this._accessorySourceFunction != null)
		{
			source = this._accessorySourceFunction(item);
			this.refreshAccessorySource(source);
			return this.accessoryLoader;
		}
		else if(this._accessorySourceField != null && item && item.hasOwnProperty(this._accessorySourceField))
		{
			source = Reflect.getProperty(item, this._accessorySourceField);
			this.refreshAccessorySource(source);
			return this.accessoryLoader;
		}
		else if(this._accessoryLabelFunction != null)
		{
			labelResult = this._accessoryLabelFunction(item);
			if(Std.is(labelResult, String))
			{
				this.refreshAccessoryLabel(cast(labelResult, String));
			}
			else
			{
				this.refreshAccessoryLabel(labelResult.toString());
			}
			return cast(this.accessoryLabel, DisplayObject);
		}
		else if(this._accessoryLabelField != null && item && item.hasOwnProperty(this._accessoryLabelField))
		{
			labelResult = Reflect.getProperty(item, this._accessoryLabelField);
			if(Std.is(labelResult, String))
			{
				this.refreshAccessoryLabel(cast(labelResult, String));
			}
			else
			{
				this.refreshAccessoryLabel(labelResult.toString());
			}
			return cast(this.accessoryLabel, DisplayObject);
		}
		else if(this._accessoryFunction != null)
		{
			return cast(this._accessoryFunction(item), DisplayObject);
		}
		else if(this._accessoryField != null && item && item.hasOwnProperty(this._accessoryField))
		{
			return cast(Reflect.getProperty(item, this._accessoryField), DisplayObject);
		}

		return null;
	}

	/**
	 * Uses the skin fields and functions to generate a skin for a specific
	 * item.
	 *
	 * <p>All of the skin fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>skinSourceFunction</code></li>
	 *     <li><code>skinSourceField</code></li>
	 *     <li><code>skinFunction</code></li>
	 *     <li><code>skinField</code></li>
	 * </ol>
	 */
	private function itemToSkin(item:Dynamic):DisplayObject
	{
		var source:Dynamic;
		if(this._skinSourceFunction != null)
		{
			source = this._skinSourceFunction(item);
			this.refreshSkinSource(source);
			return this.skinLoader;
		}
		else if(this._skinSourceField != null && item && item.hasOwnProperty(this._skinSourceField))
		{
			source = Reflect.getProperty(item, this._skinSourceField);
			this.refreshSkinSource(source);
			return this.skinLoader;
		}
		else if(this._skinFunction != null)
		{
			return cast(this._skinFunction(item), DisplayObject);
		}
		else if(this._skinField != null && item && item.hasOwnProperty(this._skinField))
		{
			return cast(Reflect.getProperty(item, this._skinField), DisplayObject);
		}

		return null;
	}

	/**
	 * Uses the selectable fields and functions to generate a selectable
	 * value for a specific item.
	 *
	 * <p>All of the selectable fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>selectableFunction</code></li>
	 *     <li><code>selectableField</code></li>
	 * </ol>
	 */
	private function itemToSelectable(item:Dynamic):Bool
	{
		if(this._selectableFunction != null)
		{
			return cast(this._selectableFunction(item), Bool);
		}
		else if(this._selectableField != null && item && item.hasOwnProperty(this._selectableField))
		{
			return cast(Reflect.getProperty(item, this._selectableField), Bool);
		}

		return true;
	}

	/**
	 * Uses the enabled fields and functions to generate a enabled value for
	 * a specific item.
	 *
	 * <p>All of the enabled fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>enabledFunction</code></li>
	 *     <li><code>enabledField</code></li>
	 * </ol>
	 */
	private function itemToEnabled(item:Dynamic):Bool
	{
		if(this._enabledFunction != null)
		{
			return cast(this._enabledFunction(item), Bool);
		}
		else if(this._enabledField != null && item && item.hasOwnProperty(this._enabledField))
		{
			return cast(Reflect.getProperty(item, this._enabledField), Bool);
		}

		return true;
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		if(dataInvalid)
		{
			this.commitData();
		}
		if(stateInvalid || dataInvalid || stylesInvalid)
		{
			this.refreshAccessory();
		}
		super.draw();
	}

	/**
	 * @inheritDoc
	 */
	override private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		var oldIgnoreAccessoryResizes:Bool = this._ignoreAccessoryResizes;
		this._ignoreAccessoryResizes = true;
		this.refreshMaxLabelSize(true);
		if(this.labelTextRenderer != null)
		{
			this.labelTextRenderer.measureText(HELPER_POINT);
		}
		else
		{
			HELPER_POINT.setTo(0, 0);
		}
		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			if(this._label != null)
			{
				newWidth = HELPER_POINT.x;
			}
			if(this._layoutOrder == LAYOUT_ORDER_LABEL_ACCESSORY_ICON)
			{
				newWidth = this.addAccessoryWidth(newWidth);
				newWidth = this.addIconWidth(newWidth);
			}
			else
			{
				newWidth = this.addIconWidth(newWidth);
				newWidth = this.addAccessoryWidth(newWidth);
			}
			newWidth += this._paddingLeft + this._paddingRight;
			if(newWidth != newWidth) //isNaN
			{
				newWidth = this._originalSkinWidth;
				if(newWidth != newWidth) //isNaN
				{
					newWidth = 0;
				}
			}
			else if(this._originalSkinWidth == this._originalSkinWidth) //!isNaN
			{
				if(this._originalSkinWidth > newWidth)
				{
					newWidth = this._originalSkinWidth;
				}
			}
		}

		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			if(this._label != null)
			{
				newHeight = HELPER_POINT.y;
			}
			if(this._layoutOrder == LAYOUT_ORDER_LABEL_ACCESSORY_ICON)
			{
				newHeight = this.addAccessoryHeight(newHeight);
				newHeight = this.addIconHeight(newHeight);
			}
			else
			{
				newHeight = this.addIconHeight(newHeight);
				newHeight = this.addAccessoryHeight(newHeight);
			}
			newHeight += this._paddingTop + this._paddingBottom;
			if(newHeight != newHeight) //isNaN
			{
				newHeight = this._originalSkinHeight;
				if(newHeight != newHeight) //isNaN
				{
					newHeight = 0;
				}
			}
			else if(this._originalSkinHeight == this._originalSkinHeight) //!isNaN
			{
				if(this._originalSkinHeight > newHeight)
				{
					newHeight = this._originalSkinHeight;
				}
			}
		}
		this._ignoreAccessoryResizes = oldIgnoreAccessoryResizes;

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * @private
	 */
	private function addIconWidth(width:Float):Float
	{
		if(this.currentIcon == null)
		{
			return width;
		}
		var iconWidth:Float = this.currentIcon.width;
		if(iconWidth != iconWidth) //isNaN
		{
			return width;
		}

		var hasPreviousItem:Bool = width == width; //!isNaN
		if(!hasPreviousItem)
		{
			width = 0;
		}

		if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE || this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
		{
			if(hasPreviousItem)
			{
				var adjustedGap:Float = this._gap;
				if(this._gap == Math.POSITIVE_INFINITY)
				{
					adjustedGap = this._minGap;
				}
				width += adjustedGap;
			}
			width += iconWidth;
		}
		else if(iconWidth > width)
		{
			width = iconWidth;
		}
		return width;
	}

	/**
	 * @private
	 */
	private function addAccessoryWidth(width:Float):Float
	{
		if(this.accessory == null)
		{
			return width;
		}
		var accessoryWidth:Float = this.accessory.width;
		if(accessoryWidth != accessoryWidth) //isNaN
		{
			return width;
		}

		var hasPreviousItem:Bool = width == width; //!isNaN;
		if(!hasPreviousItem)
		{
			width = 0;
		}

		if(this._accessoryPosition == ACCESSORY_POSITION_LEFT || this._accessoryPosition == ACCESSORY_POSITION_RIGHT)
		{
			if(hasPreviousItem)
			{
				var adjustedAccessoryGap:Float = this._accessoryGap;
				//for some reason, if we don't call a function right here,
				//compiling with the flex 4.6 SDK will throw a VerifyError
				//for a stack overflow.
				//we could change the != check back to isNaN() instead, but
				//isNaN() can allocate an object, so we should call a different
				//function without allocation.
				this.doNothing();
				if(adjustedAccessoryGap != adjustedAccessoryGap) //isNaN
				{
					adjustedAccessoryGap = this._gap;
				}
				if(adjustedAccessoryGap == Math.POSITIVE_INFINITY)
				{
					if(this._minAccessoryGap != this._minAccessoryGap) //isNaN
					{
						adjustedAccessoryGap = this._minGap;
					}
					else
					{
						adjustedAccessoryGap = this._minAccessoryGap;
					}
				}
				width += adjustedAccessoryGap;
			}
			width += accessoryWidth;
		}
		else if(accessoryWidth > width)
		{
			width = accessoryWidth;
		}
		return width;
	}


	/**
	 * @private
	 */
	private function addIconHeight(height:Float):Float
	{
		if(this.currentIcon == null)
		{
			return height;
		}
		var iconHeight:Float = this.currentIcon.height;
		if(iconHeight != iconHeight) //isNaN
		{
			return height;
		}

		var hasPreviousItem:Bool = height == height; //!isNaN
		if(!hasPreviousItem)
		{
			height = 0;
		}

		if(this._iconPosition == ICON_POSITION_TOP || this._iconPosition == ICON_POSITION_BOTTOM)
		{
			if(hasPreviousItem)
			{
				var adjustedGap:Float = this._gap;
				if(this._gap == Math.POSITIVE_INFINITY)
				{
					adjustedGap = this._minGap;
				}
				height += adjustedGap;
			}
			height += iconHeight;
		}
		else if(iconHeight > height)
		{
			height = iconHeight;
		}
		return height;
	}

	/**
	 * @private
	 */
	private function addAccessoryHeight(height:Float):Float
	{
		if(this.accessory == null)
		{
			return height;
		}
		var accessoryHeight:Float = this.accessory.height;
		if(accessoryHeight != accessoryHeight) //isNaN
		{
			return height;
		}

		var hasPreviousItem:Bool = height == height; //!isNaN
		if(!hasPreviousItem)
		{
			height = 0;
		}

		if(this._accessoryPosition == ACCESSORY_POSITION_TOP || this._accessoryPosition == ACCESSORY_POSITION_BOTTOM)
		{
			if(hasPreviousItem)
			{
				var adjustedAccessoryGap:Float = this._accessoryGap;
				//for some reason, if we don't call a function right here,
				//compiling with the flex 4.6 SDK will throw a VerifyError
				//for a stack overflow.
				//we could change the != check back to isNaN() instead, but
				//isNaN() can allocate an object, so we should call a different
				//function without allocation.
				this.doNothing();
				if(adjustedAccessoryGap != adjustedAccessoryGap) //isNaN
				{
					adjustedAccessoryGap =  this._gap;
				}
				if(adjustedAccessoryGap == Math.POSITIVE_INFINITY)
				{
					if(this._minAccessoryGap != this._minAccessoryGap) //isNaN
					{
						adjustedAccessoryGap = this._minGap;
					}
					else
					{
						adjustedAccessoryGap = this._minAccessoryGap;
					}
				}
				height += adjustedAccessoryGap;
			}
			height += accessoryHeight;
		}
		else if(accessoryHeight > height)
		{
			height = accessoryHeight;
		}
		return height;
	}

	/**
	 * @private
	 * This function is here to work around a bug in the Flex 4.6 SDK
	 * compiler. For explanation, see the places where it gets called.
	 */
	private function doNothing():Void {}

	/**
	 * Updates the renderer to display the item's data. Override this
	 * function to pass data to sub-components and react to data changes.
	 *
	 * <p>Don't forget to handle the case where the data is <code>null</code>.</p>
	 */
	private function commitData():Void
	{
		//we need to use strict equality here because the data can be
		//non-strictly equal to null
		if(this._data !== null && this._owner)
		{
			if(this._itemHasLabel)
			{
				this._label = this.itemToLabel(this._data);
				//we don't need to invalidate because the label setter
				//uses the same data invalidation flag that triggered this
				//call to commitData(), so we're already properly invalid.
			}
			if(this._itemHasSkin)
			{
				var newSkin:DisplayObject = this.itemToSkin(this._data);
				this._skinIsFromItem = newSkin != null;
				this.replaceSkin(newSkin);
			}
			else if(this._skinIsFromItem)
			{
				this._skinIsFromItem = false;
				this.replaceSkin(null);
			}
			if(this._itemHasIcon)
			{
				var newIcon:DisplayObject = this.itemToIcon(this._data);
				this._iconIsFromItem = newIcon != null;
				this.replaceIcon(newIcon);
			}
			else if(this._iconIsFromItem)
			{
				this._iconIsFromItem = false;
				this.replaceIcon(null);
			}
			if(this._itemHasAccessory)
			{
				var newAccessory:DisplayObject = this.itemToAccessory(this._data);
				this._accessoryIsFromItem = newAccessory != null;
				this.replaceAccessory(newAccessory);
			}
			else if(this._accessoryIsFromItem)
			{
				this._accessoryIsFromItem = false;
				this.replaceAccessory(null);
			}
			if(this._itemHasSelectable)
			{
				this._isToggle = this._explicitIsToggle && this.itemToSelectable(this._data);
			}
			else
			{
				this._isToggle = this._explicitIsToggle;
			}
			if(this._itemHasEnabled)
			{
				this.refreshIsEnabled(this._explicitIsEnabled && this.itemToEnabled(this._data));
			}
			else
			{
				this.refreshIsEnabled(this._explicitIsEnabled);
			}
		}
		else
		{
			if(this._itemHasLabel)
			{
				this._label = "";
			}
			if(this._itemHasIcon || this._iconIsFromItem)
			{
				this._iconIsFromItem = false;
				this.replaceIcon(null);
			}
			if(this._itemHasSkin || this._skinIsFromItem)
			{
				this._skinIsFromItem = false;
				this.replaceSkin(null);
			}
			if(this._itemHasAccessory || this._accessoryIsFromItem)
			{
				this._accessoryIsFromItem = false;
				this.replaceAccessory(null);
			}
			if(this._itemHasSelectable)
			{
				this._isToggle = this._explicitIsToggle;
			}
			if(this._itemHasEnabled)
			{
				this.refreshIsEnabled(this._explicitIsEnabled);
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshIsEnabled(value:Bool):Void
	{
		if(this._isEnabled == value)
		{
			return;
		}
		this._isEnabled = value;
		if(!this._isEnabled)
		{
			this.touchable = false;
			this._currentState = Button.STATE_DISABLED;
			this.touchPointID = -1;
		}
		else
		{
			//might be in another state for some reason
			//let's only change to up if needed
			if(this._currentState == Button.STATE_DISABLED)
			{
				this._currentState = Button.STATE_UP;
			}
			this.touchable = true;
		}
		this.setInvalidationFlag(FeathersControl.INVALIDATION_FLAG_STATE);
	}

	/**
	 * @private
	 */
	private function replaceIcon(newIcon:DisplayObject):Void
	{
		if(this.iconLoader != null && this.iconLoader != newIcon)
		{
			this.iconLoader.removeEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
			this.iconLoader.removeEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
			this.iconLoader.dispose();
			this.iconLoader = null;
		}

		if(this.iconLabel != null && this.iconLabel != cast(newIcon, ITextRenderer))
		{
			//we can dispose this one, though, since we created it
			this.iconLabel.dispose();
			this.iconLabel = null;
		}

		if(this._itemHasIcon && this.currentIcon != null && this.currentIcon != newIcon && this.currentIcon.parent == this)
		{
			//the icon is created using the data provider, and it is not
			//created inside this class, so it is not our responsibility to
			//dispose the icon. if we dispose it, it may break something.
			this.currentIcon.removeFromParent(false);
			this.currentIcon = null;
		}
		//we're using currentIcon above, but we're emulating calling the
		//defaultIcon setter here. the Button class sets the currentIcon
		//elsewhere, so we want to take advantage of that exisiting code.

		//we're not calling the defaultIcon setter directly because we're in
		//the middle of validating, and it will just invalidate, which will
		//require another validation later. we want the Button class to
		//process the new icon immediately when we call super.draw().
		if(this._iconSelector.defaultValue != newIcon)
		{
			this._iconSelector.defaultValue = newIcon;
			//we don't want this taking precedence over our icon from the
			//data provider.
			this._stateToIconFunction = null;
			//we don't need to do a full invalidation. the superclass will
			//correctly see this flag when we call super.draw().
			this.setInvalidationFlag(FeathersControl.INVALIDATION_FLAG_STYLES);
		}

		if(this.iconLoader != null)
		{
			this.iconLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
		}
	}

	/**
	 * @private
	 */
	private function replaceAccessory(newAccessory:DisplayObject):Void
	{
		if(this.accessory == newAccessory)
		{
			return;
		}

		if(this.accessory != null)
		{
			this.accessory.removeEventListener(FeathersEventType.RESIZE, accessory_resizeHandler);
			this.accessory.removeEventListener(TouchEvent.TOUCH, accessory_touchHandler);

			if(this.accessory.parent == this)
			{
				//the accessory may have come from outside of this class. it's
				//up to that code to dispose of the accessory. in fact, if we
				//disposed of it here, we will probably screw something up, so
				//let's just remove it.
				this.accessory.removeFromParent(false);
			}
		}

		if(this.accessoryLabel != null && this.accessoryLabel != cast(newAccessory, ITextRenderer))
		{
			//we can dispose this one, though, since we created it
			this.accessoryLabel.dispose();
			this.accessoryLabel = null;
		}

		if(this.accessoryLoader != null && this.accessoryLoader != newAccessory)
		{
			this.accessoryLoader.removeEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
			this.accessoryLoader.removeEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);

			//same ability to dispose here
			this.accessoryLoader.dispose();
			this.accessoryLoader = null;
		}

		this.accessory = newAccessory;

		if(this.accessory != null)
		{
			if(Std.is(this.accessory, IFeathersControl))
			{
				if(!(Std.is(this.accessory, BitmapFontTextRenderer)))
				{
					this.accessory.addEventListener(TouchEvent.TOUCH, accessory_touchHandler);
				}
				this.accessory.addEventListener(FeathersEventType.RESIZE, accessory_resizeHandler);
			}
			this.addChild(this.accessory);
		}
		
		if(this.accessoryLoader != null)
		{
			this.accessoryLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
		}
	}

	/**
	 * @private
	 */
	private function replaceSkin(newSkin:DisplayObject):Void
	{
		if(this.skinLoader != null && this.skinLoader != newSkin)
		{
			this.skinLoader.removeEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
			this.skinLoader.removeEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
			this.skinLoader.dispose();
			this.skinLoader = null;
		}

		if(this._itemHasSkin && this.currentSkin != null && this.currentSkin != newSkin && this.currentSkin.parent == this)
		{
			//the icon is created using the data provider, and it is not
			//created inside this class, so it is not our responsibility to
			//dispose the icon. if we dispose it, it may break something.
			this.currentSkin.removeFromParent(false);
			this.currentSkin = null;
		}
		//we're using currentIcon above, but we're emulating calling the
		//defaultIcon setter here. the Button class sets the currentIcon
		//elsewhere, so we want to take advantage of that exisiting code.

		//we're not calling the defaultSkin setter directly because we're in
		//the middle of validating, and it will just invalidate, which will
		//require another validation later. we want the Button class to
		//process the new skin immediately when we call super.draw().
		if(this._skinSelector.defaultValue != newSkin)
		{
			this._skinSelector.defaultValue = newSkin;
			//we don't want this taking precedence over our skin from the
			//data provider.
			this._stateToSkinFunction = null;
			//we don't need to do a full invalidation. the superclass will
			//correctly see this flag when we call super.draw().
			this.setInvalidationFlag(FeathersControl.INVALIDATION_FLAG_STYLES);
		}

		if(this.skinLoader != null)
		{
			this.skinLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
		}
	}

	/**
	 * @private
	 */
	override private function refreshIcon():Void
	{
		super.refreshIcon();
		if(this.iconLabel != null)
		{
			var displayIconLabel:DisplayObject = cast(this.iconLabel, DisplayObject);
			for (propertyName in Reflect.fields(this._iconLabelProperties.storage))
			{
				var propertyValue:Dynamic = Reflect.getProperty(this._iconLabelProperties.storage, propertyName);
				Reflect.setProperty(displayIconLabel, propertyName, propertyValue);
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshAccessory():Void
	{
		if(Std.is(this.accessory, IFeathersControl))
		{
			cast(this.accessory, IFeathersControl).isEnabled = this._isEnabled;
		}
		if(this.accessoryLabel != null)
		{
			var displayAccessoryLabel:DisplayObject = cast(this.accessoryLabel, DisplayObject);
			for (propertyName in Reflect.fields(this._accessoryLabelProperties.storage))
			{
				var propertyValue:Dynamic = Reflect.field(this._accessoryLabelProperties.storage, propertyName);
				Reflect.setProperty(displayAccessoryLabel, propertyName, propertyValue);
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshIconSource(source:Dynamic):Void
	{
		if(this.iconLoader == null)
		{
			this.iconLoader = this._iconLoaderFactory();
			this.iconLoader.addEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
			this.iconLoader.addEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
		}
		this.iconLoader.source = source;
	}

	/**
	 * @private
	 */
	private function refreshIconLabel(label:String):Void
	{
		if(this.iconLabel == null)
		{
			var factory:Dynamic = this._iconLabelFactory != null ? this._iconLabelFactory : FeathersControl.defaultTextRendererFactory;
			this.iconLabel = factory();
			this.iconLabel.styleNameList.add(this.iconLabelStyleName);
		}
		this.iconLabel.text = label;
	}

	/**
	 * @private
	 */
	private function refreshAccessorySource(source:Dynamic):Void
	{
		if(this.accessoryLoader == null)
		{
			this.accessoryLoader = this._accessoryLoaderFactory();
			this.accessoryLoader.addEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
			this.accessoryLoader.addEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
		}
		this.accessoryLoader.source = source;
	}

	/**
	 * @private
	 */
	private function refreshAccessoryLabel(label:String):Void
	{
		if(this.accessoryLabel == null)
		{
			var factory:Void->ITextRenderer = this._accessoryLabelFactory != null ? this._accessoryLabelFactory : FeathersControl.defaultTextRendererFactory;
			this.accessoryLabel = factory();
			this.accessoryLabel.styleNameList.add(this.accessoryLabelStyleName);
		}
		this.accessoryLabel.text = label;
	}

	/**
	 * @private
	 */
	private function refreshSkinSource(source:Dynamic):Void
	{
		if(this.skinLoader == null)
		{
			this.skinLoader = this._skinLoaderFactory();
			this.skinLoader.addEventListener(Event.COMPLETE, loader_completeOrErrorHandler);
			this.skinLoader.addEventListener(FeathersEventType.ERROR, loader_completeOrErrorHandler);
		}
		this.skinLoader.source = source;
	}

	/**
	 * @private
	 */
	override private function layoutContent():Void
	{
		var oldIgnoreAccessoryResizes:Bool = this._ignoreAccessoryResizes;
		this._ignoreAccessoryResizes = true;
		var oldIgnoreIconResizes:Boolean = this._ignoreIconResizes;
		this._ignoreIconResizes = true;
		this.refreshMaxLabelSize(false);
		var labelRenderer:DisplayObject = null;
		if(this._label != null && this.labelTextRenderer != null)
		{
			this.labelTextRenderer.validate();
			labelRenderer = cast(this.labelTextRenderer, DisplayObject);
		}
		var iconIsInLayout:Bool = this.currentIcon != null && this._iconPosition != ICON_POSITION_MANUAL;
		var accessoryIsInLayout:Bool = this.accessory != null && this._accessoryPosition != ACCESSORY_POSITION_MANUAL;
		var accessoryGap:Float = this._accessoryGap;
		if(accessoryGap != accessoryGap) //isNaN
		{
			accessoryGap = this._gap;
		}
		if(this._label != null && this.labelTextRenderer != null && iconIsInLayout && accessoryIsInLayout)
		{
			this.positionSingleChild(labelRenderer);
			if(this._layoutOrder == LAYOUT_ORDER_LABEL_ACCESSORY_ICON)
			{
				this.positionRelativeToOthers(this.accessory, labelRenderer, null, this._accessoryPosition, accessoryGap, null, 0);
				var iconPosition:String = this._iconPosition;
				if(iconPosition == ICON_POSITION_LEFT_BASELINE)
				{
					iconPosition = ICON_POSITION_LEFT;
				}
				else if(iconPosition == ICON_POSITION_RIGHT_BASELINE)
				{
					iconPosition = ICON_POSITION_RIGHT;
				}
				this.positionRelativeToOthers(this.currentIcon, labelRenderer, this.accessory, iconPosition, this._gap, this._accessoryPosition, accessoryGap);
			}
			else
			{
				this.positionLabelAndIcon();
				this.positionRelativeToOthers(this.accessory, labelRenderer, this.currentIcon, this._accessoryPosition, accessoryGap, this._iconPosition, this._gap);
			}
		}
		else if(this._label != null && this.labelTextRenderer != null)
		{
			this.positionSingleChild(labelRenderer);
			//we won't position both the icon and accessory here, otherwise
			//we would have gone into the previous conditional
			if(iconIsInLayout)
			{
				this.positionLabelAndIcon();
			}
			else if(accessoryIsInLayout)
			{
				this.positionRelativeToOthers(this.accessory, labelRenderer, null, this._accessoryPosition, accessoryGap, null, 0);
			}
		}
		else if(iconIsInLayout)
		{
			this.positionSingleChild(this.currentIcon);
			if(accessoryIsInLayout)
			{
				this.positionRelativeToOthers(this.accessory, this.currentIcon, null, this._accessoryPosition, accessoryGap, null, 0);
			}
		}
		else if(accessoryIsInLayout)
		{
			this.positionSingleChild(this.accessory);
		}

		if(this.accessory != null)
		{
			if(!accessoryIsInLayout)
			{
				this.accessory.x = this._paddingLeft;
				this.accessory.y = this._paddingTop;
			}
			this.accessory.x += this._accessoryOffsetX;
			this.accessory.y += this._accessoryOffsetY;
		}
		if(this.currentIcon != null)
		{
			if(!iconIsInLayout)
			{
				this.currentIcon.x = this._paddingLeft;
				this.currentIcon.y = this._paddingTop;
			}
			this.currentIcon.x += this._iconOffsetX;
			this.currentIcon.y += this._iconOffsetY;
		}
		if(this._label  != null&& this.labelTextRenderer != null)
		{
			this.labelTextRenderer.x += this._labelOffsetX;
			this.labelTextRenderer.y += this._labelOffsetY;
		}
		this._ignoreIconResizes = oldIgnoreIconResizes;
		this._ignoreAccessoryResizes = oldIgnoreAccessoryResizes;
	}

	/**
	 * @private
	 */
	override private function refreshMaxLabelSize(forMeasurement:Boolean):void
	{
		var calculatedWidth:Float = this.actualWidth;
		if(forMeasurement)
		{
			calculatedWidth = this.explicitWidth;
			if(calculatedWidth != calculatedWidth) //isNaN
			{
				calculatedWidth = this._maxWidth;
			}
		}
		calculatedWidth -= (this._paddingLeft + this._paddingRight);
		var calculatedHeight:Number = this.actualHeight;
		if(forMeasurement)
		{
			calculatedHeight = this.explicitHeight;
			if(calculatedHeight !== calculatedHeight) //isNaN
			{
				calculatedHeight = this._maxHeight;
			}
		}
		calculatedHeight -= (this._paddingTop + this._paddingBottom);

		var adjustedGap:Float = this._gap;
		if(adjustedGap == Math.POSITIVE_INFINITY)
		{
			adjustedGap = this._minGap;
		}
		var adjustedAccessoryGap:Float = this._accessoryGap;
		if(adjustedAccessoryGap != adjustedAccessoryGap) //isNaN
		{
			adjustedAccessoryGap = this._gap;
		}
		if(adjustedAccessoryGap == Math.POSITIVE_INFINITY)
		{
			adjustedAccessoryGap = this._minAccessoryGap;
			if(adjustedAccessoryGap != adjustedAccessoryGap) //isNaN
			{
				adjustedAccessoryGap = this._minGap;
			}
		}

		var hasIconToLeftOrRight:Bool = this.currentIcon != null && (this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE ||
			this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE);
		var hasIconToTopOrBottom:Boolean = this.currentIcon && (this._iconPosition == ICON_POSITION_TOP || this._iconPosition == ICON_POSITION_BOTTOM);
		var hasAccessoryToLeftOrRight:Boolean = this.accessory && (this._accessoryPosition == ACCESSORY_POSITION_LEFT || this._accessoryPosition == ACCESSORY_POSITION_RIGHT);
		var hasAccessoryToTopOrBottom:Boolean = this.accessory && (this._accessoryPosition == ACCESSORY_POSITION_TOP || this._accessoryPosition == ACCESSORY_POSITION_BOTTOM);

		if(this.accessoryLabel != null)
		{
			var iconAffectsAccessoryLabelMaxWidth:Bool = hasIconToLeftOrRight && (hasAccessoryToLeftOrRight || this._layoutOrder == LAYOUT_ORDER_LABEL_ACCESSORY_ICON);
			if(this.iconLabel != null)
			{
				this.iconLabel.maxWidth = calculatedWidth - adjustedGap;
				if(this.iconLabel.maxWidth < 0)
				{
					this.iconLabel.maxWidth = 0;
				}
			}
			if(Std.is(this.currentIcon, IValidating))
			{
				cast(this.currentIcon, IValidating).validate();
			}
			if(iconAffectsAccessoryLabelMaxWidth)
			{
				calculatedWidth -= (this.currentIcon.width + adjustedGap);
			}
			if(calculatedWidth < 0)
			{
				calculatedWidth = 0;
			}
			this.accessoryLabel.maxWidth = calculatedWidth;
			this.accessoryLabel.maxHeight = calculatedHeight;
			if(hasIconToLeftOrRight && this.currentIcon && !iconAffectsAccessoryLabelMaxWidth)
			{
				calculatedWidth -= (this.currentIcon.width + adjustedGap);
			}
			if(Std.is(this.accessory, IValidating))
			{
				cast(this.accessory, IValidating).validate();
			}
			if(hasAccessoryToLeftOrRight)
			{
				calculatedWidth -= (this.accessory.width + adjustedAccessoryGap);
			}
			if(hasAccessoryToTopOrBottom)
			{
				calculatedHeight -= (this.accessory.height + adjustedAccessoryGap);
			}
		}
		else if(this.iconLabel != null)
		{
			var accessoryAffectsIconLabelMaxWidth:Bool = hasAccessoryToLeftOrRight && (hasIconToLeftOrRight || this._layoutOrder == LAYOUT_ORDER_LABEL_ICON_ACCESSORY);
			if(Std.is(this.accessory, IValidating))
			{
				cast(this.accessory, IValidating).validate();
			}
			if(accessoryAffectsIconLabelMaxWidth)
			{
				calculatedWidth -= (adjustedAccessoryGap + this.accessory.width);
			}
			if(calculatedWidth < 0)
			{
				calculatedWidth = 0;
			}
			this.iconLabel.maxWidth = calculatedWidth;
			this.iconLabel.maxHeight = calculatedHeight;
			if(hasAccessoryToLeftOrRight && this.accessory && !accessoryAffectsIconLabelMaxWidth)
			{
				calculatedWidth -= (adjustedAccessoryGap + this.accessory.width);
			}
			if(Std.is(this.currentIcon, IValidating))
			{
				cast(this.currentIcon, IValidating).validate();
			}
			if(hasIconToLeftOrRight)
			{
				calculatedWidth -= (this.currentIcon.width + adjustedGap);
			}
			if(hasIconToTopOrBottom)
			{
				calculatedHeight -= (this.currentIcon.height + adjustedGap);
			}
		}
		else
		{
			if(Std.is(this.currentIcon, IValidating))
			{
				cast(this.currentIcon, IValidating).validate();
			}
			if(hasIconToLeftOrRight)
			{
				calculatedWidth -= (adjustedGap + this.currentIcon.width);
			}
			if(hasIconToTopOrBottom)
			{
				calculatedHeight -= (adjustedGap + this.currentIcon.height);
			}
			if(this.accessory is IValidating)
			{
				cast(this.accessory, IValidating).validate();
			}
			if(hasAccessoryToLeftOrRight)
			{
				calculatedWidth -= (adjustedAccessoryGap + this.accessory.width);
			}
			if(hasAccessoryToTopOrBottom)
			{
				calculatedHeight -= (adjustedAccessoryGap + this.accessory.height);
			}
		}
		if(calculatedWidth < 0)
		{
			calculatedWidth = 0;
		}
		if(calculatedHeight < 0)
		{
			calculatedHeight = 0;
		}
		if(this.labelTextRenderer)
		{
			this.labelTextRenderer.maxWidth = calculatedWidth;
			this.labelTextRenderer.maxHeight = calculatedHeight;
		}
	}

	/**
	 * @private
	 */
	private function positionRelativeToOthers(object:DisplayObject, relativeTo:DisplayObject, relativeTo2:DisplayObject, position:String, gap:Float, otherPosition:String, otherGap:Float):Void
	{
		var relativeToX:Float = relativeTo2 != null ? Math.min(relativeTo.x, relativeTo2.x) : relativeTo.x;
		var relativeToY:Float = relativeTo2 != null ? Math.min(relativeTo.y, relativeTo2.y) : relativeTo.y;
		var relativeToWidth:Float = relativeTo2 != null ? (Math.max(relativeTo.x + relativeTo.width, relativeTo2.x + relativeTo2.width) - relativeToX) : relativeTo.width;
		var relativeToHeight:Float = relativeTo2 != null ? (Math.max(relativeTo.y + relativeTo.height, relativeTo2.y + relativeTo2.height) - relativeToY) : relativeTo.height;
		var newRelativeToX:Float = relativeToX;
		var newRelativeToY:Float = relativeToY;
		if(position == ACCESSORY_POSITION_TOP)
		{
			if(gap == Math.POSITIVE_INFINITY)
			{
				object.y = this._paddingTop;
				newRelativeToY = this.actualHeight - this._paddingBottom - relativeToHeight;
			}
			else
			{
				if(this._verticalAlign == VERTICAL_ALIGN_TOP)
				{
					newRelativeToY += object.height + gap;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					newRelativeToY += Math.round((object.height + gap) / 2);
				}
				if(relativeTo2 != null)
				{
					newRelativeToY = Math.max(newRelativeToY, this._paddingTop + object.height + gap);
				}
				object.y = newRelativeToY - object.height - gap;
			}
		}
		else if(position == ACCESSORY_POSITION_RIGHT)
		{
			if(gap == Math.POSITIVE_INFINITY)
			{
				newRelativeToX = this._paddingLeft;
				object.x = this.actualWidth - this._paddingRight - object.width;
			}
			else
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					newRelativeToX -= (object.width + gap);
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					newRelativeToX -= Math.round((object.width + gap) / 2);
				}
				if(relativeTo2 != null)
				{
					newRelativeToX = Math.min(newRelativeToX, this.actualWidth - this._paddingRight - object.width - relativeToWidth - gap);
				}
				object.x = newRelativeToX + relativeToWidth + gap;
			}
		}
		else if(position == ACCESSORY_POSITION_BOTTOM)
		{
			if(gap == Math.POSITIVE_INFINITY)
			{
				newRelativeToY = this._paddingTop;
				object.y = this.actualHeight - this._paddingBottom - object.height;
			}
			else
			{
				if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					newRelativeToY -= (object.height + gap);
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					newRelativeToY -= Math.round((object.height + gap) / 2);
				}
				if(relativeTo2 != null)
				{
					newRelativeToY = Math.min(newRelativeToY, this.actualHeight - this._paddingBottom - object.height - relativeToHeight - gap);
				}
				object.y = newRelativeToY + relativeToHeight + gap;
			}
		}
		else if(position == ACCESSORY_POSITION_LEFT)
		{
			if(gap == Math.POSITIVE_INFINITY)
			{
				object.x = this._paddingLeft;
				newRelativeToX = this.actualWidth - this._paddingRight - relativeToWidth;
			}
			else
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
				{
					newRelativeToX += gap + object.width;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					newRelativeToX += Math.round((gap + object.width) / 2);
				}
				if(relativeTo2 != null)
				{
					newRelativeToX = Math.max(newRelativeToX, this._paddingLeft + object.width + gap);
				}
				object.x = newRelativeToX - gap - object.width;
			}
		}

		var offsetX:Float = newRelativeToX - relativeToX;
		var offsetY:Float = newRelativeToY - relativeToY;
		if(relativeTo2 == null || otherGap != Math.POSITIVE_INFINITY || !(
			(position == ACCESSORY_POSITION_TOP && otherPosition == ACCESSORY_POSITION_TOP) ||
			(position == ACCESSORY_POSITION_RIGHT && otherPosition == ACCESSORY_POSITION_RIGHT) ||
			(position == ACCESSORY_POSITION_BOTTOM && otherPosition == ACCESSORY_POSITION_BOTTOM) ||
			(position == ACCESSORY_POSITION_LEFT && otherPosition == ACCESSORY_POSITION_LEFT)
		))
		{
			relativeTo.x += offsetX;
			relativeTo.y += offsetY;
		}
		if(relativeTo2 != null)
		{
			if(otherGap != Math.POSITIVE_INFINITY || !(
				(position == ACCESSORY_POSITION_LEFT && otherPosition == ACCESSORY_POSITION_RIGHT) ||
				(position == ACCESSORY_POSITION_RIGHT && otherPosition == ACCESSORY_POSITION_LEFT) ||
				(position == ACCESSORY_POSITION_TOP && otherPosition == ACCESSORY_POSITION_BOTTOM) ||
				(position == ACCESSORY_POSITION_BOTTOM && otherPosition == ACCESSORY_POSITION_TOP)
			))
			{
				relativeTo2.x += offsetX;
				relativeTo2.y += offsetY;
			}
			if(gap == Math.POSITIVE_INFINITY && otherGap == Math.POSITIVE_INFINITY)
			{
				if(position == ACCESSORY_POSITION_RIGHT && otherPosition == ACCESSORY_POSITION_LEFT)
				{
					relativeTo.x = relativeTo2.x + Math.round((object.x - relativeTo2.x + relativeTo2.width - relativeTo.width) / 2);
				}
				else if(position == ACCESSORY_POSITION_LEFT && otherPosition == ACCESSORY_POSITION_RIGHT)
				{
					relativeTo.x = object.x + Math.round((relativeTo2.x - object.x + object.width - relativeTo.width) / 2);
				}
				else if(position == ACCESSORY_POSITION_RIGHT && otherPosition == ACCESSORY_POSITION_RIGHT)
				{
					relativeTo2.x = relativeTo.x + Math.round((object.x - relativeTo.x + relativeTo.width - relativeTo2.width) / 2);
				}
				else if(position == ACCESSORY_POSITION_LEFT && otherPosition == ACCESSORY_POSITION_LEFT)
				{
					relativeTo2.x = object.x + Math.round((relativeTo.x - object.x + object.width - relativeTo2.width) / 2);
				}
				else if(position == ACCESSORY_POSITION_BOTTOM && otherPosition == ACCESSORY_POSITION_TOP)
				{
					relativeTo.y = relativeTo2.y + Math.round((object.y - relativeTo2.y + relativeTo2.height - relativeTo.height) / 2);
				}
				else if(position == ACCESSORY_POSITION_TOP && otherPosition == ACCESSORY_POSITION_BOTTOM)
				{
					relativeTo.y = object.y + Math.round((relativeTo2.y - object.y + object.height - relativeTo.height) / 2);
				}
				else if(position == ACCESSORY_POSITION_BOTTOM && otherPosition == ACCESSORY_POSITION_BOTTOM)
				{
					relativeTo2.y = relativeTo.y + Math.round((object.y - relativeTo.y + relativeTo.height - relativeTo2.height) / 2);
				}
				else if(position == ACCESSORY_POSITION_TOP && otherPosition == ACCESSORY_POSITION_TOP)
				{
					relativeTo2.y = object.y + Math.round((relativeTo.y - object.y + object.height - relativeTo2.height) / 2);
				}
			}
		}

		if(position == ACCESSORY_POSITION_LEFT || position == ACCESSORY_POSITION_RIGHT)
		{
			if(this._verticalAlign == VERTICAL_ALIGN_TOP)
			{
				object.y = this._paddingTop;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				object.y = this.actualHeight - this._paddingBottom - object.height;
			}
			else //middle
			{
				object.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - object.height) / 2);
			}
		}
		else if(position == ACCESSORY_POSITION_TOP || position == ACCESSORY_POSITION_BOTTOM)
		{
			if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
			{
				object.x = this._paddingLeft;
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				object.x = this.actualWidth - this._paddingRight - object.width;
			}
			else //center
			{
				object.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - object.width) / 2);
			}
		}
	}

	/**
	 * @private
	 */
	private function owner_scrollStartHandler(event:Event):Void
	{
		if(this._delayTextureCreationOnScroll)
		{
			if(this.accessoryLoader != null)
			{
				this.accessoryLoader.delayTextureCreation = true;
			}
			if(this.iconLoader != null)
			{
				this.iconLoader.delayTextureCreation = true;
			}
		}

		if(this.touchPointID < 0 && this.accessoryTouchPointID < 0)
		{
			return;
		}
		this.resetTouchState();
		if(this._stateDelayTimer != null && this._stateDelayTimer.running)
		{
			this._stateDelayTimer.stop();
		}
		this._delayedCurrentState = null;

		if(this.accessoryTouchPointID >= 0)
		{
			this._owner.stopScrolling();
		}
	}

	/**
	 * @private
	 */
	private function owner_scrollCompleteHandler(event:Event):Void
	{
		if(this._delayTextureCreationOnScroll)
		{
			if(this.accessoryLoader != null)
			{
				this.accessoryLoader.delayTextureCreation = false;
			}
			if(this.iconLoader != null)
			{
				this.iconLoader.delayTextureCreation = false;
			}
		}
	}

	/**
	 * @private
	 */
	override private function button_removedFromStageHandler(event:Event):Void
	{
		super.button_removedFromStageHandler(event);
		this.accessoryTouchPointID = -1;
	}

	/**
	 * @private
	 */
	private function itemRenderer_triggeredHandler(event:Event):Void
	{
		if(this._isToggle || !this.isSelectableWithoutToggle || (this._itemHasSelectable && !this.itemToSelectable(this._data)))
		{
			return;
		}
		this.isSelected = true;
	}

	/**
	 * @private
	 */
	private function stateDelayTimer_timerCompleteHandler(event:TimerEvent):Void
	{
		super.currentState = this._delayedCurrentState;
		this._delayedCurrentState = null;
	}

	/**
	 * @private
	 */
	override private function button_touchHandler(event:TouchEvent):Void
	{
		if(this.accessory != null && !this._isSelectableOnAccessoryTouch && safe_cast(this.accessory, ITextRenderer) != this.accessoryLabel && this.accessory != this.accessoryLoader && this.touchPointID < 0)
		{
			//ignore all touches on accessories that are not labels or
			//loaders. return to up state.
			var touch:Touch = event.getTouch(this.accessory);
			if(touch != null)
			{
				this.currentState = Button.STATE_UP;
				return;
			}
		}
		super.button_touchHandler(event);
	}

	/**
	 * @private
	 */
	private function accessory_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this.accessoryTouchPointID = -1;
			return;
		}
		if(!this._stopScrollingOnAccessoryTouch ||
			safe_cast(this.accessory, ITextRenderer) == this.accessoryLabel ||
			this.accessory == this.accessoryLoader)
		{
			//do nothing
			return;
		}

		var touch:Touch;
		if(this.accessoryTouchPointID >= 0)
		{
			touch = event.getTouch(this.accessory, TouchPhase.ENDED, this.accessoryTouchPointID);
			if(touch == null)
			{
				return;
			}
			this.accessoryTouchPointID = -1;
		}
		else //if we get here, we don't have a saved touch ID yet
		{
			touch = event.getTouch(this.accessory, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this.accessoryTouchPointID = touch.id;
		}
	}

	/**
	 * @private
	 */
	private function accessory_resizeHandler(event:Event):Void
	{
		if(this._ignoreAccessoryResizes)
		{
			return;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function loader_completeOrErrorHandler(event:Event):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}
}