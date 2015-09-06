/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

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
#if flash
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
#end

import openfl.errors.ArgumentError;
import openfl.errors.Error;
import openfl.errors.RangeError;

/**
 * A StageText replacement for Flash Player with matching properties, since
 * StageText is only available in AIR.
 */
@:final class StageTextField extends EventDispatcher
{
	/**
	 * Constructor.
	 */
	public function new(initOptions:Dynamic = null)
	{
		super();
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

	public function set_autoCapitalize(value:String):String
	{
		this._autoCapitalize = value;
		return get_autoCapitalize();
	}

	private var _autoCorrect:Bool = false;

	public var autoCorrect(get, set):Bool;
	public function get_autoCorrect():Bool
	{
		return this._autoCorrect;
	}

	public function set_autoCorrect(value:Bool):Bool
	{
		this._autoCorrect = value;
		return get_autoCorrect();
	}

	private var _color:UInt = 0x000000;

	public var color(get, set):UInt;
	public function get_color():UInt
	{
		return this._textFormat.color;
	}

	public function set_color(value:UInt):UInt
	{
		if(this._textFormat.color == value)
		{
			return get_color();
		}
		this._textFormat.color = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
		return get_color();
	}

	public var displayAsPassword(get, set):Bool;
	public function get_displayAsPassword():Bool
	{
		return this._textField.displayAsPassword;
	}

	public function set_displayAsPassword(value:Bool):Bool
	{
		this._textField.displayAsPassword = value;
		return get_displayAsPassword();
	}

	public var editable(get, set):Bool;
	public function get_editable():Bool
	{
		return this._textField.type == TextFieldType.INPUT;
	}

	public function set_editable(value:Bool):Bool
	{
		this._textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		return get_editable();
	}

	private var _fontFamily:String = null;

	public var fontFamily(get, set):String;
	public function get_fontFamily():String
	{
		return this._textFormat.font;
	}

	public function set_fontFamily(value:String):String
	{
		if(this._textFormat.font == value)
		{
			return get_fontFamily();
		}
		this._textFormat.font = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
		return get_fontFamily();
	}

#if flash
	public var fontPosture(get, set):FontPosture;
	public function get_fontPosture():FontPosture
	{
		return this._textFormat.italic ? FontPosture.ITALIC : FontPosture.NORMAL;
	}
#end

#if flash
	public function set_fontPosture(value:FontPosture):FontPosture
	{
		if(this.fontPosture == value)
		{
			return get_fontPosture();
		}
		this._textFormat.italic = value == FontPosture.ITALIC;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
		return get_fontPosture();
	}
#end

	public var fontSize(get, set):Int;
	public function get_fontSize():Int
	{
		return Std.int(this._textFormat.size);
	}

	public function set_fontSize(value:Int):Int
	{
		if(this._textFormat.size == value)
		{
			return get_fontSize();
		}
		this._textFormat.size = value;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
		return get_fontSize();
	}

#if flash
	public var fontWeight(get, set):FontWeight;
	public function get_fontWeight():FontWeight
	{
		return this._textFormat.bold ? FontWeight.BOLD : FontWeight.NORMAL;
	}
#end

#if flash
	public function set_fontWeight(value:FontWeight):FontWeight
	{
		if(this.fontWeight == value)
		{
			return get_fontWeight();
		}
		this._textFormat.bold = value == FontWeight.BOLD;
		this._textField.defaultTextFormat = this._textFormat;
		this._textField.setTextFormat(this._textFormat);
		return get_fontWeight();
	}
#end

	private var _locale:String = "en";

	public var locale(get, set):String;
	public function get_locale():String
	{
		return this._locale;
	}

	public function set_locale(value:String):String
	{
		this._locale = value;
		return get_locale();
	}

	public var maxChars(get, set):Int;
	public function get_maxChars():Int
	{
		return this._textField.maxChars;
	}

	public function set_maxChars(value:Int):Int
	{
		this._textField.maxChars = value;
		return get_maxChars();
	}

	public var multiline(get, never):Bool;
	public function get_multiline():Bool
	{
		return this._textField.multiline;
	}

	public var restrict(get, set):String;
	public function get_restrict():String
	{
		return this._textField.restrict;
	}

	public function set_restrict(value:String):String
	{
		this._textField.restrict = value;
		return get_restrict();
	}

	private var _returnKeyLabel:String = "default";

	public var returnKeyLabel(get, set):String;
	public function get_returnKeyLabel():String
	{
		return this._returnKeyLabel;
	}

	public function set_returnKeyLabel(value:String):String
	{
		this._returnKeyLabel = value;
		return get_returnKeyLabel();
	}

	public var selectionActiveIndex(get, never):Int;
	public function get_selectionActiveIndex():Int
	{
		return this._textField.selectionBeginIndex;
	}

	public var selectionAnchorIndex(get, never):Int;
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

	public function set_softKeyboardType(value:String):String
	{
		this._softKeyboardType = value;
		return get_softKeyboardType();
	}

	public var stage(get, set):Stage;
	public function get_stage():Stage
	{
		return this._textField.stage;
	}

	public function set_stage(value:Stage):Stage
	{
		if(this._textField.stage == value)
		{
			return get_stage();
		}
		if(this._textField.stage != null)
		{
			this._textField.parent.removeChild(this._textField);
		}
		if(value != null)
		{
			value.addChild(this._textField);
			this.dispatchCompleteIfPossible();
		}
		return get_stage();
	}

	public var text(get, set):String;
	public function get_text():String
	{
		return this._textField.text;
	}

	public function set_text(value:String):String
	{
		this._textField.text = value;
		return get_text();
	}

	private var _textAlign:TextFormatAlign = TextFormatAlign.START;

	public var textAlign(get, set):TextFormatAlign;
	public function get_textAlign():TextFormatAlign
	{
		return this._textAlign;
	}

	public function set_textAlign(value:TextFormatAlign):TextFormatAlign
	{
		if(this._textAlign == value)
		{
			return get_textAlign();
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
		return get_textAlign();
	}

	private var _viewPort:Rectangle = new Rectangle();

	public var viewPort(get, set):Rectangle;
	public function get_viewPort():Rectangle
	{
		return this._viewPort;
	}

	public function set_viewPort(value:Rectangle):Rectangle
	{
		if(value == null || value.width < 0 || value.height < 0)
		{
			throw new RangeError("The Rectangle value is not valid.");
		}
		this._viewPort = value;
		this._textField.x = this._viewPort.x;
		this._textField.y = this._viewPort.y;
		this._textField.width = this._viewPort.width;
		this._textField.height = this._viewPort.height;

		this.dispatchCompleteIfPossible();
		return get_viewPort();
	}

	public var visible(get, set):Bool;
	public function get_visible():Bool
	{
		return this._textField.visible;
	}

	public function set_visible(value:Bool):Bool
	{
		this._textField.visible = value;
		return get_visible();
	}

	public function assignFocus():Void
	{
		if(this._textField.parent == null)
		{
			return;
		}
		this._textField.stage.focus = this._textField;
		return;
	}

	public function dispose():Void
	{
		this.stage = null;
		this._textField = null;
		this._textFormat = null;
	}

	public function drawViewPortToBitmapData(bitmap:BitmapData):Void
	{
		if(bitmap == null)
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
		if(this._textField.stage == null || this._viewPort.isEmpty())
		{
			this._isComplete = false;
		}
		if(this._textField.stage != null && !this._viewPort.isEmpty())
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
