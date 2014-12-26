package feathers.examples.drawersExplorer.skins;
import feathers.examples.drawersExplorer.views.ContentView;
import feathers.examples.drawersExplorer.views.DrawerView;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import feathers.themes.MetalWorksMobileTheme;

import starling.display.Quad;

class DrawersExplorerTheme extends MetalWorksMobileTheme
{
	inline public static var THEME_NAME_TOP_AND_BOTTOM_DRAWER:String = "drawers-explorer-top-and-bottom-drawer";
	inline public static var THEME_NAME_LEFT_AND_RIGHT_DRAWER:String = "drawers-explorer-left-and-right-drawer";

	public function DrawersExplorerTheme()
	{
		super();
	}

	override private function initializeStyleProviders():Void
	{
		super.initializeStyleProviders();
		this.getStyleProviderForClass(ContentView).defaultStyleFunction = setContentViewStyles;
		this.getStyleProviderForClass(DrawerView).setFunctionForStyleName(THEME_NAME_TOP_AND_BOTTOM_DRAWER, setTopAndBottomDrawerViewStyles);
		this.getStyleProviderForClass(DrawerView).setFunctionForStyleName(THEME_NAME_LEFT_AND_RIGHT_DRAWER, setLeftAndRightDrawerViewStyles);
	}

	private function setContentViewStyles(view:ContentView):Void
	{
		var layout:VerticalLayout = new VerticalLayout();
		layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
		layout.padding = 20 * this.scale;
		view.layout = layout;
	}

	private function setLeftAndRightDrawerViewStyles(view:DrawerView):Void
	{
		view.backgroundSkin = new Quad(10, 10, LIST_BACKGROUND_COLOR);

		var layout:VerticalLayout = new VerticalLayout();
		layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
		layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
		layout.padding = 20 * this.scale;
		layout.gap = 20 * this.scale;
		view.layout = layout;
	}

	private function setTopAndBottomDrawerViewStyles(view:DrawerView):Void
	{
		view.backgroundSkin = new Quad(10, 10, GROUPED_LIST_HEADER_BACKGROUND_COLOR);

		var layout:HorizontalLayout = new HorizontalLayout();
		layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
		layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
		layout.padding = 20 * this.scale;
		layout.gap = 20 * this.scale;
		view.layout = layout;
	}
}
