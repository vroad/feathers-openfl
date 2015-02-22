package feathers.examples.youtube.screens;
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.controls.ScrollText;
import feathers.events.FeathersEventType;
import feathers.examples.youtube.models.YouTubeModel;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import openfl.net.URLRequest;
import openfl.net.navigateToURL;

import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]

class VideoDetailsScreen extends PanelScreen
{
	public function new()
	{
		super();
	}

	private var _backButton:Button;
	private var _watchButton:Button;
	private var _scrollText:ScrollText;

	private var _model:YouTubeModel;

	public var model(get, set):YouTubeModel;
	public function get_model():YouTubeModel
	{
		return this._model;
	}

	public function set_model(value:YouTubeModel):YouTubeModel
	{
		if(this._model == value)
		{
			return;
		}
		this._model = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.layout = new AnchorLayout();

		this._scrollText = new ScrollText();
		this._scrollText.isHTML = true;
		this._scrollText.verticalScrollPolicy = ScrollText.SCROLL_POLICY_ON;
		this._scrollText.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this.addChild(this._scrollText);

		this._backButton = new Button();
		this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
		this._backButton.label = "Back";
		this._backButton.addEventListener(Event.TRIGGERED, onBackButton);
		this.headerProperties.leftItems = new <DisplayObject>
		[
			this._backButton
		];

		this._watchButton = new Button();
		this._watchButton.label = "Watch";
		this._watchButton.addEventListener(Event.TRIGGERED, watchButton_triggeredHandler);
		this.headerProperties.rightItems = new <DisplayObject>
		[
			this._watchButton
		];

		this.backButtonHandler = onBackButton;

		this.owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);
	}

	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		if(dataInvalid)
		{
			if(this._model && this._model.selectedVideo)
			{
				this.headerProperties.title = this._model.selectedVideo.title;
				var content:String = '<p><b><font size="+2">' + this._model.selectedVideo.title + '</font></b></p>';
				content += '<p><font size="-2" color="#999999">' + this._model.selectedVideo.author + '</font></p><br>';
				content += this._model.selectedVideo.description.replace(/\r\n/g, "<br>");
				this._scrollText.text = content;
			}
			else
			{
				this.headerProperties.title = null;
				this._scrollText.text = "";
			}
		}

		//never forget to call super.draw()!
		super.draw();
	}

	private function onBackButton(event:Event = null):Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function watchButton_triggeredHandler(event:Event):Void
	{
		navigateToURL(new URLRequest(this._model.selectedVideo.url), "_blank");
	}

	private function owner_transitionCompleteHandler(event:Event):Void
	{
		this.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);
		this.revealScrollBars();
	}
}
