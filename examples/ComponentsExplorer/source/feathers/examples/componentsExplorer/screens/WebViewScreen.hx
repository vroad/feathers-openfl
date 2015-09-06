package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.LayoutGroup;
import feathers.controls.PanelScreen;
import feathers.controls.TextInput;
import feathers.controls.WebView;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.HorizontalLayoutData;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;

#if 0
[Event(name="complete",type="starling.events.Event")]
#end

class WebViewScreen extends PanelScreen
{
	public function new()
	{
		super();
	}

	private var _browser:WebView;
	private var _locationInput:TextInput;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "Web View";

		this.layout = new AnchorLayout();

		var items:Array<Dynamic> = [];
		//for(var i:Int = 0; i < 150; i++)
		for(i in 0 ... 150)
		{
			var item:Dynamic = {text: "Item " + (i + 1)};
			items[i] = item;
		}
		//items.fixed = true;

		this._browser = new WebView();
		this._browser.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._browser.addEventListener("locationChange", webView_locationChangeHandler);
		this.addChild(this._browser);

		this.headerFactory = this.customHeaderFactory;
		this.footerFactory = this.customFooterFactory;

		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this.backButtonHandler = this.onBackButton;
		}
	}

	private function customHeaderFactory():Header
	{
		var header:Header = new Header();
		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			var backButton:Button = new Button();
			backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
			backButton.label = "Back";
			backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			header.leftItems = 
			[
				backButton
			];
		}
		return header;
	}

	private function customFooterFactory():LayoutGroup
	{
		var footer:LayoutGroup = new LayoutGroup();
		footer.styleNameList.add(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR);
		
		this._locationInput = new TextInput();
		this._locationInput.prompt = "Enter a website address";
		this._locationInput.layoutData = new HorizontalLayoutData(100);
		this._locationInput.addEventListener(FeathersEventType.ENTER, locationInput_enterHandler);
		footer.addChild(this._locationInput);
		
		var goButton:Button = new Button();
		goButton.label = "Go";
		goButton.addEventListener(Event.TRIGGERED, goButton_triggeredHandler);
		footer.addChild(goButton);
		
		return footer;
	}
	
	private function loadLocation():Void
	{
		if(this._locationInput.text.length == 0)
		{
			return;
		}
		this._locationInput.clearFocus();
		var url:String = this._locationInput.text;
		//make sure that there's a protocol. otherwise, AIR will add app:/,
		//which probably isn't what you want.
		if(!(~/^\w+:\//).match(url))
		{
			url = "http://" + url;
		}
		url = StringTools.urlEncode(url);
		this._browser.loadURL(url);
	}

	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}
	
	private function webView_locationChangeHandler(event:Event):Void
	{
		#if flash
		this._locationInput.text = this._browser.location;
		#end
	}
	
	private function locationInput_enterHandler(event:Event):Void
	{
		this.loadLocation();
	}
	
	private function goButton_triggeredHandler(event:Event):Void
	{
		this.loadLocation();
	}
	
	
}
