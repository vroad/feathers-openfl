package feathers.motion;

import feathers.display.RenderDelegate;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite3D;

class FlipTween extends Tween
{
	public function new(newScreen:DisplayObject, oldScreen:DisplayObject,
		rotationYOffset:Float, rotationXOffset:Float,
		duration:Float, ease:String, onCompleteCallback:Dynamic,
		tweenProperties:Dynamic)
	{

		var newScreenParent:Sprite3D = null;
		var targetParent:Sprite3D = null;
		var delegate:RenderDelegate;
		if(newScreen != null)
		{
			this._navigator = newScreen.parent;
			newScreenParent = new Sprite3D();
			delegate = new RenderDelegate(newScreen);
			delegate.alpha = newScreen.alpha;
			delegate.blendMode = newScreen.blendMode;
			delegate.rotation = newScreen.rotation;
			delegate.scaleX = newScreen.scaleX;
			delegate.scaleY = newScreen.scaleY;
			if(rotationYOffset != 0)
			{
				delegate.x = -newScreen.width / 2;
				newScreenParent.x = newScreen.width / 2;
				newScreenParent.rotationY = -rotationYOffset;
			}
			if(rotationXOffset != 0)
			{
				delegate.y = -newScreen.height / 2;
				newScreenParent.y = newScreen.height / 2;
				newScreenParent.rotationX = -rotationXOffset;
			}
			this._navigator.addChild(newScreenParent);
			newScreenParent.addChild(delegate);
			newScreen.visible = false;
			this._savedNewScreen = newScreen;
			targetParent = newScreenParent;
		}
		if(oldScreen != null)
		{
			var oldScreenParent:Sprite3D = new Sprite3D();
			delegate = new RenderDelegate(oldScreen);
			delegate.alpha = oldScreen.alpha;
			delegate.blendMode = oldScreen.blendMode;
			delegate.rotation = oldScreen.rotation;
			delegate.scaleX = oldScreen.scaleX;
			delegate.scaleY = oldScreen.scaleY;
			if(rotationYOffset != 0)
			{
				delegate.x = -oldScreen.width / 2;
				oldScreenParent.x = oldScreen.width / 2;
			}
			if(rotationXOffset != 0)
			{
				delegate.y = -oldScreen.height / 2;
				oldScreenParent.y = oldScreen.height / 2;
			}
			oldScreenParent.rotationY = 0;
			oldScreenParent.rotationX = 0;
			if(targetParent == null)
			{
				this._navigator = oldScreen.parent;
				duration = duration / 2;
				targetParent = oldScreenParent;
			}
			else
			{
				newScreenParent.visible = false;
				this._otherTarget = oldScreenParent;
			}
			this._navigator.addChild(oldScreenParent);
			oldScreenParent.addChild(delegate);
			oldScreen.visible = false;
			this._savedOldScreen = oldScreen;
		}
		else
		{
			newScreenParent.rotationY /= 2;
			newScreenParent.rotationX /= 2;
			duration = duration / 2;
		}

		super(targetParent, duration, ease);

		if(newScreenParent != null)
		{
			if(rotationYOffset != 0)
			{
				this.animate("rotationY", 0);
			}
			if(rotationXOffset != 0)
			{
				this.animate("rotationX", 0);
			}
		}
		else //we only have the old screen
		{
			if(rotationYOffset != 0)
			{
				this.animate("rotationY", rotationYOffset / 2);
			}
			if(rotationXOffset != 0)
			{
				this.animate("rotationX", rotationXOffset / 2);
			}
		}
		this._rotationYOffset = rotationYOffset;
		this._rotationXOffset = rotationXOffset;
		if(tweenProperties != null)
		{
			for(propertyName in Reflect.fields(tweenProperties))
			{
				Reflect.setProperty(this, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}

		if(this._otherTarget != null)
		{
			this.onUpdate = this.updateOtherTarget;
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		Starling.current.juggler.add(this);
	}

	private var _navigator:DisplayObjectContainer;
	private var _otherTarget:Sprite3D;
	private var _onCompleteCallback:Dynamic;
	private var _rotationYOffset:Float = 0;
	private var _rotationXOffset:Float = 0;
	private var _savedNewScreen:DisplayObject;
	private var _savedOldScreen:DisplayObject;

	private function updateOtherTarget():Void
	{
		var targetParent:Sprite3D = cast(this.target, Sprite3D);
		if(this.progress >= 0.5 && this._otherTarget.visible)
		{
			targetParent.visible = true;
			this._otherTarget.visible = false;
		}
		if(this._rotationYOffset < 0)
		{
			this._otherTarget.rotationY = targetParent.rotationY + Math.PI;
		}
		else if(this._rotationYOffset > 0)
		{
			this._otherTarget.rotationY = targetParent.rotationY - Math.PI;
		}
		if(this._rotationXOffset < 0)
		{
			this._otherTarget.rotationX = targetParent.rotationX + Math.PI;
		}
		else if(this._rotationXOffset > 0)
		{
			this._otherTarget.rotationX = targetParent.rotationX - Math.PI;
		}
	}

	private function cleanupTween():Void
	{
		var targetParent:Sprite3D = cast(this.target, Sprite3D);
		targetParent.removeFromParent(true);
		if(this._otherTarget != null)
		{
			this._otherTarget.removeFromParent(true);
		}
		if(this._savedNewScreen != null)
		{
			this._savedNewScreen.visible = true;
			this._savedNewScreen = null;
		}
		if(this._savedOldScreen != null)
		{
			this._savedOldScreen.visible = true;
			this._savedOldScreen = null;
		}
		if(this._onCompleteCallback != null)
		{
			this._onCompleteCallback();
		}
	}
}