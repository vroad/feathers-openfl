/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.display;
import feathers.core.IValidating;
import feathers.core.ValidationQueue;
import feathers.textures.Scale9Textures;
import feathers.utils.display.FeathersDisplayUtil.getDisplayObjectDepthFromStage;
import starling.utils.Max;

import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.QuadBatch;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.MatrixUtil;

//[Exclude(name="numChildren",kind="property")]
//[Exclude(name="isFlattened",kind="property")]
//[Exclude(name="addChild",kind="method")]
//[Exclude(name="addChildAt",kind="method")]
//[Exclude(name="broadcastEvent",kind="method")]
//[Exclude(name="broadcastEventWith",kind="method")]
//[Exclude(name="contains",kind="method")]
//[Exclude(name="getChildAt",kind="method")]
//[Exclude(name="getChildByName",kind="method")]
//[Exclude(name="getChildIndex",kind="method")]
//[Exclude(name="removeChild",kind="method")]
//[Exclude(name="removeChildAt",kind="method")]
//[Exclude(name="removeChildren",kind="method")]
//[Exclude(name="setChildIndex",kind="method")]
//[Exclude(name="sortChildren",kind="method")]
//[Exclude(name="swapChildren",kind="method")]
//[Exclude(name="swapChildrenAt",kind="method")]
//[Exclude(name="flatten",kind="method")]
//[Exclude(name="unflatten",kind="method")]

/**
 * Scales an image with nine regions to maintain the aspect ratio of the
 * corners regions. The top and bottom regions stretch horizontally, and the
 * left and right regions scale vertically. The center region stretches in
 * both directions to fill the remaining space.
 */
class Scale9Image extends Sprite implements IValidating
{
	/**
	 * @private
	 */
	private static var HELPER_MATRIX:Matrix = new Matrix();

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	private static var helperImage:Image;

