/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import haxe.ds.WeakMap;
import openfl.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Watches a container on the display list. As new display objects are
 * added, and if they match a specific type, they will be passed to
 * initializer functions to set properties, call methods, or otherwise
 * modify them. Useful for initializing skins and styles on UI controls.
 *
 * <p>In the example below, the <code>buttonInitializer()</code> function
 * will be called when a <code>Button</code> is added to the display list,
 * and no values are specified in its <code>styleNameList</code> that match
 * other initializers:</p>
 *
 * <listing version="3.0">
 * setInitializerForClass(Button, buttonInitializer);</listing>
 *
 * <p>You can specify a value in the button's <code>styleNameList</code> to
 * call a different initializer for a button. You might do this to apply
 * different skins for some buttons:</p>
 *
 * <listing version="3.0">
 * var button:Button = new Button();
 * button.label = "Click Me";
 * button.styleNameList.add( Button.ALTERNATE_NAME_CALL_TO_ACTION );
 * this.addChild( button );</listing>
 *
 * <p>The <code>callToActionButtonInitializer()</code> function will be called
 * when a <code>Button</code> with the <code>Button.ALTERNATE_NAME_CALL_TO_ACTION</code>
 * value is added to its <code>styleNameList</code>:</p>
 *
 * <listing version="3.0">
 * setInitializerForClass( Button, callToActionButtonInitializer, Button.ALTERNATE_NAME_CALL_TO_ACTION );</listing>
 *
 * <p>Initializers are not called for subclasses. If a <code>Check</code> is
 * added to the display list (<code>Check</code> extends
 * <code>Button</code>), the <code>buttonInitializer()</code> function will
 * not be called. This important restriction allows subclasses to have
 * different skins.</p>
 *
 * <p>You can target a specific subclass with the same initializer function
 * without adding it for all subclasses:</p>
 *
 * <listing version="3.0">
 * setInitializerForClass(Button, buttonInitializer);
 * setInitializerForClass(Check, buttonInitializer);</listing>
 *
 * <p>In this case, <code>Button</code> and <code>Check</code> will trigger
 * the <code>buttonInitializer()</code> function, but <code>Radio</code>
 * (another subclass of <code>Button</code>) will not.</p>
 *
 * <p>You can target a class and all of its subclasses, using a different
 * function. This is recommended only when you are absolutely sure that
 * no subclasses will need a separate initializer.</p>
 *
 * <listing version="3.0">
 * setInitializerForClassAndSubclasses(Button, buttonInitializer);</listing>
 *
 * <p>In this case, <code>Button</code>, <code>Check</code>, <code>Radio</code>
 * and every other subclass of <code>Button</code> (including any subclasses
 * that you create yourself) will trigger the <code>buttonInitializer()</code>
 * function.</p>
 */
class DisplayListWatcher extends EventDispatcher
{
	/**
	 * Constructor.
	 *
	 * @param topLevelContainer		The root display object to watch (not necessarily Starling's stage or root object)
	 */
	public function new(topLevelContainer:DisplayObjectContainer)
	{
		this.root = topLevelContainer;
		this.root.addEventListener(Event.ADDED, addedHandler);
	}
	
	/**
	 * The minimum base class required before the AddedWatcher will check
	 * to see if a particular display object has any initializers.
	 *
	 * <p>In the following example, the required base class is changed:</p>
	 *
	 * <listing version="3.0">
	 * watcher.requiredBaseClass = Sprite;</listing>
	 *
	 * @default feathers.core.IFeathersControl
	 */
	public var requiredBaseClass:Class<Dynamic> = IFeathersControl;

	/**
	 * Determines if only the object added should be processed or if its
	 * children should be processed recursively. Disabling this property
	 * may improve performance slightly, but it limits the capabilities of
	 * <code>DisplayListWatcher</code>.
	 *
	 * <p>In the following example, children are not processed recursively:</p>
	 *
	 * <listing version="3.0">
	 * watcher.processRecursively = false;</listing>
	 *
	 * @default true
	 */
	public var processRecursively:Bool = true;

	/**
	 * @private
	 * Tracks the objects that have been initialized. Uses weak keys so that
	 * the tracked objects can be garbage collected.
	 */
	#if flash
	private var initializedObjects:WeakMap<DisplayObject, Bool> = new WeakMap();
	#else
	private var initializedObjects:Map<DisplayObject, Bool> = new Map();
	#end

	/**
	 * @private
	 */
	private var _initializeOnce:Bool = true;

	/**
	 * Determines if objects added to the display list are initialized only
	 * once or every time that they are re-added. Disabling this property
	 * will allow you to reinitialize a component when it is removed and
	 * added to the display list. However, this may also unnecessarily
	 * reinitialize components that have not changed, which will affect
	 * performance.
	 *
	 * @default true
	 */
	public var initializeOnce(get, set):Bool;
	public function get_initializeOnce():Bool
	{
		return this._initializeOnce;
	}

