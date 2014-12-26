/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.supportClasses.LayoutViewPort;
import feathers.layout.ILayout;
import feathers.layout.IVirtualLayout;
import feathers.skins.IStyleProvider;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;

/**
 * Dispatched when the container is scrolled.
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
 * @eventType starling.events.Event.SCROLL
 *///[Event(name="change",type="starling.events.Event")]

[DefaultProperty("mxmlContent")]
/**
 * A generic container that supports layout, scrolling, and a background
 * skin. For a lighter container, see <code>LayoutGroup</code>, which
 * focuses specifically on layout without scrolling.
 *
 * <p>The following example creates a scroll container with a horizontal
 * layout and adds two buttons to it:</p>
 *
 * <listing version="3.0">
 * var container:ScrollContainer = new ScrollContainer();
 * var layout:HorizontalLayout = new HorizontalLayout();
 * layout.gap = 20;
 * layout.padding = 20;
 * container.layout = layout;
 * this.addChild( container );
 *
 * var yesButton:Button = new Button();
 * yesButton.label = "Yes";
 * container.addChild( yesButton );
 *
 * var noButton:Button = new Button();
 * noButton.label = "No";
 * container.addChild( noButton );</listing>
 *
 * @see http://wiki.starling-framework.org/feathers/scroll-container
 * @see feathers.controls.LayoutGroup
 */
class ScrollContainer extends Scroller implements IScrollContainer
{
	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_MXML_CONTENT:String = "mxmlContent";

	/**
	 * An alternate name to use with <code>ScrollContainer</code> to allow a
	 * theme to give it a toolbar style. If a theme does not provide a skin
	 * for the toolbar style, the theme will automatically fall back to
	 * using the default scroll container skin.
	 *
	 * <p>An alternate name should always be added to a component's
	 * <code>styleNameList</code> before the component is added to the stage for
	 * the first time. If it is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the toolbar style is applied to a scroll
	 * container:</p>
	 *
	 * <listing version="3.0">
	 * var container:ScrollContainer = new ScrollContainer();
	 * container.styleNameList.add( ScrollContainer.ALTERNATE_NAME_TOOLBAR );
	 * this.addChild( container );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_NAME_TOOLBAR:String = "feathers-toolbar-scroll-container";

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
	 * The default <code>IStyleProvider</code> for all <code>ScrollContainer</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * Constructor.
	 */
	public function ScrollContainer()
	{
		super();
		this.layoutViewPort = new LayoutViewPort();
		this.viewPort = this.layoutViewPort;
	}

	/**
	 * A flag that indicates if the display list functions like <code>addChild()</code>
	 * and <code>removeChild()</code> will be passed to the internal view
	 * port.
	 */
	private var displayListBypassEnabled:Bool = true;

	/**
	 * @private
	 */
	private var layoutViewPort:LayoutViewPort;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ScrollContainer.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _layout:ILayout;

	/**
	 * Controls the way that the container's children are positioned and
	 * sized.
	 *
	 * <p>The following example tells the container to use a horizontal layout:</p>
	 *
	 * <listing version="3.0">
	 * var layout:HorizontalLayout = new HorizontalLayout();
	 * layout.gap = 20;
	 * layout.padding = 20;
	 * container.layout = layout;</listing>
	 *
	 * @default null
	 */
	public function get_layout():ILayout
	{
		return this._layout;
	}

	/**
	 * @private
	 */
	public function set_layout(value:ILayout):Void
	{
		if(this._layout == value)
		{
			return;
		}
		this._layout = value;
		this.invalidate(INVALIDATION_FLAG_LAYOUT);
	}

	/**
	 * @private
	 */
	private var _mxmlContentIsReady:Bool = false;

	/**
	 * @private
	 */
	private var _mxmlContent:Array;

	[ArrayElementType("feathers.core.IFeathersControl")]
	/**
	 * @private
	 */
	public function get_mxmlContent():Array
	{
		return this._mxmlContent;
	}

	/**
	 * @private
	 */
	public function set_mxmlContent(value:Array):Void
	{
		if(this._mxmlContent == value)
		{
			return;
		}
		if(this._mxmlContent && this._mxmlContentIsReady)
		{
			var childCount:Int = this._mxmlContent.length;
			for(i in 0 ... childCount)
			{
				var child:DisplayObject = DisplayObject(this._mxmlContent[i]);
				this.removeChild(child, true);
			}
		}
		this._mxmlContent = value;
		this._mxmlContentIsReady = false;
		this.invalidate(INVALIDATION_FLAG_MXML_CONTENT);
	}

	/**
	 * @private
	 */
	override public function get_numChildren():Int
	{
		if(!this.displayListBypassEnabled)
		{
			return super.numChildren;
		}
		return DisplayObjectContainer(this.viewPort).numChildren;
	}

