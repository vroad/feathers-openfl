/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IToggle;
import feathers.core.PropertyProxy;
import feathers.skins.IStyleProvider;

import starling.display.DisplayObject;
import starling.events.Event;

/**
 * Dispatched when the button is selected or deselected either
 * programmatically or as a result of user interaction. The value of the
 * <code>isSelected</code> property indicates whether the button is selected
 * or not. Use interaction may only change selection when the
 * <code>isToggle</code> property is set to <code>true</code>.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.CHANGE
 *
 * @see #isSelected
 * @see #isToggle
 *///[Event(name="change",type="starling.events.Event")]

/**
 * A button that may be selected and deselected when triggered.
 *
 * <p>The following example creates a toggle button, and listens for when
 * its selection changes:</p>
 *
 * <listing version="3.0">
 * var button:ToggleButton = new ToggleButton();
 * button.label = "Click Me";
 * button.addEventListener( Event.CHANGE, button_changeHandler );
 * this.addChild( button );</listing>
 *
 * @see ../../../help/toggle-button.html How to use the Feathers ToggleButton component
 */
class ToggleButton extends Button implements IToggle
{
	/**
	 * The default <code>IStyleProvider</code> for all <code>ToggleButton</code>
	 * components. If <code>null</code>, falls back to using
	 * <code>Button.globalStyleProvider</code> instead.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 * @see feathers.controls.Button#globalStyleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		if(ToggleButton.globalStyleProvider != null)
		{
			return ToggleButton.globalStyleProvider;
		}
		return Button.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _isToggle:Bool = true;

	/**
	 * Determines if the button may be selected or deselected as a result of
	 * user interaction. If <code>true</code>, the value of the
	 * <code>isSelected</code> property will be toggled when the button is
	 * triggered.
	 *
	 * <p>The following example disables the ability to toggle:</p>
	 *
	 * <listing version="3.0">
	 * button.isToggle = false;</listing>
	 *
	 * @default true
	 *
	 * @see #isSelected
	 * @see #event:triggered Event.TRIGGERED
	 */
	public var isToggle(get, set):Bool;
	public function get_isToggle():Bool
	{
		return this._isToggle;
	}

	/**
	 * @private
	 */
	public function set_isToggle(value:Bool):Bool
	{
		return this._isToggle = value;
	}

	/**
	 * @private
	 */
	private var _isSelected:Bool = false;

	/**
	 * Indicates if the button is selected or not. The button may be
	 * selected programmatically, even if <code>isToggle</code> is <code>false</code>,
	 * but generally, <code>isToggle</code> should be set to <code>true</code>
	 * to allow the user to select and deselect it by triggering the button
	 * with a click or tap. If focus management is enabled, a button may
	 * also be triggered with the spacebar when the button has focus.
	 *
	 * <p>The following example enables the button to toggle and selects it
	 * automatically:</p>
	 *
	 * <listing version="3.0">
	 * button.isToggle = true;
	 * button.isSelected = true;</listing>
	 *
	 * @default false
	 *
	 * @see #event:change Event.CHANGE
	 * @see #isToggle
	 */
	public var isSelected(get, set):Bool;
	public function get_isSelected():Bool
	{
		return this._isSelected;
	}