	/**
	 * Constructor.
	 */
	public function new(textures:Scale9Textures, textureScale:Float = 1)
	{
		super();
		this.textures = textures;
		this._textureScale = textureScale;
		this._hitArea = new Rectangle();
		this.readjustSize();

		this._batch = new QuadBatch();
		this._batch.touchable = false;
		this.addChild(this._batch);

		this.addEventListener(Event.FLATTEN, flattenHandler);
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	/**
	 * @private
	 */
	private var _propertiesChanged:Bool = true;

	/**
	 * @private
	 */
	private var _layoutChanged:Bool = true;

	/**
	 * @private
	 */
	private var _renderingChanged:Bool = true;

	/**
	 * @private
	 */
	private var _frame:Rectangle;

	/**
	 * @private
	 */
	private var _textures:Scale9Textures;

	/**
	 * The textures displayed by this image.
	 *
	 * <p>In the following example, the textures are changed:</p>
	 *
	 * <listing version="3.0">
	 * image.textures = new Scale9Textures( texture, scale9Grid );</listing>
	 */
	public var textures(get, set):Scale9Textures;
	public function get_textures():Scale9Textures
	{
		return this._textures;
	}

	/**
	 * @private
	 */
	public function set_textures(value:Scale9Textures):Scale9Textures
	{
		if(value == null)
		{
			throw new IllegalOperationError("Scale9Image textures cannot be null.");
		}
		if(this._textures == value)
		{
			return this._textures;
		}
		this._textures = value;
		var texture:Texture = this._textures.texture;
		this._frame = texture.frame;
		if(this._frame == null)
		{
			this._frame = new Rectangle(0, 0, texture.width, texture.height);
		}
		this._layoutChanged = true;
		this._renderingChanged = true;
		this.invalidate();
		return this._textures;
	}

	/**
	 * @private
	 */
	private var _width:Float = Math.NaN;

	/**
	 * @private
	 */
	override public function get_width():Float
	{
		return this._width;
	}

	/**
	 * @private
	 */
	override public function set_width(value:Float):Float
	{
		if(this._width == value)
		{
			return this._width;
		}
		this._width = this._hitArea.width = value;
		this._layoutChanged = true;
		this.invalidate();
		return this._width;
	}

	/**
	 * @private
	 */
	private var _height:Float = Math.NaN;

	/**
	 * @private
	 */
	override public function get_height():Float
	{
		return this._height;
	}

	/**
	 * @private
	 */
	override public function set_height(value:Float):Float
	{
		if(this._height == value)
		{
			return this._height;
		}
		this._height = this._hitArea.height = value;
		this._layoutChanged = true;
		this.invalidate();
		return this._height;
	}

	/**
	 * @private
	 */
	private var _textureScale:Float = 1;

	/**
	 * Scales the texture dimensions during measurement. Useful for UI that
	 * should scale based on screen density or resolution.
	 *
	 * <p>In the following example, the texture scale is changed:</p>
	 *
	 * <listing version="3.0">
	 * image.textureScale = 2;</listing>
	 *
	 * @default 1
	 */
	public var textureScale(get, set):Float;
	public function get_textureScale():Float
	{
		return this._textureScale;
	}

	/**
	 * @private
	 */
	public function set_textureScale(value:Float):Float
	{
		if(this._textureScale == value)
		{
			return this._textureScale;
		}
		this._textureScale = value;
		this._layoutChanged = true;
		this.invalidate();
		return this._textureScale;
	}

	/**
	 * @private
	 */
	private var _smoothing:String = TextureSmoothing.BILINEAR;

	/**
	 * The smoothing value to pass to the images.
	 *
	 * <p>In the following example, the smoothing is changed:</p>
	 *
	 * <listing version="3.0">
	 * image.smoothing = TextureSmoothing.NONE;</listing>
	 *
	 * @default starling.textures.TextureSmoothing.BILINEAR
	 *
	 * @see http://doc.starling-framework.org/core/starling/textures/TextureSmoothing.html starling.textures.TextureSmoothing
	 */
	public var smoothing(get, set):String;
	public function get_smoothing():String
	{
		return this._smoothing;
	}

	/**
	 * @private
	 */
	public function set_smoothing(value:String):String
	{
		if(this._smoothing == value)
		{
			return this._smoothing;
		}
		this._smoothing = value;
		this._propertiesChanged = true;
		this.invalidate();
		return this._smoothing;
	}

	/**
	 * @private
	 */
	private var _color:UInt = 0xffffff;

	/**
	 * The color value to pass to the images.
	 *
	 * <p>In the following example, the color is changed:</p>
	 *
	 * <listing version="3.0">
	 * image.color = 0xff00ff;</listing>
	 *
	 * @default 0xffffff
	 */
	public var color(get, set):UInt;
	public function get_color():UInt
	{
		return this._color;
	}

	/**
	 * @private
	 */
	public function set_color(value:UInt):UInt
	{
		if(this._color == value)
		{
			return this._color;
		}
		this._color = value;
		this._propertiesChanged = true;
		this.invalidate();
		return this._color;
	}

	/**
	 * @private
	 */
	private var _useSeparateBatch:Bool = true;

	/**
	 * Determines if the regions are batched normally by Starling or if
	 * they're batched separately.
	 *
	 * <p>In the following example, the separate batching is disabled:</p>
	 *
	 * <listing version="3.0">
	 * image.useSeparateBatch = false;</listing>
	 *
	 * @default true
	 */
	public var useSeparateBatch(get, set):Bool;
	public function get_useSeparateBatch():Bool
	{
		return this._useSeparateBatch;
	}

	/**
	 * @private
	 */
	public function set_useSeparateBatch(value:Bool):Bool
	{
		if(this._useSeparateBatch == value)
		{
			return this._useSeparateBatch;
		}
		this._useSeparateBatch = value;
		this._renderingChanged = true;
		this.invalidate();
		return this._useSeparateBatch;
	}

	/**
	 * @private
	 */
	private var _hitArea:Rectangle;

	/**
	 * @private
	 */
	private var _batch:QuadBatch;

	/**
	 * @private
	 */
	private var _isValidating:Bool = false;

	/**
	 * @private
	 */
	private var _isInvalid:Bool = false;

	/**
	 * @private
	 */
	private var _validationQueue:ValidationQueue;

	/**
	 * @private
	 */
	private var _depth:Int = -1;

	/**
	 * @copy feathers.core.IValidating#depth
	 */
	public var depth(get, never):Int;
	public function get_depth():Int
	{
		return this._depth;
	}

	/**
	 * @private
	 */
	public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
	{
		if(resultRect == null)
		{
			resultRect = new Rectangle();
		}

		var minX:Float = Max.MAX_VALUE, maxX:Float = -Max.MAX_VALUE;
		var minY:Float = Max.MAX_VALUE, maxY:Float = -Max.MAX_VALUE;

		if (targetSpace == this) // optimization
		{
			minX = this._hitArea.x;
			minY = this._hitArea.y;
			maxX = this._hitArea.x + this._hitArea.width;
			maxY = this._hitArea.y + this._hitArea.height;
		}
		else
		{
			this.getTransformationMatrix(targetSpace, HELPER_MATRIX);

			MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x, this._hitArea.y, HELPER_POINT);
			minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
			maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
			minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
			maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

			MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x, this._hitArea.y + this._hitArea.height, HELPER_POINT);
			minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
			maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
			minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
			maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

			MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x + this._hitArea.width, this._hitArea.y, HELPER_POINT);
			minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
			maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
			minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
			maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

			MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x + this._hitArea.width, this._hitArea.y + this._hitArea.height, HELPER_POINT);
			minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
			maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
			minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
			maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;
		}

		resultRect.x = minX;
		resultRect.y = minY;
		resultRect.width  = maxX - minX;
		resultRect.height = maxY - minY;

		return resultRect;
	}

	/**
	 * @private
	 */
	override public function hitTest(localPoint:Point, forTouch:Bool=false):DisplayObject
	{
		if(forTouch && (!this.visible || !this.touchable))
		{
			return null;
		}
		return this._hitArea.containsPoint(localPoint) ? this : null;
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		if(this._isInvalid)
		{
			this.validate();
		}
		super.render(support, parentAlpha);
	}

	/**
	 * @copy feathers.core.IValidating#validate()
	 */
	public function validate():Void
	{
		if(!this._isInvalid)
		{
			return;
		}
		if(this._isValidating)
		{
			if(this._validationQueue != null)
			{
				//we were already validating, and something else told us to
				//validate. that's bad.
				this._validationQueue.addControl(this, true);
			}
			return;
		}
		this._isValidating = true;
		if(this._propertiesChanged || this._layoutChanged || this._renderingChanged)
		{
			this._batch.batchable = !this._useSeparateBatch;
			this._batch.reset();

			if(helperImage == null)
			{
				//because Scale9Textures enforces it, we know for sure that
				//this texture will have a size greater than zero, so there
				//won't be an error from Quad.
				helperImage = new Image(this._textures.middleCenter);
			}
			helperImage.smoothing = this._smoothing;
			helperImage.color = this._color;

			var grid:Rectangle = this._textures.scale9Grid;
			var scaledLeftWidth:Float = grid.x * this._textureScale;
			var scaledRightWidth:Float = (this._frame.width - grid.x - grid.width) * this._textureScale;
			var sumLeftAndRight:Float = scaledLeftWidth + scaledRightWidth;
			var distortionScale:Float;
			if(sumLeftAndRight > this._width)
			{
				distortionScale = (this._width / sumLeftAndRight);
				scaledLeftWidth *= distortionScale;
				scaledRightWidth *= distortionScale;
				sumLeftAndRight = scaledLeftWidth + scaledRightWidth;
			}
			var scaledCenterWidth:Float = this._width - sumLeftAndRight;
			var scaledTopHeight:Float = grid.y * this._textureScale;
			var scaledBottomHeight:Float = (this._frame.height - grid.y - grid.height) * this._textureScale;
			var sumTopAndBottom:Float = scaledTopHeight + scaledBottomHeight;
			if(sumTopAndBottom > this._height)
			{
				distortionScale = (this._height / sumTopAndBottom);
				scaledTopHeight *= distortionScale;
				scaledBottomHeight *= distortionScale;
				sumTopAndBottom = scaledTopHeight + scaledBottomHeight;
			}
			var scaledMiddleHeight:Float = this._height - sumTopAndBottom;

			if(scaledTopHeight > 0)
			{
				if(scaledLeftWidth > 0)
				{
					helperImage.texture = this._textures.topLeft;
					helperImage.readjustSize();
					helperImage.width = scaledLeftWidth;
					helperImage.height = scaledTopHeight;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = scaledTopHeight - helperImage.height;
					this._batch.addImage(helperImage);
				}

				if(scaledCenterWidth > 0)
				{
					helperImage.texture = this._textures.topCenter;
					helperImage.readjustSize();
					helperImage.width = scaledCenterWidth;
					helperImage.height = scaledTopHeight;
					helperImage.x = scaledLeftWidth;
					helperImage.y = scaledTopHeight - helperImage.height;
					this._batch.addImage(helperImage);
				}

				if(scaledRightWidth > 0)
				{
					helperImage.texture = this._textures.topRight;
					helperImage.readjustSize();
					helperImage.width = scaledRightWidth;
					helperImage.height = scaledTopHeight;
					helperImage.x = this._width - scaledRightWidth;
					helperImage.y = scaledTopHeight - helperImage.height;
					this._batch.addImage(helperImage);
				}
			}

			if(scaledMiddleHeight > 0)
			{
				if(scaledLeftWidth > 0)
				{
					helperImage.texture = this._textures.middleLeft;
					helperImage.readjustSize();
					helperImage.width = scaledLeftWidth;
					helperImage.height = scaledMiddleHeight;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = scaledTopHeight;
					this._batch.addImage(helperImage);
				}

				if(scaledCenterWidth > 0)
				{
					helperImage.texture = this._textures.middleCenter;
					helperImage.readjustSize();
					helperImage.width = scaledCenterWidth;
					helperImage.height = scaledMiddleHeight;
					helperImage.x = scaledLeftWidth;
					helperImage.y = scaledTopHeight;
					this._batch.addImage(helperImage);
				}

				if(scaledRightWidth > 0)
				{
					helperImage.texture = this._textures.middleRight;
					helperImage.readjustSize();
					helperImage.width = scaledRightWidth;
					helperImage.height = scaledMiddleHeight;
					helperImage.x = this._width - scaledRightWidth;
					helperImage.y = scaledTopHeight;
					this._batch.addImage(helperImage);
				}
			}

			if(scaledBottomHeight > 0)
			{
				if(scaledLeftWidth > 0)
				{
					helperImage.texture = this._textures.bottomLeft;
					helperImage.readjustSize();
					helperImage.width = scaledLeftWidth;
					helperImage.height = scaledBottomHeight;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = this._height - scaledBottomHeight;
					this._batch.addImage(helperImage);
				}

				if(scaledCenterWidth > 0)
				{
					helperImage.texture = this._textures.bottomCenter;
					helperImage.readjustSize();
					helperImage.width = scaledCenterWidth;
					helperImage.height = scaledBottomHeight;
					helperImage.x = scaledLeftWidth;
					helperImage.y = this._height - scaledBottomHeight;
					this._batch.addImage(helperImage);
				}

				if(scaledRightWidth > 0)
				{
					helperImage.texture = this._textures.bottomRight;
					helperImage.readjustSize();
					helperImage.width = scaledRightWidth;
					helperImage.height = scaledBottomHeight;
					helperImage.x = this._width - scaledRightWidth;
					helperImage.y = this._height - scaledBottomHeight;
					this._batch.addImage(helperImage);
				}
			}
		}

		this._propertiesChanged = false;
		this._layoutChanged = false;
		this._renderingChanged = false;
		this._isInvalid = false;
		this._isValidating = false;
	}

	/**
	 * Readjusts the dimensions of the image according to its current
	 * textures. Call this method to synchronize image and texture size
	 * after assigning textures with a different size.
	 */
	public function readjustSize():Void
	{
		this.width = this._frame.width * this._textureScale;
		this.height = this._frame.height * this._textureScale;
	}

	/**
	 * @private
	 */
	private function invalidate():Void
	{
		if(this._isInvalid)
		{
			return;
		}
		this._isInvalid = true;
		if(this._validationQueue == null)
		{
			return;
		}
		this._validationQueue.addControl(this, false);
	}

	/**
	 * @private
	 */
	private function flattenHandler(event:Event):Void
	{
		this.validate();
	}

	/**
	 * @private
	 */
	private function addedToStageHandler(event:Event):Void
	{
		this._depth = getDisplayObjectDepthFromStage(this);
		this._validationQueue = ValidationQueue.forStarling(Starling.current);
		if(this._isInvalid)
		{
			this._validationQueue.addControl(this, false);
		}
	}
}