	/**
	 * @inheritDoc
	 */
	public function get_numRawChildren():Int
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var result:Int = super.numChildren;
		this.displayListBypassEnabled = oldBypass;
		return result;
	}

	/**
	 * @private
	 */
	override public function getChildByName(name:String):DisplayObject
	{
		if(!this.displayListBypassEnabled)
		{
			return super.getChildByName(name);
		}
		return DisplayObjectContainer(this.viewPort).getChildByName(name);
	}

	/**
	 * @inheritDoc
	 */
	public function getRawChildByName(name:String):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var child:DisplayObject = super.getChildByName(name);
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @private
	 */
	override public function getChildAt(index:Int):DisplayObject
	{
		if(!this.displayListBypassEnabled)
		{
			return super.getChildAt(index);
		}
		return DisplayObjectContainer(this.viewPort).getChildAt(index);
	}

	/**
	 * @inheritDoc
	 */
	public function getRawChildAt(index:Int):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var child:DisplayObject = super.getChildAt(index);
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @inheritDoc
	 */
	public function addRawChild(child:DisplayObject):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		if(child.parent == this)
		{
			super.setChildIndex(child, super.numChildren);
		}
		else
		{
			child = super.addChildAt(child, super.numChildren);
		}
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @private
	 */
	override public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		if(!this.displayListBypassEnabled)
		{
			return super.addChildAt(child, index);
		}
		return DisplayObjectContainer(this.viewPort).addChildAt(child, index);
	}

	/**
	 * @inheritDoc
	 */
	public function addRawChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		child = super.addChildAt(child, index);
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @inheritDoc
	 */
	public function removeRawChild(child:DisplayObject, dispose:Bool = false):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var index:Int = super.getChildIndex(child);
		if(index >= 0)
		{
			super.removeChildAt(index, dispose);
		}
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @private
	 */
	override public function removeChildAt(index:Int, dispose:Bool = false):DisplayObject
	{
		if(!this.displayListBypassEnabled)
		{
			return super.removeChildAt(index, dispose);
		}
		return DisplayObjectContainer(this.viewPort).removeChildAt(index, dispose);
	}

	/**
	 * @inheritDoc
	 */
	public function removeRawChildAt(index:Int, dispose:Bool = false):DisplayObject
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		var child:DisplayObject =  super.removeChildAt(index, dispose);
		this.displayListBypassEnabled = oldBypass;
		return child;
	}

	/**
	 * @private
	 */
	override public function getChildIndex(child:DisplayObject):Int
	{
		if(!this.displayListBypassEnabled)
		{
			return super.getChildIndex(child);
		}
		return DisplayObjectContainer(this.viewPort).getChildIndex(child);
	}

	/**
	 * @inheritDoc
	 */
	public function getRawChildIndex(child:DisplayObject):Int
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		return super.getChildIndex(child);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * @private
	 */
	override public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		if(!this.displayListBypassEnabled)
		{
			super.setChildIndex(child, index);
			return;
		}
		DisplayObjectContainer(this.viewPort).setChildIndex(child, index);
	}

	/**
	 * @inheritDoc
	 */
	public function setRawChildIndex(child:DisplayObject, index:Int):Void
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		super.setChildIndex(child, index);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * @inheritDoc
	 */
	public function swapRawChildren(child1:DisplayObject, child2:DisplayObject):Void
	{
		var index1:Int = this.getRawChildIndex(child1);
		var index2:Int = this.getRawChildIndex(child2);
		if(index1 < 0 || index2 < 0)
		{
			throw new ArgumentError("Not a child of this container");
		}
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		this.swapRawChildrenAt(index1, index2);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * @private
	 */
	override public function swapChildrenAt(index1:Int, index2:Int):Void
	{
		if(!this.displayListBypassEnabled)
		{
			super.swapChildrenAt(index1, index2);
			return;
		}
		DisplayObjectContainer(this.viewPort).swapChildrenAt(index1, index2);
	}

	/**
	 * @inheritDoc
	 */
	public function swapRawChildrenAt(index1:Int, index2:Int):Void
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		super.swapChildrenAt(index1, index2);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * @private
	 */
	override public function sortChildren(compareFunction:Function):Void
	{
		if(!this.displayListBypassEnabled)
		{
			super.sortChildren(compareFunction);
			return;
		}
		DisplayObjectContainer(this.viewPort).sortChildren(compareFunction);
	}

	/**
	 * @inheritDoc
	 */
	public function sortRawChildren(compareFunction:Function):Void
	{
		var oldBypass:Bool = this.displayListBypassEnabled;
		this.displayListBypassEnabled = false;
		super.sortChildren(compareFunction);
		this.displayListBypassEnabled = oldBypass;
	}

	/**
	 * Readjusts the layout of the container according to its current
	 * content. Call this method when changes to the content cannot be
	 * automatically detected by the container. For instance, Feathers
	 * components dispatch <code>FeathersEventType.RESIZE</code> when their
	 * width and height values change, but standard Starling display objects
	 * like <code>Sprite</code> and <code>Image</code> do not.
	 */
	public function readjustLayout():Void
	{
		this.layoutViewPort.readjustLayout();
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		super.initialize();
		this.refreshMXMLContent();
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);
		var layoutInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
		var mxmlContentInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_MXML_CONTENT);

		if(mxmlContentInvalid)
		{
			this.refreshMXMLContent();
		}

		if(layoutInvalid)
		{
			if(this._layout is IVirtualLayout)
			{
				IVirtualLayout(this._layout).useVirtualLayout = false;
			}
			this.layoutViewPort.layout = this._layout;
		}

		super.draw();
	}

	/**
	 * @private
	 */
	private function refreshMXMLContent():Void
	{
		if(!this._mxmlContent || this._mxmlContentIsReady)
		{
			return;
		}
		var childCount:Int = this._mxmlContent.length;
		for(i in 0 ... childCount)
		{
			var child:DisplayObject = DisplayObject(this._mxmlContent[i]);
			this.addChild(child);
		}
		this._mxmlContentIsReady = true;
	}
}
