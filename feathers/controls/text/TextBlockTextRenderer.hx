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
#if 0
import feathers.utils.display.stageToStarling;
import feathers.utils.geom.matrixToScaleX;
import feathers.utils.geom.matrixToScaleY;
#else
import feathers.utils.display.FeathersDisplayUtil.stageToStarling;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleX;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleY;
#end
import openfl.Vector;

import openfl.display.BitmapData;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display3D.Context3DProfile;
import openfl.filters.BitmapFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if flash
import flash.text.engine.ContentElement;
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.SpaceJustifier;
import flash.text.engine.TabStop;
import flash.text.engine.TextBaseline;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;
import flash.text.engine.TextJustifier;
import flash.text.engine.TextLine;
import flash.text.engine.TextLineValidity;
import flash.text.engine.TextRotation;
#end

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.Image;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.utils.PowerOfTwo.getNextPowerOfTwo;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;

/**
 * Renders text with a native <code>openfl.text.engine.TextBlock</code> from
 * Flash Text Engine (FTE), and draws it to <code>BitmapData</code> to
 * convert to Starling textures. Textures are completely managed by this
 * component, and they will be automatically disposed when the component is
 * disposed.
 *
 * <p>For longer passages of text, this component will stitch together
 * multiple individual textures both horizontally and vertically, as a grid,
 * if required. This may require quite a lot of texture memory, possibly
 * exceeding the limits of some mobile devices, so use this component with
 * caution when displaying a lot of text.</p>
 *
 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html openfl.text.engine.TextBlock
 */
class TextBlockTextRenderer extends FeathersControl implements ITextRenderer
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
	 * @private
	 */
	private static var HELPER_RECTANGLE:Rectangle = new Rectangle();
#if flash
	/**
	 * @private
	 */
	private static var HELPER_TEXT_LINES:Array<TextLine> = new Array();
#end
	/**
	 * @private
	 * This is enforced by the runtime.
	 */
	inline private static var MAX_TEXT_LINE_WIDTH:Float = 1000000;

	/**
	 * @private
	 */
	inline private static var LINE_FEED:String = "\n";

	/**
	 * @private
	 */
	inline private static var CARRIAGE_RETURN:String = "\r";

	/**
	 * @private
	 */
	inline private static var FUZZY_TRUNCATION_DIFFERENCE:Float = 0.000001;

	/**
	 * The text will be positioned to the left edge.
	 *
	 * @see #textAlign
	 */
	inline public static var TEXT_ALIGN_LEFT:String = "left";

	/**
	 * The text will be centered horizontally.
	 *
	 * @see #textAlign
	 */
	inline public static var TEXT_ALIGN_CENTER:String = "center";

	/**
	 * The text will be positioned to the right edge.
	 *
	 * @see #textAlign
	 */
	inline public static var TEXT_ALIGN_RIGHT:String = "right";

	/**
	 * The default <code>IStyleProvider</code> for all <code>TextBlockTextRenderer</code>
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
		this.isQuickHitAreaEnabled = true;
	}

	/**
	 * The TextBlock instance used to render the text before taking a
	 * texture snapshot.
	 */
#if flash
	private var textBlock:TextBlock;
#end
	/**
	 * An image that displays a snapshot of the native <code>TextBlock</code>
	 * in the Starling display list when the editor doesn't have focus.
	 */
	private var textSnapshot:Image;

	/**
	 * If multiple snapshots are needed due to texture size limits, the
	 * snapshots appearing after the first are stored here.
	 */
	private var textSnapshots:Array<Image>;

	/**
	 * @private
	 */
	private var _textSnapshotScrollX:Float = 0;

	/**
	 * @private
	 */
	private var _textSnapshotScrollY:Float = 0;

	/**
	 * @private
	 */
	private var _textSnapshotOffsetX:Float = 0;

	/**
	 * @private
	 */
	private var _textSnapshotOffsetY:Float = 0;

	/**
	 * @private
	 */
	private var _lastGlobalScaleX:Float = 0;

	/**
	 * @private
	 */
	private var _lastGlobalScaleY:Float = 0;

	/**
	 * @private
	 */
	private var _textLineContainer:Sprite;

	/**
	 * @private
	 */
#if flash
	private var _textLines:Array<TextLine> = new Array();
#end
	/**
	 * @private
	 */
	private var _measurementTextLineContainer:Sprite;

	/**
	 * @private
	 */
#if flash
	private var _measurementTextLines:Array<TextLine> = new Array();
#end
	/**
	 * @private
	 */
	private var _previousContentWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _previousContentHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _snapshotWidth:Int = 0;

	/**
	 * @private
	 */
	private var _snapshotHeight:Int = 0;

	/**
	 * @private
	 */
	private var _snapshotVisibleWidth:Int = 0;

	/**
	 * @private
	 */
	private var _snapshotVisibleHeight:Int = 0;

	/**
	 * @private
	 */
	private var _needsNewTexture:Bool = false;

	/**
	 * @private
	 */
	private var _truncationOffset:Int = 0;

	/**
	 * @private
	 */
#if flash
	private var _textElement:TextElement;
#end
	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return TextBlockTextRenderer.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _text:String;

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
#if flash
		return this._textElement != null ? this._text : null;
#else
		return this._text;
#end
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
#if flash
		if(this._textElement == null)
		{
			this._textElement = new TextElement(value);
		}
		#if 0
		this._textElement.text = value;
		#end
		this.content = this._textElement;
#end
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._text;
	}

	/**
	 * @private
	 */
#if flash
	private var _content:ContentElement;

	/**
	 * Sets the contents of the <code>TextBlock</code> to a complex value
	 * that is more than simple text. If the <code>text</code> property is
	 * set after the <code>content</code> property, the <code>content</code>
	 * property will be replaced with a <code>TextElement</code>.
	 *
	 * <p>In the following example, the content is changed to a
	 * <code>GroupElement</code>:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.content = new GroupElement( element );</listing>
	 *
	 * <p>To simply display a string value, use the <code>text</code> property
	 * instead:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.text = "Lorem Ipsum";</listing>
	 *
	 * @default null
	 *
	 * @see #text
	 */
	public var content(get, set):ContentElement;
	public function get_content():ContentElement
	{
		return this._content;
	}

	/**
	 * @private
	 */
	public function set_content(value:ContentElement):ContentElement
	{
		if(this._content == value)
		{
			return get_content();
		}
		if(Std.is(value, TextElement))
		{
			this._textElement = cast value;
		}
		else
		{
			this._textElement = null;
		}
		this._content = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_content();
	}
