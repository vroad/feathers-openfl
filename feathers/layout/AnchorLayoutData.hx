/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * @inheritDoc
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Extra, optional data used by an <code>AnchorLayout</code> instance to
 * position and size a display object.
 *
 * @see AnchorLayout
 * @see ILayoutDisplayObject
 */
class AnchorLayoutData extends EventDispatcher implements ILayoutData
{
	/**
	 * Constructor.
	 */
	public function new(top:Null<Float> = null, right:Null<Float> = null,
		bottom:Null<Float> = null, left:Null<Float> = null, horizontalCenter:Null<Float> = null,
		verticalCenter:Null<Float> = null)
	{
		super();
		if (top == null) top = Math.NaN;
		if (right == null) right = Math.NaN;
		if (bottom == null) bottom = Math.NaN;
		if (left == null) left = Math.NaN;
		if (horizontalCenter == null) horizontalCenter = Math.NaN;
		if (verticalCenter == null) verticalCenter = Math.NaN;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
		this.left = left;
		this.horizontalCenter = horizontalCenter;
		this.verticalCenter = verticalCenter;
	}

	/**
	 * @private
	 */
	private var _percentWidth:Float = Math.NaN;

	/**
	 * The width of the layout object, as a percentage of the container's
	 * width.
	 *
	 * <p>If the value is <code>NaN</code>, this property is ignored.</p>
	 *
	 * @default NaN
	 */
	public var percentWidth(get, set):Float;
	public function get_percentWidth():Float
	{
		return this._percentWidth;
	}

	/**
	 * @private
	 */
	public function set_percentWidth(value:Float):Float
	{
		if(this._percentWidth == value)
		{
			return this._percentWidth;
		}
		this._percentWidth = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._percentWidth;
	}

	/**
	 * @private
	 */
	private var _percentHeight:Float = Math.NaN;

	/**
	 * The height of the layout object, as a percentage of the container's
	 * height.
	 *
	 * <p>If the value is <code>NaN</code>, this property is ignored.</p>
	 *
	 * @default NaN
	 */
	public var percentHeight(get, set):Float;
	public function get_percentHeight():Float
	{
		return this._percentHeight;
	}

	/**
	 * @private
	 */
	public function set_percentHeight(value:Float):Float
	{
		if(this._percentHeight == value)
		{
			return this._percentHeight;
		}
		this._percentHeight = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._percentHeight;
	}

	/**
	 * @private
	 */
	private var _topAnchorDisplayObject:DisplayObject;

