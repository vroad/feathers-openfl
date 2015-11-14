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
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.TextEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormatAlign;
#if flash
import flash.text.engine.TextElement;
import flash.text.engine.TextLine;
#end
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

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SELECTED;
import feathers.controls.text.TextBlockTextRenderer.CARRIAGE_RETURN;
import feathers.controls.text.TextBlockTextRenderer.LINE_FEED;

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
 * Renders text with a native <code>openfl.text.engine.TextBlock</code> from
 * Flash Text Engine (FTE) that may be edited at runtime by the user. Draws
 * the text to <code>BitmapData</code> to convert to Starling textures.
 * Textures are completely managed by this component, and they will be
 * automatically disposed when the component is disposed from the stage.
 *
 * <p><strong>Warning:</strong> This text editor is intended for use in
 * desktop applications only, and it does not provide support for software
 * keyboards on mobile devices.</p>
 *
 * @see ../../../help/text-editors.html Introduction to Feathers text editors
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html openfl.text.engine.TextBlock
 */
class TextBlockTextEditor extends TextBlockTextRenderer implements ITextEditor implements INativeFocusOwner
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * The text will be positioned to the left edge.
	 *
	 * @see feathers.controls.text.TextBlockTextRenderer#textAlign
	 */
	inline public static var TEXT_ALIGN_LEFT:String = "left";

	/**
	 * The text will be centered horizontally.
	 *
	 * @see feathers.controls.text.TextBlockTextRenderer#textAlign
	 */
	inline public static var TEXT_ALIGN_CENTER:String = "center";

	/**
	 * The text will be positioned to the right edge.
	 *
	 * @see feathers.controls.text.TextBlockTextRenderer#textAlign
	 */
	inline public static var TEXT_ALIGN_RIGHT:String = "right";

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this._text = "";
#if flash        
		this._textElement = new TextElement(this._text);
		this._content = this._textElement;
