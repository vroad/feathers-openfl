/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
import feathers.controls.Scroller;
import feathers.utils.geom.matrixToRotation;
import feathers.utils.geom.matrixToScaleX;
import feathers.utils.geom.matrixToScaleY;
import feathers.utils.math.roundToNearest;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;

import starling.core.Starling;
import starling.utils.MatrixUtil;

/**
 * A text editor view port for the <code>TextArea</code> component that uses
 * <code>flash.text.TextField</code>.
 *
 * @see feathers.controls.TextArea
 */
class TextFieldTextEditorViewPort extends TextFieldTextEditor implements ITextEditorViewPort
{
	/**
	 * @private
	 */
	inline private static var HELPER_MATRIX:Matrix = new Matrix();

	/**
	 * @private
	 */
	inline private static var HELPER_POINT:Point = new Point();

	/**
	 * Constructor.
	 */
	public function TextFieldTextEditorViewPort()
	{
		super();
		this.multiline = true;
		this.wordWrap = true;
		this.resetScrollOnFocusOut = false;
	}

	/**
	 * @private
	 */
	private var _ignoreScrolling:Bool = false;

	/**
	 * @private
	 */
	private var _minVisibleWidth:Float = 0;

	/**
	 * @inheritDoc
	 */
	public function get_minVisibleWidth():Float
	{
		return this._minVisibleWidth;
	}

