/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.core.FeathersControl;
import feathers.utils.geom.FeathersMatrixUtil.matrixToRotation;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleX;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleY;
import openfl.errors.ArgumentError;

import openfl.display.Sprite;
import openfl.events.TextEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
#if flash
import flash.text.StyleSheet;
#end
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.utils.MatrixUtil;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SCROLL;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STATE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;

/**
 * @private
 */
class TextFieldViewPort extends FeathersControl implements IViewPort
{
	private static var HELPER_MATRIX:Matrix = new Matrix();
	private static var HELPER_POINT:Point = new Point();

	public function new()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	private var _textFieldContainer:Sprite;
	private var _textField:TextField;

	/**
	 * @private
	 */
	private var _text:String = "";

	/**
	 * @see feathers.controls.ScrollText#text
	 */
	public var text(get, set):String;
	public function get_text():String
	{
		return this._text;
	}

	/**
	 * @private
	 */
	public function set_text(value:String):String
	{
		if(value == null)
		{
			value = "";
		}
		if(this._text == value)
		{
			return get_text();
		}
		this._text = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_text();
	}

	/**
	 * @private
	 */
	private var _isHTML:Bool = false;

	/**
	 * @see feathers.controls.ScrollText#isHTML
	 */
	public var isHTML(get, set):Bool;
	public function get_isHTML():Bool
	{
		return this._isHTML;
	}

	/**
	 * @private
	 */
	public function set_isHTML(value:Bool):Bool
	{
		if(this._isHTML == value)
		{
			return get_isHTML();
		}
		this._isHTML = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_isHTML();
	}

	/**
	 * @private
	 */
	private var _textFormat:TextFormat;

	/**
	 * @see feathers.controls.ScrollText#textFormat
	 */
	public var textFormat(get, set):TextFormat;
	public function get_textFormat():TextFormat
	{
		return this._textFormat;
	}

	/**
	 * @private
	 */
	public function set_textFormat(value:TextFormat):TextFormat
	{
		if(this._textFormat == value)
		{
			return get_textFormat();
		}
		this._textFormat = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_textFormat();
	}

	/**
	 * @private
	 */
	private var _disabledTextFormat:TextFormat;

	/**
	 * @see feathers.controls.ScrollText#disabledTextFormat
	 */
	public var disabledTextFormat(get, set):TextFormat;
	public function get_disabledTextFormat():TextFormat
	{
		return this._disabledTextFormat;
	}

	/**
	 * @private
	 */
	public function set_disabledTextFormat(value:TextFormat):TextFormat
	{
		if(this._disabledTextFormat == value)
		{
			return get_disabledTextFormat();
		}
		this._disabledTextFormat = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_disabledTextFormat();
	}

	/**
	 * @private
	 */
	#if flash
	private var _styleSheet:StyleSheet;
	#end

	/**
	 * @see feathers.controls.ScrollText#styleSheet
	 */
	#if flash
	public var styleSheet(get, set):StyleSheet;
	public function get_styleSheet():StyleSheet
	{
		return this._styleSheet;
	}
	#end

	/**
	 * @private
	 */
	#if flash
	public function set_styleSheet(value:StyleSheet):StyleSheet
	{
		if(this._styleSheet == value)
		{
			return get_styleSheet();
		}
		this._styleSheet = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_styleSheet();
	}
	#end

	/**
	 * @private
	 */
	private var _embedFonts:Bool = false;

	/**
	 * @see feathers.controls.ScrollText#embedFonts
	 */
	public var embedFonts(get, set):Bool;
	public function get_embedFonts():Bool
	{
		return this._embedFonts;
	}

	/**
	 * @private
	 */
	public function set_embedFonts(value:Bool):Bool
	{
		if(this._embedFonts == value)
		{
			return get_embedFonts();
		}
		this._embedFonts = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_embedFonts();
	}

	/**
	 * @private
	 */
	private var _antiAliasType:AntiAliasType = AntiAliasType.ADVANCED;

	/**
	 * @see feathers.controls.ScrollText#antiAliasType
	 */
	public var antiAliasType(get, set):AntiAliasType;
	public function get_antiAliasType():AntiAliasType
	{
		return this._antiAliasType;
	}

	/**
	 * @private
	 */
	public function set_antiAliasType(value:AntiAliasType):AntiAliasType
	{
		if(this._antiAliasType == value)
		{
			return get_antiAliasType();
		}
		this._antiAliasType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_antiAliasType();
	}