	/**
	 * @private
	 */
	public function set_initializeOnce(value:Bool):Bool
	{
		if(this._initializeOnce == value)
		{
			return this._initializeOnce;
		}
		this._initializeOnce = value;
		if(value)
		{
			#if flash
			this.initializedObjects = new WeakMap();
			#else
			this.initializedObjects = new Map();
			#end
		}
		else
		{
			this.initializedObjects = null;
		}
		return this._initializeOnce;
	}

	/**
	 * The root of the display list that is watched for added children.
	 */
	private var root:DisplayObjectContainer;

	/**
	 * @private
	 */
	#if flash
	private var _initializerNoNameTypeMap:WeakMap<String, Dynamic->Void> = new WeakMap();
	#else
	private var _initializerNoNameTypeMap:Map<String, Dynamic->Void> = new Map();
	#end

	/**
	 * @private
	 */
	#if flash
	private var _initializerNameTypeMap:WeakMap<String, Map<String, Dynamic->Void>> = new WeakMap();
	#else
	private var _initializerNameTypeMap:Map<String, Map<String, Dynamic->Void>> = new Map();
	#end

	/**
	 * @private
	 */
	#if flash
	private var _initializerSuperTypeMap:WeakMap<String, Dynamic->Void> = new WeakMap();
	#else
	private var _initializerSuperTypeMap:Map<String, Dynamic->Void> = new Map();
	#end

	/**
	 * @private
	 */
	private var _initializerSuperTypes:Array<Class<Dynamic>> = new Array();

	/**
	 * @private
	 */
	private var _excludedObjects:Array<DisplayObject>;

	/**
	 * Stops listening to the root and cleans up anything else that needs to
	 * be disposed. If a <code>DisplayListWatcher</code> is extended for a
	 * theme, it should also dispose textures and other assets.
	 */
	public function dispose():Void
	{
		if(this.root != null)
		{
			this.root.removeEventListener(Event.ADDED, addedHandler);
			this.root = null;
		}
		if(this._excludedObjects != null)
		{
			this._excludedObjects.splice(0, this._excludedObjects.length);
			this._excludedObjects = null;
		}
		for (key in this.initializedObjects.keys())
		{
			this.initializedObjects.remove(key);
		}
		for(key in this._initializerNameTypeMap.keys())
		{
			this._initializerNameTypeMap.remove(key);
		}
		for(key in this._initializerNoNameTypeMap.keys())
		{
			this._initializerNoNameTypeMap.remove(key);
		}
		for(key in this._initializerSuperTypeMap.keys())
		{
			this._initializerSuperTypeMap.remove(key);
		}
		this._initializerSuperTypes.splice(0, this._initializerSuperTypes.length);
	}

	/**
	 * Excludes a display object, and all if its children (if any) from
	 * being watched.
	 */
	public function exclude(target:DisplayObject):Void
	{
		if(this._excludedObjects == null)
		{
			this._excludedObjects = new Array();
		}
		this._excludedObjects.push(target);
	}

