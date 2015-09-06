package feathers.motion;

import feathers.display.RenderDelegate;

import flash.geom.Rectangle;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;

class CoverTween extends Tween
{
	public function new(newScreen:DisplayObject, oldScreen:DisplayObject,
		xOffset:Float, yOffset:Float, duration:Float, ease:String, onCompleteCallback:Dynamic,
		tweenProperties:Dynamic)
	{
		var clipRect:Rectangle = new Rectangle(0, 0, oldScreen.width, oldScreen.height);
		this._temporaryParent = new Sprite();
		this._temporaryParent.clipRect = clipRect;
		oldScreen.parent.addChild(this._temporaryParent);
		var delegate:RenderDelegate = new RenderDelegate(oldScreen);
		delegate.alpha = oldScreen.alpha;
		delegate.blendMode = oldScreen.blendMode;
		delegate.rotation = oldScreen.rotation;
		delegate.scaleX = oldScreen.scaleX;
		delegate.scaleY = oldScreen.scaleY;
		this._temporaryParent.addChild(delegate);
		oldScreen.visible = false;
		this._savedOldScreen = oldScreen;

		super(this._temporaryParent.clipRect, duration, ease);

		if(xOffset < 0)
		{
			this.animate("width", 0);
		}
		else if(xOffset > 0)
		{
			this.animate("x", xOffset);
			this.animate("width", 0);
		}
		if(yOffset < 0)
		{
			this.animate("height", 0);
		}
		else if(yOffset > 0)
		{
			this.animate("y", yOffset);
			this.animate("height", 0);
		}
		if(tweenProperties)
		{
			for(propertyName in Reflect.fields(tweenProperties))
			{
				Reflect.setProperty(this, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}
		this._onCompleteCallback = onCompleteCallback;
		if(newScreen != null)
		{
			this._savedNewScreen = newScreen;
			this._savedXOffset = xOffset;
			this._savedYOffset = yOffset;
			this.onUpdate = this.updateNewScreen;
		}
		this.onComplete = this.cleanupTween;
		Starling.current.juggler.add(this);
	}

	private var _savedXOffset:Float;
	private var _savedYOffset:Float;
	private var _savedOldScreen:DisplayObject;
	private var _savedNewScreen:DisplayObject;
	private var _temporaryParent:Sprite;
	private var _onCompleteCallback:Dynamic;

	private function updateNewScreen():Void
	{
		var clipRect:Rectangle = this._temporaryParent.clipRect;
		if(this._savedXOffset < 0)
		{
			this._savedNewScreen.x = clipRect.width;
		}
		else if(this._savedXOffset > 0)
		{
			this._savedNewScreen.x = -clipRect.width;
		}
		if(this._savedYOffset < 0)
		{
			this._savedNewScreen.y = clipRect.height;
		}
		else if(this._savedYOffset > 0)
		{
			this._savedNewScreen.y = -clipRect.height;
		}
	}

	private function cleanupTween():Void
	{
		this._temporaryParent.removeFromParent(true);
		this._temporaryParent = null;
		this._savedOldScreen.visible = true;
		this._savedNewScreen = null;
		this._savedOldScreen = null;
		if(this._onCompleteCallback != null)
		{
			this._onCompleteCallback();
		}
	}
}