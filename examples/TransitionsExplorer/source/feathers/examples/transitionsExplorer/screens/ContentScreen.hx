package feathers.examples.transitionsExplorer.screens
{
import feathers.controls.Screen;

import starling.display.Quad;

class ContentScreen extends Screen
{
	public function ContentScreen()
	{
	}

	public var color:UInt;

	override private function initialize():Void
	{
		this.backgroundSkin = new Quad(1, 1, this.color);
	}

}
}
