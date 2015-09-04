/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import feathers.core.IFeathersControl;

/**
 * Sets styles on a Feathers UI component by passing the component to a
 * function when the style provider's <code>applyStyles()</code> is called.
 *
 * <p>In the following example, a <code>FunctionStyleProvider</code> is
 * created:</p>
 * <listing version="3.0">
 * var button:Button = new Button();
 * button.label = "Click Me";
 * button.styleProvider = new FunctionStyleProvider( function( target:Button ):Void
 * {
 *     target.defaultSkin = new Image( texture );
 *     // set other styles...
 * });
 * this.addChild( button );</listing>
 *
 * @see ../../../help/skinning.html Skinning Feathers components
 */
class FunctionStyleProvider implements IStyleProvider
{
	/**
	 * Constructor.
	 */
	public function new(skinFunction:Dynamic)
	{
		this._styleFunction = skinFunction;
	}

	/**
	 * @private
	 */
	private var _styleFunction:Dynamic;

	/**
	 * The target Feathers UI component is passed to this function when
	 * <code>applyStyles()</code> is called.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:IFeathersControl ):Void</pre>
	 */
	public var styleFunction(get, set):Dynamic;
	public function get_styleFunction():Dynamic
	{
		return this._styleFunction;
	}

	/**
	 * @private
	 */
	public function set_styleFunction(value:Dynamic):Dynamic
	{
		this._styleFunction = value;
		return get_styleFunction();
	}

	/**
	 * @inheritDoc
	 */
	public function applyStyles(target:IFeathersControl):Void
	{
		if(this._styleFunction == null)
		{
			return;
		}
		this._styleFunction(target);
	}
}
