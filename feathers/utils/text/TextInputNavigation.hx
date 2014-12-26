/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.text;
/**
 * Functions for navigating text inputs with the keyboard.
 */
class TextInputNavigation
{
	/**
	 * @private
	 */
	inline private static var IS_WORD:RegExp = /\w/;

	/**
	 * @private
	 */
	inline private static var IS_WHITESPACE:RegExp = /\s/;

	/**
	 * Finds the start index of the word that starts before the selection.
	 */
	public static function findPreviousWordStartIndex(text:String, selectionStartIndex:Int):Int
	{
		if(selectionStartIndex <= 0)
		{
			return 0;
		}
		var nextCharIsWord:Boolean = IS_WORD.test(text.charAt(selectionStartIndex - 1));
		for(var i:Int = selectionStartIndex - 2; i >= 0; i--)
		{
			var charIsWord:Boolean = IS_WORD.test(text.charAt(i));
			if(!charIsWord && nextCharIsWord)
			{
				return i + 1;
			}
			nextCharIsWord = charIsWord;
		}
		return 0;
	}

	/**
	 * Finds the start index of the next word that starts after the
	 * selection.
	 */
	public static function findNextWordStartIndex(text:String, selectionEndIndex:Int):Int
	{
		var textLength:Int = text.length;
		if(selectionEndIndex >= textLength - 1)
		{
			return textLength;
		}
		//the first character is a special case. any non-whitespace is
		//considered part of the word.
		var prevCharIsWord:Boolean = !IS_WHITESPACE.test(text.charAt(selectionEndIndex));
		for(var i:Int = selectionEndIndex + 1; i < textLength; i++)
		{
			var charIsWord:Boolean = IS_WORD.test(text.charAt(i));
			if(charIsWord && !prevCharIsWord)
			{
				return i;
			}
			prevCharIsWord = charIsWord;
		}
		return textLength;
	}
}
