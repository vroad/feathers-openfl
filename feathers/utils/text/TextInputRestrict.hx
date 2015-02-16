/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.text;
import openfl.utils.Dictionary;

/**
 * Duplicates the functionality of the <code>restrict</code> property on
 * <code>openfl.text.TextField</code>.
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of openfl.text.TextField.restrict in Adobe's Flash Platform API Reference
 */
class TextInputRestrict
{
	/**
	 * @private
	 */
	inline private static var REQUIRES_ESCAPE:Dictionary = new Dictionary();
	REQUIRES_ESCAPE[/\[/g] = "\\[";
	REQUIRES_ESCAPE[/\]/g] = "\\]";
	REQUIRES_ESCAPE[/\{/g] = "\\{";
	REQUIRES_ESCAPE[/\}/g] = "\\}";
	REQUIRES_ESCAPE[/\(/g] = "\\(";
	REQUIRES_ESCAPE[/\)/g] = "\\)";
	REQUIRES_ESCAPE[/\|/g] = "\\|";
	REQUIRES_ESCAPE[/\//g] = "\\/";
	REQUIRES_ESCAPE[/\./g] = "\\.";
	REQUIRES_ESCAPE[/\+/g] = "\\+";
	REQUIRES_ESCAPE[/\*/g] = "\\*";
	REQUIRES_ESCAPE[/\?/g] = "\\?";
	REQUIRES_ESCAPE[/\$/g] = "\\$";

	/**
	 * Constructor.
	 */
	public function TextInputRestrict(restrict:String = null)
	{
		this.restrict = restrict;
	}

	/**
	 * @private
	 */
	private var _restrictStartsWithExclude:Bool = false;

	/**
	 * @private
	 */
	private var _restricts:Array<RegExp>

	/**
	 * @private
	 */
	private var _restrict:String;

	/**
	 * Indicates the set of characters that a user can input.
	 *
	 * <p>In the following example, the text is restricted to numbers:</p>
	 *
	 * <listing version="3.0">
	 * object.restrict = "0-9";</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of openfl.text.TextField.restrict in Adobe's Flash Platform API Reference
	 */
	public var restrict(get, set):String;
	public function get_restrict():String
	{
		return this._restrict;
	}

	/**
	 * @private
	 */
	public function set_restrict(value:String):Void
	{
		if(this._restrict == value)
		{
			return;
		}
		this._restrict = value;
		if(value)
		{
			if(this._restricts)
			{
				this._restricts.length = 0;
			}
			else
			{
				this._restricts = new Array();
			}
			if(this._restrict == "")
			{
				this._restricts.push(/^$/);
			}
			else if(this._restrict)
			{
				var startIndex:Int = 0;
				var isExcluding:Bool = value.indexOf("^") == 0;
				this._restrictStartsWithExclude = isExcluding;
				do
				{
					var nextStartIndex:Int = value.indexOf("^", startIndex + 1);
					if(nextStartIndex >= 0)
					{
						var partialRestrict:String = value.substr(startIndex, nextStartIndex - startIndex);
						this._restricts.push(this.createRestrictRegExp(partialRestrict, isExcluding));
					}
					else
					{
						partialRestrict = value.substr(startIndex)
						this._restricts.push(this.createRestrictRegExp(partialRestrict, isExcluding));
						break;
					}
					startIndex = nextStartIndex;
					isExcluding = !isExcluding;
				}
				while(true)
			}
		}
		else
		{
			this._restricts = null;
		}
	}

	/**
	 * Accepts a character code and determines if it is allowed or not.
	 */
	public function isCharacterAllowed(charCode:Int):Bool
	{
		if(!this._restricts)
		{
			return true;
		}
		var character:String = String.fromCharCode(charCode);
		var isExcluding:Bool = this._restrictStartsWithExclude;
		var isIncluded:Bool = isExcluding;
		var restrictCount:Int = this._restricts.length;
		for(i in 0 ... restrictCount)
		{
			var restrict:RegExp = this._restricts[i];
			if(isExcluding)
			{
				isIncluded = isIncluded && restrict.test(character);
			}
			else
			{
				isIncluded = isIncluded || restrict.test(character);
			}
			isExcluding = !isExcluding;
		}
		return isIncluded;
	}

	/**
	 * Accepts a string of characters and filters out characters that are
	 * not allowed.
	 */
	public function filterText(value:String):String
	{
		if(!this._restricts)
		{
			return value;
		}
		var textLength:Int = value.length;
		var restrictCount:Int = this._restricts.length;
		for(i in 0 ... textLength)
		{
			var character:String = value.charAt(i);
			var isExcluding:Bool = this._restrictStartsWithExclude;
			var isIncluded:Bool = isExcluding;
			for(var j:Int = 0; j < restrictCount; j++)
			{
				var restrict:RegExp = this._restricts[j];
				if(isExcluding)
				{
					isIncluded = isIncluded && restrict.test(character);
				}
				else
				{
					isIncluded = isIncluded || restrict.test(character);
				}
				isExcluding = !isExcluding;
			}
			if(!isIncluded)
			{
				value = value.substr(0, i) + value.substr(i + 1);
				i--;
				textLength--;
			}
		}
		return value;
	}

	/**
	 * @private
	 */
	private function createRestrictRegExp(restrict:String, isExcluding:Bool):RegExp
	{
		if(!isExcluding && restrict.indexOf("^") == 0)
		{
			//unlike regular expressions, which always treat ^ as excluding,
			//restrict uses ^ to swap between excluding and including.
			//if we're including, we need to remove ^ for the regexp
			restrict = restrict.substr(1);
		}
		//we need to do backslash first. otherwise, we'll get duplicates
		restrict = restrict.replace(/\\/g, "\\\\");
		for (key in REQUIRES_ESCAPE)
		{
			var keyRegExp:RegExp = key as RegExp;
			var value:String = REQUIRES_ESCAPE[keyRegExp] as String;
			restrict = restrict.replace(keyRegExp, value);
		}
		return new RegExp("[" + restrict + "]");
	}
}
