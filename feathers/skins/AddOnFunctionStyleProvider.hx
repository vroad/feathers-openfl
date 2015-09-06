/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

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
 *
 * @see ../../../help/skinning.html Skinning Feathers components
 */
class AddOnFunctionStyleProvider implements IStyleProvider
{
	/**
	 * Constructor.
	 */
	public function new(originalStyleProvider:IStyleProvider = null, addOnFunction:Dynamic = null)
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
	public var originalStyleProvider(get, set):IStyleProvider;
	public function get_originalStyleProvider():IStyleProvider
	{
		return this._originalStyleProvider;
	}

	/**
	 * @private
	 */
	public function set_originalStyleProvider(value:IStyleProvider):IStyleProvider
	{
		this._originalStyleProvider = value;
		return get_originalStyleProvider();
	}

	/**
	 * @private
	 */
	private var _addOnFunction:Dynamic;

	/**
	 * A function to call after applying the original style provider's
	 * styles.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:IFeathersControl ):Void</pre>
	 */
	public var addOnFunction(get, set):Dynamic;
	public function get_addOnFunction():Dynamic
	{
		return this._addOnFunction;
	}

	/**
	 * @private
	 */
	public function set_addOnFunction(value:Dynamic):Dynamic
	{
		this._addOnFunction = value;
		return get_addOnFunction();
	}

	/**
	 * @private
	 */
	private var _callBeforeOriginalStyleProvider:Bool = false;

	/**
	 * Determines if the add on function should be called before the
	 * original style provider is applied, or after.
	 *
	 * @default false
	 */
	public var callBeforeOriginalStyleProvider(get, set):Bool;
	public function get_callBeforeOriginalStyleProvider():Bool
	{
		return this._callBeforeOriginalStyleProvider;
	}

	/**
	 * @private
	 */
	public function set_callBeforeOriginalStyleProvider(value:Bool):Bool
	{
		this._callBeforeOriginalStyleProvider = value;
		return get_callBeforeOriginalStyleProvider();
	}

	/**
	 * @inheritDoc
	 */
	public function applyStyles(target:IFeathersControl):Void
	{
		if(this._callBeforeOriginalStyleProvider != null && this._addOnFunction != null)
		{
			this._addOnFunction(target);
		}
		if(this._originalStyleProvider != null)
		{
			this._originalStyleProvider.applyStyles(target);
		}
		if(!this._callBeforeOriginalStyleProvider && this._addOnFunction != null)
		{
			this._addOnFunction(target);
		}
	}


}
