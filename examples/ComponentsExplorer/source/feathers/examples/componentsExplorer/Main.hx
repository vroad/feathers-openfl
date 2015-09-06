package feathers.examples.componentsExplorer;
import feathers.controls.Drawers;
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.examples.componentsExplorer.data.EmbeddedAssets;
import feathers.examples.componentsExplorer.data.GroupedListSettings;
import feathers.examples.componentsExplorer.data.ItemRendererSettings;
import feathers.examples.componentsExplorer.data.ListSettings;
import feathers.examples.componentsExplorer.data.NumericStepperSettings;
import feathers.examples.componentsExplorer.data.SliderSettings;
import feathers.examples.componentsExplorer.screens.AlertScreen;
import feathers.examples.componentsExplorer.screens.AutoCompleteScreen;
import feathers.examples.componentsExplorer.screens.ButtonGroupScreen;
import feathers.examples.componentsExplorer.screens.ButtonScreen;
import feathers.examples.componentsExplorer.screens.CalloutScreen;
import feathers.examples.componentsExplorer.screens.GroupedListScreen;
import feathers.examples.componentsExplorer.screens.GroupedListSettingsScreen;
import feathers.examples.componentsExplorer.screens.ItemRendererScreen;
import feathers.examples.componentsExplorer.screens.ItemRendererSettingsScreen;
import feathers.examples.componentsExplorer.screens.LabelScreen;
import feathers.examples.componentsExplorer.screens.ListScreen;
import feathers.examples.componentsExplorer.screens.ListSettingsScreen;
import feathers.examples.componentsExplorer.screens.MainMenuScreen;
import feathers.examples.componentsExplorer.screens.NumericStepperScreen;
import feathers.examples.componentsExplorer.screens.NumericStepperSettingsScreen;
import feathers.examples.componentsExplorer.screens.PageIndicatorScreen;
import feathers.examples.componentsExplorer.screens.PickerListScreen;
import feathers.examples.componentsExplorer.screens.ProgressBarScreen;
import feathers.examples.componentsExplorer.screens.ScrollTextScreen;
import feathers.examples.componentsExplorer.screens.SliderScreen;
import feathers.examples.componentsExplorer.screens.SliderSettingsScreen;
import feathers.examples.componentsExplorer.screens.SpinnerListScreen;
import feathers.examples.componentsExplorer.screens.TabBarScreen;
import feathers.examples.componentsExplorer.screens.TextInputScreen;
import feathers.examples.componentsExplorer.screens.ToggleScreen;
import feathers.examples.componentsExplorer.screens.WebViewScreen;
import feathers.examples.componentsExplorer.themes.ComponentsExplorerTheme;
import feathers.motion.Cover;
import feathers.motion.Reveal;
import feathers.motion.Slide;
import feathers.system.DeviceCapabilities;

import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;

