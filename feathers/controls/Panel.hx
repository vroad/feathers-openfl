/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.IFocusExtras;
import feathers.core.PropertyProxy;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;

import starling.display.DisplayObject;
import starling.events.Event;

/**
 * A container with layout, optional scrolling, a header, and an optional
 * footer.
 *
 * <p>The following example creates a panel with a horizontal layout and
 * adds two buttons to it:</p>
 *
 * <listing version="3.0">
 * var panel:Panel = new Panel();
 * panel.title = "Is it time to party?";
 * 
 * var layout:HorizontalLayout = new HorizontalLayout();
 * layout.gap = 20;
 * layout.padding = 20;
 * panel.layout = layout;
 * 
 * this.addChild( panel );
 * 
 * var yesButton:Button = new Button();
 * yesButton.label = "Yes";
 * panel.addChild( yesButton );
 * 
 * var noButton:Button = new Button();
 * noButton.label = "No";
 * panel.addChild( noButton );</listing>
 *
 * @see ../../../help/panel.html How to use the Feathers Panel component
 */
class Panel extends ScrollContainer implements IFocusExtras
{
	/**
	 * The default value added to the <code>styleNameList</code> of the header.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_HEADER:String = "feathers-panel-header";

	/**
	 * DEPRECATED: Replaced by <code>Panel.DEFAULT_CHILD_STYLE_NAME_HEADER</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Panel#DEFAULT_CHILD_STYLE_NAME_HEADER
	 */
	inline public static var DEFAULT_CHILD_NAME_HEADER:String = DEFAULT_CHILD_STYLE_NAME_HEADER;

	/**
	 * The default value added to the <code>styleNameList</code> of the footer.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_FOOTER:String = "feathers-panel-footer";

	/**
	 * DEPRECATED: Replaced by <code>Panel.DEFAULT_CHILD_STYLE_NAME_FOOTER</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see Panel#DEFAULT_CHILD_STYLE_NAME_FOOTER
	 */
	inline public static var DEFAULT_CHILD_NAME_FOOTER:String = DEFAULT_CHILD_STYLE_NAME_FOOTER;

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_AUTO:String = "auto";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_ON:String = "on";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_OFF:String = "off";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

	/**
	 * The vertical scroll bar will be positioned on the right.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

	/**
	 * The vertical scroll bar will be positioned on the left.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH:String = "touch";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_MOUSE:String = "mouse";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

	/**
	 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

	/**
	 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
	 *
	 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
	 */
	inline public static var MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_NORMAL:Float = 0.998;

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_FAST:Float = 0.99;

