/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.IFocusDisplayObject;
import feathers.core.IMultilineTextEditor;
import feathers.core.INativeFocusOwner;
import feathers.core.ITextBaselineControl;
import feathers.core.ITextEditor;
import feathers.core.ITextRenderer;
import feathers.core.IValidating;
import feathers.core.PropertyProxy;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.skins.StateValueSelector;
import openfl.errors.ArgumentError;
import openfl.errors.RangeError;

import flash.display.InteractiveObject;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the text input's <code>text</code> property changes.
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
 * @eventType starling.events.Event.CHANGE
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when the user presses the Enter key while the text input
 * has focus. This event may not be dispatched at all times. Certain text
 * editors will not dispatch an event for the enter key on some platforms,
 * depending on the values of certain properties. This may include the
 * default values for some platforms! If you've encountered this issue,
 * please see the specific text editor's API documentation for complete
 * details of this event's limitations and requirements.
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
 * Dispatched when the text input receives focus.
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
 * Dispatched when the text input loses focus.
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
 * Dispatched when the soft keyboard is activated by the text editor. Not
 * all text editors will activate a soft keyboard.
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
 * Dispatched when the soft keyboard is deactivated by the text editor. Not
 * all text editors will activate a soft keyboard.
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
 * A text entry control that allows users to enter and edit a single line of
 * uniformly-formatted text.
 *
 * <p>To set things like font properties, the ability to display as
 * password, and character restrictions, use the <code>textEditorProperties</code> to pass
 * values to the <code>ITextEditor</code> instance.</p>
 *
 * <p>The following example sets the text in a text input, selects the text,
 * and listens for when the text value changes:</p>
 *
 * <listing version="3.0">
 * var input:TextInput = new TextInput();
 * input.text = "Hello World";
 * input.selectRange( 0, input.text.length );
 * input.addEventListener( Event.CHANGE, input_changeHandler );
 * this.addChild( input );</listing>
 *
 * @see ../../../help/text-input.html How to use the Feathers TextInput component
 * @see ../../../help/text-editors.html Introduction to Feathers text editors
 * @see feathers.core.ITextEditor
 * @see feathers.controls.AutoComplete
 * @see feathers.controls.TextArea
 */
