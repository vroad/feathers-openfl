/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.IValidating;
import feathers.core.PopUpManager;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.utils.display.FeathersDisplayUtil.getDisplayObjectDepthFromStage;
import openfl.errors.ArgumentError;
import starling.display.Quad;

import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the callout is closed.
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
 * A pop-up container that points at (or calls out) a specific region of
 * the application (typically a specific control that triggered it).
 *
 * <p>In general, a <code>Callout</code> isn't instantiated directly.
 * Instead, you will typically call the static function
 * <code>Callout.show()</code>. This is not required, but it result in less
 * code and no need to manually manage calls to the <code>PopUpManager</code>.</p>
 *
 * <p>In the following example, a callout displaying a <code>Label</code> is
 * shown when a <code>Button</code> is triggered:</p>
 *
 * <listing version="3.0">
 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
 * 
 * function button_triggeredHandler( event:Event ):Void
 * {
 *     var label:Label = new Label();
 *     label.text = "Hello World!";
 *     var button:Button = Button( event.currentTarget );
 *     Callout.show( label, button );
 * }</listing>
 *
 * @see ../../../help/callout.html How to use the Feathers Callout component
 */
class Callout extends FeathersControl
{
	/**
	 * The default <code>IStyleProvider</code> for all <code>Callout</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * The callout may be positioned on any side of the origin region.
	 *
	 * @see #supportedDirections
	 */
	inline public static var DIRECTION_ANY:String = "any";

	/**
	 * The callout may be positioned on top or bottom of the origin region.
	 *
	 * @see #supportedDirections
	 */
	inline public static var DIRECTION_VERTICAL:String = "vertical";

	/**
	 * The callout may be positioned on top or bottom of the origin region.
	 *
	 * @see #supportedDirections
	 */
	inline public static var DIRECTION_HORIZONTAL:String = "horizontal";

	/**
	 * The callout must be positioned above the origin region.
	 *
	 * @see #supportedDirections
	 */
	inline public static var DIRECTION_UP:String = "up";

	/**
	 * The callout must be positioned below the origin region.
	 *
	 * @see #supportedDirections
	 */
	inline public static var DIRECTION_DOWN:String = "down";

	/**
	 * The callout must be positioned to the left side of the origin region.
	 *
	 * @see #supportedDirections
	 */
	inline public static var DIRECTION_LEFT:String = "left";

	/**
	 * The callout must be positioned to the right side of the origin region.
	 *
	 * @see #supportedDirections
	 */
	inline public static var DIRECTION_RIGHT:String = "right";

	/**
	 * The arrow will appear on the top side of the callout.
	 *
	 * @see #arrowPosition
	 */
	inline public static var ARROW_POSITION_TOP:String = "top";

	/**
	 * The arrow will appear on the right side of the callout.
	 *
	 * @see #arrowPosition
	 */
	inline public static var ARROW_POSITION_RIGHT:String = "right";

	/**
	 * The arrow will appear on the bottom side of the callout.
	 *
	 * @see #arrowPosition
	 */
	inline public static var ARROW_POSITION_BOTTOM:String = "bottom";

	/**
	 * The arrow will appear on the left side of the callout.
	 *
	 * @see #arrowPosition
	 */
	inline public static var ARROW_POSITION_LEFT:String = "left";

	/**
	 * @private
	 */
	inline private static var INVALIDATION_FLAG_ORIGIN:String = "origin";

	/**
	 * @private
	 */
	private static var HELPER_RECT:Rectangle = new Rectangle();

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	private static var DIRECTION_TO_FUNCTION:Map<String, Callout->Rectangle->Void> = [
		DIRECTION_ANY => positionBestSideOfOrigin,
		DIRECTION_UP => positionAboveOrigin,
		DIRECTION_DOWN => positionBelowOrigin,
		DIRECTION_LEFT => positionToLeftOfOrigin,
		DIRECTION_RIGHT => positionToRightOfOrigin,
		DIRECTION_VERTICAL => positionAboveOrBelowOrigin,
		DIRECTION_HORIZONTAL => positionToLeftOrRightOfOrigin,
	];

	/**
	 * @private
	 */
	inline private static var FUZZY_CONTENT_DIMENSIONS_PADDING:Float = 0.000001;

	/**
	 * Quickly sets all stage padding properties to the same value. The
	 * <code>stagePadding</code> getter always returns the value of
	 * <code>stagePaddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>The following example gives the stage 20 pixels of padding on all
	 * sides:</p>
	 *
	 * <listing version="3.0">
	 * Callout.stagePadding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #stagePaddingTop
	 * @see #stagePaddingRight
	 * @see #stagePaddingBottom
	 * @see #stagePaddingLeft
	 */
	public static var stagePadding(get, set):Float;
	public static function get_stagePadding():Float
	{
		return Callout.stagePaddingTop;
	}

	/**
	 * @private
	 */
	public static function set_stagePadding(value:Float):Float
	{
		Callout.stagePaddingTop = value;
		Callout.stagePaddingRight = value;
		Callout.stagePaddingBottom = value;
		Callout.stagePaddingLeft = value;
		return get_stagePadding();
	}

	/**
	 * The padding between a callout and the top edge of the stage when the
	 * callout is positioned automatically. May be ignored if the callout
	 * is too big for the stage.
	 *
	 * <p>In the following example, the top stage padding will be set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * Callout.stagePaddingTop = 20;</listing>
	 */
	public static var stagePaddingTop:Float = 0;

	/**
	 * The padding between a callout and the right edge of the stage when the
	 * callout is positioned automatically. May be ignored if the callout
	 * is too big for the stage.
	 *
	 * <p>In the following example, the right stage padding will be set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * Callout.stagePaddingRight = 20;</listing>
	 */
	public static var stagePaddingRight:Float = 0;

	/**
	 * The padding between a callout and the bottom edge of the stage when the
	 * callout is positioned automatically. May be ignored if the callout
	 * is too big for the stage.
	 *
	 * <p>In the following example, the bottom stage padding will be set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * Callout.stagePaddingBottom = 20;</listing>
	 */
	public static var stagePaddingBottom:Float = 0;

	/**
	 * The margin between a callout and the top edge of the stage when the
	 * callout is positioned automatically. May be ignored if the callout
	 * is too big for the stage.
	 *
	 * <p>In the following example, the left stage padding will be set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * Callout.stagePaddingLeft = 20;</listing>
	 */
	public static var stagePaddingLeft:Float = 0;