#end
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
			return this._selectionSkin;
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
		return this._selectionSkin;
	}

	/**
	 * @private
	 */
	private var _cursorSkin:DisplayObject;
	public var cursorSkin(get, set):DisplayObject;

	/**
	 *
	 */
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
			return this._cursorSkin;
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
		return this._cursorSkin;
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
			return this._displayAsPassword;
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
		return this._displayAsPassword;
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
			return this._isEditable;
		}
		this._isEditable = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._isEditable;
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
			return this._text;
		}
		if(this._displayAsPassword)
		{
			this._unmaskedText = value;
			this.refreshMaskedText();
		}
		else
		{
			super.text = value;
		}
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
		return this._text;
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
			return this._maxChars;
		}
		this._maxChars = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._maxChars;
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
			return this._restrict.restrict;
		}
		if(this._restrict == null && value == null)
		{
			return null;
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
		return this._restrict.restrict;
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
		var oldSnapshotX:Float = this._textSnapshotOffsetX;
		var oldCursorX:Float = this._cursorSkin.x;
		this._cursorSkin.x -= this._textSnapshotScrollX;
		super.render(support, parentAlpha);
		this._textSnapshotOffsetX = oldSnapshotX;
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
	}

	/**
	 * @private
	 */
	/*override private function refreshTextLines(textLines:Array<TextLine>, textLineParent:DisplayObjectContainer, width:Float, height:Float):Void
	{
		super.refreshTextLines(textLines, textLineParent, width, height);
		if(textLineParent.width > width)
		{
			this.alignTextLines(textLines, width, TextFormatAlign.LEFT);
		}
	}*/

	/**
	 * @private
	 */
	private function refreshMaskedText():Void
	{
		var newText:String = "";
		var textLength:Int = this._unmaskedText.length;
		var maskChar:String = String.fromCharCode(this._passwordCharCode);
		for(i in 0 ... textLength)
		{
			newText += maskChar;
		}
		super.text = newText;
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
#if flash
		if(this._text == null || this._textLines.length == 0)
		{
			return 0;
		}
		var line:TextLine = this._textLines[0];
		if((pointX - line.x) <= 0)
		{
			return 0;
		}
		else if((pointX - line.x) >= line.width)
		{
			return this._text.length;
		}
		var atomIndex:Int = line.getAtomIndexAtPoint(pointX, pointY);
		if(atomIndex < 0)
		{
			//try again with the middle of the line
			atomIndex = line.getAtomIndexAtPoint(pointX, line.ascent / 2);
		}
		if(atomIndex < 0)
		{
			//worse case: we couldn't figure it out at all
			return this._text.length;
		}
		//we're constraining the atom index to the text length because we
		//may have added an invisible control character at the end due to
		//the fact that FTE won't include trailing spaces in measurement
		if(atomIndex > this._text.length)
		{
			atomIndex = this._text.length;
		}
		var atomBounds:Rectangle = line.getAtomBounds(atomIndex);
		if((pointX - line.x - atomBounds.x) > atomBounds.width / 2)
		{
			return atomIndex + 1;
		}
		return atomIndex;
#else
		return 0;
#end
	}

	/**
	 * @private
	 */
	private function getXPositionOfCharIndex(index:Int):Float
	{
#if flash
		if(this._text == null || this._textLines.length == 0)
		{
			if(this._textAlign == "center"/*TextFormatAlign.CENTER*/)
			{
				return Math.round(this.actualWidth / 2);
			}
			else if(this._textAlign == "right"/*TextFormatAlign.RIGHT*/)
			{
				return this.actualWidth;
			}
			return 0;
		}
		var line:TextLine = this._textLines[0];
		if(index == this._text.length)
		{
			return line.x + line.width;
		}
		var atomIndex:Int = line.getAtomIndexAtCharIndex(index);
		return line.x + line.getAtomBounds(atomIndex).x;
#else
		return 0;
#end
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
		var cursorX:Float = this.getXPositionOfCharIndex(index);
		cursorX = Std.int(cursorX - (this._cursorSkin.width / 2));
		this._cursorSkin.x = cursorX;
		this._cursorSkin.y = 0;
#if flash
		this._cursorSkin.height = this._elementFormat.fontSize;
#end
		//then we update the scroll to always show the cursor
		var minScrollX:Float = cursorX + this._cursorSkin.width - this.actualWidth;
		var maxScrollX:Float = this.getXPositionOfCharIndex(this._text.length) - this.actualWidth;
		if(maxScrollX < 0)
		{
			maxScrollX = 0;
		}
		var oldScrollX:Float = this._textSnapshotScrollX;
		if(this._textSnapshotScrollX < minScrollX)
		{
			this._textSnapshotScrollX = minScrollX;
		}
		else if(this._textSnapshotScrollX > cursorX)
		{
			this._textSnapshotScrollX = cursorX;
		}
		if(this._textSnapshotScrollX > maxScrollX)
		{
			this._textSnapshotScrollX = maxScrollX;
		}
		if(this._textSnapshotScrollX != oldScrollX)
		{
			this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
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
		var startX:Float = this.getXPositionOfCharIndex(this._selectionBeginIndex) - this._textSnapshotScrollX;
		if(startX < 0)
		{
			startX = 0;
		}
		var endX:Float = this.getXPositionOfCharIndex(this._selectionEndIndex) - this._textSnapshotScrollX;
		if(endX < 0)
		{
			endX = 0;
		}
		this._selectionSkin.x = startX;
		this._selectionSkin.width = endX - startX;
		this._selectionSkin.y = 0;
#if flash
		if(this._textLines.length > 0)
		{
			this._selectionSkin.height = this._textLines[0].height;
		}
#end
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
		this.validate();
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
		this.validate();
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
			HELPER_POINT.x += this._textSnapshotScrollX;
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
			HELPER_POINT.x += this._textSnapshotScrollX;
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
			this.validate();
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
		if(!this._isEditable)
		{
			return;
		}
		this.deleteSelectedText();
#end
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
	}
}