/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text;
import feathers.core.FeathersControl;
import feathers.core.ITextRenderer;
import feathers.skins.IStyleProvider;
import feathers.text.BitmapFontTextFormat;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormatAlign;

import starling.core.RenderSupport;
import starling.display.Image;
import starling.display.QuadBatch;
import starling.text.BitmapChar;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

import starling.text.BitmapChar;

/**
 * Renders text using <code>starling.text.BitmapFont</code>.
 *
 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
 * @see http://doc.starling-framework.org/core/starling/text/BitmapFont.html starling.text.BitmapFont
 */
class BitmapFontTextRenderer extends FeathersControl implements ITextRenderer
{
	/**
	 * @private
	 */
	private static var HELPER_IMAGE:Image;

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
	inline private static var CHARACTER_ID_SPACE:Int = 32;

	/**
	 * @private
	 */
	inline private static var CHARACTER_ID_TAB:Int = 9;

	/**
	 * @private
	 */
	inline private static var CHARACTER_ID_LINE_FEED:Int = 10;

	/**
	 * @private
	 */
	inline private static var CHARACTER_ID_CARRIAGE_RETURN:Int = 13;

	/**
	 * @private
	 */
	private static var CHARACTER_BUFFER:Array<CharLocation>;

	/**
	 * @private
	 */
	private static var CHAR_LOCATION_POOL:Array<CharLocation>;

	/**
	 * @private
	 */
	inline private static var FUZZY_MAX_WIDTH_PADDING:Float = 0.000001;

	/**
	 * The default <code>IStyleProvider</code> for all <code>BitmapFontTextRenderer</code>
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
		if(CHAR_LOCATION_POOL == null)
		{
			//compiler doesn't like referencing CharLocation class in a
			//static constant
			CHAR_LOCATION_POOL = new Array();
		}
		if(CHARACTER_BUFFER == null)
		{
			CHARACTER_BUFFER = new Array();
		}
		this.isQuickHitAreaEnabled = true;
	}

	/**
	 * @private
	 */
	private var _characterBatch:QuadBatch;

	/**
	 * @private
	 */
	private var _batchX:Float = 0;

