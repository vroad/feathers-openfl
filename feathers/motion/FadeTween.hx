package feathers.motion;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

class FadeTween extends Tween
{
	public function new(target:DisplayObject, otherTarget:DisplayObject,
		duration:Float, ease:String, onCompleteCallback:Dynamic,
		tweenProperties:Dynamic)
	{
		super(target, duration, ease);
		if(target.alpha == 0)
		{
			this.fadeTo(1);
		}
		else
		{
			this.fadeTo(0);
		}
		if(tweenProperties != null)
		{
			for(propertyName in Reflect.fields(tweenProperties))
			{
				Reflect.setProperty(this, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}
		if(otherTarget != null)
		{
			this._otherTarget = otherTarget;
			this.onUpdate = this.updateOtherTarget;
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		Starling.current.juggler.add(this);
	}

	private var _otherTarget:DisplayObject;
	private var _onCompleteCallback:Dynamic;

	private function updateOtherTarget():Void
	{
		var newScreen:DisplayObject = cast(this.target, DisplayObject);
		this._otherTarget.alpha = 1 - newScreen.alpha;
	}

	private function cleanupTween():Void
	{
		this.target.alpha = 1;
		if(this._otherTarget != null)
		{
			this._otherTarget.alpha = 1;
		}
		if(this._onCompleteCallback != null)
		{
			this._onCompleteCallback();
		}
	}
}