/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.text;
import openfl.text.TextFormatAlign;

import starling.text.BitmapFont;
import starling.text.TextField;

import openfl.errors.ArgumentError;

/**
 * Customizes a bitmap font for use by a <code>BitmapFontTextRenderer</code>.
 * 
 * @see feathers.controls.text.BitmapFontTextRenderer
 */
class BitmapFontTextFormat
{
	/**
	 * Constructor.
	 */
	public function new(font:Dynamic, size:Null<Float> = null, color:UInt = 0xffffff, align:TextFormatAlign = null)
	{
		if (align == null) align = TextFormatAlign.LEFT;
		if(Std.is(font, String))
		{
			var fontName:String = cast(font, String);
			font = TextField.getBitmapFont(fontName);
		}
		if(!Std.is(font, BitmapFont))
		{
			throw new ArgumentError("BitmapFontTextFormat font must be a BitmapFont instance or a String representing the name of a registered bitmap font.");
		}
		this.font = font;
		this.size = size;
		this.color = color;
		this.align = align;
	}

	/**
	 * The name of the font.
	 */
	@:keep public var fontName(get, never):String;
	public function get_fontName():String
	{
		return this.font != null ? this.font.name : null;
	}
	
	/**
	 * The BitmapFont instance to use.
	 */
	public var font:BitmapFont;
	
	/**
	 * The color used to tint the bitmap font's texture when rendered.
	 * Tinting works like the "multiply" blend mode. In other words, the
	 * <code>color</code> property can only make the text render with a
	 * darker color. With that in mind, if the characters in the original
	 * texture are black, then you cannot change their color at all. To be
	 * able to render the text using any color, the characters in the
	 * original texture should be white.
	 *
	 * @default 0xffffff
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/BlendMode.html#MULTIPLY starling.display.BlendMode.MULTIPLY
	 */
	public var color:UInt;
	
	/**
	 * The size at which to display the bitmap font. Set to <code>NaN</code>
	 * to use the default size in the BitmapFont instance.
	 *
	 * @default NaN
	 */
	public var size:Float;
	
	/**
	 * The number of extra pixels between characters. May be positive or
	 * negative.
	 *
	 * @default 0
	 */
	public var letterSpacing:Float = 0;

	//[Inspectable(type="String",enumeration="left,center,right")]
	/**
	 * Determines the alignment of the text, either left, center, or right.
	 *
	 * @default openfl.text.TextFormatAlign.LEFT
	 */
	public var align:TextFormatAlign = TextFormatAlign.LEFT;
	
	/**
	 * Determines if the kerning values defined in the BitmapFont instance
	 * will be used for layout.
	 *
	 * @default true
	 */
	public var isKerningEnabled:Bool = true;
}