	/**
	 * Determines if an object is excluded from being watched.
	 *
	 * <p>In the following example, we check if a display object is excluded:</p>
	 *
	 * <listing version="3.0">
	 * if( watcher.isExcluded( image ) )
	 * {
	 *     // this display object won't be processed by the watcher
	 * }</listing>
	 */
	public function isExcluded(target:DisplayObject):Bool
	{
		if(this._excludedObjects == null)
		{
			return false;
		}

		var objectCount:Int = this._excludedObjects.length;
		for(i in 0 ... objectCount)
		{
			var object:DisplayObject = this._excludedObjects[i];
			if(Std.is(object, DisplayObjectContainer))
			{
				if(cast(object, DisplayObjectContainer).contains(target))
				{
					return true;
				}
			}
			else if(object == target)
			{
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Sets the initializer for a specific class.
	 */
	public function setInitializerForClass(type:Class<Dynamic>, initializer:Dynamic->Void, withName:String = null):Void
	{
		if(withName == null)
		{
			this._initializerNoNameTypeMap[Type.getClassName(type)] = initializer;
			return;
		}
		var nameTable:Map<String, Dynamic->Void> = this._initializerNameTypeMap[Type.getClassName(type)];
		if(nameTable == null)
		{
			this._initializerNameTypeMap[Type.getClassName(type)] = nameTable = new Map();
		}
		nameTable[withName] = initializer;
	}

	/**
	 * Sets an initializer for a specific class and any subclasses. This
	 * option can potentially hurt performance, so use sparingly.
	 */
	public function setInitializerForClassAndSubclasses(type:Class<Dynamic>, initializer:Dynamic->Void):Void
	{
		var index:Int = this._initializerSuperTypes.indexOf(type);
		if(index < 0)
		{
			this._initializerSuperTypes.push(type);
		}
		this._initializerSuperTypeMap[Type.getClassName(type)] = initializer;
	}
	
	/**
	 * If an initializer exists for a specific class, it will be returned.
	 */
	public function getInitializerForClass(type:Class<Dynamic>, withName:String = null):Dynamic->Void
	{
		if(withName == null)
		{
			return this._initializerNoNameTypeMap[Type.getClassName(type)];
		}
		var nameTable:Map<String, Dynamic->Void> = this._initializerNameTypeMap[Type.getClassName(type)];
		if(nameTable == null)
		{
			return null;
		}
		return nameTable[withName];
	}

	/**
	 * If an initializer exists for a specific class and its subclasses, the initializer will be returned.
	 */
	public function getInitializerForClassAndSubclasses(type:Class<Dynamic>):Dynamic->Void
	{
		return this._initializerSuperTypeMap[Type.getClassName(type)];
	}
	
	/**
	 * If an initializer exists for a specific class, it will be removed
	 * completely.
	 */
	public function clearInitializerForClass(type:Class<Dynamic>, withName:String = null):Void
	{
		if(withName == null)
		{
			this._initializerNoNameTypeMap.remove(Type.getClassName(type));
			return;
		}

		var nameTable:Map<String, Dynamic->Void> = this._initializerNameTypeMap[Type.getClassName(type)];
		if(nameTable == null)
		{
			return;
		}
		nameTable.remove(withName);
		return;
	}

	/**
	 * If an initializer exists for a specific class and its subclasses, the
	 * initializer will be removed completely.
	 */
	public function clearInitializerForClassAndSubclasses(type:Class<Dynamic>):Void
	{
		this._initializerSuperTypeMap.remove(Type.getClassName(type));
		var index:Int = this._initializerSuperTypes.indexOf(type);
		if(index >= 0)
		{
			this._initializerSuperTypes.splice(index, 1);
		}
	}

	/**
	 * Immediately initialize an object. Useful for initializing components
	 * that are already on stage when this <code>DisplayListWatcher</code>
	 * is created.
	 *
	 * <p>If the object has already been initialized, it won't be
	 * initialized again. However, it's children may be initialized, if they
	 * haven't been initialized yet.</p>
	 */
	public function initializeObject(target:DisplayObject):Void
	{
		var targetAsRequiredBaseClass:DisplayObject = cast(target, DisplayObject);
		if(targetAsRequiredBaseClass != null)
		{
			var isInitialized:Bool = this._initializeOnce && this.initializedObjects[targetAsRequiredBaseClass];
			if(!isInitialized)
			{
				if(this.isExcluded(target))
				{
					return;
				}

				if(this._initializeOnce)
				{
					this.initializedObjects[targetAsRequiredBaseClass] = true;
				}
				this.processAllInitializers(target);
			}
		}

		if(this.processRecursively)
		{
			var targetAsContainer:DisplayObjectContainer = Std.is(target, DisplayObjectContainer) ? cast(target, DisplayObjectContainer) : null;
			if(targetAsContainer != null)
			{
				var childCount:Int = targetAsContainer.numChildren;
				for(i in 0 ... childCount)
				{
					var child:DisplayObject = targetAsContainer.getChildAt(i);
					this.initializeObject(child);
				}
			}
		}
	}
	
	/**
	 * @private
	 */
	private function processAllInitializers(target:DisplayObject):Void
	{
		var superTypeCount:Int = this._initializerSuperTypes.length;
		var type:Class<Dynamic>;
		for(i in 0 ... superTypeCount)
		{
			type = this._initializerSuperTypes[i];
			if(Std.is(target, type))
			{
				this.applyAllStylesForTypeFromMaps(target, type, this._initializerSuperTypeMap);
			}
		}
		type = Type.getClass(target);
		this.applyAllStylesForTypeFromMaps(target, type, this._initializerNoNameTypeMap, this._initializerNameTypeMap);
	}

	/**
	 * @private
	 */
	private function applyAllStylesForTypeFromMaps(target:DisplayObject, type:Class<Dynamic>, map:Map<String, Dynamic->Void>, nameMap:Map<String, Map<String, Dynamic->Void>> = null):Void
	{
		var initializer:Dynamic->Void;
		var hasNameInitializer:Bool = false;
		if(Std.is(target, IFeathersControl) && nameMap != null)
		{
			var nameTable:Map<String, Dynamic->Void> = nameMap[Type.getClassName(type)];
			if(nameTable != null)
			{
				var uiControl:IFeathersControl = cast(target, IFeathersControl);
				var styleNameList:TokenList = uiControl.styleNameList;
				var nameCount:Int = styleNameList.length;
				for(i in 0 ... nameCount)
				{
					var name:String = styleNameList.item(i);
					initializer = nameTable[name];
					if(initializer != null)
					{
						hasNameInitializer = true;
						initializer(target);
					}
				}
			}
		}
		if(hasNameInitializer)
		{
			return;
		}

		initializer = map[Type.getClassName(type)];
		if(initializer != null)
		{
			initializer(target);
		}
	}
	
	/**
	 * @private
	 */
	private function addedHandler(event:Event):Void
	{
		this.initializeObject(cast(event.target, DisplayObject));
	}
}