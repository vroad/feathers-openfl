/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.skins.IStyleProvider;
import feathers.utils.math.FeathersMathUtil.clamp;

import starling.display.DisplayObject;

import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STATE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;

/**
 * Displays the progress of a task over time. Non-interactive.
 *
 * <p>The following example creates a progress bar:</p>
 *
 * <listing version="3.0">
 * var progress:ProgressBar = new ProgressBar();
 * progress.minimum = 0;
 * progress.maximum = 100;
 * progress.value = 20;
 * this.addChild( progress );</listing>
 *
 * @see ../../../help/progress-bar.html How to use the Feathers ProgressBar component
 */
class ProgressBar extends FeathersControl
{
	/**
	 * The progress bar fills horizontally (on the x-axis).
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * The progress bar fills vertically (on the y-axis).
	 *
	 * @see #direction
	 */
	inline public static var DIRECTION_VERTICAL:String = "vertical";

	/**
	 * The default <code>IStyleProvider</code> for all <code>ProgressBar</code>
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
		return ProgressBar.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _direction:String = DIRECTION_HORIZONTAL;

	//[Inspectable(type="String",enumeration="horizontal,vertical")]
	/**
	 * Determines the direction that the progress bar fills. When this value
	 * changes, the progress bar's width and height values do not change
	 * automatically.
	 *
	 * <p>In the following example, the direction is set to vertical:</p>
	 *
	 * <listing version="3.0">
	 * progress.direction = ProgressBar.DIRECTION_VERTICAL;</listing>
	 *
	 * @default ProgressBar.DIRECTION_HORIZONTAL
	 *
	 * @see #DIRECTION_HORIZONTAL
	 * @see #DIRECTION_VERTICAL
	 */
	public var direction(get, set):String;
	public function get_direction():String
	{
		return this._direction;
	}

	/**
	 * @private
	 */
	public function set_direction(value:String):String
	{
		if(this._direction == value)
		{
			return get_direction();
		}
		this._direction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_direction();
	}

	/**
	 * @private
	 */
	private var _value:Float = 0;

	/**
	 * The value of the progress bar, between the minimum and maximum.
	 *
	 * <p>In the following example, the value is set to 12:</p>
	 *
	 * <listing version="3.0">
	 * progress.minimum = 0;
	 * progress.maximum = 100;
	 * progress.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #minimum
	 * @see #maximum
	 */
	public var value(get, set):Float;
	public function get_value():Float
	{
		return this._value;
	}

	/**
	 * @private
	 */
	public function set_value(newValue:Float):Float
	{
		newValue = clamp(newValue, this._minimum, this._maximum);
		if(this._value == newValue)
		{
			return get_value();
		}
		this._value = newValue;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_value();
	}

	/**
	 * @private
	 */
	private var _minimum:Float = 0;

	/**
	 * The progress bar's value will not go lower than the minimum.
	 *
	 * <p>In the following example, the minimum is set to 0:</p>
	 *
	 * <listing version="3.0">
	 * progress.minimum = 0;
	 * progress.maximum = 100;
	 * progress.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #value
	 * @see #maximum
	 */
	public var minimum(get, set):Float;
	public function get_minimum():Float
	{
		return this._minimum;
	}

	/**
	 * @private
	 */
	public function set_minimum(value:Float):Float
	{
		if(this._minimum == value)
		{
			return get_minimum();
		}
		this._minimum = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_minimum();
	}

	/**
	 * @private
	 */
	private var _maximum:Float = 1;

	/**
	 * The progress bar's value will not go higher than the maximum.
	 *
	 * <p>In the following example, the maximum is set to 100:</p>
	 *
	 * <listing version="3.0">
	 * progress.minimum = 0;
	 * progress.maximum = 100;
	 * progress.value = 12;</listing>
	 *
	 * @default 1
	 *
	 * @see #value
	 * @see #minimum
	 */
	public var maximum(get, set):Float;
	public function get_maximum():Float
	{
		return this._maximum;
	}

	/**
	 * @private
	 */
	public function set_maximum(value:Float):Float
	{
		if(this._maximum == value)
		{
			return get_maximum();
		}
		this._maximum = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_maximum();
	}

	/**
	 * @private
	 */
	private var _originalBackgroundWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _originalBackgroundHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var currentBackground:DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * The primary background to display.
	 *
	 * <p>In the following example, the progress bar is given a background
	 * skin:</p>
	 *
	 * <listing version="3.0">
	 * progress.backgroundSkin = new Image( texture );</listing>
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

