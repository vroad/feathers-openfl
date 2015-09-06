package feathers.motion;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;

class ColorFadeTween extends Tween
{
	public function new(target:DisplayObject, otherTarget:DisplayObject,
		color:UInt, duration:Float, ease:Dynamic, onCompleteCallback:Dynamic,
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
			target.visible = false;
		}
		this.onUpdate = this.updateOverlay;
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;

		var navigator:DisplayObjectContainer = target.parent;
		this._overlay = new Quad(navigator.width, navigator.height, color);
		this._overlay.alpha = 0;
		this._overlay.touchable = false;
		navigator.addChild(this._overlay);

		Starling.current.juggler.add(this);
	}

	private var _otherTarget:DisplayObject;
	private var _overlay:Quad;
	private var _onCompleteCallback:Dynamic;

	private function updateOverlay():Void
	{
		var progress:Float = this.progress;
		if(progress < 0.5)
		{
			this._overlay.alpha = progress * 2;
		}
		else
		{
			target.visible = true;
			if(this._otherTarget != null)
			{
				this._otherTarget.visible = false;
			}
			this._overlay.alpha = (1 - progress) * 2;
		}
	}

	private function cleanupTween():Void
	{
		this._overlay.removeFromParent(true);
		this.target.visible = true;
		if(this._otherTarget != null)
		{
			this._otherTarget.visible = true;
		}
		if(this._onCompleteCallback != null)
		{
			this._onCompleteCallback();
		}
	}
}