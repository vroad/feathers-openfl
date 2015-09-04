/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.display;
import feathers.core.IValidating;
import feathers.core.ValidationQueue;
import feathers.utils.display.FeathersDisplayUtil.getDisplayObjectDepthFromStage;
import openfl.errors.ArgumentError;
import starling.utils.Max;

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
 * Tiles a texture to fill the specified bounds.
 */
class TiledImage extends Sprite implements IValidating
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	private static var HELPER_MATRIX:Matrix = new Matrix();

	/**
	 * Constructor.
	 */
	public function new(texture:Texture, textureScale:Float = 1)
	{
		super();
		this._hitArea = new Rectangle();
		this._textureScale = textureScale;
		this.texture = texture;
		this.initializeWidthAndHeight();

		this._batch = new QuadBatch();
		this._batch.touchable = false;
		this.addChild(this._batch);

		this.addEventListener(Event.FLATTEN, flattenHandler);
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private var _propertiesChanged:Bool = true;
	private var _layoutChanged:Bool = true;

	private var _hitArea:Rectangle;

	private var _batch:QuadBatch;
	private var _image:Image;

	private var _originalImageWidth:Float;
	private var _originalImageHeight:Float;

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
	private var _texture:Texture;

	/**
	 * The texture to tile.
	 *
	 * <p>In the following example, the texture is changed:</p>
	 *
	 * <listing version="3.0">
	 * image.texture = Texture.fromBitmapData( bitmapData );</listing>
	 */
	public var texture(get, set):Texture;
	public function get_texture():Texture
	{
		return this._texture;
	}

	/**
	 * @private
	 */
	public function set_texture(value:Texture):Texture
	{
		if(value == null)
		{
			throw new ArgumentError("Texture cannot be null");
		}
		if(this._texture == value)
		{
			return this._texture;
		}
		this._texture = value;
		if(this._image == null)
		{
			this._image = new Image(value);
			this._image.touchable = false;
		}
		else
		{
			this._image.texture = value;
			this._image.readjustSize();
		}
		var frame:Rectangle = value.frame;
		if(frame == null)
		{
			this._originalImageWidth = value.width;
			this._originalImageHeight = value.height;
		}
		else
		{
			this._originalImageWidth = frame.width;
			this._originalImageHeight = frame.height;
		}
		this._layoutChanged = true;
		this.invalidate();
		return this._texture;
	}

	/**
	 * @private
	 */
	private var _smoothing:String = TextureSmoothing.BILINEAR;

	/**
	 * The smoothing value to pass to the tiled images.
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
		if(TextureSmoothing.isValid(value))
		{
			this._smoothing = value;
		}
		else
		{
			throw new ArgumentError("Invalid smoothing mode: " + value);
		}
		this._propertiesChanged = true;
		this.invalidate();
		return this._smoothing;
	}

	/**
	 * @private
	 */
	private var _color:UInt = 0xffffff;

	/**
	 * The color value to pass to the tiled images.
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
	 * Determines if the tiled images are batched normally by Starling or if
	 * they're batched separately.
	 *
	 * <p>In the following example, separate batching is disabled:</p>
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
		this._propertiesChanged = true;
		this.invalidate();
		return this._useSeparateBatch;
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
	 * Set both the width and height in one call.
	 */
	public function setSize(width:Float, height:Float):Void
	{
		this.width = width;
		this.height = height;
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
		if(this._propertiesChanged)
		{
			this._image.smoothing = this._smoothing;
			this._image.color = this._color;
		}
		if(this._propertiesChanged || this._layoutChanged)
		{
			this._batch.batchable = !this._useSeparateBatch;
			this._batch.reset();
			this._image.scaleX = this._image.scaleY = this._textureScale;
			var scaledTextureWidth:Float = this._originalImageWidth * this._textureScale;
			var scaledTextureHeight:Float = this._originalImageHeight * this._textureScale;
			var xImageCount:Int = Math.ceil(this._width / scaledTextureWidth);
			var yImageCount:Int = Math.ceil(this._height / scaledTextureHeight);
			var imageCount:Int = xImageCount * yImageCount;
			var xPosition:Float = 0;
			var yPosition:Float = 0;
			var nextXPosition:Float = xPosition + scaledTextureWidth;
			var nextYPosition:Float = yPosition + scaledTextureHeight;
			for(i in 0 ... imageCount)
			{
				this._image.x = xPosition;
				this._image.y = yPosition;

				var imageWidth:Float = (nextXPosition >= this._width) ? (this._width - xPosition) : scaledTextureWidth;
				var imageHeight:Float = (nextYPosition >= this._height) ? (this._height - yPosition) : scaledTextureHeight;
				this._image.width = imageWidth;
				this._image.height = imageHeight;

				var xCoord:Float = imageWidth / scaledTextureWidth;
				var yCoord:Float = imageHeight / scaledTextureHeight;
				HELPER_POINT.x = xCoord;
				HELPER_POINT.y = 0;
				this._image.setTexCoords(1, HELPER_POINT);

				HELPER_POINT.y = yCoord;
				this._image.setTexCoords(3, HELPER_POINT);

				HELPER_POINT.x = 0;
				this._image.setTexCoords(2, HELPER_POINT);

				this._batch.addImage(this._image);

				if(nextXPosition >= this._width)
				{
					xPosition = 0;
					nextXPosition = scaledTextureWidth;
					yPosition = nextYPosition;
					nextYPosition += scaledTextureHeight;
				}
				else
				{
					xPosition = nextXPosition;
					nextXPosition += scaledTextureWidth;
				}
			}
		}
		this._layoutChanged = false;
		this._propertiesChanged = false;
		this._isInvalid = false;
		this._isValidating = false;
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
	private function initializeWidthAndHeight():Void
	{
		this.width = this._originalImageWidth * this._textureScale;
		this.height = this._originalImageHeight * this._textureScale;
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