	/**
	 * Returns a new <code>Callout</code> instance when <code>Callout.show()</code>
	 * is called with isModal set to true. If one wishes to skin the callout
	 * manually, a custom factory may be provided.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Callout</pre>
	 *
	 * <p>The following example shows how to create a custom callout factory:</p>
	 *
	 * <listing version="3.0">
	 * Callout.calloutFactory = function():Callout
	 * {
	 *     var callout:Callout = new Callout();
	 *     //set properties here!
	 *     return callout;
	 * };</listing>
	 *
	 * @see #show()
	 */
	public static var calloutFactory:Void->Callout = defaultCalloutFactory;

	/**
	 * Returns an overlay to display with a callout that is modal. Uses the
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
	 * Callout.calloutOverlayFactory = function():Quad
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
	public static var calloutOverlayFactory:Void->DisplayObject = PopUpManager.defaultOverlayFactory;

	/**
	 * Creates a callout, and then positions and sizes it automatically
	 * based on an origin rectangle and the specified direction relative to
	 * the original. The provided width and height values are optional, and
	 * these values may be ignored if the callout cannot be drawn at the
	 * specified dimensions.
	 *
	 * <p>In the following example, a callout displaying a <code>Label</code> is
	 * shown when a <code>Button</code> is triggered:</p>
	 *
	 * <listing version="3.0">
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 *
	 * function button_triggeredHandler( event:Event ):Void
	 * {
	 *     var label:Label = new Label();
	 *     label.text = "Hello World!";
	 *     var button:Button = Button( event.currentTarget );
	 *     Callout.show( label, button );
	 * }</listing>
	 */
	public static function show(content:DisplayObject, origin:DisplayObject, supportedDirections:String = DIRECTION_ANY,
		isModal:Bool = true, customCalloutFactory:Void->Callout = null, customOverlayFactory:Void->DisplayObject = null):Callout
	{
		if(origin.stage == null)
		{
			throw new ArgumentError("Callout origin must be added to the stage.");
		}
		var factory:Void->Callout = customCalloutFactory;
		if(factory == null)
		{
			factory = calloutFactory != null ? calloutFactory : defaultCalloutFactory;
		}
		var callout:Callout = factory();
		callout.content = content;
		callout.supportedDirections = supportedDirections;
		callout.origin = origin;
		var overlayFactory:Void->DisplayObject = customOverlayFactory;
		if(overlayFactory == null)
		{
			overlayFactory = calloutOverlayFactory != null ? calloutOverlayFactory : PopUpManager.defaultOverlayFactory;
		}
		PopUpManager.addPopUp(callout, isModal, false, overlayFactory);
		return callout;
	}

	/**
	 * The default factory that creates callouts when <code>Callout.show()</code>
	 * is called. To use a different factory, you need to set
	 * <code>Callout.calloutFactory</code> to a <code>Function</code>
	 * instance.
	 */
	public static function defaultCalloutFactory():Callout
	{
		var callout:Callout = new Callout();
		callout.closeOnTouchBeganOutside = true;
		callout.closeOnTouchEndedOutside = true;
#if flash
		callout.closeOnKeys = [Keyboard.BACK, Keyboard.ESCAPE];
#else
		callout.closeOnKeys = [Keyboard.ESCAPE];
#end
		return callout;
	}

	/**
	 * @private
	 */
	private static function positionWithSupportedDirections(callout:Callout, globalOrigin:Rectangle, direction:String):Void
	{
		if(DIRECTION_TO_FUNCTION.exists(direction))
		{
			var calloutPositionFunction:Callout->Rectangle->Void = DIRECTION_TO_FUNCTION[direction];
			calloutPositionFunction(callout, globalOrigin);
		}
		else
		{
			positionBestSideOfOrigin(callout, globalOrigin);
		}
	}

	/**
	 * @private
	 */
	private static function positionBestSideOfOrigin(callout:Callout, globalOrigin:Rectangle):Void
	{
		callout.measureWithArrowPosition(ARROW_POSITION_TOP, HELPER_POINT);
		var downSpace:Float = (Starling.current.stage.stageHeight - HELPER_POINT.y) - (globalOrigin.y + globalOrigin.height);
		if(downSpace >= stagePaddingBottom)
		{
			positionBelowOrigin(callout, globalOrigin);
			return;
		}

		callout.measureWithArrowPosition(ARROW_POSITION_BOTTOM, HELPER_POINT);
		var upSpace:Float = globalOrigin.y - HELPER_POINT.y;
		if(upSpace >= stagePaddingTop)
		{
			positionAboveOrigin(callout, globalOrigin);
			return;
		}

		callout.measureWithArrowPosition(ARROW_POSITION_LEFT, HELPER_POINT);
		var rightSpace:Float = (Starling.current.stage.stageWidth - HELPER_POINT.x) - (globalOrigin.x + globalOrigin.width);
		if(rightSpace >= stagePaddingRight)
		{
			positionToRightOfOrigin(callout, globalOrigin);
			return;
		}

		callout.measureWithArrowPosition(ARROW_POSITION_RIGHT, HELPER_POINT);
		var leftSpace:Float = globalOrigin.x - HELPER_POINT.x;
		if(leftSpace >= stagePaddingLeft)
		{
			positionToLeftOfOrigin(callout, globalOrigin);
			return;
		}

		//worst case: pick the side that has the most available space
		if(downSpace >= upSpace && downSpace >= rightSpace && downSpace >= leftSpace)
		{
			positionBelowOrigin(callout, globalOrigin);
		}
		else if(upSpace >= rightSpace && upSpace >= leftSpace)
		{
			positionAboveOrigin(callout, globalOrigin);
		}
		else if(rightSpace >= leftSpace)
		{
			positionToRightOfOrigin(callout, globalOrigin);
		}
		else
		{
			positionToLeftOfOrigin(callout, globalOrigin);
		}
	}

	/**
	 * @private
	 */
	private static function positionAboveOrBelowOrigin(callout:Callout, globalOrigin:Rectangle):Void
	{
		callout.measureWithArrowPosition(ARROW_POSITION_TOP, HELPER_POINT);
		var downSpace:Float = (Starling.current.stage.stageHeight - HELPER_POINT.y) - (globalOrigin.y + globalOrigin.height);
		if(downSpace >= stagePaddingBottom)
		{
			positionBelowOrigin(callout, globalOrigin);
			return;
		}

		callout.measureWithArrowPosition(ARROW_POSITION_BOTTOM, HELPER_POINT);
		var upSpace:Float = globalOrigin.y - HELPER_POINT.y;
		if(upSpace >= stagePaddingTop)
		{
			positionAboveOrigin(callout, globalOrigin);
			return;
		}

		//worst case: pick the side that has the most available space
		if(downSpace >= upSpace)
		{
			positionBelowOrigin(callout, globalOrigin);
		}
		else
		{
			positionAboveOrigin(callout, globalOrigin);
		}
	}

