/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers;
import feathers.controls.GroupedList;
import feathers.controls.ImageLoader;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.ITextRenderer;
import feathers.core.IValidating;
import feathers.core.PropertyProxy;
import feathers.skins.IStyleProvider;

import starling.display.DisplayObject;

/**
 * The default renderer used for headers and footers in a GroupedList
 * control.
 *
 * @see feathers.controls.GroupedList
 */
@:keep class DefaultGroupedListHeaderOrFooterRenderer extends FeathersControl implements IGroupedListHeaderOrFooterRenderer
{
	/**
	 * The content will be aligned horizontally to the left edge of the renderer.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * The content will be aligned horizontally to the center of the renderer.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * The content will be aligned horizontally to the right edge of the renderer.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * The content will be justified horizontally, filling the entire width
	 * of the renderer, minus padding.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * The content will be aligned vertically to the top edge of the renderer.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * The content will be aligned vertically to the middle of the renderer.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * The content will be aligned vertically to the bottom edge of the renderer.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * The content will be justified vertically, filling the entire height
	 * of the renderer, minus padding.
	 *
	 * @see #verticalAlign
	 */
	inline public static var VERTICAL_ALIGN_JUSTIFY:String = "justify";

	/**
	 * The default value added to the <code>styleNameList</code> of the
	 * content label.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_NAME_CONTENT_LABEL:String = "feathers-header-footer-renderer-content-label";

	/**
	 * The default <code>IStyleProvider</code> for all <code>DefaultGroupedListHeaderOrFooterRenderer</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * @private
	 */
	private static function defaultImageLoaderFactory():ImageLoader
	{
		return new ImageLoader();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
	}

	/**
	 * The value added to the <code>styleNameList</code> of the content
	 * label.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	private var contentLabelName:String = DEFAULT_CHILD_NAME_CONTENT_LABEL;

	/**
	 * @private
	 */
	private var contentImage:ImageLoader;

	/**
	 * @private
	 */
	private var contentLabel:ITextRenderer;

	/**
	 * @private
	 */
	private var content:DisplayObject;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return DefaultGroupedListHeaderOrFooterRenderer.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _data:Dynamic;

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
		this._data = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_data();
	}

	/**
	 * @private
	 */
	private var _groupIndex:Int = -1;

	/**
	 * @inheritDoc
	 */
	public var groupIndex(get, set):Int;
	public function get_groupIndex():Int
	{
		return this._groupIndex;
	}

	/**
	 * @private
	 */
	public function set_groupIndex(value:Int):Int
	{
		this._groupIndex = value;
		return get_groupIndex();
	}

	/**
	 * @private
	 */
	private var _layoutIndex:Int = -1;

	/**
	 * @inheritDoc
	 */
	public var layoutIndex(get, set):Int;
	public function get_layoutIndex():Int
	{
		return this._layoutIndex;
	}

	/**
	 * @private
	 */
	public function set_layoutIndex(value:Int):Int
	{
		this._layoutIndex = value;
		return get_layoutIndex();
	}

	/**
	 * @private
	 */
	private var _owner:GroupedList;

	/**
	 * @inheritDoc
	 */
	public var owner(get, set):GroupedList;
	public function get_owner():GroupedList
	{
		return this._owner;
	}

	/**
	 * @private
	 */
	public function set_owner(value:GroupedList):GroupedList
	{
		if(this._owner == value)
		{
			return get_owner();
		}
		this._owner = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_owner();
	}

	/**
	 * @private
	 */
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

	//[Inspectable(type="String",enumeration="left,center,right,justify")]
	/**
	 * The location where the renderer's content is aligned horizontally
	 * (on the x-axis).
	 *
	 * <p>In the following example, the horizontal alignment is changed to
	 * right:</p>
	 *
	 * <listing version="3.0">
	 * renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_RIGHT;</listing>
	 *
	 * @default DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 * @see #HORIZONTAL_ALIGN_JUSTIFY
	 */
	public var horizontalAlign(get, set):String;
	public function get_horizontalAlign():String
	{
		return this._horizontalAlign;
	}

	/**
	 * @private
	 */
	public function set_horizontalAlign(value:String):String
	{
		if(this._horizontalAlign == value)
		{
			return get_horizontalAlign();
		}
		this._horizontalAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_horizontalAlign();
	}

	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;

	//[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
	/**
	 * The location where the renderer's content is aligned vertically (on
	 * the y-axis).
	 *
	 * <p>In the following example, the vertical alignment is changed to
	 * bottom:</p>
	 *
	 * <listing version="3.0">
	 * renderer.verticalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_BOTTOM;</listing>
	 *
	 * @default DefaultGroupedListHeaderOrFooterRenderer.VERTICAL_ALIGN_MIDDLE
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #VERTICAL_ALIGN_JUSTIFY
	 */
	public var verticalAlign(get, set):String;
	public function get_verticalAlign():String
	{
		return _verticalAlign;
	}

	/**
	 * @private
	 */
	public function set_verticalAlign(value:String):String
	{
		if(this._verticalAlign == value)
		{
			return get_verticalAlign();
		}
		this._verticalAlign = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_verticalAlign();
	}

	/**
	 * @private
	 */
	private var _contentField:String = "content";

	/**
	 * The field in the item that contains a display object to be positioned
	 * in the content position of the renderer. If you wish to display a
	 * texture in the content position, it's better for performance to use
	 * <code>contentSourceField</code> instead.
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentSourceFunction</code></li>
	 *     <li><code>contentSourceField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the content field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.contentField = "header";</listing>
	 *
	 * @default "content"
	 *
	 * @see #contentSourceField
	 * @see #contentFunction
	 * @see #contentSourceFunction
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentField(get, set):String;
	public function get_contentField():String
	{
		return this._contentField;
	}

	/**
	 * @private
	 */
	public function set_contentField(value:String):String
	{
		if(this._contentField == value)
		{
			return get_contentField();
		}
		this._contentField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_contentField();
	}

	/**
	 * @private
	 */
	private var _contentFunction:Dynamic->DisplayObject;

	/**
	 * A function that returns a display object to be positioned in the
	 * content position of the renderer. If you wish to display a texture in
	 * the content position, it's better for performance to use
	 * <code>contentSourceFunction</code> instead.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):DisplayObject</pre>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentSourceFunction</code></li>
	 *     <li><code>contentSourceField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the content function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.contentFunction = function( item:Dynamic ):DisplayObject
	 * {
	 *    if(item in cachedContent)
	 *    {
	 *        return cachedContent[item];
	 *    }
	 *    var content:DisplayObject = createContentForHeader( item );
	 *    cachedContent[item] = content;
	 *    return content;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #contentField
	 * @see #contentSourceField
	 * @see #contentSourceFunction
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentFunction(get, set):Dynamic->DisplayObject;
	public function get_contentFunction():Dynamic->DisplayObject
	{
		return this._contentFunction;
	}

	/**
	 * @private
	 */
	public function set_contentFunction(value:Dynamic->DisplayObject):Dynamic->DisplayObject
	{
		if(this._contentFunction == value)
		{
			return get_contentFunction();
		}
		this._contentFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_contentFunction();
	}

	/**
	 * @private
	 */
	private var _contentSourceField:String = "source";

	/**
	 * The field in the data that contains a <code>starling.textures.Texture</code>
	 * or a URL that points to a bitmap to be used as the renderer's
	 * content. The renderer will automatically manage and reuse an internal
	 * <code>ImageLoader</code> sub-component and this value will be passed
	 * to the <code>source</code> property. The <code>ImageLoader</code> may
	 * be customized by changing the <code>contentLoaderFactory</code>.
	 *
	 * <p>Using an content source will result in better performance than
	 * passing in an <code>ImageLoader</code> or <code>Image</code> through
	 * <code>contentField</code> or <code>contentFunction</code> because the
	 * renderer can avoid costly display list manipulation.</p>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentSourceFunction</code></li>
	 *     <li><code>contentSourceField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the content source field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.contentSourceField = "texture";</listing>
	 *
	 * @default "source"
	 *
	 * @see feathers.controls.ImageLoader#source
	 * @see #contentLoaderFactory
	 * @see #contentSourceFunction
	 * @see #contentField
	 * @see #contentFunction
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentSourceField(get, set):String;
	public function get_contentSourceField():String
	{
		return this._contentSourceField;
	}

	/**
	 * @private
	 */
	public function set_contentSourceField(value:String):String
	{
		if(this._contentSourceField == value)
		{
			return get_contentSourceField();
		}
		this._contentSourceField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_contentSourceField();
	}

	/**
	 * @private
	 */
	private var _contentSourceFunction:Dynamic->Dynamic;

	/**
	 * A function used to generate a <code>starling.textures.Texture</code>
	 * or a URL that points to a bitmap to be used as the renderer's
	 * content. The renderer will automatically manage and reuse an internal
	 * <code>ImageLoader</code> sub-component and this value will be passed
	 * to the <code>source</code> property. The <code>ImageLoader</code> may
	 * be customized by changing the <code>contentLoaderFactory</code>.
	 *
	 * <p>Using an content source will result in better performance than
	 * passing in an <code>ImageLoader</code> or <code>Image</code> through
	 * <code>contentField</code> or <code>contentFunction</code> because the
	 * renderer can avoid costly display list manipulation.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Dynamic</pre>
	 *
	 * <p>The return value is a valid value for the <code>source</code>
	 * property of an <code>ImageLoader</code> component.</p>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentSourceFunction</code></li>
	 *     <li><code>contentSourceField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the content source function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.contentSourceFunction = function( item:Dynamic ):Dynamic
	 * {
	 *    return "http://www.example.com/thumbs/" + item.name + "-thumb.png";
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.ImageLoader#source
	 * @see #contentLoaderFactory
	 * @see #contentSourceField
	 * @see #contentField
	 * @see #contentFunction
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentSourceFunction(get, set):Dynamic->Dynamic;
	public function get_contentSourceFunction():Dynamic->Dynamic
	{
		return this._contentSourceFunction;
	}

	/**
	 * @private
	 */
	public function set_contentSourceFunction(value:Dynamic->Dynamic):Dynamic->Dynamic
	{
		if(this.contentSourceFunction == value)
		{
			return get_contentSourceFunction();
		}
		this._contentSourceFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_contentSourceFunction();
	}

	/**
	 * @private
	 */
	private var _contentLabelField:String = "label";

	/**
	 * The field in the item that contains a string to be displayed in a
	 * renderer-managed <code>Label</code> in the content position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Label</code> and swap the text when the data changes. This
	 * <code>Label</code> may be skinned by changing the
	 * <code>contentLabelFactory</code>.
	 *
	 * <p>Using an content label will result in better performance than
	 * passing in a <code>Label</code> through a <code>contentField</code>
	 * or <code>contentFunction</code> because the renderer can avoid
	 * costly display list manipulation.</p>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the content label field is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.contentLabelField = "text";</listing>
	 *
	 * @default "label"
	 *
	 * @see #contentLabelFactory
	 * @see #contentLabelFunction
	 * @see #contentField
	 * @see #contentFunction
	 * @see #contentSourceField
	 * @see #contentSourceFunction
	 */
	public var contentLabelField(get, set):String;
	public function get_contentLabelField():String
	{
		return this._contentLabelField;
	}

	/**
	 * @private
	 */
	public function set_contentLabelField(value:String):String
	{
		if(this._contentLabelField == value)
		{
			return get_contentLabelField();
		}
		this._contentLabelField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_contentLabelField();
	}

	/**
	 * @private
	 */
	private var _contentLabelFunction:Dynamic->String;

	/**
	 * A function that returns a string to be displayed in a
	 * renderer-managed <code>Label</code> in the content position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Label</code> and swap the text when the data changes. This
	 * <code>Label</code> may be skinned by changing the
	 * <code>contentLabelFactory</code>.
	 *
	 * <p>Using an content label will result in better performance than
	 * passing in a <code>Label</code> through a <code>contentField</code>
	 * or <code>contentFunction</code> because the renderer can avoid
	 * costly display list manipulation.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):String</pre>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * <p>In the following example, the content label function is customized:</p>
	 *
	 * <listing version="3.0">
	 * renderer.contentLabelFunction = function( item:Dynamic ):String
	 * {
	 *    return item.category + " > " + item.subCategory;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #contentLabelFactory
	 * @see #contentLabelField
	 * @see #contentField
	 * @see #contentFunction
	 * @see #contentSourceField
	 * @see #contentSourceFunction
	 */
	public var contentLabelFunction(get, set):Dynamic->String;
	public function get_contentLabelFunction():Dynamic->String
	{
		return this._contentLabelFunction;
	}

	/**
	 * @private
	 */
	public function set_contentLabelFunction(value:Dynamic->String):Dynamic->String
	{
		if(this._contentLabelFunction == value)
		{
			return get_contentLabelFunction();
		}
		this._contentLabelFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_contentLabelFunction();
	}

	/**
	 * @private
	 */
	private var _contentLoaderFactory:Void->ImageLoader = defaultImageLoaderFactory;

	/**
	 * A function that generates an <code>ImageLoader</code> that uses the result
	 * of <code>contentSourceField</code> or <code>contentSourceFunction</code>.
	 * Useful for transforming the <code>ImageLoader</code> in some way. For
	 * example, you might want to scale it for current screen density or
	 * apply pixel snapping.
	 *
	 * <p>In the following example, a custom content loader factory is passed
	 * to the renderer:</p>
	 *
	 * <listing version="3.0">
	 * renderer.contentLoaderFactory = function():ImageLoader
	 * {
	 *     var loader:ImageLoader = new ImageLoader();
	 *     loader.snapToPixels = true;
	 *     return loader;
	 * };</listing>
	 *
	 * @default function():ImageLoader { return new ImageLoader(); }
	 *
	 * @see feathers.controls.ImageLoader
	 * @see #contentSourceField
	 * @see #contentSourceFunction
	 */
	public var contentLoaderFactory(get, set):Void->ImageLoader;
	public function get_contentLoaderFactory():Void->ImageLoader
	{
		return this._contentLoaderFactory;
	}

	/**
	 * @private
	 */
	public function set_contentLoaderFactory(value:Void->ImageLoader):Void->ImageLoader
	{
		if(this._contentLoaderFactory == value)
		{
			return get_contentLoaderFactory();
		}
		this._contentLoaderFactory = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_contentLoaderFactory();
	}

	/**
	 * @private
	 */
	private var _contentLabelFactory:Void->ITextRenderer;

	/**
	 * A function that generates an <code>ITextRenderer</code> that uses the result
	 * of <code>contentLabelField</code> or <code>contentLabelFunction</code>.
	 * Can be used to set properties on the <code>ITextRenderer</code>.
	 *
	 * <p>In the following example, a custom content label factory is passed
	 * to the renderer:</p>
	 *
	 * <listing version="3.0">
	 * renderer.contentLabelFactory = function():ITextRenderer
	 * {
	 *     var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
	 *     renderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
	 *     renderer.embedFonts = true;
	 *     return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentLabelFactory(get, set):Void->ITextRenderer;
	public function get_contentLabelFactory():Void->ITextRenderer
	{
		return this._contentLabelFactory;
	}

	/**
	 * @private
	 */
	public function set_contentLabelFactory(value:Void->ITextRenderer):Void->ITextRenderer
	{
		if(this._contentLabelFactory == value)
		{
			return get_contentLabelFactory();
		}
		this._contentLabelFactory = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_contentLabelFactory();
	}

	/**
	 * @private
	 */
	private var _contentLabelProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to a content label.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>In the following example, a custom content label properties are
	 * customized:</p>
	 * 
	 * <listing version="3.0">
	 * renderer.contentLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
	 * renderer.contentLabelProperties.embedFonts = true;</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentLabelProperties(get, set):PropertyProxy;
	public function get_contentLabelProperties():PropertyProxy
	{
		if(this._contentLabelProperties == null)
		{
			this._contentLabelProperties = new PropertyProxy(contentLabelProperties_onChange);
		}
		return this._contentLabelProperties;
	}

	/**
	 * @private
	 */
	public function set_contentLabelProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._contentLabelProperties == value)
		{
			return this._contentLabelProperties;
		}
		if(value == null)
		{
			value = new PropertyProxy();
		}
		if(!Std.is(value, PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for(propertyName in Reflect.fields(value.storage))
			{
				Reflect.setField(newValue.storage, propertyName, Reflect.field(value.storage, propertyName));
			}
			value = newValue;
		}
		if(this._contentLabelProperties != null)
		{
			this._contentLabelProperties.removeOnChangeCallback(contentLabelProperties_onChange);
		}
		this._contentLabelProperties = value;
		if(this._contentLabelProperties != null)
		{
			this._contentLabelProperties.addOnChangeCallback(contentLabelProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._contentLabelProperties;
	}

	/**
	 * @private
	 */
	private var originalBackgroundWidth:Float = Math.NaN;

	/**
	 * @private
	 */
	private var originalBackgroundHeight:Float = Math.NaN;

	/**
	 * @private
	 */
	private var currentBackgroundSkin:DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * A background to behind the component's content.
	 *
	 * <p>In the following example, the header renderers is given a
	 * background skin:</p>
	 *
	 * <listing version="3.0">
	 * renderer.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundSkin(get, set):DisplayObject;
	public function get_backgroundSkin():DisplayObject
	{
		return this._backgroundSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundSkin == value)
		{
			return get_backgroundSkin();
		}

		if(this._backgroundSkin != null && this._backgroundSkin != this._backgroundDisabledSkin)
		{
			this.removeChild(this._backgroundSkin);
		}
		this._backgroundSkin = value;
		if(this._backgroundSkin != null && this._backgroundSkin.parent != this)
		{
			this._backgroundSkin.visible = false;
			this.addChildAt(this._backgroundSkin, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_backgroundSkin();
	}

	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * A background to display when the component is disabled.
	 *
	 * <p>In the following example, the header renderers is given a
	 * disabled background skin:</p>
	 *
	 * <listing version="3.0">
	 * renderer.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	public var backgroundDisabledSkin(get, set):DisplayObject;
	public function get_backgroundDisabledSkin():DisplayObject
	{
		return this._backgroundDisabledSkin;
	}

	/**
	 * @private
	 */
	public function set_backgroundDisabledSkin(value:DisplayObject):DisplayObject
	{
		if(this._backgroundDisabledSkin == value)
		{
			return this._backgroundDisabledSkin;
		}

		if(this._backgroundDisabledSkin !=null && this._backgroundDisabledSkin != this._backgroundSkin)
		{
			this.removeChild(this._backgroundDisabledSkin);
		}
		this._backgroundDisabledSkin = value;
		if(this._backgroundDisabledSkin !=null && this._backgroundDisabledSkin.parent != this)
		{
			this._backgroundDisabledSkin.visible = false;
			this.addChildAt(this._backgroundDisabledSkin, 0);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return this._backgroundDisabledSkin;
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * renderer.padding = 20;</listing>
	 *
	 * @default 0
	 */
	public var padding(get, set):Float;
	public function get_padding():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_padding(value:Float):Float
	{
		this.paddingTop = value;
		this.paddingRight = value;
		this.paddingBottom = value;
		this.paddingLeft = value;
		return get_padding();
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The minimum space, in pixels, between the component's top edge and
	 * the component's content.
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * renderer.paddingTop = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingTop(get, set):Float;
	public function get_paddingTop():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_paddingTop(value:Float):Float
	{
		if(this._paddingTop == value)
		{
			return get_paddingTop();
		}
		this._paddingTop = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingTop();
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The minimum space, in pixels, between the component's right edge
	 * and the component's content.
	 *
	 * <p>In the following example, the right padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * renderer.paddingRight = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingRight(get, set):Float;
	public function get_paddingRight():Float
	{
		return this._paddingRight;
	}

	/**
	 * @private
	 */
	public function set_paddingRight(value:Float):Float
	{
		if(this._paddingRight == value)
		{
			return get_paddingRight();
		}
		this._paddingRight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingRight();
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The minimum space, in pixels, between the component's bottom edge
	 * and the component's content.
	 *
	 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * renderer.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 */
	public var paddingBottom(get, set):Float;
	public function get_paddingBottom():Float
	{
		return this._paddingBottom;
	}

	/**
	 * @private
	 */
	public function set_paddingBottom(value:Float):Float
	{
		if(this._paddingBottom == value)
		{
			return get_paddingBottom();
		}
		this._paddingBottom = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingBottom();
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The minimum space, in pixels, between the component's left edge
	 * and the component's content.
	 * 
	 * <p>In the following example, the left padding is set to 20 pixels:</p>
	 * 
	 * <listing version="3.0">
	 * renderer.paddingLeft = 20;</listing>
	 * 
	 * @default 0
	 */
	public var paddingLeft(get, set):Float;
	public function get_paddingLeft():Float
	{
		return this._paddingLeft;
	}

	/**
	 * @private
	 */
	public function set_paddingLeft(value:Float):Float
	{
		if(this._paddingLeft == value)
		{
			return get_paddingLeft();
		}
		this._paddingLeft = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_paddingLeft();
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		//the content may have come from outside of this class. it's up
		//to that code to dispose of the content. in fact, if we disposed
		//of it here, we might screw something up!
		if(this.content != null)
		{
			this.content.removeFromParent();
		}

		//however, we need to dispose these, if they exist, since we made
		//them here.
		if(this.contentImage != null)
		{
			this.contentImage.dispose();
			this.contentImage = null;
		}
		if(this.contentLabel != null)
		{
			cast(this.contentLabel, DisplayObject).dispose();
			this.contentLabel = null;
		}
		super.dispose();
	}

	/**
	 * Uses the content fields and functions to generate content for a
	 * specific group header or footer.
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 */
	private function itemToContent(item:Dynamic):DisplayObject
	{
		var source:Dynamic;
		var labelResult:Dynamic;
		if(this._contentSourceFunction != null)
		{
			source = this._contentSourceFunction(item);
			this.refreshContentSource(source);
			return this.contentImage;
		}
		else if(this._contentSourceField != null && item && item.hasOwnProperty(this._contentSourceField))
		{
			source = Reflect.getProperty(item, this._contentSourceField);
			this.refreshContentSource(source);
			return this.contentImage;
		}
		else if(this._contentLabelFunction != null)
		{
			labelResult = this._contentLabelFunction(item);
			if(Std.is(labelResult, String))
			{
				this.refreshContentLabel(cast(labelResult, String));
			}
			else
			{
				this.refreshContentLabel(labelResult.toString());
			}
			return cast(this.contentLabel, DisplayObject);
		}
		else if(this._contentLabelField != null && item && item.hasOwnProperty(this._contentLabelField))
		{
			labelResult = Reflect.getProperty(item, this._contentLabelField);
			if(Std.is(labelResult, String))
			{
				this.refreshContentLabel(cast(labelResult, String));
			}
			else
			{
				this.refreshContentLabel(labelResult.toString());
			}
			return cast(this.contentLabel, DisplayObject);
		}
		else if(this._contentFunction != null)
		{
			return cast(this._contentFunction(item), DisplayObject);
		}
		else if(this._contentField != null && item && item.hasOwnProperty(this._contentField))
		{
			return cast(Reflect.getProperty(item, this._contentField), DisplayObject);
		}
		else if(Std.is(item, String))
		{
			this.refreshContentLabel(cast(item, String));
			return cast(this.contentLabel, DisplayObject);
		}
		else if(item)
		{
			this.refreshContentLabel(item.toString());
			return cast(this.contentLabel, DisplayObject);
		}

		return null;
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);

		if(stylesInvalid || stateInvalid)
		{
			this.refreshBackgroundSkin();
		}

		if(dataInvalid)
		{
			this.commitData();
		}

		if(dataInvalid || stylesInvalid)
		{
			this.refreshContentLabelStyles();
		}

		if(dataInvalid || stateInvalid)
		{
			this.refreshEnabled();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(dataInvalid || stylesInvalid || sizeInvalid)
		{
			this.layout();
		}

		if(sizeInvalid || stylesInvalid || stateInvalid)
		{
			if(this.currentBackgroundSkin != null)
			{
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
			}
		}
	}

	/**
	 * If the component's dimensions have not been set explicitly, it will
	 * measure its content and determine an ideal size for itself. If the
	 * <code>explicitWidth</code> or <code>explicitHeight</code> member
	 * variables are set, those value will be used without additional
	 * measurement. If one is set, but not the other, the dimension with the
	 * explicit value will not be measured, but the other non-explicit
	 * dimension will still need measurement.
	 *
	 * <p>Calls <code>setSizeInternal()</code> to set up the
	 * <code>actualWidth</code> and <code>actualHeight</code> member
	 * variables used for layout.</p>
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		if(this.content == null)
		{
			return this.setSizeInternal(0, 0, false);
		}
		if(this.contentLabel != null)
		{
			//special case for label to allow word wrap
			var labelMaxWidth:Float = this.explicitWidth;
			if(needsWidth)
			{
				labelMaxWidth = this._maxWidth;
			}
			this.contentLabel.maxWidth = labelMaxWidth - this._paddingLeft - this._paddingRight;
		}
		if(this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY)
		{
			this.content.width = this.explicitWidth - this._paddingLeft - this._paddingRight;
		}
		if(this._verticalAlign == VERTICAL_ALIGN_JUSTIFY)
		{
			this.content.height = this.explicitHeight - this._paddingTop - this._paddingBottom;
		}
		if(Std.is(this.content, IValidating))
		{
			cast(this.content, IValidating).validate();
		}
		var newWidth:Float = this.explicitWidth;
		var newHeight:Float = this.explicitHeight;
		if(needsWidth)
		{
			newWidth = this.content.width + this._paddingLeft + this._paddingRight;
			if(this.originalBackgroundWidth == this.originalBackgroundWidth && //!isNaN
				this.originalBackgroundWidth > newWidth)
			{
				newWidth = this.originalBackgroundWidth;
			}
		}
		if(needsHeight)
		{
			newHeight = this.content.height + this._paddingTop + this._paddingBottom;
			if(this.originalBackgroundHeight == this.originalBackgroundHeight && //!isNaN
				this.originalBackgroundHeight > newHeight)
			{
				newHeight = this.originalBackgroundHeight;
			}
		}
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * @private
	 */
	private function refreshBackgroundSkin():Void
	{
		this.currentBackgroundSkin = this._backgroundSkin;
		if(!this._isEnabled && this._backgroundDisabledSkin != null)
		{
			if(this._backgroundSkin != null)
			{
				this._backgroundSkin.visible = false;
			}
			this.currentBackgroundSkin = this._backgroundDisabledSkin;
		}
		else if(this._backgroundDisabledSkin != null)
		{
			this._backgroundDisabledSkin.visible = false;
		}
		if(this.currentBackgroundSkin != null)
		{
			if(this.originalBackgroundWidth != this.originalBackgroundWidth) //isNaN
			{
				this.originalBackgroundWidth = this.currentBackgroundSkin.width;
			}
			if(this.originalBackgroundHeight != this.originalBackgroundHeight) //isNaN
			{
				this.originalBackgroundHeight = this.currentBackgroundSkin.height;
			}
			this.currentBackgroundSkin.visible = true;
		}
	}

	/**
	 * @private
	 */
	private function commitData():Void
	{
		if(this._owner != null)
		{
			var newContent:DisplayObject = this.itemToContent(this._data);
			if(newContent != this.content)
			{
				if(this.content != null)
				{
					this.content.removeFromParent();
				}
				this.content = newContent;
				if(this.content != null)
				{
					this.addChild(this.content);
				}
			}
		}
		else
		{
			if(this.content != null)
			{
				this.content.removeFromParent();
				this.content = null;
			}
		}
	}

	/**
	 * @private
	 */
	private function refreshContentSource(source:Dynamic):Void
	{
		if(this.contentImage == null)
		{
			this.contentImage = this._contentLoaderFactory();
		}
		this.contentImage.source = source;
	}

	/**
	 * @private
	 */
	private function refreshContentLabel(label:String):Void
	{
		if(label != null)
		{
			if(this.contentLabel == null)
			{
				var factory:Void->ITextRenderer = this._contentLabelFactory != null ? this._contentLabelFactory : FeathersControl.defaultTextRendererFactory;
				this.contentLabel = factory();
				cast(this.contentLabel, FeathersControl).styleNameList.add(this.contentLabelName);
			}
			this.contentLabel.text = label;
		}
		else if(this.contentLabel != null)
		{
			cast(this.contentLabel, DisplayObject).removeFromParent(true);
			this.contentLabel = null;
		}
	}

	/**
	 * @private
	 */
	private function refreshEnabled():Void
	{
		if(Std.is(this.content, IFeathersControl))
		{
			cast(this.content, IFeathersControl).isEnabled = this._isEnabled;
		}
	}

	/**
	 * @private
	 */
	private function refreshContentLabelStyles():Void
	{
		if(this.contentLabel == null || this._contentLabelProperties == null)
		{
			return;
		}
		for(propertyName in Reflect.fields(this._contentLabelProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._contentLabelProperties.storage, propertyName);
			Reflect.setProperty(this.contentLabel, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function layout():Void
	{
		if(this.content == null)
		{
			return;
		}

		if(this.contentLabel != null)
		{
			this.contentLabel.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight;
		}
		switch(this._horizontalAlign)
		{
			case HORIZONTAL_ALIGN_CENTER:
			{
				this.content.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.content.width) / 2;
				//break;
			}
			case HORIZONTAL_ALIGN_RIGHT:
			{
				this.content.x = this.actualWidth - this._paddingRight - this.content.width;
				//break;
			}
			case HORIZONTAL_ALIGN_JUSTIFY:
			{
				this.content.x = this._paddingLeft;
				this.content.width = this.actualWidth - this._paddingLeft - this._paddingRight;
				//break;
			}
			default: //left
			{
				this.content.x = this._paddingLeft;
			}
		}

		switch(this._verticalAlign)
		{
			case VERTICAL_ALIGN_TOP:
			{
				this.content.y = this._paddingTop;
				//break;
			}
			case VERTICAL_ALIGN_BOTTOM:
			{
				this.content.y = this.actualHeight - this._paddingBottom - this.content.height;
				//break;
			}
			case VERTICAL_ALIGN_JUSTIFY:
			{
				this.content.y = this._paddingTop;
				this.content.height = this.actualHeight - this._paddingTop - this._paddingBottom;
				//break;
			}
			default: //middle
			{
				this.content.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.content.height) / 2;
			}
		}

	}

	/**
	 * @private
	 */
	private function contentLabelProperties_onChange(proxy:PropertyProxy, name:String):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}
}
