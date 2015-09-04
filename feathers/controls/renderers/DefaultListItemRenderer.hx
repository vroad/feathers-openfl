/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers;
import feathers.controls.List;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.core.FeathersControl;
import feathers.utils.type.SafeCast.safe_cast;

/**
 * The default item renderer for List control. Supports up to three optional
 * sub-views, including a label to display text, an icon to display an
 * image, and an "accessory" to display a UI control or another display
 * object (with shortcuts for including a second image or a second label).
 * 
 * @see feathers.controls.List
 */
class DefaultListItemRenderer extends BaseDefaultItemRenderer implements IListItemRenderer
{
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
	 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_TOP
	 *
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
	 */
	inline public static var ACCESSORY_POSITION_TOP:String = "top";

	/**
	 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_RIGHT
	 *
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
	 */
	inline public static var ACCESSORY_POSITION_RIGHT:String = "right";

	/**
	 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_BOTTOM
	 *
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
	 */
	inline public static var ACCESSORY_POSITION_BOTTOM:String = "bottom";

	/**
	 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_LEFT
	 *
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
	 */
	inline public static var ACCESSORY_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#ACCESSORY_POSITION_MANUAL
	 *
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryPosition
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryOffsetX
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#accessoryOffsetY
	 */
	inline public static var ACCESSORY_POSITION_MANUAL:String = "manual";

	/**
	 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#LAYOUT_ORDER_LABEL_ACCESSORY_ICON
	 *
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#layoutOrder
	 */
	inline public static var LAYOUT_ORDER_LABEL_ACCESSORY_ICON:String = "labelAccessoryIcon";

	/**
	 * @copy feathers.controls.renderers.BaseDefaultItemRenderer#LAYOUT_ORDER_LABEL_ICON_ACCESSORY
	 *
	 * @see feathers.controls.renderers.BaseDefaultItemRenderer#layoutOrder
	 */
	inline public static var LAYOUT_ORDER_LABEL_ICON_ACCESSORY:String = "labelIconAccessory";

	/**
	 * The default <code>IStyleProvider</code> for all <code>DefaultListItemRenderer</code>
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
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return DefaultListItemRenderer.globalStyleProvider;
	}
	
	/**
	 * @private
	 */
	private var _index:Int = -1;
	
	/**
	 * @inheritDoc
	 */
	public var index(get, set):Int;
	public function get_index():Int
	{
		return this._index;
	}
	
	/**
	 * @private
	 */
	public function set_index(value:Int):Int
	{
		this._index = value;
		return get_index();
	}
	
	/**
	 * @inheritDoc
	 */
	public var owner(get, set):List;
	public function get_owner():List
	{
		return safe_cast(this._owner, List);
	}
	
	/**
	 * @private
	 */
	public function set_owner(value:List):List
	{
		if(this._owner == value)
		{
			return get_owner();
		}
		if(this._owner != null)
		{
			this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
		}
		this._owner = value;
		if(this._owner != null)
		{
			var list:List = cast(this._owner, List);
			this.isSelectableWithoutToggle = list.isSelectable;
			if(list.allowMultipleSelection)
			{
				//toggling is forced in this case
				this.isToggle = true;
			}
			this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_owner();
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		this.owner = null;
		super.dispose();
	}
}