	/**
	 * @private
	 */
	private static function positionToLeftOrRightOfOrigin(callout:Callout, globalOrigin:Rectangle):Void
	{
		callout.measureWithArrowPosition(ARROW_POSITION_LEFT, HELPER_POINT);
		var rightSpace:Float = (Starling.current.stage.stageWidth - HELPER_POINT.x) - (globalOrigin.x + globalOrigin.width);
		if(rightSpace >= stagePaddingRight)
		{
			positionToRightOfOrigin(callout, globalOrigin);
			return;
		}

		callout.measureWithArrowPosition(ARROW_POSITION_RIGHT, HELPER_POINT);
		var leftSpace:Float = globalOrigin.x - HELPER_POINT.x;
		if(leftSpace >= stagePaddingLeft)
		{
			positionToLeftOfOrigin(callout, globalOrigin);
			return;
		}

		//worst case: pick the side that has the most available space
		if(rightSpace >= leftSpace)
		{
			positionToRightOfOrigin(callout, globalOrigin);
		}
		else
		{
			positionToLeftOfOrigin(callout, globalOrigin);
		}
	}

	/**
	 * @private
	 */
	private static function positionBelowOrigin(callout:Callout, globalOrigin:Rectangle):Void
	{
		callout.measureWithArrowPosition(ARROW_POSITION_TOP, HELPER_POINT);
		var idealXPosition:Float = globalOrigin.x + Math.round((globalOrigin.width - HELPER_POINT.x) / 2);
		var xPosition:Float = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageWidth - HELPER_POINT.x - stagePaddingRight, idealXPosition));
		callout.x = xPosition;
		callout.y = globalOrigin.y + globalOrigin.height;
		if(callout._isValidating)
		{
			//no need to invalidate and need to validate again next frame
			callout._arrowOffset = idealXPosition - xPosition;
			callout._arrowPosition = ARROW_POSITION_TOP;
		}
		else
		{
			callout.arrowOffset = idealXPosition - xPosition;
			callout.arrowPosition = ARROW_POSITION_TOP;
		}
	}

	/**
	 * @private
	 */
	private static function positionAboveOrigin(callout:Callout, globalOrigin:Rectangle):Void
	{
		callout.measureWithArrowPosition(ARROW_POSITION_BOTTOM, HELPER_POINT);
		var idealXPosition:Float = globalOrigin.x + Math.round((globalOrigin.width - HELPER_POINT.x) / 2);
		var xPosition:Float = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageWidth - HELPER_POINT.x - stagePaddingRight, idealXPosition));
		callout.x = xPosition;
		callout.y = globalOrigin.y - HELPER_POINT.y;
		if(callout._isValidating)
		{
			//no need to invalidate and need to validate again next frame
			callout._arrowOffset = idealXPosition - xPosition;
			callout._arrowPosition = ARROW_POSITION_BOTTOM;
		}
		else
		{
			callout.arrowOffset = idealXPosition - xPosition;
			callout.arrowPosition = ARROW_POSITION_BOTTOM;
		}
	}

	/**
	 * @private
	 */
	private static function positionToRightOfOrigin(callout:Callout, globalOrigin:Rectangle):Void
	{
		callout.measureWithArrowPosition(ARROW_POSITION_LEFT, HELPER_POINT);
		callout.x = globalOrigin.x + globalOrigin.width;
		var idealYPosition:Float = globalOrigin.y + Math.round((globalOrigin.height - HELPER_POINT.y) / 2);
		var yPosition:Float = Math.max(stagePaddingTop, Math.min(Starling.current.stage.stageHeight - HELPER_POINT.y - stagePaddingBottom, idealYPosition));
		callout.y = yPosition;
		if(callout._isValidating)
		{
			//no need to invalidate and need to validate again next frame
			callout._arrowOffset = idealYPosition - yPosition;
			callout._arrowPosition = ARROW_POSITION_LEFT;
		}
		else
		{
			callout.arrowOffset = idealYPosition - yPosition;
			callout.arrowPosition = ARROW_POSITION_LEFT;
		}
	}

	/**
	 * @private
	 */
	private static function positionToLeftOfOrigin(callout:Callout, globalOrigin:Rectangle):Void
	{
		callout.measureWithArrowPosition(ARROW_POSITION_RIGHT, HELPER_POINT);
		callout.x = globalOrigin.x - HELPER_POINT.x;
		var idealYPosition:Float = globalOrigin.y + Math.round((globalOrigin.height - HELPER_POINT.y) / 2);
		var yPosition:Float = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageHeight - HELPER_POINT.y - stagePaddingBottom, idealYPosition));
		callout.y = yPosition;
		if(callout._isValidating)
		{
			//no need to invalidate and need to validate again next frame
			callout._arrowOffset = idealYPosition - yPosition;
			callout._arrowPosition = ARROW_POSITION_RIGHT;
		}
		else
		{
			callout.arrowOffset = idealYPosition - yPosition;
			callout.arrowPosition = ARROW_POSITION_RIGHT;
		}
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, callout_addedToStageHandler);
	}

	/**
	 * Determines if the callout is automatically closed if a touch in the
	 * <code>TouchPhase.BEGAN</code> phase happens outside of the callout's
	 * bounds.
	 *
	 * <p>In the following example, the callout will not close when a touch
	 * event with <code>TouchPhase.BEGAN</code> is detected outside the
	 * callout's (or its origin's) bounds:</p>
	 *
	 * <listing version="3.0">
	 * callout.closeOnTouchBeganOutside = false;</listing>
	 *
	 * @see #closeOnTouchEndedOutside
	 * @see #closeOnKeys
	 */
	public var closeOnTouchBeganOutside:Bool = false;

	/**
	 * Determines if the callout is automatically closed if a touch in the
	 * <code>TouchPhase.ENDED</code> phase happens outside of the callout's
	 * bounds.
	 *
	 * <p>In the following example, the callout will not close when a touch
	 * event with <code>TouchPhase.ENDED</code> is detected outside the
	 * callout's (or its origin's) bounds:</p>
	 *
	 * <listing version="3.0">
	 * callout.closeOnTouchEndedOutside = false;</listing>
	 *
	 * @see #closeOnTouchBeganOutside
	 * @see #closeOnKeys
	 */
	public var closeOnTouchEndedOutside:Bool = false;

	/**
	 * The callout will be closed if any of these keys are pressed.
	 *
	 * <p>In the following example, the callout close when the Escape key
	 * is pressed:</p>
	 *
	 * <listing version="3.0">
	 * callout.closeOnKeys = new &lt;uint&gt;[Keyboard.ESCAPE];</listing>
	 *
	 * @see #closeOnTouchBeganOutside
	 * @see #closeOnTouchEndedOutside
	 */
	public var closeOnKeys:Array<UInt>;

	/**
	 * Determines if the callout will be disposed when <code>close()</code>
	 * is called internally. Close may be called internally in a variety of
	 * cases, depending on values such as <code>closeOnTouchBeganOutside</code>,
	 * <code>closeOnTouchEndedOutside</code>, and <code>closeOnKeys</code>.
	 * If set to <code>false</code>, you may reuse the callout later by
	 * giving it a new <code>origin</code> and adding it to the
	 * <code>PopUpManager</code> again.
	 *
	 * <p>In the following example, the callout will not be disposed when it
	 * closes itself:</p>
	 *
	 * <listing version="3.0">
	 * callout.disposeOnSelfClose = false;</listing>
	 *
	 * @see #closeOnTouchBeganOutside
	 * @see #closeOnTouchEndedOutside
	 * @see #closeOnKeys
	 * @see #close()
	 */
	public var disposeOnSelfClose:Bool = true;

	/**
	 * Determines if the callout's content will be disposed when the callout
	 * is disposed. If set to <code>false</code>, the callout's content may
	 * be added to the display list again later.
	 *
	 * <p>In the following example, the callout's content will not be
	 * disposed when the callout is disposed:</p>
	 *
	 * <listing version="3.0">
	 * callout.disposeContent = false;</listing>
	 */
	public var disposeContent:Bool = true;

	/**
	 * @private
	 */
	private var _isReadyToClose:Bool = false;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Callout.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _content:DisplayObject;

	/**
	 * The display object that will be presented by the callout. This object
	 * may be resized to fit the callout's bounds. If the content needs to
	 * be scrolled if placed into a smaller region than its ideal size, it
	 * must provide its own scrolling capabilities because the callout does
	 * not offer scrolling.
	 *
	 * <p>In the following example, the callout's content is an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.content = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var content(get, set):DisplayObject;
	public function get_content():DisplayObject
	{
		return this._content;
	}

	/**
	 * @private
	 */
	public function set_content(value:DisplayObject):DisplayObject
	{
		if(this._content == value)
		{
			return get_content();
		}
		if(this._content != null)
		{
			if(Std.is(this._content, IFeathersControl))
			{
				cast(this._content, IFeathersControl).removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			if(this._content.parent == this)
			{
				this._content.removeFromParent(false);
			}
		}
		this._content = value;
		if(this._content != null)
		{
			if(Std.is(this._content, IFeathersControl))
			{
				cast(this._content, IFeathersControl).addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			this.addChild(this._content);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_content();
	}

	/**
	 * @private
	 */
	private var _origin:DisplayObject;

	/**
	 * A callout may be positioned relative to another display object, known
	 * as the callout's origin. Even if the position of the origin changes,
	 * the callout will reposition itself to always point at the origin.
	 *
	 * <p>When an origin is set, the <code>arrowPosition</code> and
	 * <code>arrowOffset</code> properties will be managed automatically by
	 * the callout. Setting either of these values manually with either have
	 * no effect or unexpected behavior, so it is recommended that you
	 * avoid modifying those properties.</p>
	 *
	 * <p>In general, if you use <code>Callout.show()</code>, you will
	 * rarely need to manually manage the origin.</p>
	 *
	 * <p>In the following example, the callout's origin is set to a button:</p>
	 *
	 * <listing version="3.0">
	 * callout.origin = button;</listing>
	 *
	 * @default null
	 *
	 * @see #supportedDirections
	 * @see #arrowPosition
	 * @see #arrowOffset
	 */
	public var origin(get, set):DisplayObject;
	public function get_origin():DisplayObject
	{
		return this._origin;
	}

	public function set_origin(value:DisplayObject):DisplayObject
	{
		if(this._origin == value)
		{
			return get_origin();
		}
		if(value != null && value.stage == null)
		{
			throw new ArgumentError("Callout origin must have access to the stage.");
		}
		if(this._origin != null)
		{
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, callout_enterFrameHandler);
			this._origin.removeEventListener(Event.REMOVED_FROM_STAGE, origin_removedFromStageHandler);
		}
		this._origin = value;
		this._lastGlobalBoundsOfOrigin = null;
		if(this._origin != null)
		{
			this._origin.addEventListener(Event.REMOVED_FROM_STAGE, origin_removedFromStageHandler);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, callout_enterFrameHandler);
		}
		this.invalidate(INVALIDATION_FLAG_ORIGIN);
		return get_origin();
	}

	/**
	 * @private
	 */
	private var _supportedDirections:String = DIRECTION_ANY;

	//[Inspectable(type="String",enumeration="any,vertical,horizontal,up,down,left,right")]
	/**
	 * The directions that the callout may be positioned, relative to its
	 * origin. If the callout's origin is not set, this value will be
	 * ignored.
	 *
	 * <p>The <code>arrowPosition</code> property is related to this one,
	 * but they have different meanings and are usually opposites. For
	 * example, a callout on the right side of its origin will generally
	 * display its left arrow.</p>
	 *
	 * <p>In the following example, the callout's supported directions are
	 * restricted to up and down:</p>
	 *
	 * <listing version="3.0">
	 * callout.supportedDirections = Callout.DIRECTION_VERTICAL;</listing>
	 *
	 * @default Callout.DIRECTION_ANY
	 *
	 * @see #origin
	 * @see #DIRECTION_ANY
	 * @see #DIRECTION_VERTICAL
	 * @see #DIRECTION_HORIZONTAL
	 * @see #DIRECTION_UP
	 * @see #DIRECTION_DOWN
	 * @see #DIRECTION_LEFT
	 * @see #DIRECTION_RIGHT
	 * @see #arrowPosition
	 */
	public var supportedDirections(get, set):String;
	public function get_supportedDirections():String
	{
		return this._supportedDirections;
	}

	public function set_supportedDirections(value:String):String
	{
		this._supportedDirections = value;
		return get_supportedDirections();
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding of all sides of the callout
	 * is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.padding = 20;</listing>
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
		return get_padding();
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the callout's top edge and the
	 * callout's content.
	 *
	 * <p>In the following example, the padding on the top edge of the
	 * callout is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.paddingTop = 20;</listing>
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
			return get_paddingTop();
		}
		this._paddingTop = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the callout's right edge and
	 * the callout's content.
	 *
	 * <p>In the following example, the padding on the right edge of the
	 * callout is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.paddingRight = 20;</listing>
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
			return get_paddingRight();
		}
		this._paddingRight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the callout's bottom edge and
	 * the callout's content.
	 *
	 * <p>In the following example, the padding on the bottom edge of the
	 * callout is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.paddingBottom = 20;</listing>
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
			return get_paddingBottom();
		}
		this._paddingBottom = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the callout's left edge and the
	 * callout's content.
	 *
	 * <p>In the following example, the padding on the left edge of the
	 * callout is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.paddingLeft = 20;</listing>
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
			return get_paddingLeft();
		}
		this._paddingLeft = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
	}

	/**
	 * @private
	 */
	private var _arrowPosition:String = ARROW_POSITION_TOP;

	//[Inspectable(type="String",enumeration="top,right,bottom,left")]
	/**
	 * The position of the callout's arrow relative to the callout's
	 * background. If the callout's <code>origin</code> is set, this value
	 * will be managed by the callout and may change automatically if the
	 * origin moves to a new position or if the stage resizes.
	 *
	 * <p>The <code>supportedDirections</code> property is related to this
	 * one, but they have different meanings and are usually opposites. For
	 * example, a callout on the right side of its origin will generally
	 * display its left arrow.</p>
	 *
	 * <p>If you use <code>Callout.show()</code> or set the <code>origin</code>
	 * property manually, you should avoid manually modifying the
	 * <code>arrowPosition</code> and <code>arrowOffset</code> properties.</p>
	 *
	 * <p>In the following example, the callout's arrow is positioned on the
	 * left side:</p>
	 *
	 * <listing version="3.0">
	 * callout.arrowPosition = Callout.ARROW_POSITION_LEFT;</listing>
	 *
	 * @default Callout.ARROW_POSITION_TOP
	 *
	 * @see #ARROW_POSITION_TOP
	 * @see #ARROW_POSITION_RIGHT
	 * @see #ARROW_POSITION_BOTTOM
	 * @see #ARROW_POSITION_LEFT
	 *
	 * @see #origin
	 * @see #supportedDirections
	 * @see #arrowOffset
	 */
	public var arrowPosition(get, set):String;
	public function get_arrowPosition():String
	{
		return this._arrowPosition;
	}

	/**
	 * @private
	 */
	public function set_arrowPosition(value:String):String
	{
		if(this._arrowPosition == value)
		{
			return get_arrowPosition();
		}
		this._arrowPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_arrowPosition();
	}

	/**
	 * @private
	 */
	private var _originalBackgroundWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _originalBackgroundHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * The primary background to display.
	 *
	 * <p>In the following example, the callout's background is set to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.backgroundSkin = new Image( texture );</listing>
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
			return get_backgroundSkin();
		}

		if(this._backgroundSkin != null)
		{
			this.removeChild(this._backgroundSkin);
		}
		this._backgroundSkin = value;
		if(this._backgroundSkin != null)
		{
			this._originalBackgroundWidth = this._backgroundSkin.width;
			this._originalBackgroundHeight = this._backgroundSkin.height;
			this.addChildAt(this._backgroundSkin, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_backgroundSkin();
	}

	/**
	 * @private
	 */
	private var currentArrowSkin:DisplayObject;

	/**
	 * @private
	 */
	private var _bottomArrowSkin:DisplayObject;

	/**
	 * The arrow skin to display on the bottom edge of the callout. This
	 * arrow is displayed when the callout is displayed above the region it
	 * points at.
	 *
	 * <p>In the following example, the callout's bottom arrow skin is set
	 * to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.bottomArrowSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var bottomArrowSkin(get, set):DisplayObject;
	public function get_bottomArrowSkin():DisplayObject
	{
		return this._bottomArrowSkin;
	}

	/**
	 * @private
	 */
	public function set_bottomArrowSkin(value:DisplayObject):DisplayObject
	{
		if(this._bottomArrowSkin == value)
		{
			return get_bottomArrowSkin();
		}

		if(this._bottomArrowSkin != null)
		{
			this.removeChild(this._bottomArrowSkin);
		}
		this._bottomArrowSkin = value;
		if(this._bottomArrowSkin != null)
		{
			this._bottomArrowSkin.visible = false;
			var index:Int = this.getChildIndex(this._content);
			if(index < 0)
			{
				this.addChild(this._bottomArrowSkin);
			}
			else
			{
				this.addChildAt(this._bottomArrowSkin, index);
			}
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_bottomArrowSkin();
	}

	/**
	 * @private
	 */
	private var _topArrowSkin:DisplayObject;

	/**
	 * The arrow skin to display on the top edge of the callout. This arrow
	 * is displayed when the callout is displayed below the region it points
	 * at.
	 *
	 * <p>In the following example, the callout's top arrow skin is set
	 * to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.topArrowSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var topArrowSkin(get, set):DisplayObject;
	public function get_topArrowSkin():DisplayObject
	{
		return this._topArrowSkin;
	}

	/**
	 * @private
	 */
	public function set_topArrowSkin(value:DisplayObject):DisplayObject
	{
		if(this._topArrowSkin == value)
		{
			return get_topArrowSkin();
		}

		if(this._topArrowSkin != null)
		{
			this.removeChild(this._topArrowSkin);
		}
		this._topArrowSkin = value;
		if(this._topArrowSkin != null)
		{
			this._topArrowSkin.visible = false;
			var index:Int = this.getChildIndex(this._content);
			if(index < 0)
			{
				this.addChild(this._topArrowSkin);
			}
			else
			{
				this.addChildAt(this._topArrowSkin, index);
			}
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_topArrowSkin();
	}

	/**
	 * @private
	 */
	private var _leftArrowSkin:DisplayObject;

	/**
	 * The arrow skin to display on the left edge of the callout. This arrow
	 * is displayed when the callout is displayed to the right of the region
	 * it points at.
	 *
	 * <p>In the following example, the callout's left arrow skin is set
	 * to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.leftArrowSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var leftArrowSkin(get, set):DisplayObject;
	public function get_leftArrowSkin():DisplayObject
	{
		return this._leftArrowSkin;
	}

	/**
	 * @private
	 */
	public function set_leftArrowSkin(value:DisplayObject):DisplayObject
	{
		if(this._leftArrowSkin == value)
		{
			return get_leftArrowSkin();
		}

		if(this._leftArrowSkin != null)
		{
			this.removeChild(this._leftArrowSkin);
		}
		this._leftArrowSkin = value;
		if(this._leftArrowSkin != null)
		{
			this._leftArrowSkin.visible = false;
			var index:Int = this.getChildIndex(this._content);
			if(index < 0)
			{
				this.addChild(this._leftArrowSkin);
			}
			else
			{
				this.addChildAt(this._leftArrowSkin, index);
			}
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_leftArrowSkin();
	}

	/**
	 * @private
	 */
	private var _rightArrowSkin:DisplayObject;

	/**
	 * The arrow skin to display on the right edge of the callout. This
	 * arrow is displayed when the callout is displayed to the left of the
	 * region it points at.
	 *
	 * <p>In the following example, the callout's right arrow skin is set
	 * to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.rightArrowSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var rightArrowSkin(get, set):DisplayObject;
	public function get_rightArrowSkin():DisplayObject
	{
		return this._rightArrowSkin;
	}

	/**
	 * @private
	 */
	public function set_rightArrowSkin(value:DisplayObject):DisplayObject
	{
		if(this._rightArrowSkin == value)
		{
			return get_rightArrowSkin();
		}

		if(this._rightArrowSkin != null)
		{
			this.removeChild(this._rightArrowSkin);
		}
		this._rightArrowSkin = value;
		if(this._rightArrowSkin != null)
		{
			this._rightArrowSkin.visible = false;
			var index:Int = this.getChildIndex(this._content);
			if(index < 0)
			{
				this.addChild(this._rightArrowSkin);
			}
			else
			{
				this.addChildAt(this._rightArrowSkin, index);
			}
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_rightArrowSkin();
	}

	/**
	 * @private
	 */
	private var _topArrowGap:Float = 0;

	/**
	 * The space, in pixels, between the top arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 *
	 * <p>In the following example, the gap between the callout and its
	 * top arrow is set to -4 pixels (perhaps to hide a border on the
	 * callout's background):</p>
	 *
	 * <listing version="3.0">
	 * callout.topArrowGap = -4;</listing>
	 *
	 * @default 0
	 */
	public var topArrowGap(get, set):Float;
	public function get_topArrowGap():Float
	{
		return this._topArrowGap;
	}

	/**
	 * @private
	 */
	public function set_topArrowGap(value:Float):Float
	{
		if(this._topArrowGap == value)
		{
			return get_topArrowGap();
		}
		this._topArrowGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_topArrowGap();
	}

	/**
	 * @private
	 */
	private var _bottomArrowGap:Float = 0;

	/**
	 * The space, in pixels, between the bottom arrow skin and the
	 * background skin. To have the arrow overlap the background, you may
	 * use a negative gap value.
	 *
	 * <p>In the following example, the gap between the callout and its
	 * bottom arrow is set to -4 pixels (perhaps to hide a border on the
	 * callout's background):</p>
	 *
	 * <listing version="3.0">
	 * callout.bottomArrowGap = -4;</listing>
	 *
	 * @default 0
	 */
	public var bottomArrowGap(get, set):Float;
	public function get_bottomArrowGap():Float
	{
		return this._bottomArrowGap;
	}

	/**
	 * @private
	 */
	public function set_bottomArrowGap(value:Float):Float
	{
		if(this._bottomArrowGap == value)
		{
			return get_bottomArrowGap();
		}
		this._bottomArrowGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_bottomArrowGap();
	}

	/**
	 * @private
	 */
	private var _rightArrowGap:Float = 0;

	/**
	 * The space, in pixels, between the right arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 *
	 * <p>In the following example, the gap between the callout and its
	 * right arrow is set to -4 pixels (perhaps to hide a border on the
	 * callout's background):</p>
	 *
	 * <listing version="3.0">
	 * callout.rightArrowGap = -4;</listing>
	 *
	 * @default 0
	 */
	public var rightArrowGap(get, set):Float;
	public function get_rightArrowGap():Float
	{
		return this._rightArrowGap;
	}

	/**
	 * @private
	 */
	public function set_rightArrowGap(value:Float):Float
	{
		if(this._rightArrowGap == value)
		{
			return get_rightArrowGap();
		}
		this._rightArrowGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_rightArrowGap();
	}

	/**
	 * @private
	 */
	private var _leftArrowGap:Float = 0;

	/**
	 * The space, in pixels, between the right arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 *
	 * <p>In the following example, the gap between the callout and its
	 * left arrow is set to -4 pixels (perhaps to hide a border on the
	 * callout's background):</p>
	 *
	 * <listing version="3.0">
	 * callout.leftArrowGap = -4;</listing>
	 *
	 * @default 0
	 */
	public var leftArrowGap(get, set):Float;
	public function get_leftArrowGap():Float
	{
		return this._leftArrowGap;
	}

	/**
	 * @private
	 */
	public function set_leftArrowGap(value:Float):Float
	{
		if(this._leftArrowGap == value)
		{
			return get_leftArrowGap();
		}
		this._leftArrowGap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_leftArrowGap();
	}

	/**
	 * @private
	 */
	private var _arrowOffset:Float = 0;

	/**
	 * The offset, in pixels, of the arrow skin from the horizontal center
	 * or vertical middle of the background skin, depending on the position
	 * of the arrow (which side it is on). This value is used to point at
	 * the callout's origin when the callout is not perfectly centered
	 * relative to the origin.
	 *
	 * <p>On the top and bottom edges, the arrow will move left for negative
	 * values of <code>arrowOffset</code> and right for positive values. On
	 * the left and right edges, the arrow will move up for negative values
	 * and down for positive values.</p>
	 *
	 * <p>If you use <code>Callout.show()</code> or set the <code>origin</code>
	 * property manually, you should avoid manually modifying the
	 * <code>arrowPosition</code> and <code>arrowOffset</code> properties.</p>
	 *
	 * <p>In the following example, the arrow offset is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.arrowOffset = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #arrowPosition
	 * @see #origin
	 */
	public var arrowOffset(get, set):Float;
	public function get_arrowOffset():Float
	{
		return this._arrowOffset;
	}

	/**
	 * @private
	 */
	public function set_arrowOffset(value:Float):Float
	{
		if(this._arrowOffset == value)
		{
			return get_arrowOffset();
		}
		this._arrowOffset = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_arrowOffset();
	}

	/**
	 * @private
	 */
	private var _lastGlobalBoundsOfOrigin:Rectangle;

	/**
	 * @private
	 */
	private var _ignoreContentResize:Bool = false;

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		this.origin = null;
		var savedContent:DisplayObject = this._content;
		this.content = null;
		//remove the content safely if it should not be disposed
		if(savedContent != null && this.disposeContent)
		{
			savedContent.dispose();
		}
		super.dispose();
	}

	/**
	 * Closes the callout.
	 */
	public function close(dispose:Bool = false):Void
	{
		if(this.parent != null)
		{
			//don't dispose here because we need to keep the event listeners
			//when dispatching Event.CLOSE. we'll dispose after that.
			this.removeFromParent(false);
			this.dispatchEventWith(Event.CLOSE);
		}
		if(dispose)
		{
			this.dispose();
		}
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this.addEventListener(Event.REMOVED_FROM_STAGE, callout_removedFromStageHandler);
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var originInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_ORIGIN);

		if(sizeInvalid)
		{
			this._lastGlobalBoundsOfOrigin = null;
			originInvalid = true;
		}

		if(originInvalid)
		{
			this.positionToOrigin();
		}

		if(stylesInvalid || stateInvalid)
		{
			this.refreshArrowSkin();
		}

		if(stateInvalid)
		{
			if(Std.is(this._content, IFeathersControl))
			{
				cast(this._content, IFeathersControl).isEnabled = this._isEnabled;
			}
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(sizeInvalid || stylesInvalid || dataInvalid || stateInvalid)
		{
			this.layoutChildren();
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
		this.measureWithArrowPosition(this._arrowPosition, HELPER_POINT);
		return this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
	}

	/**
	 * @private
	 */
	private function measureWithArrowPosition(arrowPosition:String, result:Point = null):Point
	{
		if(result == null)
		{
			result = new Point();
		}
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			result.x = this.explicitWidth;
			result.y = this.explicitHeight;
			return result;
		}

		if(Std.is(this._content, IValidating))
		{
			cast(this._content, IValidating).validate();
		}

		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			newWidth = this._content.width + this._paddingLeft + this._paddingRight;
			if(this._originalBackgroundWidth == this._originalBackgroundWidth) //!isNaN
			{
				newWidth = Math.max(this._originalBackgroundWidth, newWidth);
			}
			if(arrowPosition == ARROW_POSITION_LEFT && this._leftArrowSkin != null)
			{
				newWidth += this._leftArrowSkin.width + this._leftArrowGap;
			}
			if(arrowPosition == ARROW_POSITION_RIGHT && this._rightArrowSkin != null)
			{
				newWidth += this._rightArrowSkin.width + this._rightArrowGap;
			}
			if(arrowPosition == ARROW_POSITION_TOP && this._topArrowSkin != null)
			{
				newWidth = Math.max(newWidth, this._topArrowSkin.width + this._paddingLeft + this._paddingRight);
			}
			if(arrowPosition == ARROW_POSITION_BOTTOM && this._bottomArrowSkin != null)
			{
				newWidth = Math.max(newWidth, this._bottomArrowSkin.width + this._paddingLeft + this._paddingRight);
			}
			if(this.stage != null)
			{
				newWidth = Math.min(newWidth, this.stage.stageWidth - stagePaddingLeft - stagePaddingRight);
			}
		}
		if(needsHeight)
		{
			newHeight = this._content.height + this._paddingTop + this._paddingBottom;
			if(this._originalBackgroundHeight == this._originalBackgroundHeight) //!isNaN
			{
				newHeight = Math.max(this._originalBackgroundHeight, newHeight);
			}
			if(arrowPosition == ARROW_POSITION_TOP && this._topArrowSkin != null)
			{
				newHeight += this._topArrowSkin.height + this._topArrowGap;
			}
			if(arrowPosition == ARROW_POSITION_BOTTOM && this._bottomArrowSkin != null)
			{
				newHeight += this._bottomArrowSkin.height + this._bottomArrowGap;
			}
			if(arrowPosition == ARROW_POSITION_LEFT && this._leftArrowSkin != null)
			{
				newHeight = Math.max(newHeight, this._leftArrowSkin.height + this._paddingTop + this._paddingBottom);
			}
			if(arrowPosition == ARROW_POSITION_RIGHT && this._rightArrowSkin != null)
			{
				newHeight = Math.max(newHeight, this._rightArrowSkin.height + this._paddingTop + this._paddingBottom);
			}
			if(this.stage != null)
			{
				newHeight = Math.min(newHeight, this.stage.stageHeight - stagePaddingTop - stagePaddingBottom);
			}
		}
		result.x = Math.max(this._minWidth, Math.min(this._maxWidth, newWidth));
		result.y = Math.max(this._minHeight,  Math.min(this._maxHeight, newHeight));
		return result;
	}

	/**
	 * @private
	 */
	private function refreshArrowSkin():Void
	{
		this.currentArrowSkin = null;
		if(this._arrowPosition == ARROW_POSITION_BOTTOM)
		{
			this.currentArrowSkin = this._bottomArrowSkin;
		}
		else if(this._bottomArrowSkin != null)
		{
			this._bottomArrowSkin.visible = false;
		}
		if(this._arrowPosition == ARROW_POSITION_TOP)
		{
			this.currentArrowSkin = this._topArrowSkin;
		}
		else if(this._topArrowSkin != null)
		{
			this._topArrowSkin.visible = false;
		}
		if(this._arrowPosition == ARROW_POSITION_LEFT)
		{
			this.currentArrowSkin = this._leftArrowSkin;
		}
		else if(this._leftArrowSkin != null)
		{
			this._leftArrowSkin.visible = false;
		}
		if(this._arrowPosition == ARROW_POSITION_RIGHT)
		{
			this.currentArrowSkin = this._rightArrowSkin;
		}
		else if(this._rightArrowSkin != null)
		{
			this._rightArrowSkin.visible = false;
		}
		if(this.currentArrowSkin != null)
		{
			this.currentArrowSkin.visible = true;
		}
	}

	/**
	 * @private
	 */
	private function layoutChildren():Void
	{
		var xPosition:Float = (this._leftArrowSkin != null && this._arrowPosition == ARROW_POSITION_LEFT) ? this._leftArrowSkin.width + this._leftArrowGap : 0;
		var yPosition:Float = (this._topArrowSkin != null &&  this._arrowPosition == ARROW_POSITION_TOP) ? this._topArrowSkin.height + this._topArrowGap : 0;
		var widthOffset:Float = (this._rightArrowSkin != null && this._arrowPosition == ARROW_POSITION_RIGHT) ? this._rightArrowSkin.width + this._rightArrowGap : 0;
		var heightOffset:Float = (this._bottomArrowSkin != null && this._arrowPosition == ARROW_POSITION_BOTTOM) ? this._bottomArrowSkin.height + this._bottomArrowGap : 0;
		var backgroundWidth:Float = this.actualWidth - xPosition - widthOffset;
		var backgroundHeight:Float = this.actualHeight - yPosition - heightOffset;
		if(this._backgroundSkin != null)
		{
			this._backgroundSkin.x = xPosition;
			this._backgroundSkin.y = yPosition;
			this._backgroundSkin.width = backgroundWidth;
			this._backgroundSkin.height = backgroundHeight;
		}

		if(this.currentArrowSkin != null)
		{
			if(this._arrowPosition == ARROW_POSITION_LEFT)
			{
				this._leftArrowSkin.x = xPosition - this._leftArrowSkin.width - this._leftArrowGap;
				this._leftArrowSkin.y = this._arrowOffset + yPosition + Math.round((backgroundHeight - this._leftArrowSkin.height) / 2);
				this._leftArrowSkin.y = Math.min(yPosition + backgroundHeight - this._paddingBottom - this._leftArrowSkin.height, Math.max(yPosition + this._paddingTop, this._leftArrowSkin.y));
			}
			else if(this._arrowPosition == ARROW_POSITION_RIGHT)
			{
				this._rightArrowSkin.x = xPosition + backgroundWidth + this._rightArrowGap;
				this._rightArrowSkin.y = this._arrowOffset + yPosition + Math.round((backgroundHeight - this._rightArrowSkin.height) / 2);
				this._rightArrowSkin.y = Math.min(yPosition + backgroundHeight - this._paddingBottom - this._rightArrowSkin.height, Math.max(yPosition + this._paddingTop, this._rightArrowSkin.y));
			}
			else if(this._arrowPosition == ARROW_POSITION_BOTTOM)
			{
				this._bottomArrowSkin.x = this._arrowOffset + xPosition + Math.round((backgroundWidth - this._bottomArrowSkin.width) / 2);
				this._bottomArrowSkin.x = Math.min(xPosition + backgroundWidth - this._paddingRight - this._bottomArrowSkin.width, Math.max(xPosition + this._paddingLeft, this._bottomArrowSkin.x));
				this._bottomArrowSkin.y = yPosition + backgroundHeight + this._bottomArrowGap;
			}
			else //top
			{
				this._topArrowSkin.x = this._arrowOffset + xPosition + Math.round((backgroundWidth - this._topArrowSkin.width) / 2);
				this._topArrowSkin.x = Math.min(xPosition + backgroundWidth - this._paddingRight - this._topArrowSkin.width, Math.max(xPosition + this._paddingLeft, this._topArrowSkin.x));
				this._topArrowSkin.y = yPosition - this._topArrowSkin.height - this._topArrowGap;
			}
		}

		if(this._content != null)
		{
			this._content.x = xPosition + this._paddingLeft;
			this._content.y = yPosition + this._paddingTop;
			var oldIgnoreContentResize:Bool = this._ignoreContentResize;
			this._ignoreContentResize = true;
			var contentWidth:Float = backgroundWidth - this._paddingLeft - this._paddingRight;
			var difference:Float = Math.abs(this._content.width - contentWidth);
			//instead of !=, we do some fuzzy math to account for possible
			//floating point errors.
			if(difference > FUZZY_CONTENT_DIMENSIONS_PADDING)
			{
				this._content.width = contentWidth;
			}
			var contentHeight:Float = backgroundHeight - this._paddingTop - this._paddingBottom;
			difference = Math.abs(this._content.height - contentHeight);
			//instead of !=, we do some fuzzy math to account for possible
			//floating point errors.
			if(difference > FUZZY_CONTENT_DIMENSIONS_PADDING)
			{
				this._content.height = contentHeight;
			}
			this._ignoreContentResize = oldIgnoreContentResize;
		}
	}

	/**
	 * @private
	 */
	private function positionToOrigin():Void
	{
		if(this._origin == null)
		{
			return;
		}
		this._origin.getBounds(Starling.current.stage, HELPER_RECT);
		var hasGlobalBounds:Bool = this._lastGlobalBoundsOfOrigin != null;
		if(!hasGlobalBounds || !this._lastGlobalBoundsOfOrigin.equals(HELPER_RECT))
		{
			if(!hasGlobalBounds)
			{
				this._lastGlobalBoundsOfOrigin = new Rectangle();
			}
			this._lastGlobalBoundsOfOrigin.x = HELPER_RECT.x;
			this._lastGlobalBoundsOfOrigin.y = HELPER_RECT.y;
			this._lastGlobalBoundsOfOrigin.width = HELPER_RECT.width;
			this._lastGlobalBoundsOfOrigin.height = HELPER_RECT.height;
			positionWithSupportedDirections(this, this._lastGlobalBoundsOfOrigin, this._supportedDirections);
		}
	}

	/**
	 * @private
	 */
	private function callout_addedToStageHandler(event:Event):Void
	{
		//using priority here is a hack so that objects higher up in the
		//display list have a chance to cancel the event first.
		var priority:Int = -getDisplayObjectDepthFromStage(this);
		Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, callout_nativeStage_keyDownHandler, false, priority, true);

		this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
		//to avoid touch events bubbling up to the callout and causing it to
		//close immediately, we wait one frame before allowing it to close
		//based on touches.
		this._isReadyToClose = false;
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, callout_oneEnterFrameHandler);
	}

	/**
	 * @private
	 */
	private function callout_removedFromStageHandler(event:Event):Void
	{
		this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
		Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, callout_nativeStage_keyDownHandler);
	}

	/**
	 * @private
	 */
	private function callout_oneEnterFrameHandler(event:Event):Void
	{
		this.removeEventListener(EnterFrameEvent.ENTER_FRAME, callout_oneEnterFrameHandler);
		this._isReadyToClose = true;
	}

	/**
	 * @private
	 */
	private function callout_enterFrameHandler(event:EnterFrameEvent):Void
	{
		this.positionToOrigin();
	}

	/**
	 * @private
	 */
	private function stage_touchHandler(event:TouchEvent):Void
	{
		var target:DisplayObject = cast(event.target, DisplayObject);
		if(!this._isReadyToClose ||
			(!this.closeOnTouchEndedOutside && !this.closeOnTouchBeganOutside) || this.contains(target) ||
			(PopUpManager.isPopUp(this) && !PopUpManager.isTopLevelPopUp(this)))
		{
			return;
		}

		if(this._origin == target || (Std.is(this._origin, DisplayObjectContainer) && cast(this._origin, DisplayObjectContainer).contains(target)))
		{
			return;
		}

		var touch:Touch;
		if(this.closeOnTouchBeganOutside)
		{
			touch = event.getTouch(this.stage, TouchPhase.BEGAN);
			if(touch != null)
			{
				this.close(this.disposeOnSelfClose);
				return;
			}
		}
		if(this.closeOnTouchEndedOutside)
		{
			touch = event.getTouch(this.stage, TouchPhase.ENDED);
			if(touch != null)
			{
				this.close(this.disposeOnSelfClose);
				return;
			}
		}
	}

	/**
	 * @private
	 */
	private function callout_nativeStage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.isDefaultPrevented())
		{
			//someone else already handled this one
			return;
		}
		if(this.closeOnKeys == null || this.closeOnKeys.indexOf(event.keyCode) < 0)
		{
			return;
		}
		//don't let the OS handle the event
#if flash
		event.preventDefault();
#end
		this.close(this.disposeOnSelfClose);
	}

	/**
	 * @private
	 */
	private function origin_removedFromStageHandler(event:Event):Void
	{
		this.close(this.disposeOnSelfClose);
	}

	/**
	 * @private
	 */
	private function content_resizeHandler(event:Event):Void
	{
		if(this._ignoreContentResize)
		{
			return;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}
}
