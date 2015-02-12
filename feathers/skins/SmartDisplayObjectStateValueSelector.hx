/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import feathers.display.Scale3Image;
import feathers.display.Scale9Image;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;

import flash.utils.Dictionary;

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
class SmartDisplayObjectStateValueSelector extends StateWithToggleValueSelector
{
	/**
	 * The value type handler for type <code>starling.textures.Texture</code>.
	 *
	 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html starling.display.Texture
	 */
	public static function textureValueTypeHandler(value:Texture, oldDisplayObject:DisplayObject = null):DisplayObject
	{
		var displayObject:Image;
		if(oldDisplayObject && Object(oldDisplayObject).constructor == Image)
		{
			displayObject = Image(oldDisplayObject);
			displayObject.texture = value;
			displayObject.readjustSize();
		}
		if(!displayObject)
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
		var displayObject:Scale3Image;
		if(oldDisplayObject && Object(oldDisplayObject).constructor == Scale3Image)
		{
			displayObject = Scale3Image(oldDisplayObject);
			displayObject.textures = value;
			displayObject.readjustSize();
		}
		if(!displayObject)
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
		var displayObject:Scale9Image;
		if(oldDisplayObject && Object(oldDisplayObject).constructor == Scale9Image)
		{
			displayObject = Scale9Image(oldDisplayObject);
			displayObject.textures = value;
			displayObject.readjustSize();
		}
		if(!displayObject)
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
		var displayObject:Quad;
		if(oldDisplayObject && Object(oldDisplayObject).constructor == Quad)
		{
			displayObject = Quad(oldDisplayObject);
		}
		if(!displayObject)
		{
			displayObject = new Quad(1, 1, value);
		}
		displayObject.color = value;
		return displayObject;
	}

	/**
	 * Constructor.
	 */
	public function SmartDisplayObjectStateValueSelector()
	{
		this.setValueTypeHandler(Texture, textureValueTypeHandler);
		this.setValueTypeHandler(ConcreteTexture, textureValueTypeHandler);
		this.setValueTypeHandler(SubTexture, textureValueTypeHandler);
		this.setValueTypeHandler(Scale9Textures, scale9TextureValueTypeHandler);
		this.setValueTypeHandler(Scale3Textures, scale3TextureValueTypeHandler);
		//the constructor property of a uint is actually Float.
		this.setValueTypeHandler(Float, uintValueTypeHandler);
	}

	/**
	 * @private
	 */
	private var _displayObjectProperties:Dynamic;

	/**
	 * Optional properties to set on the Scale9Image instance.
	 *
	 * @see feathers.display.Scale9Image
	 */
	public function get_displayObjectProperties():Object
	{
		if(!this._displayObjectProperties)
		{
			this._displayObjectProperties = {};
		}
		return this._displayObjectProperties;
	}

	/**
	 * @private
	 */
	public function set_displayObjectProperties(value:Dynamic):Void
	{
		this._displayObjectProperties = value;
	}

	/**
	 * @private
	 */
	private var _handlers:Dictionary = new Dictionary(true);

	/**
	 * @private
	 */
	override public function setValueForState(value:Dynamic, state:Dynamic, isSelected:Bool = false):Void
	{
		if(value != null)
		{
			var type:Class<Dynamic> = Class(value.constructor);
			if(this._handlers[type] == null)
			{
				throw new ArgumentError("Handler for value type " + type + " has not been set.");
			}
		}
		super.setValueForState(value, state, isSelected);
	}

	/**
	 * @private
	 */
	override public function updateValue(target:Dynamic, state:Dynamic, oldValue:Dynamic = null):Object
	{
		var value:Dynamic = super.updateValue(target, state);
		if(value == null)
		{
			return null;
		}

		var typeHandler:Dynamic = this.valueToValueTypeHandler(value);
		if(typeHandler != null)
		{
			var displayObject:DisplayObject = typeHandler(value, oldValue);
		}
		else
		{
			throw new ArgumentError("Invalid value: ", value);
		}

		for (propertyName in this._displayObjectProperties)
		{
			var propertyValue:Dynamic = this._displayObjectProperties[propertyName];
			displayObject[propertyName] = propertyValue;
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
		this._handlers[type] = handler;
	}

	/**
	 * Returns the function that handles updating a value of a specific type.
	 */
	public function getValueTypeHandler(type:Class<Dynamic>):Function
	{
		return this._handlers[type] as Function;
	}

	/**
	 * Clears a value type handler.
	 */
	public function clearValueTypeHandler(type:Class<Dynamic>):Void
	{
		delete this._handlers[type];
	}

	/**
	 * @private
	 */
	private function valueToValueTypeHandler(value:Dynamic):Function
	{
		var type:Class<Dynamic> = Class(value.constructor);
		return this._handlers[type] as Function;
	}
}
