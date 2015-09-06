/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.supportClasses.TextFieldViewPort;
import feathers.skins.IStyleProvider;

import flash.text.AntiAliasType;
import flash.text.GridFitType;
#if flash
import flash.text.StyleSheet;
#end
import flash.text.TextFormat;

import starling.events.Event;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SCROLL;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;

/**
 * Dispatched when an anchor (<code>&lt;a&gt;</code>) element in the HTML
 * text is triggered when the <code>href</code> attribute begins with
 * <code>"event:"</code>. This event is dispatched when the internal
 * <code>openfl.text.TextField</code> dispatches its own
 * <code>TextEvent.LINK</code>.
 *
 * <p>The <code>data</code> property of the <code>Event</code> object that
 * is dispatched by the <code>ScrollText</code> contains the value of the
 * <code>text</code> property of the <code>TextEvent</code> that is
 * dispatched by the <code>openfl.text.TextField</code>.</p>
 *
 * <p>The following example listens for <code>Event.TRIGGERED</code> on a
 * <code>ScrollText</code> component:</p>
 *
 * <listing version="3.0">
 * var scrollText:ScrollText = new ScrollText();
 * scrollText.text = "&lt;a href=\"event:hello\"&gt;Hello&lt;/a&gt; World";
 * scrollText.addEventListener( Event.TRIGGERED, scrollText_triggeredHandler );
 * this.addChild( scrollText );</listing>
 *
 * <p>The following example shows a listener for <code>Event.TRIGGERED</code>:</p>
 *
 * <listing version="3.0">
 * function scrollText_triggeredHandler(event:Event):Void
 * {
 *     trace( event.data ); //hello
 * }</listing>
 *
 * @eventType starling.events.Event.TRIGGERED
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/TextEvent.html#LINK openfl.events.TextEvent.LINK
 *///[Event(name="triggered",type="starling.events.Event")]

/**
 * Displays long passages of text in a scrollable container using the
 * runtime's software-based <code>openfl.text.TextField</code> as an overlay
 * above Starling content on the classic display list. This component will
 * <strong>always</strong> appear above Starling content. The only way to
 * put something above ScrollText is to put something above it on the
 * classic display list.
 *
 * <p>Meant as a workaround component for when TextFieldTextRenderer runs
 * into the runtime texture limits.</p>
 *
 * <p>Since this component is rendered with the runtime's software renderer,
 * rather than on the GPU, it may not perform very well on mobile devices
 * with high resolution screens.</p>
 *
 * <p>The following example displays some text:</p>
 *
 * <listing version="3.0">
 * var scrollText:ScrollText = new ScrollText();
 * scrollText.text = "Hello World";
 * this.addChild( scrollText );</listing>
 *
 * @see ../../../help/scroll-text.html How to use the Feathers ScrollText component
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html openfl.text.TextField
 */
class ScrollText extends Scroller
{
	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_AUTO:String = "auto";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_ON:String = "on";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_OFF:String = "off";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT:String = "fixedFloat";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

	/**
	 * The vertical scroll bar will be positioned on the right.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

	/**
	 * The vertical scroll bar will be positioned on the left.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH:String = "touch";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_MOUSE:String = "mouse";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

	/**
	 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

	/**
	 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_NORMAL:Float = 0.998;

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_FAST:Float = 0.99;

	/**
	 * The default <code>IStyleProvider</code> for all <code>ScrollText</code>
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
		this.textViewPort = new TextFieldViewPort();
		this.textViewPort.addEventListener(Event.TRIGGERED, textViewPort_triggeredHandler);
		this.viewPort = this.textViewPort;
	}

	/**
	 * @private
	 */
	private var textViewPort:TextFieldViewPort;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ScrollText.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _text:String = "";