#end

	/**
	 * @private
	 */
#if flash
	private var _elementFormat:ElementFormat;

	/**
	 * The font and styles used to draw the text. This property will be
	 * ignored if the content is not a <code>TextElement</code> instance.
	 *
	 * <p>In the following example, the element format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.elementFormat = new ElementFormat( new FontDescription( "Source Sans Pro" ) );</listing>
	 *
	 * @default null
	 *
	 * @see #disabledElementFormat
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html openfl.text.engine.ElementFormat
	 */
	public var elementFormat(get, set):ElementFormat;
	public function get_elementFormat():ElementFormat
	{
		return this._elementFormat;
	}

	/**
	 * @private
	 */
	public function set_elementFormat(value:ElementFormat):ElementFormat
	{
		if(this._elementFormat == value)
		{
			return get_elementFormat();
		}
		this._elementFormat = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_elementFormat();
	}

	/**
	 * @private
	 */
	private var _disabledElementFormat:ElementFormat;

	/**
	 * The font and styles used to draw the text when the component is
	 * disabled. This property will be ignored if the content is not a
	 * <code>TextElement</code> instance.
	 *
	 * <p>In the following example, the disabled element format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.isEnabled = false;
	 * textRenderer.disabledElementFormat = new ElementFormat( new FontDescription( "Source Sans Pro" ) );</listing>
	 *
	 * @default null
	 *
	 * @see #elementFormat
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html openfl.text.engine.ElementFormat
	 */
	public var disabledElementFormat(get, set):ElementFormat;
	public function get_disabledElementFormat():ElementFormat
	{
		return this._disabledElementFormat;
	}

	/**
	 * @private
	 */
	public function set_disabledElementFormat(value:ElementFormat):ElementFormat
	{
		if(this._disabledElementFormat == value)
		{
			return get_disabledElementFormat();
		}
		this._disabledElementFormat = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_disabledElementFormat();
	}
#end
	
	/**
	 * @private
	 */
	private var _leading:Float = 0;

	/**
	 * The amount of vertical space, in pixels, between lines.
	 *
	 * <p>In the following example, the leading is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.leading = 20;</listing>
	 *
	 * @default 0
	 */
	public var leading(get, set):Float;
	public function get_leading():Float
	{
		return this._leading;
	}

	/**
	 * @private
	 */
	public function set_leading(value:Float):Float
	{
		if(this._leading == value)
		{
			return get_leading();
		}
		this._leading = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_leading();
	}

	/**
	 * @private
	 */
	private var _textAlign:String = TEXT_ALIGN_LEFT;

	/**
	 * The alignment of the text. For justified text, see the
	 * <code>textJustifier</code> property.
	 *
	 * <p>In the following example, the leading is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;</listing>
	 *
	 * @default TextBlockTextRenderer.TEXT_ALIGN_LEFT
	 *
	 * @see #TEXT_ALIGN_LEFT
	 * @see #TEXT_ALIGN_CENTER
	 * @see #TEXT_ALIGN_RIGHT
	 * @see #textJustifier
	 */
	public var textAlign(get, set):String;
	public function get_textAlign():String
	{
		return this._textAlign;
	}

	/**
	 * @private
	 */
	public function set_textAlign(value:String):String
	{
		if(this._textAlign == value)
		{
			return get_textAlign();
		}
		this._textAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_textAlign();
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
		return this._wordWrap;
	}

	/**
	 * @private
	 */
	public function set_wordWrap(value:Bool):Bool
	{
		if(this._wordWrap == value)
		{
			return this._wordWrap;
		}
		this._wordWrap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._wordWrap;
	}

	/**
	 * @inheritDoc
	 */
	public var baseline(get, never):Float;
	public function get_baseline():Float
	{
#if flash
		if(this._textLines.length == 0)
		{
			return 0;
		}
		return this._textLines[0].ascent;
#else
		return 0;
#end
	}

	/**
	 * @private
	 */
	private var _applyNonLinearFontScaling:Bool = true;

	/**
	 * Specifies that you want to enhance screen appearance at the expense
	 * of what-you-see-is-what-you-get (WYSIWYG) print fidelity.
	 *
	 * <p>In the following example, this property is changed to false:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.applyNonLinearFontScaling = false;</listing>
	 *
	 * @default true
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#applyNonLinearFontScaling Full description of openfl.text.engine.TextBlock.applyNonLinearFontScaling in Adobe's Flash Platform API Reference
	 */
	public var applyNonLinearFontScaling(get, set):Bool;
	public function get_applyNonLinearFontScaling():Bool
	{
		return this._applyNonLinearFontScaling;
	}

	/**
	 * @private
	 */
	public function set_applyNonLinearFontScaling(value:Bool):Bool
	{
		if(this._applyNonLinearFontScaling == value)
		{
			return get_applyNonLinearFontScaling();
		}
		this._applyNonLinearFontScaling = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_applyNonLinearFontScaling();
	}

	/**
	 * @private
	 */
#if flash
	private var _baselineFontDescription:FontDescription;
#end
	/**
	 * The font used to determine the baselines for all the lines created from the block, independent of their content.
	 *
	 * <p>In the following example, the baseline font description is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.baselineFontDescription = new FontDescription( "Source Sans Pro", FontWeight.BOLD );</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#baselineFontDescription Full description of openfl.text.engine.TextBlock.baselineFontDescription in Adobe's Flash Platform API Reference
	 * @see #baselineFontSize
	 */
#if flash
	public var baselineFontDescription(get, set):FontDescription;
	public function get_baselineFontDescription():FontDescription
	{
		return this._baselineFontDescription;
	}
#end
	/**
	 * @private
	 */
