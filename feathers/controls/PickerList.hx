/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.popups.CalloutPopUpContentManager;
import feathers.controls.popups.IPopUpContentManager;
import feathers.controls.popups.VerticalCenteredPopUpContentManager;
import feathers.core.FeathersControl;
import feathers.core.IFocusDisplayObject;
import feathers.core.IToggle;
import feathers.core.PropertyProxy;
import feathers.data.ListCollection;
import feathers.events.CollectionEventType;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.system.DeviceCapabilities;

import openfl.ui.Keyboard;

import starling.core.Starling;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the pop-up list is opened.
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
 * @eventType starling.events.Event.OPEN
 */
[Event(name="open",type="starling.events.Event")]

/**
 * Dispatched when the pop-up list is closed.
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
[Event(name="close",type="starling.events.Event")]

/**
 * Dispatched when the selected item changes.
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
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Displays a button that may be triggered to display a pop-up list.
 * The list may be customized to display in different ways, such as a
 * drop-down, in a <code>Callout</code>, or as a modal overlay.
 *
 * <p>The following example creates a picker list, gives it a data provider,
 * tells the item renderer how to interpret the data, and listens for when
 * the selection changes:</p>
 *
 * <listing version="3.0">
 * var list:PickerList = new PickerList();
 * 
 * list.dataProvider = new ListCollection(
 * [
 *     { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
 *     { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
 *     { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
 *     { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
 * ]);
 * 
 * list.listProperties.itemRendererFactory = function():IListItemRenderer
 * {
 *     var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
 *     renderer.labelField = "text";
 *     renderer.iconSourceField = "thumbnail";
 *     return renderer;
 * };
 * 
 * list.addEventListener( Event.CHANGE, list_changeHandler );
 * 
 * this.addChild( list );</listing>
 *
 * @see ../../../help/picker-list.html How to use the Feathers PickerList component
 */
class PickerList extends FeathersControl implements IFocusDisplayObject
{
	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";

	/**
	 * The default value added to the <code>styleNameList</code> of the button.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_BUTTON:String = "feathers-picker-list-button";

	/**
	 * DEPRECATED: Replaced by <code>PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see PickerList#DEFAULT_CHILD_STYLE_NAME_BUTTON
	 */
	inline public static var DEFAULT_CHILD_NAME_BUTTON:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

	/**
	 * The default value added to the <code>styleNameList</code> of the pop-up
	 * list.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-picker-list-list";

	/**
	 * DEPRECATED: Replaced by <code>PickerList.DEFAULT_CHILD_STYLE_NAME_LIST</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see PickerList#DEFAULT_CHILD_STYLE_NAME_LIST
	 */
	inline public static var DEFAULT_CHILD_NAME_LIST:String = DEFAULT_CHILD_STYLE_NAME_LIST;

	/**
	 * The default <code>IStyleProvider</code> for all <code>PickerList</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * @private
	 */
	private static function defaultButtonFactory():Button
	{
		return new Button();
	}

	/**
	 * @private
	 */
	private static function defaultListFactory():List
	{
		return new List();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * button. This variable is <code>protected</code> so that sub-classes
	 * can customize the button style name in their constructors instead of
	 * using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_BUTTON</code>.
	 *
	 * <p>To customize the button style name without subclassing, see
	 * <code>customButtonStyleName</code>.</p>
	 *
	 * @see #customButtonStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var buttonStyleName:String = DEFAULT_CHILD_STYLE_NAME_BUTTON;

	/**
	 * DEPRECATED: Replaced by <code>buttonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #buttonStyleName
	 */
	private function get buttonName():String
	{
		return this.buttonStyleName;
	}

	/**
	 * @private
	 */
	private function set buttonName(value:String):void
	{
		this.buttonStyleName = value;
	}

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * pop-up list. This variable is <code>protected</code> so that
	 * sub-classes can customize the list style name in their constructors
	 * instead of using the default style name defined by
	 * <code>DEFAULT_CHILD_STYLE_NAME_LIST</code>.
	 *
	 * <p>To customize the pop-up list name without subclassing, see
	 * <code>customListStyleName</code>.</p>
	 *
	 * @see #customListStyleName
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var listStyleName:String = DEFAULT_CHILD_STYLE_NAME_LIST;

	/**
	 * DEPRECATED: Replaced by <code>listStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #listStyleName
	 */
	private function get listName():String
	{
		return this.listStyleName;
	}

	/**
	 * @private
	 */
	private function set listName(value:String):void
	{
		this.listStyleName = value;
	}

	/**
	 * The button sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #buttonFactory
	 * @see #createButton()
	 */
	private var button:Button;

	/**
	 * The list sub-component.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #listFactory
	 * @see #createList()
	 */
	private var list:List;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return PickerList.globalStyleProvider;
	}
	
	/**
	 * @private
	 */
	private var _dataProvider:ListCollection;
	
