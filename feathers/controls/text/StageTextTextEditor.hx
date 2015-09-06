/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text;
import feathers.core.FeathersControl;
import feathers.core.IMultilineTextEditor;
import feathers.events.FeathersEventType;
import feathers.text.StageTextField;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleX;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleY;
import openfl.errors.Error;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
#if flash
import flash.events.SoftKeyboardEvent;
#end
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
#if falsh
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
#end
import flash.ui.Keyboard;
#if 0
import flash.utils.getDefinitionByName;
#end

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.Event;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.SystemUtil;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SKIN;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STATE;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;

/**
 * Dispatched when the text property changes.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 */
///[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when the user presses the Enter key while the editor has
 * focus. This event may not be dispatched on some platforms, depending on
 * the value of <code>returnKeyLabel</code>. This issue may even occur when
 * using the <em>default value</em> of <code>returnKeyLabel</code>!
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.ENTER
 * @see #returnKeyLabel
 */
///[Event(name="enter",type="starling.events.Event")]

/**
 * Dispatched when the text editor receives focus.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.FOCUS_IN
 */
///[Event(name="focusIn",type="starling.events.Event")]

/**
 * Dispatched when the text editor loses focus.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
 */
///[Event(name="focusOut",type="starling.events.Event")]

/**
 * Dispatched when the soft keyboard is activated. Not all text editors will
 * activate a soft keyboard.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_ACTIVATE
 */
///[Event(name="softKeyboardActivate",type="starling.events.Event")]

/**
 * Dispatched when the soft keyboard is deactivated. Not all text editors
 * will activate a soft keyboard.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_DEACTIVATE
 */
///[Event(name="softKeyboardDeactivate",type="starling.events.Event")]

/**
 * A Feathers text editor that uses the native <code>openfl.text.StageText</code>
 * class in Adobe AIR, and the custom <code>feathers.text.StageTextField</code>
 * class (that simulates <code>StageText</code> using
 * <code>openfl.text.TextField</code>) in Adobe Flash Player.
 *
 * <p>Note: Due to quirks with how the runtime manages focus with
 * <code>StageText</code>, <code>StageTextTextEditor</code> is not
 * compatible with the Feathers <code>FocusManager</code>.</p>
 *
 * @see ../../../help/text-editors.html Introduction to Feathers text editors
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html openfl.text.StageText
 * @see feathers.text.StageTextField
 */
class StageTextTextEditor extends FeathersControl implements IMultilineTextEditor
{
	/**
	 * @private
	 */
	private static var HELPER_MATRIX3D:Matrix3D;
	
	/**
	 * @private
	 */
	private static var HELPER_POINT3D:Vector3D;
	