#if flash
	public function set_baselineFontDescription(value:FontDescription):FontDescription
	{
		if(this._baselineFontDescription == value)
		{
			return get_baselineFontDescription();
		}
		this._baselineFontDescription = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_baselineFontDescription();
	}
#end

	/**
	 * @private
	 */
	private var _baselineFontSize:Float = 12;

	/**
	 * The font size used to calculate the baselines for the lines created
	 * from the block.
	 *
	 * <p>In the following example, the baseline font size is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.baselineFontSize = 20;</listing>
	 *
	 * @default 12
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#baselineFontSize Full description of openfl.text.engine.TextBlock.baselineFontSize in Adobe's Flash Platform API Reference
	 * @see #baselineFontDescription
	 */
	public var baselineFontSize(get, set):Float;
	public function get_baselineFontSize():Float
	{
		return this._baselineFontSize;
	}

	/**
	 * @private
	 */
	public function set_baselineFontSize(value:Float):Float
	{
		if(this._baselineFontSize == value)
		{
			return get_baselineFontSize();
		}
		this._baselineFontSize = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_baselineFontSize();
	}

	/**
	 * @private
	 */
#if flash
	private var _baselineZero:TextBaseline = TextBaseline.ROMAN;
#end

	/**
	 * Specifies which baseline is at y=0 for lines created from this block.
	 *
	 * <p>In the following example, the baseline zero is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.baselineZero = TextBaseline.ASCENT;</listing>
	 *
	 * @default TextBaseline.ROMAN
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#baselineZero Full description of openfl.text.engine.TextBlock.baselineZero in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBaseline.html openfl.text.engine.TextBaseline
	 */
#if flash
	public var baselineZero(get, set):TextBaseline;
	public function get_baselineZero():TextBaseline
	{
		return this._baselineZero;
	}
#end

	/**
	 * @private
	 */
#if flash
	public function set_baselineZero(value:TextBaseline):TextBaseline
	{
		if(this._baselineZero == value)
		{
			return get_baselineZero();
		}
		this._baselineZero = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_baselineZero();
	}
#end

	/**
	 * @private
	 */
	private var _bidiLevel:Int = 0;

	/**
	 * Specifies the bidirectional paragraph embedding level of the text
	 * block.
	 *
	 * <p>In the following example, the bidi level is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.bidiLevel = 1;</listing>
	 *
	 * @default 0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#bidiLevel Full description of openfl.text.engine.TextBlock.bidiLevel in Adobe's Flash Platform API Reference
	 */
	public var bidiLevel(get, set):Int;
	public function get_bidiLevel():Int
	{
		return this._bidiLevel;
	}

	/**
	 * @private
	 */
	public function set_bidiLevel(value:Int):Int
	{
		if(this._bidiLevel == value)
		{
			return get_bidiLevel();
		}
		this._bidiLevel = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_bidiLevel();
	}

	/**
	 * @private
	 */
#if flash
	private var _lineRotation:TextRotation = TextRotation.ROTATE_0;
#end

	/**
	 * Rotates the text lines in the text block as a unit.
	 *
	 * <p>In the following example, the line rotation is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.lineRotation = TextRotation.ROTATE_90;</listing>
	 *
	 * @default TextRotation.ROTATE_0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#lineRotation Full description of openfl.text.engine.TextBlock.lineRotation in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextRotation.html openfl.text.engine.TextRotation
	 */
#if flash
	public var lineRotation(get, set):TextRotation;
	public function get_lineRotation():TextRotation
	{
		return this._lineRotation;
	}
#end

	/**
	 * @private
	 */
#if flash
	public function set_lineRotation(value:TextRotation):TextRotation
	{
		if(this._lineRotation == value)
		{
			return get_lineRotation();
		}
		this._lineRotation = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_lineRotation();
	}
#end

	/**
	 * @private
	 */
#if flash
	private var _tabStops:Vector<TabStop>;

	/**
	 * Specifies the tab stops for the text in the text block, in the form
	 * of a <code>Vector</code> of <code>TabStop</code> objects.
	 *
	 * <p>In the following example, the tab stops changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.tabStops = new &lt;TabStop&gt;[ new TabStop( TabAlignment.CENTER ) ];</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#tabStops Full description of openfl.text.engine.TextBlock.tabStops in Adobe's Flash Platform API Reference
	 */
	public var tabStops(get, set):Vector<TabStop>;
	public function get_tabStops():Vector<TabStop>
	{
		return this._tabStops;
	}

	/**
	 * @private
	 */
	public function set_tabStops(value:Vector<TabStop>):Vector<TabStop>
	{
		if(this._tabStops == value)
		{
			return this._tabStops;
		}
		this._tabStops = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._tabStops;
	}

	/**
	 * @private
	 */
	private var _textJustifier:TextJustifier = new SpaceJustifier();

	/**
	 * Specifies the <code>TextJustifier</code> to use during line creation.
	 *
	 * <p>In the following example, the text justifier is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.textJustifier = new SpaceJustifier( "en", LineJustification.ALL_BUT_LAST );</listing>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#textJustifier Full description of openfl.text.engine.TextBlock.textJustifier in Adobe's Flash Platform API Reference
	 */
	public var textJustifier(get, set):TextJustifier;
	public function get_textJustifier():TextJustifier
	{
		return this._textJustifier;
	}

	/**
	 * @private
	 */
	public function set_textJustifier(value:TextJustifier):TextJustifier
	{
		if(this._textJustifier == value)
		{
			return get_textJustifier();
		}
		this._textJustifier = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_textJustifier();
	}