		if(this._backgroundSkin != null && this._backgroundSkin != this._backgroundDisabledSkin)
		{
			this.removeChild(this._backgroundSkin);
		}
		this._backgroundSkin = value;
		if(this._backgroundSkin != null && this._backgroundSkin.parent != this)
		{
			this._backgroundSkin.visible = false;
			this.addChildAt(this._backgroundSkin, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_backgroundSkin();
	}

	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * A background to display when the progress bar is disabled.
	 *
	 * <p>In the following example, the progress bar is given a disabled
	 * background skin:</p>
	 *
	 * <listing version="3.0">
	 * progress.backgroundDisabledSkin = new Image( texture );</listing>
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

		if(this._backgroundDisabledSkin !=null && this._backgroundDisabledSkin != this._backgroundSkin)
		{
			this.removeChild(this._backgroundDisabledSkin);
		}
		this._backgroundDisabledSkin = value;
		if(this._backgroundDisabledSkin !=null && this._backgroundDisabledSkin.parent != this)
		{
			this._backgroundDisabledSkin.visible = false;
			this.addChildAt(this._backgroundDisabledSkin, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_backgroundDisabledSkin();
	}

	/**
	 * @private
	 */
	private var _originalFillWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _originalFillHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var currentFill:DisplayObject;

	/**
	 * @private
	 */
	private var _fillSkin:DisplayObject;

	/**
	 * The primary fill to display.
	 *
	 * <p>Note: The size of the <code>fillSkin</code>, at the time that it
	 * is passed to the setter, will be used used as the size of the fill
	 * when the progress bar is set to the minimum value. In other words,
	 * if the fill of a horizontal progress bar with a value from 0 to 100
	 * should be virtually invisible when the value is 0, then the
	 * <code>fillSkin</code> should have a width of 0 when you pass it in.
	 * On the other hand, if you're using a <code>Scale9Image</code> as the
	 * skin, it may require a minimum width before the image parts begin to
	 * overlap. In that case, the <code>Scale9Image</code> instance passed
	 * to the <code>fillSkin</code> setter should have a <code>width</code>
	 * value that is the same as that minimum width value where the image
	 * parts do not overlap.</p>
	 *
	 * <p>In the following example, the progress bar is given a fill
	 * skin:</p>
	 *
	 * <listing version="3.0">
	 * progress.fillSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var fillSkin(get, set):DisplayObject;
	public function get_fillSkin():DisplayObject
	{
		return this._fillSkin;
	}

	/**
	 * @private
	 */
	public function set_fillSkin(value:DisplayObject):DisplayObject
	{
		if(this._fillSkin == value)
		{
			return get_fillSkin();
		}

		if(this._fillSkin != null && this._fillSkin != this._fillDisabledSkin)
		{
			this.removeChild(this._fillSkin);
		}
		this._fillSkin = value;
		if(this._fillSkin != null && this._fillSkin.parent != this)
		{
			this._fillSkin.visible = false;
			this.addChild(this._fillSkin);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_fillSkin();
	}

	/**
	 * @private
	 */
	private var _fillDisabledSkin:DisplayObject;

	/**
	 * A fill to display when the progress bar is disabled.
	 *
	 * <p>In the following example, the progress bar is given a disabled fill
	 * skin:</p>
	 *
	 * <listing version="3.0">
	 * progress.fillDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var fillDisabledSkin(get, set):DisplayObject;
	public function get_fillDisabledSkin():DisplayObject
	{
		return this._fillDisabledSkin;
	}

	/**
	 * @private
	 */
	public function set_fillDisabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._fillDisabledSkin == value)
		{
			return get_fillDisabledSkin();
		}

		if(this._fillDisabledSkin != null && this._fillDisabledSkin != this._fillSkin)
		{
			this.removeChild(this._fillDisabledSkin);
		}
		this._fillDisabledSkin = value;
		if(this._fillDisabledSkin != null && this._fillDisabledSkin.parent != this)
		{
			this._fillDisabledSkin.visible = false;
			this.addChild(this._fillDisabledSkin);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_fillDisabledSkin();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * progress.padding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #paddingTop
	 * @see #paddingRight
	 * @see #paddingBottom
	 * @see #paddingLeft
	 */
	public var padding(get, set):Float;
	public function get_padding():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_padding(value:Float):Float
	{
		this.paddingTop = value;
		this.paddingRight = value;
		this.paddingBottom = value;
		this.paddingLeft = value;
		return get_padding();
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the progress bar's top edge and
	 * the progress bar's content.
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * progress.paddingTop = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingTop(get, set):Float;
	public function get_paddingTop():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_paddingTop(value:Float):Float
	{
		if(this._paddingTop == value)
		{
			return get_paddingTop();
		}
		this._paddingTop = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the progress bar's right edge
	 * and the progress bar's content.
	 *
	 * <p>In the following example, the right padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * progress.paddingRight = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingRight(get, set):Float;
	public function get_paddingRight():Float
	{
		return this._paddingRight;
	}

	/**
	 * @private
	 */
	public function set_paddingRight(value:Float):Float
	{
		if(this._paddingRight == value)
		{
			return get_paddingRight();
		}
		this._paddingRight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the progress bar's bottom edge
	 * and the progress bar's content.
	 *
	 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * progress.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingBottom(get, set):Float;
	public function get_paddingBottom():Float
	{
		return this._paddingBottom;
	}

	/**
	 * @private
	 */
	public function set_paddingBottom(value:Float):Float
	{
		if(this._paddingBottom == value)
		{
			return get_paddingBottom();
		}
		this._paddingBottom = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the progress bar's left edge
	 * and the progress bar's content.
	 *
	 * <p>In the following example, the left padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * progress.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingLeft(get, set):Float;
	public function get_paddingLeft():Float
	{
		return this._paddingLeft;
	}

	/**
	 * @private
	 */
	public function set_paddingLeft(value:Float):Float
	{
		if(this._paddingLeft == value)
		{
			return get_paddingLeft();
		}
		this._paddingLeft = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);

		if(stylesInvalid || stateInvalid)
		{
			this.refreshBackground();
			this.refreshFill();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layoutChildren();
	}

	/**
	 * If the component's dimensions have not been set explicitly, it will
	 * measure its content and determine an ideal size for itself. If the
	 * <code>explicitWidth</code> or <code>explicitHeight</code> member
	 * variables are set, those value will be used without additional
	 * measurement. If one is set, but not the other, the dimension with the
	 * explicit value will not be measured, but the other non-explicit
	 * dimension will still need measurement.
	 *
	 * <p>Calls <code>setSizeInternal()</code> to set up the
	 * <code>actualWidth</code> and <code>actualHeight</code> member
	 * variables used for layout.</p>
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		var newWidth:Float = needsWidth ? this._originalBackgroundWidth : this.explicitWidth;
		var newHeight:Float = needsHeight ? this._originalBackgroundHeight  : this.explicitHeight;
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * @private
	 */
	private function refreshBackground():Void
	{
		this.currentBackground = this._backgroundSkin;
		if(this._backgroundDisabledSkin != null)
		{
			if(this._isEnabled)
			{
				this._backgroundDisabledSkin.visible = false;
			}
			else
			{
				this.currentBackground = this._backgroundDisabledSkin;
				if(this._backgroundSkin != null)
				{
					this._backgroundSkin.visible = false;
				}
			}
		}
		if(this.currentBackground != null)
		{
			if(this._originalBackgroundWidth != this._originalBackgroundWidth) //isNaN
			{
				this._originalBackgroundWidth = this.currentBackground.width;
			}
			if(this._originalBackgroundHeight != this._originalBackgroundHeight) //isNaN
			{
				this._originalBackgroundHeight = this.currentBackground.height;
			}
			this.currentBackground.visible = true;
		}
	}

	/**
	 * @private
	 */
	private function refreshFill():Void
	{
		this.currentFill = this._fillSkin;
		if(this._fillDisabledSkin != null)
		{
			if(this._isEnabled)
			{
				this._fillDisabledSkin.visible = false;
			}
			else
			{
				this.currentFill = this._fillDisabledSkin;
				if(this._backgroundSkin != null)
				{
					this._fillSkin.visible = false;
				}
			}
		}
		if(this.currentFill != null)
		{
			if(this._originalFillWidth != this._originalFillWidth) //isNaN
			{
				this._originalFillWidth = this.currentFill.width;
			}
			if(this._originalFillHeight != this._originalFillHeight) //isNaN
			{
				this._originalFillHeight = this.currentFill.height;
			}
			this.currentFill.visible = true;
		}
	}

	/**
	 * @private
	 */
	private function layoutChildren():Void
	{
		if(this.currentBackground != null)
		{
			this.currentBackground.width = this.actualWidth;
			this.currentBackground.height = this.actualHeight;
		}

		var percentage:Float;
		if(this._minimum == this._maximum)
		{
			percentage = 1;
		}
		else
		{
			percentage = (this._value - this._minimum) / (this._maximum - this._minimum);
			if(percentage < 0)
			{
				percentage = 0;
			}
			else if(percentage > 1)
			{
				percentage = 1;
			}
		}
		if(this._direction == DIRECTION_VERTICAL)
		{
			this.currentFill.width = this.actualWidth - this._paddingLeft - this._paddingRight;
			this.currentFill.height = Math.round(this._originalFillHeight + percentage * (this.actualHeight - this._paddingTop - this._paddingBottom - this._originalFillHeight));
			this.currentFill.x = this._paddingLeft;
			this.currentFill.y = this.actualHeight - this._paddingBottom - this.currentFill.height;
		}
		else //horizontal
		{
			this.currentFill.width = Math.round(this._originalFillWidth + percentage * (this.actualWidth - this._paddingLeft - this._paddingRight - this._originalFillWidth));
			this.currentFill.height = this.actualHeight - this._paddingTop - this._paddingBottom;
			this.currentFill.x = this._paddingLeft;
			this.currentFill.y = this._paddingTop;
		}
	}
}
