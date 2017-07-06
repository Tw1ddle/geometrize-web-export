package;

import js.Browser;
import src.reader.FileReader;
import src.reader.ShapeJsonReader;
import src.renderer.CanvasRenderer;
import src.renderer.ThreeJsRenderer;
import src.shape.Shape;

/**
 * Example code for displaying Geometrized shapes using different rendering backends
 * @author Sam Twidale (http://samcodes.co.uk/)
 */
class Main {
	private static inline var WEBSITE_URL:String = "http://geometrize.co.uk/"; // Geometrize website URL
	
	#if backend_canvas
	private var renderer:CanvasRenderer = new CanvasRenderer();
	#elseif backend_threejs
	private var renderer:ThreeJsRenderer = new ThreeJsRenderer();
	#else
	#error "No renderer defined"
	#end
	
	private var data = readShapeData();
	
	static private function __init__():Void {
		#if backend_canvas
		// No dependencies
		#elseif backend_threejs
		embed.Js.from('http://cdnjs.cloudflare.com/ajax/libs/three.js/83/three.min.js');
		#else
		#error "No backend defined. Make sure one of the backends is being targeted in the .hxml"
		#end
	}
	
	private static function main():Void {
		var main = new Main();
	}
	
	private inline function new() {
		Browser.window.onload = onWindowLoaded;
	}

	private inline function onWindowLoaded():Void {
		animate();
	}
	
	/**
	 * Main update loop.
	 */
	private function animate():Void {
		var nextFrameDelay = Std.int((1.0 / 30.0) * 1000.0); // Per-frame delay to avoid burning CPU
		
		step(50);
		
		Browser.window.setTimeout(function():Void {
			this.animate();
		}, nextFrameDelay);
	}
	
	private function step(dt:Float):Void {
		// TODO add profiling flag/option for measuring this
		renderer.render(data);
	}
	
	// TODO make demo target-dependent
	private static function readShapeData():Array<Shape> {
		return ShapeJsonReader.shapesFromJson(FileReader.readFileAsString("bin/assets/test.json"));
	}
}