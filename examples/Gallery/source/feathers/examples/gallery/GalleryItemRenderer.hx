package feathers.examples.gallery;
import feathers.controls.ImageLoader;
import feathers.controls.List;
import feathers.controls.renderers.IListItemRenderer;
import feathers.core.FeathersControl;
import feathers.events.FeathersEventType;
import starling.utils.Max;

import openfl.geom.Point;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class GalleryItemRenderer extends FeathersControl implements IListItemRenderer
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * @private
	 */
	private static var HELPER_TOUCHES_VECTOR:Array<Touch> = new Array();

	/**
	 * @private
	 * This will only work in a single list. If this item renderer needs to
	 * be used by multiple lists, this data should be stored differently.
	 */
	private static var CACHED_BOUNDS:Map<Int, Point> = new Map();

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.isQuickHitAreaEnabled = true;
		this.addEventListener(TouchEvent.TOUCH, touchHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	/**
	 * @private
	 */
	private var image:ImageLoader;

	/**
	 * @private
	 */
	private var touchPointID:Int = -1;

	/**
	 * @private
	 */
	private var fadeTween:Tween;

	/**
	 * @private
	 */
	private var _index:Int = -1;

	/**
	 * @inheritDoc
	 */
	public var index(get, set):Int;
	public function get_index():Int
	{
		return this._index;
	}

	/**
	 * @private
	 */
	public function set_index(value:Int):Int
	{
		if(this._index == value)
		{
			return get_index();
		}
		this._index = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_index();
	}

	/**
	 * @private
	 */
	private var _owner:List;

	/**
	 * @inheritDoc
	 */
	public var owner(get, set):List;
	public function get_owner():List
	{
		return this._owner;
	}

	/**
	 * @private
	 */
	public function set_owner(value:List):List
	{
		if(this._owner == value)
		{
			return get_owner();
		}
		if(this._owner != null)
		{
			this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			this._owner.removeEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
		}
		this._owner = value;
		if(this._owner != null)
		{
			if(this.image != null)
			{
				this.image.delayTextureCreation = this._owner.isScrolling;
			}
			this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			this._owner.addEventListener(FeathersEventType.SCROLL_COMPLETE, owner_scrollCompleteHandler);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_owner();
	}

	/**
	 * @private
	 */
	private var _data:GalleryItem;

	/**
	 * @inheritDoc
	 */
	public var data(get, set):Dynamic;
	public function get_data():Dynamic
	{
		return this._data;
	}

	/**
	 * @private
	 */
	public function set_data(value:Dynamic):Dynamic
	{
		if(this._data == value)
		{
			return get_data();
		}
		this.touchPointID = -1;
		this._data = cast value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_data();
	}

	/**
	 * @private
	 */
	private var _isSelected:Bool;

	/**
	 * @inheritDoc
	 */
	public var isSelected(get, set):Bool;
	public function get_isSelected():Bool
	{
		return this._isSelected;
	}

	/**
	 * @private
	 */
	public function set_isSelected(value:Bool):Bool
	{
		if(this._isSelected == value)
		{
			return get_isSelected();
		}
		this._isSelected = value;
		this.dispatchEventWith(Event.CHANGE);
		return get_isSelected();
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this.image = new ImageLoader();
		this.image.textureQueueDuration = 0.25;
		this.image.addEventListener(Event.COMPLETE, image_completeHandler);
		this.image.addEventListener(FeathersEventType.ERROR, image_errorHandler);
		this.addChild(this.image);
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var selectionInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SELECTED);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);

		if(dataInvalid)
		{
			if(this.fadeTween != null)
			{
				this.fadeTween.advanceTime(Max.MAX_VALUE);
			}
			if(this._data != null)
			{
				this.image.visible = false;
				this.image.source = this._data.thumbURL;
			}
			else
			{
				this.image.source = null;
			}
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(sizeInvalid)
		{
			this.image.width = this.actualWidth;
			this.image.height = this.actualHeight;
		}
	}

	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = Math.isNaN(this.explicitWidth);
		var needsHeight:Bool = Math.isNaN(this.explicitHeight);
		if(!needsWidth && !needsHeight)
		{
			return false;
		}

		this.image.width = this.image.height = Math.NaN;
		this.image.validate();
		var newWidth:Float = this.explicitWidth;
		var boundsFromCache:Point;
		if(needsWidth)
		{
			if(this.image.isLoaded)
			{
				if(!CACHED_BOUNDS.exists(this._index))
				{
					CACHED_BOUNDS[this._index] = new Point();
				}
				boundsFromCache = CACHED_BOUNDS[this._index];
				//also save it to a cache so that we can reuse the width and
				//height values later if the same image needs to be loaded
				//again.
				newWidth = boundsFromCache.x = this.image.width;
			}
			else
			{
				if(CACHED_BOUNDS.exists(this._index))
				{
					//if the image isn't loaded yet, but we've loaded it at
					//least once before, we can use a cached value to avoid
					//jittering when the image resizes
					boundsFromCache = CACHED_BOUNDS[this._index];
					newWidth = boundsFromCache.x;
				}
				else
				{
					//default to 100 if we've never displayed an image for
					//this index yet.
					newWidth = 100;
				}

			}
		}
		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			if(this.image.isLoaded)
			{
				if(!CACHED_BOUNDS.exists(this._index))
				{
					CACHED_BOUNDS[this._index] = new Point();
				}
				boundsFromCache = CACHED_BOUNDS[this._index];
				newHeight = boundsFromCache.y = this.image.height;
			}
			else
			{
				if(CACHED_BOUNDS.exists(this._index))
				{
					boundsFromCache = CACHED_BOUNDS[this._index];
					newHeight = boundsFromCache.y;
				}
				else
				{
					newHeight = 100;
				}
			}
		}
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * @private
	 */
	private function fadeTween_onComplete():Void
	{
		this.fadeTween = null;
	}

	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void
	{
		this.touchPointID = -1;
	}

	/**
	 * @private
	 */
	private function touchHandler(event:TouchEvent):Void
	{
		var touches:Array<Touch> = event.getTouches(this, null, HELPER_TOUCHES_VECTOR);
		if(touches.length == 0)
		{
			return;
		}
		if(this.touchPointID >= 0)
		{
			var touch:Touch = null;
			for (currentTouch in touches)
			{
				if(currentTouch.id == this.touchPointID)
				{
					touch = currentTouch;
					break;
				}
			}
			if(touch == null)
			{
				HELPER_TOUCHES_VECTOR.splice(0, HELPER_TOUCHES_VECTOR.length);
				return;
			}
			if(touch.phase == TouchPhase.ENDED)
			{
				this.touchPointID = -1;

				touch.getLocation(this, HELPER_POINT);
				if(this.hitTest(HELPER_POINT, true) != null && !this._isSelected)
				{
					this.isSelected = true;
				}
			}
		}
		else
		{
			for (touch in touches)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					this.touchPointID = touch.id;
					break;
				}
			}
		}
		HELPER_TOUCHES_VECTOR.splice(0, HELPER_TOUCHES_VECTOR.length);
	}

	/**
	 * @private
	 */
	private function owner_scrollStartHandler(event:Event):Void
	{
		this.touchPointID = -1;
		this.image.delayTextureCreation = true;
	}

	/**
	 * @private
	 */
	private function owner_scrollCompleteHandler(event:Event):Void
	{
		this.image.delayTextureCreation = false;
	}

	/**
	 * @private
	 */
	private function image_completeHandler(event:Event):Void
	{
		this.image.alpha = 0;
		this.image.visible = true;
		this.fadeTween = new Tween(this.image, 1, Transitions.EASE_OUT);
		this.fadeTween.fadeTo(1);
		this.fadeTween.onComplete = fadeTween_onComplete;
		Starling.current.juggler.add(this.fadeTween);
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}

	private function image_errorHandler(event:Event):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}

}
