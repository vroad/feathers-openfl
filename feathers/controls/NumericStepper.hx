/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.INativeFocusOwner;
import feathers.core.PropertyProxy;
import feathers.events.ExclusiveTouch;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.utils.math.FeathersMathUtil.clamp;
import feathers.utils.math.FeathersMathUtil.roundToNearest;
import feathers.utils.math.FeathersMathUtil.roundToPrecision;

import flash.display.InteractiveObject;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the stepper's value changes.
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
 * Select a value between a minimum and a maximum by using increment and
 * decrement buttons or typing in a value in a text input.
 *
 * <p>The following example sets the stepper's values and listens for when
 * when the value changes:</p>
 *
 * <listing version="3.0">
 * var stepper:NumericStepper = new NumericStepper();
 * stepper.minimum = 0;
 * stepper.maximum = 100;
 * stepper.step = 1;
 * stepper.value = 12;
 * stepper.addEventListener( Event.CHANGE, stepper_changeHandler );
 * this.addChild( stepper );</listing>
 *
 * @see ../../../help/numeric-stepper.html How to use the Feathers NumericStepper component
 */
public class NumericStepper extends FeathersControl implements IRange, INativeFocusOwner
{
	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY:String = "decrementButtonFactory";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY:String = "incrementButtonFactory";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_TEXT_INPUT_FACTORY:String = "textInputFactory";

	/**
	 * The default value added to the <code>styleNameList</code> of the decrement
	 * button.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public static const DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON:String = "feathers-numeric-stepper-decrement-button";

	/**
	 * DEPRECATED: Replaced by <code>NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see NumericStepper#DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON
	 */
	public static const DEFAULT_CHILD_NAME_DECREMENT_BUTTON:String = DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON;

	/**
	 * The default value added to the <code>styleNameList</code> of the increment
	 * button.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public static const DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON:String = "feathers-numeric-stepper-increment-button";

	/**
	 * DEPRECATED: Replaced by <code>NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see NumericStepper#DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON
	 */
	public static const DEFAULT_CHILD_NAME_INCREMENT_BUTTON:String = DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON;

	/**
	 * The default value added to the <code>styleNameList</code> of the text
	 * input.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public static const DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT:String = "feathers-numeric-stepper-text-input";

	/**
	 * DEPRECATED: Replaced by <code>NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see NumericStepper#DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT
	 */
	public static const DEFAULT_CHILD_NAME_TEXT_INPUT:String = DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT;

	/**
	 * The decrement button will be placed on the left side of the text
	 * input and the increment button will be placed on the right side of
	 * the text input.
	 *
	 * @see #buttonLayoutMode
	 */
	inline public static var BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL:String = "splitHorizontal";

	/**
	 * The decrement button will be placed below the text input and the
	 * increment button will be placed above the text input.
	 *
	 * @see #buttonLayoutMode
	 */
	inline public static var BUTTON_LAYOUT_MODE_SPLIT_VERTICAL:String = "splitVertical";

	/**
	 * Both the decrement and increment button will be placed on the right
	 * side of the text input. The increment button will be above the
	 * decrement button.
	 *
	 * @see #buttonLayoutMode
	 */
	inline public static var BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL:String = "rightSideVertical";

	/**
	 * The default <code>IStyleProvider</code> for all <code>NumericStepper</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * @private
	 */
	private static function defaultDecrementButtonFactory():Button
	{
		return new Button();
	}

	/**
	 * @private
	 */
	private static function defaultIncrementButtonFactory():Button
	{
		return new Button();
	}

	/**
	 * @private
	 */
	private static function defaultTextInputFactory():TextInput
	{
		return new TextInput();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.addEventListener(Event.REMOVED_FROM_STAGE, numericStepper_removedFromStageHandler);
	}

	/**
	 * The value added to the <code>styleNameList</code> of the decrement
	 * button. This variable is <code>protected</code> so that sub-classes
	 * can customize the decrement button style name in their constructors
	 * instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON</code>.
	 *
	 * <p>To customize the decrement button name without subclassing, see
	 * <code>customDecrementButtonStyleName</code>.</p>
	 *
	 * @see #customDecrementButtonStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	protected var decrementButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON;

	/**
	 * DEPRECATED: Replaced by <code>decrementButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #decrementButtonStyleName
	 */
	protected function get decrementButtonName():String
	{
		return this.decrementButtonStyleName;
	}

