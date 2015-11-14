/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.text;
#if 0
import flash.utils.Dictionary;
#end

/**
 * Duplicates the functionality of the <code>restrict</code> property on
 * <code>flash.text.TextField</code>.
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of flash.text.TextField.restrict in Adobe's Flash Platform API Reference
 */
class TextInputRestrict
{
	/**
	 * @private
	 */
	private static var REQUIRES_ESCAPE:Map<String, String> = new Map();
	//REQUIRES_ESCAPE[/\[/g] = "\\[";
	//REQUIRES_ESCAPE[/\]/g] = "\\]";
	//REQUIRES_ESCAPE[/\{/g] = "\\{";
	//REQUIRES_ESCAPE[/\}/g] = "\\}";
	//REQUIRES_ESCAPE[/\(/g] = "\\(";
	//REQUIRES_ESCAPE[/\)/g] = "\\)";
	//REQUIRES_ESCAPE[/\|/g] = "\\|";
	//REQUIRES_ESCAPE[/\//g] = "\\/";
	//REQUIRES_ESCAPE[/\./g] = "\\.";
	//REQUIRES_ESCAPE[/\+/g] = "\\+";
	//REQUIRES_ESCAPE[/\*/g] = "\\*";
	//REQUIRES_ESCAPE[/\?/g] = "\\?";
	//REQUIRES_ESCAPE[/\$/g] = "\\$";

	/**
	 * Constructor.
	 */
	public function new(restrict:String = null)
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
	private var _restricts:Array<EReg>;

	/**
	 * @private
	 */
	@:native("_restrict1")
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
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of flash.text.TextField.restrict in Adobe's Flash Platform API Reference
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
		if(value != null)
		{
			if(this._restricts != null)
			{
				this._restricts.splice(0, this._restricts.length);
			}
			else
			{
				this._restricts = new Array<EReg>();
			}
			if(this._restrict == "")
			{
				this._restricts.push(~/^$/);
			}
			else if(this._restrict != null)
			{
				var startIndex:Int = 0;
				var isExcluding:Bool = value.indexOf("^") == 0;
				this._restrictStartsWithExclude = isExcluding;
				do
				{
					var nextStartIndex:Int = value.indexOf("^", startIndex + 1);
					var partialRestrict:String;
					if(nextStartIndex >= 0)
					{
						partialRestrict = value.substr(startIndex, nextStartIndex - startIndex);
						this._restricts.push(this.createRestrictRegExp(partialRestrict, isExcluding));
					}
					else
					{
						partialRestrict = value.substr(startIndex);
						this._restricts.push(this.createRestrictRegExp(partialRestrict, isExcluding));
						break;
					}
					startIndex = nextStartIndex;
					isExcluding = !isExcluding;
				}
				while(true);
			}
		}
		else
		{
			this._restricts = null;
		}
		return get_restrict();
	}

	/**
	 * Accepts a character code and determines if it is allowed or not.
	 */
	public function isCharacterAllowed(charCode:Int):Bool
	{
		if(this._restricts == null)
		{
			return true;
		}
		var character:String = String.fromCharCode(charCode);
		var isExcluding:Bool = this._restrictStartsWithExclude;
		var isIncluded:Bool = isExcluding;
		var restrictCount:Int = this._restricts.length;
		//for(var i:Int = 0; i < restrictCount; i++)
		for(i in 0 ... restrictCount)
		{
			var restrict:EReg = this._restricts[i];
			if(isExcluding)
			{
				isIncluded = isIncluded && restrict.match(character);
			}
			else
			{
				isIncluded = isIncluded || restrict.match(character);
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
		if(this._restricts == null)
		{
			return value;
		}
		var textLength:Int = value.length;
		var restrictCount:Int = this._restricts.length;
		//for(var i:Int = 0; i < textLength; i++)
		var i:Int = 0;
		while(i < textLength)
		{
			var character:String = value.charAt(i);
			var isExcluding:Bool = this._restrictStartsWithExclude;
			var isIncluded:Bool = isExcluding;
			//for(var j:Int = 0; j < restrictCount; j++)
			for(j in 0 ... restrictCount)
			{
				var restrict:EReg = this._restricts[j];
				if(isExcluding)
				{
					isIncluded = isIncluded && restrict.match(character);
				}
				else
				{
					isIncluded = isIncluded || restrict.match(character);
				}
				isExcluding = !isExcluding;
			}
			if(!isIncluded)
			{
				value = value.substr(0, i) + value.substr(i + 1);
				i--;
				textLength--;
			}
			
			i++;
		}
		return value;
	}

	/**
	 * @private
	 */
	private function createRestrictRegExp(restrict:String, isExcluding:Bool):EReg
	{
		if(!isExcluding && restrict.indexOf("^") == 0)
		{
			//unlike regular expressions, which always treat ^ as excluding,
			//restrict uses ^ to swap between excluding and including.
			//if we're including, we need to remove ^ for the regexp
			restrict = restrict.substr(1);
		}
		//we need to do backslash first. otherwise, we'll get duplicates
		restrict = (~/\\/g).replace(restrict, "\\\\");
		//for(var key:Object in REQUIRES_ESCAPE)
		for(keyRegExp in REQUIRES_ESCAPE)
		{
			//var keyRegExp:EReg = key;
			var value:String = REQUIRES_ESCAPE[keyRegExp.toString()];
			restrict = new EReg(keyRegExp, "g").replace(restrict, value);
		}
		return new EReg("[" + restrict + "]", "g");
	}
}
