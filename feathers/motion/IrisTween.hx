package feathers.motion;

import feathers.display.RenderDelegate;

import flash.geom.Point;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Canvas;
import starling.display.DisplayObject;

class IrisTween extends Tween
{
	public function new(newScreen:DisplayObject, oldScreen:DisplayObject,
		originX:Float, originY:Float, openIris:Bool, duration:Float, ease:String,
		onCompleteCallback:Dynamic, tweenProperties:Dynamic)
	{
		var width:Float;
		var height:Float;
		if(newScreen != null)
		{
			width = newScreen.width;
			height = newScreen.height;
		}
		else
		{
			width = oldScreen.width;
			height = oldScreen.height;
		}
		var halfWidth:Float = width / 2;
		var halfHeight:Float = height / 2;
		var p1:Point = new Point(halfWidth, halfHeight);
		var p2:Point = new Point(originX, originY);
		var radiusFromCenter:Float = p1.length;
		var radius:Float;
		if(p1.equals(p2))
		{
			radius = radiusFromCenter;
		}
		else
		{
			var distanceFromCenterToOrigin:Float = Point.distance(p1, p2);
			radius = radiusFromCenter + distanceFromCenterToOrigin;
		}
		var maskTarget:Canvas = null;
		var mask:Canvas;
		if(newScreen != null && openIris)
		{
			this._newScreenDelegate = new RenderDelegate(newScreen);
			this._newScreenDelegate.alpha = newScreen.alpha;
			this._newScreenDelegate.blendMode = newScreen.blendMode;
			this._newScreenDelegate.rotation = newScreen.rotation;
			this._newScreenDelegate.scaleX = newScreen.scaleX;
			this._newScreenDelegate.scaleY = newScreen.scaleY;
			newScreen.parent.addChild(this._newScreenDelegate);
			newScreen.visible = false;
			this._savedNewScreen = newScreen;

			mask = new Canvas();
			mask.x = originX;
			mask.y = originY;
			mask.beginFill(0xff00ff);
			mask.drawCircle(0, 0, radius);
			mask.endFill();
			if(openIris)
			{
				mask.scaleX = 0;
				mask.scaleY = 0;
			}
			if(openIris)
			{
				this._newScreenDelegate.mask = mask;
			}
			newScreen.parent.addChild(mask);
			maskTarget = mask;
		}
		if(oldScreen != null && !openIris)
		{
			this._oldScreenDelegate = new RenderDelegate(oldScreen);
			this._oldScreenDelegate.alpha = oldScreen.alpha;
			this._oldScreenDelegate.blendMode = oldScreen.blendMode;
			this._oldScreenDelegate.rotation = oldScreen.rotation;
			this._oldScreenDelegate.scaleX = oldScreen.scaleX;
			this._oldScreenDelegate.scaleY = oldScreen.scaleY;
			oldScreen.parent.addChild(this._oldScreenDelegate);
			oldScreen.visible = false;
			this._savedOldScreen = oldScreen;

			mask = new Canvas();
			mask.x = originX;
			mask.y = originY;
			mask.beginFill(0xff00ff);
			mask.drawCircle(0, 0, radius);
			mask.endFill();
			if(!openIris)
			{
				this._oldScreenDelegate.mask = mask;
			}
			oldScreen.parent.addChild(mask);
			maskTarget = mask;
		}

		super(maskTarget, duration, ease);

		if(openIris)
		{
			this.animate("scaleX", 1);
			this.animate("scaleY", 1);
		}
		else
		{
			this.animate("scaleX", 0);
			this.animate("scaleY", 0);
		}

		if(tweenProperties != null)
		{
			for(propertyName in Reflect.fields(tweenProperties))
			{
				Reflect.setProperty(this, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}
		this._savedWidth = width;
		this._savedHeight = height;
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		Starling.current.juggler.add(this);
	}

	private var _newScreenDelegate:RenderDelegate;
	private var _oldScreenDelegate:RenderDelegate;
	private var _savedOldScreen:DisplayObject;
	private var _savedNewScreen:DisplayObject;
	private var _onCompleteCallback:Dynamic;
	private var _savedWidth:Float;
	private var _savedHeight:Float;

	private function cleanupTween():Void
	{
		if(this._newScreenDelegate != null)
		{
			this._newScreenDelegate.mask.removeFromParent(true);
			this._newScreenDelegate.removeFromParent(true);
			this._newScreenDelegate = null;
		}
		if(this._oldScreenDelegate != null)
		{
			this._oldScreenDelegate.mask.removeFromParent(true);
			this._oldScreenDelegate.removeFromParent(true);
			this._oldScreenDelegate = null;
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