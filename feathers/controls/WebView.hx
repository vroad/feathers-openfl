/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.events.FeathersEventType;
#if 0
import feathers.utils.geom.matrixToScaleX;
import feathers.utils.geom.matrixToScaleY;
#else
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleX;
import feathers.utils.geom.FeathersMatrixUtil.matrixToScaleY;
#end

import flash.errors.IllegalOperationError;
import flash.events.ErrorEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
#if 0
import flash.utils.getDefinitionByName;
#end

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.utils.MatrixUtil;

import openfl.errors.Error;

import feathers.core.FeathersControl.INVALIDATION_FLAG_DATA;
import feathers.core.FeathersControl.INVALIDATION_FLAG_SIZE;

/**
 * Dispatched when a URL has finished loading with <code>loadURL()</code> or a
 * string has finished loading with <code>loadString()</code>.
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
 * @eventType starling.events.Event.COMPLETE
 *
 * @see #loadURL()
 * @see #loadString()
 */
#if 0
[Event(name="complete",type="starling.events.Event")]
#end

/**
 * Indicates that the <code>location</code> property has changed.
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
 * @see #location
 * 
 * @eventType feathers.events.FeathersEventType.LOCATION_CHANGE
 */
#if 0
[Event(name="locationChange",type="starling.events.Event")]
#end

/**
 * Indicates that an error occurred in the <code>StageWebView</code>.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The <code>flash.events.ErrorEvent</code>
 *   dispatched by the <code>StageWebView</code>.</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.ERROR
 */
#if 0
[Event(name="error",type="starling.events.Event")]
#end

/**
 * A Feathers component that displays a web browser in Adobe AIR, using the
 * <code>flash.media.StageWebView</code> class.
 *
 * <p>Warning: This component is only compatible with Adobe AIR. It cannot
 * be used with Adobe Flash Player in a web browser.</p>
 *
 * @see ../../../help/web-view.html How to use the Feathers WebView component
 */
class WebView extends FeathersControl
{
	/**
	 * @private
	 */
	private static var HELPER_MATRIX:Matrix = new Matrix();

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	inline private static var STAGE_WEB_VIEW_NOT_SUPPORTED_ERROR:String = "Feathers WebView is only supported in Adobe AIR. It cannot be used in Adobe Flash Player.";

	/**
	 * @private
	 */
	inline private static var USE_NATIVE_ERROR:String = "The useNative property may only be set before the WebView component validates for the first time.";

	/**
	 * @private
	 */
	inline private static var DEFAULT_SIZE:Float = 320;

	/**
	 * @private
	 */
	inline private static var STAGE_WEB_VIEW_FULLY_QUALIFIED_CLASS_NAME:String = "flash.media.StageWebView";

	/**
	 * @private
	 */
	private static var STAGE_WEB_VIEW_CLASS:Class<Dynamic>;