	/**
	 * @private
	 */
	private var _background:Bool = false;

	/**
	 * @see feathers.controls.ScrollText#background
	 */
	public var background(get, set):Bool;
	public function get_background():Bool
	{
		return this._background;
	}

	/**
	 * @private
	 */
	public function set_background(value:Bool):Bool
	{
		if(this._background == value)
		{
			return get_background();
		}
		this._background = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_background();
	}

	/**
	 * @private
	 */
	private var _backgroundColor:UInt = 0xffffff;

	/**
	 * @see feathers.controls.ScrollText#backgroundColor
	 */
	public var backgroundColor(get, set):UInt;
	public function get_backgroundColor():UInt
	{
		return this._backgroundColor;
	}

	/**
	 * @private
	 */
	public function set_backgroundColor(value:UInt):UInt
	{
		if(this._backgroundColor == value)
		{
			return get_backgroundColor();
		}
		this._backgroundColor = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_backgroundColor();
	}

	/**
	 * @private
	 */
	private var _border:Bool = false;

	/**
	 * @see feathers.controls.ScrollText#border
	 */
	public var border(get, set):Bool;
	public function get_border():Bool
	{
		return this._border;
	}

	/**
	 * @private
	 */
	public function set_border(value:Bool):Bool
	{
		if(this._border == value)
		{
			return get_border();
		}
		this._border = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_border();
	}

	/**
	 * @private
	 */
	private var _borderColor:UInt = 0x000000;

	/**
	 * @see feathers.controls.ScrollText#borderColor
	 */
	public var borderColor(get, set):UInt;
	public function get_borderColor():UInt
	{
		return this._borderColor;
	}

	/**
	 * @private
	 */
	public function set_borderColor(value:UInt):UInt
	{
		if(this._borderColor == value)
		{
			return get_borderColor();
		}
		this._borderColor = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_borderColor();
	}

	/**
	 * @private
	 */
	private var _cacheAsBitmap:Bool = true;

	/**
	 * @see feathers.controls.ScrollText#cacheAsBitmap
	 */
	public var cacheAsBitmap(get, set):Bool;
	public function get_cacheAsBitmap():Bool
	{
		return this._cacheAsBitmap;
	}

	/**
	 * @private
	 */
	public function set_cacheAsBitmap(value:Bool):Bool
	{
		if(this._cacheAsBitmap == value)
		{
			return get_cacheAsBitmap();
		}
		this._cacheAsBitmap = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_cacheAsBitmap();
	}

	/**
	 * @private
	 */
	private var _condenseWhite:Bool = false;

	/**
	 * @see feathers.controls.ScrollText#condenseWhite
	 */
	public var condenseWhite(get, set):Bool;
	public function get_condenseWhite():Bool
	{
		return this._condenseWhite;
	}

	/**
	 * @private
	 */
	public function set_condenseWhite(value:Bool):Bool
	{
		if(this._condenseWhite == value)
		{
			return get_condenseWhite();
		}
		this._condenseWhite = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_condenseWhite();
	}

	/**
	 * @private
	 */
	private var _displayAsPassword:Bool = false;

	/**
	 * @see feathers.controls.ScrollText#displayAsPassword
	 */
	public var displayAsPassword(get, set):Bool;
	public function get_displayAsPassword():Bool
	{
		return this._displayAsPassword;
	}

	/**
	 * @private
	 */
	public function set_displayAsPassword(value:Bool):Bool
	{
		if(this._displayAsPassword == value)
		{
			return get_displayAsPassword();
		}
		this._displayAsPassword = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_displayAsPassword();
	}

	/**
	 * @private
	 */
	private var _gridFitType:GridFitType = GridFitType.PIXEL;

	/**
	 * @see feathers.controls.ScrollText#gridFitType
	 */
	public var gridFitType(get, set):GridFitType;
	public function get_gridFitType():GridFitType
	{
		return this._gridFitType;
	}

	/**
	 * @private
	 */
	public function set_gridFitType(value:GridFitType):GridFitType
	{
		if(this._gridFitType == value)
		{
			return get_gridFitType();
		}
		this._gridFitType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_gridFitType();
	}

	/**
	 * @private
	 */
	private var _sharpness:Float = 0;

