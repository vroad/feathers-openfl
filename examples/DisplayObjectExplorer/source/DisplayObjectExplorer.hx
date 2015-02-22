package
{
import feathers.examples.displayObjects.Main;

import openfl.display.Loader;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageOrientation;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.filesystem.File;
import openfl.filesystem.FileMode;
import openfl.filesystem.FileStream;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.utils.ByteArray;

import starling.core.Starling;

//[SWF(width="640",height="960",frameRate="60",backgroundColor="#4a4137")]
class DisplayObjectExplorer extends Sprite
{
	public function DisplayObjectExplorer()
	{
		if(this.stage)
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
		}
		this.mouseEnabled = this.mouseChildren = false;
		this.showLaunchImage();
		this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
	}

	private var _starling:Starling;
	private var _launchImage:Loader;
	private var _savedAutoOrients:Bool;

	private function showLaunchImage():Void
	{
		var filePath:String;
		var isPortraitOnly:Bool = false;
		if(Capabilities.manufacturer.indexOf("iOS") >= 0)
		{
			if(Capabilities.screenResolutionX == 1536 && Capabilities.screenResolutionY == 2048)
			{
				var isCurrentlyPortrait:Bool = this.stage.orientation == StageOrientation.DEFAULT || this.stage.orientation == StageOrientation.UPSIDE_DOWN;
				filePath = isCurrentlyPortrait ? "Default-Portrait@2x.png" : "Default-Landscape@2x.png";
			}
			else if(Capabilities.screenResolutionX == 768 && Capabilities.screenResolutionY == 1024)
			{
				isCurrentlyPortrait = this.stage.orientation == StageOrientation.DEFAULT || this.stage.orientation == StageOrientation.UPSIDE_DOWN;
				filePath = isCurrentlyPortrait ? "Default-Portrait.png" : "Default-Landscape.png";
			}
			else if(Capabilities.screenResolutionX == 640)
			{
				isPortraitOnly = true;
				if(Capabilities.screenResolutionY == 1136)
				{
					filePath = "Default-568h@2x.png";
				}
				else
				{
					filePath = "Default@2x.png";
				}
			}
			else if(Capabilities.screenResolutionX == 320)
			{
				isPortraitOnly = true;
				filePath = "Default.png";
			}
		}

		if(filePath)
		{
			var file:File = File.applicationDirectory.resolvePath(filePath);
			if(file.exists)
			{
				var bytes:ByteArray = new ByteArray();
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				stream.readBytes(bytes, 0, stream.bytesAvailable);
				stream.close();
				this._launchImage = new Loader();
				this._launchImage.loadBytes(bytes);
				this.addChild(this._launchImage);
				this._savedAutoOrients = this.stage.autoOrients;
				this.stage.autoOrients = false;
				if(isPortraitOnly)
				{
					this.stage.setOrientation(StageOrientation.DEFAULT);
				}
			}
		}
	}

	private function loaderInfo_completeHandler(event:Event):Void
	{
		Starling.handleLostContext = true;
		Starling.multitouchEnabled = true;
		this._starling = new Starling(Main, this.stage);
		this._starling.enableErrorChecking = false;
		//this._starling.showStats = true;
		this._starling.start();
		if(this._launchImage)
		{
			this._starling.addEventListener("rootCreated", starling_rootCreatedHandler);
		}

		this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, Int.MAX_VALUE, true);
		this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
	}

	private function starling_rootCreatedHandler(event:Dynamic):Void
	{
		if(this._launchImage)
		{
			this.removeChild(this._launchImage);
			this._launchImage.unloadAndStop(true);
			this._launchImage = null;
			this.stage.autoOrients = this._savedAutoOrients;
		}
	}

	private function stage_resizeHandler(event:Event):Void
	{
		this._starling.stage.stageWidth = this.stage.stageWidth;
		this._starling.stage.stageHeight = this.stage.stageHeight;

		var viewPort:Rectangle = this._starling.viewPort;
		viewPort.width = this.stage.stageWidth;
		viewPort.height = this.stage.stageHeight;
		try
		{
			this._starling.viewPort = viewPort;
		}
		catch(error:Error) {}
	}

	private function stage_deactivateHandler(event:Event):Void
	{
		this._starling.stop();
		this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
	}

	private function stage_activateHandler(event:Event):Void
	{
		this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
		this._starling.start();
	}
}