	/**
	 * Indicates if this component is supported on the current platform.
	 */
	public static var isSupported(get, never):Bool;
	public static function get_isSupported():Bool
	{
		if(STAGE_WEB_VIEW_CLASS == null)
		{
			try
			{
				STAGE_WEB_VIEW_CLASS = Type.resolveClass(STAGE_WEB_VIEW_FULLY_QUALIFIED_CLASS_NAME);
			}
			catch(error:Error)
			{
				return false;
			}
		}
		return Type.getInstanceFields(STAGE_WEB_VIEW_CLASS).indexOf("isSupported") != -1;
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.addEventListener(starling.events.Event.ADDED_TO_STAGE, webView_addedToStageHandler);
		this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, webView_removedFromStageHandler);
	}

	/**
	 * @private
	 */
	private var stageWebView:Dynamic;

	/**
	 * @private
	 */
	private var _useNative:Bool = false;

	/**
	 * Determines if the system native web browser control is used or if
	 * Adobe AIR's embedded version of the WebKit engine is used.
	 *
	 * <p>Note: Although it is not prohibited, with some content, failures can occur when the same process uses both the embedded and the system WebKit, so it is recommended that all StageWebViews in a given application be constructed with the same value for useNative. In addition, as HTMLLoader depends on the embedded WebKit, applications using HTMLLoader should only construct StageWebViews with useNative set to false.</p>
	 */
	public var useNative(get, set):Bool;
	public function get_useNative():Bool
	{
		return this._useNative;
	}

	/**
	 * @private
	 */
	public function set_useNative(value:Bool):Bool
	{
		if(this.isCreated)
		{
			throw new IllegalOperationError(USE_NATIVE_ERROR);
		}
		this._useNative = value;
		return get_useNative();
	}

	/**
	 * The URL of the currently loaded page.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#location Full description of flash.media.StageWebView.location in Adobe's Flash Platform API Reference
	 */
	public var location(get, never):String;
	public function get_location():String
	{
		if(this.stageWebView != null)
		{
			return this.stageWebView.location;
		}
		return null;
	}

	/**
	 * The title of the currently loaded page.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#title Full description of flash.media.StageWebView.title in Adobe's Flash Platform API Reference
	 */
	public var title(get, never):String;
	public function get_title():String
	{
		if(this.stageWebView != null)
		{
			return this.stageWebView.title;
		}
		return null;
	}

	/**
	 * Indicates if the web view can navigate back in its history.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#isHistoryBackEnabled Full description of flash.media.StageWebView.isHistoryBackEnabled in Adobe's Flash Platform API Reference
	 */
	public var isHistoryBackEnabled(get, never):Bool;
	public function get_isHistoryBackEnabled():Bool
	{
		if(this.stageWebView != null)
		{
			return this.stageWebView.isHistoryBackEnabled;
		}
		return false;
	}

	/**
	 * Indicates if the web view can navigate forward in its history.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#isHistoryForwardEnabled Full description of flash.media.StageWebView.isHistoryForwardEnabled in Adobe's Flash Platform API Reference
	 */
	public var isHistoryForwardEnabled(get, never):Bool;
	public function get_isHistoryForwardEnabled():Bool
	{
		if(this.stageWebView != null)
		{
			return this.stageWebView.isHistoryForwardEnabled;
		}
		return false;
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this.stageWebView != null)
		{
			this.stageWebView.stage = null;
			this.stageWebView.dispose();
			this.stageWebView = null;
		}
		super.dispose();
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		this.refreshViewPort();
		super.render(support, parentAlpha);
	}

	/**
	 * Loads the specified URL.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#loadURL() Full description of flash.media.StageWebView.loadURL() in Adobe's Flash Platform API Reference
	 */
	public function loadURL(url:String):Void
	{
		this.validate();
		this.stageWebView.loadURL(url);
	}

	/**
	 * Renders the specified HTML or XHTML string.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#loadString() Full description of flash.media.StageWebView.loadString() in Adobe's Flash Platform API Reference
	 */
	public function loadString(text:String, mimeType:String = "text/html"):Void
	{
		this.validate();
		this.stageWebView.loadString(text, mimeType);
	}

	/**
	 * Stops the current page from loading.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#stop() Full description of flash.media.StageWebView.stop() in Adobe's Flash Platform API Reference
	 */
	public function stop():Void
	{
		this.validate();
		this.stageWebView.stop();
	}

	/**
	 * Reloads the currently loaded page.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#reload() Full description of flash.media.StageWebView.reload() in Adobe's Flash Platform API Reference
	 */
	public function reload():Void
	{
		this.validate();
		this.stageWebView.reload();
	}

	/**
	 * Navigates to the previous page in the browsing history.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#historyBack() Full description of flash.media.StageWebView.historyBack() in Adobe's Flash Platform API Reference
	 * @see #isHistoryBackEnabled
	 */
	public function historyBack():Void
	{
		this.validate();
		this.stageWebView.historyBack();
	}

	/**
	 * Navigates to the next page in the browsing history.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/StageWebView.html#historyForward() Full description of flash.media.StageWebView.historyForward() in Adobe's Flash Platform API Reference
	 * @see #isHistoryForwardEnabled
	 */
	public function historyForward():Void
	{
		this.validate();
		this.stageWebView.historyForward();
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this.createStageWebView();
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);
		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
		if(sizeInvalid)
		{
			this.refreshViewPort();
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
		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			newWidth = DEFAULT_SIZE;
		}
		var newHeight:Float = this.explicitWidth;
		if(needsHeight)
		{
			newHeight = DEFAULT_SIZE;
		}
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates the <code>StageWebView</code> instance.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function createStageWebView():Void
	{
		if(isSupported)
		{
			this.stageWebView = Type.createInstance(STAGE_WEB_VIEW_CLASS, [this._useNative]);
		}
		else
		{
			throw new IllegalOperationError(STAGE_WEB_VIEW_NOT_SUPPORTED_ERROR);
		}
		this.stageWebView.addEventListener(ErrorEvent.ERROR, stageWebView_errorHandler);
		//we're using the string here because this class is AIR-only
		this.stageWebView.addEventListener("locationChange", stageWebView_locationChangeHandler);
		this.stageWebView.addEventListener(flash.events.Event.COMPLETE, stageWebView_completeHandler);
	}

	/**
	 * @private
	 */
	private function refreshViewPort():Void
	{
		var starlingViewPort:Rectangle = Starling.current.viewPort;
		var stageWebViewViewPort:Rectangle = this.stageWebView.viewPort;
		if(stageWebViewViewPort == null)
		{
			stageWebViewViewPort = new Rectangle();
		}

		HELPER_POINT.x = HELPER_POINT.y = 0;
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		var globalScaleX:Float = matrixToScaleX(HELPER_MATRIX);
		var globalScaleY:Float = matrixToScaleY(HELPER_MATRIX);
		MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
		var nativeScaleFactor:Float = 1;
		#if flash
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
		#end
		var scaleFactor:Float = Starling.current.contentScaleFactor / nativeScaleFactor;
		stageWebViewViewPort.x = Math.round(starlingViewPort.x + HELPER_POINT.x * scaleFactor);
		stageWebViewViewPort.y = Math.round(starlingViewPort.y + HELPER_POINT.y * scaleFactor);
		var viewPortWidth:Float = Math.round(this.actualWidth * scaleFactor * globalScaleX);
		if(viewPortWidth < 1 ||
			viewPortWidth != viewPortWidth) //isNaN
		{
			viewPortWidth = 1;
		}
		var viewPortHeight:Float = Math.round(this.actualHeight * scaleFactor * globalScaleY);
		if(viewPortHeight < 1 ||
			viewPortHeight != viewPortHeight) //isNaN
		{
			viewPortHeight = 1;
		}
		stageWebViewViewPort.width = viewPortWidth;
		stageWebViewViewPort.height = viewPortHeight;
		this.stageWebView.viewPort = stageWebViewViewPort;
	}

	/**
	 * @private
	 */
	private function webView_addedToStageHandler(event:starling.events.Event):Void
	{
		this.stageWebView.stage = Starling.current.nativeStage;
		this.addEventListener(starling.events.Event.ENTER_FRAME, webView_enterFrameHandler);
	}

	/**
	 * @private
	 */
	private function webView_removedFromStageHandler(event:starling.events.Event):Void
	{
		if(this.stageWebView != null)
		{
			this.stageWebView.stage = null;
		}
		this.removeEventListener(starling.events.Event.ENTER_FRAME, webView_enterFrameHandler);
	}

	/**
	 * @private
	 */
	private function webView_enterFrameHandler(event:starling.events.Event):Void
	{
		var target:DisplayObject = this;
		do
		{
			if(!target.hasVisibleArea)
			{
				this.stageWebView.stage = null;
				return;
			}
			target = target.parent;
		}
		while(target != null);
		this.stageWebView.stage = Starling.current.nativeStage;
	}

	/**
	 * @private
	 */
	private function stageWebView_errorHandler(event:ErrorEvent):Void
	{
		this.dispatchEventWith(FeathersEventType.ERROR, false, event);
	}

	/**
	 * @private
	 */
	private function stageWebView_locationChangeHandler(event:flash.events.Event):Void
	{
		this.dispatchEventWith(FeathersEventType.LOCATION_CHANGE);
	}
	
	private function stageWebView_completeHandler(event:flash.events.Event):Void
	{
		this.dispatchEventWith(starling.events.Event.COMPLETE);
	}
}
