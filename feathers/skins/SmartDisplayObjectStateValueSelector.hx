/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import feathers.core.PropertyProxy;
import feathers.display.Scale3Image;
import feathers.display.Scale9Image;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;
import haxe.ds.WeakMap;
import openfl.errors.ArgumentError;

import openfl.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.textures.ConcreteTexture;
import starling.textures.SubTexture;
import starling.textures.Texture;

/**
 * Values for each state are textures or colors, and the manager attempts to
 * reuse the existing display object that is passed in to getValueForState()
 * as the old value, if possible. Supports Image and Texture, Scale3Image
 * and Scale3Textures, Scale9Image and Scale9Textures, or Quad and uint
 * (color) value.
 *
 * <p>Additional value type handlers may be added, or the default type
 * handlers may be replaced.</p>
 */
class SmartDisplayObjectStateValueSelector extends StateWithToggleValueSelector<Dynamic>
{
	/**
	 * The value type handler for type <code>starling.textures.Texture</code>.
	 *
	 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html starling.display.Texture
	 */
	public static function textureValueTypeHandler(value:Texture, oldDisplayObject:DisplayObject = null):DisplayObject
	{
		var displayObject:Image = null;
		if(oldDisplayObject != null && Std.is(oldDisplayObject, Image))
		{
			displayObject = cast oldDisplayObject;
			displayObject.texture = value;
			displayObject.readjustSize();
		}
		if(displayObject == null)
		{
			displayObject = new Image(value);
		}
		return displayObject;
	}

	/**
	 * The value type handler for type <code>feathers.textures.Scale3Textures</code>.
	 *
	 * @see feathers.textures.Scale3Textures
	 */
	public static function scale3TextureValueTypeHandler(value:Scale3Textures, oldDisplayObject:DisplayObject = null):DisplayObject
	{
		var displayObject:Scale3Image = null;
		if(oldDisplayObject != null && Std.is(oldDisplayObject, Scale3Image))
		{
			displayObject = cast oldDisplayObject;
			displayObject.textures = value;
			displayObject.readjustSize();
		}
		if(displayObject == null)
		{
			displayObject = new Scale3Image(value);
		}
		return displayObject;
	}

	/**
	 * The value type handler for type <code>feathers.textures.Scale9Textures</code>.
	 *
	 * @see feathers.textures.Scale9Textures
	 */
	public static function scale9TextureValueTypeHandler(value:Scale9Textures, oldDisplayObject:DisplayObject = null):DisplayObject
	{
		var displayObject:Scale9Image = null;
		if(oldDisplayObject != null && Std.is(oldDisplayObject, Scale9Image))
		{
			displayObject = cast oldDisplayObject;
			displayObject.textures = value;
			displayObject.readjustSize();
		}
		if(displayObject == null)
		{
			displayObject = new Scale9Image(value);
		}
		return displayObject;
	}

	/**
	 * The value type handler for type <code>uint</code> (a color to display
	 * by a quad).
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/Quad.html starling.display.Quad
	 */
	public static function uintValueTypeHandler(value:UInt, oldDisplayObject:DisplayObject = null):DisplayObject
	{
		var displayObject:Quad = null;
		if(oldDisplayObject != null && Std.is(oldDisplayObject, Quad))
		{
			displayObject = cast oldDisplayObject;
		}
		if(displayObject == null)
		{
			displayObject = new Quad(1, 1, value);
		}
		displayObject.color = value;
		return displayObject;
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.setValueTypeHandler(Texture, textureValueTypeHandler);
		this.setValueTypeHandler(ConcreteTexture, textureValueTypeHandler);
		this.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		this.setValueTypeHandler(Scale9Textures, scale9TextureValueTypeHandler);
		this.setValueTypeHandler(Scale3Textures, scale3TextureValueTypeHandler);
		//the constructor property of a uint is actually Float.
		//this.setValueTypeHandler(Float, uintValueTypeHandler);
	}

	/**
	 * @private
	 */
	private var _displayObjectProperties:PropertyProxy;

	/**
	 * Optional properties to set on the Scale9Image instance.
	 *
	 * @see feathers.display.Scale9Image
	 */
	public var displayObjectProperties(get, set):PropertyProxy;
	public function get_displayObjectProperties():PropertyProxy
	{
		if(this._displayObjectProperties == null)
		{
			this._displayObjectProperties = new PropertyProxy();
		}
		return this._displayObjectProperties;
	}

	/**
	 * @private
	 */
	public function set_displayObjectProperties(value:PropertyProxy):PropertyProxy
	{
		return this._displayObjectProperties = value;
	}

	/**
	 * @private
	 */
#if flash
	private var _handlers:WeakMap<String, Dynamic> = new WeakMap();
#else
	private var _handlers:Map<String, Dynamic> = new Map();
#end
	/**
	 * @private
	 */
	override public function setValueForState(value:Dynamic, state:String, isSelected:Bool = false):Void
	{
		if(value != null)
		{
			var type:Class<Dynamic> = Type.getClass(value);
			var className:String = Type.getClassName(type);
			if(this._handlers.get(className) == null)
			{
				throw new ArgumentError("Handler for value type " + type + " has not been set.");
			}
		}
		super.setValueForState(value, state, isSelected);
	}

	/**
	 * @private
	 */
	override public function updateValue(target:Dynamic, state:String, oldValue:Dynamic = null):Dynamic
	{
		var value:Dynamic = super.updateValue(target, state);
		if(value == null)
		{
			return null;
		}

		var typeHandler:Dynamic = this.valueToValueTypeHandler(value);
		var displayObject:DisplayObject;
		if(typeHandler != null)
		{
			displayObject = typeHandler(value, oldValue);
		}
		else
		{
			throw new ArgumentError("Invalid value: " + value);
		}

		var className:String = Type.getClassName(Type.getClass(target));
		var instanceFields:Array<String> = Type.getInstanceFields(Type.getClass(displayObject));
		for (propertyName in Reflect.fields(this._displayObjectProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._displayObjectProperties.storage, propertyName);
			if (instanceFields.indexOf("get_" + propertyName) == -1)
				trace('Couldn\'t find a property named "$propertyName" from $className"');
			Reflect.setProperty(displayObject, propertyName, propertyValue);
		}

		return displayObject;
	}

	/**
	 * Sets a function to handle updating a value of a specific type. The
	 * function must have the following signature:
	 *
	 * <pre>function(value:Dynamic, oldDisplayObject:DisplayObject = null):DisplayObject</pre>
	 *
	 * <p>The <code>oldDisplayObject</code> is optional, and it may be of
	 * a type that is different than what the function will return. If the
	 * types do not match, the function should create a new object instead
	 * of reusing the old display object.</p>
	 */
	public function setValueTypeHandler(type:Class<Dynamic>, handler:Dynamic):Void
	{
		this._handlers.set(Type.getClassName(type), handler);
	}

	/**
	 * Returns the function that handles updating a value of a specific type.
	 */
	public function getValueTypeHandler(type:Class<Dynamic>):Dynamic
	{
		return this._handlers.get(Type.getClassName(type));
	}

	/**
	 * Clears a value type handler.
	 */
	public function clearValueTypeHandler(type:Class<Dynamic>):Void
	{
		this._handlers.remove(Type.getClassName(type));
	}

	/**
	 * @private
	 */
	private function valueToValueTypeHandler(value:Dynamic):Dynamic
	{
		var type:Class<Dynamic> = Type.getClass(value);
		var className:String = Type.getClassName(type);
		return this._handlers.get(className);
	}
}