	/**
	 * @private
	 */
	public function set_isSelected(value:Bool):Bool
	{
		if(this._isSelected == value)
		{
			return this._isSelected;
		}
		this._isSelected = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STATE);
		this.dispatchEventWith(Event.CHANGE);
		return this._isSelected;
	}

	/**
	 * The skin used when no other skin is defined for the current state
	 * when the button is selected. Has a higher priority than
	 * <code>defaultSkin</code>, but a lower priority than other selected
	 * skins.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a default skin to use for
	 * all selected states when no specific skin is available:</p>
	 *
	 * <listing version="3.0">
	 * button.defaultSelectedSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultSkin
	 * @see #selectedUpSkin
	 * @see #selectedDownSkin
	 * @see #selectedHoverSkin
	 * @see #selectedDisabledSkin
	 */
	public var defaultSelectedSkin(get, set):DisplayObject;
	public function get_defaultSelectedSkin():DisplayObject
	{
		return this._skinSelector.defaultSelectedValue;
	}

	/**
	 * @private
	 */
	public function set_defaultSelectedSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.defaultSelectedValue == value)
		{
			return this._skinSelector.defaultSelectedValue;
		}
		this._skinSelector.defaultSelectedValue = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._skinSelector.defaultSelectedValue;
	}

	/**
	 * The skin used for the button's up state when the button is selected.
	 * If <code>null</code>, then <code>defaultSelectedSkin</code> is used
	 * instead. If <code>defaultSelectedSkin</code> is also
	 * <code>null</code>, then <code>defaultSkin</code> is used.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a skin for the selected up state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedUpSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultSkin
	 * @see #defaultSelectedSkin
	 * @see #STATE_UP
	 */
	public var selectedUpSkin(get, set):DisplayObject;
	public function get_selectedUpSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(Button.STATE_UP, true);
	}

	/**
	 * @private
	 */
	public function set_selectedUpSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(Button.STATE_UP, true) == value)
		{
			return this._skinSelector.getValueForState(Button.STATE_UP, true);
		}
		this._skinSelector.setValueForState(value, Button.STATE_UP, true);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._skinSelector.getValueForState(Button.STATE_UP, true);
	}

	/**
	 * The skin used for the button's down state when the button is
	 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
	 * is used instead. If <code>defaultSelectedSkin</code> is also
	 * <code>null</code>, then <code>defaultSkin</code> is used.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a skin for the selected down state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedDownSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultSkin
	 * @see #defaultSelectedSkin
	 * @see #STATE_DOWN
	 */
	public var selectedDownSkin(get, set):DisplayObject;
	public function get_selectedDownSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(Button.STATE_DOWN, true);
	}

	/**
	 * @private
	 */
	public function set_selectedDownSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(Button.STATE_DOWN, true) == value)
		{
			return this._skinSelector.getValueForState(Button.STATE_DOWN, true);
		}
		this._skinSelector.setValueForState(value, Button.STATE_DOWN, true);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._skinSelector.getValueForState(Button.STATE_DOWN, true);
	}

	/**
	 * The skin used for the button's hover state when the button is
	 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
	 * is used instead. If <code>defaultSelectedSkin</code> is also
	 * <code>null</code>, then <code>defaultSkin</code> is used.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a skin for the selected hover state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedHoverSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultSkin
	 * @see #defaultSelectedSkin
	 * @see #STATE_HOVER
	 */
	public var selectedHoverSkin(get, set):DisplayObject;
	public function get_selectedHoverSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(Button.STATE_HOVER, true);
	}

	/**
	 * @private
	 */
	public function set_selectedHoverSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(Button.STATE_HOVER, true) == value)
		{
			return this._skinSelector.getValueForState(Button.STATE_DOWN, true);
		}
		this._skinSelector.setValueForState(value, Button.STATE_HOVER, true);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._skinSelector.getValueForState(Button.STATE_DOWN, true);
	}

	/**
	 * The skin used for the button's disabled state when the button is
	 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
	 * is used instead. If <code>defaultSelectedSkin</code> is also
	 * <code>null</code>, then <code>defaultSkin</code> is used.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToSkinFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a skin for the selected disabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultSkin
	 * @see #defaultSelectedSkin
	 * @see #STATE_DISABLED
	 */
	public var selectedDisabledSkin(get, set):DisplayObject;
	public function get_selectedDisabledSkin():DisplayObject
	{
		return this._skinSelector.getValueForState(Button.STATE_DISABLED, true);
	}

	/**
	 * @private
	 */
	public function set_selectedDisabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._skinSelector.getValueForState(Button.STATE_DISABLED, true) == value)
		{
			return this._skinSelector.getValueForState(Button.STATE_DISABLED, true);
		}
		this._skinSelector.setValueForState(value, Button.STATE_DISABLED, true);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._skinSelector.getValueForState(Button.STATE_DISABLED, true);
	}

	/**
	 * An object that stores properties for the button's label text renderer
	 * when no specific properties are defined for the button's current
	 * state (and the button's <code>isSelected</code> property is
	 * <code>true</code>), and the properties will be passed down to the
	 * label text renderer when the button validates. The available
	 * properties depend on which <code>ITextRenderer</code> implementation
	 * is returned by <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button default label properties to
	 * use for all selected states when no specific label properties are
	 * available:</p>
	 *
	 * <listing version="3.0">
	 * button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
	 * button.defaultSelectedLabelProperties.wordWrap = true;</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 */
	public var defaultSelectedLabelProperties(get, set):PropertyProxy;
	public function get_defaultSelectedLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.defaultSelectedValue;
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.defaultSelectedValue = value;
		}
		return value;
	}

	/**
	 * @private
	 */
	public function set_defaultSelectedLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!(Std.is(value, PropertyProxy)))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.defaultSelectedValue;
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.defaultSelectedValue = value;
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_defaultSelectedLabelProperties();
	}

	/**
	 * An object that stores properties for the button's label text renderer
	 * when the button is in the <code>Button.STATE_UP</code> state (and
	 * the button's <code>isSelected</code> property is <code>true</code>),
	 * and the properties will be passed down to the label text renderer
	 * when the button validates. The available properties depend on which
	 * <code>ITextRenderer</code> implementation is returned by
	 * <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button label properties for the
	 * selected up state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedUpLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 * @see #defaultSelectedLabelProperties
	 * @see #upLabelProperties
	 * @see #STATE_UP
	 */
	public var selectedUpLabelProperties(get, set):PropertyProxy;
	public function get_selectedUpLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.getValueForState(Button.STATE_UP, true);
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.setValueForState(value, Button.STATE_UP, true);
		}
		return value;
	}

	/**
	 * @private
	 */
	public function set_selectedUpLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!(Std.is(value, PropertyProxy)))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.getValueForState(Button.STATE_UP, true);
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.setValueForState(value, Button.STATE_UP, true);
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_selectedUpLabelProperties();
	}

	/**
	 * An object that stores properties for the button's label text renderer
	 * when the button is in the <code>Button.STATE_DOWN</code> state (and
	 * the button's <code>isSelected</code> property is <code>true</code>),
	 * and the properties will be passed down to the label text renderer
	 * when the button validates. The available properties depend on which
	 * <code>ITextRenderer</code> implementation is returned by
	 * <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button label properties for the
	 * selected down state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedDownLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 * @see #defaultSelectedLabelProperties
	 * @see #downLabelProperties
	 * @see #STATE_DOWN
	 */
	public var selectedDownLabelProperties(get, set):PropertyProxy;
	public function get_selectedDownLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.getValueForState(Button.STATE_DOWN, true);
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.setValueForState(value, Button.STATE_DOWN, true);
		}
		return value;
	}

	/**
	 * @private
	 */
	public function set_selectedDownLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!(Std.is(value, PropertyProxy)))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.getValueForState(Button.STATE_DOWN, true);
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.setValueForState(value, Button.STATE_DOWN, true);
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_selectedDownLabelProperties();
	}

	/**
	 * An object that stores properties for the button's label text renderer
	 * when the button is in the <code>Button.STATE_HOVER</code> state (and
	 * the button's <code>isSelected</code> property is <code>true</code>),
	 * and the properties will be passed down to the label text renderer
	 * when the button validates. The available properties depend on which
	 * <code>ITextRenderer</code> implementation is returned by
	 * <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button label properties for the
	 * selected hover state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedHoverLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 * @see #defaultSelectedLabelProperties
	 * @see #hoverLabelProperties
	 * @see #STATE_HOVER
	 */
	public var selectedHoverLabelProperties(get, set):PropertyProxy;
	public function get_selectedHoverLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.getValueForState(Button.STATE_HOVER, true);
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.setValueForState(value, Button.STATE_HOVER, true);
		}
		return value;
	}

	/**
	 * @private
	 */
	public function set_selectedHoverLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!(Std.is(value, PropertyProxy)))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.getValueForState(Button.STATE_HOVER, true);
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.setValueForState(value, Button.STATE_HOVER, true);
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_selectedHoverLabelProperties();
	}

	/**
	 * An object that stores properties for the button's label text renderer
	 * when the button is in the <code>Button.STATE_DISABLED</code> state
	 * (and the button's <code>isSelected</code> property is
	 * <code>true</code>), and the properties will be passed down to the
	 * label text renderer when the button validates. The available
	 * properties depend on which <code>ITextRenderer</code> implementation
	 * is returned by <code>labelFactory</code>. Refer to
	 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
	 * for a list of available text renderer implementations.
	 *
	 * <p>The following example gives the button label properties for the
	 * selected disabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedDisabledLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #defaultLabelProperties
	 * @see #defaultSelectedLabelProperties
	 * @see #disabledLabelProperties
	 * @see #STATE_DISABLED
	 */
	public var selectedDisabledLabelProperties(get, set):PropertyProxy;
	public function get_selectedDisabledLabelProperties():PropertyProxy
	{
		var value:PropertyProxy = this._labelPropertiesSelector.getValueForState(Button.STATE_DISABLED, true);
		if(value == null)
		{
			value = new PropertyProxy(childProperties_onChange);
			this._labelPropertiesSelector.setValueForState(value, Button.STATE_DISABLED, true);
		}
		return value;
	}

	/**
	 * @private
	 */
	public function set_selectedDisabledLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(!(Std.is(value, PropertyProxy)))
		{
			value = PropertyProxy.fromObject(value);
		}
		var oldValue:PropertyProxy = this._labelPropertiesSelector.getValueForState(Button.STATE_DISABLED, true);
		if(oldValue != null)
		{
			oldValue.removeOnChangeCallback(childProperties_onChange);
		}
		this._labelPropertiesSelector.setValueForState(value, Button.STATE_DISABLED, true);
		if(value != null)
		{
			value.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_selectedDisabledLabelProperties();
	}

	/**
	 * The icon used when no other icon is defined for the current state
	 * when the button is selected. Has a higher priority than
	 * <code>defaultIcon</code>, but a lower priority than other selected
	 * icons.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a default icon to use for
	 * all selected states when no specific icon is available:</p>
	 *
	 * <listing version="3.0">
	 * button.defaultSelectedIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #selectedUpIcon
	 * @see #selectedDownIcon
	 * @see #selectedHoverIcon
	 * @see #selectedDisabledIcon
	 */
	public var defaultSelectedIcon(get, set):DisplayObject;
	public function get_defaultSelectedIcon():DisplayObject
	{
		return this._iconSelector.defaultSelectedValue;
	}

	/**
	 * @private
	 */
	public function set_defaultSelectedIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.defaultSelectedValue == value)
		{
			return this._iconSelector.defaultSelectedValue;
		}
		this._iconSelector.defaultSelectedValue = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._iconSelector.defaultSelectedValue;
	}

	/**
	 * The icon used for the button's up state when the button is
	 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
	 * is used instead. If <code>defaultSelectedIcon</code> is also
	 * <code>null</code>, then <code>defaultIcon</code> is used.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button an icon for the selected up state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedUpIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #defaultSelectedIcon
	 * @see #STATE_UP
	 */
	public var selectedUpIcon(get, set):DisplayObject;
	public function get_selectedUpIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(Button.STATE_UP, true);
	}

	/**
	 * @private
	 */
	public function set_selectedUpIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(Button.STATE_UP, true) == value)
		{
			return this._iconSelector.getValueForState(Button.STATE_UP, true);
		}
		this._iconSelector.setValueForState(value, Button.STATE_UP, true);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._iconSelector.getValueForState(Button.STATE_UP, true);
	}

	/**
	 * The icon used for the button's down state when the button is
	 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
	 * is used instead. If <code>defaultSelectedIcon</code> is also
	 * <code>null</code>, then <code>defaultIcon</code> is used.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button an icon for the selected down state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedDownIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #defaultSelectedIcon
	 * @see #STATE_DOWN
	 */
	public var selectedDownIcon(get, set):DisplayObject;
	public function get_selectedDownIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(Button.STATE_DOWN, true);
	}

	/**
	 * @private
	 */
	public function set_selectedDownIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(Button.STATE_DOWN, true) == value)
		{
			return this._iconSelector.getValueForState(Button.STATE_DOWN, true);
		}
		this._iconSelector.setValueForState(value, Button.STATE_DOWN, true);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._iconSelector.getValueForState(Button.STATE_DOWN, true);
	}

	/**
	 * The icon used for the button's hover state when the button is
	 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
	 * is used instead. If <code>defaultSelectedIcon</code> is also
	 * <code>null</code>, then <code>defaultIcon</code> is used.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button an icon for the selected hover state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedHoverIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #defaultSelectedIcon
	 * @see #STATE_HOVER
	 */
	public var selectedHoverIcon(get, set):DisplayObject;
	public function get_selectedHoverIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(Button.STATE_HOVER, true);
	}

	/**
	 * @private
	 */
	public function set_selectedHoverIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(Button.STATE_HOVER, true) == value)
		{
			return this._iconSelector.getValueForState(Button.STATE_HOVER, true);
		}
		this._iconSelector.setValueForState(value, Button.STATE_HOVER, true);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._iconSelector.getValueForState(Button.STATE_HOVER, true);
	}

	/**
	 * The icon used for the button's disabled state when the button is
	 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
	 * is used instead. If <code>defaultSelectedIcon</code> is also
	 * <code>null</code>, then <code>defaultIcon</code> is used.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button an icon for the selected disabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedDisabledIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #defaultIcon
	 * @see #defaultSelectedIcon
	 * @see #STATE_DISABLED
	 */
	public var selectedDisabledIcon(get, set):DisplayObject;
	public function get_selectedDisabledIcon():DisplayObject
	{
		return this._iconSelector.getValueForState(Button.STATE_DISABLED, true);
	}

	/**
	 * @private
	 */
	public function set_selectedDisabledIcon(value:DisplayObject):DisplayObject
	{
		if(this._iconSelector.getValueForState(Button.STATE_DISABLED, true) == value)
		{
			return this._iconSelector.getValueForState(Button.STATE_DISABLED, true);
		}
		this._iconSelector.setValueForState(value, Button.STATE_DISABLED, true);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._iconSelector.getValueForState(Button.STATE_DISABLED, true);
	}

	/**
	 * @private
	 */
	override private function trigger():Void
	{
		super.trigger();
		if(this._isToggle)
		{
			this.isSelected = !this._isSelected;
		}
	}
}
