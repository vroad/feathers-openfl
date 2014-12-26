/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import feathers.core.IFeathersControl;

/**
 * Wraps an existing style provider to call an additional function after
 * the existing style provider applies its styles.
 *
 * <p>Expected usage is to replace a component's existing style provider:</p>
 * <listing version="3.0">
 * var button:Button = new Button();
 * button.label = "Click Me";
 * function setExtraStyles( target:Button ):Void
 * {
 *     target.defaultIcon = new Image( texture );
 *     // set other styles, if desired...
 * }
 * button.styleProvider = new AddOnFunctionStyleProvider( button.styleProvider, setExtraStyles );
 * this.addChild( button );</listing>
 */
class AddOnFunctionStyleProvider implements IStyleProvider
{
	/**
	 * Constructor.
	 */
	public function AddOnFunctionStyleProvider(originalStyleProvider:IStyleProvider = null, addOnFunction:Function = null)
	{
		this._originalStyleProvider = originalStyleProvider;
		this._addOnFunction = addOnFunction;
	}

	/**
	 * @private
	 */
	private var _originalStyleProvider:IStyleProvider;

	/**
	 * The <code>addOnFunction</code> will be called after the original
	 * style provider applies its styles.
	 */
	public function get_originalStyleProvider():IStyleProvider
	{
		return this._originalStyleProvider;
	}

	/**
	 * @private
	 */
	public function set_originalStyleProvider(value:IStyleProvider):Void
	{
		this._originalStyleProvider = value;
	}

	/**
	 * @private
	 */
	private var _addOnFunction:Function;

	/**
	 * A function to call after applying the original style provider's
	 * styles.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:IFeathersControl ):Void</pre>
	 */
	public function get_addOnFunction():Function
	{
		return this._addOnFunction;
	}

	/**
	 * @private
	 */
	public function set_addOnFunction(value:Function):Void
	{
		this._addOnFunction = value;
	}

	/**
	 * @inheritDoc
	 */
	public function applyStyles(target:IFeathersControl):Void
	{
		if(this._originalStyleProvider)
		{
			this._originalStyleProvider.applyStyles(target);
		}
		if(this._addOnFunction !== null)
		{
			this._addOnFunction(target);
		}
	}


}
