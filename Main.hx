package;

import haxe.Http;
import haxe.io.Path;
import js.Browser;
import js.html.Element;
import src.reader.ShapeEmbedder;
import src.reader.ShapeJsonReader;

import src.shape.Shape;
import src.shape.ShapeTypes;
import src.shape.abstracts.Rectangle;

#if backend_canvas
import src.renderer.CanvasRenderer;
#elseif backend_threejs
import src.renderer.ThreeJsRenderer;
#end

using StringTools;

#if test_backend
@:build(src.reader.ShapeEmbedder.buildDirectory("bin/assets/"))
#end
@:keep
class EmbeddedShapeData
{
}

/**
 * Encapsulates geometrized images (shapes) and a renderer that draws the data
 */
class GeometrizeWidget
{
	public static inline var GEOMETRIZE_WIDGET_TYPE_NAME:String = "geometrize_widget"; // Used for finding widgets on HTML pages or UI layouts
	
	private var shapes:Array<Shape> = [];
	
	// The renderer that draws the shapes
	#if backend_canvas
	private var renderer:CanvasRenderer;
	#elseif backend_threejs
	private var renderer:ThreeJsRenderer;
	#else
	#error "No renderer defined"
	#end
	
	/**
	 * Creates a new widget
	 * @param	shapes The shapes that will be rendered within the widget
	 * @param	attachmentPointId A unique id for the object to which the widget shall be attached
	 */
	public inline function new(shapes:Array<Shape>, attachmentPointId:String) {
		this.shapes = shapes;
		
		// NOTE should calculate intrinsic size from max extents of the shapes, or include that somewhere in the data
		// For now require the first shape is the rectangular "background" and defines the size of the renderer window
		var getSize = function(shape:Shape) {
			if (shape.type != ShapeTypes.RECTANGLE) {
				return { x : 0, y : 0 };
			}
			
			var rect:Rectangle = cast shape.data;
			return { x: (rect.x2 - rect.x1), y: (rect.y2 - rect.y1) };
		};
		var size = getSize(shapes[0]);
		
		#if backend_canvas
		renderer = new CanvasRenderer(attachmentPointId, size.x, size.y);
		#elseif backend_threejs
		renderer = new ThreeJsRenderer(attachmentPointId, size.x, size.y);
		#end
	}
	
	public inline function render(dt:Float) {
		renderer.render(shapes);
	}
}

/**
 * Code for drawing Geometrized images using different rendering backends
 * @author Sam Twidale (https://samcodes.co.uk/)
 */
class Main
{
	private static inline var WEBSITE_URL:String = "https://geometrize.co.uk/"; // Geometrize website URL
	private static inline var SHAPE_DATA_SOURCE_TAG:String = "data-source";
	private static inline var SHAPE_DATA_EMBEDDED_TAG:String = "data-embedded";
	
	private var widgets:Array<GeometrizeWidget> = [];
	
	private static function main():Void {
		var main = new Main();
	}
	
	private inline function new() {
		createWidgets(Browser.document.documentElement);
	}
	
	/**
	 * Creates all of the Geometrize shape widgets below the given element on the page
	 * @param	root The root element to search under for Geometrize shape widgets to create
	 */
	private inline function createWidgets(root:Element):Void {
		var elements = root.getElementsByClassName(GeometrizeWidget.GEOMETRIZE_WIDGET_TYPE_NAME);
		
		for (element in elements) {
			var dataEmbeddedElement = element.attributes.getNamedItem(SHAPE_DATA_EMBEDDED_TAG);
			if (dataEmbeddedElement == null) {
				continue;
			}
			
			var data:String = dataEmbeddedElement.value;
			if (data.length == 0) {
				continue;
			}
			
			loadShapeData(data, element.id);
		}
		
		for (element in elements) {
			var dataSourceElement = element.attributes.getNamedItem(SHAPE_DATA_SOURCE_TAG);
			if (dataSourceElement == null) {
				continue;
			}
			
			var dataSource:String = dataSourceElement.value;
			if (dataSource.length == 0) {
				continue;
			}
			
			loadShapeDataFromSource(dataSource, element.id);
		}
	}
	
	/**
	 * Adds a Geometrize widget, rendering it once
	 * @param	widget The widget to add to the page
	 */
	private inline function addWidget(widget:GeometrizeWidget):Void {
		widget.render(0);
		widgets.push(widget);
	}
	
	/**
	 * Attempts to load shape data directly from a string and creates a widget from that data.
	 * @param	data The shape data
	 * @param	attachmentPointId The id of the element to attach the widget to
	 */
	private inline function loadShapeData(data:String, attachmentPointId:String):Void {
		var shapes:Array<Shape> = ShapeJsonReader.shapesFromJson(data);
		addWidget(new GeometrizeWidget(shapes, attachmentPointId));
	}
	
	/**
	 * Attempts to load JSON shape data from a source and create a widget from that data
	 * @param	source The URL or file path to request shape data from
	 * @param	attachmentPointId The id of the element to attach the widget to
	 */
	private inline function loadShapeDataFromSource(source:String, attachmentPointId:String):Void {
		// If the data is embedded in the embedded shape data class
		var path:Path = new Path(source);
		var s:String = ShapeEmbedder.toVarName(path.file + "_" + path.ext);
		if (Reflect.hasField(EmbeddedShapeData, s)) {
			var shapes:Array<Shape> = Reflect.field(EmbeddedShapeData, s);
			addWidget(new GeometrizeWidget(shapes, attachmentPointId));
			return;
		}
		
		// Data is a local file or web resource, request it
		requestData(source,
		function(data:String) {
			var shapes:Array<Shape> = ShapeJsonReader.shapesFromJson(data);
			addWidget(new GeometrizeWidget(shapes, attachmentPointId));
		},
		function(error:String) {
			trace(error);
		});
	}
	
	/**
	 * Loads data pointed to at the given URL
	 * @param	url The URL of the data to load
	 * @param	onData Callback triggered if the data is received
	 * @param	onError Callback triggered if the data is not received due to an error
	 */
	private static inline function requestData(url:String, onData:String->Void, onError:String->Void):Void {
		var http = new haxe.Http(url);
		http.onData = onData;
		http.onError = onError;
		http.request();
	}
}