#end
	/**
	 * @private
	 */
	private var _userData:Dynamic;

	/**
	 * Provides a way for the application to associate arbitrary data with
	 * the text block.
	 *
	 * <p>In the following example, the user data is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.userData = { author: "William Shakespeare", title: "Much Ado About Nothing" };</listing>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#userData Full description of openfl.text.engine.TextBlock.userData in Adobe's Flash Platform API Reference
	 */
	public var userData(get, set):Dynamic;
	public function get_userData():Dynamic
	{
		return this._userData;
	}

	/**
	 * @private
	 */
	public function set_userData(value:Dynamic):Dynamic
	{
		if(this._userData == value)
		{
			return get_userData();
		}
		this._userData = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_userData();
	}

	/**
	 * @private
	 */
	private var _snapToPixels:Bool = true;

	/**
	 * Determines if the text should be snapped to the nearest whole pixel
	 * when rendered. When this is <code>false</code>, text may be displayed
	 * on sub-pixels, which often results in blurred rendering due to
	 * texture smoothing.
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
		return this._snapToPixels;
	}

	/**
	 * @private
	 */
	public function set_snapToPixels(value:Bool):Bool
	{
		this._snapToPixels = value;
		return get_snapToPixels();
	}

	/**
	 * @private
	 */
	private var _maxTextureDimensions:Int = 2048;

	/**
	 * The maximum size of individual textures that are managed by this text
	 * renderer. Must be a power of 2. A larger value will create fewer
	 * individual textures, but a smaller value may use less overall texture
	 * memory by incrementing over smaller powers of two.
	 *
	 * <p>In the following example, the maximum size of the textures is
	 * changed:</p>
	 *
	 * <listing version="3.0">
	 * renderer.maxTextureDimensions = 4096;</listing>
	 *
	 * @default 2048
	 */
	public var maxTextureDimensions(get, set):Int;
	public function get_maxTextureDimensions():Int
	{
		return this._maxTextureDimensions;
	}

	/**
	 * @private
	 */
	public function set_maxTextureDimensions(value:Int):Int
	{
		//check if we can use rectangle textures or not
		if(Starling.current.profile == Context3DProfile.BASELINE_CONSTRAINED)
		{
			value = getNextPowerOfTwo(value);
		}
		if(this._maxTextureDimensions == value)
		{
			return get_maxTextureDimensions();
		}
		this._maxTextureDimensions = value;
		this._needsNewTexture = true;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_maxTextureDimensions();
	}

	/**
	 * @private
	 */
	private var _nativeFilters:Array<BitmapFilter>;

	/**
	 * Native filters to pass to the <code>openfl.text.engine.TextLine</code>
	 * instances before creating the texture snapshot.
	 *
	 * <p>In the following example, the native filters are changed:</p>
	 *
	 * <listing version="3.0">
	 * renderer.nativeFilters = [ new GlowFilter() ];</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#filters Full description of openfl.display.DisplayObject.filters in Adobe's Flash Platform API Reference
	 */
	public var nativeFilters(get, set):Array<BitmapFilter>;
	public function get_nativeFilters():Array<BitmapFilter>
	{
		return this._nativeFilters;
	}

	/**
	 * @private
	 */
	public function set_nativeFilters(value:Array<BitmapFilter>):Array<BitmapFilter>
	{
		if(this._nativeFilters == value)
		{
			return get_nativeFilters();
		}
		this._nativeFilters = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_nativeFilters();
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
	 *
	 * @see #truncateToFit
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
			return get_truncationText();
		}
		this._truncationText = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_truncationText();
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
	 * <p>This feature only works when the <code>text</code> property is
	 * set to a string value. If the <code>content</code> property is set
	 * instead, then the content will not be truncated.</p>
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
	private var _updateSnapshotOnScaleChange:Bool = false;

	/**
	 * Refreshes the texture snapshot every time that the text renderer is
	 * scaled. Based on the scale in global coordinates, so scaling the
	 * parent will require a new snapshot.
	 *
	 * <p>Warning: setting this property to true may result in reduced
	 * performance because every change of the scale requires uploading a
	 * new texture to the GPU. Use with caution. Consider setting this
	 * property to false temporarily during animations that modify the
	 * scale.</p>
	 *
	 * <p>In the following example, the snapshot will be updated when the
	 * text renderer is scaled:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.updateSnapshotOnScaleChange = true;</listing>
	 *
	 * @default false
	 */
	public function get_updateSnapshotOnScaleChange():Bool
	{
		return this._updateSnapshotOnScaleChange;
	}

	/**
	 * @private
	 */
	public function set_updateSnapshotOnScaleChange(value:Bool):Bool
	{
		if(this._updateSnapshotOnScaleChange == value)
		{
			return get_updateSnapshotOnScaleChange();
		}
		this._updateSnapshotOnScaleChange = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_updateSnapshotOnScaleChange();
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this.textSnapshot != null)
		{
			this.textSnapshot.texture.dispose();
			this.removeChild(this.textSnapshot, true);
			this.textSnapshot = null;
		}
		if(this.textSnapshots != null)
		{
			var snapshotCount:Int = this.textSnapshots.length;
			for(i in 0 ... snapshotCount)
			{
				var snapshot:Image = this.textSnapshots[i];
				snapshot.texture.dispose();
				this.removeChild(snapshot, true);
			}
			this.textSnapshots = null;
		}
		//this isn't necessary, but if a memory leak keeps the text renderer
		//from being garbage collected, freeing up these things may help
		//ease memory pressure from native filters and other expensive stuff
#if flash
		this.textBlock = null;
#end
		this._textLineContainer = null;
#if flash
		this._textLines = null;
#end
		this._measurementTextLineContainer = null;
#if flash
		this._measurementTextLines = null;
		this._textElement = null;
		this._content = null;