	/**
	 * @private
	 */
	private static var HELPER_MATRIX:Matrix = new Matrix();

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		// TODO: Check OS
		//this._stageTextIsTextField = ~/^(Windows|Mac OS|Linux) .*/.match(Capabilities.os);
		this._stageTextIsTextField = true;
		this.isQuickHitAreaEnabled = true;
		this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, textEditor_removedFromStageHandler);
	}

	/**
	 * The StageText instance. It's typed Object so that a replacement class
	 * can be used in browser-based Flash Player.
	 */
	private var stageText:Dynamic;

	/**
	 * An image that displays a snapshot of the native <code>StageText</code>
	 * in the Starling display list when the editor doesn't have focus.
	 */
	private var textSnapshot:Image;

	/**
	 * @private
	 */
	private var _needsNewTexture:Bool = false;

	/**
	 * @private
	 */
	private var _ignoreStageTextChanges:Bool = false;

	/**
	 * @private
	 */
	private var _text:String = "";

	/**
	 * The text displayed by the input.
	 *
	 * <p>In the following example, the text is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.text = "Lorem ipsum";</listing>
	 *
	 * @default ""
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
			//don't allow null or undefined
			value = "";
		}
		if(this._text == value)
		{
			return this._text;
		}
		this._text = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		this.dispatchEventWith(starling.events.Event.CHANGE);
		return this._text;
	}

	/**
	 * @private
	 */
	private var _measureTextField:TextField;

	/**
	 * @private
	 * This flag tells us if StageText is implemented by a TextField under
	 * the hood. We want to eliminate that damn TextField gutter to improve
	 * consistency across platforms.
	 */
	private var _stageTextIsTextField:Bool = false;

	/**
	 * @private
	 */
	private var _stageTextHasFocus:Bool = false;

	/**
	 * @private
	 */
	private var _isWaitingToSetFocus:Bool = false;

	/**
	 * @private
	 */
	private var _pendingSelectionBeginIndex:Int = -1;

	/**
	 * @inheritDoc
	 */
	public var selectionBeginIndex(get, never):Int;
	public function get_selectionBeginIndex():Int
	{
		if(this._pendingSelectionBeginIndex >= 0)
		{
			return this._pendingSelectionBeginIndex;
		}
		if(this.stageText != null)
		{
			return this.stageText.selectionAnchorIndex;
		}
		return 0;
	}

	/**
	 * @private
	 */
	private var _pendingSelectionEndIndex:Int = -1;

	/**
	 * @inheritDoc
	 */
	public var selectionEndIndex(get, never):Int;
	public function get_selectionEndIndex():Int
	{
		if(this._pendingSelectionEndIndex >= 0)
		{
			return this._pendingSelectionEndIndex;
		}
		if(this.stageText != null)
		{
			return this.stageText.selectionActiveIndex;
		}
		return 0;
	}

	/**
	 * @private
	 */
	private var _stageTextIsComplete:Bool = false;

	/**
	 * @inheritDoc
	 */
	public var baseline(get, never):Float;
	public function get_baseline():Float
	{
		if(this._measureTextField == null)
		{
			return 0;
		}
		return this._measureTextField.getLineMetrics(0).ascent;
	}

	/**
	 * @private
	 */
	private var _autoCapitalize:String = "none";

	/**
	 * Controls how a device applies auto capitalization to user input. This
	 * property is only a hint to the underlying platform, because not all
	 * devices and operating systems support this functionality.
	 *
	 * <p>In the following example, the auto capitalize behavior is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.autoCapitalize = AutoCapitalize.WORD;</listing>
	 *
	 * @default openfl.text.AutoCapitalize.NONE
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#autoCapitalize Full description of openfl.text.StageText.autoCapitalize in Adobe's Flash Platform API Reference
	 */
	public var autoCapitalize(get, set):String;
	public function get_autoCapitalize():String
	{
		return this._autoCapitalize;
	}

	/**
	 * @private
	 */
	public function set_autoCapitalize(value:String):String
	{
		if(this._autoCapitalize == value)
		{
			return this._autoCapitalize;
		}
		this._autoCapitalize = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._autoCapitalize;
	}

	/**
	 * @private
	 */
	private var _autoCorrect:Bool = false;

	/**
	 * Indicates whether a device auto-corrects user input for spelling or
	 * punctuation mistakes. This property is only a hint to the underlying
	 * platform, because not all devices and operating systems support this
	 * functionality.
	 *
	 * <p>In the following example, auto correct is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.autoCorrect = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#autoCorrect Full description of openfl.text.StageText.autoCorrect in Adobe's Flash Platform API Reference
	 */
	public var autoCorrect(get, set):Bool;
	public function get_autoCorrect():Bool
	{
		return this._autoCorrect;
	}

	/**
	 * @private
	 */
	public function set_autoCorrect(value:Bool):Bool
	{
		if(this._autoCorrect == value)
		{
			return this._autoCorrect;
		}
		this._autoCorrect = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._autoCorrect;
	}

	/**
	 * @private
	 */
	private var _color:UInt = 0x000000;

	/**
	 * Specifies text color as a number containing three 8-bit RGB
	 * components.
	 *
	 * <p>In the following example, the text color is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.color = 0xff9900;</listing>
	 *
	 * @default 0x000000
	 *
	 * @see #disabledColor
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#color Full description of openfl.text.StageText.color in Adobe's Flash Platform API Reference
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._color;
	}

	/**
	 * @private
	 */
	private var _disabledColor:UInt = 0x999999;

	/**
	 * Specifies text color when the component is disabled as a number
	 * containing three 8-bit RGB components.
	 *
	 * <p>In the following example, the text color is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.isEnabled = false;
	 * textEditor.disabledColor = 0xff9900;</listing>
	 *
	 * @default 0x999999
	 *
	 * @see #disabledColor
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#color Full description of openfl.text.StageText.color in Adobe's Flash Platform API Reference
	 */
	public var disabledColor(get, set):UInt;
	public function get_disabledColor():UInt
	{
		return this._disabledColor;
	}

	/**
	 * @private
	 */
	public function set_disabledColor(value:UInt):UInt
	{
		if(this._disabledColor == value)
		{
			return this._disabledColor;
		}
		this._disabledColor = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._disabledColor;
	}

	/**
	 * @private
	 */
	private var _displayAsPassword:Bool = false;

	/**
	 * Indicates whether the text field is a password text field that hides
	 * input characters using a substitute character.
	 *
	 * <p>In the following example, the text is displayed as a password:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.displayAsPassword = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#displayAsPassword Full description of openfl.text.StageText.displayAsPassword in Adobe's Flash Platform API Reference
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
	private var _isEditable:Bool = true;

	/**
	 * Determines if the text input is editable. If the text input is not
	 * editable, it will still appear enabled.
	 *
	 * <p>In the following example, the text is not editable:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.isEditable = false;</listing>
	 *
	 * @default true
	 */
	public var isEditable(get, set):Bool;
	public function get_isEditable():Bool
	{
		return this._isEditable;
	}

	/**
	 * @private
	 */
	public function set_isEditable(value:Bool):Bool
	{
		if(this._isEditable == value)
		{
			return this._isEditable;
		}
		this._isEditable = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._isEditable;
	}

	/**
	 * @inheritDoc
	 *
	 * @default true
	 */
	public var setTouchFocusOnEndedPhase(get, never):Bool;
	public function get_setTouchFocusOnEndedPhase():Bool
	{
		return true;
	}

	/**
	 * @private
	 */
	private var _fontFamily:String = null;

	/**
	 * Indicates the name of the current font family. A value of null
	 * indicates the system default.
	 *
	 * <p>In the following example, the font family is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.fontFamily = "Source Sans Pro";</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#fontFamily Full description of openfl.text.StageText.fontFamily in Adobe's Flash Platform API Reference
	 */
	public var fontFamily(get, set):String;
	public function get_fontFamily():String
	{
		return this._fontFamily;
	}

	/**
	 * @private
	 */
	public function set_fontFamily(value:String):String
	{
		if(this._fontFamily == value)
		{
			return this._fontFamily;
		}
		this._fontFamily = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._fontFamily;
	}

	/**
	 * @private
	 */
#if flash
	private var _fontPosture:String = "normal"/*FontPosture.NORMAL*/;
#end
	/**
	 * Specifies the font posture, using constants defined in the
	 * <code>openfl.text.engine.FontPosture</code> class.
	 *
	 * <p>In the following example, the font posture is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.fontPosture = FontPosture.ITALIC;</listing>
	 *
	 * @default openfl.text.engine.FontPosture.NORMAL
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#fontPosture Full description of openfl.text.StageText.fontPosture in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontPosture.html openfl.text.engine.FontPosture
	 */
#if flash
	public function get_fontPosture():String
	{
		return this._fontPosture;
	}
#end
	/**
	 * @private
	 */
#if flash
	public function set_fontPosture(value:String):String
	{
		if(this._fontPosture == value)
		{
			return get_fontPosture();
		}
		this._fontPosture = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_fontPosture();
	}
