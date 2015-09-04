/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.text
{
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

	public function get_autoCapitalize():String
	{
		return this._autoCapitalize;
	}

	public function set_autoCapitalize(value:String):String
	{
		this._autoCapitalize = value;
	}

	private var _autoCorrect:Boolean = false;

	public function get_autoCorrect():Boolean
	{
		return this._autoCorrect;
	}

	public function set_autoCorrect(value:Boolean):Boolean
	{
		this._autoCorrect = value;
	}

	private var _color:uint = 0x000000;

	public function get_color():uint
	{
		return this._textFormat.color as uint;
	}

	public function set_color(value:uint):uint
	{
		if(this._textFormat.color == value)
		{
			return;
		}
		this._textFormat.color = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public function get_displayAsPassword():Boolean
	{
		return this._textField.displayAsPassword;
	}

	public function set_displayAsPassword(value:Boolean):Boolean
	{
		this._textField.displayAsPassword = value;
	}

	public function get_editable():Boolean
	{
		return this._textField.type == TextFieldType.INPUT;
	}

	public function set_editable(value:Boolean):Boolean
	{
		this._textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
	}

	private var _fontFamily:String = null;

	public function get_fontFamily():String
	{
		return this._textFormat.font;
	}

	public function set_fontFamily(value:String):String
	{
		if(this._textFormat.font == value)
		{
			return;
		}
		this._textFormat.font = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public function get_fontPosture():String
	{
		return this._textFormat.italic ? FontPosture.ITALIC : FontPosture.NORMAL;
	}

	public function set_fontPosture(value:String):String
	{
		if(this.fontPosture == value)
		{
			return;
		}
		this._textFormat.italic = value == FontPosture.ITALIC;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public function get_fontSize():int
	{
		return this._textFormat.size as int;
	}

	public function set_fontSize(value:int):int
	{
		if(this._textFormat.size == value)
		{
			return;
		}
		this._textFormat.size = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public function get_fontWeight():String
	{
		return this._textFormat.bold ? FontWeight.BOLD : FontWeight.NORMAL;
	}

	public function set_fontWeight(value:String):String
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

	public function get_locale():String
	{
		return this._locale;
	}

	public function set_locale(value:String):String
	{
		this._locale = value;
	}

	public function get_maxChars():int
	{
		return this._textField.maxChars;
	}

	public function set_maxChars(value:int):int
	{
		this._textField.maxChars = value;
	}

	public function get_multiline():Boolean
	{
		return this._textField.multiline;
	}

	public function get_restrict():String
	{
		return this._textField.restrict;
	}

	public function set_restrict(value:String):String
	{
		this._textField.restrict = value;
	}

	private var _returnKeyLabel:String = "default";

	public function get_returnKeyLabel():String
	{
		return this._returnKeyLabel;
	}

	public function set_returnKeyLabel(value:String):String
	{
		this._returnKeyLabel = value;
	}

	public function get_selectionActiveIndex():int
	{
		return this._textField.selectionBeginIndex;
	}

	public function get_selectionAnchorIndex():int
	{
		return this._textField.selectionEndIndex;
	}

	private var _softKeyboardType:String = "default";

	public function get_softKeyboardType():String
	{
		return this._softKeyboardType;
	}

	public function set_softKeyboardType(value:String):String
	{
		this._softKeyboardType = value;
	}

	public function get_stage():Stage
	{
		return this._textField.stage;
	}

	public function set_stage(value:Stage):Stage
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

	public function get_text():String
	{
		return this._textField.text;
	}

	public function set_text(value:String):String
	{
		this._textField.text = value;
	}

	private var _textAlign:String = TextFormatAlign.START;

	public function get_textAlign():String
	{
		return this._textAlign;
	}

	public function set_textAlign(value:String):String
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

	public function get_viewPort():Rectangle
	{
		return this._viewPort;
	}

	public function set_viewPort(value:Rectangle):Rectangle
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

	public function get_visible():Boolean
	{
		return this._textField.visible;
	}

	public function set_visible(value:Boolean):Boolean
	{
		this._textField.visible = value;
	}

	public function assignFocus():void
	{
		if(!this._textField.parent)
		{
			return;
		}
		this._textField.stage.focus = this._textField;
	}

	public function dispose():void
	{
		this.stage = null;
		this._textField = null;
		this._textFormat = null;
	}

	public function drawViewPortToBitmapData(bitmap:BitmapData):void
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

	public function selectRange(anchorIndex:int, activeIndex:int):void
	{
		this._textField.setSelection(anchorIndex, activeIndex);
	}

	private function dispatchCompleteIfPossible():void
	{
		if(!this._textField.stage || this._viewPort.isEmpty())
		{
			this._isComplete = false;
		}
		if(this._textField.stage && !this._viewPort.isEmpty())
		{
			this._isComplete = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	private function initialize(initOptions:Object):void
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

	private function textField_eventHandler(event:Event):void
	{
		this.dispatchEvent(event);
	}
}
}