	/**
	 * The text to display. If <code>isHTML</code> is <code>true</code>, the
	 * text will be rendered as HTML with the same capabilities as the
	 * <code>htmlText</code> property of <code>openfl.text.TextField</code>.
	 *
	 * <p>In the following example, some text is displayed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.text = "Hello World";</listing>
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
	 * Determines if the TextField should display the text as HTML or not.
	 *
	 * <p>In the following example, some HTML-formatted text is displayed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.isHTML = true;
	 * scrollText.text = "&lt;b&gt;Hello&lt;/b&gt; &lt;i&gt;World&lt;/i&gt;";</listing>
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
	 * The font and styles used to draw the text.
	 *
	 * <p>In the following example, the text is formatted:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.textFormat = new TextFormat( "_sans", 16, 0x333333 );</listing>
	 *
	 * @default null
	 *
	 * @see #disabledTextFormat
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html openfl.text.TextFormat
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
	 * The font and styles used to draw the text when the component is disabled.
	 *
	 * <p>In the following example, the disabled text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.isEnabled = false;
	 * textRenderer.disabledTextFormat = new TextFormat( "_sans", 16, 0xcccccc );</listing>
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
	 * scrollText.styleSheet = style;
	 * scrollText.isHTML = true;
	 * scrollText.text = "&lt;body&gt;&lt;span class='heading'&gt;Hello&lt;/span&gt; World...&lt;/body&gt;";</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#styleSheet Full description of openfl.text.TextField.styleSheet in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StyleSheet.html openfl.text.StyleSheet
	 * @see #isHTML
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
	 * Determines if the TextField should use an embedded font or not. If
	 * the specified font is not embedded, the text is not displayed.
	 *
	 * <p>In the following example, some text is formatted with an embedded
	 * font:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333;
	 * scrollText.embedFonts = true;</listing>
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
	 * The type of anti-aliasing used for this text field, defined as
	 * constants in the <code>openfl.text.AntiAliasType</code> class.
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
	 * Specifies whether the text field has a background fill. Use the
	 * <code>backgroundColor</code> property to set the background color of
	 * a text field.
	 *
	 * <p>In the following example, the background is enabled:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.background = true;
	 * scrollText.backgroundColor = 0xff0000;</listing>
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
	 * The color of the text field background that is displayed if the
	 * <code>background</code> property is set to <code>true</code>.
	 *
	 * <p>In the following example, the background color is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.background = true;
	 * scrollText.backgroundColor = 0xff000ff;</listing>
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
	 * Specifies whether the text field has a border. Use the
	 * <code>borderColor</code> property to set the border color.
	 *
	 * <p>In the following example, the border is enabled:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.border = true;
	 * scrollText.borderColor = 0xff0000;</listing>
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
	 * The color of the text field border that is displayed if the
	 * <code>border</code> property is set to <code>true</code>.
	 *
	 * <p>In the following example, the border color is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.border = true;
	 * scrollText.borderColor = 0xff00ff;</listing>
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
	 * If set to <code>true</code>, an internal bitmap representation of the
	 * <code>TextField</code> on the classic display list is cached by the
	 * runtime. This caching can increase performance.
	 *
	 * <p>In the following example, bitmap caching is disabled:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.cacheAsBitmap = false;</listing>
	 *
	 * @default true
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#cacheAsBitmap Full description of flash.display.DisplayObject.cacheAsBitmap in Adobe's Flash Platform API Reference
	 */
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
	 * A boolean value that specifies whether extra white space (spaces,
	 * line breaks, and so on) in a text field with HTML text is removed.
	 *
	 * <p>In the following example, whitespace is condensed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.condenseWhite = true;</listing>
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
	 * Specifies whether the text field is a password text field that hides
	 * the input characters using asterisks instead of the actual
	 * characters.
	 *
	 * <p>In the following example, the text is displayed as a password:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.displayAsPassword = true;</listing>
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
	 * Determines whether Flash Player forces strong horizontal and vertical
	 * lines to fit to a pixel or subpixel grid, or not at all using the
	 * constants defined in the <code>openfl.text.GridFitType</code> class.
	 * This property applies only if the <code>antiAliasType</code> property
	 * of the text field is set to <code>openfl.text.AntiAliasType.ADVANCED</code>.
	 *
	 * <p>In the following example, the grid fit type is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.gridFitType = GridFitType.SUBPIXEL;</listing>
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
	 * The sharpness of the glyph edges in this text field. This property
	 * applies only if the <code>antiAliasType</code> property of the text
	 * field is set to <code>openfl.text.AntiAliasType.ADVANCED</code>. The
	 * range for <code>sharpness</code> is a number from <code>-400</code>
	 * to <code>400</code>.
	 *
	 * <p>In the following example, the sharpness is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.sharpness = 200;</listing>
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
	 * The thickness of the glyph edges in this text field. This property
	 * applies only if the <code>antiAliasType</code> property is set to
	 * <code>openfl.text.AntiAliasType.ADVANCED</code>. The range for
	 * <code>thickness</code> is a number from <code>-200</code> to
	 * <code>200</code>.
	 *
	 * <p>In the following example, the thickness is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.thickness = 100;</listing>
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
			return get_thickness();
		}
		this._thickness = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_thickness();
	}

	/**
	 * @private
	 */
	override public function get_padding():Float
	{
		return this._textPaddingTop;
	}

	//no setter for padding because the one in Scroller is acceptable

	/**
	 * @private
	 */
	private var _textPaddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the component's top edge and
	 * the top edge of the text.
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.paddingTop = 20;</listing>
	 *
	 * @default 0
	 */
	override public function get_paddingTop():Float
	{
		return this._textPaddingTop;
	}

	/**
	 * @private
	 */
	override public function set_paddingTop(value:Float):Float
	{
		if(this._textPaddingTop == value)
		{
			return get_paddingTop();
		}
		this._textPaddingTop = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	/**
	 * @private
	 */
	private var _textPaddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the component's right edge and
	 * the right edge of the text.
	 *
	 * <p>In the following example, the right padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.paddingRight = 20;</listing>
	 */
	override public function get_paddingRight():Float
	{
		return this._textPaddingRight;
	}

	/**
	 * @private
	 */
	override public function set_paddingRight(value:Float):Float
	{
		if(this._textPaddingRight == value)
		{
			return get_paddingRight();
		}
		this._textPaddingRight = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	/**
	 * @private
	 */
	private var _textPaddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the component's bottom edge and
	 * the bottom edge of the text.
	 *
	 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.paddingBottom = 20;</listing>
	 */
	override public function get_paddingBottom():Float
	{
		return this._textPaddingBottom;
	}

	/**
	 * @private
	 */
	override public function set_paddingBottom(value:Float):Float
	{
		if(this._textPaddingBottom == value)
		{
			return get_paddingBottom();
		}
		this._textPaddingBottom = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	/**
	 * @private
	 */
	private var _textPaddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the component's left edge and
	 * the left edge of the text.
	 *
	 * <p>In the following example, the left padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.paddingLeft = 20;</listing>
	 */
	override public function get_paddingLeft():Float
	{
		return this._textPaddingLeft;
	}

	/**
	 * @private
	 */
	override public function set_paddingLeft(value:Float):Float
	{
		if(this._textPaddingLeft == value)
		{
			return get_paddingLeft();
		}
		this._textPaddingLeft = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
	}

	/**
	 * @private
	 */
	private var _visible:Bool = true;

	/**
	 * @private
	 */
	override public function get_visible():Bool
	{
		return this._visible;
	}

	/**
	 * @private
	 */
	override public function set_visible(value:Bool):Bool
	{
		if(this._visible == value)
		{
			return get_visible();
		}
		this._visible = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_visible();
	}

	/**
	 * @private
	 */
	private var _alpha:Float = 1;

	/**
	 * @private
	 */
	override public function get_alpha():Float
	{
		return this._alpha;
	}

	/**
	 * @private
	 */
	override public function set_alpha(value:Float):Float
	{
		if(this._alpha == value)
		{
			return get_alpha();
		}
		this._alpha = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		return get_alpha();
	}

	/**
	 * @private
	 */
	override public function get_hasVisibleArea():Bool
	{
		return true;
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var scrollInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SCROLL);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);

		if(dataInvalid)
		{
			this.textViewPort.text = this._text;
			this.textViewPort.isHTML = this._isHTML;
		}

		if(stylesInvalid)
		{
			this.textViewPort.antiAliasType = this._antiAliasType;
			this.textViewPort.background = this._background;
			this.textViewPort.backgroundColor = this._backgroundColor;
			this.textViewPort.border = this._border;
			this.textViewPort.borderColor = this._borderColor;
			this.textViewPort.cacheAsBitmap = this._cacheAsBitmap;
			this.textViewPort.condenseWhite = this._condenseWhite;
			this.textViewPort.displayAsPassword = this._displayAsPassword;
			this.textViewPort.gridFitType = this._gridFitType;
			this.textViewPort.sharpness = this._sharpness;
			this.textViewPort.thickness = this._thickness;
			this.textViewPort.textFormat = this._textFormat;
			this.textViewPort.disabledTextFormat = this._disabledTextFormat;
			#if flash
			this.textViewPort.styleSheet = this._styleSheet;
			#end
			this.textViewPort.embedFonts = this._embedFonts;
			this.textViewPort.paddingTop = this._textPaddingTop;
			this.textViewPort.paddingRight = this._textPaddingRight;
			this.textViewPort.paddingBottom = this._textPaddingBottom;
			this.textViewPort.paddingLeft = this._textPaddingLeft;
			this.textViewPort.visible = this._visible;
			this.textViewPort.alpha = this._alpha;
		}

		super.draw();
	}

	/**
	 * @private
	 */
	private function textViewPort_triggeredHandler(event:Event, link:String):Void
	{
		this.dispatchEventWith(Event.TRIGGERED, false, link);
	}
}