	/**
	 * @private
	 */
	public function set_minVisibleWidth(value:Float):Float
	{
		if(this._minVisibleWidth == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleWidth cannot be NaN");
		}
		this._minVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _maxVisibleWidth:Float = Float.POSITIVE_INFINITY;

	/**
	 * @inheritDoc
	 */
	public function get_maxVisibleWidth():Float
	{
		return this._maxVisibleWidth;
	}

	/**
	 * @private
	 */
	public function set_maxVisibleWidth(value:Float):Float
	{
		if(this._maxVisibleWidth == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleWidth cannot be NaN");
		}
		this._maxVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _visibleWidth:Float = NaN;

	/**
	 * @inheritDoc
	 */
	public function get_visibleWidth():Float
	{
		return this._visibleWidth;
	}

	/**
	 * @private
	 */
	public function set_visibleWidth(value:Float):Float
	{
		if(this._visibleWidth == value ||
			(value != value && this._visibleWidth != this._visibleWidth)) //isNaN
		{
			return;
		}
		this._visibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _minVisibleHeight:Float = 0;

	/**
	 * @inheritDoc
	 */
	public function get_minVisibleHeight():Float
	{
		return this._minVisibleHeight;
	}

	/**
	 * @private
	 */
	public function set_minVisibleHeight(value:Float):Float
	{
		if(this._minVisibleHeight == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleHeight cannot be NaN");
		}
		this._minVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _maxVisibleHeight:Float = Float.POSITIVE_INFINITY;

	/**
	 * @inheritDoc
	 */
	public function get_maxVisibleHeight():Float
	{
		return this._maxVisibleHeight;
	}

	/**
	 * @private
	 */
	public function set_maxVisibleHeight(value:Float):Float
	{
		if(this._maxVisibleHeight == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleHeight cannot be NaN");
		}
		this._maxVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _visibleHeight:Float = NaN;

	/**
	 * @inheritDoc
	 */
	public function get_visibleHeight():Float
	{
		return this._visibleHeight;
	}

	/**
	 * @private
	 */
	public function set_visibleHeight(value:Float):Float
	{
		if(this._visibleHeight == value ||
			(value != value && this._visibleHeight != this._visibleHeight)) //isNaN
		{
			return;
		}
		this._visibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	public function get_contentX():Float
	{
		return 0;
	}

	public function get_contentY():Float
	{
		return 0;
	}

	/**
	 * @private
	 */
	private var _scrollStep:Int = 0;

	/**
	 * @inheritDoc
	 */
	public function get_horizontalScrollStep():Float
	{
		return this._scrollStep;
	}

	/**
	 * @inheritDoc
	 */
	public function get_verticalScrollStep():Float
	{
		return this._scrollStep;
	}

	/**
	 * @private
	 */
	private var _horizontalScrollPosition:Float = 0;

	/**
	 * @inheritDoc
	 */
	public function get_horizontalScrollPosition():Float
	{
		return this._horizontalScrollPosition;
	}

	/**
	 * @private
	 */
	public function set_horizontalScrollPosition(value:Float):Float
	{
		//this value is basically ignored because the text does not scroll
		//horizontally. instead, it wraps.
		this._horizontalScrollPosition = value;
	}

	/**
	 * @private
	 */
	private var _verticalScrollPosition:Float = 0;

	/**
	 * @inheritDoc
	 */
	public function get_verticalScrollPosition():Float
	{
		return this._verticalScrollPosition;
	}

	/**
	 * @private
	 */
	public function set_verticalScrollPosition(value:Float):Float
	{
		if(this._verticalScrollPosition == value)
		{
			return;
		}
		this._verticalScrollPosition = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL);
		//hack because the superclass doesn't know about the scroll flag
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	override public function get_baseline():Float
	{
		return super.baseline + this._paddingTop + this._verticalScrollPosition;
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * @default 0
	 *
	 * @see #paddingTop
	 * @see #paddingRight
	 * @see #paddingBottom
	 * @see #paddingLeft
	 */
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
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the view port's top edge and
	 * the view port's content.
	 *
	 * @default 0
	 */
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
			return;
		}
		this._paddingTop = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the view port's right edge and
	 * the view port's content.
	 *
	 * @default 0
	 */
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
			return;
		}
		this._paddingRight = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the view port's bottom edge and
	 * the view port's content.
	 *
	 * @default 0
	 */
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
			return;
		}
		this._paddingBottom = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the view port's left edge and
	 * the view port's content.
	 *
	 * @default 0
	 */
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
			return;
		}
		this._paddingLeft = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	override private function measure(result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}

		var needsWidth:Bool = this._visibleWidth != this._visibleWidth; //isNaN

		this.commitStylesAndData(this.measureTextField);

		var gutterDimensionsOffset:Float = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}

		var newWidth:Float = this._visibleWidth;
		this.measureTextField.width = newWidth - this._paddingLeft - this._paddingRight + gutterDimensionsOffset;
		if(needsWidth)
		{
			newWidth = this.measureTextField.width + this._paddingLeft + this._paddingRight - gutterDimensionsOffset;
			if(newWidth < this._minVisibleWidth)
			{
				newWidth = this._minVisibleWidth;
			}
			else if(newWidth > this._maxVisibleWidth)
			{
				newWidth = this._maxVisibleWidth;
			}
		}
		var newHeight:Float = this.measureTextField.height + this._paddingTop + this._paddingBottom - gutterDimensionsOffset;
		if(this._useGutter)
		{
			newHeight += 4;
		}
		if(this._visibleHeight == this._visibleHeight) //!isNaN
		{
			if(newHeight < this._visibleHeight)
			{
				newHeight = this._visibleHeight;
			}
		}
		else if(newHeight < this._minVisibleHeight)
		{
			newHeight = this._minVisibleHeight;
		}

		result.x = newWidth;
		result.y = newHeight;

		return result;
	}

	/**
	 * @private
	 */
	override private function getSelectionIndexAtPoint(pointX:Float, pointY:Float):Int
	{
		pointY += this._verticalScrollPosition;
		return this.textField.getCharIndexAtPoint(pointX, pointY);
	}

	/**
	 * @private
	 */
	override private function refreshSnapshotParameters():Void
	{
		var textFieldWidth:Float = this._visibleWidth - this._paddingLeft - this._paddingRight;
		if(textFieldWidth != textFieldWidth) //isNaN
		{
			if(this._maxVisibleWidth < Float.POSITIVE_INFINITY)
			{
				textFieldWidth = this._maxVisibleWidth - this._paddingLeft - this._paddingRight;
			}
			else
			{
				textFieldWidth = this._minVisibleWidth - this._paddingLeft - this._paddingRight;
			}
		}
		var textFieldHeight:Float = this._visibleHeight - this._paddingTop - this._paddingBottom;
		if(textFieldHeight != textFieldHeight) //isNaN
		{
			if(this._maxVisibleHeight < Float.POSITIVE_INFINITY)
			{
				textFieldHeight = this._maxVisibleHeight - this._paddingTop - this._paddingBottom;
			}
			else
			{
				textFieldHeight = this._minVisibleHeight - this._paddingTop - this._paddingBottom;
			}
		}

		this._textFieldOffsetX = 0;
		this._textFieldOffsetY = 0;
		this._textFieldSnapshotClipRect.x = 0;
		this._textFieldSnapshotClipRect.y = 0;

		var scaleFactor:Float = Starling.contentScaleFactor;
		var clipWidth:Float = textFieldWidth * scaleFactor;
		if(this._updateSnapshotOnScaleChange)
		{
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			clipWidth *= matrixToScaleX(HELPER_MATRIX);
		}
		if(clipWidth < 0)
		{
			clipWidth = 0;
		}
		var clipHeight:Float = textFieldHeight * scaleFactor;
		if(this._updateSnapshotOnScaleChange)
		{
			clipHeight *= matrixToScaleY(HELPER_MATRIX);
		}
		if(clipHeight < 0)
		{
			clipHeight = 0;
		}
		this._textFieldSnapshotClipRect.width = clipWidth;
		this._textFieldSnapshotClipRect.height = clipHeight;
	}

	/**
	 * @private
	 */
	override private function refreshTextFieldSize():Void
	{
		var oldIgnoreScrolling:Bool = this._ignoreScrolling;
		var gutterDimensionsOffset:Float = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}
		this._ignoreScrolling = true;
		this.textField.width = this._visibleWidth - this._paddingLeft - this._paddingRight + gutterDimensionsOffset;
		var textFieldHeight:Float = this._visibleHeight - this._paddingTop - this._paddingBottom + gutterDimensionsOffset;
		if(this.textField.height != textFieldHeight)
		{
			this.textField.height = textFieldHeight;
		}
		var scroller:Scroller = Scroller(this.parent);
		this.textField.scrollV = Math.round(1 + ((this.textField.maxScrollV - 1) * (this._verticalScrollPosition / scroller.maxVerticalScrollPosition)));
		this._ignoreScrolling = oldIgnoreScrolling;
	}

