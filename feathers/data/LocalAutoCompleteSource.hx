/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Dispatched when the suggestions finish loading.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>A <code>ListCollection</code> containing
 *   the suggestions to display.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.COMPLETE
 */
#if 0
[Event(name="complete",type="starling.events.Event")]
#end

/**
 * Creates a list of suggestions for an <code>AutoComplete</code> component
 * by searching through items in a <code>ListCollection</code>.
 *
 * @see feathers.controls.AutoComplete
 * @see feathers.data.ListCollection
 */
class LocalAutoCompleteSource extends EventDispatcher implements IAutoCompleteSource
{
	/**
	 * @private
	 */
	private static function defaultCompareFunction(item:Dynamic, textToMatch:String):Bool
	{
		return item.toString().toLowerCase().indexOf(textToMatch.toLowerCase()) >= 0;
	}

	/**
	 * Constructor.
	 */
	public function new(source:ListCollection = null)
	{
		super();
		this._dataProvider = source;
	}

	/**
	 * @private
	 */
	private var _dataProvider:ListCollection;

	/**
	 * A collection of items to be used as a source for auto-complete
	 * results.
	 */
	public var dataProvider(get, set):ListCollection;
	public function get_dataProvider():ListCollection
	{
		return this._dataProvider;
	}

	/**
	 * @private
	 */
	public function set_dataProvider(value:ListCollection):ListCollection
	{
		this._dataProvider = value;
		return get_dataProvider();
	}

	/**
	 * @private
	 */
	private var _compareFunction:Dynamic->String->Bool = defaultCompareFunction;

	/**
	 * A function used to compare items from the data provider with the
	 * string passed to the <code>load()</code> function in order to
	 * generate a list of suggestions. The function should return
	 * <code>true</code> if the item should be included in the list of
	 * suggestions.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Object, textToMatch:String ):Boolean</pre>
	 */
	public var compareFunction(get, set):Dynamic->String->Bool;
	public function get_compareFunction():Dynamic->String->Bool
	{
		return this._compareFunction;
	}

	/**
	 * @private
	 */
	public function set_compareFunction(value:Dynamic->String->Bool):Dynamic->String->Bool
	{
		if(value == null)
		{
			value = defaultCompareFunction;
		}
		this._compareFunction = value;
		return get_compareFunction();
	}

	/**
	 * @copy feathers.data.IAutoCompleteSource#load()
	 */
	public function load(textToMatch:String, result:ListCollection = null):Void
	{
		if(result != null)
		{
			result.removeAll();
		}
		else
		{
			result = new ListCollection();
		}
		if(this._dataProvider == null || textToMatch.length == 0)
		{
			this.dispatchEventWith(Event.COMPLETE, false, result);
			return;
		}
		var compareFunction:Dynamic->String->Bool = this._compareFunction;
		//for(var i:Int = 0; i < this._dataProvider.length; i++)
		for(i in 0 ... this._dataProvider.length)
		{
			var item:Dynamic = this._dataProvider.getItemAt(i);
			if(compareFunction(item, textToMatch))
			{
				result.addItem(item);
			}
		}
		this.dispatchEventWith(Event.COMPLETE, false, result);
	}
}