#end

	/**
	 * @private
	 */
	private var _fontSize:Int = 12;

	/**
	 * The size in pixels for the current font family.
	 *
	 * <p>In the following example, the font size is increased to 16 pixels:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.fontSize = 16;</listing>
	 *
	 * @default 12
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#fontSize Full description of openfl.text.StageText.fontSize in Adobe's Flash Platform API Reference
	 */
	public var fontSize(get, set):Int;
	public function get_fontSize():Int
	{
		return this._fontSize;
	}

	/**
	 * @private
	 */
	public function set_fontSize(value:Int):Int
	{
		if(this._fontSize == value)
		{
			return this._fontSize;
		}
		this._fontSize = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._fontSize;
	}

	/**
	 * @private
	 */
#if flash
	private var _fontWeight:String = "normal"/*FontWeight.NORMAL*/;
#end

	/**
	 * Specifies the font weight, using constants defined in the
	 * <code>openfl.text.engine.FontWeight</code> class.
	 *
	 * <p>In the following example, the font weight is changed to bold:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.fontWeight = FontWeight.BOLD;</listing>
	 *
	 * @default openfl.text.engine.FontWeight.NORMAL
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#fontWeight Full description of openfl.text.StageText.fontWeight in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontWeight.html openfl.text.engine.FontWeight
	 */
#if flash
	public function get_fontWeight():String
	{
		return this._fontWeight;
	}
#end

	/**
	 * @private
	 */
#if flash
	public function set_fontWeight(value:String):String
	{
		if(this._fontWeight == value)
		{
			return get_fontWeight();
		}
		this._fontWeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_fontWeight();
	}