#end
		this._previousContentWidth = Math.NaN;
		this._previousContentHeight = Math.NaN;

		this._needsNewTexture = false;
		this._snapshotWidth = 0;
		this._snapshotHeight = 0;

		super.dispose();
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		if(this.textSnapshot != null)
		{
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			if(this._updateSnapshotOnScaleChange)
			{
				var globalScaleX:Float = matrixToScaleX(HELPER_MATRIX);
				var globalScaleY:Float = matrixToScaleY(HELPER_MATRIX);
				if(globalScaleX != this._lastGlobalScaleX || globalScaleY != this._lastGlobalScaleY)
				{
					//the snapshot needs to be updated because the scale has
					//changed since the last snapshot was taken.
					this.invalidate(INVALIDATION_FLAG_SIZE);
					this.validate();
				}
			}
			var scaleFactor:Float = Starling.current.contentScaleFactor;
			var offsetX:Float;
			var offsetY:Float;
			if(this._nativeFilters == null || this._nativeFilters.length == 0)
			{
				offsetX = 0;
				offsetY = 0;
			}
			else
			{
				offsetX = this._textSnapshotOffsetX / scaleFactor;
				offsetY = this._textSnapshotOffsetY / scaleFactor;
			}
			if(this._snapToPixels)
			{
				offsetX += Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
				offsetY += Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
			}

			var snapshotIndex:Int = -1;
			var totalBitmapWidth:Float = this._snapshotWidth;
			var totalBitmapHeight:Float = this._snapshotHeight;
			var xPosition:Float = offsetX;
			var yPosition:Float = offsetY;
			do
			{
				var currentBitmapWidth:Float = totalBitmapWidth;
				if(currentBitmapWidth > this._maxTextureDimensions)
				{
					currentBitmapWidth = this._maxTextureDimensions;
				}
				do
				{
					var currentBitmapHeight:Float = totalBitmapHeight;
					if(currentBitmapHeight > this._maxTextureDimensions)
					{
						currentBitmapHeight = this._maxTextureDimensions;
					}
					var snapshot:Image;
					if(snapshotIndex < 0)
					{
						snapshot = this.textSnapshot;
					}
					else
					{
						snapshot = this.textSnapshots[snapshotIndex];
					}
					snapshot.x = xPosition / scaleFactor;
					snapshot.y = yPosition / scaleFactor;
					if(this._updateSnapshotOnScaleChange)
					{
						snapshot.x /= this._lastGlobalScaleX;
						snapshot.y /= this._lastGlobalScaleX;
					}
					snapshotIndex++;
					yPosition += currentBitmapHeight;
					totalBitmapHeight -= currentBitmapHeight;
				}
				while(totalBitmapHeight > 0);
				xPosition += currentBitmapWidth;
				totalBitmapWidth -= currentBitmapWidth;
				yPosition = offsetY;
				totalBitmapHeight = this._snapshotHeight;
			}
			while(totalBitmapWidth > 0);
		}
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

		//if a parent component validates before we're added to the stage,
		//measureText() may be called before initialization, so we need to
		//force it.
		if(!this._isInitialized)
		{
			this.initializeInternal();
		}

		this.commit();

		result = this.measure(result);

		return result;
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
#if flash
		if(this.textBlock == null)
		{
			this.textBlock = new TextBlock();
		}
#end
		if(this._textLineContainer == null)
		{
			this._textLineContainer = new Sprite();
		}
		if(this._measurementTextLineContainer == null)
		{
			this._measurementTextLineContainer = new Sprite();
		}
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);

		this.commit();

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layout(sizeInvalid);
	}

	/**
	 * @private
	 */
	private function commit():Void
	{
#if flash
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);

		if(dataInvalid || stylesInvalid || stateInvalid)
		{
			if(this._textElement != null)
			{
				if(!this._isEnabled && this._disabledElementFormat != null)
				{
					this._textElement.elementFormat = this._disabledElementFormat;
				}
				else
				{
					if(this._elementFormat == null)
					{
						this._elementFormat = new ElementFormat();
					}
					this._textElement.elementFormat = this._elementFormat;
				}
			}
		}

		if(stylesInvalid)
		{
			this.textBlock.applyNonLinearFontScaling = this._applyNonLinearFontScaling;
			this.textBlock.baselineFontDescription = this._baselineFontDescription;
			this.textBlock.baselineFontSize = this._baselineFontSize;
			this.textBlock.baselineZero = this._baselineZero;
			this.textBlock.bidiLevel = this._bidiLevel;
			this.textBlock.lineRotation = this._lineRotation;
			this.textBlock.tabStops = this._tabStops;
			this.textBlock.textJustifier = this._textJustifier;
			this.textBlock.userData = this._userData;

			this._textLineContainer.filters = this._nativeFilters;
		}

		if(dataInvalid)
		{
			this.textBlock.content = this._content;
		}
#end
	}

	/**
	 * @private
	 */
	private function measure(result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}

		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			newWidth = this._maxWidth;
			if(newWidth > MAX_TEXT_LINE_WIDTH)
			{
				newWidth = MAX_TEXT_LINE_WIDTH;
			}
		}
		if(needsHeight)
		{
			newHeight = this._maxHeight;
		}
#if flash
		this.refreshTextLines(this._measurementTextLines, this._measurementTextLineContainer, newWidth, newHeight);