	/**
	 * @see feathers.controls.ScrollText#sharpness
	 */
	public var sharpness(get, set):Float;
	public function get_sharpness():Float
	{
		return this._sharpness;
	}

	/**
	 * @private
	 */
	public function set_sharpness(value:Float):Float
	{
		if(this._sharpness == value)
		{
			return get_sharpness();
		}
		this._sharpness = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_sharpness();
	}

	/**
	 * @private
	 */
	private var _thickness:Float = 0;

	/**
	 * @see feathers.controls.ScrollText#thickness
	 */
	public var thickness(get, set):Float;
	public function get_thickness():Float
	{
		return this._thickness;
	}

	/**
	 * @private
	 */
	public function set_thickness(value:Float):Float
	{
		if(this._thickness == value)
		{
			return get_thickness();
		}
		this._thickness = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_thickness();
	}

	private var _minVisibleWidth:Float = 0;

	public var minVisibleWidth(get, set):Float;
	public function get_minVisibleWidth():Float
	{
		return this._minVisibleWidth;
	}

	public function set_minVisibleWidth(value:Float):Float
	{
		if(this._minVisibleWidth == value)
		{
			return get_minVisibleWidth();
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleWidth cannot be NaN");
		}
		this._minVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return get_minVisibleWidth();
	}

	private var _maxVisibleWidth:Float = Math.POSITIVE_INFINITY;

	public var maxVisibleWidth(get, set):Float;
	public function get_maxVisibleWidth():Float
	{
		return this._maxVisibleWidth;
	}

	public function set_maxVisibleWidth(value:Float):Float
	{
		if(this._maxVisibleWidth == value)
		{
			return get_maxVisibleWidth();
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleWidth cannot be NaN");
		}
		this._maxVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return get_maxVisibleWidth();
	}

	private var _actualVisibleWidth:Float = 0;

	private var _explicitVisibleWidth:Float = Math.NaN;

	public var visibleWidth(get, set):Float;
	public function get_visibleWidth():Float
	{
		if(this._explicitVisibleWidth != this._explicitVisibleWidth) //isNaN
		{
			return this._actualVisibleWidth;
		}
		return this._explicitVisibleWidth;
	}

	public function set_visibleWidth(value:Float):Float
	{
		if(this._explicitVisibleWidth == value ||
			(value != value && this._explicitVisibleWidth != this._explicitVisibleWidth)) //isNaN
		{
			return get_visibleWidth();
		}
		this._explicitVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return get_visibleWidth();
	}

	private var _minVisibleHeight:Float = 0;

	public var minVisibleHeight(get, set):Float;
	public function get_minVisibleHeight():Float
	{
		return this._minVisibleHeight;
	}

	public function set_minVisibleHeight(value:Float):Float
	{
		if(this._minVisibleHeight == value)
		{
			return get_minVisibleHeight();
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleHeight cannot be NaN");
		}
		this._minVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return get_minVisibleHeight();
	}

	private var _maxVisibleHeight:Float = Math.POSITIVE_INFINITY;

	public var maxVisibleHeight(get, set):Float;
	public function get_maxVisibleHeight():Float
	{
		return this._maxVisibleHeight;
	}

	public function set_maxVisibleHeight(value:Float):Float
	{
		if(this._maxVisibleHeight == value)
		{
			return get_maxVisibleHeight();
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleHeight cannot be NaN");
		}
		this._maxVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return get_maxVisibleHeight();
	}

	private var _actualVisibleHeight:Float = 0;

	private var _explicitVisibleHeight:Float = Math.NaN;

	public var visibleHeight(get, set):Float;
	public function get_visibleHeight():Float
	{
		if(this._explicitVisibleHeight != this._explicitVisibleHeight) //isNaN
		{
			return this._actualVisibleHeight;
		}
		return this._explicitVisibleHeight;
	}

	public function set_visibleHeight(value:Float):Float
	{
		if(this._explicitVisibleHeight == value ||
			(value != value && this._explicitVisibleHeight != this._explicitVisibleHeight)) //isNaN
		{
			return get_visibleHeight();
		}
		this._explicitVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
		return get_visibleHeight();
	}

	public var contentX(get, never):Float;
	public function get_contentX():Float
	{
		return 0;
	}

	public var contentY(get, never):Float;
	public function get_contentY():Float
	{
		return 0;
	}

	private var _scrollStep:Float;

