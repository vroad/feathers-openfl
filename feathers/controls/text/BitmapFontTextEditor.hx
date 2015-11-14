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
import feathers.utils.text.TextInputNavigation;
import feathers.utils.text.TextInputRestrict;

import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.TextEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.BitmapChar;
import starling.text.BitmapFont;

import feathers.core.FeathersControl.INVALIDATION_FLAG_SELECTED;
import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;

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
 * Dispatched when the user presses the Enter key while the editor has
 * focus.
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
 * Renders text using <code>starling.text.BitmapFont</code> that may be
 * edited at runtime by the user.
 *
 * <p><strong>Warning:</strong> This text editor is intended for use in
 * desktop applications only, and it does not provide support for software
 * keyboards on mobile devices.</p>
 *
 * @see ../../../help/text-editors.html Introduction to Feathers text editors
 * @see http://doc.starling-framework.org/core/starling/text/BitmapFont.html starling.text.BitmapFont
 */
class BitmapFontTextEditor extends BitmapFontTextRenderer implements ITextEditor implements INativeFocusOwner
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	inline private static var LINE_FEED:String = "\n";

	/**
	 * @private
	 */
	inline private static var CARRIAGE_RETURN:String = "\r";

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this._text = "";
		this.isQuickHitAreaEnabled = true;
		this.truncateToFit = false;
		this.addEventListener(TouchEvent.TOUCH, textEditor_touchHandler);
	}

	/**
	 * @private
	 */
	private var _selectionSkin:DisplayObject;

	/**
	 *
	 */
	public var selectionSkin(get, set):DisplayObject;
	public function get_selectionSkin():DisplayObject
	{
		return this._selectionSkin;
	}

	/**
	 * @private
	 */
	public function set_selectionSkin(value:DisplayObject):DisplayObject
	{
		if(this._selectionSkin == value)
		{
			return get_selectionSkin();
		}
		if(this._selectionSkin != null && this._selectionSkin.parent == this)
		{
			this._selectionSkin.removeFromParent();
		}
		this._selectionSkin = value;
		if(this._selectionSkin != null)
		{
			this._selectionSkin.visible = false;
			this.addChildAt(this._selectionSkin, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_selectionSkin();
	}

	/**
	 * @private
	 */
	private var _cursorSkin:DisplayObject;

	/**
	 *
	 */
	public var cursorSkin(get, set):DisplayObject;
	public function get_cursorSkin():DisplayObject
	{
		return this._cursorSkin;
	}

	/**
	 * @private
	 */
	public function set_cursorSkin(value:DisplayObject):DisplayObject
	{
		if(this._cursorSkin == value)
		{
			return get_cursorSkin();
		}
		if(this._cursorSkin != null && this._cursorSkin.parent == this)
		{
			this._cursorSkin.removeFromParent();
		}
		this._cursorSkin = value;
		if(this._cursorSkin != null)
		{
			this._cursorSkin.visible = false;
			this.addChild(this._cursorSkin);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_cursorSkin();
	}

	/**
	 * @private
	 */
	private var _unmaskedText:String;

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
	 * @see #passwordCharCode
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
		if(this._displayAsPassword)
		{
			this._unmaskedText = this._text;
			this.refreshMaskedText();
		}
		else
		{
			this._text = this._unmaskedText;
			this._unmaskedText = null;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_displayAsPassword();
	}

	/**
	 * @private
	 */
	private var _passwordCharCode:Int = 42; //asterisk

	/**
	 * The character code of the character used to display a password.
	 *
	 * <p>In the following example, the substitute character for passwords
	 * is set to a bullet:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.displayAsPassword = true;
	 * textEditor.passwordCharCode = "•".charCodeAt(0);</listing>
	 *
	 * @default 42 (asterisk)
	 *
	 * @see #displayAsPassword
	 */
	public var passwordCharCode(get, set):Int;
	public function get_passwordCharCode():Int
	{
		return this._passwordCharCode;
	}

	/**
	 * @private
	 */
	public function set_passwordCharCode(value:Int):Int
	{
		if(this._passwordCharCode == value)
		{
			return get_passwordCharCode();
		}
		this._passwordCharCode = value;
		if(this._displayAsPassword)
		{
			this.refreshMaskedText();
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_passwordCharCode();
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
	 * @inheritDoc
	 *
	 * @default false
	 */
	public var setTouchFocusOnEndedPhase(get, never):Bool;
	public function get_setTouchFocusOnEndedPhase():Bool
	{
		return false;
	}

	/**
	 * @private
	 */
	override public function get_text():String
	{
		if(this._displayAsPassword)
		{
			return this._unmaskedText;
		}
		return this._text;
	}

	/**
	 * @private
	 */
	override public function set_text(value:String):String
	{
		if(value == null)
		{
			//don't allow null or undefined
			value = "";
		}
		var currentValue:String = this._text;
		if(this._displayAsPassword)
		{
			currentValue = this._unmaskedText;
		}
		if(currentValue == value)
		{
			return get_text();
		}
		if(this._displayAsPassword)
		{
			this._unmaskedText = value;
			this.refreshMaskedText();
		}
		else
		{
			this._text = value;
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
		var textLength:Int = this._text.length;
		//we need to account for the possibility that the text is in the
		//middle of being selected when it changes
		if(this._selectionAnchorIndex > textLength)
		{
			this._selectionAnchorIndex = textLength;
		}
		//then, we need to make sure the selected range is still valid
		if(this._selectionBeginIndex > textLength)
		{
			this.selectRange(textLength, textLength);
		}
		else if(this._selectionEndIndex > textLength)
		{
			this.selectRange(this._selectionBeginIndex, textLength);
		}
		this.dispatchEventWith(starling.events.Event.CHANGE);
		return get_text();
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
	private var _restrict:TextInputRestrict;

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
	 */
	public var restrict(get, set):String;
	public function get_restrict():String
	{
		if(this._restrict == null)
		{
			return null;
		}
		return this._restrict.restrict;
	}

	/**
	 * @private
	 */
	public function set_restrict(value:String):String
	{
		if(this._restrict != null && this._restrict.restrict == value)
		{
			return get_restrict();
		}
		if(this._restrict == null && value == null)
		{
			return get_restrict();
		}
		if(value == null)
		{
			this._restrict = null;
		}
		else
		{
			if(this._restrict != null)
			{
				this._restrict.restrict = value;
			}
			else
			{

				this._restrict = new TextInputRestrict(value);
			}
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_restrict();
	}

	/**
	 * @private
	 */
	private var _selectionBeginIndex:Int = 0;

	/**
	 * @inheritDoc
	 */
	public var selectionBeginIndex(get, never):Int;
	public function get_selectionBeginIndex():Int
	{
		return this._selectionBeginIndex;
	}

	/**
	 * @private
	 */
	private var _selectionEndIndex:Int = 0;

	/**
	 * @inheritDoc
	 */
	public var selectionEndIndex(get, never):Int;
	public function get_selectionEndIndex():Int
	{
		return this._selectionEndIndex;
	}

	/**
	 * @private
	 */
	private var _selectionAnchorIndex:Int = -1;

	/**
	 * @private
	 */
	private var _scrollX:Float = 0;

	/**
	 * @private
	 */
	private var touchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _nativeFocus:Sprite;

	/**
	 * @copy feathers.core.INativeFocusOwner#nativeFocus
	 */
	public var nativeFocus(get, never):InteractiveObject;
	public function get_nativeFocus():InteractiveObject
	{
		return this._nativeFocus;
	}

	/**
	 * @private
	 */
	private var _isWaitingToSetFocus:Bool = false;

	/**
	 * @inheritDoc
	 */
	public function setFocus(position:Point = null):Void
	{
		//we already have focus, so there's no reason to change
		if(this._hasFocus && position == null)
		{
			return;
		}
		if(this._nativeFocus != null)
		{
			if(this._nativeFocus.parent == null)
			{
				Starling.current.nativeStage.addChild(this._nativeFocus);
			}
			var newIndex:Int = -1;
			if(position != null)
			{
				newIndex = this.getSelectionIndexAtPoint(position.x, position.y);
			}
			if(newIndex >= 0)
			{
				this.selectRange(newIndex, newIndex);
			}
			this.focusIn();
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
		if(!this._hasFocus)
		{
			return;
		}
		this._hasFocus = false;
		this._cursorSkin.visible = false;
		this._selectionSkin.visible = false;
		this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		this.removeEventListener(starling.events.Event.ENTER_FRAME, hasFocus_enterFrameHandler);
		var nativeStage:Stage = Starling.current.nativeStage;
		if(nativeStage.focus == this._nativeFocus)
		{
			//only clear the native focus when our native target has focus
			//because otherwise another component may lose focus.

			//don't set focus to null here. the focus manager will interpret
			//that as the runtime automatically clearing focus for other
			//reasons.
			nativeStage.focus = nativeStage;
		}
		this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
	}

	/**
	 * @inheritDoc
	 */
	public function selectRange(beginIndex:Int, endIndex:Int):Void
	{
		if(endIndex < beginIndex)
		{
			var temp:Int = endIndex;
			endIndex = beginIndex;
			beginIndex = temp;
		}
		this._selectionBeginIndex = beginIndex;
		this._selectionEndIndex = endIndex;
		if(beginIndex == endIndex)
		{
			if(beginIndex < 0)
			{
				this._cursorSkin.visible = false;
			}
			else
			{
				this._cursorSkin.visible = this._hasFocus;
			}
			this._selectionSkin.visible = false;
		}
		else
		{
			this._cursorSkin.visible = false;
			this._selectionSkin.visible = true;
		}
		this.invalidate(INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this._nativeFocus != null && this._nativeFocus.parent != null)
		{
			this._nativeFocus.parent.removeChild(this._nativeFocus);
		}
		this._nativeFocus = null;
		super.dispose();
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		var oldBatchX:Float = this._batchX;
		var oldCursorX:Float = this._cursorSkin.x;
		this._batchX -= this._scrollX;
		this._cursorSkin.x -= this._scrollX;
		super.render(support, parentAlpha);
		this._batchX = oldBatchX;
		this._cursorSkin.x = oldCursorX;
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(this._nativeFocus == null)
		{
			this._nativeFocus = new Sprite();
			//let's ensure that this can only get focus through code
			this._nativeFocus.tabEnabled = false;
			this._nativeFocus.tabChildren = false;
			this._nativeFocus.mouseEnabled = false;
			this._nativeFocus.mouseChildren = false;
			//adds support for mobile
			this._nativeFocus.needsSoftKeyboard = true;
		}
		#if flash
		this._nativeFocus.addEventListener(flash.events.Event.CUT, nativeFocus_cutHandler, false, 0, true);
		this._nativeFocus.addEventListener(flash.events.Event.COPY, nativeFocus_copyHandler, false, 0, true);
		this._nativeFocus.addEventListener(flash.events.Event.PASTE, nativeFocus_pasteHandler, false, 0, true);
		this._nativeFocus.addEventListener(flash.events.Event.SELECT_ALL, nativeFocus_selectAllHandler, false, 0, true);
		#end
		this._nativeFocus.addEventListener(TextEvent.TEXT_INPUT, nativeFocus_textInputHandler, false, 0, true);
		if(this._cursorSkin == null)
		{
			this.cursorSkin = new Quad(1, 1, 0x000000);
		}
		if(this._selectionSkin == null)
		{
			this.selectionSkin = new Quad(1, 1, 0x000000);
		}
		super.initialize();
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var selectionInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SELECTED);
		
		super.draw();
		
		if(dataInvalid || selectionInvalid)
		{
			this.positionCursorAtCharIndex(this.getCursorIndexFromSelectionRange());
			this.positionSelectionBackground();
		}

		var clipRect:Rectangle = this.clipRect;
		if(clipRect != null)
		{
			clipRect.setTo(0, 0, this.actualWidth, this.actualHeight);
		}
		else
		{
			this.clipRect = new Rectangle(0, 0, this.actualWidth, this.actualHeight);
		}
	}

	/**
	 * @private
	 */
	override private function layoutCharacters(result:Point = null):Point
	{
		result = super.layoutCharacters(result);
		if(this.explicitWidth == this.explicitWidth && //!isNaN
			result.x > this.explicitWidth)
		{
			this._characterBatch.reset();
			var oldTextAlign:TextFormatAlign = this.currentTextFormat.align;
			this.currentTextFormat.align = TextFormatAlign.LEFT;
			result = super.layoutCharacters(result);
			this.currentTextFormat.align = oldTextAlign;
		}
		return result;
	}

	/**
	 * @private
	 */
	override private function refreshTextFormat():Void
	{
		super.refreshTextFormat();
		if(this._cursorSkin != null)
		{
			var font:BitmapFont = this.currentTextFormat.font;
			var customSize:Float = this.currentTextFormat.size;
			var scale:Float = customSize / font.size;
			if(scale != scale) //isNaN
			{
				scale = 1;
			}
			this._cursorSkin.height = font.lineHeight * scale;
		}
	}

	/**
	 * @private
	 */
	private function refreshMaskedText():Void
	{
		this._text = "";
		var textLength:Int = this._unmaskedText.length;
		var maskChar:String = String.fromCharCode(this._passwordCharCode);
		for(i in 0 ... textLength)
		{
			this._text += maskChar;
		}
	}

	/**
	 * @private
	 */
	private function focusIn():Void
	{
		var showCursor:Bool = this._selectionBeginIndex >= 0 && this._selectionBeginIndex == this._selectionEndIndex;
		this._cursorSkin.visible = showCursor;
		this._selectionSkin.visible = !showCursor;
		if(!FocusManager.isEnabledForStage(this.stage))
		{
			//if there isn't a focus manager, we need to set focus manually
			Starling.current.nativeStage.focus = this._nativeFocus;
		}
		this._nativeFocus.requestSoftKeyboard();
		if(this._hasFocus)
		{
			return;
		}
		//we're reusing this variable. since this isn't a display object
		//that the focus manager can see, it's not being used anyway.
		this._hasFocus = true;
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		this.addEventListener(starling.events.Event.ENTER_FRAME, hasFocus_enterFrameHandler);
		this.dispatchEventWith(FeathersEventType.FOCUS_IN);
	}

	/**
	 * @private
	 */
	private function getSelectionIndexAtPoint(pointX:Float, pointY:Float):Int
	{
		if(this._text == null || pointX <= 0)
		{
			return 0;
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
		var align:TextFormatAlign = this.currentTextFormat.align;
		if(align != TextFormatAlign.LEFT)
		{
			var lineWidth:Float = this.measureText(HELPER_POINT).x;
			var hasExplicitWidth:Bool = this.explicitWidth == this.explicitWidth; //!isNaN
			var maxLineWidth:Float = hasExplicitWidth ? this.explicitWidth : this._maxWidth;
			if(maxLineWidth > lineWidth)
			{
				if(align == TextFormatAlign.RIGHT)
				{
					pointX -= maxLineWidth - lineWidth;
				}
				else //center
				{
					pointX -= (maxLineWidth - lineWidth) / 2;
				}
			}
		}
		var currentX:Float = 0;
		var previousCharID:Int = 0xffffffff;
		var charCount:Int = this._text.length;
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
				currentKerning = charData.getKerning(previousCharID) * scale;
			}
			var charWidth:Float = customLetterSpacing + currentKerning + charData.xAdvance * scale;
			if(pointX >= currentX && pointX < (currentX + charWidth))
			{
				if(pointX > (currentX + charWidth / 2))
				{
					return i + 1;
				}
				return i;
			}
			currentX += charWidth;
			previousCharID = charID;
		}
		if(pointX >= currentX)
		{
			return this._text.length;
		}
		return 0;
	}

	/**
	 * @private
	 */
	private function getXPositionOfIndex(index:Int):Float
	{
		var font:BitmapFont = this.currentTextFormat.font;
		var customSize:Float = this.currentTextFormat.size;
		var customLetterSpacing:Float = this.currentTextFormat.letterSpacing;
		var isKerningEnabled:Bool = this.currentTextFormat.isKerningEnabled;
		var scale:Float = customSize / font.size;
		if(scale != scale) //isNaN
		{
			scale = 1;
		}
		var xPositionOffset:Float = 0;
		var align:TextFormatAlign = this.currentTextFormat.align;
		if(align != TextFormatAlign.LEFT)
		{
			var lineWidth:Float = this.measureText(HELPER_POINT).x;
			var hasExplicitWidth:Bool = this.explicitWidth == this.explicitWidth; //!isNaN
			var maxLineWidth:Float = hasExplicitWidth ? this.explicitWidth : this._maxWidth;
			if(maxLineWidth > lineWidth)
			{
				if(align == TextFormatAlign.RIGHT)
				{
					xPositionOffset = maxLineWidth - lineWidth;
				}
				else //center
				{
					xPositionOffset = (maxLineWidth - lineWidth) / 2;
				}
			}
		}
		var currentX:Float = 0;
		var previousCharID:Int = 0xffffffff;
		var charCount:Int = this._text.length;
		if(index < charCount)
		{
			charCount = index;
		}
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
				currentKerning = charData.getKerning(previousCharID) * scale;
			}
			currentX += customLetterSpacing + currentKerning + charData.xAdvance * scale;
			previousCharID = charID;
		}
		return currentX + xPositionOffset;
	}

	/**
	 * @private
	 */
	private function positionCursorAtCharIndex(index:Int):Void
	{
		if(index < 0)
		{
			index = 0;
		}
		var cursorX:Float = this.getXPositionOfIndex(index);
		cursorX = Std.int(cursorX - (this._cursorSkin.width / 2));
		this._cursorSkin.x = cursorX;
		this._cursorSkin.y = 0;

		//then we update the scroll to always show the cursor
		var minScrollX:Float = cursorX + this._cursorSkin.width - this.actualWidth;
		var maxScrollX:Float = this.getXPositionOfIndex(this._text.length) - this.actualWidth;
		if(maxScrollX < 0)
		{
			maxScrollX = 0;
		}
		if(this._scrollX < minScrollX)
		{
			this._scrollX = minScrollX;
		}
		else if(this._scrollX > cursorX)
		{
			this._scrollX = cursorX;
		}
		if(this._scrollX > maxScrollX)
		{
			this._scrollX = maxScrollX;
		}
	}

	/**
	 * @private
	 */
	private function getCursorIndexFromSelectionRange():Int
	{
		var cursorIndex:Int = this._selectionEndIndex;
		if(this.touchPointID >= 0 && this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionEndIndex)
		{
			cursorIndex = this._selectionBeginIndex;
		}
		return cursorIndex;
	}

	/**
	 * @private
	 */
	private function positionSelectionBackground():Void
	{
		var font:BitmapFont = this.currentTextFormat.font;
		var customSize:Float = this.currentTextFormat.size;
		var scale:Float = customSize / font.size;
		if(scale != scale) //isNaN
		{
			scale = 1;
		}

		var startX:Float = this.getXPositionOfIndex(this._selectionBeginIndex) - this._scrollX;
		if(startX < 0)
		{
			startX = 0;
		}
		var endX:Float = this.getXPositionOfIndex(this._selectionEndIndex) - this._scrollX;
		if(endX < 0)
		{
			endX = 0;
		}
		this._selectionSkin.x = startX;
		this._selectionSkin.width = endX - startX;
		this._selectionSkin.y = 0;
		this._selectionSkin.height = font.lineHeight * scale;
	}

	/**
	 * @private
	 */
	private function getSelectedText():String
	{
		if(this._selectionBeginIndex == this._selectionEndIndex)
		{
			return null;
		}
		return this._text.substr(this._selectionBeginIndex, this._selectionEndIndex - this._selectionBeginIndex);
	}

	/**
	 * @private
	 */
	private function deleteSelectedText():Void
	{
		var currentValue:String = this._text;
		if(this._displayAsPassword)
		{
			currentValue = this._unmaskedText;
		}
		this.text = currentValue.substr(0, this._selectionBeginIndex) + currentValue.substr(this._selectionEndIndex);
		this.selectRange(this._selectionBeginIndex, this._selectionBeginIndex);
	}

	/**
	 * @private
	 */
	private function replaceSelectedText(text:String):Void
	{
		var currentValue:String = this._text;
		if(this._displayAsPassword)
		{
			currentValue = this._unmaskedText;
		}
		var newText:String = currentValue.substr(0, this._selectionBeginIndex) + text + currentValue.substr(this._selectionEndIndex);
		if(this._maxChars > 0 && newText.length > this._maxChars)
		{
			return;
		}
		this.text = newText;
		var selectionIndex:Int = this._selectionBeginIndex + text.length;
		this.selectRange(selectionIndex, selectionIndex);
	}

	/**
	 * @private
	 */
	private function hasFocus_enterFrameHandler(event:starling.events.Event):Void
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

	/**
	 * @private
	 */
	private function textEditor_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this.touchPointID = -1;
			return;
		}
		var touch:Touch;
		if(this.touchPointID >= 0)
		{
			touch = event.getTouch(this, null, this.touchPointID);
			touch.getLocation(this, HELPER_POINT);
			HELPER_POINT.x += this._scrollX;
			this.selectRange(this._selectionAnchorIndex, this.getSelectionIndexAtPoint(HELPER_POINT.x, HELPER_POINT.y));
			if(touch.phase == TouchPhase.ENDED)
			{
				this.touchPointID = -1;
				if(this._selectionBeginIndex == this._selectionEndIndex)
				{
					this._selectionAnchorIndex = -1;
				}
				if(!FocusManager.isEnabledForStage(this.stage) && this._hasFocus)
				{
					this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
				}
			}
		}
		else //if we get here, we don't have a saved touch ID yet
		{
			touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = touch.id;
			touch.getLocation(this, HELPER_POINT);
			HELPER_POINT.x += this._scrollX;
			if(event.shiftKey)
			{
				if(this._selectionAnchorIndex < 0)
				{
					this._selectionAnchorIndex = this._selectionBeginIndex;
				}
				this.selectRange(this._selectionAnchorIndex, this.getSelectionIndexAtPoint(HELPER_POINT.x, HELPER_POINT.y));
			}
			else
			{
				this.setFocus(HELPER_POINT);
				this._selectionAnchorIndex = this._selectionBeginIndex;
			}
		}
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
	private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(!this._isEnabled || this.touchPointID >= 0 || event.isDefaultPrevented())
		{
			return;
		}
		//ignore select all, cut, copy, and paste
		var charCode:UInt = event.charCode;
		if(event.ctrlKey && (charCode == 97 || charCode == 99 || charCode == 118 || charCode == 120)) //a, c, p, and x
		{
			return;
		}
		var newIndex:Int = -1;
		if(!FocusManager.isEnabledForStage(this.stage) && event.keyCode == Keyboard.TAB)
		{
			this.clearFocus();
			return;
		}
		else if(event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.UP)
		{
			newIndex = 0;
		}
		else if(event.keyCode == Keyboard.END || event.keyCode == Keyboard.DOWN)
		{
			newIndex = this._text.length;
		}
		else if(event.keyCode == Keyboard.LEFT)
		{
			if(event.shiftKey)
			{
				if(this._selectionAnchorIndex < 0)
				{
					this._selectionAnchorIndex = this._selectionBeginIndex;
				}
				if(this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionBeginIndex &&
					this._selectionBeginIndex != this._selectionEndIndex)
				{
					newIndex = this._selectionEndIndex - 1;
					this.selectRange(this._selectionBeginIndex, newIndex);
				}
				else
				{
					newIndex = this._selectionBeginIndex - 1;
					if(newIndex < 0)
					{
						newIndex = 0;
					}
					this.selectRange(newIndex, this._selectionEndIndex);
				}
				return;
			}
			else if(this._selectionBeginIndex != this._selectionEndIndex)
			{
				newIndex = this._selectionBeginIndex;
			}
			else
			{
				if(event.altKey || event.ctrlKey)
				{
					newIndex = TextInputNavigation.findPreviousWordStartIndex(this._text, this._selectionBeginIndex);
				}
				else
				{
					newIndex = this._selectionBeginIndex - 1;
				}
				if(newIndex < 0)
				{
					newIndex = 0;
				}
			}
		}
		else if(event.keyCode == Keyboard.RIGHT)
		{
			if(event.shiftKey)
			{
				if(this._selectionAnchorIndex < 0)
				{
					this._selectionAnchorIndex = this._selectionBeginIndex;
				}
				if(this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionEndIndex &&
					this._selectionBeginIndex != this._selectionEndIndex)
				{
					newIndex = this._selectionBeginIndex + 1;
					this.selectRange(newIndex, this._selectionEndIndex);
				}
				else
				{
					newIndex = this._selectionEndIndex + 1;
					if(newIndex < 0 || newIndex > this._text.length)
					{
						newIndex = this._text.length;
					}
					this.selectRange(this._selectionBeginIndex, newIndex);
				}
				return;
			}
			else if(this._selectionBeginIndex != this._selectionEndIndex)
			{
				newIndex = this._selectionEndIndex;
			}
			else
			{
				if(event.altKey || event.ctrlKey)
				{
					newIndex = TextInputNavigation.findNextWordStartIndex(this._text, this._selectionEndIndex);
				}
				else
				{
					newIndex = this._selectionEndIndex + 1;
				}
				if(newIndex < 0 || newIndex > this._text.length)
				{
					newIndex = this._text.length;
				}
			}
		}
		if(newIndex < 0)
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				this.dispatchEventWith(FeathersEventType.ENTER);
				return;
			}
			//everything after this point edits the text, so return if the text
			//editor isn't editable.
			if(!this._isEditable)
			{
				return;
			}
			var currentValue:String = this._text;
			if(this._displayAsPassword)
			{
				currentValue = this._unmaskedText;
			}
			if(event.keyCode == Keyboard.DELETE)
			{
				if(event.altKey || event.ctrlKey)
				{
					var nextWordStartIndex:Int = TextInputNavigation.findNextWordStartIndex(this._text, this._selectionEndIndex);
					this.text = currentValue.substr(0, this._selectionBeginIndex) + currentValue.substr(nextWordStartIndex);
				}
				else if(this._selectionBeginIndex != this._selectionEndIndex)
				{
					this.deleteSelectedText();
				}
				else if(this._selectionEndIndex < currentValue.length)
				{
					this.text = currentValue.substr(0, this._selectionBeginIndex) + currentValue.substr(this._selectionEndIndex + 1);
				}
			}
			else if(event.keyCode == Keyboard.BACKSPACE)
			{
				if(event.altKey || event.ctrlKey)
				{
					newIndex = TextInputNavigation.findPreviousWordStartIndex(this._text, this._selectionBeginIndex);
					this.text = currentValue.substr(0, newIndex) + currentValue.substr(this._selectionEndIndex);
				}
				else if(this._selectionBeginIndex != this._selectionEndIndex)
				{
					this.deleteSelectedText();
				}
				else if(this._selectionBeginIndex > 0)
				{
					newIndex = this._selectionBeginIndex - 1;
					this.text = currentValue.substr(0, this._selectionBeginIndex - 1) + currentValue.substr(this._selectionEndIndex);
				}
			}
		}
		if(newIndex >= 0)
		{
			this._selectionAnchorIndex = newIndex;
			this.selectRange(newIndex, newIndex);
		}
	}

	/**
	 * @private
	 */
	private function nativeFocus_textInputHandler(event:TextEvent):Void
	{
		if(!this._isEditable || !this._isEnabled)
		{
			return;
		}
		var text:String = event.text;
		if(text == CARRIAGE_RETURN || text == LINE_FEED)
		{
			//ignore new lines
			return;
		}
		var charCode:Int = text.charCodeAt(0);
		if(this._restrict == null || this._restrict.isCharacterAllowed(charCode))
		{
			this.replaceSelectedText(text);
		}
	}

	/**
	 * @private
	 */
	private function nativeFocus_selectAllHandler(event:flash.events.Event):Void
	{
		if(!this._isEnabled)
		{
			return;
		}
		this._selectionAnchorIndex = 0;
		this.selectRange(0, this._text.length);
	}

	/**
	 * @private
	 */
	private function nativeFocus_cutHandler(event:flash.events.Event):Void
	{
		if(!this._isEnabled || this._selectionBeginIndex == this._selectionEndIndex || this._displayAsPassword)
		{
			return;
		}
		#if flash
		Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.getSelectedText());
		#end
		if(!this._isEditable)
		{
			return;
		}
		this.deleteSelectedText();
	}

	/**
	 * @private
	 */
	private function nativeFocus_copyHandler(event:flash.events.Event):Void
	{
		if(!this._isEnabled || this._selectionBeginIndex == this._selectionEndIndex || this._displayAsPassword)
		{
			return;
		}
		#if flash
		Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.getSelectedText());
		#end
	}

	/**
	 * @private
	 */
	private function nativeFocus_pasteHandler(event:flash.events.Event):Void
	{
		#if flash
		if(!this._isEditable || !this._isEnabled)
		{
			return;
		}
		var pastedText:String = cast(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT), String);
		if(pastedText == null)
		{
			//the clipboard doesn't contain any text to paste
			return;
		}
		if(this._restrict != null)
		{
			pastedText = this._restrict.filterText(pastedText);
		}
		this.replaceSelectedText(pastedText);
		#end
	}
}
