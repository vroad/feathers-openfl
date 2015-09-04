/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
/**
 * Handles the editing of text, and supports multiline editing. This is not
 * a text editor intended for a <code>TextArea</code> component. Instead,
 * its a text editor intended for a <code>TextInput</code> component and it
 * is expected to provide its own scroll bars.
 *
 * @see feathers.controls.TextInput
 * @see ../../../help/text-editors Introduction to Feathers text editors
 */
interface IMultilineTextEditor extends ITextEditor
{
	/**
	 * Indicates whether the text editor can display more than one line of
	 * text.
	 */
	var multiline(get, set):Bool;
	//function get_multiline():Bool;

	/**
	 * @private
	 */
	//function set_multiline(value:Bool):Void;
}
