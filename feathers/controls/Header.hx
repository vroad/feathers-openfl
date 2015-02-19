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
import feathers.core.PropertyProxy;
import feathers.events.FeathersEventType;
import feathers.layout.HorizontalLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.ViewPortBounds;
import feathers.skins.IStyleProvider;
import feathers.system.DeviceCapabilities;

import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.events.FullScreenEvent;
import openfl.geom.Point;
import openfl.system.Capabilities;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;

/**
 * A header that displays an optional title along with a horizontal regions
 * on the sides for additional UI controls. The left side is typically for
 * navigation (to display a back button, for example) and the right for
 * additional actions. The title is displayed in the center by default,
 * but it may be aligned to the left or right if there are no items on the
 * desired side.
 *
 * <p>In the following example, a header is created, given a title, and a
 * back button:</p>
 *
 * <listing version="3.0">
 * var backButton:Button = new Button();
 * backButton.label = "Back";
 * backButton.styleNameList.add( Button.ALTERNATE_NAME_BACK_BUTTON );
 * backButton.addEventListener( Event.TRIGGERED, backButton_triggeredHandler );
 *
 * var header:Header = new Header();
 * header.title = "I'm a header";
 * header.leftItems = new &lt;DisplayObject&gt;[ backButton ];
 * this.addChild( header );</listing>
 *
 * @see http://wiki.starling-framework.org/feathers/header
 */
class Header extends FeathersControl
{
	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_LEFT_CONTENT:String = "leftContent";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_RIGHT_CONTENT:String = "rightContent";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_CENTER_CONTENT:String = "centerContent";

	/**
	 * @private
	 */
	inline private static var IOS_RETINA_STATUS_BAR_HEIGHT:Float = 40;

	/**
	 * @private
	 */
	inline private static var IOS_NON_RETINA_STATUS_BAR_HEIGHT:Float = 20;

	/**
	 * @private
	 */
	inline private static var IOS_RETINA_MINIMUM_DPI:Float = 264;

	/**
	 * @private
	 */
	inline private static var IOS_NAME_PREFIX:String = "iPhone OS ";

	/**
	 * @private
	 */
	inline private static var STATUS_BAR_MIN_IOS_VERSION:Int = 7;

	/**
	 * The default <code>IStyleProvider</code> for all <code>Header</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * The title will appear in the center of the header.
	 *
	 * @see #titleAlign
	 */
	inline public static var TITLE_ALIGN_CENTER:String = "center";

	/**
	 * The title will appear on the left of the header, if there is no other
	 * content on that side. If there is content, the title will appear in
	 * the center.
	 *
	 * @see #titleAlign
	 */
	inline public static var TITLE_ALIGN_PREFER_LEFT:String = "preferLeft";

	/**
	 * The title will appear on the right of the header, if there is no
	 * other content on that side. If there is content, the title will
	 * appear in the center.
	 *
	 * @see #titleAlign
	 */
	inline public static var TITLE_ALIGN_PREFER_RIGHT:String = "preferRight";

	/**
	 * The items will be aligned to the top of the bounds.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * The items will be aligned to the middle of the bounds.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * The items will be aligned to the bottom of the bounds.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * The default value added to the <code>styleNameList</code> of the header's
	 * items.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_NAME_ITEM:String = "feathers-header-item";

	/**
	 * The default value added to the <code>styleNameList</code> of the header's
	 * title.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_NAME_TITLE:String = "feathers-header-title";

	/**
	 * @private
	 */
	inline private static var HELPER_BOUNDS:ViewPortBounds = new ViewPortBounds();

