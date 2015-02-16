/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.text;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.engine.FontPosture;
import openfl.text.engine.FontWeight;

/**
 * A StageText replacement for Flash Player with matching properties, since
 * StageText is only available in AIR.
 */
public final class StageTextField extends EventDispatcher
{
	/**
	 * Constructor.
	 */
	public function StageTextField(initOptions:Dynamic = null)
	{
		this.initialize(initOptions);
	}

	private var _textField:TextField;
	private var _textFormat:TextFormat;
	private var _isComplete:Bool = false;

	private var _autoCapitalize:String = "none";

	public var autoCapitalize(get, set):String;
	public function get_autoCapitalize():String
	{
		return this._autoCapitalize;
	}

	public function set_autoCapitalize(value:String):Void
	{
		this._autoCapitalize = value;
	}

	private var _autoCorrect:Bool = false;

	public var autoCorrect(get, set):Bool;
	public function get_autoCorrect():Bool
	{
		return this._autoCorrect;
	}

	public function set_autoCorrect(value:Bool):Void
	{
		this._autoCorrect = value;
	}

	private var _color:UInt = 0x000000;

	public var color(get, set):UInt;
	public function get_color():UInt
	{
		return this._textFormat.color as uint;
	}

	public function set_color(value:UInt):Void
	{
		if(this._textFormat.color == value)
		{
			return;
		}
		this._textFormat.color = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public var displayAsPassword(get, set):Bool;
	public function get_displayAsPassword():Bool
	{
		return this._textField.displayAsPassword;
	}

	public function set_displayAsPassword(value:Bool):Void
	{
		this._textField.displayAsPassword = value;
	}

	public var editable(get, set):Bool;
	public function get_editable():Bool
	{
		return this._textField.type == TextFieldType.INPUT;
	}

	public function set_editable(value:Bool):Void
	{
		this._textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
	}

	private var _fontFamily:String = null;

	public var fontFamily(get, set):String;
	public function get_fontFamily():String
	{
		return this._textFormat.font;
	}

	public function set_fontFamily(value:String):Void
	{
		if(this._textFormat.font == value)
		{
			return;
		}
		this._textFormat.font = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public var fontPosture(get, set):String;
	public function get_fontPosture():String
	{
		return this._textFormat.italic ? FontPosture.ITALIC : FontPosture.NORMAL;
	}

	public function set_fontPosture(value:String):Void
	{
		if(this.fontPosture == value)
		{
			return;
		}
		this._textFormat.italic = value == FontPosture.ITALIC;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public var fontSize(get, set):Int;
	public function get_fontSize():Int
	{
		return this._textFormat.size as int;
	}

	public function set_fontSize(value:Int):Void
	{
		if(this._textFormat.size == value)
		{
			return;
		}
		this._textFormat.size = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
	}

	public var fontWeight(get, set):String;
	public function get_fontWeight():String
	{
		return this._textFormat.bold ? FontWeight.BOLD : FontWeight.NORMAL;
	}

	public function set_fontWeight(value:String):Void
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

	public var locale(get, set):String;
	public function get_locale():String
	{
		return this._locale;
	}

	public function set_locale(value:String):Void
	{
		this._locale = value;
	}

	public var maxChars(get, set):Int;
	public function get_maxChars():Int
	{
		return this._textField.maxChars;
	}

	public function set_maxChars(value:Int):Void
	{
		this._textField.maxChars = value;
	}

	public var multiline(get, set):Bool;
	public function get_multiline():Bool
	{
		return this._textField.multiline;
	}

	public var restrict(get, set):String;
	public function get_restrict():String
	{
		return this._textField.restrict;
	}

	public function set_restrict(value:String):Void
	{
		this._textField.restrict = value;
	}

	private var _returnKeyLabel:String = "default";

	public var returnKeyLabel(get, set):String;
	public function get_returnKeyLabel():String
	{
		return this._returnKeyLabel;
	}

	public function set_returnKeyLabel(value:String):Void
	{
		this._returnKeyLabel = value;
	}

	public var selectionActiveIndex(get, set):Int;
	public function get_selectionActiveIndex():Int
	{
		return this._textField.selectionBeginIndex;
	}

	public var selectionAnchorIndex(get, set):Int;
	public function get_selectionAnchorIndex():Int
	{
		return this._textField.selectionEndIndex;
	}

	private var _softKeyboardType:String = "default";

	public var softKeyboardType(get, set):String;
	public function get_softKeyboardType():String
	{
		return this._softKeyboardType;
	}

	public function set_softKeyboardType(value:String):Void
	{
		this._softKeyboardType = value;
	}

	public var stage(get, set):Stage;
	public function get_stage():Stage
	{
		return this._textField.stage;
	}

	public function set_stage(value:Stage):Void
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

	public var text(get, set):String;
	public function get_text():String
	{
		return this._textField.text;
	}

	public function set_text(value:String):Void
	{
		this._textField.text = value;
	}

	private var _textAlign:String = TextFormatAlign.START;

	public var textAlign(get, set):String;
	public function get_textAlign():String
	{
		return this._textAlign;
	}

	public function set_textAlign(value:String):Void
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

	public var viewPort(get, set):Rectangle;
	public function get_viewPort():Rectangle
	{
		return this._viewPort;
	}

	public function set_viewPort(value:Rectangle):Void
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

	public var visible(get, set):Bool;
	public function get_visible():Bool
	{
		return this._textField.visible;
	}

	public function set_visible(value:Bool):Void
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

	private function initialize(initOptions:Dynamic):Void
	{
		this._textField = new TextField();
		this._textField.type = TextFieldType.INPUT;
		var isMultiline:Bool = initOptions && initOptions.hasOwnProperty("multiline") && initOptions.multiline;
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
