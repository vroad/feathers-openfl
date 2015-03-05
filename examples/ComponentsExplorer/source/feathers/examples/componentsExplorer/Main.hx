package feathers.examples.componentsExplorer;
import feathers.controls.Drawers;
import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.examples.componentsExplorer.data.EmbeddedAssets;
import feathers.examples.componentsExplorer.data.GroupedListSettings;
import feathers.examples.componentsExplorer.data.ItemRendererSettings;
import feathers.examples.componentsExplorer.data.ListSettings;
import feathers.examples.componentsExplorer.data.NumericStepperSettings;
import feathers.examples.componentsExplorer.data.SliderSettings;
import feathers.examples.componentsExplorer.screens.AlertScreen;
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
import feathers.examples.componentsExplorer.screens.TabBarScreen;
import feathers.examples.componentsExplorer.screens.TextInputScreen;
import feathers.examples.componentsExplorer.screens.ToggleScreen;
import feathers.examples.componentsExplorer.themes.ComponentsExplorerTheme;
import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.events.Event;

@:keep class Main extends Drawers
{
	inline private static var MAIN_MENU:String = "mainMenu";
	inline private static var ALERT:String = "alert";
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
	inline private static var SLIDER_SETTINGS:String = "sliderSettings";
	inline private static var TAB_BAR:String = "tabBar";
	inline private static var TEXT_INPUT:String = "textInput";
	inline private static var TOGGLES:String = "toggles";

	private static var MAIN_MENU_EVENTS:Dynamic =
	{
		showAlert: ALERT,
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
		showTabBar: TAB_BAR,
		showTextInput: TEXT_INPUT,
		showToggles: TOGGLES
	};
	
	public function new()
	{
		super();
	}

	private var _navigator:ScreenNavigator;
	private var _menu:MainMenuScreen;
	private var _transitionManager:ScreenSlidingStackTransitionManager;
	
	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		EmbeddedAssets.initialize();

		new ComponentsExplorerTheme();
		
		this._navigator = new ScreenNavigator();
		this.content = this._navigator;

		this._navigator.addScreen(ALERT, new ScreenNavigatorItem(AlertScreen,
		{
			complete: MAIN_MENU
		}));

		this._navigator.addScreen(BUTTON, new ScreenNavigatorItem(ButtonScreen,
		{
			complete: MAIN_MENU,
			showSettings: BUTTON_SETTINGS
		}));

		this._navigator.addScreen(BUTTON_GROUP, new ScreenNavigatorItem(ButtonGroupScreen,
		{
			complete: MAIN_MENU
		}));

		this._navigator.addScreen(CALLOUT, new ScreenNavigatorItem(CalloutScreen,
		{
			complete: MAIN_MENU
		}));

		this._navigator.addScreen(SCROLL_TEXT, new ScreenNavigatorItem(ScrollTextScreen,
		{
			complete: MAIN_MENU
		}));

		var sliderSettings:SliderSettings = new SliderSettings();
		this._navigator.addScreen(SLIDER, new ScreenNavigatorItem(SliderScreen,
		{
			complete: MAIN_MENU,
			showSettings: SLIDER_SETTINGS
		},
		{
			settings: sliderSettings
		}));

		this._navigator.addScreen(SLIDER_SETTINGS, new ScreenNavigatorItem(SliderSettingsScreen,
		{
			complete: SLIDER
		},
		{
			settings: sliderSettings
		}));
		
		this._navigator.addScreen(TOGGLES, new ScreenNavigatorItem(ToggleScreen,
		{
			complete: MAIN_MENU
		}));

		var groupedListSettings:GroupedListSettings = new GroupedListSettings();
		this._navigator.addScreen(GROUPED_LIST, new ScreenNavigatorItem(GroupedListScreen,
		{
			complete: MAIN_MENU,
			showSettings: GROUPED_LIST_SETTINGS
		},
		{
			settings: groupedListSettings
		}));

		this._navigator.addScreen(GROUPED_LIST_SETTINGS, new ScreenNavigatorItem(GroupedListSettingsScreen,
		{
			complete: GROUPED_LIST
		},
		{
			settings: groupedListSettings
		}));

		var itemRendererSettings:ItemRendererSettings = new ItemRendererSettings();
		this._navigator.addScreen(ITEM_RENDERER, new ScreenNavigatorItem(ItemRendererScreen,
		{
			complete: MAIN_MENU,
			showSettings: ITEM_RENDERER_SETTINGS
		},
		{
			settings: itemRendererSettings
		}));

		this._navigator.addScreen(ITEM_RENDERER_SETTINGS, new ScreenNavigatorItem(ItemRendererSettingsScreen,
		{
			complete: ITEM_RENDERER
		},
		{
			settings: itemRendererSettings
		}));

		this._navigator.addScreen(LABEL, new ScreenNavigatorItem(LabelScreen,
		{
			complete: MAIN_MENU
		}));

		var listSettings:ListSettings = new ListSettings();
		this._navigator.addScreen(LIST, new ScreenNavigatorItem(ListScreen,
		{
			complete: MAIN_MENU,
			showSettings: LIST_SETTINGS
		},
		{
			settings: listSettings
		}));

		this._navigator.addScreen(LIST_SETTINGS, new ScreenNavigatorItem(ListSettingsScreen,
		{
			complete: LIST
		},
		{
			settings: listSettings
		}));

		var numericStepperSettings:NumericStepperSettings = new NumericStepperSettings();
		this._navigator.addScreen(NUMERIC_STEPPER, new ScreenNavigatorItem(NumericStepperScreen,
		{
			complete: MAIN_MENU,
			showSettings: NUMERIC_STEPPER_SETTINGS
		},
		{
			settings: numericStepperSettings
		}));

		this._navigator.addScreen(NUMERIC_STEPPER_SETTINGS, new ScreenNavigatorItem(NumericStepperSettingsScreen,
		{
			complete: NUMERIC_STEPPER
		},
		{
			settings: numericStepperSettings
		}));

		this._navigator.addScreen(PAGE_INDICATOR, new ScreenNavigatorItem(PageIndicatorScreen,
		{
			complete: MAIN_MENU
		}));
		
		this._navigator.addScreen(PICKER_LIST, new ScreenNavigatorItem(PickerListScreen,
		{
			complete: MAIN_MENU
		}));

		this._navigator.addScreen(TAB_BAR, new ScreenNavigatorItem(TabBarScreen,
		{
			complete: MAIN_MENU
		}));

		this._navigator.addScreen(TEXT_INPUT, new ScreenNavigatorItem(TextInputScreen,
		{
			complete: MAIN_MENU
		}));

		this._navigator.addScreen(PROGRESS_BAR, new ScreenNavigatorItem(ProgressBarScreen,
		{
			complete: MAIN_MENU
		}));

		this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
		this._transitionManager.duration = 0.4;

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
			this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, MAIN_MENU_EVENTS));
			this._navigator.showScreen(MAIN_MENU);
		}
	}

	private function mainMenuEventHandler(event:Event):Void
	{
		var screenName:String = Reflect.field(MAIN_MENU_EVENTS, event.type);
		//because we're controlling the navigation externally, it doesn't
		//make sense to transition or keep a history
		this._transitionManager.clearStack();
		this._transitionManager.skipNextTransition = true;
		this._navigator.showScreen(screenName);
	}
}