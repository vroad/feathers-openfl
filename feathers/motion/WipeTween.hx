package feathers.motion;

import feathers.display.RenderDelegate;

import flash.geom.Rectangle;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;

class WipeTween extends Tween
{
	public function new(newScreen:DisplayObject, oldScreen:DisplayObject,
		xOffset:Float, yOffset:Float, duration:Float, ease:String, onCompleteCallback:Dynamic,
		tweenProperties:Dynamic)
	{
		var clipRect:Rectangle = null;
		var delegate:RenderDelegate;
		if(newScreen != null)
		{
			this._temporaryNewScreenParent = new Sprite();
			clipRect = new Rectangle();
			if(xOffset != 0)
			{
				if(xOffset < 0)
				{
					clipRect.x = newScreen.width;
				}
				clipRect.height = newScreen.height;
			}
			if(yOffset != 0)
			{
				if(yOffset < 0)
				{
					clipRect.y = newScreen.height;
				}
				clipRect.width = newScreen.width;
			}
			this._temporaryNewScreenParent.clipRect = clipRect;
			newScreen.parent.addChild(this._temporaryNewScreenParent);
			delegate = new RenderDelegate(newScreen);
			delegate.alpha = newScreen.alpha;
			delegate.blendMode = newScreen.blendMode;
			delegate.rotation = newScreen.rotation;
			delegate.scaleX = newScreen.scaleX;
			delegate.scaleY = newScreen.scaleY;
			this._temporaryNewScreenParent.addChild(delegate);
			newScreen.visible = false;
			this._savedNewScreen = newScreen;
			//the clipRect setter may have made a clone
			clipRect = this._temporaryNewScreenParent.clipRect;
		}
		if(oldScreen != null)
		{
			this._temporaryOldScreenParent = new Sprite();
			this._temporaryOldScreenParent.clipRect = new Rectangle(0, 0, oldScreen.width, oldScreen.height);
			delegate = new RenderDelegate(oldScreen);
			delegate.alpha = oldScreen.alpha;
			delegate.blendMode = oldScreen.blendMode;
			delegate.rotation = oldScreen.rotation;
			delegate.scaleX = oldScreen.scaleX;
			delegate.scaleY = oldScreen.scaleY;
			this._temporaryOldScreenParent.addChild(delegate);
			clipRect = this._temporaryOldScreenParent.clipRect;
			oldScreen.parent.addChild(this._temporaryOldScreenParent);
			oldScreen.visible = false;
			this._savedOldScreen = oldScreen;
		}

		super(clipRect, duration, ease);
		
		if(oldScreen != null)
		{
			if(xOffset < 0)
			{
				this.animate("width", oldScreen.width + xOffset);
			}
			else if(xOffset > 0)
			{
				this.animate("x", xOffset);
				this.animate("width", oldScreen.width - xOffset);
			}
			if(yOffset < 0)
			{
				this.animate("height", oldScreen.height + yOffset);
			}
			else if(yOffset > 0)
			{
				this.animate("y", yOffset);
				this.animate("height", oldScreen.height - yOffset);
			}
			if(this._temporaryNewScreenParent != null)
			{
				this.onUpdate = this.updateNewScreen;
			}
		}
		else //new screen only
		{
			if(xOffset < 0)
			{
				this.animate("x", newScreen.width + xOffset);
				this.animate("width", -xOffset);
			}
			else if(xOffset > 0)
			{
				this.animate("width", xOffset);
			}
			if(yOffset < 0)
			{
				this.animate("y", newScreen.height + yOffset);
				this.animate("height", -yOffset);
			}
			else if(yOffset > 0)
			{
				this.animate("height", yOffset);
			}
		}
		if(tweenProperties != null)
		{
			for(propertyName in Reflect.fields(tweenProperties))
			{
				Reflect.setProperty(this, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}
		this._savedXOffset = xOffset;
		this._savedYOffset = yOffset;
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		Starling.current.juggler.add(this);
	}

	private var _temporaryOldScreenParent:Sprite;
	private var _temporaryNewScreenParent:Sprite;
	private var _savedOldScreen:DisplayObject;
	private var _savedNewScreen:DisplayObject;
	private var _savedXOffset:Float;
	private var _savedYOffset:Float;
	private var _onCompleteCallback:Dynamic;

	private function updateNewScreen():Void
	{
		var oldScreenClipRect:Rectangle = cast(this.target, Rectangle);
		var newScreenClipRect:Rectangle = this._temporaryNewScreenParent.clipRect;
		if(this._savedXOffset < 0)
		{
			newScreenClipRect.x = oldScreenClipRect.width;
			newScreenClipRect.width = this._savedNewScreen.width - newScreenClipRect.x;
		}
		else if(this._savedXOffset > 0)
		{
			newScreenClipRect.width = oldScreenClipRect.x;
		}
		if(this._savedYOffset < 0)
		{
			newScreenClipRect.y = oldScreenClipRect.height;
			newScreenClipRect.height = this._savedNewScreen.height - newScreenClipRect.y;
		}
		else if(this._savedYOffset > 0)
		{
			newScreenClipRect.height = oldScreenClipRect.y;
		}
	}

	private function cleanupTween():Void
	{
		if(this._temporaryOldScreenParent != null)
		{
			this._temporaryOldScreenParent.removeFromParent(true);
			this._temporaryOldScreenParent = null;
		}
		if(this._temporaryNewScreenParent != null)
		{
			this._temporaryNewScreenParent.removeFromParent(true);
			this._temporaryNewScreenParent = null;
		}
		if(this._savedOldScreen != null)
		{
			this._savedOldScreen.visible = true;
			this._savedOldScreen = null;
		}
		if(this._savedNewScreen != null)
		{
			this._savedNewScreen.visible = true;
			this._savedNewScreen = null;
		}
		if(this._onCompleteCallback != null)
		{
			this._onCompleteCallback();
		}
	}

}