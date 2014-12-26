package feathers.examples.youtube;
import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.examples.youtube.models.VideoDetails;
import feathers.examples.youtube.models.VideoFeed;
import feathers.examples.youtube.models.YouTubeModel;
import feathers.examples.youtube.screens.ListVideosScreen;
import feathers.examples.youtube.screens.MainMenuScreen;
import feathers.examples.youtube.screens.VideoDetailsScreen;
import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
import feathers.themes.MetalWorksMobileTheme;

import starling.events.Event;

class Main extends ScreenNavigator
{
	inline private static var MAIN_MENU:String = "mainMenu";
	inline private static var LIST_VIDEOS:String = "listVideos";
	inline private static var VIDEO_DETAILS:String = "videoDetails";

	public function Main()
	{
		super();
	}

	private var _transitionManager:ScreenSlidingStackTransitionManager;
	private var _model:YouTubeModel;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		new MetalWorksMobileTheme();

		this._model = new YouTubeModel();

		this.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen,
		{
			listVideos: mainMenuScreen_listVideosHandler
		}));

		this.addScreen(LIST_VIDEOS, new ScreenNavigatorItem(ListVideosScreen,
		{
			complete: MAIN_MENU,
			showVideoDetails: listVideos_showVideoDetails
		},
		{
			model: this._model
		}));

		this.addScreen(VIDEO_DETAILS, new ScreenNavigatorItem(VideoDetailsScreen,
		{
			complete: LIST_VIDEOS
		},
		{
			model: this._model
		}));

		this.showScreen(MAIN_MENU);

		this._transitionManager = new ScreenSlidingStackTransitionManager(this);
		this._transitionManager.duration = 0.4;
	}

	private function mainMenuScreen_listVideosHandler(event:Event, selectedItem:VideoFeed):Void
	{
		this._model.selectedList = selectedItem;
		this.showScreen(LIST_VIDEOS);
	}

	private function listVideos_showVideoDetails(event:Event, selectedItem:VideoDetails):Void
	{
		this._model.selectedVideo = selectedItem;
		this.showScreen(VIDEO_DETAILS);
	}
}
