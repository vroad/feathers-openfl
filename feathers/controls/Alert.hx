/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.ITextRenderer;
import feathers.core.IValidating;
import feathers.core.PopUpManager;
import feathers.core.PropertyProxy;
import feathers.data.ListCollection;
import feathers.layout.VerticalLayout;
import feathers.skins.IStyleProvider;

import starling.display.DisplayObject;
import starling.events.Event;

[Exclude(name="layout",kind="property")]
[Exclude(name="footer",kind="property")]
[Exclude(name="footerFactory",kind="property")]
[Exclude(name="footerProperties",kind="property")]
[Exclude(name="customFooterName",kind="property")]
[Exclude(name="createFooter",kind="method")]

/**
 * Dispatched when the alert is closed. The <code>data</code> property of
 * the event object will contain the item from the <code>ButtonGroup</code>
 * data provider for the button that is triggered. If no button is
 * triggered, then the <code>data</code> property will be <code>null</code>.
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
 * @eventType starling.events.Event.CLOSE
 */
//[Event(name="close",type="starling.events.Event")]

/**
 * Displays a message in a modal pop-up with a title and a set of buttons.
 *
 * <p>In general, an <code>Alert</code> isn't instantiated directly.
 * Instead, you will typically call the static function
 * <code>Alert.show()</code>. This is not required, but it result in less
 * code and no need to manually manage calls to the <code>PopUpManager</code>.</p>
 *
 * <p>In the following example, an alert is shown when a <code>Button</code>
 * is triggered:</p>
 *
 * <listing version="3.0">
 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
 *
 * function button_triggeredHandler( event:Event ):Void
 * {
 *     var alert:Alert = Alert.show( "This is an alert!", "Hello World", new ListCollection(
 *     [
 *         { label: "OK" }
 *     ]);
 * }</listing>
 *
 * @see http://wiki.starling-framework.org/feathers/alert
 */
class Alert extends Panel
{
	/**
	 * The default value added to the <code>styleNameList</code> of the header.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_NAME_HEADER:String = "feathers-alert-header";

	/**
	 * The default value added to the <code>styleNameList</code> of the button group.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_NAME_BUTTON_GROUP:String = "feathers-alert-button-group";

	/**
	 * The default value added to the <code>styleNameList</code> of the message.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_NAME_MESSAGE:String = "feathers-alert-message";

	/**
	 * Returns a new <code>Alert</code> instance when <code>Alert.show()</code>
	 * is called. If one wishes to skin the alert manually, a custom factory
	 * may be provided.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Alert</pre>
	 *
	 * <p>The following example shows how to create a custom alert factory:</p>
	 *
	 * <listing version="3.0">
	 * Alert.alertFactory = function():Alert
	 * {
	 *     var alert:Alert = new Alert();
	 *     //set properties here!
	 *     return alert;
	 * };</listing>
	 *
	 * @see #show()
	 */
	public static var alertFactory:Dynamic = defaultAlertFactory;

	/**
	 * Returns an overlay to display with a alert that is modal. Uses the
	 * standard <code>overlayFactory</code> of the <code>PopUpManager</code>
	 * by default, but you can use this property to provide your own custom
	 * overlay, if you prefer.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 * <pre>function():DisplayObject</pre>
	 *
	 * <p>The following example uses a semi-transparent <code>Quad</code> as
	 * a custom overlay:</p>
	 *
	 * <listing version="3.0">
	 * Alert.overlayFactory = function():Quad
	 * {
	 *     var quad:Quad = new Quad(10, 10, 0x000000);
	 *     quad.alpha = 0.75;
	 *     return quad;
	 * };</listing>
	 *
	 * @see feathers.core.PopUpManager#overlayFactory
	 *
	 * @see #show()
	 */
	public static var overlayFactory:Dynamic;

	/**
	 * The default <code>IStyleProvider</code> for all <code>Alert</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * The default factory that creates alerts when <code>Alert.show()</code>
	 * is called. To use a different factory, you need to set
	 * <code>Alert.alertFactory</code> to a <code>Function</code>
	 * instance.
	 *
	 * @see #show()
	 * @see #alertFactory
	 */
	public static function defaultAlertFactory():Alert
	{
		return new Alert();
	}