public class TextInput extends FeathersControl implements IFocusDisplayObject, ITextBaselineControl, INativeFocusOwner
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_PROMPT_FACTORY:String = "promptFactory";

	/**
	 * The <code>TextInput</code> is enabled and does not have focus.
	 */
	inline public static var STATE_ENABLED:String = "enabled";

	/**
	 * The <code>TextInput</code> is disabled.
	 */
	inline public static var STATE_DISABLED:String = "disabled";

	/**
	 * The <code>TextInput</code> is enabled and has focus.
	 */
	inline public static var STATE_FOCUSED:String = "focused";

	/**
	 * An alternate style name to use with <code>TextInput</code> to allow a
	 * theme to give it a search input style. If a theme does not provide a
	 * style for the search text input, the theme will automatically fal
	 * back to using the default text input style.
	 *
	 * <p>An alternate style name should always be added to a component's
	 * <code>styleNameList</code> before the component is initialized. If
	 * the style name is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the search style is applied to a text
	 * input:</p>
	 *
	 * <listing version="3.0">
	 * var input:TextInput = new TextInput();
	 * input.styleNameList.add( TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT );
	 * this.addChild( input );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public static const ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT:String = "feathers-search-text-input";

	/**
	 * DEPRECATED: Replaced by <code>TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see TextInput#ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT
	 */
	public static const ALTERNATE_NAME_SEARCH_TEXT_INPUT:String = ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT;

	/**
	 * The text editor, icon, and prompt will be aligned vertically to the
	 * top edge of the text input.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * The text editor, icon, and prompt will be aligned vertically to the
	 * middle of the text input.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * The text editor, icon, and prompt will be aligned vertically to the
	 * bottom edge of the text input.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * The text editor will fill the full height of the text input (minus
	 * top and bottom padding).
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * The default <code>IStyleProvider</code> for all <code>TextInput</code>
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
		this.addEventListener(TouchEvent.TOUCH, textInput_touchHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, textInput_removedFromStageHandler);
	}

	/**
	 * The text editor sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var textEditor:ITextEditor;

	/**
	 * The prompt text renderer sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var promptTextRenderer:ITextRenderer;

	/**
	 * The currently selected background, based on state.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var currentBackground:DisplayObject;

	/**
	 * The currently visible icon. The value will be <code>null</code> if
	 * there is no currently visible icon.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var currentIcon:DisplayObject;

	/**
	 * @private
	 */
	private var _textEditorHasFocus:Bool = false;

	/**
	 * A text editor may be an <code>INativeFocusOwner</code>, so we need to
	 * return the value of its <code>nativeFocus</code> property. If not,
	 * then we return <code>null</code>.
	 * 
	 * @see feathers.core.INativeFocusOwner
	 */
	public function get nativeFocus():InteractiveObject
	{
		if(this.textEditor is INativeFocusOwner)
		{
			return INativeFocusOwner(this.textEditor).nativeFocus;
		}
		return null;
	}

	/**
	 * @private
	 */
	private var _ignoreTextChanges:Bool = false;

	/**
	 * @private
	 */
	private var _touchPointID:Int = -1;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return TextInput.globalStyleProvider;
	}

	/**
	 * When the <code>FocusManager</code> isn't enabled, <code>hasFocus</code>
	 * can be used instead of <code>FocusManager.focus == textInput</code>
	 * to determine if the text input has focus.
	 */
	public var hasFocus(get, never):Bool;
	public function get_hasFocus():Bool
	{
		if(this._focusManager == null)
		{
			return this._textEditorHasFocus;
		}
		return this._hasFocus;
	}

	/**
	 * @private
	 */
	override public function set_isEnabled(value:Bool):Bool
	{
		super.isEnabled = value;
		if(this._isEnabled)
		{
			this.currentState = this.hasFocus ? STATE_FOCUSED : STATE_ENABLED;
		}
		else
		{
			this.currentState = STATE_DISABLED;
		}
		return get_isEnabled();
	}

	/**
	 * @private
	 */
	private var _stateNames:Array<String> = 
	[
		STATE_ENABLED, STATE_DISABLED, STATE_FOCUSED
	];

	/**
	 * A list of all valid state names for use with <code>currentState</code>.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #currentState
	 */
	private var stateNames(get, never):Array<String>;
	private function get_stateNames():Array<String>
	{
		return this._stateNames;
	}

	/**
	 * @private
	 */
	private var _currentState:String = STATE_ENABLED;

	/**
	 * The current state of the input.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var currentState(get, set):String;
	private function get_currentState():String
	{
		return this._currentState;
	}

	/**
	 * @private
	 */
	private function set_currentState(value:String):String
	{
		if(this._currentState == value)
		{
			return get_currentState();
		}
		if(this.stateNames.indexOf(value) < 0)
		{
			throw new ArgumentError("Invalid state: " + value + ".");
		}
		this._currentState = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STATE);
		return get_currentState();
	}

	/**
	 * @private
	 */
	private var _text:String = "";

	/**
	 * The text displayed by the text input. The text input dispatches
	 * <code>Event.CHANGE</code> when the value of the <code>text</code>
	 * property changes for any reason.
	 *
	 * <p>In the following example, the text input's text is updated:</p>
	 *
	 * <listing version="3.0">
	 * input.text = "Hello World";</listing>
	 *
	 * @see #event:change
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
	 * The baseline measurement of the text, in pixels.
	 */
	public var baseline(get, never):Float;
	public function get_baseline():Float
	{
		if(this.textEditor == null)
		{
			return 0;
		}
		return this.textEditor.y + this.textEditor.baseline;
	}

	/**
	 * @private
	 */
	private var _prompt:String = null;

	/**
	 * The prompt, hint, or description text displayed by the input when the
	 * value of its text is empty.
	 *
	 * <p>In the following example, the text input's prompt is updated:</p>
	 *
	 * <listing version="3.0">
	 * input.prompt = "User Name";</listing>
	 *
	 * @default null
	 */
	public var prompt(get, set):String;
	public function get_prompt():String
	{
		return this._prompt;
	}

	/**
	 * @private
	 */
	public function set_prompt(value:String):String
	{
		if(this._prompt == value)
		{
			return get_prompt();
		}
		this._prompt = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_prompt();
	}

	/**
	 * @private
	 */
	private var _typicalText:String;

	/**
	 * The text used to measure the input when the dimensions are not set
	 * explicitly (in addition to using the background skin for measurement).
	 *
	 * <p>In the following example, the text input's typical text is
	 * updated:</p>
	 *
	 * <listing version="3.0">
	 * input.text = "We want to allow the text input to show all of this text";</listing>
	 *
	 * @default null
	 */
	public var typicalText(get, set):String;
	public function get_typicalText():String
	{
		return this._typicalText;
	}

	/**
	 * @private
	 */
	public function set_typicalText(value:String):String
	{
		if(this._typicalText == value)
		{
			return get_typicalText();
		}
		this._typicalText = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_typicalText();
	}

	/**
	 * @private
	 */
	private var _maxChars:Int = 0;

	/**
	 * The maximum number of characters that may be entered. If <code>0</code>,
	 * any number of characters may be entered.
	 *
	 * <p>In the following example, the text input's maximum characters is
	 * specified:</p>
	 *
	 * <listing version="3.0">
	 * input.maxChars = 10;</listing>
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
	private var _restrict:String;

	/**
	 * Limits the set of characters that may be entered.
	 *
	 * <p>In the following example, the text input's allowed characters are
	 * restricted:</p>
	 *
	 * <listing version="3.0">
	 * input.restrict = "0-9";</listing>
	 *
	 * @default null
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
	private var _displayAsPassword:Bool = false;

	/**
	 * Determines if the entered text will be masked so that it cannot be
	 * seen, such as for a password input.
	 *
	 * <p>In the following example, the text input's text is displayed as
	 * a password:</p>
	 *
	 * <listing version="3.0">
	 * input.displayAsPassword = true;</listing>
	 *
	 * @default false
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
	private var _isEditable:Bool = true;

	/**
	 * Determines if the text input is editable. If the text input is not
	 * editable, it will still appear enabled.
	 *
	 * <p>In the following example, the text input is not editable:</p>
	 *
	 * <listing version="3.0">
	 * input.isEditable = false;</listing>
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
	private var _textEditorFactory:Void->ITextEditor;

	/**
	 * A function used to instantiate the text editor. If null,
	 * <code>FeathersControl.defaultTextEditorFactory</code> is used
	 * instead. The text editor must be an instance of
	 * <code>ITextEditor</code>. This factory can be used to change
	 * properties on the text editor when it is first created. For instance,
	 * if you are skinning Feathers components without a theme, you might
	 * use this factory to set styles on the text editor.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextEditor</pre>
	 *
	 * <p>In the following example, a custom text editor factory is passed
	 * to the text input:</p>
	 *
	 * <listing version="3.0">
	 * input.textEditorFactory = function():ITextEditor
	 * {
	 *     return new TextFieldTextEditor();
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextEditor
	 * @see feathers.core.FeathersControl#defaultTextEditorFactory
	 */
	public var textEditorFactory(get, set):Void->ITextEditor;
	public function get_textEditorFactory():Void->ITextEditor
	{
		return this._textEditorFactory;
	}

	/**
	 * @private
	 */
	public function set_textEditorFactory(value:Void->ITextEditor):Void->ITextEditor
	{
		if(this._textEditorFactory == value)
		{
			return get_textEditorFactory();
		}
		this._textEditorFactory = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_TEXT_EDITOR);
		return get_textEditorFactory();
	}

	/**
	 * @private
	 */
	private var _promptFactory:Void->ITextRenderer;

	/**
	 * A function used to instantiate the prompt text renderer. If null,
	 * <code>FeathersControl.defaultTextRendererFactory</code> is used
	 * instead. The prompt text renderer must be an instance of
	 * <code>ITextRenderer</code>. This factory can be used to change
	 * properties on the prompt when it is first created. For instance, if
	 * you are skinning Feathers components without a theme, you might use
	 * this factory to set styles on the prompt.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * <p>If the <code>prompt</code> property is <code>null</code>, the
	 * prompt text renderer will not be created.</p>
	 *
	 * <p>In the following example, a custom prompt factory is passed to the
	 * text input:</p>
	 *
	 * <listing version="3.0">
	 * input.promptFactory = function():ITextRenderer
	 * {
	 *     return new TextFieldTextRenderer();
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #prompt
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 */
	public var promptFactory(get, set):Void->ITextRenderer;
	public function get_promptFactory():Void->ITextRenderer
	{
		return this._promptFactory;
	}

	/**
	 * @private
	 */
	public function set_promptFactory(value:Void->ITextRenderer):Void->ITextRenderer
	{
		if(this._promptFactory == value)
		{
			return get_promptFactory();
		}
		this._promptFactory = value;
		this.invalidate(INVALIDATION_FLAG_PROMPT_FACTORY);
		return get_promptFactory();
	}

	/**
	 * @private
	 */
	private var _promptProperties:PropertyProxy;

	/**
	 * An object that stores properties for the input's prompt text
	 * renderer sub-component, and the properties will be passed down to the
	 * text renderer when the input validates. The available properties
	 * depend on which <code>ITextRenderer</code> implementation is returned
	 * by <code>messageFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>promptFactory</code> function
	 * instead of using <code>promptProperties</code> will result in
	 * better performance.</p>
	 *
	 * <p>In the following example, the text input's prompt's properties are
	 * updated (this example assumes that the prompt text renderer is a
	 * <code>TextFieldTextRenderer</code>):</p>
	 *
	 * <listing version="3.0">
	 * input.promptProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
	 * input.promptProperties.embedFonts = true;</listing>
	 *
	 * @default null
	 *
	 * @see #prompt
	 * @see #promptFactory
	 * @see feathers.core.ITextRenderer
	 */
	public var promptProperties(get, set):PropertyProxy;
	public function get_promptProperties():PropertyProxy
	{
		if(this._promptProperties == null)
		{
			this._promptProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._promptProperties;
	}

	/**
	 * @private
	 */
	public function set_promptProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._promptProperties == value)
		{
			return get_promptProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._promptProperties != null)
		{
			this._promptProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._promptProperties = value;
		if(this._promptProperties != null)
		{
			this._promptProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_promptProperties();
	}

	/**
	 * @private
	 * The width of the first skin that was displayed.
	 */
	private var _originalSkinWidth:Float = Math.NaN;

	/**
	 * @private
	 * The height of the first skin that was displayed.
	 */
	private var _originalSkinHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _skinSelector:StateValueSelector<DisplayObject> = new StateValueSelector();

	/**
	 * The skin used when no other skin is defined for the current state.
	 * Intended for use when multiple states should use the same skin.
	 *
	 * <p>The following example gives the input a default skin to use for
	 * all states when no specific skin is available:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #backgroundEnabledSkin
	 * @see #backgroundDisabledSkin
	 * @see #backgroundFocusedSkin
	 */
	public var backgroundSkin(get, set):DisplayObject;
	public function get_backgroundSkin():DisplayObject
	{
		return this._skinSelector.defaultValue;
	}

	/**
	 * @private
	 */
	public function set_backgroundSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.defaultValue == value)
		{
			return get_backgroundSkin();
		}
		this._skinSelector.defaultValue = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_backgroundSkin();
	}

	/**
	 * The skin used for the input's enabled state. If <code>null</code>,
	 * then <code>backgroundSkin</code> is used instead.
	 *
	 * <p>The following example gives the input a skin for the enabled state:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundEnabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #backgroundSkin
	 * @see #backgroundDisabledSkin
	 */
	public var backgroundEnabledSkin(get, set):DisplayObject;
	public function get_backgroundEnabledSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(STATE_ENABLED);
	}

	/**
	 * @private
	 */
	public function set_backgroundEnabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(STATE_ENABLED) == value)
		{
			return get_backgroundEnabledSkin();
		}
		this._skinSelector.setValueForState(value, STATE_ENABLED);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_backgroundEnabledSkin();
	}

	/**
	 * The skin used for the input's focused state. If <code>null</code>,
	 * then <code>backgroundSkin</code> is used instead.
	 *
	 * <p>The following example gives the input a skin for the focused state:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundFocusedSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundFocusedSkin(get, set):DisplayObject;
	public function get_backgroundFocusedSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(STATE_FOCUSED);
	}

	/**
	 * @private
	 */
	public function set_backgroundFocusedSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(STATE_FOCUSED) == value)
		{
			return get_backgroundFocusedSkin();
		}
		this._skinSelector.setValueForState(value, STATE_FOCUSED);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_backgroundFocusedSkin();
	}

	/**
	 * The skin used for the input's disabled state. If <code>null</code>,
	 * then <code>backgroundSkin</code> is used instead.
	 *
	 * <p>The following example gives the input a skin for the disabled state:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundDisabledSkin(get, set):DisplayObject;
	public function get_backgroundDisabledSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(STATE_DISABLED);
	}

	/**
	 * @private
	 */
	public function set_backgroundDisabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(STATE_DISABLED) == value)
		{
			return get_backgroundDisabledSkin();
		}
		this._skinSelector.setValueForState(value, STATE_DISABLED);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_backgroundDisabledSkin();
	}

	/**
	 * @private
	 */
	private var _stateToSkinFunction:TextInput->Dynamic->DisplayObject->DisplayObject;

	/**
	 * Returns a skin for the current state.
	 *
	 * <p>The following function signature is expected:</p>
	 * <pre>function( target:TextInput, state:Dynamic, oldSkin:DisplayObject = null ):DisplayObject</pre>
	 *
	 * @default null
	 */
	public var stateToSkinFunction(get, set):TextInput->Dynamic->DisplayObject->DisplayObject;
	public function get_stateToSkinFunction():TextInput->Dynamic->DisplayObject->DisplayObject
	{
		return this._stateToSkinFunction;
	}

	/**
	 * @private
	 */
	public function set_stateToSkinFunction(value:TextInput->Dynamic->DisplayObject->DisplayObject):TextInput->Dynamic->DisplayObject->DisplayObject
	{
		if(this._stateToSkinFunction == value)
		{
			return get_stateToSkinFunction();
		}
		this._stateToSkinFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return get_stateToSkinFunction();
	}

	/**
	 * @private
	 */
	private var _iconSelector:StateValueSelector<DisplayObject> = new StateValueSelector();

	/**
	 * The icon used when no other icon is defined for the current state.
	 * Intended for use when multiple states should use the same icon.
	 *
	 * <p>The following example gives the input a default icon to use for
	 * all states when no specific icon is available:</p>
	 *
	 * <listing version="3.0">
	 * input.defaultIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #stateToIconFunction
	 * @see #enabledIcon
	 * @see #disabledIcon
	 * @see #focusedIcon
	 */
	public var defaultIcon(get, set):DisplayObject;
	public function get_defaultIcon():DisplayObject
	{
		return this._iconSelector.defaultValue;
	}

	/**
	 * @private
	 */
	public function set_defaultIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.defaultValue == value)
		{
			return get_defaultIcon();
		}
		this._iconSelector.defaultValue = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_defaultIcon();
	}

	/**
	 * The icon used for the input's enabled state. If <code>null</code>,
	 * then <code>defaultIcon</code> is used instead.
	 *
	 * <p>The following example gives the input an icon for the enabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.enabledIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #disabledIcon
	 */
	public var enabledIcon(get, set):DisplayObject;
	public function get_enabledIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(STATE_ENABLED);
	}

	/**
	 * @private
	 */
	public function set_enabledIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(STATE_ENABLED) == value)
		{
			return get_enabledIcon();
		}
		this._iconSelector.setValueForState(value, STATE_ENABLED);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_enabledIcon();
	}

	/**
	 * The icon used for the input's disabled state. If <code>null</code>,
	 * then <code>defaultIcon</code> is used instead.
	 *
	 * <p>The following example gives the input an icon for the disabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.disabledIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #enabledIcon
	 */
	public var disabledIcon(get, set):DisplayObject;
	public function get_disabledIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(STATE_DISABLED);
	}

	/**
	 * @private
	 */
	public function set_disabledIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(STATE_DISABLED) == value)
		{
			return get_disabledIcon();
		}
		this._iconSelector.setValueForState(value, STATE_DISABLED);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_disabledIcon();
	}

	/**
	 * The icon used for the input's focused state. If <code>null</code>,
	 * then <code>defaultIcon</code> is used instead.
	 *
	 * <p>The following example gives the input an icon for the focused state:</p>
	 *
	 * <listing version="3.0">
	 * button.focusedIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #enabledIcon
	 * @see #disabledIcon
	 */
	public var focusedIcon(get, set):DisplayObject;
	public function get_focusedIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(STATE_FOCUSED);
	}

	/**
	 * @private
	 */
	public function set_focusedIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(STATE_FOCUSED) == value)
		{
			return get_focusedIcon();
		}
		this._iconSelector.setValueForState(value, STATE_FOCUSED);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_focusedIcon();
	}

	/**
	 * @private
	 */
	private var _stateToIconFunction:TextInput->Dynamic->DisplayObject->DisplayObject;

	/**
	 * Returns an icon for the current state.
	 *
	 * <p>The following function signature is expected:</p>
	 * <pre>function( target:TextInput, state:Dynamic, oldIcon:DisplayObject = null ):DisplayObject</pre>
	 *
	 * @default null
	 */
	public var stateToIconFunction(get, set):TextInput->Dynamic->DisplayObject->DisplayObject;
	public function get_stateToIconFunction():TextInput->Dynamic->DisplayObject->DisplayObject
	{
		return this._stateToIconFunction;
	}

	/**
	 * @private
	 */
	public function set_stateToIconFunction(value:TextInput->Dynamic->DisplayObject->DisplayObject):TextInput->Dynamic->DisplayObject->DisplayObject
	{
		if(this._stateToIconFunction == value)
		{
			return get_stateToIconFunction();
		}
		this._stateToIconFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_stateToIconFunction();
	}

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * The space, in pixels, between the icon and the text editor, if an
	 * icon exists.
	 *
	 * <p>The following example creates a gap of 50 pixels between the icon
	 * and the text editor:</p>
	 *
	 * <listing version="3.0">
	 * button.defaultIcon = new Image( texture );
	 * button.gap = 50;</listing>
	 *
	 * @default 0
	 */
	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return this._gap;
	}

	/**
	 * @private
	 */
	public function set_gap(value:Float):Float
	{
		if(this._gap == value)
		{
			return get_gap();
		}
		this._gap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_gap();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the text input's padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.padding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #paddingTop
	 * @see #paddingRight
	 * @see #paddingBottom
	 * @see #paddingLeft
	 */
	public var padding(get, set):Float;
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
		return get_padding();
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the input's top edge and the
	 * input's content.
	 *
	 * <p>In the following example, the text input's top padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.paddingTop = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingTop(get, set):Float;
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
			return get_paddingTop();
		}
		this._paddingTop = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the input's right edge and the
	 * input's content.
	 *
	 * <p>In the following example, the text input's right padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.paddingRight = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingRight(get, set):Float;
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
			return get_paddingRight();
		}
		this._paddingRight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the input's bottom edge and
	 * the input's content.
	 *
	 * <p>In the following example, the text input's bottom padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingBottom(get, set):Float;
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
			return get_paddingBottom();
		}
		this._paddingBottom = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the input's left edge and the
	 * input's content.
	 *
	 * <p>In the following example, the text input's left padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingLeft(get, set):Float;
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
			return get_paddingLeft();
		}
		this._paddingLeft = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
	}

	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;

	//[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
	/**
	 * The location where the text editor is aligned vertically (on
	 * the y-axis).
	 *
	 * <p>The following example aligns the text editor to the top:</p>
	 *
	 * <listing version="3.0">
	 * input.verticalAlign = TextInput.VERTICAL_ALIGN_TOP;</listing>
	 *
	 * @default TextInput.VERTICAL_ALIGN_MIDDLE
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #VERTICAL_ALIGN_JUSTIFY
	 */
	public var verticalAlign(get, set):String;
	public function get_verticalAlign():String
	{
		return _verticalAlign;
	}

	/**
	 * @private
	 */
	public function set_verticalAlign(value:String):String
	{
		if(this._verticalAlign == value)
		{
			return get_verticalAlign();
		}
		this._verticalAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_verticalAlign();
	}

	/**
	 * @private
	 * Flag indicating that the text editor should get focus after it is
	 * created.
	 */
	private var _isWaitingToSetFocus:Bool = false;

	/**
	 * @private
	 */
	private var _pendingSelectionBeginIndex:Int = -1;

	/**
	 * @private
	 */
	private var _pendingSelectionEndIndex:Int = -1;

	/**
	 * @private
	 */
	private var _oldMouseCursor:String = null;

	/**
	 * @private
	 */
	private var _textEditorProperties:PropertyProxy;

	/**
	 * An object that stores properties for the input's text editor
	 * sub-component, and the properties will be passed down to the
	 * text editor when the input validates. The available properties
	 * depend on which <code>ITextEditor</code> implementation is returned
	 * by <code>textEditorFactory</code>. Refer to
	 * <a href="../core/ITextEditor.html"><code>feathers.core.ITextEditor</code></a>
	 * for a list of available text editor implementations.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>textEditorFactory</code> function
	 * instead of using <code>textEditorProperties</code> will result in
	 * better performance.</p>
	 *
	 * <p>In the following example, the text input's text editor properties
	 * are specified (this example assumes that the text editor is a
	 * <code>StageTextTextEditor</code>):</p>
	 *
	 * <listing version="3.0">
	 * input.textEditorProperties.fontName = "Helvetica";
	 * input.textEditorProperties.fontSize = 16;</listing>
	 *
	 * @default null
	 *
	 * @see #textEditorFactory
	 * @see feathers.core.ITextEditor
	 */
	public var textEditorProperties(get, set):PropertyProxy;
	public function get_textEditorProperties():PropertyProxy
	{
		if(this._textEditorProperties == null)
		{
			this._textEditorProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._textEditorProperties;
	}

	/**
	 * @private
	 */
	public function set_textEditorProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._textEditorProperties == value)
		{
			return get_textEditorProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._textEditorProperties != null)
		{
			this._textEditorProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._textEditorProperties = value;
		if(this._textEditorProperties != null)
		{
			this._textEditorProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_textEditorProperties();
	}

	/**
	 * @copy feathers.core.ITextEditor#selectionBeginIndex
	 */
	public var selectionBeginIndex(get, never):Int;
	public function get_selectionBeginIndex():Int
	{
		if(this._pendingSelectionBeginIndex >= 0)
		{
			return this._pendingSelectionBeginIndex;
		}
		if(this.textEditor != null)
		{
			return this.textEditor.selectionBeginIndex;
		}
		return 0;
	}

	/**
	 * @copy feathers.core.ITextEditor#selectionEndIndex
	 */
	public var selectionEndIndex(get, never):Int;
	public function get_selectionEndIndex():Int
	{
		if(this._pendingSelectionEndIndex >= 0)
		{
			return this._pendingSelectionEndIndex;
		}
		if(this.textEditor != null)
		{
			return this.textEditor.selectionEndIndex;
		}
		return 0;
	}

	/**
	 * @private
	 */
	override public function set_visible(value:Bool):Bool
	{
		if(!value)
		{
			this._isWaitingToSetFocus = false;
			if(this._textEditorHasFocus)
			{
				this.textEditor.clearFocus();
			}
		}
		super.visible = value;
		return get_visible();
	}

	/**
	 * @private
	 */
	override public function hitTest(localPoint:Point, forTouch:Bool = false):DisplayObject
	{
		if(forTouch && (!this.visible || !this.touchable))
		{
			return null;
		}
		var clipRect:Rectangle = this.clipRect;
		if(clipRect != null && !clipRect.containsPoint(localPoint))
		{
			return null;
		}
		return this._hitArea.containsPoint(localPoint) ? cast(this.textEditor, DisplayObject) : null;
	}

	/**
	 * @inheritDoc
	 */
	override public function showFocus():Void
	{
		if(this._focusManager == null || this._focusManager.focus != this)
		{
			return;
		}
		this.selectRange(0, this._text.length);
		super.showFocus();
	}

	/**
	 * Focuses the text input control so that it may be edited.
	 */
	public function setFocus():Void
	{
		//if the text editor has focus, no need to set focus
		//if this is invisible, it wouldn't make sense to set focus
		//if there's a touch point ID, we'll be setting focus on our own
		if(this._textEditorHasFocus || !this.visible || this._touchPointID >= 0)
		{
			return;
		}
		if(this.textEditor != null)
		{
			this._isWaitingToSetFocus = false;
			this.textEditor.setFocus();
		}
		else
		{
			this._isWaitingToSetFocus = true;
			this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		}
	}

	/**
	 * Manually removes focus from the text input control.
	 */
	public function clearFocus():Void
	{
		this._isWaitingToSetFocus = false;
		if(this.textEditor == null || !this._textEditorHasFocus)
		{
			return;
		}
		this.textEditor.clearFocus();
	}

	/**
	 * Sets the range of selected characters. If both values are the same,
	 * or the end index is <code>-1</code>, the text insertion position is
	 * changed and nothing is selected.
	 */
	public function selectRange(beginIndex:Int, endIndex:Int = -1):Void
	{
		if(endIndex < 0)
		{
			endIndex = beginIndex;
		}
		if(beginIndex < 0)
		{
			throw new RangeError("Expected start index >= 0. Received " + beginIndex + ".");
		}
		if(endIndex > this._text.length)
		{
			throw new RangeError("Expected end index <= " + this._text.length + ". Received " + endIndex + ".");
		}

		//if it's invalid, we need to wait until validation before changing
		//the selection
		if(this.textEditor != null && (this._isValidating || !this.isInvalid()))
		{
			this._pendingSelectionBeginIndex = -1;
			this._pendingSelectionEndIndex = -1;
			this.textEditor.selectRange(beginIndex, endIndex);
		}
		else
		{
			this._pendingSelectionBeginIndex = beginIndex;
			this._pendingSelectionEndIndex = endIndex;
			this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		}
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var skinInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SKIN);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var textEditorInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_TEXT_EDITOR);
		var promptFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_PROMPT_FACTORY);
		var focusInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_FOCUS);

		if(textEditorInvalid)
		{
			this.createTextEditor();
		}

		if(promptFactoryInvalid || (this._prompt != null && this.promptTextRenderer == null))
		{
			this.createPrompt();
		}

		if(textEditorInvalid || stylesInvalid)
		{
			this.refreshTextEditorProperties();
		}

		if(promptFactoryInvalid || stylesInvalid)
		{
			this.refreshPromptProperties();
		}

		if(textEditorInvalid || dataInvalid)
		{
			var oldIgnoreTextChanges:Bool = this._ignoreTextChanges;
			this._ignoreTextChanges = true;
			this.textEditor.text = this._text;
			this._ignoreTextChanges = oldIgnoreTextChanges;
		}

		if(this.promptTextRenderer != null)
		{
			if(promptFactoryInvalid || dataInvalid || stylesInvalid)
			{
				this.promptTextRenderer.visible = this._prompt != null && this._text.length == 0;
			}

			if(promptFactoryInvalid || stateInvalid)
			{
				this.promptTextRenderer.isEnabled = this._isEnabled;
			}
		}

		if(textEditorInvalid || stateInvalid)
		{
			this.textEditor.isEnabled = this._isEnabled;
			#if flash
			if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor)
			{
				Mouse.cursor = this._oldMouseCursor;
				this._oldMouseCursor = null;
			}
			#end
		}

		if(stateInvalid || skinInvalid)
		{
			this.refreshBackgroundSkin();
		}
		if(stateInvalid || stylesInvalid)
		{
			this.refreshIcon();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layoutChildren();

		if(sizeInvalid || focusInvalid)
		{
			this.refreshFocusIndicator();
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

		var typicalTextWidth:Float = 0;
		var typicalTextHeight:Float = 0;
		var oldTextEditorWidth:Float = 0;
		var oldTextEditorHeight:Float = 0;
		if(this._typicalText != null)
		{
			oldTextEditorWidth = this.textEditor.width;
			oldTextEditorHeight = this.textEditor.height;
			var oldIgnoreTextChanges:Bool = this._ignoreTextChanges;
			this._ignoreTextChanges = true;
			this.textEditor.setSize(Math.NaN, Math.NaN);
			this.textEditor.text = this._typicalText;
			this.textEditor.measureText(HELPER_POINT);
			this.textEditor.text = this._text;
			this._ignoreTextChanges = oldIgnoreTextChanges;
			typicalTextWidth = HELPER_POINT.x;
			typicalTextHeight = HELPER_POINT.y;
		}
		if(this._prompt != null)
		{
			this.promptTextRenderer.setSize(Math.NaN, Math.NaN);
			this.promptTextRenderer.measureText(HELPER_POINT);
			typicalTextWidth = Math.max(typicalTextWidth, HELPER_POINT.x);
			typicalTextHeight = Math.max(typicalTextHeight, HELPER_POINT.y);
		}

		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			newWidth = Math.max(this._originalSkinWidth, typicalTextWidth + this._paddingLeft + this._paddingRight);
			if(newWidth != newWidth) //isNaN
			{
				newWidth = 0;
			}
		}
		if(needsHeight)
		{
			newHeight = Math.max(this._originalSkinHeight, typicalTextHeight + this._paddingTop + this._paddingBottom);
			if(newHeight != newHeight) //isNaN
			{
				newHeight = 0;
			}
		}

		var isMultiline:Bool = Std.is(this.textEditor, IMultilineTextEditor) && cast(this.textEditor, IMultilineTextEditor).multiline;
		if(this._typicalText != null && (this._verticalAlign == VERTICAL_ALIGN_JUSTIFY || isMultiline))
		{
			this.textEditor.width = oldTextEditorWidth;
			this.textEditor.height = oldTextEditorHeight;
		}

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates and adds the <code>textEditor</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #textEditor
	 * @see #textEditorFactory
	 */
	private function createTextEditor():Void
	{
		if(this.textEditor != null)
		{
			this.removeChild(cast(this.textEditor, DisplayObject), true);
			this.textEditor.removeEventListener(Event.CHANGE, textEditor_changeHandler);
			this.textEditor.removeEventListener(FeathersEventType.ENTER, textEditor_enterHandler);
			this.textEditor.removeEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
			this.textEditor.removeEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
			this.textEditor = null;
		}

		var factory:Void->ITextEditor = this._textEditorFactory != null ? this._textEditorFactory : FeathersControl.defaultTextEditorFactory;
		this.textEditor = factory();
		this.textEditor.addEventListener(Event.CHANGE, textEditor_changeHandler);
		this.textEditor.addEventListener(FeathersEventType.ENTER, textEditor_enterHandler);
		this.textEditor.addEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
		this.textEditor.addEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
		this.addChild(cast(this.textEditor, DisplayObject));
	}

	/**
	 * @private
	 */
	private function createPrompt():Void
	{
		if(this.promptTextRenderer != null)
		{
			this.removeChild(cast(this.promptTextRenderer, DisplayObject), true);
			this.promptTextRenderer = null;
		}

		if(this._prompt == null)
		{
			return;
		}

		var factory:Void->ITextRenderer = this._promptFactory != null ? this._promptFactory : FeathersControl.defaultTextRendererFactory;
		this.promptTextRenderer = factory();
		this.addChild(cast(this.promptTextRenderer, DisplayObject));
	}

	/**
	 * @private
	 */
	private function doPendingActions():Void
	{
		if(this._isWaitingToSetFocus)
		{
			this._isWaitingToSetFocus = false;
			if(!this._textEditorHasFocus)
			{
				this.textEditor.setFocus();
			}
		}
		if(this._pendingSelectionBeginIndex >= 0)
		{
			var startIndex:Int = this._pendingSelectionBeginIndex;
			var endIndex:Int = this._pendingSelectionEndIndex;
			this._pendingSelectionBeginIndex = -1;
			this._pendingSelectionEndIndex = -1;
			if(endIndex >= 0)
			{
				var textLength:Int = this._text.length;
				if(endIndex > textLength)
				{
					endIndex = textLength;
				}
			}
			this.selectRange(startIndex, endIndex);
		}
	}

	/**
	 * @private
	 */
	private function refreshTextEditorProperties():Void
	{
		this.textEditor.displayAsPassword = this._displayAsPassword;
		this.textEditor.maxChars = this._maxChars;
		this.textEditor.restrict = this._restrict;
		this.textEditor.isEditable = this._isEditable;
		for (propertyName in Reflect.fields(this._textEditorProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._textEditorProperties.storage, propertyName);
			Reflect.setProperty(this.textEditor, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function refreshPromptProperties():Void
	{
		if(this.promptTextRenderer == null || this._promptProperties == null)
		{
			return;
		}
		this.promptTextRenderer.text = this._prompt;
		var displayPrompt:DisplayObject = cast(this.promptTextRenderer, DisplayObject);
		for (propertyName in Reflect.fields(this._promptProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._promptProperties.storage, propertyName);
			Reflect.setProperty(this.promptTextRenderer, propertyName, propertyValue);
		}
	}

	/**
	 * Sets the <code>currentBackground</code> property.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private function refreshBackgroundSkin():Void
	{
		var oldSkin:DisplayObject = this.currentBackground;
		if(this._stateToSkinFunction != null)
		{
			this.currentBackground = this._stateToSkinFunction(this, this._currentState, oldSkin);
		}
		else
		{
			this.currentBackground = this._skinSelector.updateValue(this, this._currentState, this.currentBackground);
		}
		if(this.currentBackground != oldSkin)
		{
			if(oldSkin != null)
			{
				this.removeChild(oldSkin, false);
			}
			if(this.currentBackground != null)
			{
				this.addChildAt(this.currentBackground, 0);
			}
		}
		if(this.currentBackground != null &&
			(this._originalSkinWidth != this._originalSkinWidth || //isNaN
				this._originalSkinHeight != this._originalSkinHeight)) //isNaN
		{
			if(Std.is(this.currentBackground, IValidating))
			{
				cast(this.currentBackground, IValidating).validate();
			}
			this._originalSkinWidth = this.currentBackground.width;
			this._originalSkinHeight = this.currentBackground.height;
		}
	}

	/**
	 * Sets the <code>currentIcon</code> property.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private function refreshIcon():Void
	{
		var oldIcon:DisplayObject = this.currentIcon;
		if(this._stateToIconFunction != null)
		{
			this.currentIcon = this._stateToIconFunction(this, this._currentState, oldIcon);
		}
		else
		{
			this.currentIcon = this._iconSelector.updateValue(this, this._currentState, this.currentIcon);
		}
		if(Std.is(this.currentIcon, IFeathersControl))
		{
			cast(this.currentIcon, IFeathersControl).isEnabled = this._isEnabled;
		}
		if(this.currentIcon != oldIcon)
		{
			if(oldIcon != null)
			{
				this.removeChild(oldIcon, false);
			}
			if(this.currentIcon != null)
			{
				//we want the icon to appear below the text editor
				var index:Int = this.getChildIndex(cast(this.textEditor, DisplayObject));
				this.addChildAt(this.currentIcon, index);
			}
		}
	}

	/**
	 * Positions and sizes the text input's children.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private function layoutChildren():Void
	{
		if(this.currentBackground != null)
		{
			this.currentBackground.visible = true;
			this.currentBackground.touchable = true;
			this.currentBackground.width = this.actualWidth;
			this.currentBackground.height = this.actualHeight;
		}

		if(Std.is(this.currentIcon, IValidating))
		{
			cast(this.currentIcon, IValidating).validate();
		}

		if(this.currentIcon != null)
		{
			this.currentIcon.x = this._paddingLeft;
			this.textEditor.x = this.currentIcon.x + this.currentIcon.width + this._gap;
			if(this.promptTextRenderer != null)
			{
				this.promptTextRenderer.x = this.currentIcon.x + this.currentIcon.width + this._gap;
			}
		}
		else
		{
			this.textEditor.x = this._paddingLeft;
			if(this.promptTextRenderer != null)
			{
				this.promptTextRenderer.x = this._paddingLeft;
			}
		}
		this.textEditor.width = this.actualWidth - this._paddingRight - this.textEditor.x;
		if(this.promptTextRenderer != null)
		{
			this.promptTextRenderer.width = this.actualWidth - this._paddingRight - this.promptTextRenderer.x;
		}

		var isMultiline:Bool = Std.is(this.textEditor, IMultilineTextEditor) && cast(this.textEditor, IMultilineTextEditor).multiline;
		if(isMultiline || this._verticalAlign == VERTICAL_ALIGN_JUSTIFY)
		{
			//multiline is treated the same as justify
			this.textEditor.height = this.actualHeight - this._paddingTop - this._paddingBottom;
		}
		else
		{
			//clear the height and auto-size instead
			this.textEditor.height = Math.NaN;
		}
		this.textEditor.validate();
		if(this.promptTextRenderer != null)
		{
			this.promptTextRenderer.validate();
		}

		var biggerHeight:Float = this.textEditor.height;
		var biggerBaseline:Float = this.textEditor.baseline;
		var promptBaseline:Float = 0;
		if(this.promptTextRenderer != null)
		{
			promptBaseline = this.promptTextRenderer.baseline;
			var promptHeight:Float = this.promptTextRenderer.height;
			if(promptBaseline > biggerBaseline)
			{
				biggerBaseline = promptBaseline;
			}
			if(promptHeight > biggerHeight)
			{
				biggerHeight = promptHeight;
			}
		}

		if(isMultiline)
		{
			this.textEditor.y = this._paddingTop + biggerBaseline - this.textEditor.baseline;
			if(this.promptTextRenderer != null)
			{
				this.promptTextRenderer.y = this._paddingTop + biggerBaseline - promptBaseline;
				this.promptTextRenderer.height = this.actualHeight - this.promptTextRenderer.y - this._paddingBottom;
			}
			if(this.currentIcon != null)
			{
				this.currentIcon.y = this._paddingTop;
			}
		}
		else
		{
			switch(this._verticalAlign)
			{
				case VERTICAL_ALIGN_JUSTIFY:
				{
					this.textEditor.y = this._paddingTop + biggerBaseline - this.textEditor.baseline;
					if(this.promptTextRenderer != null)
					{
						this.promptTextRenderer.y = this._paddingTop + biggerBaseline - promptBaseline;
						this.promptTextRenderer.height = this.actualHeight - this.promptTextRenderer.y - this._paddingBottom;
					}
					if(this.currentIcon != null)
					{
						this.currentIcon.y = this._paddingTop;
					}
				}
				case VERTICAL_ALIGN_TOP:
				{
					this.textEditor.y = this._paddingTop + biggerBaseline - this.textEditor.baseline;
					if(this.promptTextRenderer != null)
					{
						this.promptTextRenderer.y = this._paddingTop + biggerBaseline - promptBaseline;
					}
					if(this.currentIcon != null)
					{
						this.currentIcon.y = this._paddingTop;
					}
				}
				case VERTICAL_ALIGN_BOTTOM:
				{
					this.textEditor.y = this.actualHeight - this._paddingBottom - biggerHeight + biggerBaseline - this.textEditor.baseline;
					if(this.promptTextRenderer != null)
					{
						this.promptTextRenderer.y = this.actualHeight - this._paddingBottom - biggerHeight + biggerBaseline - promptBaseline;
					}
					if(this.currentIcon != null)
					{
						this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
					}
				}
				default: //middle
				{
					this.textEditor.y = biggerBaseline - this.textEditor.baseline + this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - biggerHeight) / 2;
					if(this.promptTextRenderer != null)
					{
						this.promptTextRenderer.y = biggerBaseline - promptBaseline + this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - biggerHeight) / 2;
					}
					if(this.currentIcon != null)
					{
						this.currentIcon.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2;
					}
				}
			}
		}
	}

	/**
	 * @private
	 */
	private function setFocusOnTextEditorWithTouch(touch:Touch):Void
	{
		if(!this.isFocusEnabled)
		{
			return;
		}
		touch.getLocation(this.stage, HELPER_POINT);
		var isInBounds:Bool = this.contains(this.stage.hitTest(HELPER_POINT, true));
		if(isInBounds && !this._textEditorHasFocus)
		{
			this.textEditor.globalToLocal(HELPER_POINT, HELPER_POINT);
			this._isWaitingToSetFocus = false;
			this.textEditor.setFocus(HELPER_POINT);
		}
	}

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function textInput_removedFromStageHandler(event:Event):Void
	{
		if(this._focusManager == null && this._textEditorHasFocus)
		{
			this.clearFocus();
		}
		this._textEditorHasFocus = false;
		this._isWaitingToSetFocus = false;
		this._touchPointID = -1;
		#if flash
		if(Mouse.supportsNativeCursor && this._oldMouseCursor)
		{
			Mouse.cursor = this._oldMouseCursor;
			this._oldMouseCursor = null;
		}
		#end
	}

	/**
	 * @private
	 */
	private function textInput_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this._touchPointID = -1;
			return;
		}

		var touch:Touch;
		if(this._touchPointID >= 0)
		{
			touch = event.getTouch(this, TouchPhase.ENDED, this._touchPointID);
			if(touch == null)
			{
				return;
			}
			this._touchPointID = -1;
			if(this.textEditor.setTouchFocusOnEndedPhase)
			{
				this.setFocusOnTextEditorWithTouch(touch);
			}
		}
		else
		{
			touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch != null)
			{
				this._touchPointID = touch.id;
				if(!this.textEditor.setTouchFocusOnEndedPhase)
				{
					this.setFocusOnTextEditorWithTouch(touch);
				}
				return;
			}
			touch = event.getTouch(this, TouchPhase.HOVER);
			if(touch != null)
			{
				#if flash
				if(Mouse.supportsNativeCursor && !this._oldMouseCursor)
				{
					this._oldMouseCursor = Mouse.cursor;
					Mouse.cursor = MouseCursor.IBEAM;
				}
				#end
				return;
			}

			//end hover
			#if flash
			if(Mouse.supportsNativeCursor && this._oldMouseCursor)
			{
				Mouse.cursor = this._oldMouseCursor;
				this._oldMouseCursor = null;
			}
			#end
		}
	}

	/**
	 * @private
	 */
	override private function focusInHandler(event:Event):Void
	{
		if(this._focusManager == null)
		{
			return;
		}
		super.focusInHandler(event);
		this.setFocus();
	}

	/**
	 * @private
	 */
	override private function focusOutHandler(event:Event):Void
	{
		if(this._focusManager == null)
		{
			return;
		}
		super.focusOutHandler(event);
		this.textEditor.clearFocus();
	}

	/**
	 * @private
	 */
	private function textEditor_changeHandler(event:Event):Void
	{
		if(this._ignoreTextChanges)
		{
			return;
		}
		this.text = this.textEditor.text;
	}

	/**
	 * @private
	 */
	private function textEditor_enterHandler(event:Event):Void
	{
		this.dispatchEventWith(FeathersEventType.ENTER);
	}

	/**
	 * @private
	 */
	private function textEditor_focusInHandler(event:Event):Void
	{
		if(!this.visible)
		{
			this.textEditor.clearFocus();
			return;
		}
		this._textEditorHasFocus = true;
		this.currentState = STATE_FOCUSED;
		if(this._focusManager && this.isFocusEnabled && this._focusManager.focus !== this)
		{
			//if setFocus() was called manually, we need to notify the focus
			//manager (unless isFocusEnabled is false).
			//if the focus manager already knows that we have focus, it will
			//simply return without doing anything.
			this._focusManager.focus = this;
		}
		else if(!this._focusManager)
		{
			this.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}
	}

	/**
	 * @private
	 */
	private function textEditor_focusOutHandler(event:Event):Void
	{
		this._textEditorHasFocus = false;
		this.currentState = this._isEnabled ? STATE_ENABLED : STATE_DISABLED;
		if(this._focusManager && this._focusManager.focus === this)
		{
			//if clearFocus() was called manually, we need to notify the
			//focus manager if it still thinks we have focus.
			this._focusManager.focus = null;
		}
		else if(!this._focusManager)
		{
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}
	}
}
