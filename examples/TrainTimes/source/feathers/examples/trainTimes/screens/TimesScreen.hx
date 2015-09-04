package feathers.examples.trainTimes.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.data.ListCollection;
import feathers.examples.trainTimes.model.TimeData;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import starling.display.DisplayObject;
import starling.events.Event;

//[Event(name="complete",type="starling.events.Event")]

class TimesScreen extends PanelScreen
{
	inline public static var CHILD_STYLE_NAME_TIMES_LIST:String = "timesList";

	private static var NORTH_TIMES:Array<TimeData> =
	[
		new TimeData(281, createDate(2013, 2, 6, 13, 5), createDate(2013, 2, 6, 13, 19)),
		new TimeData(281, createDate(2013, 2, 6, 14, 5), createDate(2013, 2, 6, 14, 19)),
		new TimeData(281, createDate(2013, 2, 6, 15, 5), createDate(2013, 2, 6, 15, 19)),
		new TimeData(281, createDate(2013, 2, 6, 16, 5), createDate(2013, 2, 6, 16, 19)),
		new TimeData(281, createDate(2013, 2, 6, 17, 5), createDate(2013, 2, 6, 17, 21)),
		new TimeData(281, createDate(2013, 2, 6, 17, 35), createDate(2013, 2, 6, 17, 51)),
		new TimeData(281, createDate(2013, 2, 6, 18, 5), createDate(2013, 2, 6, 18, 21)),
		new TimeData(281, createDate(2013, 2, 6, 18, 35), createDate(2013, 2, 6, 18, 51)),
		new TimeData(281, createDate(2013, 2, 6, 19, 5), createDate(2013, 2, 6, 19, 21)),
		new TimeData(281, createDate(2013, 2, 6, 20, 1), createDate(2013, 2, 6, 20, 12)),
		new TimeData(281, createDate(2013, 2, 6, 20, 41), createDate(2013, 2, 6, 20, 52)),
		new TimeData(281, createDate(2013, 2, 6, 21, 41), createDate(2013, 2, 6, 21, 52)),
		new TimeData(281, createDate(2013, 2, 6, 22, 41), createDate(2013, 2, 6, 22, 52)),
		new TimeData(281, createDate(2013, 2, 6, 23, 41), createDate(2013, 2, 6, 23, 52)),
	];
	
	inline private static function createDate(year:Int, month:Int, day:Int, hour:Int, min:Int, sec:Int = 0)
	{
		return new Date(year, month, day, hour, min, sec);
	}

	public function new()
	{
		super();
	}

	private var _backButton:Button;
	private var _list:List;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.title = "Schedule";

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.styleNameList.add(CHILD_STYLE_NAME_TIMES_LIST);
		this._list.dataProvider = new ListCollection(NORTH_TIMES);
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.itemRendererProperties.setProperty("labelFunction", list_labelFunction);
		this.addChild(this._list);

		this.headerFactory = this.customHeaderFactory;

		this.backButtonHandler = this.onBackButton;
	}

	private function customHeaderFactory():Header
	{
		var header:Header = new Header();
		this._backButton = new Button();
		this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
		header.leftItems = new <DisplayObject>
		[
			this._backButton
		]);
		return header;
	}

	private function list_labelFunction(item:TimeData):String
	{
		var departureTime:Date = item.departureTime;
		var arrivalTime:Date = item.arrivalTime;
		var duration:Int = Std.int((arrivalTime.getTime() - departureTime.getTime()) / 1000 / 60);
		return this.formatTimeAsString(departureTime) + "\t" + this.formatTimeAsString(arrivalTime) + "\t" +
			item.trainNumber + "\t" + duration + "mins";
	}

	private function formatTimeAsString(time:Date):String
	{
		var hours:Float = time.getHours();
		var isAM:Bool = hours < 12;
		var hoursAsString:String = "" + ((isAM ? hours : (hours - 12)) + 1);
		var minutes:Float = time.getMinutes();
		var minutesAsString:String = minutes < 10 ? "0" + minutes : "" + minutes;
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
