package feathers.examples.trainTimes.screens;
import feathers.controls.Button;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.data.ListCollection;
import feathers.examples.trainTimes.model.TimeData;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import starling.display.DisplayObject;
import starling.events.Event;

[Event(name="complete",type="starling.events.Event")]

class TimesScreen extends PanelScreen
{
	inline public static var CHILD_NAME_TIMES_LIST:String = "timesList";

	inline private static var NORTH_TIMES:Vector.<TimeData> = new <TimeData>
	[
		new TimeData(281, new Date(2013, 2, 6, 13, 5), new Date(2013, 2, 6, 13, 19)),
		new TimeData(281, new Date(2013, 2, 6, 14, 5), new Date(2013, 2, 6, 14, 19)),
		new TimeData(281, new Date(2013, 2, 6, 15, 5), new Date(2013, 2, 6, 15, 19)),
		new TimeData(281, new Date(2013, 2, 6, 16, 5), new Date(2013, 2, 6, 16, 19)),
		new TimeData(281, new Date(2013, 2, 6, 17, 5), new Date(2013, 2, 6, 17, 21)),
		new TimeData(281, new Date(2013, 2, 6, 17, 35), new Date(2013, 2, 6, 17, 51)),
		new TimeData(281, new Date(2013, 2, 6, 18, 5), new Date(2013, 2, 6, 18, 21)),
		new TimeData(281, new Date(2013, 2, 6, 18, 35), new Date(2013, 2, 6, 18, 51)),
		new TimeData(281, new Date(2013, 2, 6, 19, 5), new Date(2013, 2, 6, 19, 21)),
		new TimeData(281, new Date(2013, 2, 6, 20, 1), new Date(2013, 2, 6, 20, 12)),
		new TimeData(281, new Date(2013, 2, 6, 20, 41), new Date(2013, 2, 6, 20, 52)),
		new TimeData(281, new Date(2013, 2, 6, 21, 41), new Date(2013, 2, 6, 21, 52)),
		new TimeData(281, new Date(2013, 2, 6, 22, 41), new Date(2013, 2, 6, 22, 52)),
		new TimeData(281, new Date(2013, 2, 6, 23, 41), new Date(2013, 2, 6, 23, 52)),
	];

	public function TimesScreen()
	{
		super();
	}

	private var _backButton:Button;
	private var _list:List;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.styleNameList.add(CHILD_NAME_TIMES_LIST);
		this._list.dataProvider = new ListCollection(NORTH_TIMES);
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.itemRendererProperties.labelFunction = list_labelFunction;
		this.addChild(this._list);

		this._backButton = new Button();
		this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		this.headerProperties.title = "Schedule";
		this.headerProperties.leftItems = new <DisplayObject>
		[
			this._backButton
		];

		this.backButtonHandler = this.onBackButton;
	}

	private function list_labelFunction(item:TimeData):String
	{
		var departureTime:Date = item.departureTime;
		var arrivalTime:Date = item.arrivalTime;
		var duration:Int = (arrivalTime.getTime() - departureTime.getTime()) / 1000 / 60;
		return this.formatTimeAsString(departureTime) + "\t" + this.formatTimeAsString(arrivalTime) + "\t" +
			item.trainNumber + "\t" + duration + "mins";
	}

	private function formatTimeAsString(time:Date):String
	{
		var hours:Float = time.hours;
		var isAM:Bool = hours < 12;
		var hoursAsString:String = ((isAM ? hours : (hours - 12)) + 1).toString();
		var minutes:Float = time.minutes;
		var minutesAsString:String = minutes < 10 ? "0" + minutes : minutes.toString();
		return hoursAsString + ":" + minutesAsString + (isAM ? "am" : "pm");
	}

	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}
}
