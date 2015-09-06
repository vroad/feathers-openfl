package feathers.motion;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

class SlideTween extends Tween
{
	public function new(target:DisplayObject, otherTarget:DisplayObject,
		xOffset:Float, yOffset:Float, duration:Float, ease:String,
		onCompleteCallback:Dynamic, tweenProperties:Dynamic)
	{
		super(target, duration, ease);
		if(xOffset != 0)
		{
			this._xOffset = xOffset;
			this.animate("x", target.x + xOffset);
		}
		if(yOffset != 0)
		{
			this._yOffset = yOffset;
			this.animate("y", target.y + yOffset);
		}
		if(tweenProperties)
		{
			for(propertyName in Reflect.fields(tweenProperties))
			{
				Reflect.setProperty(this, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}
		this._navigator = target.parent;
		if(otherTarget != null)
		{
			this._otherTarget = otherTarget;
			this.onUpdate = this.updateOtherTarget;
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		Starling.current.juggler.add(this);
	}

	private var _navigator:DisplayObject;
	private var _otherTarget:DisplayObject;
	private var _onCompleteCallback:Dynamic;
	private var _xOffset:Float = 0;
	private var _yOffset:Float = 0;

	private function updateOtherTarget():Void
	{
		var newScreen:DisplayObject = cast(this.target, DisplayObject);
		if(this._xOffset < 0)
		{
			this._otherTarget.x = newScreen.x - this._navigator.width;
		}
		else if(this._xOffset > 0)
		{
			this._otherTarget.x = newScreen.x + newScreen.width;
		}
		if(this._yOffset < 0)
		{
			this._otherTarget.y = newScreen.y - this._navigator.height;
		}
		else if(this._yOffset > 0)
		{
			this._otherTarget.y = newScreen.y + newScreen.height;
		}
	}

	private function cleanupTween():Void
	{
		this.target.x = 0;
		this.target.y = 0;
		if(this._otherTarget != null)
		{
			this._otherTarget.x = 0;
			this._otherTarget.y = 0;
		}
		if(this._onCompleteCallback != null)
		{
			this._onCompleteCallback();
		}
	}
}