	/**
	 * @copy feathers.controls.ScrollContainer#AUTO_SIZE_MODE_STAGE
	 *
	 * @see feathers.controls.ScrollContainer#autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_STAGE:String = "stage";

	/**
	 * @copy feathers.controls.ScrollContainer#AUTO_SIZE_MODE_CONTENT
	 *
	 * @see feathers.controls.ScrollContainer#autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_CONTENT:String = "content";

	/**
	 * The default <code>IStyleProvider</code> for all <code>Panel</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_HEADER_FACTORY:String = "headerFactory";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_FOOTER_FACTORY:String = "footerFactory";

	/**
	 * @private
	 */
	private static function defaultHeaderFactory():IFeathersControl
	{
		return new Header();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * The header sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #headerFactory
	 * @see #createHeader()
	 */
	private var header:IFeathersControl;

	/**
	 * The footer sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #footerFactory
	 * @see #createFooter()
	 */
	private var footer:IFeathersControl;

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * header. This variable is <code>protected</code> so that sub-classes
	 * can customize the header style name in their constructors instead of
	 * using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_HEADER</code>.
	 *
	 * <p>To customize the header style name without subclassing, see
	 * <code>customHeaderStyleName</code>.</p>
	 *
	 * @see #customHeaderStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	protected var headerStyleName:String = DEFAULT_CHILD_STYLE_NAME_HEADER;

	/**
	 * DEPRECATED: Replaced by <code>headerStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #headerStyleName
	 */
	protected function get headerName():String
	{
		return this.headerStyleName;
	}

	/**
	 * @private
	 */
	protected function set headerName(value:String):void
	{
		this.headerStyleName = value;
	}

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * footer. This variable is <code>protected</code> so that sub-classes
	 * can customize the footer style name in their constructors instead of
	 * using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_FOOTER</code>.
	 *
	 * <p>To customize the footer style name without subclassing, see
	 * <code>customFooterStyleName</code>.</p>
	 *
	 * @see #customFooterStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	protected var footerStyleName:String = DEFAULT_CHILD_STYLE_NAME_FOOTER;

	/**
	 * DEPRECATED: Replaced by <code>footerStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #footerStyleName
	 */
	protected function get footerName():String
	{
		return this.footerStyleName;
	}

	/**
	 * @private
	 */
	protected function set footerName(value:String):void
	{
		this.footerStyleName = value;
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Panel.globalStyleProvider;
	}

	/**
	 * @private
	 */
	protected var _title:String = null;

	/**
	 * The panel's title to display in the header.
	 *
	 * <p>By default, this value is passed to the <code>title</code>
	 * property of the header, if that property exists. However, if the
	 * header is not a <code>feathers.controls.Header</code> instance,
	 * changing the value of <code>titleField</code> will allow the panel to
	 * pass its title to a different property on the header instead.</p>
	 *
	 * <p>In the following example, a custom header factory is provided to
	 * the panel:</p>
	 *
	 * <listing version="3.0">
	 * panel.title = "Settings";</listing>
	 *
	 * @default null
	 *
	 * @see #headerTitleField
	 * @see #headerFactory
	 */
	public function get title():String
	{
		return this._title;
	}

	/**
	 * @private
	 */
	public function set title(value:String):void
	{
		if(this._title == value)
		{
			return;
		}
		this._title = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}


	/**
	 * @private
	 */
	protected var _headerTitleField:String = "title";

	/**
	 * A property of the header that should be used to display the panel's
	 * title.
	 *
	 * <p>By default, this value is passed to the <code>title</code>
	 * property of the header, if that property exists. However, if the
	 * header is not a <code>feathers.controls.Header</code> instance,
	 * changing the value of <code>titleField</code> will allow the panel to
	 * pass the title to a different property name instead.</p>
	 *
	 * <p>In the following example, a <code>Button</code> is used as a
	 * custom header, and the title is passed to its <code>label</code>
	 * property:</p>
	 *
	 * <listing version="3.0">
	 * panel.headerFactory = function():IFeathersControl
	 * {
	 *     return new Button();
	 * };
	 * panel.titleField = "label";</listing>
	 *
	 * @default "title"
	 *
	 * @see #title
	 * @see #headerFactory
	 */
	public function get headerTitleField():String
	{
		return this._headerTitleField;
	}

	/**
	 * @private
	 */
	public function set headerTitleField(value:String):void
	{
		if(this._headerTitleField == value)
		{
			return;
		}
		this._headerTitleField = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	protected var _headerFactory:Function;

	/**
	 * A function used to generate the panel's header sub-component.
	 * The header must be an instance of <code>IFeathersControl</code>, but
	 * the default is an instance of <code>Header</code>. This factory can
	 * be used to change properties on the header when it is first
	 * created. For instance, if you are skinning Feathers components
	 * without a theme, you might use this factory to set skins and other
	 * styles on the header.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():IFeathersControl</pre>
	 *
	 * <p>In the following example, a custom header factory is provided to
	 * the panel:</p>
	 *
	 * <listing version="3.0">
	 * panel.headerFactory = function():IFeathersControl
	 * {
	 *     var header:Header = new Header();
	 *     var closeButton:Button = new Button();
	 *     closeButton.label = "Close";
	 *     closeButton.addEventListener( Event.TRIGGERED, closeButton_triggeredHandler );
	 *     header.rightItems = new &lt;DisplayObject&gt;[ closeButton ];
	 *     return header;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Header
	 * @see #headerProperties
	 */
	public var headerFactory(get, set):Void->IFeathersControl;
	public function get_headerFactory():Void->IFeathersControl
	{
		return this._headerFactory;
	}

	/**
	 * @private
	 */
	public function set_headerFactory(value:Void->IFeathersControl):Void->IFeathersControl
	{
		if(this._headerFactory == value)
		{
			return get_headerFactory();
		}
		this._headerFactory = value;
		this.invalidate(INVALIDATION_FLAG_HEADER_FACTORY);
		//hack because the super class doesn't know anything about the
		//header factory
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_headerFactory();
	}

	/**
	 * @private
	 */
	protected var _customHeaderStyleName:String;

	/**
	 * A style name to add to the panel's header sub-component. Typically
	 * used by a theme to provide different styles to different panels.
	 *
	 * <p>In the following example, a custom header style name is passed to
	 * the panel:</p>
	 *
	 * <listing version="3.0">
	 * panel.customHeaderStyleName = "my-custom-header";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default (this example assumes that the
	 * header is a <code>Header</code>, but it can be any
	 * <code>IFeathersControl</code>):</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Header ).setFunctionForStyleName( "my-custom-header", setCustomHeaderStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_HEADER
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #headerFactory
	 * @see #headerProperties
	 */
	public function get customHeaderStyleName():String
	{
		return this._customHeaderStyleName;
	}

	/**
	 * @private
	 */
	public function set customHeaderStyleName(value:String):void
	{
		if(this._customHeaderStyleName == value)
		{
			return get_customHeaderName();
		}
		this._customHeaderStyleName = value;
		this.invalidate(INVALIDATION_FLAG_HEADER_FACTORY);
		//hack because the super class doesn't know anything about the
		//header factory
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_customHeaderName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customHeaderStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customHeaderStyleName
	 */
	public function get customHeaderName():String
	{
		return this.customHeaderStyleName;
	}

	/**
	 * @private
	 */
	public function set customHeaderName(value:String):void
	{
		this.customHeaderStyleName = value;
	}

	/**
	 * @private
	 */
	private var _headerProperties:PropertyProxy;

	/**
	 * An object that stores properties for the container's header
	 * sub-component, and the properties will be passed down to the header
	 * when the container validates. Any Feathers component may be used as
	 * the container's header, so the available properties depend on which
	 * type of component is returned by <code>headerFactory</code>.
	 *
	 * <p>By default, the <code>headerFactory</code> will return a
	 * <code>Header</code> instance. If you aren't using a different type of
	 * component as the container's header, you can refer to
	 * <a href="Header.html"><code>feathers.controls.Header</code></a>
	 * for a list of available properties. Otherwise, refer to the
	 * appropriate documentation for details about which properties are
	 * available on the component that you're using as the header.</p>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>headerFactory</code> function
	 * instead of using <code>headerProperties</code> will result in better
	 * performance.</p>
	 *
	 * <p>In the following example, the header properties are customized:</p>
	 *
	 * <listing version="3.0">
	 * var closeButton:Button = new Button();
	 * closeButton.label = "Close";
	 * closeButton.addEventListener( Event.TRIGGERED, closeButton_triggeredHandler );
	 * panel.headerProperties.rightItems = new &lt;DisplayObject&gt;[ closeButton ];</listing>
	 *
	 * @default null
	 *
	 * @see #headerFactory
	 * @see feathers.controls.Header
	 */
	public var headerProperties(get, set):PropertyProxy;
	public function get_headerProperties():PropertyProxy
	{
		if(this._headerProperties == null)
		{
			this._headerProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._headerProperties;
	}

	/**
	 * @private
	 */
	public function set_headerProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._headerProperties == value)
		{
			return get_headerProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._headerProperties != null)
		{
			this._headerProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._headerProperties = value;
		if(this._headerProperties != null)
		{
			this._headerProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_headerProperties();
	}

	/**
	 * @private
	 */
	private var _footerFactory:Void->IFeathersControl;

	/**
	 * A function used to generate the panel's footer sub-component.
	 * The footer must be an instance of <code>IFeathersControl</code>, and
	 * by default, there is no footer. This factory can be used to change
	 * properties on the footer when it is first created. For instance, if
	 * you are skinning Feathers components without a theme, you might use
	 * this factory to set skins and other styles on the footer.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():IFeathersControl</pre>
	 *
	 * <p>In the following example, a custom footer factory is provided to
	 * the panel:</p>
	 *
	 * <listing version="3.0">
	 * panel.footerFactory = function():IFeathersControl
	 * {
	 *     return new ScrollContainer();
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl
	 * @see #footerProperties
	 */
	public var footerFactory(get, set):Void->IFeathersControl;
	public function get_footerFactory():Void->IFeathersControl
	{
		return this._footerFactory;
	}

	/**
	 * @private
	 */
	public function set_footerFactory(value:Void->IFeathersControl):Void->IFeathersControl
	{
		if(this._footerFactory == value)
		{
			return get_footerFactory();
		}
		this._footerFactory = value;
		this.invalidate(INVALIDATION_FLAG_FOOTER_FACTORY);
		//hack because the super class doesn't know anything about the
		//header factory
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_footerFactory();
	}

	/**
	 * @private
	 */
	protected var _customFooterStyleName:String;

	/**
	 * A style name to add to the panel's footer sub-component. Typically
	 * used by a theme to provide different styles to different panels.
	 *
	 * <p>In the following example, a custom footer style name is passed to
	 * the panel:</p>
	 *
	 * <listing version="3.0">
	 * panel.customFooterStyleName = "my-custom-footer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default (this example assumes that the
	 * footer is a <code>ScrollContainer</code>, but it can be any
	 * <code>IFeathersControl</code>):</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( ScrollContainer ).setFunctionForStyleName( "my-custom-footer", setCustomFooterStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_FOOTER
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #footerFactory
	 * @see #footerProperties
	 */
	public function get customFooterStyleName():String
	{
		return this._customFooterStyleName;
	}

	/**
	 * @private
	 */
	public function set customFooterStyleName(value:String):void
	{
		if(this._customFooterStyleName == value)
		{
			return get_customFooterName();
		}
		this._customFooterStyleName = value;
		this.invalidate(INVALIDATION_FLAG_FOOTER_FACTORY);
		//hack because the super class doesn't know anything about the
		//header factory
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_customFooterName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customFooterStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customFooterStyleName
	 */
	public function get customFooterName():String
	{
		return this.customFooterStyleName;
	}

	/**
	 * @private
	 */
	public function set customFooterName(value:String):void
	{
		this.customFooterStyleName = value;
	}

	/**
	 * @private
	 */
	private var _footerProperties:PropertyProxy;

	/**
	 * An object that stores properties for the container's footer
	 * sub-component, and the properties will be passed down to the footer
	 * when the container validates. Any Feathers component may be used as
	 * the container's footer, so the available properties depend on which
	 * type of component is returned by <code>footerFactory</code>. Refer to
	 * the appropriate documentation for details about which properties are
	 * available on the component that you're using as the footer.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>footerFactory</code> function
	 * instead of using <code>footerProperties</code> will result in better
	 * performance.</p>
	 *
	 * <p>In the following example, the footer properties are customized:</p>
	 *
	 * <listing version="3.0">
	 * panel.footerProperties.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;</listing>
	 *
	 * @default null
	 *
	 * @see #footerFactory
	 */
	public var footerProperties(get, set):PropertyProxy;
	public function get_footerProperties():PropertyProxy
	{
		if(this._footerProperties == null)
		{
			this._footerProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._footerProperties;
	}

	/**
	 * @private
	 */
	public function set_footerProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._footerProperties == value)
		{
			return get_footerProperties();
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!(Std.is(value, PropertyProxy)))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for (propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._footerProperties != null)
		{
			this._footerProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._footerProperties = value;
		if(this._footerProperties != null)
		{
			this._footerProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_footerProperties();
	}

	/**
	 * @private
	 */
	private var _focusExtrasBefore:Array<DisplayObject> = new Array();

	/**
	 * @inheritDoc
	 */
	public var focusExtrasBefore(get, never):Array<DisplayObject>;
	public function get_focusExtrasBefore():Array<DisplayObject>
	{
		return this._focusExtrasBefore;
	}

	/**
	 * @private
	 */
	private var _focusExtrasAfter:Array<DisplayObject> = new Array();

	/**
	 * @inheritDoc
	 */
	public var focusExtrasAfter(get, never):Array<DisplayObject>;
	public function get_focusExtrasAfter():Array<DisplayObject>
	{
		return this._focusExtrasAfter;
	}

	/**
	 * Quickly sets all outer padding properties to the same value. The
	 * <code>outerPadding</code> getter always returns the value of
	 * <code>outerPaddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the outer padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * panel.outerPadding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #outerPaddingTop
	 * @see #outerPaddingRight
	 * @see #outerPaddingBottom
	 * @see #outerPaddingLeft
	 * @see feathers.controls.Scroller#padding
	 */
	public var outerPadding(get, set):Float;
	public function get_outerPadding():Float
	{
		return this._outerPaddingTop;
	}

	/**
	 * @private
	 */
	public function set_outerPadding(value:Float):Float
	{
		this.outerPaddingTop = value;
		this.outerPaddingRight = value;
		this.outerPaddingBottom = value;
		this.outerPaddingLeft = value;
		return get_outerPadding();
	}

	/**
	 * @private
	 */
	private var _outerPaddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the panel's top edge and the
	 * panel's header.
	 *
	 * <p>Note: The <code>paddingTop</code> property applies to the
	 * middle content only, and it does not affect the header. Use
	 * <code>outerPaddingTop</code> if you want to include padding above
	 * the header. <code>outerPaddingTop</code> and <code>paddingTop</code>
	 * may be used simultaneously to define padding around the outer edges
	 * of the panel and additional padding around its middle content.</p>
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * panel.outerPaddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see feathers.controls.Scroller#paddingTop
	 */
	public var outerPaddingTop(get, set):Float;
	public function get_outerPaddingTop():Float
	{
		return this._outerPaddingTop;
	}

	/**
	 * @private
	 */
	public function set_outerPaddingTop(value:Float):Float
	{
		if(this._outerPaddingTop == value)
		{
			return get_outerPaddingTop();
		}
		this._outerPaddingTop = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_outerPaddingTop();
	}

	/**
	 * @private
	 */
	private var _outerPaddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the panel's right edge and the
	 * panel's header, middle content, and footer.
	 *
	 * <p>Note: The <code>paddingRight</code> property applies to the middle
	 * content only, and it does not affect the header or footer. Use
	 * <code>outerPaddingRight</code> if you want to include padding around
	 * the header and footer too. <code>outerPaddingRight</code> and
	 * <code>paddingRight</code> may be used simultaneously to define
	 * padding around the outer edges of the panel plus additional padding
	 * around its middle content.</p>
	 *
	 * <p>In the following example, the right outer padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * panel.outerPaddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see feathers.controls.Scroller#paddingRight
	 */
	public var outerPaddingRight(get, set):Float;
	public function get_outerPaddingRight():Float
	{
		return this._outerPaddingRight;
	}

	/**
	 * @private
	 */
	public function set_outerPaddingRight(value:Float):Float
	{
		if(this._outerPaddingRight == value)
		{
			return get_outerPaddingRight();
		}
		this._outerPaddingRight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_outerPaddingRight();
	}

	/**
	 * @private
	 */
	private var _outerPaddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the panel's bottom edge and the
	 * panel's footer.
	 *
	 * <p>Note: The <code>paddingBottom</code> property applies to the
	 * middle content only, and it does not affect the footer. Use
	 * <code>outerPaddingBottom</code> if you want to include padding below
	 * the footer. <code>outerPaddingBottom</code> and <code>paddingBottom</code>
	 * may be used simultaneously to define padding around the outer edges
	 * of the panel and additional padding around its middle content.</p>
	 *
	 * <p>In the following example, the bottom outer padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * panel.outerPaddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see feathers.controls.Scroller#paddingBottom
	 */
	public var outerPaddingBottom(get, set):Float;
	public function get_outerPaddingBottom():Float
	{
		return this._outerPaddingBottom;
	}

	/**
	 * @private
	 */
	public function set_outerPaddingBottom(value:Float):Float
	{
		if(this._outerPaddingBottom == value)
		{
			return get_outerPaddingBottom();
		}
		this._outerPaddingBottom = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_outerPaddingBottom();
	}

	/**
	 * @private
	 */
	private var _outerPaddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the panel's left edge and the
	 * panel's header, middle content, and footer.
	 *
	 * <p>Note: The <code>paddingLeft</code> property applies to the middle
	 * content only, and it does not affect the header or footer. Use
	 * <code>outerPaddingLeft</code> if you want to include padding around
	 * the header and footer too. <code>outerPaddingLeft</code> and
	 * <code>paddingLeft</code> may be used simultaneously to define padding
	 * around the outer edges of the panel and additional padding around its
	 * middle content.</p>
	 *
	 * <p>In the following example, the left outer padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.outerPaddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see feathers.controls.Scroller#paddingLeft
	 */
	public var outerPaddingLeft(get, set):Float;
	public function get_outerPaddingLeft():Float
	{
		return this._outerPaddingLeft;
	}

	/**
	 * @private
	 */
	public function set_outerPaddingLeft(value:Float):Float
	{
		if(this._outerPaddingLeft == value)
		{
			return get_outerPaddingLeft();
		}
		this._outerPaddingLeft = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_outerPaddingLeft();
	}

	/**
	 * @private
	 */
	private var _ignoreHeaderResizing:Bool = false;

	/**
	 * @private
	 */
	private var _ignoreFooterResizing:Bool = false;

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var headerFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_HEADER_FACTORY);
		var footerFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_FOOTER_FACTORY);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);

		if(headerFactoryInvalid)
		{
			this.createHeader();
		}

		if(footerFactoryInvalid)
		{
			this.createFooter();
		}

		if(headerFactoryInvalid || stylesInvalid)
		{
			this.refreshHeaderStyles();
		}

		if(footerFactoryInvalid || stylesInvalid)
		{
			this.refreshFooterStyles();
		}

		super.draw();
	}

	/**
	 * @inheritDoc
	 */
	override private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
		{
			return this.setSizeInternal(this.stage.stageWidth, this.stage.stageHeight, false);
		}

		var oldIgnoreHeaderResizing:Bool = this._ignoreHeaderResizing;
		this._ignoreHeaderResizing = true;
		var oldIgnoreFooterResizing:Bool = this._ignoreFooterResizing;
		this._ignoreFooterResizing = true;

		var oldHeaderWidth:Float = this.header.width;
		var oldHeaderHeight:Float = this.header.height;
		this.header.width = this.explicitWidth;
		this.header.maxWidth = this._maxWidth;
		this.header.height = Math.NaN;
		this.header.validate();

		var oldFooterWidth:Float = 0;
		var oldFooterHeight:Float = 0;
		if(this.footer != null)
		{
			oldFooterWidth = this.footer.width;
			oldFooterHeight = this.footer.height;
			this.footer.width = this.explicitWidth;
			this.footer.maxWidth = this._maxWidth;
			this.footer.height = Math.NaN;
			this.footer.validate();
		}

		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			newWidth = Math.max(this.header.width, this._viewPort.width + this._rightViewPortOffset + this._leftViewPortOffset);
			if(this.footer != null)
			{
				newWidth = Math.max(newWidth, this.footer.width);
			}
			if(this.originalBackgroundWidth == this.originalBackgroundWidth) //!isNaN
			{
				newWidth = Math.max(newWidth, this.originalBackgroundWidth);
			}
		}
		if(needsHeight)
		{
			newHeight = this._viewPort.height + this._bottomViewPortOffset + this._topViewPortOffset;
			if(this.originalBackgroundHeight == this.originalBackgroundHeight) //!isNaN
			{
				newHeight = Math.max(newHeight, this.originalBackgroundHeight);
			}
		}

		this.header.width = oldHeaderWidth;
		this.header.height = oldHeaderHeight;
		if(this.footer != null)
		{
			this.footer.width = oldFooterWidth;
			this.footer.height = oldFooterHeight;
		}
		this._ignoreHeaderResizing = oldIgnoreHeaderResizing;
		this._ignoreFooterResizing = oldIgnoreFooterResizing;

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates and adds the <code>header</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #header
	 * @see #headerFactory
	 * @see #customHeaderStyleName
	 */
	private function createHeader():Void
	{
		var displayHeader:DisplayObject;
		if(this.header != null)
		{
			this.header.removeEventListener(FeathersEventType.RESIZE, header_resizeHandler);
			displayHeader = cast(this.header, DisplayObject);
			this._focusExtrasBefore.splice(this._focusExtrasBefore.indexOf(displayHeader), 1);
			this.removeRawChild(displayHeader, true);
			this.header = null;
		}

		var factory:Void->IFeathersControl = this._headerFactory != null ? this._headerFactory : defaultHeaderFactory;
		var headerStyleName:String = this._customHeaderStyleName != null ? this._customHeaderStyleName : this.headerStyleName;
		this.header = factory();
		this.header.styleNameList.add(headerStyleName);
		this.header.addEventListener(FeathersEventType.RESIZE, header_resizeHandler);
		displayHeader = cast(this.header, DisplayObject);
		this.addRawChild(displayHeader);
		this._focusExtrasBefore.push(displayHeader);
	}

	/**
	 * Creates and adds the <code>footer</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #footer
	 * @see #footerFactory
	 * @see #customFooterStyleName
	 */
	private function createFooter():Void
	{
		var displayFooter:DisplayObject;
		if(this.footer != null)
		{
			this.footer.removeEventListener(FeathersEventType.RESIZE, footer_resizeHandler);
			displayFooter = cast(this.footer, DisplayObject);
			this._focusExtrasAfter.splice(this._focusExtrasAfter.indexOf(displayFooter), 1);
			this.removeRawChild(displayFooter, true);
			this.footer = null;
		}

		if(this._footerFactory == null)
		{
			return;
		}
		var footerStyleName:String = this._customFooterStyleName != null ? this._customFooterStyleName : this.footerStyleName;
		this.footer = this._footerFactory();
		this.footer.styleNameList.add(footerStyleName);
		this.footer.addEventListener(FeathersEventType.RESIZE, footer_resizeHandler);
		displayFooter = cast(this.footer, DisplayObject);
		this.addRawChild(displayFooter);
		this._focusExtrasAfter.push(displayFooter);
	}

	/**
	 * @private
	 */
	private function refreshHeaderStyles():Void
	{
		if(Object(this.header).hasOwnProperty(this._headerTitleField))
		{
			this.header[this._headerTitleField] = this._title;
		}
		for(var propertyName:String in this._headerProperties)
		{
			var propertyValue:Dynamic = Reflect.field(this._headerProperties.storage, propertyName);
			Reflect.setProperty(this.header, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function refreshFooterStyles():Void
	{
		if (this._footerProperties == null)
			return;
		for (propertyName in Reflect.fields(this._footerProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._footerProperties.storage, propertyName);
			Reflect.setProperty(this.footer, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	override private function calculateViewPortOffsets(forceScrollBars:Bool = false, useActualBounds:Bool = false):Void
	{
		super.calculateViewPortOffsets(forceScrollBars);

		this._leftViewPortOffset += this._outerPaddingLeft;
		this._rightViewPortOffset += this._outerPaddingRight;

		var oldIgnoreHeaderResizing:Bool = this._ignoreHeaderResizing;
		this._ignoreHeaderResizing = true;
		var oldHeaderWidth:Float = this.header.width;
		var oldHeaderHeight:Float = this.header.height;
		if(useActualBounds)
		{
			this.header.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
		}
		else
		{
			this.header.width = this.explicitWidth - this._outerPaddingLeft - this._outerPaddingRight;
		}
		this.header.maxWidth = this._maxWidth - this._outerPaddingLeft - this._outerPaddingRight;
		this.header.height = Math.NaN;
		this.header.validate();
		this._topViewPortOffset += this.header.height + this._outerPaddingTop;
		this.header.width = oldHeaderWidth;
		this.header.height = oldHeaderHeight;
		this._ignoreHeaderResizing = oldIgnoreHeaderResizing;

		if(this.footer != null)
		{
			var oldIgnoreFooterResizing:Bool = this._ignoreFooterResizing;
			this._ignoreFooterResizing = true;
			var oldFooterWidth:Float = this.footer.width;
			var oldFooterHeight:Float = this.footer.height;
			if(useActualBounds)
			{
				this.footer.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
			}
			else
			{
				this.header.width = this.explicitWidth - this._outerPaddingLeft - this._outerPaddingRight;
			}
			this.footer.maxWidth = this._maxWidth - this._outerPaddingLeft - this._outerPaddingRight;
			this.footer.height = Math.NaN;
			this.footer.validate();
			this._bottomViewPortOffset += this.footer.height + this._outerPaddingBottom;
			this.footer.width = oldFooterWidth;
			this.footer.height = oldFooterHeight;
			this._ignoreFooterResizing = oldIgnoreFooterResizing;
		}
		else
		{
			this._bottomViewPortOffset += this._outerPaddingBottom;
		}
	}

	/**
	 * @private
	 */
	override private function layoutChildren():Void
	{
		super.layoutChildren();

		var oldIgnoreHeaderResizing:Bool = this._ignoreHeaderResizing;
		this._ignoreHeaderResizing = true;
		this.header.x = this._outerPaddingLeft;
		this.header.y = this._outerPaddingTop;
		this.header.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
		this.header.height = Math.NaN;
		this.header.validate();
		this._ignoreHeaderResizing = oldIgnoreHeaderResizing;

		if(this.footer != null)
		{
			var oldIgnoreFooterResizing:Bool = this._ignoreFooterResizing;
			this._ignoreFooterResizing = true;
			this.footer.x = this._outerPaddingLeft;
			this.footer.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
			this.footer.height = Math.NaN;
			this.footer.validate();
			this.footer.y = this.actualHeight - this.footer.height - this._outerPaddingBottom;
			this._ignoreFooterResizing = oldIgnoreFooterResizing;
		}
	}

	/**
	 * @private
	 */
	private function header_resizeHandler(event:Event):Void
	{
		if(this._ignoreHeaderResizing)
		{
			return;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function footer_resizeHandler(event:Event):Void
	{
		if(this._ignoreFooterResizing)
		{
			return;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}
}