	/**
	 * @private
	 */
	protected function set decrementButtonName(value:String):void
	{
		this.decrementButtonStyleName = value;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the increment
	 * button. This variable is <code>protected</code> so that sub-classes
	 * can customize the increment button style name in their constructors
	 * instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON</code>.
	 *
	 * <p>To customize the increment button name without subclassing, see
	 * <code>customIncrementButtonStyleName</code>.</p>
	 *
	 * @see #customIncrementButtonStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	protected var incrementButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON;

	/**
	 * DEPRECATED: Replaced by <code>incrementButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #incrementButtonStyleName
	 */
	protected function get incrementButtonName():String
	{
		return this.incrementButtonStyleName;
	}

	/**
	 * @private
	 */
	protected function set incrementButtonName(value:String):void
	{
		this.incrementButtonStyleName = value;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the text input.
	 * This variable is <code>protected</code> so that sub-classes can
	 * customize the text input style name in their constructors instead of
	 * using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT</code>.
	 *
	 * <p>To customize the text input name without subclassing, see
	 * <code>customTextInputName</code>.</p>
	 *
	 * @see #customTextInputStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	protected var textInputStyleName:String = DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT;

	/**
	 * DEPRECATED: Replaced by <code>textInputStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #textInputStyleName
	 */
	protected function get textInputName():String
	{
		return this.textInputStyleName;
	}

	/**
	 * @private
	 */
	protected function set textInputName(value:String):void
	{
		this.textInputStyleName = value;
	}

	/**
	 * The decrement button sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #createDecrementButton()
	 */
	private var decrementButton:Button;

	/**
	 * The increment button sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #createIncrementButton()
	 */
	private var incrementButton:Button;

	/**
	 * The text input sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #createTextInput()
	 */
	private var textInput:TextInput;

	/**
	 * @private
	 */
	private var touchPointID:Int = -1;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return NumericStepper.globalStyleProvider;
	}

	/**
	 * A text input's text editor may be an <code>INativeFocusOwner</code>,
	 * so we need to return the value of its <code>nativeFocus</code>
	 * property.
	 *
	 * @see feathers.core.INativeFocusOwner
	 */
	public function get nativeFocus():InteractiveObject
	{
		if(this.textInput)
		{
			return this.textInput.nativeFocus;
		}
		return null;
	}

	/**
	 * @private
	 */
	private var _value:Float = 0;

	/**
	 * The value of the numeric stepper, between the minimum and maximum.
	 *
	 * <p>In the following example, the value is changed to 12:</p>
	 *
	 * <listing version="3.0">
	 * stepper.minimum = 0;
	 * stepper.maximum = 100;
	 * stepper.step = 1;
	 * stepper.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #minimum
	 * @see #maximum
	 * @see #step
	 * @see #event:change
	 */
	public var value(get, set):Float;
	public function get_value():Float
	{
		return this._value;
	}

	/**
	 * @private
	 */
	public function set_value(newValue:Float):Float
	{
		if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
		{
			//roundToPrecision helps us to avoid numbers like 1.00000000000000001
			//caused by the inaccuracies of floating point math.
			newValue = roundToPrecision(roundToNearest(newValue - this._minimum, this._step) + this._minimum, 10);
		}
		newValue = clamp(newValue, this._minimum, this._maximum);
		if(this._value == newValue)
		{
			return get_value();
		}
		this._value = newValue;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		this.dispatchEventWith(Event.CHANGE);
		return get_value();
	}

	/**
	 * @private
	 */
	private var _minimum:Float = 0;

	/**
	 * The numeric stepper's value will not go lower than the minimum.
	 *
	 * <p>In the following example, the minimum is changed to 0:</p>
	 *
	 * <listing version="3.0">
	 * stepper.minimum = 0;
	 * stepper.maximum = 100;
	 * stepper.step = 1;
	 * stepper.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #value
	 * @see #maximum
	 * @see #step
	 */
	public var minimum(get, set):Float;
	public function get_minimum():Float
	{
		return this._minimum;
	}

	/**
	 * @private
	 */
	public function set_minimum(value:Float):Float
	{
		if(this._minimum == value)
		{
			return get_minimum();
		}
		this._minimum = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_minimum();
	}

	/**
	 * @private
	 */
	private var _maximum:Float = 0;

	/**
	 * The numeric stepper's value will not go higher than the maximum.
	 *
	 * <p>In the following example, the maximum is changed to 100:</p>
	 *
	 * <listing version="3.0">
	 * stepper.minimum = 0;
	 * stepper.maximum = 100;
	 * stepper.step = 1;
	 * stepper.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #value
	 * @see #minimum
	 * @see #step
	 */
	public var maximum(get, set):Float;
	public function get_maximum():Float
	{
		return this._maximum;
	}

	/**
	 * @private
	 */
	public function set_maximum(value:Float):Float
	{
		if(this._maximum == value)
		{
			return get_maximum();
		}
		this._maximum = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_maximum();
	}

	/**
	 * @private
	 */
	private var _step:Float = 0;

	/**
	 * As the numeric stepper's buttons are pressed, the value is snapped to
	 * a multiple of the step.
	 *
	 * <p>In the following example, the step is changed to 1:</p>
	 *
	 * <listing version="3.0">
	 * stepper.minimum = 0;
	 * stepper.maximum = 100;
	 * stepper.step = 1;
	 * stepper.value = 12;</listing>
	 *
	 * @default 0
	 *
	 * @see #value
	 * @see #minimum
	 * @see #maximum
	 */
	public var step(get, set):Float;
	public function get_step():Float
	{
		return this._step;
	}

	/**
	 * @private
	 */
	public function set_step(value:Float):Float
	{
		if(this._step == value)
		{
			return get_step();
		}
		this._step = value;
		return get_step();
	}

	/**
	 * @private
	 */
	protected var _valueFormatFunction:Function;

	/**
	 * A callback that formats the numeric stepper's value as a string to
	 * display to the user.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function(value:Number):String</pre>
	 *
	 * <p>In the following example, the stepper's value format function is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * stepper.valueFormatFunction = function(value:Number):String
	 * {
	 *     return currencyFormatter.format(value, true);
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #valueParseFunction
	 */
	public function get valueFormatFunction():Function
	{
		return this._valueFormatFunction;
	}

	/**
	 * @private
	 */
	public function set valueFormatFunction(value:Function):void
	{
		if(this._valueFormatFunction == value)
		{
			return;
		}
		this._valueFormatFunction = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	protected var _valueParseFunction:Function;

	/**
	 * A callback that accepts the displayed text of the numeric stepper and
	 * converts it to a simple numeric value.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function(displayedText:String):Number</pre>
	 *
	 * <p>In the following example, the stepper's value parse function is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * stepper.valueParseFunction = function(displayedText:String):String
	 * {
	 *     return currencyFormatter.parse(displayedText).value;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #valueFormatFunction
	 */
	public function get valueParseFunction():Function
	{
		return this._valueParseFunction;
	}

	/**
	 * @private
	 */
	public function set valueParseFunction(value:Function):void
	{
		this._valueParseFunction = value;
	}

	/**
	 * @private
	 */
	protected var currentRepeatAction:Function;

	/**
	 * @private
	 */
	private var _repeatTimer:Timer;

	/**
	 * @private
	 */
	private var _repeatDelay:Float = 0.05;

	/**
	 * The time, in seconds, before actions are repeated. The first repeat
	 * happens after a delay that is five times longer than the following
	 * repeats.
	 *
	 * <p>In the following example, the stepper's repeat delay is set to
	 * 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * stepper.repeatDelay = 0.5;</listing>
	 *
	 * @default 0.05
	 */
	public var repeatDelay(get, set):Float;
	public function get_repeatDelay():Float
	{
		return this._repeatDelay;
	}

	/**
	 * @private
	 */
	public function set_repeatDelay(value:Float):Float
	{
		if(this._repeatDelay == value)
		{
			return get_repeatDelay();
		}
		this._repeatDelay = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_repeatDelay();
	}

	/**
	 * @private
	 */
	private var _buttonLayoutMode:String = BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL;

	//[Inspectable(type="String",enumeration="splitHorizontal,splitVertical,rightSideVertical")]
	/**
	 * How the buttons are positioned relative to the text input.
	 *
	 * <p>In the following example, the button layout is set to place the
	 * buttons on the right side, stacked vertically, for a desktop
	 * appearance:</p>
	 *
	 * <listing version="3.0">
	 * stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;</listing>
	 *
	 * @default NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL
	 *
	 * @see #BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL
	 * @see #BUTTON_LAYOUT_MODE_SPLIT_VERTICAL
	 * @see #BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL
	 */
	public var buttonLayoutMode(get, set):String;
	public function get_buttonLayoutMode():String
	{
		return this._buttonLayoutMode;
	}

	/**
	 * @private
	 */
	public function set_buttonLayoutMode(value:String):String
	{
		if(this._buttonLayoutMode == value)
		{
			return get_buttonLayoutMode();
		}
		this._buttonLayoutMode = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_buttonLayoutMode();
	}

	/**
	 * @private
	 */
	private var _buttonGap:Float = 0;

	/**
	 * The gap, in pixels, between the numeric stepper's increment and
	 * decrement buttons when they are both positioned on the same side. If
	 * the buttons are split between two sides, this value is not used.
	 *
	 * <p>In the following example, the gap between buttons is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;
	 * stepper.buttonGap = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #textInputGap
	 * @see #buttonLayoutMode
	 */
	public var buttonGap(get, set):Float;
	public function get_buttonGap():Float
	{
		return this._buttonGap;
	}

	/**
	 * @private
	 */
	public function set_buttonGap(value:Float):Float
	{
		if(this._buttonGap == value)
		{
			return get_buttonGap();
		}
		this._buttonGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_buttonGap();
	}

	/**
	 * @private
	 */
	private var _textInputGap:Float = 0;

	/**
	 * The gap, in pixels, between the numeric stepper's text input and its
	 * buttons. If the buttons are split, this gap is used on both sides. If
	 * the buttons both appear on the same side, the gap is used only on
	 * that side.
	 *
	 * <p>In the following example, the gap between the text input and buttons is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * stepper.textInputGap = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #buttonGap
	 * @see #buttonLayoutMode
	 */
	public var textInputGap(get, set):Float;
	public function get_textInputGap():Float
	{
		return this._textInputGap;
	}

	/**
	 * @private
	 */
	public function set_textInputGap(value:Float):Float
	{
		if(this._textInputGap == value)
		{
			return get_textInputGap();
		}
		this._textInputGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_textInputGap();
	}

	/**
	 * @private
	 */
	private var _decrementButtonFactory:Void->Button;

	/**
	 * A function used to generate the numeric stepper's decrement button
	 * sub-component. The decrement button must be an instance of
	 * <code>Button</code>. This factory can be used to change properties on
	 * the decrement button when it is first created. For instance, if you
	 * are skinning Feathers components without a theme, you might use this
	 * factory to set skins and other styles on the decrement button.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom decrement button factory is passed
	 * to the stepper:</p>
	 *
	 * <listing version="3.0">
	 * stepper.decrementButtonFactory = function():Button
	 * {
	 *     var button:Button = new Button();
	 *     button.defaultSkin = new Image( upTexture );
	 *     button.downSkin = new Image( downTexture );
	 *     return button;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #decrementButtonProperties
	 */
	public var decrementButtonFactory(get, set):Void->Button;
	public function get_decrementButtonFactory():Void->Button
	{
		return this._decrementButtonFactory;
	}

	/**
	 * @private
	 */
	public function set_decrementButtonFactory(value:Void->Button):Void->Button
	{
		if(this._decrementButtonFactory == value)
		{
			return get_decrementButtonFactory();
		}
		this._decrementButtonFactory = value;
		this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		return get_decrementButtonFactory();
	}

	/**
	 * @private
	 */
	protected var _customDecrementButtonStyleName:String;

	/**
	 * A style name to add to the numeric stepper's decrement button
	 * sub-component. Typically used by a theme to provide different styles
	 * to different numeric steppers.
	 *
	 * <p>In the following example, a custom decrement button style name is
	 * passed to the stepper:</p>
	 *
	 * <listing version="3.0">
	 * stepper.customDecrementButtonStyleName = "my-custom-decrement-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-decrement-button", setCustomDecrementButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #decrementButtonFactory
	 * @see #decrementButtonProperties
	 */
	public function get customDecrementButtonStyleName():String
	{
		return this._customDecrementButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set customDecrementButtonStyleName(value:String):void
	{
		if(this._customDecrementButtonStyleName == value)
		{
			return get_customDecrementButtonName();
		}
		this._customDecrementButtonStyleName = value;
		this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		return get_customDecrementButtonName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customDecrementButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customDecrementButtonStyleName
	 */
	public function get customDecrementButtonName():String
	{
		return this.customDecrementButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set customDecrementButtonName(value:String):void
	{
		this.customDecrementButtonStyleName = value;
	}

	/**
	 * @private
	 */
	private var _decrementButtonProperties:PropertyProxy;

	/**
	 * An object that stores properties for the numeric stepper's decrement
	 * button sub-component, and the properties will be passed down to the
	 * decrement button when the numeric stepper validates. For a list of
	 * available properties, refer to <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>decrementButtonFactory</code>
	 * function instead of using <code>decrementButtonProperties</code> will
	 * result in better performance.</p>
	 *
	 * <p>In the following example, the stepper's decrement button properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * stepper.decrementButtonProperties.defaultSkin = new Image( upTexture );
	 * stepper.decrementButtonProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 *
	 * @see #decrementButtonFactory
	 * @see feathers.controls.Button
	 */
	public var decrementButtonProperties(get, set):PropertyProxy;
	public function get_decrementButtonProperties():PropertyProxy
	{
		if(this._decrementButtonProperties == null)
		{
			this._decrementButtonProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._decrementButtonProperties;
	}

	/**
	 * @private
	 */
	public function set_decrementButtonProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._decrementButtonProperties == value)
		{
			return get_decrementButtonProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._decrementButtonProperties != null)
		{
			this._decrementButtonProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._decrementButtonProperties = value;
		if(this._decrementButtonProperties != null)
		{
			this._decrementButtonProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_decrementButtonProperties();
	}

	/**
	 * @private
	 */
	private var _decrementButtonLabel:String = null;

	/**
	 * The text displayed by the decrement button. Often, there is no text
	 * displayed on this button and an icon is used instead.
	 *
	 * <p>In the following example, the decrement button's label is customized:</p>
	 *
	 * <listing version="3.0">
	 * stepper.decrementButtonLabel = "-";</listing>
	 *
	 * @default null
	 */
	public var decrementButtonLabel(get, set):String;
	public function get_decrementButtonLabel():String
	{
		return this._decrementButtonLabel;
	}

	/**
	 * @private
	 */
	public function set_decrementButtonLabel(value:String):String
	{
		if(this._decrementButtonLabel == value)
		{
			return get_decrementButtonLabel();
		}
		this._decrementButtonLabel = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_decrementButtonLabel();
	}

	/**
	 * @private
	 */
	private var _incrementButtonFactory:Void->Button;

	/**
	 * A function used to generate the numeric stepper's increment button
	 * sub-component. The increment button must be an instance of
	 * <code>Button</code>. This factory can be used to change properties on
	 * the increment button when it is first created. For instance, if you
	 * are skinning Feathers components without a theme, you might use this
	 * factory to set skins and other styles on the increment button.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom increment button factory is passed
	 * to the stepper:</p>
	 *
	 * <listing version="3.0">
	 * stepper.incrementButtonFactory = function():Button
	 * {
	 *     var button:Button = new Button();
	 *     button.defaultSkin = new Image( upTexture );
	 *     button.downSkin = new Image( downTexture );
	 *     return button;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #incrementButtonProperties
	 */
	public var incrementButtonFactory(get, set):Void->Button;
	public function get_incrementButtonFactory():Void->Button
	{
		return this._incrementButtonFactory;
	}

	/**
	 * @private
	 */
	public function set_incrementButtonFactory(value:Void->Button):Void->Button
	{
		if(this._incrementButtonFactory == value)
		{
			return get_incrementButtonFactory();
		}
		this._incrementButtonFactory = value;
		this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		return get_incrementButtonFactory();
	}

	/**
	 * @private
	 */
	protected var _customIncrementButtonStyleName:String;

	/**
	 * A style name to add to the numeric stepper's increment button
	 * sub-component. Typically used by a theme to provide different styles
	 * to different numeric steppers.
	 *
	 * <p>In the following example, a custom increment button style name is
	 * passed to the stepper:</p>
	 *
	 * <listing version="3.0">
	 * stepper.customIncrementButtonStyleName = "my-custom-increment-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-increment-button", setCustomIncrementButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #incrementButtonFactory
	 * @see #incrementButtonProperties
	 */
	public function get customIncrementButtonStyleName():String
	{
		return this._customIncrementButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set customIncrementButtonStyleName(value:String):void
	{
		if(this._customIncrementButtonStyleName == value)
		{
			return get_customIncrementButtonName();
		}
		this._customIncrementButtonStyleName = value;
		this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		return get_customIncrementButtonName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customIncrementButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customIncrementButtonStyleName
	 */
	public function get customIncrementButtonName():String
	{
		return this.customIncrementButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set customIncrementButtonName(value:String):void
	{
		this.customIncrementButtonStyleName = value;
	}

	/**
	 * @private
	 */
	protected var _incrementButtonProperties:PropertyProxy;

	/**
	 * An object that stores properties for the numeric stepper's increment
	 * button sub-component, and the properties will be passed down to the
	 * increment button when the numeric stepper validates. For a list of
	 * available properties, refer to <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>incrementButtonFactory</code>
	 * function instead of using <code>incrementButtonProperties</code> will
	 * result in better performance.</p>
	 *
	 * <p>In the following example, the stepper's increment button properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * stepper.incrementButtonProperties.defaultSkin = new Image( upTexture );
	 * stepper.incrementButtonProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 *
	 * @see #incrementButtonFactory
	 * @see feathers.controls.Button
	 */
	public var incrementButtonProperties(get, set):PropertyProxy;
	public function get_incrementButtonProperties():PropertyProxy
	{
		if(this._incrementButtonProperties == null)
		{
			this._incrementButtonProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._incrementButtonProperties;
	}

	/**
	 * @private
	 */
	public function set_incrementButtonProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._incrementButtonProperties == value)
		{
			return get_incrementButtonProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._incrementButtonProperties != null)
		{
			this._incrementButtonProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._incrementButtonProperties = value;
		if(this._incrementButtonProperties != null)
		{
			this._incrementButtonProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_incrementButtonProperties();
	}

	/**
	 * @private
	 */
	private var _incrementButtonLabel:String = null;

	/**
	 * The text displayed by the increment button. Often, there is no text
	 * displayed on this button and an icon is used instead.
	 *
	 * <p>In the following example, the increment button's label is customized:</p>
	 *
	 * <listing version="3.0">
	 * stepper.incrementButtonLabel = "+";</listing>
	 *
	 * @default null
	 */
	public var incrementButtonLabel(get, set):String;
	public function get_incrementButtonLabel():String
	{
		return this._incrementButtonLabel;
	}

	/**
	 * @private
	 */
	public function set_incrementButtonLabel(value:String):String
	{
		if(this._incrementButtonLabel == value)
		{
			return get_incrementButtonLabel();
		}
		this._incrementButtonLabel = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_incrementButtonLabel();
	}

	/**
	 * @private
	 */
	private var _textInputFactory:Void->TextInput;

	/**
	 * A function used to generate the numeric stepper's text input
	 * sub-component. The text input must be an instance of <code>TextInput</code>.
	 * This factory can be used to change properties on the text input when
	 * it is first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on the text input.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():TextInput</pre>
	 *
	 * <p>In the following example, a custom text input factory is passed
	 * to the stepper:</p>
	 *
	 * <listing version="3.0">
	 * stepper.textInputFactory = function():TextInput
	 * {
	 *     var textInput:TextInput = new TextInput();
	 *     textInput.backgroundSkin = new Image( texture );
	 *     return textInput;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.TextInput
	 * @see #textInputProperties
	 */
	public var textInputFactory(get, set):Void->TextInput;
	public function get_textInputFactory():Void->TextInput
	{
		return this._textInputFactory;
	}

	/**
	 * @private
	 */
	public function set_textInputFactory(value:Void->TextInput):Void->TextInput
	{
		if(this._textInputFactory == value)
		{
			return get_textInputFactory();
		}
		this._textInputFactory = value;
		this.invalidate(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);
		return get_textInputFactory();
	}

	/**
	 * @private
	 */
	protected var _customTextInputStyleName:String;

	/**
	 * A style name to add to the numeric stepper's text input sub-component.
	 * Typically used by a theme to provide different styles to different
	 * text inputs.
	 *
	 * <p>In the following example, a custom text input style name is passed
	 * to the stepper:</p>
	 *
	 * <listing version="3.0">
	 * stepper.customTextInputStyleName = "my-custom-text-input";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( TextInput ).setFunctionForStyleName( "my-custom-text-input", setCustomTextInputStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #textInputFactory
	 * @see #textInputProperties
	 */
	public function get customTextInputStyleName():String
	{
		return this._customTextInputStyleName;
	}

	/**
	 * @private
	 */
	public function set customTextInputStyleName(value:String):void
	{
		if(this._customTextInputStyleName == value)
		{
			return get_customTextInputName();
		}
		this._customTextInputStyleName = value;
		this.invalidate(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);
		return get_customTextInputName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customTextInputStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customTextInputStyleName
	 */
	public function get customTextInputName():String
	{
		return this.customTextInputStyleName;
	}

	/**
	 * @private
	 */
	public function set customTextInputName(value:String):void
	{
		this.customTextInputStyleName = value;
	}

	/**
	 * @private
	 */
	private var _textInputProperties:PropertyProxy;

	/**
	 * An object that stores properties for the numeric stepper's text
	 * input sub-component, and the properties will be passed down to the
	 * text input when the numeric stepper validates. For a list of
	 * available properties, refer to <a href="TextInput.html"><code>feathers.controls.TextInput</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>textInputFactory</code> function
	 * instead of using <code>textInputProperties</code> will result in
	 * better performance.</p>
	 *
	 * <p>In the following example, the stepper's text input properties
	 * are updated:</p>
	 *
	 * <listing version="3.0">
	 * stepper.textInputProperties.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #textInputFactory
	 * @see feathers.controls.TextInput
	 */
	public var textInputProperties(get, set):PropertyProxy;
	public function get_textInputProperties():PropertyProxy
	{
		if(this._textInputProperties == null)
		{
			this._textInputProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._textInputProperties;
	}

	/**
	 * @private
	 */
	public function set_textInputProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._textInputProperties == value)
		{
			return get_textInputProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._textInputProperties != null)
		{
			this._textInputProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._textInputProperties = value;
		if(this._textInputProperties != null)
		{
			this._textInputProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_textInputProperties();
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
		var decrementButtonFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		var incrementButtonFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		var textInputFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);
		var focusInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_FOCUS);

		if(decrementButtonFactoryInvalid)
		{
			this.createDecrementButton();
		}

		if(incrementButtonFactoryInvalid)
		{
			this.createIncrementButton();
		}

		if(textInputFactoryInvalid)
		{
			this.createTextInput();
		}

		if(decrementButtonFactoryInvalid || stylesInvalid)
		{
			this.refreshDecrementButtonStyles();
		}

		if(incrementButtonFactoryInvalid || stylesInvalid)
		{
			this.refreshIncrementButtonStyles();
		}

		if(textInputFactoryInvalid || stylesInvalid)
		{
			this.refreshTextInputStyles();
		}

		if(textInputFactoryInvalid || dataInvalid)
		{
			this.refreshTypicalText();
			this.refreshDisplayedText();
		}

		if(decrementButtonFactoryInvalid || stateInvalid)
		{
			this.decrementButton.isEnabled = this._isEnabled;
		}

		if(incrementButtonFactoryInvalid || stateInvalid)
		{
			this.incrementButton.isEnabled = this._isEnabled;
		}

		if(textInputFactoryInvalid || stateInvalid)
		{
			this.textInput.isEnabled = this._isEnabled;
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(decrementButtonFactoryInvalid || incrementButtonFactoryInvalid || textInputFactoryInvalid ||
			dataInvalid || stylesInvalid || sizeInvalid)
		{
			this.layoutChildren();
		}

		if(sizeInvalid || focusInvalid)
		{
			this.refreshFocusIndicator();
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

		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;

		this.decrementButton.validate();
		this.incrementButton.validate();
		var oldTextInputWidth:Float = this.textInput.width;
		var oldTextInputHeight:Float = this.textInput.height;
		if(this._buttonLayoutMode == BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL)
		{
			var maxButtonWidth:Float = Math.max(this.decrementButton.width, this.incrementButton.width);
			this.textInput.minWidth = Math.max(0, this._minWidth - maxButtonWidth);
			this.textInput.maxWidth = Math.max(0, this._maxWidth - maxButtonWidth);
			this.textInput.width = Math.max(0, this.explicitWidth - maxButtonWidth);
			this.textInput.height = this.explicitHeight;
			this.textInput.validate();

			if(needsWidth)
			{
				newWidth = this.textInput.width + maxButtonWidth + this._textInputGap;
			}
			if(needsHeight)
			{
				newHeight = Math.max(this.textInput.height, this.decrementButton.height + this._buttonGap + this.incrementButton.height);
			}
		}
		else if(this._buttonLayoutMode == BUTTON_LAYOUT_MODE_SPLIT_VERTICAL)
		{
			this.textInput.minHeight = Math.max(0, this._minHeight - this.decrementButton.height - this.incrementButton.height);
			this.textInput.maxHeight = Math.max(0, this._maxHeight - this.decrementButton.height - this.incrementButton.height);
			this.textInput.height = Math.max(0, this.explicitHeight - this.decrementButton.height - this.incrementButton.height);
			this.textInput.width = this.explicitWidth;
			this.textInput.validate();

			if(needsWidth)
			{
				newWidth = Math.max(Math.max(this.decrementButton.width, this.incrementButton.width), this.textInput.width);
			}
			if(needsHeight)
			{
				newHeight = this.decrementButton.height + this.textInput.height + this.incrementButton.height + 2 * this._textInputGap;
			}
		}
		else //split horizontal
		{
			this.textInput.minWidth = Math.max(0, this._minWidth - this.decrementButton.width - this.incrementButton.width);
			this.textInput.maxWidth = Math.max(0, this._maxWidth - this.decrementButton.width - this.incrementButton.width);
			this.textInput.width = Math.max(0, this.explicitWidth - this.decrementButton.width - this.incrementButton.width);
			this.textInput.height = this.explicitHeight;
			this.textInput.validate();

			if(needsWidth)
			{
				newWidth = this.decrementButton.width + this.textInput.width + this.incrementButton.width + 2 * this._textInputGap;
			}
			if(needsHeight)
			{
				newHeight = Math.max(Math.max(this.decrementButton.height, this.incrementButton.height), this.textInput.height);
			}
		}

		this.textInput.width = oldTextInputWidth;
		this.textInput.height = oldTextInputHeight;
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * @private
	 */
	private function decrement():Void
	{
		this.value = this._value - this._step;
		if(this.textInput.isEditable)
		{
			this.validate();
			this.textInput.selectRange(0, this.textInput.text.length);
		}
	}

	/**
	 * @private
	 */
	private function increment():Void
	{
		this.value = this._value + this._step;
		if(this.textInput.isEditable)
		{
			this.validate();
			this.textInput.selectRange(0, this.textInput.text.length);
		}
	}

	/**
	 * @private
	 */
	private function toMinimum():Void
	{
		this.value = this._minimum;
		if(this.textInput.isEditable)
		{
			this.validate();
			this.textInput.selectRange(0, this.textInput.text.length);
		}
	}

	/**
	 * @private
	 */
	private function toMaximum():Void
	{
		this.value = this._maximum;
		if(this.textInput.isEditable)
		{
			this.validate();
			this.textInput.selectRange(0, this.textInput.text.length);
		}
	}

	/**
	 * Creates and adds the <code>decrementButton</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #decrementButton
	 * @see #decrementButtonFactory
	 * @see #customDecrementButtonStyleName
	 */
	private function createDecrementButton():Void
	{
		if(this.decrementButton != null)
		{
			this.decrementButton.removeFromParent(true);
			this.decrementButton = null;
		}

		var factory:Void->Button = this._decrementButtonFactory != null ? this._decrementButtonFactory : defaultDecrementButtonFactory;
		var decrementButtonStyleName:String = this._customDecrementButtonStyleName != null ? this._customDecrementButtonStyleName : this.decrementButtonStyleName;
		this.decrementButton = factory();
		this.decrementButton.styleNameList.add(decrementButtonStyleName);
		this.decrementButton.addEventListener(TouchEvent.TOUCH, decrementButton_touchHandler);
		this.addChild(this.decrementButton);
	}

	/**
	 * Creates and adds the <code>incrementButton</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #incrementButton
	 * @see #incrementButtonFactory
	 * @see #customIncrementButtonStyleName
	 */
	private function createIncrementButton():Void
	{
		if(this.incrementButton != null)
		{
			this.incrementButton.removeFromParent(true);
			this.incrementButton = null;
		}

		var factory:Void->Button = this._incrementButtonFactory != null ? this._incrementButtonFactory : defaultIncrementButtonFactory;
		var incrementButtonStyleName:String = this._customIncrementButtonStyleName != null ? this._customIncrementButtonStyleName : this.incrementButtonStyleName;
		this.incrementButton = factory();
		this.incrementButton.styleNameList.add(incrementButtonStyleName);
		this.incrementButton.addEventListener(TouchEvent.TOUCH, incrementButton_touchHandler);
		this.addChild(this.incrementButton);
	}

	/**
	 * Creates and adds the <code>textInput</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #textInput
	 * @see #textInputFactory
	 * @see #customTextInputStyleName
	 */
	private function createTextInput():Void
	{
		if(this.textInput != null)
		{
			this.textInput.removeFromParent(true);
			this.textInput = null;
		}

		var factory:Void->TextInput = this._textInputFactory != null ? this._textInputFactory : defaultTextInputFactory;
		var textInputStyleName:String = this._customTextInputStyleName != null ? this._customTextInputStyleName : this.textInputStyleName;
		this.textInput = factory();
		this.textInput.styleNameList.add(textInputStyleName);
		this.textInput.addEventListener(FeathersEventType.ENTER, textInput_enterHandler);
		this.textInput.addEventListener(FeathersEventType.FOCUS_OUT, textInput_focusOutHandler);
		//while we're setting isFocusEnabled to false on the text input when
		//we have a focus manager, we'll still be able to call setFocus() on
		//the text input manually.
		this.textInput.isFocusEnabled = !this._focusManager;
		this.addChild(this.textInput);
	}

	/**
	 * @private
	 */
	private function refreshDecrementButtonStyles():Void
	{
		if (this.decrementButtonProperties != null)
		{
			for (propertyName in Reflect.fields(this._decrementButtonProperties.storage))
			{
				var propertyValue:Dynamic = Reflect.field(this._decrementButtonProperties.storage, propertyName);
				Reflect.setProperty(this.decrementButton, propertyName, propertyValue);
			}
		}
		this.decrementButton.label = this._decrementButtonLabel;
	}

	/**
	 * @private
	 */
	private function refreshIncrementButtonStyles():Void
	{
		if (this._incrementButtonProperties != null)
		{
			for (propertyName in Reflect.fields(this._incrementButtonProperties.storage))
			{
				var propertyValue:Dynamic = Reflect.field(this._incrementButtonProperties.storage, propertyName);
				Reflect.setProperty(this.incrementButton, propertyName, propertyValue);
			}
		}
		this.incrementButton.label = this._incrementButtonLabel;
	}

	/**
	 * @private
	 */
	private function refreshTextInputStyles():Void
	{
		if (this.textInputProperties != null)
		{
			for (propertyName in Reflect.fields(this._textInputProperties.storage))
			{
				var propertyValue:Dynamic = Reflect.field(this._textInputProperties.storage, propertyName);
				Reflect.setProperty(this.textInput, propertyName, propertyValue);
			}
		}
	}

	/**
	 * @private
	 */
	protected function refreshDisplayedText():void
	{
		if(this._valueFormatFunction != null)
		{
			this.textInput.text = this._valueFormatFunction(this._value);
		}
		else
		{
			this.textInput.text = this._value.toString();
		}
	}

	/**
	 * @private
	 */
	protected function refreshTypicalText():void
	{
		var typicalText:String = "";
		var maxCharactersBeforeDecimal:Float = Math.max(Math.max(("" + Std.int(this._minimum)).length, ("" + Std.int(this._maximum)).length), ("" + Std.int(this._step)).length);

		//roundToPrecision() helps us to avoid numbers like 1.00000000000000001
		//caused by the inaccuracies of floating point math.
		var maxCharactersAfterDecimal:Float = Math.max(Math.max(("" + roundToPrecision(this._minimum - Std.int(this._minimum), 10)).length,
			("" + roundToPrecision(this._maximum - Std.int(this._maximum), 10)).length),
			("" + roundToPrecision(this._step - Std.int(this._step), 10)).length) - 2;
		if(maxCharactersAfterDecimal < 0)
		{
			maxCharactersAfterDecimal = 0;
		}
		var characterCount:Int = Std.int(maxCharactersBeforeDecimal + maxCharactersAfterDecimal);
		for(i in 0 ... characterCount)
		{
			typicalText += "0";
		}
		if(maxCharactersAfterDecimal > 0)
		{
			typicalText += ".";
		}
		this.textInput.typicalText = typicalText;
	}

	/**
	 * @private
	 */
	private function layoutChildren():Void
	{
		if(this._buttonLayoutMode == BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL)
		{
			var buttonHeight:Float = (this.actualHeight - this._buttonGap) / 2;
			this.incrementButton.y = 0;
			this.incrementButton.height = buttonHeight;
			this.incrementButton.validate();

			this.decrementButton.y = buttonHeight + this._buttonGap;
			this.decrementButton.height = buttonHeight;
			this.decrementButton.validate();

			var buttonWidth:Float = Math.max(this.decrementButton.width, this.incrementButton.width);
			var buttonX:Float = this.actualWidth - buttonWidth;
			this.decrementButton.x = buttonX;
			this.incrementButton.x = buttonX;

			this.textInput.x = 0;
			this.textInput.y = 0;
			this.textInput.width = buttonX - this._textInputGap;
			this.textInput.height = this.actualHeight;
		}
		else if(this._buttonLayoutMode == BUTTON_LAYOUT_MODE_SPLIT_VERTICAL)
		{
			this.incrementButton.x = 0;
			this.incrementButton.y = 0;
			this.incrementButton.width = this.actualWidth;
			this.incrementButton.validate();

			this.decrementButton.x = 0;
			this.decrementButton.width = this.actualWidth;
			this.decrementButton.validate();
			this.decrementButton.y = this.actualHeight - this.decrementButton.height;

			this.textInput.x = 0;
			this.textInput.y = this.incrementButton.height + this._textInputGap;
			this.textInput.width = this.actualWidth;
			this.textInput.height = Math.max(0, this.actualHeight - this.decrementButton.height - this.incrementButton.height - 2 * this._textInputGap);
		}
		else //split horizontal
		{
			this.decrementButton.x = 0;
			this.decrementButton.y = 0;
			this.decrementButton.height = this.actualHeight;
			this.decrementButton.validate();

			this.incrementButton.y = 0;
			this.incrementButton.height = this.actualHeight;
			this.incrementButton.validate();
			this.incrementButton.x = this.actualWidth - this.incrementButton.width;

			this.textInput.x = this.decrementButton.width + this._textInputGap;
			this.textInput.width = this.actualWidth - this.decrementButton.width - this.incrementButton.width - 2 * this._textInputGap;
			this.textInput.height = this.actualHeight;
		}

		//final validation to avoid juggler next frame issues
		this.textInput.validate();
	}

	/**
	 * @private
	 */
	private function startRepeatTimer(action:Dynamic):Void
	{
		if(this.touchPointID >= 0)
		{
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			var claim:DisplayObject = exclusiveTouch.getClaim(this.touchPointID);
			if(claim != this)
			{
				if(claim != null)
				{
					//already claimed by another display object
					return;
				}
				else
				{
					exclusiveTouch.claimTouch(this.touchPointID, this);
				}
			}
		}
		this.currentRepeatAction = action;
		if(this._repeatDelay > 0)
		{
			if(this._repeatTimer == null)
			{
				this._repeatTimer = new Timer(this._repeatDelay * 1000);
				this._repeatTimer.addEventListener(TimerEvent.TIMER, repeatTimer_timerHandler);
			}
			else
			{
				this._repeatTimer.reset();
				this._repeatTimer.delay = this._repeatDelay * 1000;
			}
			this._repeatTimer.start();
		}
	}

	/**
	 * @private
	 */
	private function parseTextInputValue():Void
	{
		if(this._valueParseFunction != null)
		{
			var newValue:Number = this._valueParseFunction(this.textInput.text);
		}
		else
		{
			newValue = parseFloat(this.textInput.text);
		}
		if(newValue === newValue) //!isNaN
		{
			this.value = newValue;
		}
		//we need to force invalidation just to be sure that the text input
		//is displaying the correct value.
		this.invalidate(INVALIDATION_FLAG_DATA);
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
	private function numericStepper_removedFromStageHandler(event:Event):Void
	{
		this.touchPointID = -1;
	}

	/**
	 * @private
	 */
	override private function focusInHandler(event:Event):Void
	{
		super.focusInHandler(event);
		if(this.textInput.isEditable)
		{
			this.textInput.setFocus();
			this.textInput.selectRange(0, this.textInput.text.length);
		}
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
	}

	/**
	 * @private
	 */
	override private function focusOutHandler(event:Event):Void
	{
		super.focusOutHandler(event);
		this.textInput.clearFocus();
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
	}

	/**
	 * @private
	 */
	private function textInput_enterHandler(event:Event):Void
	{
		this.parseTextInputValue();
	}

	/**
	 * @private
	 */
	private function textInput_focusOutHandler(event:Event):Void
	{
		this.parseTextInputValue();
	}

	/**
	 * @private
	 */
	private function decrementButton_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this.touchPointID = -1;
			return;
		}

		var touch:Touch;
		if(this.touchPointID >= 0)
		{
			touch = event.getTouch(this.decrementButton, TouchPhase.ENDED, this.touchPointID);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = -1;
			this._repeatTimer.stop();
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
		}
		else //if we get here, we don't have a saved touch ID yet
		{
			touch = event.getTouch(this.decrementButton, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = touch.id;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			this.decrement();
			this.startRepeatTimer(this.decrement);
		}
	}

	/**
	 * @private
	 */
	private function incrementButton_touchHandler(event:TouchEvent):Void
	{
		if(!this._isEnabled)
		{
			this.touchPointID = -1;
			return;
		}

		var touch:Touch;
		if(this.touchPointID >= 0)
		{
			touch = event.getTouch(this.incrementButton, TouchPhase.ENDED, this.touchPointID);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = -1;
			this._repeatTimer.stop();
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
		}
		else //if we get here, we don't have a saved touch ID yet
		{
			touch = event.getTouch(this.incrementButton, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this.touchPointID = touch.id;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			this.increment();
			this.startRepeatTimer(this.increment);
		}
	}

	/**
	 * @private
	 */
	private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.keyCode == Keyboard.HOME)
		{
			//prevent default so that text input selection doesn't change
			event.preventDefault();
			this.toMinimum();
		}
		else if(event.keyCode == Keyboard.END)
		{
			//prevent default so that text input selection doesn't change
			event.preventDefault();
			this.toMaximum();
		}
		else if(event.keyCode == Keyboard.UP)
		{
			//prevent default so that text input selection doesn't change
			event.preventDefault();
			this.increment();
		}
		else if(event.keyCode == Keyboard.DOWN)
		{
			//prevent default so that text input selection doesn't change
			event.preventDefault();
			this.decrement();
		}
	}

	/**
	 * @private
	 */
	private function repeatTimer_timerHandler(event:TimerEvent):Void
	{
		if(this._repeatTimer.currentCount < 5)
		{
			return;
		}
		this.currentRepeatAction();
	}
}
