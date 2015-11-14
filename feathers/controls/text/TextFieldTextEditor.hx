/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text;
import feathers.core.FeathersControl;
import feathers.core.FocusManager;
import feathers.core.INativeFocusOwner;
import feathers.core.ITextEditor;
import feathers.events.FeathersEventType;
import feathers.utils.geom.FeathersMatrixUtil.matrixToRotation;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleX;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleY;
import openfl.errors.Error;

import flash.display.BitmapData;
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.display3D.Context3DProfile;
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
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.PowerOfTwo.getNextPowerOfTwo;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_STYLES;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;

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
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when the user presses the Enter key while the editor has focus.
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
 *///[Event(name="enter",type="starling.events.Event")]

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
 *///[Event(name="focusIn",type="starling.events.Event")]

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
 *///[Event(name="focusOut",type="starling.events.Event")]

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
 *///[Event(name="softKeyboardActivate",type="starling.events.Event")]

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
 *///[Event(name="softKeyboardDeactivate",type="starling.events.Event")]

/**
 * A Feathers text editor that uses the native <code>openfl.text.TextField</code>
 * class with its <code>type</code> property set to
 * <code>openfl.text.TextInputType.INPUT</code>. Textures are completely
 * managed by this component, and they will be automatically disposed when
 * the component is disposed.
 *
 * <p>For desktop apps, <code>TextFieldTextEditor</code> is recommended
 * instead of <code>StageTextTextEditor</code>. <code>StageTextTextEditor</code>
 * will still work in desktop apps, but it is more appropriate for mobile
 * apps.</p>
 *
 * @see ../../../help/text-editors.html Introduction to Feathers text editors
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html openfl.text.TextField
 */
