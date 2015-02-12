/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins;
import feathers.display.Scale9Image;
import feathers.textures.Scale9Textures;

/**
 * Values for each state are Scale9Textures instances, and the manager
 * attempts to reuse the existing Scale9Image instance that is passed in to
 * getValueForState() as the old value by swapping the textures.
 */
class Scale9ImageStateValueSelector extends StateWithToggleValueSelector
{
	/**
	 * Constructor.
	 */
	public function Scale9ImageStateValueSelector()
	{
	}

	/**
	 * @private
	 */
	private var _imageProperties:Dynamic;

	/**
	 * Optional properties to set on the Scale9Image instance.
	 *
	 * @see feathers.display.Scale9Image
	 */
	public function get_imageProperties():Dynamic
	{
		if(!this._imageProperties)
		{
			this._imageProperties = {};
		}
		return this._imageProperties;
	}

	/**
	 * @private
	 */
	public function set_imageProperties(value:Dynamic):Void
	{
		this._imageProperties = value;
	}

	/**
	 * @private
	 */
	override public function setValueForState(value:Dynamic, state:Dynamic, isSelected:Bool = false):Void
	{
		if(!(Std.is(value, Scale9Textures)))
		{
			throw new ArgumentError("Value for state must be a Scale9Textures instance.");
		}
		super.setValueForState(value, state, isSelected);
	}

	/**
	 * @private
	 */
	override public function updateValue(target:Dynamic, state:Dynamic, oldValue:Dynamic = null):Dynamic
	{
		var textures:Scale9Textures = super.updateValue(target, state) as Scale9Textures;
		if(!textures)
		{
			return null;
		}

		if(Std.is(oldValue, Scale9Image))
		{
			var image:Scale9Image = Scale9Image(oldValue);
			image.textures = textures;
			image.readjustSize();
		}
		else
		{
			image = new Scale9Image(textures);
		}

		for (propertyName in this._imageProperties)
		{
			var propertyValue:Dynamic = this._imageProperties[propertyName];
			image[propertyName] = propertyValue;
		}

		return image;
	}
}
