package feathers.examples.gallery;
import feathers.controls.List;
import feathers.themes.MetalWorksMobileTheme;

/**
 * Extends MetalWorksMobileTheme to make some app-specific styling tweaks
 */
class GalleryTheme extends MetalWorksMobileTheme
{
	public function new()
	{
		super(true)
	}

	override private function initializeStyleProviders():Void
	{
		super.initializeStyleProviders();
		this.getStyleProviderForClass(List).setFunctionForStyleName(Main.THUMBNAIL_LIST_NAME, this.setThumbnailListStyles);
	}

	private function setThumbnailListStyles(list:List):Void
	{
		//start with the default list styles. we could start from scratch,
		//if we wanted, but we're only making minor changes.
		super.setListStyles(list);

		//we're not displaying scroll bars
		list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
	}
}