#end
		if(needsWidth)
		{
			newWidth = this._measurementTextLineContainer.width;
			if(newWidth > this._maxWidth)
			{
				newWidth = this._maxWidth;
			}
		}
		if(needsHeight)
		{
			newHeight = this._measurementTextLineContainer.height;
#if flash
			if(newHeight <= 0 && this._elementFormat != null)
			{
				newHeight = this._elementFormat.fontSize;
			}
#end
		}

		result.x = newWidth;
		result.y = newHeight;

		return result;
	}

	/**
	 * @private
	 */
	private function layout(sizeInvalid:Bool):Void
	{
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);

		if(sizeInvalid)
		{
			var scaleFactor:Float = Starling.current.contentScaleFactor;
			//these are getting put into an int later, so we don't want it
			//to possibly round down and cut off part of the text. 
			var rectangleSnapshotWidth:Float = Math.ceil(this.actualWidth * scaleFactor);
			var rectangleSnapshotHeight:Float = Math.ceil(this.actualHeight * scaleFactor);
			if(this._updateSnapshotOnScaleChange)
			{
				this.getTransformationMatrix(this.stage, HELPER_MATRIX);
				rectangleSnapshotWidth *= matrixToScaleX(HELPER_MATRIX);
				rectangleSnapshotHeight *= matrixToScaleY(HELPER_MATRIX);
			}
			if(rectangleSnapshotWidth >= 1 && rectangleSnapshotHeight >= 1 &&
				this._nativeFilters != null && this._nativeFilters.length > 0)
			{
				HELPER_MATRIX.identity();
				HELPER_MATRIX.scale(scaleFactor, scaleFactor);
				var bitmapData:BitmapData = new BitmapData(Std.int(rectangleSnapshotWidth), Std.int(rectangleSnapshotHeight), true, 0x00ff00ff);
				bitmapData.draw(this._textLineContainer, HELPER_MATRIX, null, null, HELPER_RECTANGLE);
				this.measureNativeFilters(bitmapData, HELPER_RECTANGLE);
				bitmapData.dispose();
				bitmapData = null;
				this._textSnapshotOffsetX = HELPER_RECTANGLE.x;
				this._textSnapshotOffsetY = HELPER_RECTANGLE.y;
				rectangleSnapshotWidth = HELPER_RECTANGLE.width;
				rectangleSnapshotHeight = HELPER_RECTANGLE.height;
			}
			var canUseRectangleTexture:Bool = Starling.current.profile != Context3DProfile.BASELINE_CONSTRAINED;
			if(canUseRectangleTexture)
			{
				if(rectangleSnapshotWidth > this._maxTextureDimensions)
				{
					this._snapshotWidth = Std.int(Std.int(rectangleSnapshotWidth / this._maxTextureDimensions) * this._maxTextureDimensions + (rectangleSnapshotWidth % this._maxTextureDimensions));
				}
				else
				{
					this._snapshotWidth = Std.int(rectangleSnapshotWidth);
				}
			}
			else
			{
				if(rectangleSnapshotWidth > this._maxTextureDimensions)
				{
					this._snapshotWidth = Std.int(Std.int(rectangleSnapshotWidth / this._maxTextureDimensions) * this._maxTextureDimensions + getNextPowerOfTwo(Std.int(rectangleSnapshotWidth % this._maxTextureDimensions)));
				}
				else
				{
					this._snapshotWidth = getNextPowerOfTwo(Std.int(rectangleSnapshotWidth));
				}
			}
			if(canUseRectangleTexture)
			{
				if(rectangleSnapshotHeight > this._maxTextureDimensions)
				{
					this._snapshotHeight = Std.int(Std.int(rectangleSnapshotHeight / this._maxTextureDimensions) * this._maxTextureDimensions + (rectangleSnapshotHeight % this._maxTextureDimensions));
				}
				else
				{
					this._snapshotHeight = Std.int(rectangleSnapshotHeight);
				}
			}
			else
			{
				if(rectangleSnapshotHeight > this._maxTextureDimensions)
				{
					this._snapshotHeight = Std.int(rectangleSnapshotHeight / this._maxTextureDimensions) * this._maxTextureDimensions + getNextPowerOfTwo(Std.int(rectangleSnapshotHeight % this._maxTextureDimensions));
				}
				else
				{
					this._snapshotHeight = getNextPowerOfTwo(Std.int(rectangleSnapshotHeight));
				}
			}
			var textureRoot:ConcreteTexture = this.textSnapshot != null ? this.textSnapshot.texture.root : null;
			this._needsNewTexture = this._needsNewTexture || this.textSnapshot == null ||
			textureRoot.scale != scaleFactor ||
			this._snapshotWidth != textureRoot.width || this._snapshotHeight != textureRoot.height;
			this._snapshotVisibleWidth = Std.int(rectangleSnapshotWidth);
			this._snapshotVisibleHeight = Std.int(rectangleSnapshotHeight);
		}

		//instead of checking sizeInvalid, which will often be triggered by
		//changing maxWidth or something for measurement, we check against
		//the previous actualWidth/Height used for the snapshot.
		if(stylesInvalid || dataInvalid || stateInvalid || this._needsNewTexture ||
			this.actualWidth != this._previousContentWidth ||
			this.actualHeight != this._previousContentHeight)
		{
			this._previousContentWidth = this.actualWidth;
			this._previousContentHeight = this.actualHeight;
#if flash
			if(this._content != null)
			{
				this.refreshTextLines(this._textLines, this._textLineContainer, this.actualWidth, this.actualHeight);
				this.refreshSnapshot();
			}
			if(this.textSnapshot != null)
			{
				this.textSnapshot.visible = this._snapshotWidth > 0 && this._snapshotHeight > 0 && this._content != null;
			}
#end
		}
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

		this.measure(HELPER_POINT);
		return this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
	}

	/**
	 * @private
	 */
	private function measureNativeFilters(bitmapData:BitmapData, result:Rectangle = null):Rectangle
	{
		if(result == null)
		{
			result = new Rectangle();
		}
		var resultX:Float = 0;
		var resultY:Float = 0;
		var resultWidth:Float = 0;
		var resultHeight:Float = 0;
		var filterCount:Int = this._nativeFilters.length;
		for(i in 0 ... filterCount)
		{
			var filter:BitmapFilter = this._nativeFilters[i];
			var filterRect:Rectangle = bitmapData.generateFilterRect(bitmapData.rect, filter);
			var filterX:Float = filterRect.x;
			var filterY:Float = filterRect.y;
			var filterWidth:Float = filterRect.width;
			var filterHeight:Float = filterRect.height;
			if(resultX > filterX)
			{
				resultX = filterX;
			}
			if(resultY > filterY)
			{
				resultY = filterY;
			}
			if(resultWidth < filterWidth)
			{
				resultWidth = filterWidth;
			}
			if(resultHeight < filterHeight)
			{
				resultHeight = filterHeight;
			}
		}
		result.setTo(resultX, resultY, resultWidth, resultHeight);
		return result;
	}

	/**
	 * @private
	 */
	private function createTextureOnRestoreCallback(snapshot:Image):Void
	{
		var self:TextBlockTextRenderer = this;
		var texture:Texture = snapshot.texture;
		texture.root.onRestore = function():Void
		{
			var scaleFactor:Float = Starling.current.contentScaleFactor;
			if(texture.scale != scaleFactor)
			{
				//if we've changed between scale factors, we need to
				//recreate the texture to match the new scale factor.
				invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				HELPER_MATRIX.identity();
				HELPER_MATRIX.scale(scaleFactor, scaleFactor);
				var bitmapData:BitmapData = self.drawTextLinesRegionToBitmapData(
					snapshot.x, snapshot.y, texture.nativeWidth, texture.nativeHeight);
				texture.root.uploadBitmapData(bitmapData);
				bitmapData.dispose();
			}
		};
	}

	/**
	 * @private
	 */
	private function drawTextLinesRegionToBitmapData(textLinesX:Float, textLinesY:Float,
		bitmapWidth:Float, bitmapHeight:Float, bitmapData:BitmapData = null):BitmapData
	{
		var clipWidth:Float = this._snapshotVisibleWidth - textLinesX;
		var clipHeight:Float = this._snapshotVisibleHeight - textLinesY;
		if(bitmapData == null || bitmapData.width != bitmapWidth || bitmapData.height != bitmapHeight)
		{
			if(bitmapData != null)
			{
				bitmapData.dispose();
			}
			bitmapData = new BitmapData(Std.int(bitmapWidth), Std.int(bitmapHeight), true, 0x00ff00ff);
		}
		else
		{
			//clear the bitmap data and reuse it
			bitmapData.fillRect(bitmapData.rect, 0x00ff00ff);
		}
		var nativeScaleFactor:Float = 1;
		var starling:Starling = stageToStarling(this.stage);
		#if flash
		if(starling != null && starling.supportHighResolutions)
		{
			nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
		}
		#end
		HELPER_MATRIX.tx = -textLinesX - this._textSnapshotScrollX * nativeScaleFactor - this._textSnapshotOffsetX;
		HELPER_MATRIX.ty = -textLinesY - this._textSnapshotScrollY * nativeScaleFactor - this._textSnapshotOffsetY;
		HELPER_RECTANGLE.setTo(0, 0, clipWidth, clipHeight);
		bitmapData.draw(this._textLineContainer, HELPER_MATRIX, null, null, HELPER_RECTANGLE);
		return bitmapData;
	}

	/**
	 * @private
	 */
	private function refreshSnapshot():Void
	{
		if(this._snapshotWidth == 0 || this._snapshotHeight == 0)
		{
			return;
		}
		var scaleFactor:Float = Starling.current.contentScaleFactor;
		var globalScaleX:Float = Math.NaN;
		var globalScaleY:Float = Math.NaN;
		if(this._updateSnapshotOnScaleChange)
		{
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			globalScaleX = matrixToScaleX(HELPER_MATRIX);
			globalScaleY = matrixToScaleY(HELPER_MATRIX);
		}
		HELPER_MATRIX.identity();
		HELPER_MATRIX.scale(scaleFactor, scaleFactor);
		if(this._updateSnapshotOnScaleChange)
		{
			HELPER_MATRIX.scale(globalScaleX, globalScaleY);
		}
		var totalBitmapWidth:Float = this._snapshotWidth;
		var totalBitmapHeight:Float = this._snapshotHeight;
		var xPosition:Float = 0;
		var yPosition:Float = 0;
		var bitmapData:BitmapData = null;
		var snapshotIndex:Int = -1;
		var snapshot:Image = null;
		do
		{
			var currentBitmapWidth:Float = totalBitmapWidth;
			if(currentBitmapWidth > this._maxTextureDimensions)
			{
				currentBitmapWidth = this._maxTextureDimensions;
			}
			do
			{
				var currentBitmapHeight:Float = totalBitmapHeight;
				if(currentBitmapHeight > this._maxTextureDimensions)
				{
					currentBitmapHeight = this._maxTextureDimensions;
				}
				bitmapData = this.drawTextLinesRegionToBitmapData(xPosition, yPosition,
					currentBitmapWidth, currentBitmapHeight, bitmapData);
				var newTexture:Texture = null;
				if(this.textSnapshot == null || this._needsNewTexture)
				{
					//skip Texture.fromBitmapData() because we don't want
					//it to create an onRestore function that will be
					//immediately discarded for garbage collection. 
					newTexture = Texture.empty(bitmapData.width / scaleFactor, bitmapData.height / scaleFactor,
						true, false, false, scaleFactor);
					newTexture.root.uploadBitmapData(bitmapData);
				}
				if(snapshotIndex >= 0)
				{
					if(this.textSnapshots == null)
					{
						this.textSnapshots = new Array();
					}
					else if(this.textSnapshots.length > snapshotIndex)
					{
						snapshot = this.textSnapshots[snapshotIndex];
					}
				}
				else
				{
					snapshot = this.textSnapshot;
				}

				if(snapshot == null)
				{
					snapshot = new Image(newTexture);
					this.addChild(snapshot);
				}
				else
				{
					if(this._needsNewTexture)
					{
						snapshot.texture.dispose();
						snapshot.texture = newTexture;
						snapshot.readjustSize();
					}
					else
					{
						//this is faster, if we haven't resized the bitmapdata
						var existingTexture:Texture = snapshot.texture;
						existingTexture.root.uploadBitmapData(bitmapData);
					}
				}
				if(newTexture != null)
				{
					this.createTextureOnRestoreCallback(snapshot);
				}
				if(snapshotIndex >= 0)
				{
					this.textSnapshots[snapshotIndex] = snapshot;
				}
				else
				{
					this.textSnapshot = snapshot;
				}
				snapshot.x = xPosition / scaleFactor;
				snapshot.y = yPosition / scaleFactor;
				if(this._updateSnapshotOnScaleChange)
				{
					snapshot.scaleX = 1 / globalScaleX;
					snapshot.scaleY = 1 / globalScaleY;
					snapshot.x /= globalScaleX;
					snapshot.y /= globalScaleY;
				}
				snapshotIndex++;
				yPosition += currentBitmapHeight;
				totalBitmapHeight -= currentBitmapHeight;
			}
			while (totalBitmapHeight > 0);
			xPosition += currentBitmapWidth;
			totalBitmapWidth -= currentBitmapWidth;
			yPosition = 0;
			totalBitmapHeight = this._snapshotHeight;
		}
		while (totalBitmapWidth > 0);
		bitmapData.dispose();
		if(this.textSnapshots != null)
		{
			var snapshotCount:Int = this.textSnapshots.length;
			for(i in snapshotIndex ... snapshotCount)
			{
				snapshot = this.textSnapshots[i];
				snapshot.texture.dispose();
				snapshot.removeFromParent(true);
			}
			if(snapshotIndex == 0)
			{
				this.textSnapshots = null;
			}
			else
			{
				this.textSnapshots.slice(0, snapshotIndex);
			}
		}
		if(this._updateSnapshotOnScaleChange)
		{
			this._lastGlobalScaleX = globalScaleX;
			this._lastGlobalScaleY = globalScaleY;
		}
		this._needsNewTexture = false;
	}

