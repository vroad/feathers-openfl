/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.text;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;

/**
 * A StageText replacement for Flash Player with matching properties, since
 * StageText is only available in AIR.
 */
public final class StageTextField extends EventDispatcher
{
	/**
	 * Constructor.
	 */
	public function StageTextField(initOptions:Object = null)
	{
		this.initialize(initOptions);
	}

	private var _textField:TextField;
	private var _textFormat:TextFormat;
	private var _isComplete:Boolean = false;

	private var _autoCapitalize:String = "none";

	public function get autoCapitalize():String
	{
		return this._autoCapitalize;
	}

	public function set autoCapitalize(value:String):Void
	{
		this._autoCapitalize = value;
	}

	private var _autoCorrect:Boolean = false;

	public function get autoCorrect():Boolean
	{
		return this._autoCorrect;
	}

	public function set autoCorrect(value:Boolean):Void
	{
		this._autoCorrect = value;
	}

	private var _color:uint = 0x000000;

	public function get color():uint
	{
		return this._textFormat.color as uint;
	}

	public function set color(value:uint):Void
	{
		if(this._textFormat.color == value)
		{
			return;
		}
		this._textFormat.color = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public function get displayAsPassword():Boolean
	{
		return this._textField.displayAsPassword;
	}

	public function set displayAsPassword(value:Boolean):Void
	{
		this._textField.displayAsPassword = value;
	}

	public function get editable():Boolean
	{
		return this._textField.type == TextFieldType.INPUT;
	}

	public function set editable(value:Boolean):Void
	{
		this._textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
	}

	private var _fontFamily:String = null;

	public function get fontFamily():String
	{
		return this._textFormat.font;
	}

	public function set fontFamily(value:String):Void
	{
		if(this._textFormat.font == value)
		{
			return;
		}
		this._textFormat.font = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public function get fontPosture():String
	{
		return this._textFormat.italic ? FontPosture.ITALIC : FontPosture.NORMAL;
	}

	public function set fontPosture(value:String):Void
	{
		if(this.fontPosture == value)
		{
			return;
		}
		this._textFormat.italic = value == FontPosture.ITALIC;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public function get fontSize():Int
	{
		return this._textFormat.size as int;
	}

	public function set fontSize(value:Int):Void
	{
		if(this._textFormat.size == value)
		{
			return;
		}
		this._textFormat.size = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public function get fontWeight():String
	{
		return this._textFormat.bold ? FontWeight.BOLD : FontWeight.NORMAL;
	}

	public function set fontWeight(value:String):Void
	{
		if(this.fontWeight == value)
		{
			return;
		}
		this._textFormat.bold = value == FontWeight.BOLD;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	private var _locale:String = "en";

	public function get locale():String
	{
		return this._locale;
	}

	public function set locale(value:String):Void
	{
		this._locale = value;
	}

	public function get maxChars():Int
	{
		return this._textField.maxChars;
	}

	public function set maxChars(value:Int):Void
	{
		this._textField.maxChars = value;
	}

	public function get multiline():Boolean
	{
		return this._textField.multiline;
	}

	public function get restrict():String
	{
		return this._textField.restrict;
	}

	public function set restrict(value:String):Void
	{
		this._textField.restrict = value;
	}

	private var _returnKeyLabel:String = "default";

	public function get returnKeyLabel():String
	{
		return this._returnKeyLabel;
	}

	public function set returnKeyLabel(value:String):Void
	{
		this._returnKeyLabel = value;
	}

	public function get selectionActiveIndex():Int
	{
		return this._textField.selectionBeginIndex;
	}

	public function get selectionAnchorIndex():Int
	{
		return this._textField.selectionEndIndex;
	}

	private var _softKeyboardType:String = "default";

	public function get softKeyboardType():String
	{
		return this._softKeyboardType;
	}

	public function set softKeyboardType(value:String):Void
	{
		this._softKeyboardType = value;
	}

	public function get stage():Stage
	{
		return this._textField.stage;
	}

	public function set stage(value:Stage):Void
	{
		if(this._textField.stage == value)
		{
			return;
		}
		if(this._textField.stage)
		{
			this._textField.parent.removeChild(this._textField);
		}
		if(value)
		{
			value.addChild(this._textField);
			this.dispatchCompleteIfPossible();
		}
	}

	public function get text():String
	{
		return this._textField.text;
	}

	public function set text(value:String):Void
	{
		this._textField.text = value;
	}

	private var _textAlign:String = TextFormatAlign.START;

	public function get textAlign():String
	{
		return this._textAlign;
	}

	public function set textAlign(value:String):Void
	{
		if(this._textAlign == value)
		{
			return;
		}
		this._textAlign = value;
		if(value == TextFormatAlign.START)
		{
			value = TextFormatAlign.LEFT;
		}
		else if(value == TextFormatAlign.END)
		{
			value = TextFormatAlign.RIGHT;
		}
		this._textFormat.align = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	private var _viewPort:Rectangle = new Rectangle();

	public function get viewPort():Rectangle
	{
		return this._viewPort;
	}

	public function set viewPort(value:Rectangle):Void
	{
		if(!value || value.width < 0 || value.height < 0)
		{
			throw new RangeError("The Rectangle value is not valid.");
		}
		this._viewPort = value;
		this._textField.x = this._viewPort.x;
		this._textField.y = this._viewPort.y;
		this._textField.width = this._viewPort.width;
		this._textField.height = this._viewPort.height;

		this.dispatchCompleteIfPossible();
	}

	public function get visible():Boolean
	{
		return this._textField.visible;
	}

	public function set visible(value:Boolean):Void
	{
		this._textField.visible = value;
	}

	public function assignFocus():Void
	{
		if(!this._textField.parent)
		{
			return;
		}
		this._textField.stage.focus = this._textField;
	}

	public function dispose():Void
	{
		this.stage = null;
		this._textField = null;
		this._textFormat = null;
	}

	public function drawViewPortToBitmapData(bitmap:BitmapData):Void
	{
		if(!bitmap)
		{
			throw new Error("The bitmap is null.");
		}
		if(bitmap.width != this._viewPort.width || bitmap.height != this._viewPort.height)
		{
			throw new ArgumentError("The bitmap's width or height is different from view port's width or height.");
		}
		bitmap.draw(this._textField);
	}

	public function selectRange(anchorIndex:Int, activeIndex:Int):Void
	{
		this._textField.setSelection(anchorIndex, activeIndex);
	}

	private function dispatchCompleteIfPossible():Void
	{
		if(!this._textField.stage || this._viewPort.isEmpty())
		{
			this._isComplete = false;
		}
		if(this._textField.stage && !this.viewPort.isEmpty())
		{
			this._isComplete = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	private function initialize(initOptions:Object):Void
	{
		this._textField = new TextField();
		this._textField.type = TextFieldType.INPUT;
		var isMultiline:Boolean = initOptions && initOptions.hasOwnProperty("multiline") && initOptions.multiline;
		this._textField.multiline = isMultiline;
		this._textField.wordWrap = isMultiline;
		this._textField.addEventListener(Event.CHANGE, textField_eventHandler);
		this._textField.addEventListener(FocusEvent.FOCUS_IN, textField_eventHandler);
		this._textField.addEventListener(FocusEvent.FOCUS_OUT, textField_eventHandler);
		this._textField.addEventListener(KeyboardEvent.KEY_DOWN, textField_eventHandler);
		this._textField.addEventListener(KeyboardEvent.KEY_UP, textField_eventHandler);
		this._textFormat = new TextFormat(null, 11, 0x000000, false, false, false);
		this._textField.defaultTextFormat = this._textFormat;
	}

	private function textField_eventHandler(event:Event):Void
	{
		this.dispatchEvent(event);
	}
}