	/**
	 * Creates an alert, sets common properties, and adds it to the
	 * <code>PopUpManager</code> with the specified modal and centering
	 * options.
	 *
	 * <p>In the following example, an alert is shown when a
	 * <code>Button</code> is triggered:</p>
	 *
	 * <listing version="3.0">
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 *
	 * function button_triggeredHandler( event:Event ):Void
	 * {
	 *     var alert:Alert = Alert.show( "This is an alert!", "Hello World", new ListCollection(
	 *     [
	 *         { label: "OK" }
	 *     ]);
	 * }</listing>
	 */
	public static function show(message:String, title:String = null, buttons:ListCollection = null,
		icon:DisplayObject = null, isModal:Bool = true, isCentered:Bool = true,
		customAlertFactory:Dynamic = null, customOverlayFactory:Dynamic = null):Alert
	{
		var factory:Dynamic = customAlertFactory;
		if(factory == null)
		{
			factory = alertFactory != null ? alertFactory : defaultAlertFactory;
		}
		var alert:Alert = Alert(factory());
		alert.title = title;
		alert.message = message;
		alert.buttonsDataProvider = buttons;
		alert.icon = icon;
		factory = customOverlayFactory;
		if(factory == null)
		{
			factory = overlayFactory;
		}
		PopUpManager.addPopUp(alert, isModal, isCentered, factory);
		return alert;
	}

	/**
	 * @private
	 */
	private static function defaultButtonGroupFactory():ButtonGroup
	{
		return new ButtonGroup();
	}

	/**
	 * Constructor.
	 */
	public function Alert()
	{
		super();
		this.headerName = DEFAULT_CHILD_NAME_HEADER;
		this.footerName = DEFAULT_CHILD_NAME_BUTTON_GROUP;
		this.buttonGroupFactory = defaultButtonGroupFactory;
	}

	/**
	 * The value added to the <code>styleNameList</code> of the alert's
	 * message text renderer. This variable is <code>private</code> so
	 * that sub-classes can customize the message name in their constructors
	 * instead of using the default name defined by
	 * <code>DEFAULT_CHILD_NAME_MESSAGE</code>.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var messageName:String = DEFAULT_CHILD_NAME_MESSAGE;

	/**
	 * The header sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var headerHeader:Header;

	/**
	 * The button group sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var buttonGroupFooter:ButtonGroup;

	/**
	 * The message text renderer sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 */
	private var messageTextRenderer:ITextRenderer;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Alert.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _title:String = null;

	/**
	 * The title text displayed in the alert's header.
	 */
	public var title(get, set):String;
	public function get_title():String
	{
		return this._title;
	}