	/**
	 * The top edge of the layout object will be relative to this anchor.
	 * If there is no anchor, the top edge of the parent container will be
	 * the anchor.
	 *
	 * @default null
	 *
	 * @see #top
	 */
	public var topAnchorDisplayObject(get, set):DisplayObject;
	public function get_topAnchorDisplayObject():DisplayObject
	{
		return this._topAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	public function set_topAnchorDisplayObject(value:DisplayObject):DisplayObject
	{
		if(this._topAnchorDisplayObject == value)
		{
			return this._topAnchorDisplayObject;
		}
		this._topAnchorDisplayObject = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._topAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	private var _top:Float = Math.NaN;

	/**
	 * The position, in pixels, of the top edge relative to the top
	 * anchor, or, if there is no top anchor, then the position is relative
	 * to the top edge of the parent container. If this value is
	 * <code>NaN</code>, the object's top edge will not be anchored.
	 *
	 * @default NaN
	 *
	 * @see #topAnchorDisplayObject
	 */
	public var top(get, set):Float;
	public function get_top():Float
	{
		return this._top;
	}

	/**
	 * @private
	 */
	public function set_top(value:Float):Float
	{
		if(this._top == value)
		{
			return this._top;
		}
		this._top = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._top;
	}

	/**
	 * @private
	 */
	private var _rightAnchorDisplayObject:DisplayObject;

	/**
	 * The right edge of the layout object will be relative to this anchor.
	 * If there is no anchor, the right edge of the parent container will be
	 * the anchor.
	 *
	 * @default null
	 *
	 * @see #right
	 */
	public var rightAnchorDisplayObject(get, set):DisplayObject;
	public function get_rightAnchorDisplayObject():DisplayObject
	{
		return this._rightAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	public function set_rightAnchorDisplayObject(value:DisplayObject):DisplayObject
	{
		if(this._rightAnchorDisplayObject == value)
		{
			return this._rightAnchorDisplayObject;
		}
		this._rightAnchorDisplayObject = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._rightAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	private var _right:Float = Math.NaN;

	/**
	 * The position, in pixels, of the right edge relative to the right
	 * anchor, or, if there is no right anchor, then the position is relative
	 * to the right edge of the parent container. If this value is
	 * <code>NaN</code>, the object's right edge will not be anchored.
	 *
	 * @default NaN
	 *
	 * @see #rightAnchorDisplayObject
	 */
	public var right(get, set):Float;
	public function get_right():Float
	{
		return this._right;
	}

	/**
	 * @private
	 */
	public function set_right(value:Float):Float
	{
		if(this._right == value)
		{
			return this._right;
		}
		this._right = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._right;
	}

	/**
	 * @private
	 */
	private var _bottomAnchorDisplayObject:DisplayObject;

	/**
	 * The bottom edge of the layout object will be relative to this anchor.
	 * If there is no anchor, the bottom edge of the parent container will be
	 * the anchor.
	 *
	 * @default null
	 *
	 * @see #bottom
	 */
	public var bottomAnchorDisplayObject(get, set):DisplayObject;
	public function get_bottomAnchorDisplayObject():DisplayObject
	{
		return this._bottomAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	public function set_bottomAnchorDisplayObject(value:DisplayObject):DisplayObject
	{
		if(this._bottomAnchorDisplayObject == value)
		{
			return this._bottomAnchorDisplayObject;
		}
		this._bottomAnchorDisplayObject = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._bottomAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	private var _bottom:Float = Math.NaN;

	/**
	 * The position, in pixels, of the bottom edge relative to the bottom
	 * anchor, or, if there is no bottom anchor, then the position is relative
	 * to the bottom edge of the parent container. If this value is
	 * <code>NaN</code>, the object's bottom edge will not be anchored.
	 *
	 * @default NaN
	 *
	 * @see #bottomAnchorDisplayObject
	 */
	public var bottom(get, set):Float;
	public function get_bottom():Float
	{
		return this._bottom;
	}

	/**
	 * @private
	 */
	public function set_bottom(value:Float):Float
	{
		if(this._bottom == value)
		{
			return this._bottom;
		}
		this._bottom = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._bottom;
	}

	/**
	 * @private
	 */
	private var _leftAnchorDisplayObject:DisplayObject;

	/**
	 * The left edge of the layout object will be relative to this anchor.
	 * If there is no anchor, the left edge of the parent container will be
	 * the anchor.
	 *
	 * @default null
	 *
	 * @see #left
	 */
	public var leftAnchorDisplayObject(get, set):DisplayObject;
	public function get_leftAnchorDisplayObject():DisplayObject
	{
		return this._leftAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	public function set_leftAnchorDisplayObject(value:DisplayObject):DisplayObject
	{
		if(this._leftAnchorDisplayObject == value)
		{
			return this._leftAnchorDisplayObject;
		}
		this._leftAnchorDisplayObject = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._leftAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	private var _left:Float = Math.NaN;

	/**
	 * The position, in pixels, of the left edge relative to the left
	 * anchor, or, if there is no left anchor, then the position is relative
	 * to the left edge of the parent container. If this value is
	 * <code>NaN</code>, the object's left edge will not be anchored.
	 *
	 * @default NaN
	 *
	 * @see #leftAnchorDisplayObject
	 */
	public var left(get, set):Float;
	public function get_left():Float
	{
		return this._left;
	}

	/**
	 * @private
	 */
	public function set_left(value:Float):Float
	{
		if(this._left == value)
		{
			return this._left;
		}
		this._left = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._left;
	}

	/**
	 * @private
	 */
	private var _horizontalCenterAnchorDisplayObject:DisplayObject;

	/**
	 * The horizontal center of the layout object will be relative to this
	 * anchor. If there is no anchor, the horizontal center of the parent
	 * container will be the anchor.
	 *
	 * @default null
	 *
	 * @see #horizontalCenter
	 */
	public var horizontalCenterAnchorDisplayObject(get, set):DisplayObject;
	public function get_horizontalCenterAnchorDisplayObject():DisplayObject
	{
		return this._horizontalCenterAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	public function set_horizontalCenterAnchorDisplayObject(value:DisplayObject):DisplayObject
	{
		if(this._horizontalCenterAnchorDisplayObject == value)
		{
			return this._horizontalCenterAnchorDisplayObject;
		}
		this._horizontalCenterAnchorDisplayObject = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._horizontalCenterAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	private var _horizontalCenter:Float = Math.NaN;

	/**
	 * The position, in pixels, of the horizontal center relative to the
	 * horizontal center anchor, or, if there is no horizontal center
	 * anchor, then the position is relative to the horizontal center of the
	 * parent container. If this value is <code>NaN</code>, the object's
	 * horizontal center will not be anchored.
	 *
	 * @default NaN
	 *
	 * @see #horizontalCenterAnchorDisplayObject
	 */
	public var horizontalCenter(get, set):Float;
	public function get_horizontalCenter():Float
	{
		return this._horizontalCenter;
	}

	/**
	 * @private
	 */
	public function set_horizontalCenter(value:Float):Float
	{
		if(this._horizontalCenter == value)
		{
			return this._horizontalCenter;
		}
		this._horizontalCenter = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._horizontalCenter;
	}

	/**
	 * @private
	 */
	private var _verticalCenterAnchorDisplayObject:DisplayObject;

	/**
	 * The vertical center of the layout object will be relative to this
	 * anchor. If there is no anchor, the vertical center of the parent
	 * container will be the anchor.
	 *
	 * @default null
	 *
	 * @see #verticalCenter
	 */
	public var verticalCenterAnchorDisplayObject(get, set):DisplayObject;
	public function get_verticalCenterAnchorDisplayObject():DisplayObject
	{
		return this._verticalCenterAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	public function set_verticalCenterAnchorDisplayObject(value:DisplayObject):DisplayObject
	{
		if(this._verticalCenterAnchorDisplayObject == value)
		{
			return this._verticalCenterAnchorDisplayObject;
		}
		this._verticalCenterAnchorDisplayObject = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._verticalCenterAnchorDisplayObject;
	}

	/**
	 * @private
	 */
	private var _verticalCenter:Float = Math.NaN;

	/**
	 * The position, in pixels, of the vertical center relative to the
	 * vertical center anchor, or, if there is no vertical center anchor,
	 * then the position is relative to the vertical center of the parent
	 * container. If this value is <code>NaN</code>, the object's vertical
	 * center will not be anchored.
	 *
	 * @default NaN
	 *
	 * @see #verticalCenterAnchorDisplayObject
	 */
	public var verticalCenter(get, set):Float;
	public function get_verticalCenter():Float
	{
		return this._verticalCenter;
	}

	/**
	 * @private
	 */
	public function set_verticalCenter(value:Float):Float
	{
		if(this._verticalCenter == value)
		{
			return this._verticalCenter;
		}
		this._verticalCenter = value;
		this.dispatchEventWith(Event.CHANGE);
		return this._verticalCenter;
	}
}
