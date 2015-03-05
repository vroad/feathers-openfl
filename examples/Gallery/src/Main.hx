package;

import lime.app.Application;
import lime.graphics.opengl.GL;
import lime.graphics.RenderContext;

/**
 * ...
 * @author vroad
 */

class Main extends Application 
{

	public function new() 
	{
		super();
	}
	
	public override function init(context:RenderContext):Void 
	{
		switch (context) 
		{
			case OPENGL(gl):
			
			default:
		}
	}
	
	public override function render(context:RenderContext):Void 
	{
		switch (context) 
		{
			case OPENGL(gl):
				gl.viewport(0, 0, window.width, window.height);
				gl.clearColor(1.0, 1.0, 1.0, 1.0);
				gl.clear(gl.COLOR_BUFFER_BIT);
				
			default:
		}
	}
	
}
