package feathers.motion;

import openfl.display3D.Context3DTriangleFace;
import starling.core.Starling;
import starling.core.RenderSupport;
import starling.display.Sprite3D;

class CulledSprite3D extends Sprite3D
{
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		Starling.current.context.setCulling(Context3DTriangleFace.BACK);
		super.render(support, parentAlpha);
		Starling.current.context.setCulling(Context3DTriangleFace.NONE);
	}
}