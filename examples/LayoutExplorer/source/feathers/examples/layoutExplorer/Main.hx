package feathers.examples.layoutExplorer;
import feathers.controls.Drawers;
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.examples.layoutExplorer.data.FlowLayoutSettings;
import feathers.examples.layoutExplorer.data.HorizontalLayoutSettings;
import feathers.examples.layoutExplorer.data.TiledColumnsLayoutSettings;
import feathers.examples.layoutExplorer.data.TiledRowsLayoutSettings;
import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
import feathers.examples.layoutExplorer.data.WaterfallLayoutSettings;
import feathers.examples.layoutExplorer.screens.AnchorLayoutScreen;
import feathers.examples.layoutExplorer.screens.FlowLayoutScreen;
import feathers.examples.layoutExplorer.screens.FlowLayoutSettingsScreen;
import feathers.examples.layoutExplorer.screens.HorizontalLayoutScreen;
import feathers.examples.layoutExplorer.screens.HorizontalLayoutSettingsScreen;
import feathers.examples.layoutExplorer.screens.MainMenuScreen;
import feathers.examples.layoutExplorer.screens.TiledColumnsLayoutScreen;
import feathers.examples.layoutExplorer.screens.TiledColumnsLayoutSettingsScreen;
import feathers.examples.layoutExplorer.screens.TiledRowsLayoutScreen;
import feathers.examples.layoutExplorer.screens.TiledRowsLayoutSettingsScreen;
import feathers.examples.layoutExplorer.screens.VerticalLayoutScreen;
import feathers.examples.layoutExplorer.screens.VerticalLayoutSettingsScreen;
import feathers.examples.layoutExplorer.screens.WaterfallLayoutScreen;
import feathers.examples.layoutExplorer.screens.WaterfallLayoutSettingsScreen;
import feathers.motion.Cover;
import feathers.motion.Reveal;
import feathers.motion.Slide;
import feathers.system.DeviceCapabilities;
import feathers.themes.MetalWorksMobileTheme;

import starling.core.Starling;
import starling.events.Event;

