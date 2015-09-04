/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

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
	private static var IS_WORD:EReg = ~/\w/;

	/**
	 * @private
	 */
	private static var IS_WHITESPACE:EReg = ~/\s/;

	/**
	 * Finds the start index of the word that starts before the selection.
	 */
	public static function findPreviousWordStartIndex(text:String, selectionStartIndex:Int):Int
	{
		if(selectionStartIndex <= 0)
		{
			return 0;
		}
		var nextCharIsWord:Bool = IS_WORD.match(text.charAt(selectionStartIndex - 1));
		//for(var i:Int = selectionStartIndex - 2; i >= 0; i--)
		var i:Int = selectionStartIndex - 2;
		while(i >= 0)
		{
			var charIsWord:Bool = IS_WORD.match(text.charAt(i));
			if(!charIsWord && nextCharIsWord)
			{
				return i + 1;
			}
			nextCharIsWord = charIsWord;
			i--;
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
		var prevCharIsWord:Bool = !IS_WHITESPACE.match(text.charAt(selectionEndIndex));
		//for(var i:Int = selectionEndIndex + 1; i < textLength; i++)
		for(i in selectionEndIndex + 1 ... textLength)
		{
			var charIsWord:Bool = IS_WORD.match(text.charAt(i));
			if(charIsWord && !prevCharIsWord)
			{
				return i;
			}
			prevCharIsWord = charIsWord;
		}
		return textLength;
	}
}
