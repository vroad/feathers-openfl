package feathers.examples.transitionsExplorer.screens
{
import feathers.controls.Screen;

import starling.display.Quad;

class ContentScreen extends Screen
{
	public function ContentScreen()
	{
	}

	public var color:uint;

	override private function initialize():Void
	{
		this.backgroundSkin = new Quad(1, 1, this.color);
	}

}
}
