package feathers.motion;

import feathers.display.RenderDelegate;

import flash.geom.Rectangle;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;

class RevealTween extends Tween
{
	public function new(oldScreen:DisplayObject, newScreen:DisplayObject,
		xOffset:Float, yOffset:Float, duration:Float, ease:String, onCompleteCallback:Dynamic,
		tweenProperties:Dynamic)
	{
		var clipRect:Rectangle = new Rectangle();
		if(xOffset == 0)
		{
			clipRect.width = newScreen.width;
		}
		else if(xOffset < 0)
		{
			clipRect.x = -xOffset;
		}
		if(yOffset == 0)
		{
			clipRect.height = newScreen.height;
		}
		else if(yOffset < 0)
		{
			clipRect.y = -yOffset;
		}
		this._temporaryParent = new Sprite();
		this._temporaryParent.clipRect = clipRect;
		newScreen.parent.addChild(this._temporaryParent);
		var delegate:RenderDelegate = new RenderDelegate(newScreen);
		delegate.alpha = newScreen.alpha;
		delegate.blendMode = newScreen.blendMode;
		delegate.rotation = newScreen.rotation;
		delegate.scaleX = newScreen.scaleX;
		delegate.scaleY = newScreen.scaleY;
		this._temporaryParent.addChild(delegate);
		newScreen.visible = false;
		this._savedNewScreen = newScreen;

		super(this._temporaryParent.clipRect, duration, ease);

		if(xOffset < 0)
		{
			this.animate("x", clipRect.x + xOffset);
			this.animate("width", -xOffset);
		}
		else if(xOffset > 0)
		{
			this.animate("width", xOffset);
		}
		if(yOffset < 0)
		{
			this.animate("y", clipRect.y + yOffset);
			this.animate("height", -yOffset);
		}
		else if(yOffset > 0)
		{
			this.animate("height", yOffset);
		}

		if(tweenProperties)
		{
			for(propertyName in Reflect.fields(tweenProperties))
			{
				Reflect.setProperty(this, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}
		this._onCompleteCallback = onCompleteCallback;
		if(oldScreen != null)
		{
			this._savedOldScreen = oldScreen;
			this._savedXOffset = xOffset;
			this._savedYOffset = yOffset;
			this.onUpdate = this.updateOldScreen;
		}
		this.onComplete = this.cleanupTween;
		Starling.current.juggler.add(this);
	}

	private var _savedXOffset:Float;
	private var _savedYOffset:Float;
	private var _savedNewScreen:DisplayObject;
	private var _savedOldScreen:DisplayObject;
	private var _temporaryParent:Sprite;
	private var _onCompleteCallback:Dynamic;

	private function updateOldScreen():Void
	{
		var clipRect:Rectangle = this._temporaryParent.clipRect;
		if(this._savedXOffset < 0)
		{
			this._savedOldScreen.x = -clipRect.width;
		}
		else if(this._savedXOffset > 0)
		{
			this._savedOldScreen.x = clipRect.width;
		}
		if(this._savedYOffset < 0)
		{
			this._savedOldScreen.y = -clipRect.height;
		}
		else if(this._savedYOffset > 0)
		{
			this._savedOldScreen.y = clipRect.height;
		}
	}

	private function cleanupTween():Void
	{
		this._temporaryParent.removeFromParent(true);
		this._temporaryParent = null;
		this._savedNewScreen.visible = true;
		this._savedNewScreen = null;
		if(this._savedOldScreen != null)
		{
			this._savedOldScreen.x = 0;
			this._savedOldScreen.y = 0;
			this._savedOldScreen = null;
		}
		if(this._onCompleteCallback != null)
		{
			this._onCompleteCallback();
		}
	}

}