	/**
	 * The collection of data displayed by the list.
	 *
	 * <p>The following example passes in a data provider and tells the item
	 * renderer how to interpret the data:</p>
	 *
	 * <listing version="3.0">
	 * list.dataProvider = new ListCollection(
	 * [
	 *     { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
	 *     { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
	 *     { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
	 *     { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
	 * ]);
	 *
	 * list.listProperties.itemRendererFactory = function():IListItemRenderer
	 * {
	 *     var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	 *     renderer.labelField = "text";
	 *     renderer.iconSourceField = "thumbnail";
	 *     return renderer;
	 * };</listing>
	 *
	 * @default null
	 */
	public var dataProvider(get, set):ListCollection;
	public function get_dataProvider():ListCollection
	{
		return this._dataProvider;
	}
	
	/**
	 * @private
	 */
	public function set_dataProvider(value:ListCollection):ListCollection
	{
		if(this._dataProvider == value)
		{
			return get_dataProvider();
		}
		var oldSelectedIndex:int = this.selectedIndex;
		var oldSelectedItem:Object = this.selectedItem;
		if(this._dataProvider)
		{
			this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_multipleEventHandler);
			this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_multipleEventHandler);
			this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_multipleEventHandler);
			this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_multipleEventHandler);
		}
		this._dataProvider = value;
		if(this._dataProvider)
		{
			this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_multipleEventHandler);
			this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_multipleEventHandler);
			this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_multipleEventHandler);
			this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_multipleEventHandler);
		}
		if(!this._dataProvider || this._dataProvider.length == 0)
		{
			this.selectedIndex = -1;
		}
		else
		{
			this.selectedIndex = 0;
		}
		//this ensures that Event.CHANGE will dispatch for selectedItem
		//changing, even if selectedIndex has not changed.
		if(this.selectedIndex == oldSelectedIndex && this.selectedItem != oldSelectedItem)
		{
			this.dispatchEventWith(Event.CHANGE);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_dataProvider();
	}

	/**
	 * @private
	 */
	private var _ignoreSelectionChanges:Bool = false;
	
	/**
	 * @private
	 */
	private var _selectedIndex:Int = -1;
	
	/**
	 * The index of the currently selected item. Returns <code>-1</code> if
	 * no item is selected.
	 *
	 * <p>The following example selects an item by its index:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedIndex = 2;</listing>
	 *
	 * <p>The following example clears the selected index:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedIndex = -1;</listing>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected index:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:PickerList = PickerList( event.currentTarget );
	 *     var index:Int = list.selectedIndex;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @default -1
	 *
	 * @see #selectedItem
	 */
	public var selectedIndex(get, set):Int;
	public function get_selectedIndex():Int
	{
		return this._selectedIndex;
	}
	
	/**
	 * @private
	 */
	public function set_selectedIndex(value:Int):Int
	{
		if(this._selectedIndex == value)
		{
			return get_selectedIndex();
		}
		this._selectedIndex = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		this.dispatchEventWith(Event.CHANGE);
		return get_selectedIndex();
	}
	
	/**
	 * The currently selected item. Returns <code>null</code> if no item is
	 * selected.
	 *
	 * <p>The following example changes the selected item:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedItem = list.dataProvider.getItemAt(0);</listing>
	 *
	 * <p>The following example clears the selected item:</p>
	 *
	 * <listing version="3.0">
	 * list.selectedItem = null;</listing>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected item:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:PickerList = PickerList( event.currentTarget );
	 *     var item:Dynamic = list.selectedItem;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @default null
	 *
	 * @see #selectedIndex
	 */
	public var selectedItem(get, set):Dynamic;
	public function get_selectedItem():Dynamic
	{
		if(this._dataProvider == null || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
		{
			return null;
		}
		return this._dataProvider.getItemAt(this._selectedIndex);
	}
	
	/**
	 * @private
	 */
	public function set_selectedItem(value:Dynamic):Dynamic
	{
		if(this._dataProvider == null)
		{
			this.selectedIndex = -1;
			return get_selectedItem();
		}
		this.selectedIndex = this._dataProvider.getItemIndex(value);
		return get_selectedItem();
	}

	/**
	 * @private
	 */
	private var _prompt:String;

	/**
	 * Text displayed by the button sub-component when no items are
	 * currently selected.
	 *
	 * <p>In the following example, a prompt is given to the picker list
	 * and the selected item is cleared to display the prompt:</p>
	 *
	 * <listing version="3.0">
	 * list.prompt = "Select an Item";
	 * list.selectedIndex = -1;</listing>
	 *
	 * @default null
	 */
	public var prompt(get, set):String;
	public function get_prompt():String
	{
		return this._prompt;
	}

	/**
	 * @private
	 */
	public function set_prompt(value:String):String
	{
		if(this._prompt == value)
		{
			return get_prompt();
		}
		this._prompt = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		return get_prompt();
	}
	
	/**
	 * @private
	 */
	private var _labelField:String = "label";
	
	/**
	 * The field in the selected item that contains the label text to be
	 * displayed by the picker list's button control. If the selected item
	 * does not have this field, and a <code>labelFunction</code> is not
	 * defined, then the picker list will default to calling
	 * <code>toString()</code> on the selected item. To omit the
	 * label completely, define a <code>labelFunction</code> that returns an
	 * empty string.
	 *
	 * <p><strong>Important:</strong> This value only affects the selected
	 * item displayed by the picker list's button control. It will <em>not</em>
	 * affect the label text of the pop-up list's item renderers.</p>
	 *
	 * <p>In the following example, the label field is changed:</p>
	 *
	 * <listing version="3.0">
	 * list.labelField = "text";</listing>
	 *
	 * @default "label"
	 *
	 * @see #labelFunction
	 */
	public var labelField(get, set):String;
	public function get_labelField():String
	{
		return this._labelField;
	}
	
	/**
	 * @private
	 */
	public function set_labelField(value:String):String
	{
		if(this._labelField == value)
		{
			return get_labelField();
		}
		this._labelField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_labelField();
	}
	
	/**
	 * @private
	 */
	private var _labelFunction:Dynamic->String;

	/**
	 * A function used to generate label text for the selected item
	 * displayed by the picker list's button control. If this
	 * function is not null, then the <code>labelField</code> will be
	 * ignored.
	 *
	 * <p><strong>Important:</strong> This value only affects the selected
	 * item displayed by the picker list's button control. It will <em>not</em>
	 * affect the label text of the pop-up list's item renderers.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):String</pre>
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>labelFunction</code></li>
	 *     <li><code>labelField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the label field is changed:</p>
	 *
	 * <listing version="3.0">
	 * list.labelFunction = function( item:Dynamic ):String
	 * {
	 *     return item.firstName + " " + item.lastName;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #labelField
	 */
	public var labelFunction(get, set):Dynamic->String;
	public function get_labelFunction():Dynamic->String
	{
		return this._labelFunction;
	}
	
	/**
	 * @private
	 */
	public function set_labelFunction(value:Dynamic->String):Dynamic->String
	{
		this._labelFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_labelFunction();
	}
	
	/**
	 * @private
	 */
	private var _popUpContentManager:IPopUpContentManager;
	
	/**
	 * A manager that handles the details of how to display the pop-up list.
	 *
	 * <p>In the following example, a pop-up content manager is provided:</p>
	 *
	 * <listing version="3.0">
	 * list.popUpContentManager = new CalloutPopUpContentManager();</listing>
	 *
	 * @default null
	 */
	public var popUpContentManager(get, set):IPopUpContentManager;
	public function get_popUpContentManager():IPopUpContentManager
	{
		return this._popUpContentManager;
	}
	
	/**
	 * @private
	 */
	public function set_popUpContentManager(value:IPopUpContentManager):IPopUpContentManager
	{
		if(this._popUpContentManager == value)
		{
			return get_popUpContentManager();
		}
		var dispatcher:EventDispatcher;
		if(Std.is(this._popUpContentManager, EventDispatcher))
		{
			dispatcher = cast(this._popUpContentManager, EventDispatcher);
			dispatcher.removeEventListener(Event.OPEN, popUpContentManager_openHandler);
			dispatcher.removeEventListener(Event.CLOSE, popUpContentManager_closeHandler);
		}
		this._popUpContentManager = value;
		if(Std.is(this._popUpContentManager, EventDispatcher))
		{
			dispatcher = cast(this._popUpContentManager, EventDispatcher);
			dispatcher.addEventListener(Event.OPEN, popUpContentManager_openHandler);
			dispatcher.addEventListener(Event.CLOSE, popUpContentManager_closeHandler);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_popUpContentManager();
	}

	/**
	 * @private
	 */
	private var _typicalItemWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _typicalItemHeight:Float = Math.NaN;
	
	/**
	 * @private
	 */
	private var _typicalItem:Dynamic = null;
	
	/**
	 * Used to auto-size the list. If the list's width or height is NaN, the
	 * list will try to automatically pick an ideal size. This item is
	 * used in that process to create a sample item renderer.
	 *
	 * <p>The following example provides a typical item:</p>
	 *
	 * <listing version="3.0">
	 * list.typicalItem = { text: "A typical item", thumbnail: texture };
	 * list.itemRendererProperties.labelField = "text";
	 * list.itemRendererProperties.iconSourceField = "thumbnail";</listing>
	 *
	 * @default null
	 */
	public var typicalItem(get, set):Dynamic;
	public function get_typicalItem():Dynamic
	{
		return this._typicalItem;
	}
	
	/**
	 * @private
	 */
	public function set_typicalItem(value:Dynamic):Dynamic
	{
		if(this._typicalItem == value)
		{
			return get_typicalItem();
		}
		this._typicalItem = value;
		this._typicalItemWidth = Math.NaN;
		this._typicalItemHeight = Math.NaN;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_typicalItem();
	}

	/**
	 * @private
	 */
	private var _buttonFactory:Void->Button;

	/**
	 * A function used to generate the picker list's button sub-component.
	 * The button must be an instance of <code>Button</code>. This factory
	 * can be used to change properties on the button when it is first
	 * created. For instance, if you are skinning Feathers components
	 * without a theme, you might use this factory to set skins and other
	 * styles on the button.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():Button</pre>
	 *
	 * <p>In the following example, a custom button factory is passed to the
	 * picker list:</p>
	 *
	 * <listing version="3.0">
	 * list.buttonFactory = function():Button
	 * {
	 *     var button:Button = new Button();
	 *     button.defaultSkin = new Image( upTexture );
	 *     button.downSkin = new Image( downTexture );
	 *     return button;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.Button
	 * @see #buttonProperties
	 */
	public var buttonFactory(get, set):Void->Button;
	public function get_buttonFactory():Void->Button
	{
		return this._buttonFactory;
	}

	/**
	 * @private
	 */
	public function set_buttonFactory(value:Void->Button):Void->Button
	{
		if(this._buttonFactory == value)
		{
			return get_buttonFactory();
		}
		this._buttonFactory = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_buttonFactory();
	}

	/**
	 * @private
	 */
	private var _customButtonStyleName:String;

	/**
	 * A style name to add to the picker list's button sub-component.
	 * Typically used by a theme to provide different styles to different
	 * picker lists.
	 *
	 * <p>In the following example, a custom button style name is passed to
	 * the picker list:</p>
	 *
	 * <listing version="3.0">
	 * list.customButtonStyleName = "my-custom-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-button", setCustomButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #buttonFactory
	 * @see #buttonProperties
	 */
	public function get customButtonStyleName():String
	{
		return this._customButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set customButtonStyleName(value:String):void
	{
		if(this._customButtonStyleName == value)
		{
			return get_customButtonName();
		}
		this._customButtonStyleName = value;
		this.invalidate(INVALIDATION_FLAG_BUTTON_FACTORY);
		return get_customButtonName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customButtonStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customButtonStyleName
	 */
	public function get customButtonName():String
	{
		return this.customButtonStyleName;
	}

	/**
	 * @private
	 */
	public function set customButtonName(value:String):void
	{
		this.customButtonStyleName = value;
	}
	
	/**
	 * @private
	 */
	private var _buttonProperties:PropertyProxy;
	
	/**
	 * An object that stores properties for the picker's button
	 * sub-component, and the properties will be passed down to the button
	 * when the picker validates. For a list of available
	 * properties, refer to
	 * <a href="Button.html"><code>feathers.controls.Button</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>buttonFactory</code> function
	 * instead of using <code>buttonProperties</code> will result in better
	 * performance.</p>
	 *
	 * <p>In the following example, the button properties are passed to the
	 * picker list:</p>
	 *
	 * <listing version="3.0">
	 * list.buttonProperties.defaultSkin = new Image( upTexture );
	 * list.buttonProperties.downSkin = new Image( downTexture );</listing>
	 *
	 * @default null
	 *
	 * @see #buttonFactory
	 * @see feathers.controls.Button
	 */
	public var buttonProperties(get, set):PropertyProxy;
	public function get_buttonProperties():PropertyProxy
	{
		if(this._buttonProperties == null)
		{
			this._buttonProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._buttonProperties;
	}
	
	/**
	 * @private
	 */
	public function set_buttonProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._buttonProperties == value)
		{
			return get_buttonProperties();
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
		if(this._buttonProperties != null)
		{
			this._buttonProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._buttonProperties = value;
		if(this._buttonProperties != null)
		{
			this._buttonProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_buttonProperties();
	}

	/**
	 * @private
	 */
	private var _listFactory:Void->List;

	/**
	 * A function used to generate the picker list's pop-up list
	 * sub-component. The list must be an instance of <code>List</code>.
	 * This factory can be used to change properties on the list when it is
	 * first created. For instance, if you are skinning Feathers components
	 * without a theme, you might use this factory to set skins and other
	 * styles on the list.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function():List</pre>
	 *
	 * <p>In the following example, a custom list factory is passed to the
	 * picker list:</p>
	 *
	 * <listing version="3.0">
	 * list.listFactory = function():List
	 * {
	 *     var popUpList:List = new List();
	 *     popUpList.backgroundSkin = new Image( texture );
	 *     return popUpList;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.List
	 * @see #listProperties
	 */
	public var listFactory(get, set):Void->List;
	public function get_listFactory():Void->List
	{
		return this._listFactory;
	}

	/**
	 * @private
	 */
	public function set_listFactory(value:Void->List):Void->List
	{
		if(this._listFactory == value)
		{
			return get_listFactory();
		}
		this._listFactory = value;
		this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
		return get_listFactory();
	}

	/**
	 * @private
	 */
	private var _customListStyleName:String;

	/**
	 * A style name to add to the picker list's list sub-component.
	 * Typically used by a theme to provide different styles to different
	 * picker lists.
	 *
	 * <p>In the following example, a custom list style name is passed to the
	 * picker list:</p>
	 *
	 * <listing version="3.0">
	 * list.customListStyleName = "my-custom-list";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to provide
	 * different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( List ).setFunctionForStyleName( "my-custom-list", setCustomListStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_LIST
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #listFactory
	 * @see #listProperties
	 */
	public function get customListStyleName():String
	{
		return this._customListStyleName;
	}

	/**
	 * @private
	 */
	public function set customListStyleName(value:String):void
	{
		if(this._customListStyleName == value)
		{
			return get_customListName();
		}
		this._customListStyleName = value;
		this.invalidate(INVALIDATION_FLAG_LIST_FACTORY);
		return get_customListName();
	}

	/**
	 * DEPRECATED: Replaced by <code>customListStyleName</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
	 * starting with Feathers 2.1. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @see #customListStyleName
	 */
	public function get customListName():String
	{
		return this.customListStyleName;
	}

	/**
	 * @private
	 */
	public function set customListName(value:String):void
	{
		this.customListStyleName = value;
	}
	
	/**
	 * @private
	 */
	private var _listProperties:PropertyProxy;
	
	/**
	 * An object that stores properties for the picker's pop-up list
	 * sub-component, and the properties will be passed down to the pop-up
	 * list when the picker validates. For a list of available
	 * properties, refer to
	 * <a href="List.html"><code>feathers.controls.List</code></a>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>listFactory</code> function
	 * instead of using <code>listProperties</code> will result in better
	 * performance.</p>
	 *
	 * <p>In the following example, the list properties are passed to the
	 * picker list:</p>
	 *
	 * <listing version="3.0">
	 * list.listProperties.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #listFactory
	 * @see feathers.controls.List
	 */
	public var listProperties(get, set):PropertyProxy;
	public function get_listProperties():PropertyProxy
	{
		if(this._listProperties == null)
		{
			this._listProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._listProperties;
	}
	
	/**
	 * @private
	 */
	public function set_listProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._listProperties == value)
		{
			return get_listProperties();
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
		if(this._listProperties != null)
		{
			this._listProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._listProperties = value;
		if(this._listProperties != null)
		{
			this._listProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_listProperties();
	}

	/**
	 * @private
	 */
	private var _toggleButtonOnOpenAndClose:Bool = false;

	/**
	 * Determines if the <code>isSelected</code> property of the picker
	 * list's button sub-component is toggled when the list is opened and
	 * closed, if the class used to create the thumb implements the
	 * <code>IToggle</code> interface. Useful for skinning to provide a
	 * different appearance for the button based on whether the list is open
	 * or not.
	 *
	 * <p>In the following example, the button is toggled on open and close:</p>
	 *
	 * <listing version="3.0">
	 * list.toggleButtonOnOpenAndClose = true;</listing>
	 *
	 * @default false
	 *
	 * @see feathers.core.IToggle
	 * @see feathers.controls.ToggleButton
	 */
	public var toggleButtonOnOpenAndClose(get, set):Bool;
	public function get_toggleButtonOnOpenAndClose():Bool
	{
		return this._toggleButtonOnOpenAndClose;
	}

	/**
	 * @private
	 */
	public function set_toggleButtonOnOpenAndClose(value:Bool):Bool
	{
		if(this._toggleButtonOnOpenAndClose == value)
		{
			return get_toggleButtonOnOpenAndClose();
		}
		this._toggleButtonOnOpenAndClose = value;
		if(Std.is(this.button, IToggle))
		{
			if(this._toggleButtonOnOpenAndClose && this._popUpContentManager.isOpen)
			{
				cast(this.button, IToggle).isSelected = true;
			}
			else
			{
				cast(this.button, IToggle).isSelected = false;
			}
		}
		return get_toggleButtonOnOpenAndClose();
	}

	/**
	 * @private
	 */
	private var _isOpenListPending:Bool = false;

	/**
	 * @private
	 */
	private var _isCloseListPending:Bool = false;
	
	/**
	 * Using <code>labelField</code> and <code>labelFunction</code>,
	 * generates a label from the selected item to be displayed by the
	 * picker list's button control.
	 *
	 * <p><strong>Important:</strong> This value only affects the selected
	 * item displayed by the picker list's button control. It will <em>not</em>
	 * affect the label text of the pop-up list's item renderers.</p>
	 */
	public function itemToLabel(item:Dynamic):String
	{
		var labelResult:Dynamic;
		if(this._labelFunction != null)
		{
			labelResult = this._labelFunction(item);
			if(Std.is(labelResult, String))
			{
				return cast(labelResult, String);
			}
			return labelResult.toString();
		}
		else if(this._labelField != null && item && item.hasOwnProperty(this._labelField))
		{
			labelResult = Reflect.getProperty(item, this._labelField);
			if(Std.is(labelResult, String))
			{
				return cast(labelResult, String);
			}
			return labelResult.toString();
		}
		else if(Std.is(item, String))
		{
			return cast(item, String);
		}
		else if(item)
		{
			return item.toString();
		}
		return "";
	}

	/**
	 * @private
	 */
	private var _buttonHasFocus:Bool = false;

	/**
	 * @private
	 */
	private var _buttonTouchPointID:Int = -1;

	/**
	 * @private
	 */
	private var _listIsOpenOnTouchBegan:Bool = false;

	/**
	 * Opens the pop-up list, if it isn't already open.
	 */
	public function openList():Void
	{
		this._isCloseListPending = false;
		if(this._popUpContentManager.isOpen)
		{
			return;
		}
		if(!this._isValidating && this.isInvalid())
		{
			this._isOpenListPending = true;
			return;
		}
		this._isOpenListPending = false;
		this._popUpContentManager.open(this.list, this);
		this.list.scrollToDisplayIndex(this._selectedIndex);
		this.list.validate();
		if(this._focusManager != null)
		{
			this._focusManager.focus = this.list;
			this.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
			this.list.addEventListener(FeathersEventType.FOCUS_OUT, list_focusOutHandler);
		}
	}

	/**
	 * Closes the pop-up list, if it is open.
	 */
	public function closeList():Void
	{
		this._isOpenListPending = false;
		if(!this._popUpContentManager.isOpen)
		{
			return;
		}
		if(!this._isValidating && this.isInvalid())
		{
			this._isCloseListPending = true;
			return;
		}
		this._isCloseListPending = false;
		this.list.validate();
		//don't clean up anything from openList() in closeList(). The list
		//may be closed by removing it from the PopUpManager, which would
		//result in closeList() never being called.
		//instead, clean up in the Event.REMOVED_FROM_STAGE listener.
		this._popUpContentManager.close();
	}
	
	/**
	 * @inheritDoc
	 */
	override public function dispose():Void
	{
		if(this.list != null)
		{
			this.closeList();
			this.list.dispose();
			this.list = null;
		}
		if(this._popUpContentManager != null)
		{
			this._popUpContentManager.dispose();
			this._popUpContentManager = null;
		}
		//clearing selection now so that the data provider setter won't
		//cause a selection change that triggers events.
		this._selectedIndex = -1;
		this.dataProvider = null;
		super.dispose();
	}

	/**
	 * @private
	 */
	override public function showFocus():Void
	{
		if(this.button == null)
		{
			return;
		}
		this.button.showFocus();
	}

	/**
	 * @private
	 */
	override public function hideFocus():Void
	{
		if(this.button == null)
		{
			return;
		}
		this.button.hideFocus();
	}
	
	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(this._popUpContentManager == null)
		{
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.popUpContentManager = new CalloutPopUpContentManager();
			}
			else
			{
				this.popUpContentManager = new VerticalCenteredPopUpContentManager();
			}
		}

	}
	
	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var selectionInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SELECTED);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var buttonFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
		var listFactoryInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_LIST_FACTORY);

		if(buttonFactoryInvalid)
		{
			this.createButton();
		}

		if(listFactoryInvalid)
		{
			this.createList();
		}
		
		if(buttonFactoryInvalid || stylesInvalid || selectionInvalid)
		{
			//this section asks the button to auto-size again, if our
			//explicit dimensions aren't set.
			//set this before buttonProperties is used because it might
			//contain width or height changes.
			if(this.explicitWidth != this.explicitWidth) //isNaN
			{
				this.button.width = Math.NaN;
			}
			if(this.explicitHeight != this.explicitHeight) //isNaN
			{
				this.button.height = Math.NaN;
			}
		}

		if(buttonFactoryInvalid || stylesInvalid)
		{
			this._typicalItemWidth = Math.NaN;
			this._typicalItemHeight = Math.NaN;
			this.refreshButtonProperties();
		}

		if(listFactoryInvalid || stylesInvalid)
		{
			this.refreshListProperties();
		}
		
		var oldIgnoreSelectionChanges:Bool;
		if(listFactoryInvalid || dataInvalid)
		{
			oldIgnoreSelectionChanges = this._ignoreSelectionChanges;
			this._ignoreSelectionChanges = true;
			this.list.dataProvider = this._dataProvider;
			this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
		}
		
		if(buttonFactoryInvalid || listFactoryInvalid || stateInvalid)
		{
			this.button.isEnabled = this._isEnabled;
			this.list.isEnabled = this._isEnabled;
		}

		if(buttonFactoryInvalid || dataInvalid || selectionInvalid)
		{
			this.refreshButtonLabel();
		}
		if(listFactoryInvalid || dataInvalid || selectionInvalid)
		{
			oldIgnoreSelectionChanges = this._ignoreSelectionChanges;
			this._ignoreSelectionChanges = true;
			this.list.selectedIndex = this._selectedIndex;
			this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(buttonFactoryInvalid || stylesInvalid || sizeInvalid || selectionInvalid)
		{
			this.layout();
		}

		//final validation to avoid juggler next frame issues
		//also, to ensure that property changes on the pop-up list are fully
		//committed
		this.list.validate();

		this.handlePendingActions();
	}

	/**
	 * If the component's dimensions have not been set explicitly, it will
	 * measure its content and determine an ideal size for itself. If the
	 * <code>explicitWidth</code> or <code>explicitHeight</code> member
	 * variables are set, those value will be used without additional
	 * measurement. If one is set, but not the other, the dimension with the
	 * explicit value will not be measured, but the other non-explicit
	 * dimension will still need measurement.
	 *
	 * <p>Calls <code>setSizeInternal()</code> to set up the
	 * <code>actualWidth</code> and <code>actualHeight</code> member
	 * variables used for layout.</p>
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}

		var buttonWidth:Float;
		var buttonHeight:Float;
		if(this._typicalItem)
		{
			if(this._typicalItemWidth != this._typicalItemWidth || //isNaN
				this._typicalItemHeight != this._typicalItemHeight) //isNaN
			{
				var oldWidth:Float = this.button.width;
				var oldHeight:Float = this.button.height;
				this.button.width = Math.NaN;
				this.button.height = Math.NaN;
				if(this._typicalItem)
				{
					this.button.label = this.itemToLabel(this._typicalItem);
				}
				this.button.validate();
				this._typicalItemWidth = this.button.width;
				this._typicalItemHeight = this.button.height;
				this.refreshButtonLabel();
				this.button.width = oldWidth;
				this.button.height = oldHeight;
			}
			buttonWidth = this._typicalItemWidth;
			buttonHeight = this._typicalItemHeight;
		}
		else
		{
			this.button.validate();
			buttonWidth = this.button.width;
			buttonHeight = this.button.height;
		}

		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			if(buttonWidth == buttonWidth) //!isNaN
			{
				newWidth = buttonWidth;
			}
			else
			{
				newWidth = 0;
			}
		}
		if(needsHeight)
		{
			if(buttonHeight == buttonHeight) //!isNaN
			{
				newHeight = buttonHeight;
			}
			else
			{
				newHeight = 0;
			}
		}

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates and adds the <code>button</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #button
	 * @see #buttonFactory
	 * @see #customButtonStyleName
	 */
	private function createButton():Void
	{
		if(this.button != null)
		{
			this.button.removeFromParent(true);
			this.button = null;
		}

		var factory:Void->Button = this._buttonFactory != null ? this._buttonFactory : defaultButtonFactory;
		var buttonStyleName:String = this._customButtonStyleName != null ? this._customButtonStyleName : this.buttonStyleName;
		this.button = factory();
		if(Std.is(this.button, ToggleButton))
		{
			//we'll control the value of isSelected manually
			cast(this.button, ToggleButton).isToggle = false;
		}
		this.button.styleNameList.add(buttonStyleName);
		this.button.addEventListener(TouchEvent.TOUCH, button_touchHandler);
		this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
		this.addChild(this.button);
	}

	/**
	 * Creates and adds the <code>list</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #list
	 * @see #listFactory
	 * @see #customListStyleName
	 */
	private function createList():Void
	{
		if(this.list != null)
		{
			this.list.removeFromParent(false);
			//disposing separately because the list may not have a parent
			this.list.dispose();
			this.list = null;
		}

		var factory:Void->List = this._listFactory != null ? this._listFactory : defaultListFactory;
		var listStyleName:String = this._customListStyleName != null ? this._customListStyleName : this.listStyleName;
		this.list = factory();
		this.list.focusOwner = this;
		this.list.styleNameList.add(listStyleName);
		this.list.addEventListener(Event.CHANGE, list_changeHandler);
		this.list.addEventListener(Event.TRIGGERED, list_triggeredHandler);
		this.list.addEventListener(Event.REMOVED_FROM_STAGE, list_removedFromStageHandler);
	}
	
	/**
	 * @private
	 */
	private function refreshButtonLabel():Void
	{
		if(this._selectedIndex >= 0)
		{
			this.button.label = this.itemToLabel(this.selectedItem);
		}
		else
		{
			this.button.label = this._prompt;
		}
	}
	
	/**
	 * @private
	 */
	private function refreshButtonProperties():Void
	{
		if (this._buttonProperties == null)
			return;
		for (propertyName in Reflect.fields(this._buttonProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._buttonProperties.storage, propertyName);
			Reflect.setProperty(this.button, propertyName, propertyValue);
		}
	}
	
	/**
	 * @private
	 */
	private function refreshListProperties():Void
	{
		if (this._listProperties == null)
			return;
		for (propertyName in Reflect.fields(this._listProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._listProperties.storage, propertyName);
			Reflect.setProperty(this.list, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function layout():Void
	{
		this.button.width = this.actualWidth;
		this.button.height = this.actualHeight;

		//final validation to avoid juggler next frame issues
		this.button.validate();
	}

	/**
	 * @private
	 */
	private function handlePendingActions():Void
	{
		if(this._isOpenListPending)
		{
			this.openList();
		}
		if(this._isCloseListPending)
		{
			this.closeList();
		}
	}

	/**
	 * @private
	 */
	override private function focusInHandler(event:Event):Void
	{
		super.focusInHandler(event);
		this._buttonHasFocus = true;
		this.button.dispatchEventWith(FeathersEventType.FOCUS_IN);
	}

	/**
	 * @private
	 */
	override private function focusOutHandler(event:Event):Void
	{
		if(this._buttonHasFocus)
		{
			this.button.dispatchEventWith(FeathersEventType.FOCUS_OUT);
			this._buttonHasFocus = false;
		}
		super.focusOutHandler(event);
	}

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function button_touchHandler(event:TouchEvent):Void
	{
		var touch:Touch;
		if(this._buttonTouchPointID >= 0)
		{
			touch = event.getTouch(this.button, TouchPhase.ENDED, this._buttonTouchPointID);
			if(touch == null)
			{
				return;
			}
			this._buttonTouchPointID = -1;
			//the button will dispatch Event.TRIGGERED before this touch
			//listener is called, so it is safe to clear this flag.
			//we're clearing it because Event.TRIGGERED may also be
			//dispatched after keyboard input.
			this._listIsOpenOnTouchBegan = false;
		}
		else
		{
			touch = event.getTouch(this.button, TouchPhase.BEGAN);
			if(touch == null)
			{
				return;
			}
			this._buttonTouchPointID = touch.id;
			this._listIsOpenOnTouchBegan = this._popUpContentManager.isOpen;
		}
	}
	
	/**
	 * @private
	 */
	private function button_triggeredHandler(event:Event):Void
	{
		if(this._focusManager != null && this._listIsOpenOnTouchBegan)
		{
			return;
		}
		if(this._popUpContentManager.isOpen)
		{
			this.closeList();
			return;
		}
		this.openList();
	}
	
	/**
	 * @private
	 */
	private function list_changeHandler(event:Event):Void
	{
		if(this._ignoreSelectionChanges)
		{
			return;
		}
		this.selectedIndex = this.list.selectedIndex;
	}

	/**
	 * @private
	 */
	private function popUpContentManager_openHandler(event:Event):Void
	{
		if(this._toggleButtonOnOpenAndClose && Std.is(this.button, IToggle))
		{
			cast(this.button, IToggle).isSelected = true;
		}
		this.dispatchEventWith(Event.OPEN);
	}

	/**
	 * @private
	 */
	private function popUpContentManager_closeHandler(event:Event):Void
	{
		if(this._toggleButtonOnOpenAndClose && Std.is(this.button, IToggle))
		{
			cast(this.button, IToggle).isSelected = false;
		}
		this.dispatchEventWith(Event.CLOSE);
	}

	/**
	 * @private
	 */
	private function list_removedFromStageHandler(event:Event):Void
	{
		if(this._focusManager != null)
		{
			this.list.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
			this.list.removeEventListener(FeathersEventType.FOCUS_OUT, list_focusOutHandler);
		}
	}

	/**
	 * @private
	 */
	private function list_focusOutHandler(event:Event):Void
	{
		if(!this._popUpContentManager.isOpen)
		{
			return;
		}
		this.closeList();
	}

	/**
	 * @private
	 */
	private function list_triggeredHandler(event:Event):void
	{
		if(!this._isEnabled)
		{
			return;
		}
		this.closeList();
	}

	/**
	 * @private
	 */
	private function dataProvider_multipleEventHandler():void
	{
		//we need to ensure that the pop-up list has received the new
		//selected index, or it might update the selected index to an
		//incorrect value after an item is added, removed, or replaced.
		this.validate();
	}

	/**
	 * @private
	 */
	private function stage_keyUpHandler(event:KeyboardEvent):void
	{
		if(!this._popUpContentManager.isOpen)
		{
			return;
		}
		if(event.keyCode == Keyboard.ENTER)
		{
			this.closeList();
		}
	}
}