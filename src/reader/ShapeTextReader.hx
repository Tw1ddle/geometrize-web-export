package src.reader;

import src.shape.Shape;
import src.shape.ShapeTypes;

/**
 * Reads text data that describes shapes and converts it into data structures for convenient access at runtime
 * @author Sam Twidale (http://samcodes.co.uk/)
 */
@:keep
class ShapeTextReader {
	public static function readShapeData(data:String):Array<Shape> {
		var shapes = new Array<Shape>();
		
		var lines = data.split("\n");
		var i:Int = 0;
		while (i < lines.length) {
			var type:ShapeTypes = Std.parseInt(lines[i]);
			var data:Array<String> = lines[i + 1].split(",");
			var numericData:Array<Int> = new Array<Int>();
			for (s in data) {
				numericData.push(Std.parseInt(s));
			}
			
			var shape:Shape = new Shape(type, numericData, lines[i + 2]);
			shapes.push(shape);
			
			i += 3;
		}
		
		return shapes;
	}
}