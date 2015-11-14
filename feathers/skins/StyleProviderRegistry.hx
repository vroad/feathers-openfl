/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
#if 0
import openfl.utils.Dictionary;
#end
import haxe.ds.WeakMap;
import openfl.errors.ArgumentError;

/**
 * Used by themes to create and manage style providers for component classes.
 */
class StyleProviderRegistry
{
	/**
	 * @private
	 */
	inline private static var GLOBAL_STYLE_PROVIDER_PROPERTY_NAME:String = "globalStyleProvider";

	/**
	 * @private
	 */
	private static function defaultStyleProviderFactory():IStyleProvider
	{
		return new StyleNameFunctionStyleProvider();
	}

	/**
	 * Constructor.
	 *
	 * <p>If style providers are to be registered globally, they will be
	 * passed to the static <code>globalStyleProvider</code> property of the
	 * specified class. If the class does not define a
	 * <code>globalStyleProvider</code> property, an error will be thrown.</p>
	 *
	 * <p>The style provider factory function is expected to have the following
	 * signature:</p>
	 * <pre>function():IStyleProvider</pre>
	 *
	 * @param registerGlobally			Determines if the registry sets the static <code>globalStyleProvider</code> property.
	 * @param styleProviderFactory		An optional function that creates a new style provider. If <code>null</code>, a <code>StyleNameFunctionStyleProvider</code> will be created.
	 */
	public function new(registerGlobally:Bool = true, styleProviderFactory:Dynamic = null)
	{
		this._registerGlobally = registerGlobally;
		if(styleProviderFactory == null)
		{
			this._styleProviderFactory = defaultStyleProviderFactory;
		}
		else
		{
			this._styleProviderFactory = styleProviderFactory;
		}
	}

	/**
	 * @private
	 */
	private var _registerGlobally:Bool;

	/**
	 * @private
	 */
	private var _styleProviderFactory:Dynamic;

	/**
	 * @private
	 */
#if flash
	private var _classToStyleProvider:WeakMap<String, Dynamic> = new WeakMap();
#else
	private var _classToStyleProvider:Map<String, IStyleProvider> = new Map();
#end

	/**
	 * Disposes the theme.
	 */
	public function dispose():Void
	{
		//clear the global style providers, but only if they still match the
		//ones that the theme created. a developer could replace the global
		//style providers with different ones.
		for (className in this._classToStyleProvider.keys())
		{
			this.clearStyleProvider(Type.resolveClass(className));
		}
		this._classToStyleProvider = null;
	}

	/**
	 * Creates an <code>IStyleProvider</code> for the specified component
	 * class, or if it was already created, returns the existing registered
	 * style provider. If the registry is global, a newly created style
	 * provider will be passed to the static <code>globalStyleProvider</code>
	 * property of the specified class.
	 *
	 * @param forClass					The style provider is registered for this class.
	 * @param styleProviderFactory		A factory used to create the style provider.
	 */
	public function getStyleProvider(forClass:Class<Dynamic>):IStyleProvider
	{
		this.validateComponentClass(forClass);
		var className:String = Type.getClassName(forClass);
		var styleProvider:IStyleProvider = this._classToStyleProvider.get(className);
		if(styleProvider == null)
		{
			styleProvider = this._styleProviderFactory();
			this._classToStyleProvider.set(className, styleProvider);
			if(this._registerGlobally)
			{
				Reflect.setProperty(forClass, GLOBAL_STYLE_PROVIDER_PROPERTY_NAME, styleProvider);
			}
		}
		return styleProvider;
	}

	/**
	 * Removes the style provider for the specified component class. If the
	 * registry is global, and the static <code>globalStyleProvider</code>
	 * property contains the same value, it will be set to <code>null</code>.
	 * If it contains a different value, then it will be left unchanged to
	 * avoid conflicts with other registries or code.
	 *
	 * @param forClass		The style provider is registered for this class.
	 */
	public function clearStyleProvider(forClass:Class<Dynamic>):Void
	{
		this.validateComponentClass(forClass);
		var className:String = Type.getClassName(forClass);
		if(this._classToStyleProvider.exists(className))
		{
			var styleProvider:IStyleProvider = this._classToStyleProvider.get(className);
			this._classToStyleProvider.remove(className);
			if(this._registerGlobally &&
				Reflect.getProperty(forClass, GLOBAL_STYLE_PROVIDER_PROPERTY_NAME) == styleProvider)
			{
				//something else may have changed the global style provider
				//after this registry set it, so we check if it's equal
				//before setting to null.
				Reflect.setProperty(forClass, GLOBAL_STYLE_PROVIDER_PROPERTY_NAME, null);
			}
		}
	}

	/**
	 * @private
	 */
	private function validateComponentClass(type:Class<Dynamic>):Void
	{
		if(!this._registerGlobally || Reflect.hasField(type, GLOBAL_STYLE_PROVIDER_PROPERTY_NAME))
		{
			return;
		}
		throw new ArgumentError("Class " + type + " must have a " + GLOBAL_STYLE_PROVIDER_PROPERTY_NAME + " static property to support themes.");
	}
}
