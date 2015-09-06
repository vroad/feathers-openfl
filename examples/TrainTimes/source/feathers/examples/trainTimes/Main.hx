package feathers.examples.trainTimes;

import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.examples.trainTimes.screens.StationScreen;
import feathers.examples.trainTimes.screens.TimesScreen;
import feathers.examples.trainTimes.themes.TrainTimesTheme;
import feathers.motion.Slide;

import starling.events.Event;

class Main extends StackScreenNavigator
{
	inline private static var STATION_SCREEN:String = "stationScreen";
	inline private static var TIMES_SCREEN:String = "timesScreen";

	@:keep public function new()
	{
		super();
	}

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		new TrainTimesTheme();

		var stationScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(StationScreen);
		stationScreenItem.setScreenIDForPushEvent(Event.COMPLETE, TIMES_SCREEN);
		this.addScreen(STATION_SCREEN, stationScreenItem);

		var timesScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TimesScreen);
		timesScreenItem.addPopEvent(Event.COMPLETE);
		this.addScreen(TIMES_SCREEN, timesScreenItem);

		this.rootScreenID = STATION_SCREEN;

		this.pushTransition = Slide.createSlideLeftTransition();
		this.popTransition = Slide.createSlideRightTransition();
	}
}
