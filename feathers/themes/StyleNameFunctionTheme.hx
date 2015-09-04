/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.themes;
import feathers.skins.StyleNameFunctionStyleProvider;
import feathers.skins.StyleProviderRegistry;

import starling.events.EventDispatcher;

/**
 * Base class for themes that pass a <code>StyleNameFunctionStyleProvider</code>
 * to each component class.
 *
 * @see feathers.skins.StyleNameFunctionStyleProvider
 * @see ../../../help/skinning.html Skinning Feathers components
 * @see ../../../help/custom-themes.html Creating custom Feathers themes
 */
class StyleNameFunctionTheme extends EventDispatcher
{
	/**
	 * Constructor.
	 */
	public function new()
	{
		this.createRegistry();
	}

	/**
	 * @private
	 */
	private var _registry:StyleProviderRegistry;

	/**
	 * Disposes the theme.
	 */
	public function dispose():Void
	{
		if(this._registry != null)
		{
			this._registry.dispose();
			this._registry = null;
		}
	}

	/**
	 * Returns a <code>StyleNameFunctionStyleProvider</code> to be passed to
	 * the specified class.
	 */
	public function getStyleProviderForClass(type:Class):StyleNameFunctionStyleProvider
	{
		return cast this._registry.getStyleProvider(type);
	}

	/**
	 * @private
	 */
	protected function createRegistry():void
	{
		this._registry = new StyleProviderRegistry();
	}
	
}