	/**
	 * @private
	 */
	override private function commitStylesAndData(textField:TextField):Void
	{
		super.commitStylesAndData(textField);
		if(textField == this.textField)
		{
			this._scrollStep = textField.getLineMetrics(0).height;
		}
	}

	/**
	 * @private
	 */
	override private function transformTextField():Void
	{
		if(!this.textField.visible)
		{
			return;
		}
		var nativeScaleFactor:Float = 1;
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
		var scaleFactor:Float = Starling.contentScaleFactor / nativeScaleFactor;
		HELPER_POINT.x = HELPER_POINT.y = 0;
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
		var scaleX:Float = matrixToScaleX(HELPER_MATRIX) * scaleFactor;
		var scaleY:Float = matrixToScaleY(HELPER_MATRIX) * scaleFactor;
		var offsetX:Float = Math.round(this._paddingLeft * scaleX);
		var offsetY:Float = Math.round((this._paddingTop + this._verticalScrollPosition) * scaleY);
		var starlingViewPort:Rectangle = Starling.current.viewPort;
		var gutterPositionOffset:Float = 2;
		if(this._useGutter)
		{
			gutterPositionOffset = 0;
		}
		this.textField.x = offsetX + Math.round(starlingViewPort.x + (HELPER_POINT.x * scaleFactor) - gutterPositionOffset * scaleX);
		this.textField.y = offsetY + Math.round(starlingViewPort.y + (HELPER_POINT.y * scaleFactor) - gutterPositionOffset * scaleY);
		this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / Math.PI;
		this.textField.scaleX = scaleX;
		this.textField.scaleY = scaleY;
	}

	/**
	 * @private
	 */
	override private function positionSnapshot():Void
	{
		if(!this.textSnapshot)
		{
			return;
		}
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		this.textSnapshot.x = this._paddingLeft + Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
		this.textSnapshot.y = this._paddingTop + this._verticalScrollPosition + Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
	}

	/**
	 * @private
	 */
	override private function checkIfNewSnapshotIsNeeded():Void
	{
		super.checkIfNewSnapshotIsNeeded();
		this._needsNewTexture ||= this.isInvalid(INVALIDATION_FLAG_SCROLL);
	}

	/**
	 * @private
	 */
	override private function textField_focusInHandler(event:FocusEvent):Void
	{
		this.textField.addEventListener(Event.SCROLL, textField_scrollHandler);
		super.textField_focusInHandler(event);
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	override private function textField_focusOutHandler(event:FocusEvent):Void
	{
		this.textField.removeEventListener(Event.SCROLL, textField_scrollHandler);
		super.textField_focusOutHandler(event);
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function textField_scrollHandler(event:Event):Void
	{
		//for some reason, the text field's scroll positions don't work
		//properly unless we access the values here. weird.
		var scrollH:Float = this.textField.scrollH;
		var scrollV:Float = this.textField.scrollV;
		if(this._ignoreScrolling)
		{
			return;
		}
		var scroller:Scroller = Scroller(this.parent);
		if(scroller.maxVerticalScrollPosition > 0 && this.textField.maxScrollV > 1)
		{
			var calculatedVerticalScrollPosition:Float = scroller.maxVerticalScrollPosition * (scrollV - 1) / (this.textField.maxScrollV - 1);
			scroller.verticalScrollPosition = roundToNearest(calculatedVerticalScrollPosition, this._scrollStep);
		}
	}

}
}
