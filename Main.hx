package;

import js.Browser;

/**
 * Code for rendering shapes using various backends
 * @author Sam Twidale (http://samcodes.co.uk/)
 */
class Main {
	private static inline var GEOMETRY_DATA_PLACEHOLDER:String = "::GEOMETRY_DATA_PLACEHOLDER::"; // The token that will be replaced by geometry data in the test/export process
	private static inline var GEOMETRY_METADATA_PLACEHOLDER:String = "::GEOMETRY_METADATA_PLACEHOLDER::"; // The token that will be replaced by metadata about the exported data in the test/export process
	
	private static inline var WEBSITE_URL:String = "http://geometrize.co.uk/"; // Geometrize website URL
	
	private static inline var maxFps:Float = 30.0; // Render framerate cap
	
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
		var nextFrameDelay = Std.int((1.0 / Main.maxFps) * 1000.0);
		
		step(50);
		
		Browser.window.setTimeout(function():Void {
			this.animate();
		}, nextFrameDelay);
	}
	
	private function step(dt:Float):Void {
		
	}
}