#if flash
	/**
	 * @private
	 */
	private function refreshTextLines(textLines:Array<TextLine>, textLineParent:DisplayObjectContainer, width:Float, height:Float):Void
	{
		if(this._textElement != null)
		{
			if(this._text != null)
			{
				//this._textElement.text = this._text;
				if(this._text != null && this._text.charAt(this._text.length - 1) == " ")
				{
					//add an invisible control character because FTE apparently
					//doesn't think that it's important to include trailing
					//spaces in its width measurement.
					//this._textElement.text += String.fromCharCode(3);
				}
			}
			else
			{
				//similar to above. this hack ensures that the baseline is
				//measured properly when the text is an empty string.
				//this._textElement.text = String.fromCharCode(3);
			}
		}
		HELPER_TEXT_LINES = [];
		var yPosition:Float = 0;
		var lineCount:Int = textLines.length;
		var lastLine:TextLine = null;
		var cacheIndex:Int = lineCount;
		var i:Int = 0;
		var line:TextLine = null;
		while(i < lineCount)
		{
			line = textLines[i];
			if(line.validity == "valid"/*TextLineValidity.VALID*/)
			{
				lastLine = line;
				textLines[i] = line;
				continue;
			}
			else
			{
				line = lastLine;
				if(lastLine != null)
				{
					yPosition = lastLine.y;
					//we're using this value in the next loop
					lastLine = null;
				}
				cacheIndex = i;
				break;
			}
			i++;
		}
		//copy the invalid text lines over to the helper vector so that we
		//can reuse them
		//for(; i < lineCount; i++)
		while(i < lineCount)
		{
			HELPER_TEXT_LINES[Std.int(i - cacheIndex)] = textLines[i];
			i++;
		}
		textLines = textLines.slice(0, cacheIndex);

		var inactiveTextLineCount:Int;
		if(width >= 0)
		{
			var lineStartIndex:Int = 0;
			var canTruncate:Bool = this._truncateToFit && this._textElement != null && !this._wordWrap;
			var pushIndex:Int = textLines.length;
			inactiveTextLineCount = HELPER_TEXT_LINES.length;
			while(true)
			{
				this._truncationOffset = 0;
				var previousLine:TextLine = line;
				var lineWidth:Float = width;
				if(!this._wordWrap)
				{
					lineWidth = MAX_TEXT_LINE_WIDTH;
				}
				if(inactiveTextLineCount > 0)
				{
					var inactiveLine:TextLine = HELPER_TEXT_LINES[0];
					line = this.textBlock.recreateTextLine(inactiveLine, previousLine, lineWidth, 0, true);
					if(line != null)
					{
						HELPER_TEXT_LINES.shift();
						inactiveTextLineCount--;
					}
				}
				else
				{
					line = this.textBlock.createTextLine(previousLine, lineWidth, 0, true);
					if(line != null)
					{
						textLineParent.addChild(line);
					}
				}
				if(line == null)
				{
					//end of text
					break;
				}
				var lineLength:Int = line.rawTextLength;
				var isTruncated:Bool = false;
				var difference:Float = 0;
				while(canTruncate && (difference = line.width - width) > FUZZY_TRUNCATION_DIFFERENCE)
				{
					isTruncated = true;
					if(this._truncationOffset == 0)
					{
						//this will quickly skip all of the characters after
						//the maximum width of the line, instead of going
						//one by one.
						var endIndex:Int = line.getAtomIndexAtPoint(width, 0);
						if(endIndex >= 0)
						{
							this._truncationOffset = line.rawTextLength - endIndex;
						}
					}
					this._truncationOffset++;
					var truncatedTextLength:Int = lineLength - this._truncationOffset;
					//we want to start at this line so that the previous
					//lines don't become invalid.
					//this._textElement.text = this._text.substr(lineStartIndex, truncatedTextLength) + this._truncationText;
					var lineBreakIndex:Int = this._text.indexOf(LINE_FEED, lineStartIndex);
					if(lineBreakIndex < 0)
					{
						lineBreakIndex = this._text.indexOf(CARRIAGE_RETURN, lineStartIndex);
					}
					if(lineBreakIndex >= 0)
					{
						//this._textElement.text += this._text.substr(lineBreakIndex);
					}
					line = this.textBlock.recreateTextLine(line, null, lineWidth, 0, true);
					if(truncatedTextLength <= 0)
					{
						break;
					}
				}
				if(pushIndex > 0)
				{
					yPosition += this._leading;
				}
				yPosition += line.ascent;
				line.y = yPosition;
				yPosition += line.descent;
				textLines[pushIndex] = line;
				pushIndex++;
				lineStartIndex += lineLength;
			}
		}

		this.alignTextLines(textLines, width, this._textAlign);

		inactiveTextLineCount = HELPER_TEXT_LINES.length;
		//for(i = 0; i < inactiveTextLineCount; i++)
		for(i in 0 ... inactiveTextLineCount)
		{
			line = HELPER_TEXT_LINES[i];
			textLineParent.removeChild(line);
		}
		HELPER_TEXT_LINES = [];
	}

	/**
	 * @private
	 */
	private function alignTextLines(textLines:Array<TextLine>, width:Float, textAlign:String):Void
	{
		var lineCount:Int = textLines.length;
		for(i in 0 ... lineCount)
		{
			var line:TextLine = textLines[i];
			if(textAlign == TEXT_ALIGN_CENTER)
			{
				line.x = (width - line.width) / 2;
			}
			else if(textAlign == TEXT_ALIGN_RIGHT)
			{
				line.x = width - line.width;
			}
			else
			{
				line.x = 0;
			}
		}
	}
#end
}