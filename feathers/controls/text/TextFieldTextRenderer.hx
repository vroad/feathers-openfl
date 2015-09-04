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
import feathers.utils.geom.matrixToScaleX;
import feathers.utils.geom.matrixToScaleY;

import openfl._internal.text.TextEngine;
import openfl.display.BitmapData;
import openfl.display3D.Context3DProfile;
import openfl.filters.BitmapFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
#if flash
import openfl.text.StyleSheet;
#end
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextRenderer;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.utils.PowerOfTwo.getNextPowerOfTwo;

/**
 * Renders text with a native <code>openfl.text.TextField</code> and draws
 * it to <code>BitmapData</code> to convert to Starling textures. Textures
 * are completely managed by this component, and they will be automatically
 * disposed when the component is disposed.
 *
 * <p>For longer passages of text, this component will stitch together
 * multiple individual textures both horizontally and vertically, as a grid,
 * if required. This may require quite a lot of texture memory, possibly
 * exceeding the limits of some mobile devices, so use this component with
 * caution when displaying a lot of text.</p>
 *
 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html openfl.text.TextField
 */
class TextFieldTextRenderer extends FeathersControl implements ITextRenderer
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

	/**
	 * The default <code>IStyleProvider</code> for all <code>TextFieldTextRenderer</code>
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
	 * The TextField instance used to render the text before taking a
	 * texture snapshot.
	 */
	private var textField:TextField;

	/**
	 * An image that displays a snapshot of the native <code>TextField</code>
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
	private var _textSnapshotOffsetX:Float = 0;

	/**
	 * @private
	 */
	private var _textSnapshotOffsetY:Float = 0;

	/**
	 * @private
	 */
	private var _previousActualWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _previousActualHeight:Float = Math.NaN;

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
	private var _hasMeasured:Bool = false;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return TextFieldTextRenderer.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _text:String = "";

	/**
	 * @inheritDoc
	 *
	 * <p>In the following example, the text is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.text = "Lorem ipsum";</listing>
	 *
	 * @default ""
	 *
	 * @see #isHTML
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
		if(value == null)
		{
			//openfl.text.TextField won't accept a null value
			value = "";
		}
		this._text = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._text;
	}

	/**
	 * @private
	 */
	private var _isHTML:Bool = false;

	/**
	 * Determines if the TextField should display the text as HTML or not.
	 *
	 * <p>In the following example, the text is displayed as HTML:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.isHTML = true;
	 * textRenderer.text = "&lt;span class='heading'&gt;hello&lt;/span&gt; world!";</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText openfl.text.TextField.htmlText
	 * @see #text
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
			return this._isHTML;
		}
		this._isHTML = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._isHTML;
	}

	/**
	 * @private
	 */
	private var _textFormat:TextFormat;

	/**
	 * The font and styles used to draw the text.
	 *
	 * <p>In the following example, the text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.textFormat = new TextFormat( "Source Sans Pro" );</listing>
	 *
	 * @default null
	 *
	 * @see #disabledTextFormat
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html openfl.text.TextFormat
	 */
	public var textFormat(get, set):TextFormat;
	@:keep public function get_textFormat():TextFormat
	{
		return this._textFormat;
	}

	/**
	 * @private
	 */
	@:keep public function set_textFormat(value:TextFormat):TextFormat
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
	private var _disabledTextFormat:TextFormat;

	/**
	 * The font and styles used to draw the text when the component is disabled.
	 *
	 * <p>In the following example, the disabled text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.isEnabled = false;
	 * textRenderer.disabledTextFormat = new TextFormat( "Source Sans Pro" );</listing>
	 *
	 * @default null
	 *
	 * @see #textFormat
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html openfl.text.TextFormat
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
			return this._disabledTextFormat;
		}
		this._disabledTextFormat = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._disabledTextFormat;
	}

	/**
	 * @private
	 */
	#if flash
	private var _styleSheet:StyleSheet;
	#end

	/**
	 * The <code>StyleSheet</code> object to pass to the TextField.
	 *
	 * <p>In the following example, a style sheet is applied:</p>
	 *
	 * <listing version="3.0">
	 * var style:StyleSheet = new StyleSheet();
	 * var heading:Dynamic = new Object();
	 * heading.fontWeight = "bold";
	 * heading.color = "#FF0000";
	 *
	 * var body:Dynamic = new Object();
	 * body.fontStyle = "italic";
	 *
	 * style.setStyle(".heading", heading);
	 * style.setStyle("body", body);
	 *
	 * textRenderer.styleSheet = style;
	 * textRenderer.isHTML = true;
	 * textRenderer.text = "&lt;body&gt;&lt;span class='heading'&gt;Hello&lt;/span&gt; World...&lt;/body&gt;";</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#styleSheet Full description of openfl.text.TextField.styleSheet in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StyleSheet.html openfl.text.StyleSheet
	 * @see #isHTML
	 */
	#if flash
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
			return;
		}
		this._styleSheet = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}
	#end

	/**
	 * @private
	 */
	private var _embedFonts:Bool = false;

	/**
	 * Determines if the TextField should use an embedded font or not. If
	 * the specified font is not embedded, the text is not displayed.
	 *
	 * <p>In the following example, the font is embedded:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.embedFonts = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#embedFonts Full description of openfl.text.TextField.embedFonts in Adobe's Flash Platform API Reference
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
			return this._embedFonts;
		}
		this._embedFonts = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._embedFonts;
	}

	/**
	 * @inheritDoc
	 */
	public var baseline(get, never):Float;
	public function get_baseline():Float
	{
		if(this.textField == null)
		{
			return 0;
		}
		var gutterDimensionsOffset:Float = 0;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 2;
		}
		return gutterDimensionsOffset + this.textField.getLineMetrics(0).ascent;
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
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#wordWrap Full description of openfl.text.TextField.wordWrap in Adobe's Flash Platform API Reference
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
		return this._snapToPixels = value;
	}

	/**
	 * @private
	 */
	private var _antiAliasType:AntiAliasType = AntiAliasType.ADVANCED;

	/**
	 * The type of anti-aliasing used for this text field, defined as
	 * constants in the <code>flash.text.AntiAliasType</code> class. You can
	 * control this setting only if the font is embedded (with the
	 * <code>embedFonts</code> property set to true).
	 *
	 * <p>In the following example, the anti-alias type is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.antiAliasType = AntiAliasType.NORMAL;</listing>
	 *
	 * @default openfl.text.AntiAliasType.ADVANCED
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#antiAliasType Full description of openfl.text.TextField.antiAliasType in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/AntiAliasType.html openfl.text.AntiAliasType
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
			return this._antiAliasType;
		}
		this._antiAliasType = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._antiAliasType;
	}

	/**
	 * @private
	 */
	private var _background:Bool = false;

	/**
	 * Specifies whether the text field has a background fill. Use the
	 * <code>backgroundColor</code> property to set the background color of
	 * a text field.
	 *
	 * <p>In the following example, the background is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.background = true;
	 * textRenderer.backgroundColor = 0xff0000;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#background Full description of openfl.text.TextField.background in Adobe's Flash Platform API Reference
	 * @see #backgroundColor
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
			return this._background;
		}
		this._background = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._background;
	}

	/**
	 * @private
	 */
	private var _backgroundColor:UInt = 0xffffff;

	/**
	 * The color of the text field background that is displayed if the
	 * <code>background</code> property is set to <code>true</code>.
	 *
	 * <p>In the following example, the background color is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.background = true;
	 * textRenderer.backgroundColor = 0xff000ff;</listing>
	 *
	 * @default 0xffffff
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#backgroundColor Full description of openfl.text.TextField.backgroundColor in Adobe's Flash Platform API Reference
	 * @see #background
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
			return this._backgroundColor;
		}
		this._backgroundColor = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._backgroundColor;
	}

	/**
	 * @private
	 */
	private var _border:Bool = false;

	/**
	 * Specifies whether the text field has a border. Use the
	 * <code>borderColor</code> property to set the border color.
	 *
	 * <p>Note: this property cannot be used when the <code>useGutter</code>
	 * property is set to <code>false</code> (the default value!).</p>
	 *
	 * <p>In the following example, the border is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.border = true;
	 * textRenderer.borderColor = 0xff0000;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#border Full description of openfl.text.TextField.border in Adobe's Flash Platform API Reference
	 * @see #borderColor
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
			return this._border;
		}
		this._border = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._border;
	}

	/**
	 * @private
	 */
	private var _borderColor:UInt = 0x000000;

	/**
	 * The color of the text field border that is displayed if the
	 * <code>border</code> property is set to <code>true</code>.
	 *
	 * <p>In the following example, the border color is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.border = true;
	 * textRenderer.borderColor = 0xff00ff;</listing>
	 *
	 * @default 0x000000
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#borderColor Full description of openfl.text.TextField.borderColor in Adobe's Flash Platform API Reference
	 * @see #border
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
			return this._borderColor;
		}
		this._borderColor = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._borderColor;
	}

	/**
	 * @private
	 */
	private var _condenseWhite:Bool = false;

	/**
	 * A boolean value that specifies whether extra white space (spaces,
	 * line breaks, and so on) in a text field with HTML text is removed.
	 *
	 * <p>In the following example, whitespace is condensed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.condenseWhite = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#condenseWhite Full description of openfl.text.TextField.condenseWhite in Adobe's Flash Platform API Reference
	 * @see #isHTML
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
			return this._condenseWhite;
		}
		this._condenseWhite = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._condenseWhite;
	}

	/**
	 * @private
	 */
	private var _displayAsPassword:Bool = false;

	/**
	 * Specifies whether the text field is a password text field that hides
	 * the input characters using asterisks instead of the actual
	 * characters.
	 *
	 * <p>In the following example, the text is displayed as a password:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.displayAsPassword = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#displayAsPassword Full description of openfl.text.TextField.displayAsPassword in Adobe's Flash Platform API Reference
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
			return this._displayAsPassword;
		}
		this._displayAsPassword = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._displayAsPassword;
	}

	/**
	 * @private
	 */
	private var _gridFitType:GridFitType = GridFitType.PIXEL;

	/**
	 * Determines whether Flash Player forces strong horizontal and vertical
	 * lines to fit to a pixel or subpixel grid, or not at all using the
	 * constants defined in the <code>openfl.text.GridFitType</code> class.
	 * This property applies only if the <code>antiAliasType</code> property
	 * of the text field is set to <code>openfl.text.AntiAliasType.ADVANCED</code>.
	 *
	 * <p>In the following example, the grid fit type is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.gridFitType = GridFitType.SUBPIXEL;</listing>
	 *
	 * @default openfl.text.GridFitType.PIXEL
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#gridFitType Full description of openfl.text.TextField.gridFitType in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/GridFitType.html openfl.text.GridFitType
	 * @see #antiAliasType
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
			return this._gridFitType;
		}
		this._gridFitType = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._gridFitType;
	}

	/**
	 * @private
	 */
	private var _sharpness:Float = 0;

	/**
	 * The sharpness of the glyph edges in this text field. This property
	 * applies only if the <code>antiAliasType</code> property of the text
	 * field is set to <code>openfl.text.AntiAliasType.ADVANCED</code>. The
	 * range for <code>sharpness</code> is a number from <code>-400</code>
	 * to <code>400</code>.
	 *
	 * <p>In the following example, the sharpness is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.sharpness = 200;</listing>
	 *
	 * @default 0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#sharpness Full description of openfl.text.TextField.sharpness in Adobe's Flash Platform API Reference
	 * @see #antiAliasType
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
			return this._sharpness;
		}
		this._sharpness = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._sharpness;
	}

	/**
	 * @private
	 */
	private var _thickness:Float = 0;

	/**
	 * The thickness of the glyph edges in this text field. This property
	 * applies only if the <code>antiAliasType</code> property is set to
	 * <code>openfl.text.AntiAliasType.ADVANCED</code>. The range for
	 * <code>thickness</code> is a number from <code>-200</code> to
	 * <code>200</code>.
	 *
	 * <p>In the following example, the thickness is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.thickness = 100;</listing>
	 *
	 * @default 0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#thickness Full description of openfl.text.TextField.thickness in Adobe's Flash Platform API Reference
	 * @see #antiAliasType
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
			return this._thickness;
		}
		this._thickness = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._thickness;
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
			return this._maxTextureDimensions;
		}
		this._maxTextureDimensions = value;
		this._needsNewTexture = true;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._maxTextureDimensions;
	}

	/**
	 * @private
	 */
	private var _nativeFilters:Array<BitmapFilter>;

	/**
	 * Native filters to pass to the <code>openfl.text.TextField</code>
	 * before creating the texture snapshot.
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
			return this._nativeFilters;
		}
		this._nativeFilters = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._nativeFilters;
	}

	/**
	 * @private
	 */
	private var _useGutter:Bool = false;

	/**
	 * Determines if the 2-pixel gutter around the edges of the
	 * <code>openfl.text.TextField</code> will be used in measurement and
	 * layout. To visually align with other text renderers and text editors,
	 * it is often best to leave the gutter disabled.
	 *
	 * <p>In the following example, the gutter is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.useGutter = true;</listing>
	 *
	 * @default false
	 */
	public var useGutter(get, set):Bool;
	public function get_useGutter():Bool
	{
		return this._useGutter;
	}

	/**
	 * @private
	 */
	public function set_useGutter(value:Bool):Bool
	{
		if(this._useGutter == value)
		{
			return this._useGutter;
		}
		this._useGutter = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._useGutter;
	}

	/**
	 * @private
	 */
	private var _lastGlobalScaleX:Number = 0;

	/**
	 * @private
	 */
	private var _lastGlobalScaleY:Number = 0;

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
			return;
		}
		this._updateSnapshotOnScaleChange = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _useSnapshotDelayWorkaround:Bool = false;

	/**
	 * Fixes an issue where <code>flash.text.TextField</code> renders
	 * incorrectly when drawn to <code>BitmapData</code> by waiting one
	 * frame.
	 *
	 * <p>Warning: enabling this workaround may cause slight flickering
	 * after the <code>text</code> property is changed.</p>
	 *
	 * <p>In the following example, the workaround is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.useSnapshotDelayWorkaround = true;</listing>
	 *
	 * @default false
	 */
	public function get_useSnapshotDelayWorkaround():Bool
	{
		return this._useSnapshotDelayWorkaround;
	}

	/**
	 * @private
	 */
	public function set_useSnapshotDelayWorkaround(value:Bool):Bool
	{
		if(this._useSnapshotDelayWorkaround == value)
		{
			return;
		}
		this._useSnapshotDelayWorkaround = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
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
		//from being garbage collected, freeing up the text field may help
		//ease major memory pressure from native filters
		this.textField = null;

		this._previousActualWidth = Math.NaN;
		this._previousActualHeight = Math.NaN;

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
				var globalScaleX:Number = matrixToScaleX(HELPER_MATRIX);
				var globalScaleY:Number = matrixToScaleY(HELPER_MATRIX);
				if(globalScaleX != this._lastGlobalScaleX || globalScaleY != this._lastGlobalScaleY)
				{
					//the snapshot needs to be updated because the scale has
					//changed since the last snapshot was taken.
					this.invalidate(INVALIDATION_FLAG_SIZE);
					this.validate();
				}
			}
			var scaleFactor:Number = Starling.current.contentScaleFactor;
			if(!this._nativeFilters || this._nativeFilters.length === 0)
			{
				var offsetX:Number = 0;
				var offsetY:Number = 0;
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
			var totalBitmapWidth:Number = this._snapshotWidth;
			var totalBitmapHeight:Number = this._snapshotHeight;
			var xPosition:Number = offsetX;
			var yPosition:Number = offsetY;
			do
			{
				var currentBitmapWidth:Number = totalBitmapWidth;
				if(currentBitmapWidth > this._maxTextureDimensions)
				{
					currentBitmapWidth = this._maxTextureDimensions;
				}
				do
				{
					var currentBitmapHeight:Number = totalBitmapHeight;
					if(currentBitmapHeight > this._maxTextureDimensions)
					{
						currentBitmapHeight = this._maxTextureDimensions;
					}
					if(snapshotIndex < 0)
					{
						var snapshot:Image = this.textSnapshot;
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
				while(totalBitmapHeight > 0)
				xPosition += currentBitmapWidth;
				totalBitmapWidth -= currentBitmapWidth;
				yPosition = offsetY;
				totalBitmapHeight = this._snapshotHeight;
			}
			while(totalBitmapWidth > 0)
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
		if(this.textField == null)
		{
			this.textField = new TextField();
			var scaleFactor:Float = Starling.current.contentScaleFactor;
			this.textField.scaleX = scaleFactor;
			this.textField.scaleY = scaleFactor;
			#if flash
			this.textField.mouseEnabled = this.textField.mouseWheelEnabled = false;
			#else
			this.textField.mouseEnabled = false;
			#end
			this.textField.selectable = false;
			this.textField.multiline = true;
		}
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);

		this.commit();

		this._hasMeasured = false;
		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layout(sizeInvalid);
	}

	/**
	 * @private
	 */
	private function commit():Void
	{
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);

		if(stylesInvalid)
		{
			this.textField.antiAliasType = this._antiAliasType;
			this.textField.background = this._background;
			this.textField.backgroundColor = this._backgroundColor;
			this.textField.border = this._border;
			this.textField.borderColor = this._borderColor;
			#if flash
			this.textField.condenseWhite = this._condenseWhite;
			#end
			this.textField.displayAsPassword = this._displayAsPassword;
			this.textField.gridFitType = this._gridFitType;
			this.textField.sharpness = this._sharpness;
			#if flash
			this.textField.thickness = this._thickness;
			#end
			this.textField.filters = this._nativeFilters;
		}

		if(dataInvalid || stylesInvalid || stateInvalid)
		{
			this.textField.wordWrap = this._wordWrap;
			this.textField.embedFonts = this._embedFonts;
			#if flash
			if(this._styleSheet)
			{
				this.textField.styleSheet = this._styleSheet;
			}
			else
			#end
			{
				#if flash
				this.textField.styleSheet = null;
				#end
				if(!this._isEnabled && this._disabledTextFormat != null)
				{
					this.textField.defaultTextFormat = this._disabledTextFormat;
				}
				else if(this._textFormat != null)
				{
					this.textField.defaultTextFormat = this._textFormat;
				}
			}
			if(this._isHTML)
			{
				this.textField.htmlText = this._text;
			}
			else
			{
				this.textField.text = this._text;
			}
		}
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

		this.textField.autoSize = TextFieldAutoSize.LEFT;
		this.textField.wordWrap = false;

		var scaleFactor:Float = Starling.current.contentScaleFactor;
		var gutterDimensionsOffset:Float = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}

		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			//yes, this value is never used. this is a workaround for a bug
			//in AIR for iOS where getting the value for textField.width the
			//first time results in an incorrect value, but if you query it
			//again, for some reason, it reports the correct width value.
			#if flash
			var hackWorkaround:Float = this.textField.width;
			#end
			var textWidth:Float = #if flash this.textField.width #else this.textField.textWidth + 4 #end;
			newWidth = (textWidth / scaleFactor) - gutterDimensionsOffset;
			if(newWidth < this._minWidth)
			{
				newWidth = this._minWidth;
			}
			else if(newWidth > this._maxWidth)
			{
				newWidth = this._maxWidth;
			}
		}
		//and this is a workaround for an issue where openfl.text.TextField
		//will wrap the last word when you pass the value returned by the
		//width getter (when TextFieldAutoSize.LEFT is used) to the width
		//setter. In other words, the value technically isn't changing, but
		//TextField behaves differently.
		if(!needsWidth || ((this.textField.width / scaleFactor) - gutterDimensionsOffset) > newWidth)
		{
			this.textField.width = newWidth + gutterDimensionsOffset;
			this.textField.wordWrap = this._wordWrap;
		}
		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			var textHeight:Float = #if flash this.textField.height #else this.textField.textHeight + 4 #end;
			newHeight = (textHeight / scaleFactor) - gutterDimensionsOffset;
			if(newHeight < this._minHeight)
			{
				newHeight = this._minHeight;
			}
			else if(newHeight > this._maxHeight)
			{
				newHeight = this._maxHeight;
			}
		}

		this.textField.autoSize = TextFieldAutoSize.NONE;

		//put the width and height back just in case we measured without
		//a full validation
		this.textField.width = this.actualWidth + gutterDimensionsOffset;
		this.textField.height = this.actualHeight + gutterDimensionsOffset;

		result.x = newWidth;
		result.y = newHeight;

		this._hasMeasured = true;
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

		var scaleFactor:Float = Starling.current.contentScaleFactor;
		var gutterDimensionsOffset:Float = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}

		//if measure() isn't called, we need to apply the same workaround
		//for the openfl.text.TextField bug with wordWrap.
		if(!this._hasMeasured && this._wordWrap)
		{
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.textField.wordWrap = false;
			if(((this.textField.width / scaleFactor) - gutterDimensionsOffset) > this.actualWidth)
			{
				this.textField.wordWrap = true;
			}
			this.textField.autoSize = TextFieldAutoSize.NONE;
			this.textField.width = this.actualWidth + gutterDimensionsOffset;
		}
		if(sizeInvalid)
		{
			this.textField.width = this.actualWidth + gutterDimensionsOffset;
			this.textField.height = this.actualHeight + gutterDimensionsOffset;
			//these are getting put into an int later, so we don't want it
			//to possibly round down and cut off part of the text. 
			var rectangleSnapshotWidth:Number = Math.ceil(this.actualWidth * scaleFactor);
			var rectangleSnapshotHeight:Number = Math.ceil(this.actualHeight * scaleFactor);
			if(this._updateSnapshotOnScaleChange)
			{
				this.getTransformationMatrix(this.stage, HELPER_MATRIX);
				rectangleSnapshotWidth *= matrixToScaleX(HELPER_MATRIX);
				rectangleSnapshotHeight *= matrixToScaleY(HELPER_MATRIX);
			}
			if(rectangleSnapshotWidth >= 1 && rectangleSnapshotHeight >= 1 &&
				this._nativeFilters && this._nativeFilters.length > 0)
			{
				HELPER_MATRIX.identity();
				HELPER_MATRIX.scale(scaleFactor, scaleFactor);
				var bitmapData:BitmapData = new BitmapData(rectangleSnapshotWidth, rectangleSnapshotHeight, true, 0x00ff00ff);
				bitmapData.draw(this.textField, HELPER_MATRIX, null, null, HELPER_RECTANGLE);
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
					this._snapshotWidth = Std.Int(Std.Int(rectangleSnapshotWidth / this._maxTextureDimensions) * this._maxTextureDimensions + (rectangleSnapshotWidth % this._maxTextureDimensions));
				}
				else
				{
					this._snapshotWidth = Std.Int(rectangleSnapshotWidth);
				}
			}
			else
			{
				if(rectangleSnapshotWidth > this._maxTextureDimensions)
				{
					this._snapshotWidth = Std.Int(rectangleSnapshotWidth / this._maxTextureDimensions) * this._maxTextureDimensions + getNextPowerOfTwo(Std.Int(rectangleSnapshotWidth % this._maxTextureDimensions));
				}
				else
				{
					this._snapshotWidth = getNextPowerOfTwo(Std.Int(rectangleSnapshotWidth));
				}
			}
			if(canUseRectangleTexture)
			{
				if(rectangleSnapshotHeight > this._maxTextureDimensions)
				{
					this._snapshotHeight = Std.Int(Std.Int(rectangleSnapshotHeight / this._maxTextureDimensions) * this._maxTextureDimensions + (rectangleSnapshotHeight % this._maxTextureDimensions));
				}
				else
				{
					this._snapshotHeight = Std.Int(rectangleSnapshotHeight);
				}
			}
			else
			{
				if(rectangleSnapshotHeight > this._maxTextureDimensions)
				{
					this._snapshotHeight = Std.Int(rectangleSnapshotHeight / this._maxTextureDimensions) * this._maxTextureDimensions + getNextPowerOfTwo(Std.Int(rectangleSnapshotHeight % this._maxTextureDimensions));
				}
				else
				{
					this._snapshotHeight = getNextPowerOfTwo(Std.Int(rectangleSnapshotHeight));
				}
			}
			var textureRoot:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
			this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || this._snapshotWidth != textureRoot.width || this._snapshotHeight != textureRoot.height;
			this._snapshotVisibleWidth = rectangleSnapshotWidth;
			this._snapshotVisibleHeight = rectangleSnapshotHeight;
		}

		//instead of checking sizeInvalid, which will often be triggered by
		//changing maxWidth or something for measurement, we check against
		//the previous actualWidth/Height used for the snapshot.
		if(stylesInvalid || dataInvalid || stateInvalid || this._needsNewTexture ||
			this.actualWidth != this._previousActualWidth ||
			this.actualHeight != this._previousActualHeight)
		{
			this._previousActualWidth = this.actualWidth;
			this._previousActualHeight = this.actualHeight;
			var hasText:Bool = this._text.length > 0;
			if(hasText)
			{
				if(this._useSnapshotDelayWorkaround)
				{
					//we need to wait a frame for the TextField to render
					//properly. sometimes two, and this is a known issue.
					this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
				else
				{
					this.refreshSnapshot();
				}
			}
			if(this.textSnapshot != null)
			{
				this.textSnapshot.visible = hasText && this._snapshotWidth > 0 && this._snapshotHeight > 0;
			}
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
		var self:TextFieldTextRenderer = this;
		var texture:Texture = snapshot.texture;
		texture.root.onRestore = function():Void
		{
			var scaleFactor:Number = Starling.contentScaleFactor;
			HELPER_MATRIX.identity();
			HELPER_MATRIX.scale(scaleFactor, scaleFactor);
			var bitmapData:BitmapData = self.drawTextFieldRegionToBitmapData(
				snapshot.x, snapshot.y, texture.nativeWidth, texture.nativeHeight);
			texture.root.uploadBitmapData(bitmapData);
			bitmapData.dispose();
		};
	}

	/**
	 * @private
	 */
	private function drawTextFieldRegionToBitmapData(textFieldX:Number, textFieldY:Number,
		bitmapWidth:Number, bitmapHeight:Number, bitmapData:BitmapData = null):BitmapData
	{
		var scaleFactor:Number = Starling.contentScaleFactor;
		var clipWidth:Number = this._snapshotVisibleWidth - textFieldX;
		var clipHeight:Number = this._snapshotVisibleHeight - textFieldY;
		if(!bitmapData || bitmapData.width != bitmapWidth || bitmapData.height != bitmapHeight)
		{
			if(bitmapData)
			{
				bitmapData.dispose();
			}
			bitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0x00ff00ff);
		}
		else
		{
			//clear the bitmap data and reuse it
			bitmapData.fillRect(bitmapData.rect, 0x00ff00ff);
		}
		var gutterPositionOffset:Number = 2 * scaleFactor;
		if(this._useGutter)
		{
			gutterPositionOffset = 0;
		}
		HELPER_MATRIX.tx = -(textFieldX + gutterPositionOffset) - this._textSnapshotOffsetX;
		HELPER_MATRIX.ty = -(textFieldY + gutterPositionOffset) - this._textSnapshotOffsetY;
		HELPER_RECTANGLE.setTo(0, 0, clipWidth, clipHeight);
		bitmapData.draw(this.textField, HELPER_MATRIX, null, null, HELPER_RECTANGLE);
		return bitmapData;
	}

	/**
	 * @private
	 */
	private function refreshSnapshot():Void
	{
		if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
		{
			return;
		}
		var scaleFactor:Number = Starling.contentScaleFactor;
		if(this._updateSnapshotOnScaleChange)
		{
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			var globalScaleX:Number = matrixToScaleX(HELPER_MATRIX);
			var globalScaleY:Number = matrixToScaleY(HELPER_MATRIX);
		}
		HELPER_MATRIX.identity();
		HELPER_MATRIX.scale(scaleFactor, scaleFactor);
		if(this._updateSnapshotOnScaleChange)
		{
			HELPER_MATRIX.scale(globalScaleX, globalScaleY);
		}
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
				bitmapData = this.drawTextFieldRegionToBitmapData(xPosition, yPosition, currentBitmapWidth, currentBitmapHeight, bitmapData);
				#else
				this._textSnapshotOffsetX = 0;
				this._textSnapshotOffsetY = 0;
				#end
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
				var snapshot:Image = null;
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
						#if ((js && html5) || flash)
						var existingTexture:Texture = snapshot.texture;
						existingTexture.root.uploadBitmapData(bitmapData);
						#end
					}
				}
				if(newTexture)
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
			while(totalBitmapHeight > 0);
			xPosition += currentBitmapWidth;
			totalBitmapWidth -= currentBitmapWidth;
			yPosition = 0;
			totalBitmapHeight = this._snapshotHeight;
		}
		while(totalBitmapWidth > 0);
		#if ((js && html5) || flash)
		bitmapData.dispose();
		#end
		if(this.textSnapshots != null)
		{
			var snapshotCount:Int = this.textSnapshots.length;
			for(i in snapshotIndex ... snapshotCount)
			{
				var snapshot:Image = this.textSnapshots[i];
				snapshot.texture.dispose();
				snapshot.removeFromParent(true);
			}
			if(snapshotIndex == 0)
			{
				this.textSnapshots = null;
			}
			else
			{
				//this.textSnapshots.length = snapshotIndex;
				this.textSnapshots.splice(snapshotIndex, this.textSnapshots.length - snapshotIndex);
			}
		}
		if(this._updateSnapshotOnScaleChange)
		{
			this._lastGlobalScaleX = globalScaleX;
			this._lastGlobalScaleY = globalScaleY;
		}
		this._needsNewTexture = false;
	}

	/**
	 * @private
	 */
	private function enterFrameHandler(event:Event):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		this.refreshSnapshot();
	}
}