class TextFieldTextEditor extends FeathersControl implements ITextEditor implements INativeFocusOwner
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
		this.isQuickHitAreaEnabled = true;
		this.addEventListener(Event.ADDED_TO_STAGE, textEditor_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, textEditor_removedFromStageHandler);
	}

	/**
	 * The text field sub-component.
	 */
	private var textField:TextField;

	/**
	 * @copy feathers.core.INativeFocusOwner#nativeFocus
	 */
	public var nativeFocus(get, never):InteractiveObject;
	public function get_nativeFocus():InteractiveObject
	{
		return this.textField;
	}

	/**
	 * An image that displays a snapshot of the native <code>TextField</code>
	 * in the Starling display list when the editor doesn't have focus.
	 */
	private var textSnapshot:Image;

	/**
	 * The separate text field sub-component used for measurement.
	 * Typically, the main text field often doesn't report correct values
	 * for a full frame if its dimensions are changed too often.
	 */
	private var measureTextField:TextField;

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
	private var _textFieldSnapshotClipRect:Rectangle = new Rectangle();

	/**
	 * @private
	 */
	private var _textFieldOffsetX:Float = 0;

	/**
	 * @private
	 */
	private var _textFieldOffsetY:Float = 0;

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
	private var _needsNewTexture:Bool = false;

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
			return get_text();
		}
		this._text = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		this.dispatchEventWith(Event.CHANGE);
		return get_text();
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
	private var _previousTextFormat:TextFormat;

	/**
	 * @private
	 */
	private var _textFormat:TextFormat;

	/**
	 * The format of the text, such as font and styles.
	 *
	 * <p>In the following example, the text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.textFormat = new TextFormat( "Source Sans Pro" );;</listing>
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
		//since the text format has changed, the comparison will return
		//false whether we use the real previous format or null. might as
		//well remove the reference to an object we don't need anymore.
		this._previousTextFormat = null;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
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
	 * textEditor.isEnabled = false;
	 * textEditor.disabledTextFormat = new TextFormat( "Source Sans Pro" );</listing>
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_disabledTextFormat();
	}

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
	 * textEditor.embedFonts = true;</listing>
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_embedFonts();
	}

	/**
	 * @private
	 */
	private var _wordWrap:Bool = false;

	/**
	 * Determines if the TextField wraps text to the next line.
	 *
	 * <p>In the following example, word wrap is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.wordWrap = true;</listing>
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
			return get_wordWrap();
		}
		this._wordWrap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_wordWrap();
	}

	/**
	 * @private
	 */
	private var _multiline:Bool = false;

	/**
	 * Indicates whether field is a multiline text field.
	 *
	 * <p>In the following example, multiline is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.multiline = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#multiline Full description of openfl.text.TextField.multiline in Adobe's Flash Platform API Reference
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
			return get_multiline();
		}
		this._multiline = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_multiline();
	}

	/**
	 * @private
	 */
	private var _isHTML:Bool = false;

	/**
	 * Determines if the TextField should display the value of the
	 * <code>text</code> property as HTML or not.
	 *
	 * <p>In the following example, the text is displayed as HTML:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.isHTML = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText openfl.text.TextField.htmlText
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_isHTML();
	}

	/**
	 * @private
	 */
	private var _alwaysShowSelection:Bool = false;

	/**
	 * When set to <code>true</code> and the text field is not in focus,
	 * Flash Player highlights the selection in the text field in gray. When
	 * set to <code>false</code> and the text field is not in focus, Flash
	 * Player does not highlight the selection in the text field.
	 *
	 * <p>In the following example, the selection is always shown:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.alwaysShowSelection = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#alwaysShowSelection Full description of openfl.text.TextField.alwaysShowSelection in Adobe's Flash Platform API Reference
	 */
	public var alwaysShowSelection(get, set):Bool;
	public function get_alwaysShowSelection():Bool
	{
		return this._alwaysShowSelection;
	}

	/**
	 * @private
	 */
	public function set_alwaysShowSelection(value:Bool):Bool
	{
		if(this._alwaysShowSelection == value)
		{
			return get_alwaysShowSelection();
		}
		this._alwaysShowSelection = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_alwaysShowSelection();
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
	 * <p>In the following example, the text is displayed as as password:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.fontWeight = FontWeight.BOLD;</listing>
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
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_displayAsPassword();
	}

	/**
	 * @private
	 */
	private var _maxChars:Int = 0;

	/**
	 * The maximum number of characters that the text field can contain, as
	 * entered by a user. A script can insert more text than <code>maxChars</code>
	 * allows. If the value of this property is <code>0</code>, a user can
	 * enter an unlimited amount of text.
	 *
	 * <p>In the following example, the maximum character count is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.maxChars = 10;</listing>
	 *
	 * @default 0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#maxChars Full description of openfl.text.TextField.maxChars in Adobe's Flash Platform API Reference
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
			return get_maxChars();
		}
		this._maxChars = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_maxChars();
	}

	/**
	 * @private
	 */
	@:native("_restrict1")
	private var _restrict:String;

	/**
	 * Indicates the set of characters that a user can enter into the text
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
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of openfl.text.TextField.restrict in Adobe's Flash Platform API Reference
	 */
	public var restrict(get, set):String;
	public function get_restrict():String
	{
		return this._restrict;
	}

	/**
	 * @private
	 */
	public function set_restrict(value:String):String
	{
		if(this._restrict == value)
		{
			return get_restrict();
		}
		this._restrict = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_restrict();
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
			return get_isEditable();
		}
		this._isEditable = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_isEditable();
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
	 * @default flash.text.AntiAliasType.ADVANCED
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#antiAliasType Full description of flash.text.TextField.antiAliasType in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/AntiAliasType.html flash.text.AntiAliasType
	 * @see #embedFonts
	 */
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
	private var _gridFitType:GridFitType = GridFitType.PIXEL;

	/**
	 * Determines whether Flash Player forces strong horizontal and vertical
	 * lines to fit to a pixel or subpixel grid, or not at all using the
	 * constants defined in the <code>flash.text.GridFitType</code> class.
	 * This property applies only if the <code>antiAliasType</code> property
	 * of the text field is set to <code>flash.text.AntiAliasType.ADVANCED</code>.
	 *
	 * <p>In the following example, the grid fit type is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.gridFitType = GridFitType.SUBPIXEL;</listing>
	 *
	 * @default flash.text.GridFitType.PIXEL
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#gridFitType Full description of flash.text.TextField.gridFitType in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/GridFitType.html flash.text.GridFitType
	 * @see #antiAliasType
	 */
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
	 * field is set to <code>flash.text.AntiAliasType.ADVANCED</code>. The
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
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#sharpness Full description of flash.text.TextField.sharpness in Adobe's Flash Platform API Reference
	 * @see #antiAliasType
	 */
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
	 * <code>flash.text.AntiAliasType.ADVANCED</code>. The range for
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
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#thickness Full description of flash.text.TextField.thickness in Adobe's Flash Platform API Reference
	 * @see #antiAliasType
	 */
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
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#background Full description of flash.text.TextField.background in Adobe's Flash Platform API Reference
	 * @see #backgroundColor
	 */
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
	 * textRenderer.background = true;
	 * textRenderer.backgroundColor = 0xff000ff;</listing>
	 *
	 * @default 0xffffff
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#backgroundColor Full description of flash.text.TextField.backgroundColor in Adobe's Flash Platform API Reference
	 * @see #background
	 */
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
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#border Full description of flash.text.TextField.border in Adobe's Flash Platform API Reference
	 * @see #borderColor
	 */
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
	 * textRenderer.border = true;
	 * textRenderer.borderColor = 0xff00ff;</listing>
	 *
	 * @default 0x000000
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#borderColor Full description of flash.text.TextField.borderColor in Adobe's Flash Platform API Reference
	 * @see #border
	 */
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
			return get_useGutter();
		}
		this._useGutter = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_useGutter();
	}

	/**
	 * @inheritDoc
	 */
	public var setTouchFocusOnEndedPhase(get, never):Bool;
	public function get_setTouchFocusOnEndedPhase():Bool
	{
		return false;
	}

	/**
	 * @private
	 */
	private var _textFieldHasFocus:Bool = false;

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
		if(this.textField != null)
		{
			return this.textField.selectionBeginIndex;
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
		if(this.textField != null)
		{
			return this.textField.selectionEndIndex;
		}
		return 0;
	}

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
	 * textEditor.useSnapshotDelayWorkaround = true;</listing>
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
			return get_useSnapshotDelayWorkaround();
		}
		this._useSnapshotDelayWorkaround = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		return get_useSnapshotDelayWorkaround();
	}

	/**
	 * @private
	 */
	private var resetScrollOnFocusOut:Bool = true;

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this.textSnapshot != null)
		{
			//avoid the need to call dispose(). we'll create a new snapshot
			//when the renderer is added to stage again.
			this.textSnapshot.texture.dispose();
			this.removeChild(this.textSnapshot, true);
			this.textSnapshot = null;
		}

		if(this.textField != null && this.textField.parent != null)
		{
			this.textField.parent.removeChild(this.textField);
		}
		//this isn't necessary, but if a memory leak keeps the text renderer
		//from being garbage collected, freeing up the text field may help
		//ease major memory pressure from native filters
		this.textField = null;
		this.measureTextField = null;

		super.dispose();
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		if(this.textSnapshot != null)
		{
			if(this._updateSnapshotOnScaleChange)
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
			this.positionSnapshot();
		}
		//we'll skip this if the text field isn't visible to avoid running
		//that code every frame.
		if(this.textField != null && this.textField.visible)
		{
			this.transformTextField();
		}
		super.render(support, parentAlpha);
	}

	/**
	 * @inheritDoc
	 */
	public function setFocus(position:Point = null):Void
	{
		if(this.textField != null)
		{
			if(this.textField.parent == null)
			{
				Starling.current.nativeStage.addChild(this.textField);
			}
			if(position != null)
			{
				var gutterPositionOffset:Float = 2;
				if(this._useGutter)
				{
					gutterPositionOffset = 0;
				}
				var positionX:Float = position.x - this.textSnapshot.x + gutterPositionOffset;
				var positionY:Float = position.y - this.textSnapshot.y + gutterPositionOffset;
				if(positionX < 0)
				{
					this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = 0;
				}
				else
				{
					this._pendingSelectionBeginIndex = this.getSelectionIndexAtPoint(positionX, positionY);
					if(this._pendingSelectionBeginIndex < 0)
					{
						if(this._multiline)
						{
							var lineIndex:Int = Std.int(positionY / this.textField.getLineMetrics(0).height) + (this.textField.scrollV - 1);
							try
							{
								this._pendingSelectionBeginIndex = this.textField.getLineOffset(lineIndex)#if flash + this.textField.getLineLength(lineIndex) #end;
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
							this._pendingSelectionBeginIndex = this.getSelectionIndexAtPoint(positionX, this.textField.getLineMetrics(0).ascent / 2);
							if(this._pendingSelectionBeginIndex < 0)
							{
								this._pendingSelectionBeginIndex = this._text.length;
							}
						}
					}
					else
					{
						var bounds:Rectangle = this.textField.getCharBoundaries(this._pendingSelectionBeginIndex);
						//bounds should never be null because the character
						//index passed to getCharBoundaries() comes from a
						//call to getCharIndexAtPoint(). however, a user
						//reported that a null reference error happened
						//here! I couldn't reproduce, but I might as well
						//assume that the runtime has a bug. won't hurt.
						if(bounds != null)
						{
							var boundsX:Float = bounds.x;
							if(bounds != null && (boundsX + bounds.width - positionX) < (positionX - boundsX))
							{
								this._pendingSelectionBeginIndex++;
							}
						}
					}
					this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
				}
			}
			else
			{
				this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
			}
			if(!FocusManager.isEnabledForStage(this.stage))
			{
				Starling.current.nativeStage.focus = this.textField;
			}
			this.textField.requestSoftKeyboard();
			if(this._textFieldHasFocus)
			{
				this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
			}
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
		if(!this._textFieldHasFocus)
		{
			return;
		}
		var nativeStage:Stage = Starling.current.nativeStage;
		if(nativeStage.focus == this.textField)
		{
			//only clear the native focus when our native target has focus
			//because otherwise another component may lose focus.
			
			//don't set focus to null here. the focus manager will interpret
			//that as the runtime automatically clearing focus for other
			//reasons.
			nativeStage.focus = nativeStage;
		}
	}

	/**
	 * @inheritDoc
	 */
	public function selectRange(beginIndex:Int, endIndex:Int):Void
	{
		if(this.textField != null)
		{
			if(!this._isValidating)
			{
				this.validate();
			}
			this.textField.setSelection(beginIndex, endIndex);
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

		this.commit();

		result = this.measure(result);

		return result;
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this.textField = new TextField();
		//let's ensure that the text field can only get keyboard focus
		//through code. no need to set mouseEnabled to false since the text
		//field won't be visible until it needs to be interactive, so it
		//can't receive focus with mouse/touch anyway.
		this.textField.tabEnabled = false;
		this.textField.visible = false;
		this.textField.needsSoftKeyboard = true;
		this.textField.addEventListener(openfl.events.Event.CHANGE, textField_changeHandler);
		this.textField.addEventListener(FocusEvent.FOCUS_IN, textField_focusInHandler);
		this.textField.addEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
		this.textField.addEventListener(KeyboardEvent.KEY_DOWN, textField_keyDownHandler);
		#if flash
		this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, textField_softKeyboardActivateHandler);
		this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, textField_softKeyboardDeactivateHandler);
		#end

		this.measureTextField = new TextField();
		this.measureTextField.autoSize = TextFieldAutoSize.LEFT;
		this.measureTextField.selectable = false;
		this.measureTextField.tabEnabled = false;
		#if flash
		this.measureTextField.mouseWheelEnabled = false;
		#end
		this.measureTextField.mouseEnabled = false;
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
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);

		if(dataInvalid || stylesInvalid || stateInvalid)
		{
			this.commitStylesAndData(this.textField);
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
	private function measure(result:Point = null):Point
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

		this.commitStylesAndData(this.measureTextField);

		var gutterDimensionsOffset:Float = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}

		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			this.measureTextField.wordWrap = false;
			newWidth = this.measureTextField.width - gutterDimensionsOffset;
			if(newWidth < this._minWidth)
			{
				newWidth = this._minWidth;
			}
			else if(newWidth > this._maxWidth)
			{
				newWidth = this._maxWidth;
			}
		}

		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			this.measureTextField.wordWrap = this._wordWrap;
			this.measureTextField.width = newWidth + gutterDimensionsOffset;
			newHeight = this.measureTextField.height - gutterDimensionsOffset;
			if(this._useGutter)
			{
				newHeight += 4;
			}
			if(newHeight < this._minHeight)
			{
				newHeight = this._minHeight;
			}
			else if(newHeight > this._maxHeight)
			{
				newHeight = this._maxHeight;
			}
		}

		result.x = newWidth;
		result.y = newHeight;

		return result;
	}

	/**
	 * @private
	 */
	private function commitStylesAndData(textField:TextField):Void
	{
		textField.antiAliasType = this._antiAliasType;
		textField.background = this._background;
		textField.backgroundColor = this._backgroundColor;
		textField.border = this._border;
		textField.borderColor = this._borderColor;
		textField.gridFitType = this._gridFitType;
		textField.sharpness = this._sharpness;
		#if flash
		textField.thickness = this._thickness;
		#end
		textField.maxChars = this._maxChars;
		textField.restrict = this._restrict;
		#if flash
		textField.alwaysShowSelection = this._alwaysShowSelection;
		#end
		textField.displayAsPassword = this._displayAsPassword;
		textField.wordWrap = this._wordWrap;
		textField.multiline = this._multiline;
		textField.embedFonts = this._embedFonts;
		textField.type = this._isEditable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		textField.selectable = this._isEnabled;
		var isFormatDifferent:Bool = false;
		var currentTextFormat:TextFormat;
		if(!this._isEnabled && this._disabledTextFormat != null)
		{
			currentTextFormat = this._disabledTextFormat;
		}
		else
		{
			currentTextFormat = this._textFormat;
		}
		if(currentTextFormat != null)
		{
			//for some reason, textField.defaultTextFormat always fails
			//comparison against currentTextFormat. if we save to a member
			//variable and compare against that instead, it works.
			//I guess text field creates a different TextFormat object.
			isFormatDifferent = this._previousTextFormat != currentTextFormat;
			this._previousTextFormat = currentTextFormat;
			textField.defaultTextFormat = currentTextFormat;
		}
		if(this._isHTML)
		{
			if(isFormatDifferent || textField.htmlText != this._text)
			{
				if(textField == this.textField && this._pendingSelectionBeginIndex < 0)
				{
					this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
					this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
				}
				textField.htmlText = this._text;
			}
		}
		else
		{
			if(isFormatDifferent || textField.text != this._text)
			{
				if(textField == this.textField && this._pendingSelectionBeginIndex < 0)
				{
					this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
					this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
				}
				textField.text = this._text;
			}
		}
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
			this.refreshSnapshotParameters();
			this.refreshTextFieldSize();
			this.transformTextField();
			this.positionSnapshot();
		}

		this.checkIfNewSnapshotIsNeeded();

		if(!this._textFieldHasFocus && (sizeInvalid || stylesInvalid || dataInvalid || stateInvalid || this._needsNewTexture))
		{
			if(this._useSnapshotDelayWorkaround)
			{
				//sometimes, we need to wait a frame for flash.text.TextField
				//to render properly when drawing to BitmapData.
				this.addEventListener(Event.ENTER_FRAME, refreshSnapshot_enterFrameHandler);
			}
			else
			{
				this.refreshSnapshot();
			}
		}
		this.doPendingActions();
	}

	/**
	 * @private
	 */
	private function getSelectionIndexAtPoint(pointX:Float, pointY:Float):Int
	{
		return this.textField.getCharIndexAtPoint(pointX, pointY);
	}

	/**
	 * @private
	 */
	private function refreshTextFieldSize():Void
	{
		var gutterDimensionsOffset:Float = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}
		this.textField.width = this.actualWidth + gutterDimensionsOffset;
		this.textField.height = this.actualHeight + gutterDimensionsOffset;
	}

	/**
	 * @private
	 */
	private function refreshSnapshotParameters():Void
	{
		this._textFieldOffsetX = 0;
		this._textFieldOffsetY = 0;
		this._textFieldSnapshotClipRect.x = 0;
		this._textFieldSnapshotClipRect.y = 0;

		var scaleFactor:Float = Starling.current.contentScaleFactor;
		var clipWidth:Float = this.actualWidth * scaleFactor;
		if(this._updateSnapshotOnScaleChange)
		{
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			clipWidth *= matrixToScaleX(HELPER_MATRIX);
		}
		if(clipWidth < 0)
		{
			clipWidth = 0;
		}
		var clipHeight:Float = this.actualHeight * scaleFactor;
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
	private function transformTextField():Void
	{
		//there used to be some code here that returned immediately if the
		//TextField wasn't visible. some mobile devices displayed the text
		//at the wrong scale if the TextField weren't transformed before
		//being made visible, so I had to remove it. I moved the visible
		//check into render(), since it can still benefit from the
		//optimization there. see issue #1104.
		
		HELPER_POINT.x = HELPER_POINT.y = 0;
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		var globalScaleX:Float = matrixToScaleX(HELPER_MATRIX);
		var globalScaleY:Float = matrixToScaleY(HELPER_MATRIX);
		var smallerGlobalScale:Float = globalScaleX;
		if(globalScaleY < smallerGlobalScale)
		{
			smallerGlobalScale = globalScaleY;
		}
		if(this.is3D)
		{
			HELPER_MATRIX3D = this.getTransformationMatrix3D(this.stage, HELPER_MATRIX3D);
			HELPER_POINT3D = MatrixUtil.transformCoords3D(HELPER_MATRIX3D, 0, 0, 0, HELPER_POINT3D);
			HELPER_POINT.setTo(HELPER_POINT3D.x, HELPER_POINT3D.y);
		}
		else
		{
			MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
		}
		var starlingViewPort:Rectangle = Starling.current.viewPort;
		var nativeScaleFactor:Float = 1;
		#if flash
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
		#end
		var scaleFactor:Float = Starling.current.contentScaleFactor / nativeScaleFactor;
		var gutterPositionOffset:Float = 0;
		if(!this._useGutter)
		{
			gutterPositionOffset = 2 * smallerGlobalScale;
		}
		this.textField.x = Math.round(starlingViewPort.x + (HELPER_POINT.x * scaleFactor) - gutterPositionOffset);
		this.textField.y = Math.round(starlingViewPort.y + (HELPER_POINT.y * scaleFactor) - gutterPositionOffset);
		this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / Math.PI;
		this.textField.scaleX = matrixToScaleX(HELPER_MATRIX) * scaleFactor;
		this.textField.scaleY = matrixToScaleY(HELPER_MATRIX) * scaleFactor;
	}

	/**
	 * @private
	 */
	private function positionSnapshot():Void
	{
		if(this.textSnapshot == null)
		{
			return;
		}
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
		this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
	}

	/**
	 * @private
	 */
	private function checkIfNewSnapshotIsNeeded():Void
	{
		var canUseRectangleTexture:Bool = Starling.current.profile != Context3DProfile.BASELINE_CONSTRAINED;
		if(canUseRectangleTexture)
		{
			this._snapshotWidth = Std.int(this._textFieldSnapshotClipRect.width);
			this._snapshotHeight = Std.int(this._textFieldSnapshotClipRect.height);
		}
		else
		{
			this._snapshotWidth = getNextPowerOfTwo(Std.int(this._textFieldSnapshotClipRect.width));
			this._snapshotHeight = getNextPowerOfTwo(Std.int(this._textFieldSnapshotClipRect.height));
		}
		var textureRoot:ConcreteTexture = this.textSnapshot != null ? this.textSnapshot.texture.root : null;
		this._needsNewTexture = this._needsNewTexture || this.textSnapshot == null ||
		textureRoot.scale != Starling.current.contentScaleFactor ||
		this._snapshotWidth != textureRoot.width || this._snapshotHeight != textureRoot.height;
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
			var endIndex:Int = this._pendingSelectionEndIndex;
			this._pendingSelectionBeginIndex = -1;
			this._pendingSelectionEndIndex = -1;
			this.selectRange(startIndex, endIndex);
		}
	}

	/**
	 * @private
	 */
	private function texture_onRestore():Void
	{
		if(this.textSnapshot != null && this.textSnapshot.texture != null &&
			this.textSnapshot.texture.scale != Starling.current.contentScaleFactor)
		{
			//if we've changed between scale factors, we need to recreate
			//the texture to match the new scale factor.
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		else
		{
			this.refreshSnapshot();
		}
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
		var gutterPositionOffset:Float = 2;
		if(this._useGutter)
		{
			gutterPositionOffset = 0;
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
		HELPER_MATRIX.translate(this._textFieldOffsetX - gutterPositionOffset, this._textFieldOffsetY - gutterPositionOffset);
		HELPER_MATRIX.scale(scaleFactor, scaleFactor);
		if(this._updateSnapshotOnScaleChange)
		{
			HELPER_MATRIX.scale(globalScaleX, globalScaleY);
		}
		var bitmapData:BitmapData = new BitmapData(this._snapshotWidth, this._snapshotHeight, true, 0x00ff00ff);
		bitmapData.draw(this.textField, HELPER_MATRIX, null, null, this._textFieldSnapshotClipRect);
		var newTexture:Texture = null;
		if(this.textSnapshot == null || this._needsNewTexture)
		{
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
		if(this._updateSnapshotOnScaleChange)
		{
			this.textSnapshot.scaleX = 1 / globalScaleX;
			this.textSnapshot.scaleY = 1 / globalScaleY;
			this._lastGlobalScaleX = globalScaleX;
			this._lastGlobalScaleY = globalScaleY;
		}
		this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
		bitmapData.dispose();
		this._needsNewTexture = false;
	}

	/**
	 * @private
	 */
	private function textEditor_addedToStageHandler(event:Event):Void
	{
		if(this.textField.parent == null)
		{
			//the text field needs to be on the native stage to measure properly
			Starling.current.nativeStage.addChild(this.textField);
		}
	}

	/**
	 * @private
	 */
	private function textEditor_removedFromStageHandler(event:Event):Void
	{
		if(this.textField.parent != null)
		{
			//remove this from the stage, if needed
			//it will be added back next time we receive focus
			this.textField.parent.removeChild(this.textField);
		}
	}

	/**
	 * @private
	 */
	private function hasFocus_enterFrameHandler(event:Event):Void
	{
		if(this.textSnapshot != null)
		{
			this.textSnapshot.visible = !this._textFieldHasFocus;
		}
		this.textField.visible = this._textFieldHasFocus;

		if(this._textFieldHasFocus)
		{
			var target:DisplayObject = this;
			do
			{
				if(!target.hasVisibleArea)
				{
					this.clearFocus();
					break;
				}
				target = target.parent;
			}
			while(target != null);
		}
		else
		{
			this.removeEventListener(Event.ENTER_FRAME, hasFocus_enterFrameHandler);
		}
	}

	/**
	 * @private
	 */
	private function refreshSnapshot_enterFrameHandler(event:Event):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, refreshSnapshot_enterFrameHandler);
		this.refreshSnapshot();
	}

	/**
	 * @private
	 */
	private function stage_touchHandler(event:TouchEvent):Void
	{
		var touch:Touch = event.getTouch(this.stage, TouchPhase.BEGAN);
		if(touch == null) //we only care about began touches
		{
			return;
		}
		touch.getLocation(this.stage, HELPER_POINT);
		var isInBounds:Bool = this.contains(this.stage.hitTest(HELPER_POINT, true));
		if(isInBounds) //if the touch is in the text editor, it's all good
		{
			return;
		}
		//if the touch begins anywhere else, it's a focus out!
		this.clearFocus();
	}

	/**
	 * @private
	 */
	private function textField_changeHandler(event:flash.events.Event):Void
	{
		if(this._isHTML)
		{
			this.text = this.textField.htmlText;
		}
		else
		{
			this.text = this.textField.text;
		}
	}

	/**
	 * @private
	 */
	private function textField_focusInHandler(event:FocusEvent):Void
	{
		this._textFieldHasFocus = true;
		this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
		this.addEventListener(Event.ENTER_FRAME, hasFocus_enterFrameHandler);
		this.dispatchEventWith(FeathersEventType.FOCUS_IN);
	}

	/**
	 * @private
	 */
	private function textField_focusOutHandler(event:FocusEvent):Void
	{
		this._textFieldHasFocus = false;
		this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);

		if(this.resetScrollOnFocusOut)
		{
			this.textField.scrollH = this.textField.scrollV = 0;
		}

		//the text may have changed, so we invalidate the data flag
		this.invalidate(INVALIDATION_FLAG_DATA);
		this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
	}

	/**
	 * @private
	 */
	private function textField_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.keyCode == Keyboard.ENTER)
		{
			this.dispatchEventWith(FeathersEventType.ENTER);
		}
		else if(!FocusManager.isEnabledForStage(this.stage) && event.keyCode == Keyboard.TAB)
		{
			this.clearFocus();
		}
	}

	/**
	 * @private
	 */
	#if flash
	private function textField_softKeyboardActivateHandler(event:SoftKeyboardEvent):Void
	{
		this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE, true);
	}
	#end

	/**
	 * @private
	 */
	#if flash
	private function textField_softKeyboardDeactivateHandler(event:SoftKeyboardEvent):Void
	{
		this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_DEACTIVATE, true);
	}
	#end
}