@:keep class Main extends Drawers
{
	inline private static var MAIN_MENU:String = "mainMenu";
	inline private static var ANCHOR:String = "anchor";
	inline private static var FLOW:String = "flow";
	inline private static var HORIZONTAL:String = "horizontal";
	inline private static var VERTICAL:String = "vertical";
	inline private static var TILED_ROWS:String = "tiledRows";
	inline private static var TILED_COLUMNS:String = "tiledColumns";
	inline private static var WATERFALL:String = "waterfall";
	inline private static var FLOW_SETTINGS:String = "flowSettings";
	inline private static var HORIZONTAL_SETTINGS:String = "horizontalSettings";
	inline private static var VERTICAL_SETTINGS:String = "verticalSettings";
	inline private static var TILED_ROWS_SETTINGS:String = "tiledRowsSettings";
	inline private static var TILED_COLUMNS_SETTINGS:String = "tiledColumnsSettings";
	inline private static var WATERFALL_SETTINGS:String = "waterfallSettings";

	private static var MAIN_MENU_EVENTS:Dynamic =
	{
		showAnchor: ANCHOR,
		showFlow: FLOW,
		showHorizontal: HORIZONTAL,
		showVertical: VERTICAL,
		showTiledRows: TILED_ROWS,
		showTiledColumns: TILED_COLUMNS,
		showWaterfall: WATERFALL
	};

	public function new()
	{
		//set up the theme right away!
		new MetalWorksMobileTheme();
		super();
	}

	private var _navigator:StackScreenNavigator;
	private var _menu:MainMenuScreen;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this._navigator = new StackScreenNavigator();
		//we're using Drawers because we want to display the menu on the
		//side when running on tablets.
		this.content = this._navigator;

		var anchorItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AnchorLayoutScreen);
		anchorItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(ANCHOR, anchorItem);

		var flowLayoutSettings:FlowLayoutSettings = new FlowLayoutSettings();
		var flowItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FlowLayoutScreen);
		flowItem.setScreenIDForPushEvent(FlowLayoutScreen.SHOW_SETTINGS, FLOW_SETTINGS);
		flowItem.addPopEvent(Event.COMPLETE);
		flowItem.properties.settings = flowLayoutSettings;
		this._navigator.addScreen(FLOW, flowItem);

		var flowSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FlowLayoutSettingsScreen);
		flowSettingsItem.addPopEvent(Event.COMPLETE);
		flowSettingsItem.properties.settings = flowLayoutSettings;
		flowSettingsItem.pushTransition = Cover.createCoverUpTransition();
		flowSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(FLOW_SETTINGS, flowSettingsItem);

		var horizontalLayoutSettings:HorizontalLayoutSettings = new HorizontalLayoutSettings();
		var horizontalItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HorizontalLayoutScreen);
		horizontalItem.setScreenIDForPushEvent(HorizontalLayoutScreen.SHOW_SETTINGS, HORIZONTAL_SETTINGS);
		horizontalItem.addPopEvent(Event.COMPLETE);
		horizontalItem.properties.settings = horizontalLayoutSettings;
		this._navigator.addScreen(HORIZONTAL, horizontalItem);

		var horizontalSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HorizontalLayoutSettingsScreen);
		horizontalSettingsItem.addPopEvent(Event.COMPLETE);
		horizontalSettingsItem.properties.settings = horizontalLayoutSettings;
		horizontalSettingsItem.pushTransition = Cover.createCoverUpTransition();
		horizontalSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(HORIZONTAL_SETTINGS, horizontalSettingsItem);

		var verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
		var verticalItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(VerticalLayoutScreen);
		verticalItem.setScreenIDForPushEvent(VerticalLayoutScreen.SHOW_SETTINGS, VERTICAL_SETTINGS);
		verticalItem.addPopEvent(Event.COMPLETE);
		verticalItem.properties.settings = verticalLayoutSettings;
		this._navigator.addScreen(VERTICAL, verticalItem);

		var verticalSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(VerticalLayoutSettingsScreen);
		verticalSettingsItem.addPopEvent(Event.COMPLETE);
		verticalSettingsItem.properties.settings = verticalLayoutSettings;
		verticalSettingsItem.pushTransition = Cover.createCoverUpTransition();
		verticalSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(VERTICAL_SETTINGS, verticalSettingsItem);

		var tiledRowsLayoutSettings:TiledRowsLayoutSettings = new TiledRowsLayoutSettings();
		var tiledRowsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TiledRowsLayoutScreen);
		tiledRowsItem.setScreenIDForPushEvent(TiledRowsLayoutScreen.SHOW_SETTINGS, TILED_ROWS_SETTINGS);
		tiledRowsItem.addPopEvent(Event.COMPLETE);
		tiledRowsItem.properties.settings = tiledRowsLayoutSettings;
		this._navigator.addScreen(TILED_ROWS, tiledRowsItem);

		var tiledRowsSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TiledRowsLayoutSettingsScreen);
		tiledRowsSettingsItem.addPopEvent(Event.COMPLETE);
		tiledRowsSettingsItem.properties.settings = tiledRowsLayoutSettings;
		tiledRowsSettingsItem.pushTransition = Cover.createCoverUpTransition();
		tiledRowsSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(TILED_ROWS_SETTINGS, tiledRowsSettingsItem);

		var tiledColumnsLayoutSettings:TiledColumnsLayoutSettings = new TiledColumnsLayoutSettings();
		var tiledColumnsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TiledColumnsLayoutScreen);
		tiledColumnsItem.setScreenIDForPushEvent(TiledColumnsLayoutScreen.SHOW_SETTINGS, TILED_COLUMNS_SETTINGS);
		tiledColumnsItem.addPopEvent(Event.COMPLETE);
		tiledColumnsItem.properties.settings = tiledColumnsLayoutSettings;
		this._navigator.addScreen(TILED_COLUMNS, tiledColumnsItem);

		var tiledColumnsSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TiledColumnsLayoutSettingsScreen);
		tiledColumnsSettingsItem.addPopEvent(Event.COMPLETE);
		tiledColumnsSettingsItem.properties.settings = tiledColumnsLayoutSettings;
		tiledColumnsSettingsItem.pushTransition = Cover.createCoverUpTransition();
		tiledColumnsSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(TILED_COLUMNS_SETTINGS, tiledColumnsSettingsItem);

		var waterfallLayoutSettings:WaterfallLayoutSettings = new WaterfallLayoutSettings();
		var waterfallItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(WaterfallLayoutScreen);
		waterfallItem.setScreenIDForPushEvent(TiledColumnsLayoutScreen.SHOW_SETTINGS, WATERFALL_SETTINGS);
		waterfallItem.addPopEvent(Event.COMPLETE);
		waterfallItem.properties.settings = waterfallLayoutSettings;
		this._navigator.addScreen(WATERFALL, waterfallItem);

		var waterfallSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(WaterfallLayoutSettingsScreen);
		waterfallSettingsItem.addPopEvent(Event.COMPLETE);
		waterfallSettingsItem.properties.settings = waterfallLayoutSettings;
		waterfallSettingsItem.pushTransition = Cover.createCoverUpTransition();
		waterfallSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(WATERFALL_SETTINGS, waterfallSettingsItem);

		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			//we don't want the screens bleeding outside the navigator's
			//bounds on top of a drawer when a transition is active, so
			//enable clipping.
			this._navigator.clipContent = true;
			this._menu = new MainMenuScreen();
			for (eventType in Reflect.fields(MAIN_MENU_EVENTS))
			{
				this._menu.addEventListener(eventType, mainMenuEventHandler);
			}
			this.leftDrawer = this._menu;
			this.leftDrawerDockMode = Drawers.DOCK_MODE_BOTH;
		}
		else
		{
			var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(MainMenuScreen);
			for(eventType in MAIN_MENU_EVENTS)
			{
				mainMenuItem.setScreenIDForPushEvent(eventType, MAIN_MENU_EVENTS[eventType] as String);
			}
			this._navigator.addScreen(MAIN_MENU, mainMenuItem);
			this._navigator.rootScreenID = MAIN_MENU;
		}

		this._navigator.pushTransition = Slide.createSlideLeftTransition();
		this._navigator.popTransition = Slide.createSlideRightTransition();
	}

	private function mainMenuEventHandler(event:Event):Void
	{
		var screenName:String = MAIN_MENU_EVENTS[event.type] as String;
		//since this navigation is triggered by an external menu, we don't
		//want to push a new screen onto the stack. we want to start fresh.
		this._navigator.rootScreenID = screenName;
	}
}
