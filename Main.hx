package;

import js.Browser;

class Main {
	private static inline var GEOMETRY_DATA_PLACEHOLDER:String = "::GEOMETRY_DATA_PLACEHOLDER::"; // The token that will be replaced by geometry data in the test/export process
	private static inline var GEOMETRY_METADATA_PLACEHOLDER:String = "::GEOMETRY_METADATA_PLACEHOLDER::"; // The token that will be replaced by metadata about the exported data in the test/export process
	
	private static inline var WEBSITE_URL:String = "http://geometrize.co.uk/"; // Geometrize website URL
	
	private static function main():Void {
		var main = new Main();
	}
	
	private inline function new() {
		Browser.window.onload = onWindowLoaded;
	}

	private inline function onWindowLoaded():Void {
		// TODO
	}
}