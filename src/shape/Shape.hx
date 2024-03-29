package src.shape;

/**
 * Compact representation of data about a Geometrize shape used by renderers
 * @author Sam Twidale (https://samcodes.co.uk/)
 */
@:keep
typedef Shape = {
	var type:ShapeTypes; // Shape type id
	var color:Rgba; // RGBA8888 color
	var data:Array<Int>; // Geometry data, has a different structure per shape type
}