@:keep class Main extends Drawers
{
	inline private static var MAIN_MENU:String = "mainMenu";
	inline private static var ALERT:String = "alert";
	inline private static var AUTO_COMPLETE:String = "autoComplete";
	inline private static var BUTTON:String = "button";
	inline private static var BUTTON_SETTINGS:String = "buttonSettings";
	inline private static var BUTTON_GROUP:String = "buttonGroup";
	inline private static var CALLOUT:String = "callout";
	inline private static var GROUPED_LIST:String = "groupedList";
	inline private static var GROUPED_LIST_SETTINGS:String = "groupedListSettings";
	inline private static var ITEM_RENDERER:String = "itemRenderer";
	inline private static var ITEM_RENDERER_SETTINGS:String = "itemRendererSettings";
	inline private static var LABEL:String = "label";
	inline private static var LIST:String = "list";
	inline private static var LIST_SETTINGS:String = "listSettings";
	inline private static var NUMERIC_STEPPER:String = "numericStepper";
	inline private static var NUMERIC_STEPPER_SETTINGS:String = "numericStepperSettings";
	inline private static var PAGE_INDICATOR:String = "pageIndicator";
	inline private static var PICKER_LIST:String = "pickerList";
	inline private static var PROGRESS_BAR:String = "progressBar";
	inline private static var SCROLL_TEXT:String = "scrollText";
	inline private static var SLIDER:String = "slider";
	inline private static var SPINNER_LIST:String = "spinnerList";
	inline private static var SLIDER_SETTINGS:String = "sliderSettings";
	inline private static var TAB_BAR:String = "tabBar";
	inline private static var TEXT_INPUT:String = "textInput";
	inline private static var TOGGLES:String = "toggles";
	inline private static var WEB_VIEW:String = "webView";

	private static var MAIN_MENU_EVENTS:Dynamic =
	{
		showAlert: ALERT,
		showAutoComplete: AUTO_COMPLETE,
		showButton: BUTTON,
		showButtonGroup: BUTTON_GROUP,
		showCallout: CALLOUT,
		showGroupedList: GROUPED_LIST,
		showItemRenderer: ITEM_RENDERER,
		showLabel: LABEL,
		showList: LIST,
		showNumericStepper: NUMERIC_STEPPER,
		showPageIndicator: PAGE_INDICATOR,
		showPickerList: PICKER_LIST,
		showProgressBar: PROGRESS_BAR,
		showScrollText: SCROLL_TEXT,
		showSlider: SLIDER,
		showSpinnerList: SPINNER_LIST,
		showTabBar: TAB_BAR,
		showTextInput: TEXT_INPUT,
		showToggles: TOGGLES,
		showWebView: WEB_VIEW
	};
	
	public function new()
	{
		//set up the theme right away!
		new ComponentsExplorerTheme();
		super();
	}

	private var _navigator:StackScreenNavigator;
	private var _menu:MainMenuScreen;
	
	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		EmbeddedAssets.initialize();

		this._navigator = new StackScreenNavigator();
		this.content = this._navigator;

		var alertItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AlertScreen);
		alertItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(ALERT, alertItem);

		var autoCompleteItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AutoCompleteScreen);
		autoCompleteItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(AUTO_COMPLETE, autoCompleteItem);

		var buttonItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ButtonScreen);
		buttonItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(BUTTON, buttonItem);

		var buttonGroupItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ButtonGroupScreen);
		buttonGroupItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(BUTTON_GROUP, buttonGroupItem);

		var calloutItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(CalloutScreen);
		calloutItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(CALLOUT, calloutItem);

		var groupedListSettings:GroupedListSettings = new GroupedListSettings();
		var groupedListItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(GroupedListScreen);
		groupedListItem.setScreenIDForPushEvent(GroupedListScreen.SHOW_SETTINGS, GROUPED_LIST_SETTINGS);
		groupedListItem.addPopEvent(Event.COMPLETE);
		groupedListItem.properties.settings = groupedListSettings;
		this._navigator.addScreen(GROUPED_LIST, groupedListItem);

		var groupedListSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(GroupedListSettingsScreen);
		groupedListSettingsItem.addPopEvent(Event.COMPLETE);
		groupedListSettingsItem.properties.settings = groupedListSettings;
		//custom push and pop transitions for this settings screen
		groupedListSettingsItem.pushTransition = Cover.createCoverUpTransition();
		groupedListSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(GROUPED_LIST_SETTINGS, groupedListSettingsItem);

		var itemRendererSettings:ItemRendererSettings = new ItemRendererSettings();
		var itemRendererItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ItemRendererScreen);
		itemRendererItem.setScreenIDForPushEvent(ItemRendererScreen.SHOW_SETTINGS, ITEM_RENDERER_SETTINGS);
		itemRendererItem.addPopEvent(Event.COMPLETE);
		itemRendererItem.properties.settings = itemRendererSettings;
		this._navigator.addScreen(ITEM_RENDERER, itemRendererItem);

		var itemRendererSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ItemRendererSettingsScreen);
		itemRendererSettingsItem.addPopEvent(Event.COMPLETE);
		itemRendererSettingsItem.properties.settings = itemRendererSettings;
		//custom push and pop transitions for this settings screen
		itemRendererSettingsItem.pushTransition = Cover.createCoverUpTransition();
		itemRendererSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(ITEM_RENDERER_SETTINGS, itemRendererSettingsItem);

		var labelItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(LabelScreen);
		labelItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(LABEL, labelItem);

		var listSettings:ListSettings = new ListSettings();
		var listItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ListScreen);
		listItem.setScreenIDForPushEvent(ListScreen.SHOW_SETTINGS, LIST_SETTINGS);
		listItem.addPopEvent(Event.COMPLETE);
		listItem.properties.settings = listSettings;
		this._navigator.addScreen(LIST, listItem);

		var listSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ListSettingsScreen);
		listSettingsItem.addPopEvent(Event.COMPLETE);
		listSettingsItem.properties.settings = listSettings;
		//custom push and pop transitions for this settings screen
		listSettingsItem.pushTransition = Cover.createCoverUpTransition();
		listSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(LIST_SETTINGS, listSettingsItem);

		var numericStepperSettings:NumericStepperSettings = new NumericStepperSettings();
		var numericStepperItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(NumericStepperScreen);
		numericStepperItem.setScreenIDForPushEvent(NumericStepperScreen.SHOW_SETTINGS, NUMERIC_STEPPER_SETTINGS);
		numericStepperItem.addPopEvent(Event.COMPLETE);
		numericStepperItem.properties.settings = numericStepperSettings;
		this._navigator.addScreen(NUMERIC_STEPPER, numericStepperItem);

		var numericStepperSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(NumericStepperSettingsScreen);
		numericStepperSettingsItem.addPopEvent(Event.COMPLETE);
		numericStepperSettingsItem.properties.settings = numericStepperSettings;
		//custom push and pop transitions for this settings screen
		numericStepperSettingsItem.pushTransition = Cover.createCoverUpTransition();
		numericStepperSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(NUMERIC_STEPPER_SETTINGS, numericStepperSettingsItem);

		var pageIndicatorItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(PageIndicatorScreen);
		pageIndicatorItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(PAGE_INDICATOR, pageIndicatorItem);

		var pickerListItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(PickerListScreen);
		pickerListItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(PICKER_LIST, pickerListItem);

		var progressBarItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ProgressBarScreen);
		progressBarItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(PROGRESS_BAR, progressBarItem);

		var scrollTextItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ScrollTextScreen);
		scrollTextItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(SCROLL_TEXT, scrollTextItem);

		var sliderSettings:SliderSettings = new SliderSettings();
		var sliderItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SliderScreen);
		sliderItem.setScreenIDForPushEvent(SliderScreen.SHOW_SETTINGS, SLIDER_SETTINGS);
		sliderItem.addPopEvent(Event.COMPLETE);
		sliderItem.properties.settings = sliderSettings;
		this._navigator.addScreen(SLIDER, sliderItem);

		var sliderSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SliderSettingsScreen);
		sliderSettingsItem.addPopEvent(Event.COMPLETE);
		sliderSettingsItem.properties.settings = sliderSettings;
		//custom push and pop transitions for this settings screen
		sliderSettingsItem.pushTransition = Cover.createCoverUpTransition();
		sliderSettingsItem.popTransition = Reveal.createRevealDownTransition();
		this._navigator.addScreen(SLIDER_SETTINGS, sliderSettingsItem);

		var spinnerListItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SpinnerListScreen);
		spinnerListItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(SPINNER_LIST, spinnerListItem);

		var tabBarItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TabBarScreen);
		tabBarItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(TAB_BAR, tabBarItem);

		var textInputItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TextInputScreen);
		textInputItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(TEXT_INPUT, textInputItem);

		var togglesItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ToggleScreen);
		togglesItem.addPopEvent(Event.COMPLETE);
		this._navigator.addScreen(TOGGLES, togglesItem);

		if(Capabilities.playerType == "Desktop") //this means AIR, even for mobile
		{
			var webViewItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(WebViewScreen);
			webViewItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(WEB_VIEW, webViewItem);
		}

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
			this._menu.height = 200;
			this.leftDrawer = this._menu;
			this.leftDrawerDockMode = Drawers.DOCK_MODE_BOTH;
		}
		else
		{
			var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(MainMenuScreen);
			for(eventType in Reflect.fields(MAIN_MENU_EVENTS))
			{
				mainMenuItem.setScreenIDForPushEvent(eventType, cast(Reflect.field(MAIN_MENU_EVENTS, eventType), String));
			}
			this._navigator.addScreen(MAIN_MENU, mainMenuItem);
			this._navigator.rootScreenID = MAIN_MENU;
		}

		this._navigator.pushTransition = Slide.createSlideLeftTransition();
		this._navigator.popTransition = Slide.createSlideRightTransition();
	}

	private function mainMenuEventHandler(event:Event):Void
	{
		var screenName:String = cast(Reflect.field(MAIN_MENU_EVENTS, event.type), String);
		//since this navigation is triggered by an external menu, we don't
		//want to push a new screen onto the stack. we want to start fresh.
		this._navigator.rootScreenID = screenName;
	}
}