	public var horizontalScrollStep(get, never):Float;
	public function get_horizontalScrollStep():Float
	{
		return this._scrollStep;
	}

	public var verticalScrollStep(get, never):Float;
	public function get_verticalScrollStep():Float
	{
		return this._scrollStep;
	}

	private var _horizontalScrollPosition:Float = 0;

	public var horizontalScrollPosition(get, set):Float;
	public function get_horizontalScrollPosition():Float
	{
		return this._horizontalScrollPosition;
	}

	public function set_horizontalScrollPosition(value:Float):Float
	{
		if(this._horizontalScrollPosition == value)
		{
			return get_horizontalScrollPosition();
		}
		this._horizontalScrollPosition = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL);
		return get_horizontalScrollPosition();
	}

	private var _verticalScrollPosition:Float = 0;

	public var verticalScrollPosition(get, set):Float;
	public function get_verticalScrollPosition():Float
	{
		return this._verticalScrollPosition;
	}

	public function set_verticalScrollPosition(value:Float):Float
	{
		if(this._verticalScrollPosition == value)
		{
			return get_verticalScrollPosition();
		}
		this._verticalScrollPosition = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL);
		return get_verticalScrollPosition();
	}

	private var _paddingTop:Float = 0;

	public var paddingTop(get, set):Float;
	public function get_paddingTop():Float
	{
		return this._paddingTop;
	}

	public function set_paddingTop(value:Float):Float
	{
		if(this._paddingTop == value)
		{
			return get_paddingTop();
		}
		this._paddingTop = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	private var _paddingRight:Float = 0;

	public var paddingRight(get, set):Float;
	public function get_paddingRight():Float
	{
		return this._paddingRight;
	}

	public function set_paddingRight(value:Float):Float
	{
		if(this._paddingRight == value)
		{
			return get_paddingRight();
		}
		this._paddingRight = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	private var _paddingBottom:Float = 0;

	public var paddingBottom(get, set):Float;
	public function get_paddingBottom():Float
	{
		return this._paddingBottom;
	}

	public function set_paddingBottom(value:Float):Float
	{
		if(this._paddingBottom == value)
		{
			return get_paddingBottom();
		}
		this._paddingBottom = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	private var _paddingLeft:Float = 0;

	public var paddingLeft(get, set):Float;
	public function get_paddingLeft():Float
	{
		return this._paddingLeft;
	}

	public function set_paddingLeft(value:Float):Float
	{
		if(this._paddingLeft == value)
		{
			return get_paddingLeft();
		}
		this._paddingLeft = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
	}

	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		var starlingViewPort:Rectangle = Starling.current.viewPort;
		HELPER_POINT.x = HELPER_POINT.y = 0;
		this.parent.getTransformationMatrix(this.stage, HELPER_MATRIX);
		MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
		var nativeScaleFactor:Float = 1;
		#if flash
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
		#end
		var scaleFactor:Float = Starling.current.contentScaleFactor / nativeScaleFactor;
		this._textFieldContainer.x = starlingViewPort.x + HELPER_POINT.x * scaleFactor;
		this._textFieldContainer.y = starlingViewPort.y + HELPER_POINT.y * scaleFactor;
		this._textFieldContainer.scaleX = matrixToScaleX(HELPER_MATRIX) * scaleFactor;
		this._textFieldContainer.scaleY = matrixToScaleY(HELPER_MATRIX) * scaleFactor;
		this._textFieldContainer.rotation = matrixToRotation(HELPER_MATRIX) * 180 / Math.PI;
		this._textFieldContainer.alpha = parentAlpha * this.alpha;
		super.render(support, parentAlpha);
	}

	override private function initialize():Void
	{
		this._textFieldContainer = new Sprite();
		this._textFieldContainer.visible = false;
		this._textField = new TextField();
		this._textField.autoSize = TextFieldAutoSize.LEFT;
		this._textField.selectable = false;
		#if flash
		this._textField.mouseWheelEnabled = false;
		#end
		this._textField.wordWrap = true;
		this._textField.multiline = true;
		this._textField.addEventListener(TextEvent.LINK, textField_linkHandler);
		this._textFieldContainer.addChild(this._textField);
	}

	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);
		var scrollInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SCROLL);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);

		if(stylesInvalid)
		{
			this._textField.antiAliasType = this._antiAliasType;
			this._textField.background = this._background;
			this._textField.backgroundColor = this._backgroundColor;
			this._textField.border = this._border;
			this._textField.borderColor = this._borderColor;
			#if flash
			this._textField.condenseWhite = this._condenseWhite;
			#end
			this._textField.displayAsPassword = this._displayAsPassword;
			this._textField.embedFonts = this._embedFonts;
			this._textField.gridFitType = this._gridFitType;
			this._textField.sharpness = this._sharpness;
			#if flash
			this._textField.thickness = this._thickness;
			#end
			this._textField.cacheAsBitmap = this._cacheAsBitmap;
			this._textField.x = this._paddingLeft;
			this._textField.y = this._paddingTop;
		}

		if(dataInvalid || stylesInvalid || stateInvalid)
		{
			#if flash
			if(this._styleSheet != null)
			{
				this._textField.styleSheet = this._styleSheet;
			}
			else
			#end
			{
				#if flash
				this._textField.styleSheet = null;
				#end
				if(!this._isEnabled && this._disabledTextFormat != null)
				{
					this._textField.defaultTextFormat = this._disabledTextFormat;
				}
				else if(this._textFormat != null)
				{
					this._textField.defaultTextFormat = this._textFormat;
				}
			}
			if(this._isHTML)
			{
				this._textField.htmlText = this._text;
			}
			else
			{
				this._textField.text = this._text;
			}
			this._scrollStep = this._textField.getLineMetrics(0).height * Starling.current.contentScaleFactor;
		}

		var calculatedVisibleWidth:Float = this._explicitVisibleWidth;
		if(calculatedVisibleWidth != calculatedVisibleWidth)
		{
			if(this.stage != null)
			{
				calculatedVisibleWidth = this.stage.stageWidth;
			}
			else
			{
				calculatedVisibleWidth = Starling.current.stage.stageWidth;
			}
			if(calculatedVisibleWidth < this._minVisibleWidth)
			{
				calculatedVisibleWidth = this._minVisibleWidth;
			}
			else if(calculatedVisibleWidth > this._maxVisibleWidth)
			{
				calculatedVisibleWidth = this._maxVisibleWidth;
			}
		}
		this._textField.width = calculatedVisibleWidth - this._paddingLeft - this._paddingRight;
		var totalContentHeight:Float = this._textField.height + this._paddingTop + this._paddingBottom;
		var calculatedVisibleHeight:Float = this._explicitVisibleHeight;
		if(calculatedVisibleHeight != calculatedVisibleHeight)
		{
			calculatedVisibleHeight = totalContentHeight;
			if(calculatedVisibleHeight < this._minVisibleHeight)
			{
				calculatedVisibleHeight = this._minVisibleHeight;
			}
			else if(calculatedVisibleHeight > this._maxVisibleHeight)
			{
				calculatedVisibleHeight = this._maxVisibleHeight;
			}
		}
		sizeInvalid = this.setSizeInternal(calculatedVisibleWidth, totalContentHeight, false) || sizeInvalid;
		this._actualVisibleWidth = calculatedVisibleWidth;
		this._actualVisibleHeight = calculatedVisibleHeight;

		if(sizeInvalid || scrollInvalid)
		{
			var scrollRect:Rectangle = this._textFieldContainer.scrollRect;
			if(scrollRect == null)
			{
				scrollRect = new Rectangle();
			}
			scrollRect.width = calculatedVisibleWidth;
			scrollRect.height = calculatedVisibleHeight;
			scrollRect.x = this._horizontalScrollPosition;
			scrollRect.y = this._verticalScrollPosition;
			this._textFieldContainer.scrollRect = scrollRect;
		}
	}

	private function addedToStageHandler(event:Event):Void
	{
		Starling.current.nativeStage.addChild(this._textFieldContainer);
		this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	private function removedFromStageHandler(event:Event):Void
	{
		Starling.current.nativeStage.removeChild(this._textFieldContainer);
		this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	private function enterFrameHandler(event:Event):Void
	{
		var target:DisplayObject = this;
		do
		{
			if(!target.hasVisibleArea)
			{
				this._textFieldContainer.visible = false;
				return;
			}
			target = target.parent;
		}
		while(target != null);
		this._textFieldContainer.visible = true;
	}

	private function textField_linkHandler(event:TextEvent):Void
	{
		this.dispatchEventWith(Event.TRIGGERED, false, event.text);
	}
}