	/**
	 * @private
	 */
	inline private static var HELPER_LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * Constructor.
	 */
	public function Header()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, header_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, header_removedFromStageHandler);
	}

	/**
	 * The value added to the <code>styleNameList</code> of the header's title. This
	 * variable is <code>private</code> so that sub-classes can customize
	 * the title name in their constructors instead of using the default
	 * name defined by <code>DEFAULT_CHILD_NAME_TITLE</code>.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var titleName:String = DEFAULT_CHILD_NAME_TITLE;

	/**
	 * The value added to the <code>styleNameList</code> of the header's items. This
	 * variable is <code>private</code> so that sub-classes can customize
	 * the item name in their constructors instead of using the default
	 * name defined by <code>DEFAULT_CHILD_NAME_ITEM</code>.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var itemName:String = DEFAULT_CHILD_NAME_ITEM;

	/**
	 * @private
	 */
	private var leftItemsWidth:Float = 0;

	/**
	 * @private
	 */
	private var rightItemsWidth:Float = 0;

	/**
	 * @private
	 * The layout algorithm. Shared by both sides.
	 */
	private var _layout:HorizontalLayout;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Header.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _title:String = "";

	/**
	 * The text displayed for the header's title.
	 *
	 * <p>In the following example, the header's title is set:</p>
	 *
	 * <listing version="3.0">
	 * header.title = "I'm a Header";</listing>
	 *
	 * @default ""
	 *
	 * @see #titleFactory
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
		if(value == null)
		{
			value = "";
		}
		if(this._title == value)
		{
			return;
		}
		this._title = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _titleFactory:Dynamic;

	/**
	 * A function used to instantiate the header's title text renderer
	 * sub-component. By default, the header will use the global text
	 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
	 * to create the title text renderer. The title text renderer must be an
	 * instance of <code>ITextRenderer</code>. This factory can be used to
	 * change properties on the title text renderer when it is first
	 * created. For instance, if you are skinning Feathers components
	 * without a theme, you might use this factory to style the title text
	 * renderer.
	 *
	 * <p>If you are not using a theme, the title factory can be used to
	 * provide skin the title with appropriate text styles.</p>
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * <p>In the following example, a custom title factory is passed to the
	 * header:</p>
	 *
	 * <listing version="3.0">
	 * header.titleFactory = function():ITextRenderer
	 * {
	 *     var titleRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
	 *     titleRenderer.textFormat = new TextFormat( "_sans", 12, 0xff0000 );
	 *     return titleRenderer;
	 * }</listing>
	 *
	 * @default null
	 *
	 * @see #title
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 * @see feathers.controls.text.BitmapFontTextRenderer
	 * @see feathers.controls.text.TextFieldTextRenderer
	 */
	public var titleFactory(get, set):Dynamic;
	public function get_titleFactory():Dynamic
	{
		return this._titleFactory;
	}

	/**
	 * @private
	 */
	public function set_titleFactory(value:Dynamic):Dynamic
	{
		if(this._titleFactory == value)
		{
			return;
		}
		this._titleFactory = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_TEXT_RENDERER);
	}

	/**
	 * The text renderer for the header's title.
	 *
	 * <p>For internal use in subclasses.</p>
	 *
	 * @see #title
	 * @see #titleFactory
	 * @see #createTitle()
	 */
	private var titleTextRenderer:ITextRenderer;

	/**
	 * @private
	 */
	private var _disposeItems:Bool = true;

	/**
	 * Determines if the <code>leftItems</code>, <code>centerItems</code>,
	 * and <code>rightItems</code> are disposed or not when the header is
	 * disposed.
	 *
	 * <p>If you change this value to <code>false</code>, you must dispose
	 * the items manually. Failing to dispose the items may result in a
	 * memory leak.</p>
	 *
	 * @default true
	 */
	public var disposeItems(get, set):Bool;
	public function get_disposeItems():Bool
	{
		return this._disposeItems;
	}

	/**
	 * @private
	 */
	public function set_disposeItems(value:Bool):Bool
	{
		this._disposeItems = value;
	}

	/**
	 * @private
	 */
	private var _leftItems:Array<DisplayObject>;

	/**
	 * The UI controls that appear in the left region of the header.
	 *
	 * <p>In the following example, a back button is displayed on the left
	 * side of the header:</p>
	 *
	 * <listing version="3.0">
	 * var backButton:Button = new Button();
	 * backButton.label = "Back";
	 * backButton.styleNameList.add( Button.ALTERNATE_NAME_BACK_BUTTON );
	 * backButton.addEventListener( Event.TRIGGERED, backButton_triggeredHandler );
	 * header.leftItems = new &lt;DisplayObject&gt;[ backButton ];</listing>
	 *
	 * @default null
	 */
	public var leftItems(get, set):Array<DisplayObject>;
	public function get_leftItems():Array<DisplayObject>
	{
		return this._leftItems;
	}

	/**
	 * @private
	 */
	public function set_leftItems(value:Array<DisplayObject>):Array<DisplayObject>
	{
		if(this._leftItems == value)
		{
			return;
		}
		if(this._leftItems)
		{
			for each(var item:DisplayObject in this._leftItems)
			{
				if(item is IFeathersControl)
				{
					IFeathersControl(item).styleNameList.remove(this.itemName);
					item.removeEventListener(FeathersEventType.RESIZE, item_resizeHandler);
				}
				item.removeFromParent();
			}
		}
		this._leftItems = value;
		if(this._leftItems)
		{
			for each(item in this._leftItems)
			{
				if(item is IFeathersControl)
				{
					item.addEventListener(FeathersEventType.RESIZE, item_resizeHandler);
				}
			}
		}
		this.invalidate(INVALIDATION_FLAG_LEFT_CONTENT);
	}

	/**
	 * @private
	 */
	private var _centerItems:Array<DisplayObject>;

	/**
	 * The UI controls that appear in the center region of the header. If
	 * <code>centerItems</code> is not <code>null</code>, and the
	 * <code>titleAlign</code> property is <code>Header.TITLE_ALIGN_CENTER</code>,
	 * the title text renderer will be hidden.
	 *
	 * <p>In the following example, a settings button is displayed in the
	 * center of the header:</p>
	 *
	 * <listing version="3.0">
	 * var settingsButton:Button = new Button();
	 * settingsButton.label = "Settings";
	 * settingsButton.addEventListener( Event.TRIGGERED, settingsButton_triggeredHandler );
	 * header.centerItems = new &lt;DisplayObject&gt;[ settingsButton ];</listing>
	 *
	 * @default null
	 */
	public var centerItems(get, set):Array<DisplayObject>;
	public function get_centerItems():Array<DisplayObject>
	{
		return this._centerItems;
	}

	/**
	 * @private
	 */
	public function set_centerItems(value:Array<DisplayObject>):Array<DisplayObject>
	{
		if(this._centerItems == value)
		{
			return;
		}
		if(this._centerItems)
		{
			for each(var item:DisplayObject in this._centerItems)
			{
				if(item is IFeathersControl)
				{
					IFeathersControl(item).styleNameList.remove(this.itemName);
					item.removeEventListener(FeathersEventType.RESIZE, item_resizeHandler);
				}
				item.removeFromParent();
			}
		}
		this._centerItems = value;
		if(this._centerItems)
		{
			for each(item in this._centerItems)
			{
				if(item is IFeathersControl)
				{
					item.addEventListener(FeathersEventType.RESIZE, item_resizeHandler);
				}
			}
		}
		this.invalidate(INVALIDATION_FLAG_CENTER_CONTENT);
	}

	/**
	 * @private
	 */
	private var _rightItems:Array<DisplayObject>;

	/**
	 * The UI controls that appear in the right region of the header.
	 *
	 * <p>In the following example, a settings button is displayed on the
	 * right side of the header:</p>
	 *
	 * <listing version="3.0">
	 * var settingsButton:Button = new Button();
	 * settingsButton.label = "Settings";
	 * settingsButton.addEventListener( Event.TRIGGERED, settingsButton_triggeredHandler );
	 * header.rightItems = new &lt;DisplayObject&gt;[ settingsButton ];</listing>
	 *
	 * @default null
	 */
	public var rightItems(get, set):Array<DisplayObject>;
	public function get_rightItems():Array<DisplayObject>
	{
		return this._rightItems;
	}

	/**
	 * @private
	 */
	public function set_rightItems(value:Array<DisplayObject>):Array<DisplayObject>
	{
		if(this._rightItems == value)
		{
			return;
		}
		if(this._rightItems)
		{
			for each(var item:DisplayObject in this._rightItems)
			{
				if(item is IFeathersControl)
				{
					IFeathersControl(item).styleNameList.remove(this.itemName);
					item.removeEventListener(FeathersEventType.RESIZE, item_resizeHandler);
				}
				item.removeFromParent();
			}
		}
		this._rightItems = value;
		if(this._rightItems)
		{
			for each(item in this._rightItems)
			{
				if(item is IFeathersControl)
				{
					item.addEventListener(FeathersEventType.RESIZE, item_resizeHandler);
				}
			}
		}
		this.invalidate(INVALIDATION_FLAG_RIGHT_CONTENT);
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the header's padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * header.padding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #paddingTop
	 * @see #paddingRight
	 * @see #paddingBottom
	 * @see #paddingLeft
	 */
	public var padding(get, set):Float;
	public function get_padding():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_padding(value:Float):Float
	{
		this.paddingTop = value;
		this.paddingRight = value;
		this.paddingBottom = value;
		this.paddingLeft = value;
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the header's top edge and the
	 * header's content.
	 *
	 * <p>In the following example, the header's top padding is set to 20
	 * pixels:</p>
	 *
	 * <listing version="3.0">
	 * header.paddingTop = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingTop(get, set):Float;
	public function get_paddingTop():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_paddingTop(value:Float):Float
	{
		if(this._paddingTop == value)
		{
			return;
		}
		this._paddingTop = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the header's right edge and the
	 * header's content.
	 *
	 * <p>In the following example, the header's right padding is set to 20
	 * pixels:</p>
	 *
	 * <listing version="3.0">
	 * header.paddingRight = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingRight(get, set):Float;
	public function get_paddingRight():Float
	{
		return this._paddingRight;
	}

	/**
	 * @private
	 */
	public function set_paddingRight(value:Float):Float
	{
		if(this._paddingRight == value)
		{
			return;
		}
		this._paddingRight = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the header's bottom edge and
	 * the header's content.
	 *
	 * <p>In the following example, the header's bottom padding is set to 20
	 * pixels:</p>
	 *
	 * <listing version="3.0">
	 * header.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingBottom(get, set):Float;
	public function get_paddingBottom():Float
	{
		return this._paddingBottom;
	}

	/**
	 * @private
	 */
	public function set_paddingBottom(value:Float):Float
	{
		if(this._paddingBottom == value)
		{
			return;
		}
		this._paddingBottom = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the header's left edge and the
	 * header's content.
	 *
	 * <p>In the following example, the header's left padding is set to 20
	 * pixels:</p>
	 *
	 * <listing version="3.0">
	 * header.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingLeft(get, set):Float;
	public function get_paddingLeft():Float
	{
		return this._paddingLeft;
	}

	/**
	 * @private
	 */
	public function set_paddingLeft(value:Float):Float
	{
		if(this._paddingLeft == value)
		{
			return;
		}
		this._paddingLeft = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * Space, in pixels, between items. The same value is used with the
	 * <code>leftItems</code> and <code>rightItems</code>.
	 *
	 * <p>Set the <code>titleGap</code> to make the gap on the left and
	 * right of the title use a different value.</p>
	 *
	 * <p>In the following example, the header's gap between items is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * header.gap = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #titleGap
	 * @see #leftItems
	 * @see #rightItems
	 */
	public var gap(get, set):Float;
	public function get_gap():Float
	{
		return _gap;
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
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _titleGap:Float = Math.NaN;

	/**
	 * Space, in pixels, between the title and the left or right groups of
	 * items. If <code>Math.NaN</code> (the default), the default <code>gap</code>
	 * property is used instead.
	 *
	 * <p>In the following example, the header's title gap is set to 20
	 * pixels:</p>
	 *
	 * <listing version="3.0">
	 * header.titleGap = 20;</listing>
	 *
	 * @default Math.NaN
	 *
	 * @see #gap
	 */
	public var titleGap(get, set):Float;
	public function get_titleGap():Float
	{
		return _titleGap;
	}

	/**
	 * @private
	 */
	public function set_titleGap(value:Float):Float
	{
		if(this._titleGap == value)
		{
			return;
		}
		this._titleGap = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _useExtraPaddingForOSStatusBar:Bool = false;

	/**
	 * If enabled, the header's top padding will be increased to account for
	 * the height of the OS status bar when the app is rendered under the OS
	 * status bar. The header will not add extra padding to apps that aren't
	 * rendered under the OS status bar.
	 *
	 * <p>iOS started rendering apps that aren't full screen under the OS
	 * status bar in version 7.</p>
	 *
	 * <p>In the following example, the header's padding will account for
	 * the iOS status bar height:</p>
	 *
	 * <listing version="3.0">
	 * header.useExtraPaddingForOSStatusBar = true;</listing>
	 *
	 * @default false;
	 *
	 * @see #paddingTop
	 */
	public var useExtraPaddingForOSStatusBar(get, set):Bool;
	public function get_useExtraPaddingForOSStatusBar():Bool
	{
		return this._useExtraPaddingForOSStatusBar;
	}

	/**
	 * @private
	 */
	public function set_useExtraPaddingForOSStatusBar(value:Bool):Bool
	{
		if(this._useExtraPaddingForOSStatusBar == value)
		{
			return;
		}
		this._useExtraPaddingForOSStatusBar = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;

	[Inspectable(type="String",enumeration="top,middle,bottom")]
	/**
	 * The alignment of the items vertically, on the y-axis.
	 *
	 * <p>In the following example, the header's vertical alignment is set
	 * to the middle:</p>
	 *
	 * <listing version="3.0">
	 * header.verticalAlign = Header.VERTICAL_ALIGN_MIDDLE;</listing>
	 *
	 * @default Header.VERTICAL_ALIGN_MIDDLE
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 */
	public var verticalAlign(get, set):String;
	public function get_verticalAlign():String
	{
		return this._verticalAlign;
	}

	/**
	 * @private
	 */
	public function set_verticalAlign(value:String):String
	{
		if(this._verticalAlign == value)
		{
			return;
		}
		this._verticalAlign = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var originalBackgroundWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var originalBackgroundHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var currentBackgroundSkin:DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * A display object displayed behind the header's content.
	 *
	 * <p>In the following example, the header's background skin is set to
	 * a <code>Quad</code>:</p>
	 *
	 * <listing version="3.0">
	 * header.backgroundSkin = new Quad( 10, 10, 0xff0000 );</listing>
	 *
	 * @default null
	 */
	public var backgroundSkin(get, set):DisplayObject;
	public function get_backgroundSkin():DisplayObject
	{
		return this._backgroundSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundSkin == value)
		{
			return;
		}

		if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
		{
			this.removeChild(this._backgroundSkin);
		}
		this._backgroundSkin = value;
		if(this._backgroundSkin && this._backgroundSkin.parent != this)
		{
			this._backgroundSkin.visible = false;
			this.addChildAt(this._backgroundSkin, 0);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * A background to display when the header is disabled.
	 *
	 * <p>In the following example, the header's disabled background skin is
	 * set to a <code>Quad</code>:</p>
	 *
	 * <listing version="3.0">
	 * header.backgroundDisabledSkin = new Quad( 10, 10, 0x999999 );</listing>
	 *
	 * @default null
	 */
	public var backgroundDisabledSkin(get, set):DisplayObject;
	public function get_backgroundDisabledSkin():DisplayObject
	{
		return this._backgroundDisabledSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundDisabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundDisabledSkin == value)
		{
			return;
		}

		if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
		{
			this.removeChild(this._backgroundDisabledSkin);
		}
		this._backgroundDisabledSkin = value;
		if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
		{
			this._backgroundDisabledSkin.visible = false;
			this.addChildAt(this._backgroundDisabledSkin, 0);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _titleProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the header's title. The
	 * title is an <code>ITextRenderer</code> instance. The available
	 * properties depend on which <code>ITextRenderer</code> implementation
	 * is returned by <code>titleFactory</code>. The most common
	 * implementations are <code>BitmapFontTextRenderer</code> and
	 * <code>TextFieldTextRenderer</code>.
	 *
	 * <p>In the following example, some properties are set for the header's
	 * title text renderer (this example assumes that the title text renderer
	 * is a <code>BitmapFontTextRenderer</code>):</p>
	 *
	 * <listing version="3.0">
	 * header.titleProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
	 * header.titleProperties.wordWrap = true;</listing>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>titleFactory</code> function instead
	 * of using <code>titleProperties</code> will result in better
	 * performance.</p>
	 *
	 * @default null
	 *
	 * @see #titleFactory
	 * @see feathers.core.ITextRenderer
	 * @see feathers.controls.text.BitmapFontTextRenderer
	 * @see feathers.controls.text.TextFieldTextRenderer
	 */
	public var titleProperties(get, set):Dynamic;
	public function get_titleProperties():Dynamic
	{
		if(!this._titleProperties)
		{
			this._titleProperties = new PropertyProxy(titleProperties_onChange);
		}
		return this._titleProperties;
	}

	/**
	 * @private
	 */
	public function set_titleProperties(value:Dynamic):Dynamic
	{
		if(this._titleProperties == value)
		{
			return;
		}
		if(value && !(value is PropertyProxy))
		{
			value = PropertyProxy.fromObject(value);
		}
		if(this._titleProperties)
		{
			this._titleProperties.removeOnChangeCallback(titleProperties_onChange);
		}
		this._titleProperties = PropertyProxy(value);
		if(this._titleProperties)
		{
			this._titleProperties.addOnChangeCallback(titleProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _titleAlign:String = TITLE_ALIGN_CENTER;

	[Inspectable(type="String",enumeration="center,preferLeft,preferRight")]
	/**
	 * The preferred position of the title. If <code>leftItems</code> and/or
	 * <code>rightItems</code> are not <code>null</code>, the title may be
	 * forced to the center even if the preferred position is on the left or
	 * right. If <code>centerItems</code> is not <code>null</code>, and the
	 * title is centered, the title will be hidden.
	 *
	 * <p>In the following example, the header's title aligment is set to
	 * prefer the left side:</p>
	 *
	 * <listing version="3.0">
	 * header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;</listing>
	 *
	 * @default Header.TITLE_ALIGN_CENTER
	 *
	 * @see #TITLE_ALIGN_CENTER
	 * @see #TITLE_ALIGN_PREFER_LEFT
	 * @see #TITLE_ALIGN_PREFER_RIGHT
	 */
	public var titleAlign(get, set):String;
	public function get_titleAlign():String
	{
		return this._titleAlign;
	}

	/**
	 * @private
	 */
	public function set_titleAlign(value:String):String
	{
		if(this._titleAlign == value)
		{
			return;
		}
		this._titleAlign = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this._disposeItems)
		{
			for each(var item:DisplayObject in this._leftItems)
			{
				item.dispose();
			}
			for each(item in this._centerItems)
			{
				item.dispose();
			}
			for each(item in this._rightItems)
			{
				item.dispose();
			}
		}
		this.leftItems = null;
		this.rightItems = null;
		this.centerItems = null;
		super.dispose();
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		if(!this._layout)
		{
			this._layout = new HorizontalLayout();
			this._layout.useVirtualLayout = false;
			this._layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
		}
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);
		var leftContentInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_LEFT_CONTENT);
		var rightContentInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_RIGHT_CONTENT);
		var centerContentInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_CENTER_CONTENT);
		var textRendererInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_TEXT_RENDERER);

		if(textRendererInvalid)
		{
			this.createTitle();
		}

		if(textRendererInvalid || dataInvalid)
		{
			this.titleTextRenderer.text = this._title;
		}

		if(stateInvalid || stylesInvalid)
		{
			this.refreshBackground();
		}

		if(textRendererInvalid || stylesInvalid || sizeInvalid)
		{
			this.refreshLayout();
		}
		if(textRendererInvalid || stylesInvalid)
		{
			this.refreshTitleStyles();
		}

		if(leftContentInvalid)
		{
			if(this._leftItems)
			{
				for each(var item:DisplayObject in this._leftItems)
				{
					if(item is IFeathersControl)
					{
						IFeathersControl(item).styleNameList.add(this.itemName);
					}
					this.addChild(item);
				}
			}
		}

		if(rightContentInvalid)
		{
			if(this._rightItems)
			{
				for each(item in this._rightItems)
				{
					if(item is IFeathersControl)
					{
						IFeathersControl(item).styleNameList.add(this.itemName);
					}
					this.addChild(item);
				}
			}
		}

		if(centerContentInvalid)
		{
			if(this._centerItems)
			{
				for each(item in this._centerItems)
				{
					if(item is IFeathersControl)
					{
						IFeathersControl(item).styleNameList.add(this.itemName);
					}
					this.addChild(item);
				}
			}
		}

		if(stateInvalid || textRendererInvalid)
		{
			this.refreshEnabled();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(sizeInvalid || stylesInvalid)
		{
			this.layoutBackground();
		}

		if(sizeInvalid || leftContentInvalid || rightContentInvalid || centerContentInvalid || stylesInvalid)
		{
			this.leftItemsWidth = 0;
			this.rightItemsWidth = 0;
			if(this._leftItems)
			{
				this.layoutLeftItems();
			}
			if(this._rightItems)
			{
				this.layoutRightItems();
			}
			if(this._centerItems)
			{
				this.layoutCenterItems();
			}
		}

		if(textRendererInvalid || sizeInvalid || stylesInvalid || dataInvalid || leftContentInvalid || rightContentInvalid || centerContentInvalid)
		{
			this.layoutTitle();
		}

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
		var newWidth:Float = needsWidth ? (this._paddingLeft + this._paddingRight) : this.explicitWidth;
		var newHeight:Float = needsHeight ? 0 : this.explicitHeight;

		var totalItemWidth:Float = 0;
		var leftItemCount:Int = this._leftItems ? this._leftItems.length : 0;
		for(var i:Int = 0; i < leftItemCount; i++)
		{
			var item:DisplayObject = this._leftItems[i];
			if(item is IValidating)
			{
				IValidating(item).validate();
			}
			var itemWidth:Float = item.width;
			if(needsWidth &&
				itemWidth == itemWidth) //!isNaN
			{
				totalItemWidth += itemWidth;
				if(i > 0)
				{
					totalItemWidth += this._gap;
				}
			}
			var itemHeight:Float = item.height;
			if(needsHeight &&
				itemHeight == itemHeight && //!isNaN
				itemHeight > newHeight)
			{
				newHeight = itemHeight;
			}
		}
		var centerItemCount:Int = this._centerItems ? this._centerItems.length : 0;
		for(i = 0; i < centerItemCount; i++)
		{
			item = this._centerItems[i];
			if(item is IValidating)
			{
				IValidating(item).validate();
			}
			itemWidth = item.width;
			if(needsWidth &&
				itemWidth == itemWidth) //!isNaN
			{
				totalItemWidth += itemWidth;
				if(i > 0)
				{
					totalItemWidth += this._gap;
				}
			}
			itemHeight = item.height;
			if(needsHeight &&
				itemHeight == itemHeight && //!isNaN
				itemHeight > newHeight)
			{
				newHeight = itemHeight;
			}
		}
		var rightItemCount:Int = this._rightItems ? this._rightItems.length : 0;
		for(i = 0; i < rightItemCount; i++)
		{
			item = this._rightItems[i];
			if(item is IValidating)
			{
				IValidating(item).validate();
			}
			itemWidth = item.width
			if(needsWidth &&
				itemWidth == itemWidth) //!isNaN
			{
				totalItemWidth += itemWidth;
				if(i > 0)
				{
					totalItemWidth += this._gap;
				}
			}
			itemHeight = item.height;
			if(needsHeight &&
				itemHeight == itemHeight && //!isNaN
				itemHeight > newHeight)
			{
				newHeight = itemHeight;
			}
		}
		newWidth += totalItemWidth;

		if(this._title && !(this._titleAlign == TITLE_ALIGN_CENTER && this._centerItems))
		{
			var calculatedTitleGap:Float = this._titleGap;
			if(calculatedTitleGap != calculatedTitleGap) //isNaN
			{
				calculatedTitleGap = this._gap;
			}
			newWidth += 2 * calculatedTitleGap;
			var maxTitleWidth:Float = (needsWidth ? this._maxWidth : this.explicitWidth) - totalItemWidth;
			if(leftItemCount > 0)
			{
				maxTitleWidth -= calculatedTitleGap;
			}
			if(centerItemCount > 0)
			{
				maxTitleWidth -= calculatedTitleGap;
			}
			if(rightItemCount > 0)
			{
				maxTitleWidth -= calculatedTitleGap;
			}
			this.titleTextRenderer.maxWidth = maxTitleWidth;
			this.titleTextRenderer.measureText(HELPER_POINT);
			var measuredTitleWidth:Float = HELPER_POINT.x;
			var measuredTitleHeight:Float = HELPER_POINT.y;
			if(needsWidth &&
				measuredTitleWidth == measuredTitleWidth) //!isNaN
			{
				newWidth += measuredTitleWidth;
				if(leftItemCount > 0)
				{
					newWidth += calculatedTitleGap;
				}
				if(rightItemCount > 0)
				{
					newWidth += calculatedTitleGap;
				}
			}
			if(needsHeight &&
				measuredTitleHeight == measuredTitleHeight && //!isNaN
				measuredTitleHeight > newHeight)
			{
				newHeight = measuredTitleHeight;
			}
		}
		if(needsHeight)
		{
			newHeight += this._paddingTop + this._paddingBottom;
			var extraPaddingTop:Float = this.calculateExtraOSStatusBarPadding();
			if(extraPaddingTop > 0)
			{
				//account for the minimum height before adding the padding
				if(newHeight < this._minHeight)
				{
					newHeight = this._minHeight;
				}
				newHeight += extraPaddingTop;
			}
		}
		if(needsWidth &&
			this.originalBackgroundWidth == this.originalBackgroundWidth && //!isNaN
			this.originalBackgroundWidth > newWidth)
		{
			newWidth = this.originalBackgroundWidth;
		}
		if(needsHeight &&
			this.originalBackgroundHeight == this.originalBackgroundHeight && //!isNaN
			this.originalBackgroundHeight > newHeight)
		{
			newHeight = this.originalBackgroundHeight;
		}

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates and adds the <code>titleTextRenderer</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #title
	 * @see #titleTextRenderer
	 * @see #titleFactory
	 */
	private function createTitle():Void
	{
		if(this.titleTextRenderer)
		{
			this.removeChild(DisplayObject(this.titleTextRenderer), true);
			this.titleTextRenderer = null;
		}

		var factory:Dynamic = this._titleFactory != null ? this._titleFactory : FeathersControl.defaultTextRendererFactory;
		this.titleTextRenderer = ITextRenderer(factory());
		var uiTitleRenderer:IFeathersControl = IFeathersControl(this.titleTextRenderer);
		uiTitleRenderer.styleNameList.add(this.titleName);
		this.addChild(DisplayObject(uiTitleRenderer));
	}

	/**
	 * @private
	 */
	private function refreshBackground():Void
	{
		this.currentBackgroundSkin = this._backgroundSkin;
		if(!this._isEnabled && this._backgroundDisabledSkin)
		{
			if(this._backgroundSkin)
			{
				this._backgroundSkin.visible = false;
			}
			this.currentBackgroundSkin = this._backgroundDisabledSkin;
		}
		else if(this._backgroundDisabledSkin)
		{
			this._backgroundDisabledSkin.visible = false;
		}
		if(this.currentBackgroundSkin)
		{
			this.currentBackgroundSkin.visible = true;

			if(this.originalBackgroundWidth != this.originalBackgroundWidth) //isNaN
			{
				this.originalBackgroundWidth = this.currentBackgroundSkin.width;
			}
			if(this.originalBackgroundHeight != this.originalBackgroundHeight) //isNaN
			{
				this.originalBackgroundHeight = this.currentBackgroundSkin.height;
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshLayout():Void
	{
		this._layout.gap = this._gap;
		this._layout.paddingTop = this._paddingTop + this.calculateExtraOSStatusBarPadding();
		this._layout.paddingBottom = this._paddingBottom;
		this._layout.verticalAlign = this._verticalAlign;
	}

	/**
	 * @private
	 */
	private function refreshEnabled():Void
	{
		this.titleTextRenderer.isEnabled = this._isEnabled;
	}

	/**
	 * @private
	 */
	private function refreshTitleStyles():Void
	{
		for(var propertyName:String in this._titleProperties)
		{
			var propertyValue:Dynamic = this._titleProperties[propertyName];
			this.titleTextRenderer[propertyName] = propertyValue;
		}
	}

	/**
	 * @private
	 */
	private function calculateExtraOSStatusBarPadding():Float
	{
		if(!this._useExtraPaddingForOSStatusBar)
		{
			return 0;
		}
		var os:String = Capabilities.os;
		if(os.indexOf(IOS_NAME_PREFIX) != 0 || parseInt(os.substr(IOS_NAME_PREFIX.length, 1), 10) < STATUS_BAR_MIN_IOS_VERSION)
		{
			return 0;
		}
		var nativeStage:Stage = Starling.current.nativeStage;
		if(nativeStage.displayState != StageDisplayState.NORMAL)
		{
			return 0;
		}
		if(DeviceCapabilities.dpi >= IOS_RETINA_MINIMUM_DPI)
		{
			return IOS_RETINA_STATUS_BAR_HEIGHT;
		}
		return IOS_NON_RETINA_STATUS_BAR_HEIGHT;
	}

	/**
	 * @private
	 */
	private function layoutBackground():Void
	{
		if(!this.currentBackgroundSkin)
		{
			return;
		}
		this.currentBackgroundSkin.width = this.actualWidth;
		this.currentBackgroundSkin.height = this.actualHeight;
	}

	/**
	 * @private
	 */
	private function layoutLeftItems():Void
	{
		for each(var item:DisplayObject in this._leftItems)
		{
			if(item is IValidating)
			{
				IValidating(item).validate();
			}
		}
		HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
		HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
		HELPER_BOUNDS.explicitWidth = this.actualWidth;
		HELPER_BOUNDS.explicitHeight = this.actualHeight;
		this._layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
		this._layout.paddingRight = 0;
		this._layout.paddingLeft = this._paddingLeft;
		this._layout.layout(this._leftItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
		this.leftItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
		if(this.leftItemsWidth != this.leftItemsWidth) //isNaN
		{
			this.leftItemsWidth = 0;
		}

	}

	/**
	 * @private
	 */
	private function layoutRightItems():Void
	{
		for each(var item:DisplayObject in this._rightItems)
		{
			if(item is IValidating)
			{
				IValidating(item).validate();
			}
		}
		HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
		HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
		HELPER_BOUNDS.explicitWidth = this.actualWidth;
		HELPER_BOUNDS.explicitHeight = this.actualHeight;
		this._layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
		this._layout.paddingRight = this._paddingRight;
		this._layout.paddingLeft = 0;
		this._layout.layout(this._rightItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
		this.rightItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
		if(this.rightItemsWidth != this.rightItemsWidth) //isNaN
		{
			this.rightItemsWidth = 0;
		}
	}

	/**
	 * @private
	 */
	private function layoutCenterItems():Void
	{
		for each(var item:DisplayObject in this._centerItems)
		{
			if(item is IValidating)
			{
				IValidating(item).validate();
			}
		}
		HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
		HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
		HELPER_BOUNDS.explicitWidth = this.actualWidth;
		HELPER_BOUNDS.explicitHeight = this.actualHeight;
		this._layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
		this._layout.paddingRight = this._paddingRight;
		this._layout.paddingLeft = this._paddingLeft;
		this._layout.layout(this._centerItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
	}

	/**
	 * @private
	 */
	private function layoutTitle():Void
	{
		if((this._titleAlign == TITLE_ALIGN_CENTER && this._centerItems) || this._title.length == 0)
		{
			this.titleTextRenderer.visible = false;
			return;
		}
		this.titleTextRenderer.visible = true;
		var calculatedTitleGap:Float = this._titleGap;
		if(calculatedTitleGap != calculatedTitleGap) //isNaN
		{
			calculatedTitleGap = this._gap;
		}
		//left and right offsets already include padding
		var leftOffset:Float = (this._leftItems && this._leftItems.length > 0) ? (this.leftItemsWidth + calculatedTitleGap) : 0;
		var rightOffset:Float = (this._rightItems && this._rightItems.length > 0) ? (this.rightItemsWidth + calculatedTitleGap) : 0;
		if(this._titleAlign == TITLE_ALIGN_PREFER_LEFT && (!this._leftItems || this._leftItems.length == 0))
		{
			this.titleTextRenderer.maxWidth = this.actualWidth - this._paddingLeft - rightOffset;
			this.titleTextRenderer.validate();
			this.titleTextRenderer.x = this._paddingLeft;
		}
		else if(this._titleAlign == TITLE_ALIGN_PREFER_RIGHT && (!this._rightItems || this._rightItems.length == 0))
		{
			this.titleTextRenderer.maxWidth = this.actualWidth - this._paddingRight - leftOffset;
			this.titleTextRenderer.validate();
			this.titleTextRenderer.x = this.actualWidth - this._paddingRight - this.titleTextRenderer.width;
		}
		else
		{
			var actualWidthMinusPadding:Float = this.actualWidth - this._paddingLeft - this._paddingRight;
			var actualWidthMinusOffsets:Float = this.actualWidth - leftOffset - rightOffset;
			this.titleTextRenderer.maxWidth = actualWidthMinusOffsets;
			this.titleTextRenderer.validate();
			var idealTitlePosition:Float = this._paddingLeft + (actualWidthMinusPadding - this.titleTextRenderer.width) / 2;
			if(leftOffset > idealTitlePosition ||
				(idealTitlePosition + this.titleTextRenderer.width) > (this.actualWidth - rightOffset))
			{
				this.titleTextRenderer.x = leftOffset + (actualWidthMinusOffsets - this.titleTextRenderer.width) / 2;
			}
			else
			{
				this.titleTextRenderer.x = idealTitlePosition;
			}
		}
		var paddingTop:Float = this._paddingTop + this.calculateExtraOSStatusBarPadding();
		if(this._verticalAlign == VERTICAL_ALIGN_TOP)
		{
			this.titleTextRenderer.y = paddingTop;
		}
		else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
		{
			this.titleTextRenderer.y = this.actualHeight - this._paddingBottom - this.titleTextRenderer.height;
		}
		else
		{
			this.titleTextRenderer.y = paddingTop + (this.actualHeight - paddingTop - this._paddingBottom - this.titleTextRenderer.height) / 2;
		}
	}

	/**
	 * @private
	 */
	private function header_addedToStageHandler(event:Event):Void
	{
		Starling.current.nativeStage.addEventListener("fullScreen", nativeStage_fullScreenHandler);
	}

	/**
	 * @private
	 */
	private function header_removedFromStageHandler(event:Event):Void
	{
		Starling.current.nativeStage.removeEventListener("fullScreen", nativeStage_fullScreenHandler);
	}

	/**
	 * @private
	 */
	private function nativeStage_fullScreenHandler(event:FullScreenEvent):Void
	{
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function titleProperties_onChange(proxy:PropertyProxy, propertyName:String):Void
	{
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private function item_resizeHandler(event:Event):Void
	{
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}
}