#end

	/**
	 * @private
	 */
	private var _locale:String = "en";

	/**
	 * Indicates the locale of the text. <code>StageText</code> uses the
	 * standard locale identifiers. For example <code>"en"</code>,
	 * <code>"en_US"</code> and <code>"en-US"</code> are all English.
	 *
	 * <p>In the following example, the locale is changed to Russian:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.locale = "ru";</listing>
	 *
	 * @default "en"
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#locale Full description of openfl.text.StageText.locale in Adobe's Flash Platform API Reference
	 */
	public var locale(get, set):String;
	public function get_locale():String
	{
		return this._locale;
	}

	/**
	 * @private
	 */
	public function set_locale(value:String):String
	{
		if(this._locale == value)
		{
			return this._locale;
		}
		this._locale = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._locale;
	}

	/**
	 * @private
	 */
	private var _maxChars:Int = 0;

	/**
	 * Indicates the maximum number of characters that a user can enter into
	 * the text editor. A script can insert more text than <code>maxChars</code>
	 * allows. If <code>maxChars</code> equals zero, a user can enter an
	 * unlimited amount of text into the text editor.
	 *
	 * <p>In the following example, the maximum character count is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.maxChars = 10;</listing>
	 *
	 * @default 0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#maxChars Full description of openfl.text.StageText.maxChars in Adobe's Flash Platform API Reference
	 */
	public var maxChars(get, set):Int;
	public function get_maxChars():Int
	{
		return this._maxChars;
	}

	/**
	 * @private
	 */
	public function set_maxChars(value:Int):Int
	{
		if(this._maxChars == value)
		{
			return this._maxChars;
		}
		this._maxChars = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._maxChars;
	}

	/**
	 * @private
	 */
	private var _multiline:Bool = false;

	/**
	 * Indicates whether the StageText object can display more than one line
	 * of text. This property is configurable after the text editor is
	 * created, unlike a regular <code>StageText</code> instance. The text
	 * editor will dispose and recreate its internal <code>StageText</code>
	 * instance if the value of the <code>multiline</code> property is
	 * changed after the <code>StageText</code> is initially created.
	 *
	 * <p>In the following example, multiline is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.multiline = true;</listing>
	 *
	 * When setting this property to <code>true</code>, it is recommended
	 * that the text input's <code>verticalAlign</code> property is set to
	 * <code>TextInput.VERTICAL_ALIGN_JUSTIFY</code>.
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#multiline Full description of openfl.text.StageText.multiline in Adobe's Flash Platform API Reference
	 */
	public var multiline(get, set):Bool;
	public function get_multiline():Bool
	{
		return this._multiline;
	}

	/**
	 * @private
	 */
	public function set_multiline(value:Bool):Bool
	{
		if(this._multiline == value)
		{
			return this._multiline;
		}
		this._multiline = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._multiline;
	}

	/**
	 * @private
	 */
	// variable named "_restrict" generates compile error on hxcpp 
	// private var _restrict:String;
	private var _restrict_:String;

	/**
	 * Restricts the set of characters that a user can enter into the text
	 * field. Only user interaction is restricted; a script can put any text
	 * into the text field.
	 *
	 * <p>In the following example, the text is restricted to numbers:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.restrict = "0-9";</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#restrict Full description of openfl.text.StageText.restrict in Adobe's Flash Platform API Reference
	 */
	public var restrict(get, set):String;
	public function get_restrict():String
	{
		return this._restrict_;
	}

	/**
	 * @private
	 */
	public function set_restrict(value:String):String
	{
		if(this._restrict_ == value)
		{
			return this._restrict_;
		}
		this._restrict_ = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._restrict_;
	}

	/**
	 * @private
	 */
	private var _returnKeyLabel:String = "default";

	/**
	 * Indicates the label on the Return key for devices that feature a soft
	 * keyboard. The available values are constants defined in the
	 * <code>openfl.text.ReturnKeyLabel</code> class. This property is only a
	 * hint to the underlying platform, because not all devices and
	 * operating systems support this functionality.
	 *
	 * <p>In the following example, the return key label is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.returnKeyLabel = ReturnKeyLabel.GO;</listing>
	 *
	 * @default openfl.text.ReturnKeyLabel.DEFAULT
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#returnKeyLabel Full description of openfl.text.StageText.returnKeyLabel in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/ReturnKeyLabel.html openfl.text.ReturnKeyLabel
	 */
	public var returnKeyLabel(get, set):String;
	public function get_returnKeyLabel():String
	{
		return this._returnKeyLabel;
	}

	/**
	 * @private
	 */
	public function set_returnKeyLabel(value:String):String
	{
		if(this._returnKeyLabel == value)
		{
			return this._returnKeyLabel;
		}
		this._returnKeyLabel = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._returnKeyLabel;
	}

	/**
	 * @private
	 */
	private var _softKeyboardType:String = "default";

	/**
	 * Controls the appearance of the soft keyboard. Valid values are
	 * defined as constants in the <code>openfl.text.SoftKeyboardType</code>
	 * class. This property is only a hint to the underlying platform,
	 * because not all devices and operating systems support this
	 * functionality.
	 *
	 * <p>In the following example, the soft keyboard type is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.softKeyboardType = SoftKeyboardType.NUMBER;</listing>
	 *
	 * @default openfl.text.SoftKeyboardType.DEFAULT
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#softKeyboardType Full description of openfl.text.StageText.softKeyboardType in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/SoftKeyboardType.html openfl.text.SoftKeyboardType
	 */
	public var softKeyboardType(get, set):String;
	public function get_softKeyboardType():String
	{
		return this._softKeyboardType;
	}

	/**
	 * @private
	 */
	public function set_softKeyboardType(value:String):String
	{
		if(this._softKeyboardType == value)
		{
			return this._softKeyboardType;
		}
		this._softKeyboardType = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._softKeyboardType;
	}

	/**
	 * @private
	 */
	private var _textAlign:TextFormatAlign = TextFormatAlign.START;

	/**
	 * Indicates the paragraph alignment. Valid values are defined as
	 * constants in the <code>openfl.text.TextFormatAlign</code> class.
	 *
	 * <p>In the following example, the text is centered:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.textAlign = TextFormatAlign.CENTER;</listing>
	 *
	 * @default openfl.text.TextFormatAlign.START
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#textAlign Full description of openfl.text.StageText.textAlign in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormatAlign.html openfl.text.TextFormatAlign
	 */
	public var textAlign(get, set):TextFormatAlign;
	public function get_textAlign():TextFormatAlign
	{
		return this._textAlign;
	}

	/**
	 * @private
	 */
	public function set_textAlign(value:TextFormatAlign):TextFormatAlign
	{
		if(this._textAlign == value)
		{
			return this._textAlign;
		}
		this._textAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._textAlign;
	}

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
	private var _updateSnapshotOnScaleChange:Bool = false;

	/**
	 * Refreshes the texture snapshot every time that the text editor is
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
	 * text editor is scaled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.updateSnapshotOnScaleChange = true;</listing>
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
		if(this._measureTextField != null)
		{
			Starling.current.nativeStage.removeChild(this._measureTextField);
			this._measureTextField = null;
		}

		if(this.stageText != null)
		{
			this.disposeStageText();
		}

		if(this.textSnapshot != null)
		{
			//avoid the need to call dispose(). we'll create a new snapshot
			//when the renderer is added to stage again.
			this.textSnapshot.texture.dispose();
			this.removeChild(this.textSnapshot, true);
			this.textSnapshot = null;
		}

		super.dispose();
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		if(this.textSnapshot != null && this._updateSnapshotOnScaleChange)
		{
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			if(matrixToScaleX(HELPER_MATRIX) != this._lastGlobalScaleX || matrixToScaleY(HELPER_MATRIX) != this._lastGlobalScaleY)
			{
				//the snapshot needs to be updated because the scale has
				//changed since the last snapshot was taken.
				this.invalidate(INVALIDATION_FLAG_SIZE);
				this.validate();
			}
		}
		
		//we'll skip this if the text field isn't visible to avoid running
		//that code every frame.
		if(this.stageText != null && this.stageText.visible)
		{
			this.refreshViewPortAndFontSize();
		}

		if(this.textSnapshot != null)
		{
			var desktopGutterPositionOffset:Float = 0;
			if(this._stageTextIsTextField)
			{
				desktopGutterPositionOffset = 2;
			}
			this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx - desktopGutterPositionOffset;
			this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty - desktopGutterPositionOffset;
		}

		super.render(support, parentAlpha);
	}

	/**
	 * @inheritDoc
	 */
	public function setFocus(position:Point = null):Void
	{
		//setting the editable property of a StageText to false seems to be
		//ignored on Android, so this is the workaround
		if(!this._isEditable && SystemUtil.platform == "AND")
		{
			return;
		}
		if(this.stage != null && this.stageText.stage == null)
		{
			this.stageText.stage = Starling.current.nativeStage;
		}
		if(this.stageText != null && this._stageTextIsComplete)
		{
			if(position != null)
			{
				var positionX:Float = position.x + 2;
				var positionY:Float = position.y + 2;
				if(positionX < 0)
				{
					this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = 0;
				}
				else
				{
					this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(positionX, positionY);
					if(this._pendingSelectionBeginIndex < 0)
					{
						if(this._multiline)
						{
							var lineIndex:Int = Std.int(positionY / this._measureTextField.getLineMetrics(0).height);
							try
							{
#if flash
								this._pendingSelectionBeginIndex = this._measureTextField.getLineOffset(lineIndex) + this._measureTextField.getLineLength(lineIndex);
#else
								// TODO: Implement TextField.getLineLength
								this._pendingSelectionBeginIndex = this._measureTextField.getLineOffset(lineIndex);
#end
								if(this._pendingSelectionBeginIndex != this._text.length)
								{
									this._pendingSelectionBeginIndex--;
								}
							}
							catch(error:Error)
							{
								//we may be checking for a line beyond the
								//end that doesn't exist
								this._pendingSelectionBeginIndex = this._text.length;
							}
						}
						else
						{
							this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(positionX, this._measureTextField.getLineMetrics(0).ascent / 2);
							if(this._pendingSelectionBeginIndex < 0)
							{
								this._pendingSelectionBeginIndex = this._text.length;
							}
						}
					}
					else
					{
						var bounds:Rectangle = this._measureTextField.getCharBoundaries(this._pendingSelectionBeginIndex);
						var boundsX:Float = bounds.x;
						if(bounds != null && (boundsX + bounds.width - positionX) < (positionX - boundsX))
						{
							this._pendingSelectionBeginIndex++;
						}
					}
					this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
				}
			}
			else
			{
				this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
			}
			this.stageText.visible = true;
			this.stageText.assignFocus();
		}
		else
		{
			this._isWaitingToSetFocus = true;
		}
	}

	/**
	 * @inheritDoc
	 */
	public function clearFocus():Void
	{
		if(!this._stageTextHasFocus)
		{
			return;
		}
		Starling.current.nativeStage.focus = Starling.current.nativeStage;
	}

	/**
	 * @inheritDoc
	 */
	public function selectRange(beginIndex:Int, endIndex:Int):Void
	{
		if(this._stageTextIsComplete && this.stageText)
		{
			this._pendingSelectionBeginIndex = -1;
			this._pendingSelectionEndIndex = -1;
			this.stageText.selectRange(beginIndex, endIndex);
		}
		else
		{
			this._pendingSelectionBeginIndex = beginIndex;
			this._pendingSelectionEndIndex = endIndex;
		}
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

		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid((FeathersControl.INVALIDATION_FLAG_DATA));

		if(stylesInvalid || dataInvalid)
		{
			this.refreshMeasureProperties();
		}

		result = this.measure(result);

		return result;
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(this._measureTextField != null && this._measureTextField.parent == null)
		{
			Starling.current.nativeStage.addChild(this._measureTextField);
		}
		else if(this._measureTextField == null)
		{
			this._measureTextField = new TextField();
			this._measureTextField.visible = false;
#if flash
			this._measureTextField.mouseEnabled = this._measureTextField.mouseWheelEnabled = false;
#else
			this._measureTextField.mouseEnabled = false;
#end
			this._measureTextField.autoSize = TextFieldAutoSize.LEFT;
			this._measureTextField.multiline = false;
			this._measureTextField.wordWrap = false;
			this._measureTextField.embedFonts = false;
			this._measureTextField.defaultTextFormat = new TextFormat(null, 11, 0x000000, false, false, false);
			Starling.current.nativeStage.addChild(this._measureTextField);
		}

		this.createStageText();
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
		var stateInvalid:Bool = this.isInvalid((FeathersControl.INVALIDATION_FLAG_STATE));
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid((FeathersControl.INVALIDATION_FLAG_DATA));

		if(stylesInvalid || dataInvalid)
		{
			this.refreshMeasureProperties();
		}

		var oldIgnoreStageTextChanges:Bool = this._ignoreStageTextChanges;
		this._ignoreStageTextChanges = true;
		if(stateInvalid || stylesInvalid)
		{
			this.refreshStageTextProperties();
		}

		if(dataInvalid)
		{
			if(this.stageText.text != this._text)
			{
				if(this._pendingSelectionBeginIndex < 0)
				{
					this._pendingSelectionBeginIndex = this.stageText.selectionActiveIndex;
					this._pendingSelectionEndIndex = this.stageText.selectionAnchorIndex;
				}
				this.stageText.text = this._text;
			}
		}
		this._ignoreStageTextChanges = oldIgnoreStageTextChanges;

		if(stylesInvalid || stateInvalid)
		{
			this.stageText.editable = this._isEditable && this._isEnabled;
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

		this._measureTextField.autoSize = TextFieldAutoSize.LEFT;

		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			newWidth = this._measureTextField.textWidth;
			if(newWidth < this._minWidth)
			{
				newWidth = this._minWidth;
			}
			else if(newWidth > this._maxWidth)
			{
				newWidth = this._maxWidth;
			}
		}

		//the +4 is accounting for the TextField gutter
		this._measureTextField.width = newWidth + 4;
		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			//since we're measuring with TextField, but rendering with
			//StageText, we're using height instead of textHeight here to be
			//sure that the measured size is on the larger side, in case the
			//rendered size is actually bigger than textHeight
			//if only StageText had an API for text measurement, we wouldn't
			//be in this mess...
			newHeight = this._measureTextField.height;
			if(newHeight < this._minHeight)
			{
				newHeight = this._minHeight;
			}
			else if(newHeight > this._maxHeight)
			{
				newHeight = this._maxHeight;
			}
		}

		this._measureTextField.autoSize = TextFieldAutoSize.NONE;

		//put the width and height back just in case we measured without
		//a full validation
		//the +4 is accounting for the TextField gutter
		this._measureTextField.width = this.actualWidth + 4;
		this._measureTextField.height = this.actualHeight;

		result.x = newWidth;
		result.y = newHeight;

		return result;
	}

	/**
	 * @private
	 */
	private function layout(sizeInvalid:Bool):Void
	{
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var skinInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SKIN);

		if(sizeInvalid || stylesInvalid || skinInvalid || stateInvalid)
		{
			this.refreshViewPortAndFontSize();
			this.refreshMeasureTextFieldDimensions();
			var viewPort:Rectangle = this.stageText.viewPort;
			var textureRoot:ConcreteTexture = this.textSnapshot != null ? this.textSnapshot.texture.root : null;
			this._needsNewTexture = this._needsNewTexture || this.textSnapshot == null ||
				textureRoot.scale != Starling.current.contentScaleFactor ||
				viewPort.width != textureRoot.width || viewPort.height != textureRoot.height;
		}

		if(!this._stageTextHasFocus && (stateInvalid || stylesInvalid || dataInvalid || sizeInvalid || this._needsNewTexture))
		{
			var hasText:Bool = this._text.length > 0;
			if(hasText)
			{
				this.refreshSnapshot();
			}
			if(this.textSnapshot != null)
			{
				this.textSnapshot.visible = !this._stageTextHasFocus;
				this.textSnapshot.alpha = hasText ? 1 : 0;
			}
			this.stageText.visible = false;
		}

		this.doPendingActions();
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
	private function refreshMeasureProperties():Void
	{
		var nativeScaleFactor:Float = 1;
#if flash
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
#end
		
		this._measureTextField.displayAsPassword = this._displayAsPassword;
		this._measureTextField.maxChars = this._maxChars;
		this._measureTextField.restrict = this._restrict_;
		this._measureTextField.multiline = this._measureTextField.wordWrap = this._multiline;

		var format:TextFormat = this._measureTextField.defaultTextFormat;
		format.color = this._color;
		format.font = this._fontFamily;
#if flash
		format.italic = this._fontPosture == "italic"/*FontPosture.ITALIC*/;
#end
		format.size = Std.int(this._fontSize * nativeScaleFactor);
#if flash
		format.bold = this._fontWeight == "bold"/*FontWeight.BOLD*/;
#end
		var alignValue:TextFormatAlign = this._textAlign;
		if(alignValue == TextFormatAlign.START)
		{
			alignValue = TextFormatAlign.LEFT;
		}
		else if(alignValue == TextFormatAlign.END)
		{
			alignValue = TextFormatAlign.RIGHT;
		}
		format.align = alignValue;
		this._measureTextField.defaultTextFormat = format;
		this._measureTextField.setTextFormat(format);
		if(this._text.length == 0)
		{
			this._measureTextField.text = " ";
		}
		else
		{
			this._measureTextField.text = this._text;
		}
	}

	/**
	 * @private
	 */
	private function refreshStageTextProperties():Void
	{
		if(this.stageText.multiline != this._multiline)
		{
			if(this.stageText != null)
			{
				this.disposeStageText();
			}
			this.createStageText();
		}

		this.stageText.autoCapitalize = this._autoCapitalize;
		this.stageText.autoCorrect = this._autoCorrect;
		if(this._isEnabled)
		{
			this.stageText.color = this._color;
		}
		else
		{
			this.stageText.color = this._disabledColor;
		}
		this.stageText.displayAsPassword = this._displayAsPassword;
		this.stageText.fontFamily = this._fontFamily;
#if flash
		this.stageText.fontPosture = this._fontPosture;
		this.stageText.fontWeight = this._fontWeight;
#end
		this.stageText.locale = this._locale;
		this.stageText.maxChars = this._maxChars;
		this.stageText.restrict = this._restrict_;
		this.stageText.returnKeyLabel = this._returnKeyLabel;
		this.stageText.softKeyboardType = this._softKeyboardType;
		this.stageText.textAlign = this._textAlign;
	}

	/**
	 * @private
	 */
	private function doPendingActions():Void
	{
		if(this._isWaitingToSetFocus)
		{
			this._isWaitingToSetFocus = false;
			this.setFocus();
		}
		if(this._pendingSelectionBeginIndex >= 0)
		{
			var startIndex:Int = this._pendingSelectionBeginIndex;
			var endIndex:Int = (this._pendingSelectionEndIndex < 0) ? this._pendingSelectionBeginIndex : this._pendingSelectionEndIndex;
			this._pendingSelectionBeginIndex = -1;
			this._pendingSelectionEndIndex = -1;
			if(this.stageText.selectionAnchorIndex != startIndex || this.stageText.selectionActiveIndex != endIndex)
			{
				//if the same range is already selected, don't try to do it
				//again because on iOS, if the StageText is multiline, this
				//will cause the clipboard menu to appear when it shouldn't.
				this.selectRange(startIndex, endIndex);
			}
		}
	}

	/**
	 * @private
	 */
	private function texture_onRestore():Void
	{
		if(this.textSnapshot.texture.scale != Starling.current.contentScaleFactor)
		{
			//if we've changed between scale factors, we need to recreate
			//the texture to match the new scale factor.
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		else
		{
			this.refreshSnapshot();
			if(this.textSnapshot != null)
			{
				this.textSnapshot.visible = !this._stageTextHasFocus;
				this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
			}
			if(!this._stageTextHasFocus)
			{
				this.stageText.visible = false;
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshSnapshot():Void
	{
		//StageText's stage property cannot be null when we call
		//drawViewPortToBitmapData()
		if(this.stage != null && this.stageText.stage == null)
		{
			this.stageText.stage = Starling.current.nativeStage;
		}
		if(!this.stageText.stage)
		{
			//we need to keep a flag active so that the snapshot will be
			//refreshed after the text editor is added to the stage
			this.invalidate((FeathersControl.INVALIDATION_FLAG_DATA));
			return;
		}
		var viewPort:Rectangle = this.stageText.viewPort;
		if(viewPort.width == 0 || viewPort.height == 0)
		{
			return;
		}
		var nativeScaleFactor:Float = 1;
#if flash
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
#end
		//StageText sucks because it requires that the BitmapData's width
		//and height exactly match its view port width and height.
		//(may be doubled on Retina Mac) 
		var bitmapData:BitmapData = null;
		try
		{
			bitmapData= new BitmapData(Std.int(viewPort.width * nativeScaleFactor), Std.int(viewPort.height * nativeScaleFactor), true, 0x00ff00ff);
			this.stageText.drawViewPortToBitmapData(bitmapData);
		} 
		catch(error:Error) 
		{
			//drawing stage text to the bitmap data at double size may fail
			//on runtime versions less than 15, so fall back to using a
			//snapshot that is half size. it's not ideal, but better than
			//nothing.
			bitmapData.dispose();
			bitmapData = new BitmapData(Std.int(viewPort.width), Std.int(viewPort.height), true, 0x00ff00ff);
			this.stageText.drawViewPortToBitmapData(bitmapData);
		}

		var newTexture:Texture = null;
		if(this.textSnapshot == null || this._needsNewTexture)
		{
			var scaleFactor:Float = Starling.current.contentScaleFactor;
			//skip Texture.fromBitmapData() because we don't want
			//it to create an onRestore function that will be
			//immediately discarded for garbage collection. 
			newTexture = Texture.empty(bitmapData.width / scaleFactor, bitmapData.height / scaleFactor,
				true, false, false, scaleFactor);
			newTexture.root.uploadBitmapData(bitmapData);
			newTexture.root.onRestore = texture_onRestore;
		}
		if(this.textSnapshot == null)
		{
			this.textSnapshot = new Image(newTexture);
			this.addChild(this.textSnapshot);
		}
		else
		{
			if(this._needsNewTexture)
			{
				this.textSnapshot.texture.dispose();
				this.textSnapshot.texture = newTexture;
				this.textSnapshot.readjustSize();
			}
			else
			{
				//this is faster, if we haven't resized the bitmapdata
				var existingTexture:Texture = this.textSnapshot.texture;
				existingTexture.root.uploadBitmapData(bitmapData);
			}
		}
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		var globalScaleX:Float = matrixToScaleX(HELPER_MATRIX);
		var globalScaleY:Float = matrixToScaleY(HELPER_MATRIX);
		if(this._updateSnapshotOnScaleChange)
		{
			this.textSnapshot.scaleX = 1 / globalScaleX;
			this.textSnapshot.scaleY = 1 / globalScaleY;
			this._lastGlobalScaleX = globalScaleX;
			this._lastGlobalScaleY = globalScaleY;
		}
		else
		{
			this.textSnapshot.scaleX = 1;
			this.textSnapshot.scaleY = 1;
		}
		if(nativeScaleFactor > 1 && bitmapData.width == viewPort.width)
		{
			//when we fall back to using a snapshot that is half size on
			//older runtimes, we need to scale it up.
			this.textSnapshot.scaleX *= nativeScaleFactor;
			this.textSnapshot.scaleY *= nativeScaleFactor;
		}
		bitmapData.dispose();
		this._needsNewTexture = false;
	}

	/**
	 * @private
	 */
	private function refreshViewPortAndFontSize():Void
	{
		HELPER_POINT.x = HELPER_POINT.y = 0;
		var desktopGutterPositionOffset:Float = 0;
		var desktopGutterDimensionsOffset:Float = 0;
		if(this._stageTextIsTextField)
		{
			desktopGutterPositionOffset = 2;
			desktopGutterDimensionsOffset = 4;
		}
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		var globalScaleX:Float;
		var globalScaleY:Float;
		var smallerGlobalScale:Float;
		if(this._stageTextHasFocus || this._updateSnapshotOnScaleChange)
		{
			globalScaleX = matrixToScaleX(HELPER_MATRIX);
			globalScaleY = matrixToScaleY(HELPER_MATRIX);
			smallerGlobalScale = globalScaleX;
			if(globalScaleY < smallerGlobalScale)
			{
				smallerGlobalScale = globalScaleY;
			}
		}
		else
		{
			globalScaleX = 1;
			globalScaleY = 1;
			smallerGlobalScale = 1;
		}
		if(this.is3D)
		{
			HELPER_MATRIX3D = this.getTransformationMatrix3D(this.stage, HELPER_MATRIX3D);
			HELPER_POINT3D = MatrixUtil.transformCoords3D(HELPER_MATRIX3D, -desktopGutterPositionOffset, -desktopGutterPositionOffset, 0, HELPER_POINT3D);
			HELPER_POINT.setTo(HELPER_POINT3D.x, HELPER_POINT3D.y);
		}
		else
		{
			MatrixUtil.transformCoords(HELPER_MATRIX, -desktopGutterPositionOffset, -desktopGutterPositionOffset, HELPER_POINT);
		}
		var nativeScaleFactor:Float = 1;
#if flash
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
#end
		var scaleFactor:Float = Starling.current.contentScaleFactor / nativeScaleFactor;
		var starlingViewPort:Rectangle = Starling.current.viewPort;
		var stageTextViewPort:Rectangle = this.stageText.viewPort;
		if(stageTextViewPort == null)
		{
			stageTextViewPort = new Rectangle();
		}
		stageTextViewPort.x = Math.round(starlingViewPort.x + HELPER_POINT.x * scaleFactor);
		stageTextViewPort.y = Math.round(starlingViewPort.y + HELPER_POINT.y * scaleFactor);
		var viewPortWidth:Float = Math.round((this.actualWidth + desktopGutterDimensionsOffset) * scaleFactor * globalScaleX);
		if(viewPortWidth < 1 ||
			viewPortWidth != viewPortWidth) //isNaN
		{
			viewPortWidth = 1;
		}
		var viewPortHeight:Float = Math.round((this.actualHeight + desktopGutterDimensionsOffset) * scaleFactor * globalScaleY);
		if(viewPortHeight < 1 ||
			viewPortHeight != viewPortHeight) //isNaN
		{
			viewPortHeight = 1;
		}
		stageTextViewPort.width = viewPortWidth;
		stageTextViewPort.height = viewPortHeight;
		this.stageText.viewPort = stageTextViewPort;

		//for some reason, we don't need to account for the native scale factor here
		scaleFactor = Starling.current.contentScaleFactor;
		//StageText's fontSize property is an int, so we need to
		//specifically avoid using Number here.
		var newFontSize:Int = Std.int(this._fontSize * scaleFactor * smallerGlobalScale);
		if(this.stageText.fontSize != newFontSize)
		{
			//we need to check if this value has changed because on iOS
			//if displayAsPassword is set to true, the new character
			//will not be shown if the font size changes. instead, it
			//immediately changes to a bullet. (Github issue #881)
			this.stageText.fontSize = newFontSize;
		}
		
	}

	/**
	 * @private
	 */
	private function refreshMeasureTextFieldDimensions():Void
	{
		//the +4 is accounting for the TextField gutter
		this._measureTextField.width = this.actualWidth + 4;
		this._measureTextField.height = this.actualHeight;
	}

	/**
	 * @private
	 */
	private function disposeStageText():Void
	{
		if(this.stageText == null)
		{
			return;
		}
		this.stageText.removeEventListener(openfl.events.Event.CHANGE, stageText_changeHandler);
		this.stageText.removeEventListener(KeyboardEvent.KEY_DOWN, stageText_keyDownHandler);
		this.stageText.removeEventListener(KeyboardEvent.KEY_UP, stageText_keyUpHandler);
		this.stageText.removeEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
		this.stageText.removeEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
		this.stageText.removeEventListener(openfl.events.Event.COMPLETE, stageText_completeHandler);
#if flash
		this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, stageText_softKeyboardActivateHandler);
		this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, stageText_softKeyboardDeactivateHandler);
#end
		this.stageText.stage = null;
		this.stageText.dispose();
		this.stageText = null;
	}

	/**
	 * Creates and adds the <code>stageText</code> instance.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function createStageText():Void
	{
		this._stageTextIsComplete = false;
		var StageTextType:Class<Dynamic>;
		var initOptions:Dynamic;
		#if flash
		try
		{
			StageTextType = Type.resolveClass("openfl.text.StageText");
			var StageTextInitOptionsType:Class<Dynamic> = Type.resolveClass("openfl.text.StageTextInitOptions");
			initOptions = Type.createInstance(StageTextInitOptionsType, [this._multiline]);
		}
		catch (error:Error)
		#end
		{
			#if 0
			StageTextType = flash.text.StageText;
			#else
			StageTextType = null;
			#end
			initOptions = { multiline: this._multiline };
		}
		this.stageText = Type.createInstance(StageTextType, [initOptions]);
		this.stageText.visible = false;
		this.stageText.addEventListener(openfl.events.Event.CHANGE, stageText_changeHandler);
		this.stageText.addEventListener(KeyboardEvent.KEY_DOWN, stageText_keyDownHandler);
		this.stageText.addEventListener(KeyboardEvent.KEY_UP, stageText_keyUpHandler);
		this.stageText.addEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
		this.stageText.addEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
#if flash
		this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, stageText_softKeyboardActivateHandler);
		this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, stageText_softKeyboardDeactivateHandler);
#end
		this.stageText.addEventListener(openfl.events.Event.COMPLETE, stageText_completeHandler);
		this.invalidate();
	}

	/**
	 * @private
	 */
	private function textEditor_removedFromStageHandler(event:starling.events.Event):Void
	{
		//remove this from the stage, if needed
		//it will be added back next time we receive focus
		this.stageText.stage = null;
	}

	/**
	 * @private
	 */
	private function stageText_changeHandler(event:openfl.events.Event):Void
	{
		if(this._ignoreStageTextChanges)
		{
			return;
		}
		this.text = this.stageText.text;
	}

	/**
	 * @private
	 */
	private function stageText_completeHandler(event:openfl.events.Event):Void
	{
		this.stageText.removeEventListener(openfl.events.Event.COMPLETE, stageText_completeHandler);
		this.invalidate();

		this._stageTextIsComplete = true;
	}

	/**
	 * @private
	 */
	private function stageText_focusInHandler(event:FocusEvent):Void
	{
		this._stageTextHasFocus = true;
		this.addEventListener(starling.events.Event.ENTER_FRAME, hasFocus_enterFrameHandler);
		if(this.textSnapshot != null)
		{
			this.textSnapshot.visible = false;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		this.dispatchEventWith(FeathersEventType.FOCUS_IN);
	}

	/**
	 * @private
	 */
	private function stageText_focusOutHandler(event:FocusEvent):Void
	{
		this._stageTextHasFocus = false;
		//since StageText doesn't expose its scroll position, we need to
		//set the selection back to the beginning to scroll there. it's a
		//hack, but so is everything about StageText.
		//in other news, why won't 0,0 work here?
		this.stageText.selectRange(1, 1);

		this.invalidate((FeathersControl.INVALIDATION_FLAG_DATA));
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
	}

	/**
	 * @private
	 */
	private function hasFocus_enterFrameHandler(event:starling.events.Event):Void
	{
		if(this._stageTextHasFocus)
		{
			var target:DisplayObject = this;
			do
			{
				if(!target.hasVisibleArea)
				{
					this.stageText.stage.focus = null;
					break;
				}
				target = target.parent;
			}
			while(target != null);
		}
		else
		{
			this.removeEventListener(starling.events.Event.ENTER_FRAME, hasFocus_enterFrameHandler);
		}
	}

	/**
	 * @private
	 */
	private function stageText_keyDownHandler(event:KeyboardEvent):Void
	{
#if flash
		if(!this._multiline && (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.NEXT))
		{
			event.preventDefault();
			this.dispatchEventWith(FeathersEventType.ENTER);
		}
		else if(event.keyCode == Keyboard.BACK)
		{
			//even a listener on the stage won't detect the back key press that
			//will close the application if the StageText has focus, so we
			//always need to prevent it here
			event.preventDefault();
			Starling.current.nativeStage.focus = Starling.current.nativeStage;
		}
#end
	}

	/**
	 * @private
	 */
	private function stageText_keyUpHandler(event:KeyboardEvent):Void
	{
#if flash
		if(!this._multiline && (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.NEXT))
		{
			event.preventDefault();
		}
#end
	}

	/**
	 * @private
	 */
#if flash
	private function stageText_softKeyboardActivateHandler(event:SoftKeyboardEvent):Void
	{
		this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE, true);
	}
#end
	/**
	 * @private
	 */
#if flash
	private function stageText_softKeyboardDeactivateHandler(event:SoftKeyboardEvent):Void
	{
		this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_DEACTIVATE, true);
	}
#end
}