	/**
	 * @private
	 */
	public function set_title(value:String):String
	{
		if(this._title == value)
		{
			return;
		}
		this._title = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _message:String = null;

	/**
	 * The alert's main text content.
	 */
	public var message(get, set):String;
	public function get_message():String
	{
		return this._message;
	}

	/**
	 * @private
	 */
	public function set_message(value:String):String
	{
		if(this._message == value)
		{
			return;
		}
		this._message = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _icon:DisplayObject;

	/**
	 * The alert's optional icon content to display next to the text.
	 */
	public var icon(get, set):DisplayObject;
	public function get_icon():DisplayObject
	{
		return this._icon;
	}

	/**
	 * @private
	 */
	public function set_icon(value:DisplayObject):DisplayObject
	{
		if(this._icon == value)
		{
			return;
		}
		var oldDisplayListBypassEnabled:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		if(this._icon)
		{
			this.removeChild(this._icon);
		}
		this._icon = value;
		if(this._icon)
		{
			this.addChild(this._icon);
		}
		this.displayListBypassEnabled = oldDisplayListBypassEnabled;
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * The space, in pixels, between the alert's icon and its message text
	 * renderer.
	 *
	 * <p>In the following example, the gap is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * alert.gap = 20;</listing>
	 *
	 * @default 0
	 */
	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return this._gap;
	}

	/**
	 * @private
	 */
	public function set_gap(value:Float):Float
	{
		if(this._gap == value)
		{
			return;
		}
		this._gap = value;
		this.invalidate(INVALIDATION_FLAG_LAYOUT);
	}

	/**
	 * @private
	 */
	private var _buttonsDataProvider:ListCollection;

	/**
	 * The data provider of the alert's <code>ButtonGroup</code>.
	 */
	public var buttonsDataProvider(get, set):ListCollection;
	public function get_buttonsDataProvider():ListCollection
	{
		return this._buttonsDataProvider;
	}

	/**
	 * @private
	 */
	public function set_buttonsDataProvider(value:ListCollection):ListCollection
	{
		if(this._buttonsDataProvider == value)
		{
			return;
		}
		this._buttonsDataProvider = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _messageFactory:Dynamic;

	/**
	 * A function used to instantiate the alert's message text renderer
	 * sub-component. By default, the alert will use the global text
	 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
	 * to create the message text renderer. The message text renderer must
	 * be an instance of <code>ITextRenderer</code>. This factory can be
	 * used to change properties on the message text renderer when it is
	 * first created. For instance, if you are skinning Feathers components
	 * without a theme, you might use this factory to style the message text
	 * renderer.
	 *
	 * <p>If you are not using a theme, the message factory can be used to
	 * provide skin the message text renderer with appropriate text styles.</p>
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * <p>In the following example, a custom message factory is passed to
	 * the alert:</p>
	 *
	 * <listing version="3.0">
	 * alert.messageFactory = function():ITextRenderer
	 * {
	 *     var messageRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
	 *     messageRenderer.textFormat = new TextFormat( "_sans", 12, 0xff0000 );
	 *     return messageRenderer;
	 * }</listing>
	 *
	 * @default null
	 *
	 * @see #message
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 * @see feathers.controls.text.BitmapFontTextRenderer
	 * @see feathers.controls.text.TextFieldTextRenderer
	 */
	public var messageFactory(get, set):Dynamic;
	public function get_messageFactory():Dynamic
	{
		return this._messageFactory;
	}

	/**
	 * @private
	 */
	public function set_messageFactory(value:Dynamic):Dynamic
	{
		if(this._messageFactory == value)
		{
			return;
		}
		this._messageFactory = value;
		this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
	}

	/**
	 * @private
	 */
	private var _messageProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the alert's message
	 * text renderer. The message text renderer is an <code>ITextRenderer</code>
	 * instance. The available properties depend on which
	 * <code>ITextRenderer</code> implementation is returned by
	 * <code>messageFactory</code>. The most common implementations are
	 * <code>BitmapFontTextRenderer</code> and <code>TextFieldTextRenderer</code>.
	 *
	 * <p>In the following example, some properties are set for the alert's
	 * message text renderer (this example assumes that the message text
	 * renderer is a <code>BitmapFontTextRenderer</code>):</p>
	 *
	 * <listing version="3.0">
	 * alert.messageProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
	 * alert.messageProperties.wordWrap = true;</listing>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>messageFactory</code> function instead
	 * of using <code>messageProperties</code> will result in better
	 * performance.</p>
	 *
	 * @default null
	 *
	 * @see #titleFactory
	 * @see feathers.core.ITextRenderer
	 * @see feathers.controls.text.BitmapFontTextRenderer
	 * @see feathers.controls.text.TextFieldTextRenderer
	 */
	public var messageProperties(get, set):Dynamic;
	public function get_messageProperties():Dynamic
	{
		if(!this._messageProperties)
		{
			this._messageProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._messageProperties;
	}

	/**
	 * @private
	 */
	public function set_messageProperties(value:Dynamic):Dynamic
	{
		if(this._messageProperties == value)
		{
			return;
		}
		if(value && !(value is PropertyProxy))
		{
			value = PropertyProxy.fromObject(value);
		}
		if(this._messageProperties)
		{
			this._messageProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._messageProperties = PropertyProxy(value);
		if(this._messageProperties)
		{
			this._messageProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * A function used to generate the alerts's button group sub-component.
	 * The button group must be an instance of <code>ButtonGroup</code>.
	 * This factory can be used to change properties on the button group
	 * when it is first created. For instance, if you are skinning Feathers
	 * components without a theme, you might use this factory to set skins
	 * and other styles on the button group.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():ButtonGroup</pre>
	 *
	 * <p>In the following example, a custom button group factory is
	 * provided to the alert:</p>
	 *
	 * <listing version="3.0">
	 * alert.buttonGroupFactory = function():ButtonGroup
	 * {
	 *     return new ButtonGroup();
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.ButtonGroup
	 * @see #buttonGroupProperties
	 */
	public var buttonGroupFactory(get, set):Dynamic;
	public function get_buttonGroupFactory():Dynamic
	{
		return super.footerFactory;
	}

	/**
	 * @private
	 */
	public function set_buttonGroupFactory(value:Dynamic):Dynamic
	{
		super.footerFactory = value;
	}

	/**
	 * A name to add to the alert's button group sub-component. Typically
	 * used by a theme to provide different skins to different alerts.
	 *
	 * <p>In the following example, a custom button group name is passed to
	 * the alert:</p>
	 *
	 * <listing version="3.0">
	 * alert.customButtonGroupName = "my-custom-button-group";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( ButtonGroup ).setFunctionForStyleName( "my-custom-button-group", setCustomButtonGroupStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_NAME_BUTTON_GROUP
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #buttonGroupFactory
	 * @see #buttonGroupProperties
	 */
	public var customButtonGroupName(get, set):String;
	public function get_customButtonGroupName():String
	{
		return super.customFooterName;
	}

	/**
	 * @private
	 */
	public function set_customButtonGroupName(value:String):String
	{
		super.customFooterName = value;
	}

	/**
	 * A set of key/value pairs to be passed down to the alert's button
	 * group sub-component. The button must be a
	 * <code>feathers.core.ButtonGroup</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>buttonGroupFactory</code> function
	 * instead of using <code>buttonGroupProperties</code> will result in better
	 * performance.</p>
	 *
	 * <p>In the following example, the button group properties are customized:</p>
	 *
	 * <listing version="3.0">
	 * alert.buttonGroupProperties.gap = 20;</listing>
	 *
	 * @default null
	 *
	 * @see #buttonGroupFactory
	 * @see feathers.controls.ButtonGroup
	 */
	public var buttonGroupProperties(get, set):Dynamic;
	public function get_buttonGroupProperties():Dynamic
	{
		return super.footerProperties;
	}

	/**
	 * @private
	 */
	public function set_buttonGroupProperties(value:Dynamic):Dynamic
	{
		super.footerProperties = value;
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(!this.layout)
		{
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			this.layout = layout;
		}
		super.initialize();
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES)
		var textRendererInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

		if(textRendererInvalid)
		{
			this.createMessage();
		}

		if(textRendererInvalid || dataInvalid)
		{
			this.messageTextRenderer.text = this._message;
		}

		if(textRendererInvalid || stylesInvalid)
		{
			this.refreshMessageStyles();
		}

		super.draw();

		if(this._icon)
		{
			if(this._icon is IValidating)
			{
				IValidating(this._icon).validate();
			}
			this._icon.x = this._paddingLeft;
			this._icon.y = this._topViewPortOffset + (this._viewPort.height - this._icon.height) / 2;
		}
	}

	/**
	 * @private
	 */
	override private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}

		if(this._icon is IValidating)
		{
			IValidating(this._icon).validate();
		}

		var oldHeaderWidth:Float = this.header.width;
		var oldHeaderHeight:Float = this.header.height;
		this.header.width = this.explicitWidth;
		this.header.maxWidth = this._maxWidth;
		this.header.height = NaN;
		this.header.validate();

		if(this.footer)
		{
			var oldFooterWidth:Float = this.footer.width;
			var oldFooterHeight:Float = this.footer.height;
			this.footer.width = this.explicitWidth;
			this.footer.maxWidth = this._maxWidth;
			this.footer.height = NaN;
			this.footer.validate();
		}

		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			newWidth = this._viewPort.width + this._rightViewPortOffset + this._leftViewPortOffset;
			if(this._icon)
			{
				var iconWidth:Float = this._icon.width;
				if(iconWidth == iconWidth) //!isNaN
				{
					newWidth += this._icon.width + this._gap;
				}
			}
			newWidth = Math.max(newWidth, this.header.width);
			if(this.footer)
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
			newHeight = this._viewPort.height;
			if(this._icon)
			{
				var iconHeight:Float = this._icon.height;
				if(iconHeight == iconHeight) //!isNaN
				{
					newHeight = Math.max(newHeight, this._icon.height);
				}
			}
			newHeight += this._bottomViewPortOffset + this._topViewPortOffset
			if(this.originalBackgroundHeight == this.originalBackgroundHeight) //!isNaN
			{
				newHeight = Math.max(newHeight, this.originalBackgroundHeight);
			}
		}

		this.header.width = oldHeaderWidth;
		this.header.height = oldHeaderHeight;
		if(this.footer)
		{
			this.footer.width = oldFooterWidth;
			this.footer.height = oldFooterHeight;
		}

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
	 * @see #customHeaderName
	 */
	override private function createHeader():Void
	{
		super.createHeader();
		this.headerHeader = Header(this.header);
	}

	/**
	 * Creates and adds the <code>buttonGroupFooter</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #buttonGroupFooter
	 * @see #buttonGroupFactory
	 * @see #customButtonGroupName
	 */
	private function createButtonGroup():Void
	{
		if(this.buttonGroupFooter)
		{
			this.buttonGroupFooter.removeEventListener(Event.TRIGGERED, buttonsFooter_triggeredHandler);
		}
		super.createFooter();
		this.buttonGroupFooter = ButtonGroup(this.footer);
		this.buttonGroupFooter.addEventListener(Event.TRIGGERED, buttonsFooter_triggeredHandler);
	}

	/**
	 * @private
	 */
	override private function createFooter():Void
	{
		this.createButtonGroup();
	}

	/**
	 * Creates and adds the <code>messageTextRenderer</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #message
	 * @see #messageTextRenderer
	 * @see #messageFactory
	 */
	private function createMessage():Void
	{
		if(this.messageTextRenderer)
		{
			this.removeChild(DisplayObject(this.messageTextRenderer), true);
			this.messageTextRenderer = null;
		}

		var factory:Dynamic = this._messageFactory != null ? this._messageFactory : FeathersControl.defaultTextRendererFactory;
		this.messageTextRenderer = ITextRenderer(factory());
		var uiTextRenderer:IFeathersControl = IFeathersControl(this.messageTextRenderer);
		uiTextRenderer.styleNameList.add(this.messageName);
		uiTextRenderer.touchable = false;
		this.addChild(DisplayObject(this.messageTextRenderer));
	}

	/**
	 * @private
	 */
	override private function refreshHeaderStyles():Void
	{
		super.refreshHeaderStyles();
		this.headerHeader.title = this._title;
	}

	/**
	 * @private
	 */
	override private function refreshFooterStyles():Void
	{
		super.refreshFooterStyles();
		this.buttonGroupFooter.dataProvider = this._buttonsDataProvider;
	}

	/**
	 * @private
	 */
	private function refreshMessageStyles():Void
	{
		for(var propertyName:String in this._messageProperties)
		{
			var propertyValue:Dynamic = this._messageProperties[propertyName];
			this.messageTextRenderer[propertyName] = propertyValue;
		}
	}

	/**
	 * @private
	 */
	override private function calculateViewPortOffsets(forceScrollBars:Bool = false, useActualBounds:Bool = false):Void
	{
		super.calculateViewPortOffsets(forceScrollBars, useActualBounds);
		if(this._icon)
		{
			if(this._icon is IValidating)
			{
				IValidating(this._icon).validate();
			}
			var iconWidth:Float = this._icon.width;
			if(iconWidth == iconWidth) //!isNaN
			{
				this._leftViewPortOffset += this._icon.width + this._gap;
			}
		}
	}

	/**
	 * @private
	 */
	private function buttonsFooter_triggeredHandler(event:Event, data:Dynamic):Void
	{
		this.removeFromParent();
		this.dispatchEventWith(Event.CLOSE, false, data);
		this.dispose();
	}

}