	/**
	 * @private
	 */
	private var currentTextFormat:BitmapFontTextFormat;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return BitmapFontTextRenderer.globalStyleProvider;
	}
	
	/**
	 * @private
	 */
	private var _textFormat:BitmapFontTextFormat;
	
	/**
	 * The font and styles used to draw the text.
	 *
	 * <p>In the following example, the text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 */
	public var textFormat(get, set):BitmapFontTextFormat;
	@:keep public function get_textFormat():BitmapFontTextFormat
	{
		return this._textFormat;
	}
	
	/**
	 * @private
	 */
	@:keep public function set_textFormat(value:BitmapFontTextFormat):BitmapFontTextFormat
	{
		if(this._textFormat == value)
		{
			return this._textFormat;
		}
		this._textFormat = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._textFormat;
	}

	/**
	 * @private
	 */
	private var _disabledTextFormat:BitmapFontTextFormat;

	/**
	 * The font and styles used to draw the text when the label is disabled.
	 *
	 * <p>In the following example, the disabled text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.disabledTextFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 */
	@:keep public var disabledTextFormat(get, set):BitmapFontTextFormat;
	public function get_disabledTextFormat():BitmapFontTextFormat
	{
		return this._disabledTextFormat;
	}

	/**
	 * @private
	 */
	@:keep public function set_disabledTextFormat(value:BitmapFontTextFormat):BitmapFontTextFormat
	{
		if(this._disabledTextFormat == value)
		{
			return this._disabledTextFormat;
		}
		this._disabledTextFormat = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._disabledTextFormat;
	}
	
	/**
	 * @private
	 */
	private var _text:String = null;
	
	/**
	 * @inheritDoc
	 *
	 * <p>In the following example, the text is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.text = "Lorem ipsum";</listing>
	 *
	 * @default null
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
		if(this._text == value)
		{
			return this._text;
		}
		this._text = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._text;
	}
	
	/**
	 * @private
	 */
	private var _smoothing:String = TextureSmoothing.BILINEAR;

	//[Inspectable(type="String",enumeration="bilinear,trilinear,none")]
	/**
	 * A smoothing value passed to each character image.
	 *
	 * <p>In the following example, the texture smoothing is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.smoothing = TextureSmoothing.NONE;</listing>
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._smoothing;
	}

	/**
	 * @private
	 */
	private var _wordWrap:Bool = false;

	/**
	 * @inheritDoc
	 *
	 * <p>In the following example, word wrap is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.wordWrap = true;</listing>
	 *
	 * @default false
	 */
	public var wordWrap(get, set):Bool;
	public function get_wordWrap():Bool
	{
		return _wordWrap;
	}

	/**
	 * @private
	 */
	public function set_wordWrap(value:Bool):Bool
	{
		if(this._wordWrap == value)
		{
			return _wordWrap;
		}
		this._wordWrap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return _wordWrap;
	}

	/**
	 * @private
	 */
	private var _snapToPixels:Bool = true;

	/**
	 * Determines if the position of the text should be snapped to the
	 * nearest whole pixel when rendered. When snapped to a whole pixel, the
	 * text is often more readable. When not snapped, the text may become
	 * blurry due to texture smoothing.
	 *
	 * <p>In the following example, the text is not snapped to pixels:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.snapToPixels = false;</listing>
	 *
	 * @default true
	 */
	public var snapToPixels(get, set):Bool;
	public function get_snapToPixels():Bool
	{
		return _snapToPixels;
	}

	/**
	 * @private
	 */
	public function set_snapToPixels(value:Bool):Bool
	{
		if(this._snapToPixels == value)
		{
			return this._snapToPixels;
		}
		this._snapToPixels = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._snapToPixels;
	}

	/**
	 * @private
	 */
	private var _truncateToFit:Bool = true;

	/**
	 * If word wrap is disabled, and the text is longer than the width of
	 * the label, the text may be truncated using <code>truncationText</code>.
	 *
	 * <p>This feature may be disabled to improve performance.</p>
	 *
	 * <p>This feature does not currently support the truncation of text
	 * displayed on multiple lines.</p>
	 *
	 * <p>In the following example, truncation is disabled:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.truncateToFit = false;</listing>
	 *
	 * @default true
	 *
	 * @see #truncationText
	 */
	public var truncateToFit(get, set):Bool;
	public function get_truncateToFit():Bool
	{
		return _truncateToFit;
	}

	/**
	 * @private
	 */
	public function set_truncateToFit(value:Bool):Bool
	{
		if(this._truncateToFit == value)
		{
			return this._truncateToFit;
		}
		this._truncateToFit = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._truncateToFit;
	}

	/**
	 * @private
	 */
	private var _truncationText:String = "...";

	/**
	 * The text to display at the end of the label if it is truncated.
	 *
	 * <p>In the following example, the truncation text is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.truncationText = " [more]";</listing>
	 *
	 * @default "..."
	 */
	public var truncationText(get, set):String;
	public function get_truncationText():String
	{
		return _truncationText;
	}

	/**
	 * @private
	 */
	public function set_truncationText(value:String):String
	{
		if(this._truncationText == value)
		{
			return this._truncationText;
		}
		this._truncationText = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return _truncationText;
	}

	/**
	 * @private
	 */
	private var _useSeparateBatch:Bool = true;

	/**
	 * Determines if the characters are batched normally by Starling or if
	 * they're batched separately. Batching separately may improve
	 * performance for text that changes often, while batching normally
	 * may be better when a lot of text is displayed on screen at once.
	 *
	 * <p>In the following example, separate batching is disabled:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.useSeparateBatch = false;</listing>
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._useSeparateBatch;
	}

	/**
	 * @inheritDoc
	 */
	public var baseline(get, never):Float;
	public function get_baseline():Float
	{
		if(this._textFormat == null)
		{
			return 0;
		}
		var font:BitmapFont = this._textFormat.font;
		var formatSize:Float = this._textFormat.size;
		var fontSizeScale:Float = formatSize / font.size;
		if(fontSizeScale != fontSizeScale) //isNaN
		{
			fontSizeScale = 1;
		}
		var baseline:Float = font.baseline;
		//for some reason, if we don't call a function right here,
		//compiling with the flex 4.6 SDK will throw a VerifyError
		//for a stack overflow.
		//we could change the !== check back to isNaN() instead, but
		//isNaN() can allocate an object, so we should call a different
		//function without allocation.
		this.doNothing();
		if(baseline != baseline) //isNaN
		{
			return font.lineHeight * fontSizeScale;
		}
		return baseline * fontSizeScale;
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		var offsetX:Float = 0;
		var offsetY:Float = 0;
		if(this._snapToPixels)
		{
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			offsetX = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
			offsetY = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
		}
		this._characterBatch.x = this._batchX + offsetX;
		this._characterBatch.y = offsetY;
		super.render(support, parentAlpha);
	}
	
	/**
	 * @inheritDoc
	 */
	public function measureText(result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}

		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			result.x = this.explicitWidth;
			result.y = this.explicitHeight;
			return result;
		}

		if(this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES) || this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE))
		{
			this.refreshTextFormat();
		}

		if(this.currentTextFormat == null || this._text == null)
		{
			result.setTo(0, 0);
			return result;
		}

		var font:BitmapFont = this.currentTextFormat.font;
		var customSize:Float = this.currentTextFormat.size;
		var customLetterSpacing:Float = this.currentTextFormat.letterSpacing;
		var isKerningEnabled:Bool = this.currentTextFormat.isKerningEnabled;
		var scale:Float = customSize / font.size;
		if(scale != scale) //isNaN
		{
			scale = 1;
		}
		var lineHeight:Float = font.lineHeight * scale;
		var maxLineWidth:Float = this.explicitWidth;
		if(maxLineWidth != maxLineWidth) //isNaN
		{
			maxLineWidth = this._maxWidth;
		}

		var maxX:Float = 0;
		var currentX:Float = 0;
		var currentY:Float = 0;
		var previousCharID:Float = Math.NaN;
		var charCount:Int = this._text.length;
		var startXOfPreviousWord:Float = 0;
		var widthOfWhitespaceAfterWord:Float = 0;
		var wordCountForLine:Int = 0;
		var line:String = "";
		var word:String = "";
		//for(var i:Int = 0; i < charCount; i++)
		for(i in 0 ... charCount)
		{
			var charID:Int = this._text.charCodeAt(i);
			if(charID == CHARACTER_ID_LINE_FEED || charID == CHARACTER_ID_CARRIAGE_RETURN) //new line \n or \r
			{
				currentX = currentX - customLetterSpacing;
				if(currentX < 0)
				{
					currentX = 0;
				}
				if(maxX < currentX)
				{
					maxX = currentX;
				}
				previousCharID = Math.NaN;
				currentX = 0;
				currentY += lineHeight;
				startXOfPreviousWord = 0;
				wordCountForLine = 0;
				widthOfWhitespaceAfterWord = 0;
				continue;
			}

			var charData:BitmapChar = font.getChar(charID);
			if(charData == null)
			{
				trace("Missing character " + String.fromCharCode(charID) + " in font " + font.name + ".");
				continue;
			}

			if(isKerningEnabled &&
				previousCharID == previousCharID) //!isNaN
			{
				currentX += charData.getKerning(Std.int(previousCharID)) * scale;
			}

			var offsetX:Float = charData.xAdvance * scale;
			if(this._wordWrap)
			{
				var currentCharIsWhitespace:Bool = charID == CHARACTER_ID_SPACE || charID == CHARACTER_ID_TAB;
				var previousCharIsWhitespace:Bool = previousCharID == CHARACTER_ID_SPACE || previousCharID == CHARACTER_ID_TAB;
				if(currentCharIsWhitespace)
				{
					if(!previousCharIsWhitespace)
					{
						widthOfWhitespaceAfterWord = 0;
					}
					widthOfWhitespaceAfterWord += offsetX;
				}
				else if(previousCharIsWhitespace)
				{
					startXOfPreviousWord = currentX;
					wordCountForLine++;
					line += word;
					word = "";
				}

				if(!currentCharIsWhitespace && wordCountForLine > 0 && (currentX + offsetX) > maxLineWidth)
				{
					//we're just reusing this variable to avoid creating a
					//new one. it'll be reset to 0 in a moment.
					widthOfWhitespaceAfterWord = startXOfPreviousWord - widthOfWhitespaceAfterWord;
					if(maxX < widthOfWhitespaceAfterWord)
					{
						maxX = widthOfWhitespaceAfterWord;
					}
					previousCharID = Math.NaN;
					currentX -= startXOfPreviousWord;
					currentY += lineHeight;
					startXOfPreviousWord = 0;
					widthOfWhitespaceAfterWord = 0;
					wordCountForLine = 0;
					line = "";
				}
			}
			currentX += offsetX + customLetterSpacing;
			previousCharID = charID;
			word += String.fromCharCode(charID);
		}
		currentX = currentX - customLetterSpacing;
		if(currentX < 0)
		{
			currentX = 0;
		}
		//if the text ends in extra whitespace, the currentX value will be
		//larger than the max line width. we'll remove that and add extra
		//lines.
		if(this._wordWrap)
		{
			while(currentX > maxLineWidth)
			{
				currentX -= maxLineWidth;
				currentY += lineHeight;
			}
		}
		if(maxX < currentX)
		{
			maxX = currentX;
		}

		result.x = maxX;
		result.y = currentY + lineHeight;
		return result;
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(this._characterBatch == null)
		{
			this._characterBatch = new QuadBatch();
			this._characterBatch.touchable = false;
			this.addChild(this._characterBatch);
		}
	}
	
	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);

		if(stylesInvalid || stateInvalid)
		{
			this.refreshTextFormat();
		}

		if(dataInvalid || stylesInvalid || sizeInvalid || stateInvalid)
		{
			this._characterBatch.batchable = !this._useSeparateBatch;
			this._characterBatch.reset();
			if(this.currentTextFormat == null || this._text == null)
			{
				this.setSizeInternal(0, 0, false);
				return;
			}
			this.layoutCharacters(HELPER_POINT);
			this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
		}
	}

	/**
	 * @private
	 */
	private function layoutCharacters(result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}

		var font:BitmapFont = this.currentTextFormat.font;
		var customSize:Float = this.currentTextFormat.size;
		var customLetterSpacing:Float = this.currentTextFormat.letterSpacing;
		var isKerningEnabled:Bool = this.currentTextFormat.isKerningEnabled;
		var scale:Float = customSize / font.size;
		if(scale != scale) //isNaN
		{
			scale = 1;
		}
		var lineHeight:Float = font.lineHeight * scale;

		var hasExplicitWidth:Bool = this.explicitWidth == this.explicitWidth; //!isNaN
		var isAligned:Bool = this.currentTextFormat.align != TextFormatAlign.LEFT;
		var maxLineWidth:Float = hasExplicitWidth ? this.explicitWidth : this._maxWidth;
		if(isAligned && maxLineWidth == Math.POSITIVE_INFINITY)
		{
			//we need to measure the text to get the maximum line width
			//so that we can align the text
			this.measureText(HELPER_POINT);
			maxLineWidth = HELPER_POINT.x;
		}
		var textToDraw:String = this._text;
		if(this._truncateToFit)
		{
			textToDraw = this.getTruncatedText(maxLineWidth);
		}
		CHARACTER_BUFFER = [];

		var maxX:Float = 0;
		var currentX:Float = 0;
		var currentY:Float = 0;
		var previousCharID:Float = Math.NaN;
		var isWordComplete:Bool = false;
		var startXOfPreviousWord:Float = 0;
		var widthOfWhitespaceAfterWord:Float = 0;
		var wordLength:Int = 0;
		var wordCountForLine:Int = 0;
		var charCount:Int = textToDraw != null ? textToDraw.length : 0;
		//for(var i:Int = 0; i < charCount; i++)
		for(i in 0 ... charCount)
		{
			isWordComplete = false;
			var charID:Int = textToDraw.charCodeAt(i);
			if(charID == CHARACTER_ID_LINE_FEED || charID == CHARACTER_ID_CARRIAGE_RETURN) //new line \n or \r
			{
				currentX = currentX - customLetterSpacing;
				if(currentX < 0)
				{
					currentX = 0;
				}
				if(this._wordWrap || isAligned)
				{
					this.alignBuffer(maxLineWidth, currentX, 0);
					this.addBufferToBatch(0);
				}
				if(maxX < currentX)
				{
					maxX = currentX;
				}
				previousCharID = Math.NaN;
				currentX = 0;
				currentY += lineHeight;
				startXOfPreviousWord = 0;
				widthOfWhitespaceAfterWord = 0;
				wordLength = 0;
				wordCountForLine = 0;
				continue;
			}

			var charData:BitmapChar = font.getChar(charID);
			if(charData == null)
			{
				trace("Missing character " + String.fromCharCode(charID) + " in font " + font.name + ".");
				continue;
			}

			if(isKerningEnabled &&
				previousCharID == previousCharID) //!isNaN
			{
				currentX += charData.getKerning(Std.int(previousCharID)) * scale;
			}

			var offsetX:Float = charData.xAdvance * scale;
			if(this._wordWrap)
			{
				var currentCharIsWhitespace:Bool = charID == CHARACTER_ID_SPACE || charID == CHARACTER_ID_TAB;
				var previousCharIsWhitespace:Bool = previousCharID == CHARACTER_ID_SPACE || previousCharID == CHARACTER_ID_TAB;
				if(currentCharIsWhitespace)
				{
					if(!previousCharIsWhitespace)
					{
						widthOfWhitespaceAfterWord = 0;
					}
					widthOfWhitespaceAfterWord += offsetX;
				}
				else if(previousCharIsWhitespace)
				{
					startXOfPreviousWord = currentX;
					wordLength = 0;
					wordCountForLine++;
					isWordComplete = true;
				}

				//we may need to move to a new line at the same time
				//that our previous word in the buffer can be batched
				//so we need to add the buffer here rather than after
				//the next section
				if(isWordComplete && !isAligned)
				{
					this.addBufferToBatch(0);
				}

				if(!currentCharIsWhitespace && wordCountForLine > 0 && (currentX + offsetX) > maxLineWidth)
				{
					if(isAligned)
					{
						this.trimBuffer(wordLength);
						this.alignBuffer(maxLineWidth, startXOfPreviousWord - widthOfWhitespaceAfterWord, wordLength);
						this.addBufferToBatch(wordLength);
					}
					this.moveBufferedCharacters(-startXOfPreviousWord, lineHeight, 0);
					//we're just reusing this variable to avoid creating a
					//new one. it'll be reset to 0 in a moment.
					widthOfWhitespaceAfterWord = startXOfPreviousWord - widthOfWhitespaceAfterWord;
					if(maxX < widthOfWhitespaceAfterWord)
					{
						maxX = widthOfWhitespaceAfterWord;
					}
					previousCharID = Math.NaN;
					currentX -= startXOfPreviousWord;
					currentY += lineHeight;
					startXOfPreviousWord = 0;
					widthOfWhitespaceAfterWord = 0;
					wordLength = 0;
					isWordComplete = false;
					wordCountForLine = 0;
				}
			}
			if(this._wordWrap || isAligned)
			{
				var charLocation:CharLocation = CHAR_LOCATION_POOL.length > 0 ? CHAR_LOCATION_POOL.shift() : new CharLocation();
				charLocation.char = charData;
				charLocation.x = currentX + charData.xOffset * scale;
				charLocation.y = currentY + charData.yOffset * scale;
				charLocation.scale = scale;
				CHARACTER_BUFFER[CHARACTER_BUFFER.length] = charLocation;
				wordLength++;
			}
			else
			{
				this.addCharacterToBatch(charData, currentX + charData.xOffset * scale, currentY + charData.yOffset * scale, scale);
			}

			currentX += offsetX + customLetterSpacing;
			previousCharID = charID;
		}
		currentX = currentX - customLetterSpacing;
		if(currentX < 0)
		{
			currentX = 0;
		}
		if(this._wordWrap || isAligned)
		{
			this.alignBuffer(maxLineWidth, currentX, 0);
			this.addBufferToBatch(0);
		}
		//if the text ends in extra whitespace, the currentX value will be
		//larger than the max line width. we'll remove that and add extra
		//lines.
		if(this._wordWrap)
		{
			while(currentX > maxLineWidth)
			{
				currentX -= maxLineWidth;
				currentY += lineHeight;
			}
		}
		if(maxX < currentX)
		{
			maxX = currentX;
		}

		if(isAligned && !hasExplicitWidth)
		{
			var align:TextFormatAlign = this._textFormat.align;
			if(align == TextFormatAlign.CENTER)
			{
				this._batchX = (maxX - maxLineWidth) / 2;
			}
			else if(align == TextFormatAlign.RIGHT)
			{
				this._batchX = maxX - maxLineWidth;
			}
		}
		else
		{
			this._batchX = 0;
		}
		this._characterBatch.x = this._batchX;

		result.x = maxX;
		result.y = currentY + lineHeight;
		return result;
	}

	/**
	 * @private
	 */
	private function trimBuffer(skipCount:Int):Void
	{
		var countToRemove:Int = 0;
		var charCount:Int = CHARACTER_BUFFER.length - skipCount;
		//for(var i:Int = charCount - 1; i >= 0; i--)
		var i:Int = charCount - 1;
		while(i >= 0)
		{
			var charLocation:CharLocation = CHARACTER_BUFFER[i];
			var charData:BitmapChar = charLocation.char;
			var charID:Int = charData.charID;
			if(charID == CHARACTER_ID_SPACE || charID == CHARACTER_ID_TAB)
			{
				countToRemove++;
			}
			else
			{
				break;
			}
			--i;
		}
		if(countToRemove > 0)
		{
			CHARACTER_BUFFER.splice(i + 1, countToRemove);
		}
	}

	/**
	 * @private
	 */
	private function alignBuffer(maxLineWidth:Float, currentLineWidth:Float, skipCount:Int):Void
	{
		var align:TextFormatAlign = this.currentTextFormat.align;
		if(align == TextFormatAlign.CENTER)
		{
			this.moveBufferedCharacters(Math.round((maxLineWidth - currentLineWidth) / 2), 0, skipCount);
		}
		else if(align == TextFormatAlign.RIGHT)
		{
			this.moveBufferedCharacters(maxLineWidth - currentLineWidth, 0, skipCount);
		}
	}

	/**
	 * @private
	 */
	private function addBufferToBatch(skipCount:Int):Void
	{
		var charCount:Int = CHARACTER_BUFFER.length - skipCount;
		var pushIndex:Int = CHAR_LOCATION_POOL.length;
		//for(var i:Int = 0; i < charCount; i++)
		for(i in 0 ... charCount)
		{
			var charLocation:CharLocation = CHARACTER_BUFFER.shift();
			this.addCharacterToBatch(charLocation.char, charLocation.x, charLocation.y, charLocation.scale);
			charLocation.char = null;
			CHAR_LOCATION_POOL[pushIndex] = charLocation;
			pushIndex++;
		}
	}

	/**
	 * @private
	 */
	private function moveBufferedCharacters(xOffset:Float, yOffset:Float, skipCount:Int):Void
	{
		var charCount:Int = CHARACTER_BUFFER.length - skipCount;
		//for(var i:Int = 0; i < charCount; i++)
		for(i in 0 ... charCount)
		{
			var charLocation:CharLocation = CHARACTER_BUFFER[i];
			charLocation.x += xOffset;
			charLocation.y += yOffset;
		}
	}

	/**
	 * @private
	 */
	private function addCharacterToBatch(charData:BitmapChar, x:Float, y:Float, scale:Float, support:RenderSupport = null, parentAlpha:Float = 1):Void
	{
		var texture:Texture = charData.texture;
		var frame:Rectangle = texture.frame;
		if(frame != null)
		{
			if(frame.width == 0 || frame.height == 0)
			{
				return;
			}
		}
		else if(texture.width == 0 || texture.height == 0)
		{
			return;
		}
		if(HELPER_IMAGE == null)
		{
			HELPER_IMAGE = new Image(texture);
		}
		else
		{
			HELPER_IMAGE.texture = texture;
			HELPER_IMAGE.readjustSize();
		}
		HELPER_IMAGE.scaleX = HELPER_IMAGE.scaleY = scale;
		HELPER_IMAGE.x = x;
		HELPER_IMAGE.y = y;
		HELPER_IMAGE.color = this.currentTextFormat.color;
		HELPER_IMAGE.smoothing = this._smoothing;

		if(support != null)
		{
			support.pushMatrix();
			support.transformMatrix(HELPER_IMAGE);
			support.batchQuad(HELPER_IMAGE, parentAlpha, HELPER_IMAGE.texture, this._smoothing);
			support.popMatrix();
		}
		else
		{
			this._characterBatch.addImage(HELPER_IMAGE);
		}
	}

	/**
	 * @private
	 */
	private function refreshTextFormat():Void
	{
		if(!this._isEnabled && this._disabledTextFormat != null)
		{
			this.currentTextFormat = this._disabledTextFormat;
		}
		else
		{
			#if 0 // No fallback to mini font since its is not implemented in OpenFL port
			//let's fall back to using Starling's embedded mini font if no
			//text format has been specified
			if(this._textFormat == null)
			{
				//if it's not registered, do that first
				if(TextField.getBitmapFont(BitmapFont.MINI) == null)
				{
					TextField.registerBitmapFont(new BitmapFont());
				}
				this._textFormat = new BitmapFontTextFormat(BitmapFont.MINI, null, 0x000000);
			}
			#end
			this.currentTextFormat = this._textFormat;
		}
	}

	/**
	 * @private
	 */
	private function getTruncatedText(width:Float):String
	{
		if(this._text == null)
		{
			//this shouldn't be called if _text is null, but just in case...
			return "";
		}

		//if the width is infinity or the string is multiline, don't allow truncation
		if(width == Math.POSITIVE_INFINITY || this._wordWrap || this._text.indexOf(String.fromCharCode(CHARACTER_ID_LINE_FEED)) >= 0 || this._text.indexOf(String.fromCharCode(CHARACTER_ID_CARRIAGE_RETURN)) >= 0)
		{
			return this._text;
		}

		var font:BitmapFont = this.currentTextFormat.font;
		var customSize:Float = this.currentTextFormat.size;
		var customLetterSpacing:Float = this.currentTextFormat.letterSpacing;
		var isKerningEnabled:Bool = this.currentTextFormat.isKerningEnabled;
		var scale:Float = customSize / font.size;
		if(scale != scale) //isNaN
		{
			scale = 1;
		}
		var currentX:Float = 0;
		var previousCharID:Float = Math.NaN;
		var charCount:Int = this._text.length;
		var truncationIndex:Int = -1;
		//for(var i:Int = 0; i < charCount; i++)
		for(i in 0 ... charCount)
		{
			var charID:Int = this._text.charCodeAt(i);
			var charData:BitmapChar = font.getChar(charID);
			if(charData == null)
			{
				continue;
			}
			var currentKerning:Float = 0;
			if(isKerningEnabled &&
				previousCharID == previousCharID) //!isNaN
			{
				currentKerning = charData.getKerning(Std.int(previousCharID)) * scale;
			}
			currentX += currentKerning + charData.xAdvance * scale;
			if(currentX > width)
			{
				//floating point errors can cause unnecessary truncation,
				//so we're going to be a little bit fuzzy on the greater
				//than check. such tiny numbers shouldn't break anything.
				var difference:Float = Math.abs(currentX - width);
				if(difference > FUZZY_MAX_WIDTH_PADDING)
				{
					truncationIndex = i;
					break;
				}
			}
			currentX += customLetterSpacing;
			previousCharID = charID;
		}

		if(truncationIndex >= 0)
		{
			//first measure the size of the truncation text
			charCount = this._truncationText.length;
			//for(i = 0; i < charCount; i++)
			for(i in 0 ... charCount)
			{
				var charID:Int = this._truncationText.charCodeAt(i);
				var charData:BitmapChar = font.getChar(charID);
				if(charData == null)
				{
					continue;
				}
				var currentKerning:Float = 0;
				if(isKerningEnabled &&
					previousCharID == previousCharID) //!isNaN
				{
					currentKerning = charData.getKerning(Std.int(previousCharID)) * scale;
				}
				currentX += currentKerning + charData.xAdvance * scale + customLetterSpacing;
				previousCharID = charID;
			}
			currentX -= customLetterSpacing;

			//then work our way backwards until we fit into the width
			//for(i = truncationIndex; i >= 0; i--)
			var i:Int = truncationIndex;
			while(i >= 0)
			{
				var charID:Int = this._text.charCodeAt(i);
				previousCharID = i > 0 ? this._text.charCodeAt(i - 1) : Math.NaN;
				var charData:BitmapChar = font.getChar(charID);
				if(charData == null)
				{
					continue;
				}
				var currentKerning:Float = 0;
				if(isKerningEnabled &&
					previousCharID == previousCharID) //!isNaN
				{
					currentKerning = charData.getKerning(Std.int(previousCharID)) * scale;
				}
				currentX -= (currentKerning + charData.xAdvance * scale + customLetterSpacing);
				if(currentX <= width)
				{
					return this._text.substr(0, i) + this._truncationText;
				}
				--i;
			}
			return this._truncationText;
		}
		return this._text;
	}

	/**
	 * @private
	 * This function is here to work around a bug in the Flex 4.6 SDK
	 * compiler. For explanation, see the places where it gets called.
	 */
	private function doNothing():Void {}
}

class CharLocation
{
public function new()
{

}

public var char:BitmapChar;
public var scale:Float;
public var x:Float;
public var y:Float;
}
