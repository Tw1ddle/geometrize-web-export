package src.reader;

import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr.Access.APublic;
import haxe.macro.Expr.Access.AStatic;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType.FVar;

import src.reader.FileReader;
import src.shape.Shape;

/**
 * Reads shape data at compile time and embeds it in the program
 * @author Sam Twidale (http://samcodes.co.uk/)
 */
class ShapeEmbedder {
	// Reads the given file and builds a type containing a static array containing the shape data
	public static function buildFromJson(filePath:String):Array<Field> {
		var fields = Context.getBuildFields();
		
		try {
			var data = FileReader.readFileAsString(filePath);
			
			// TODO get this working and support other formats
			
			var path = new Path(jsonFilePath);
			var name = path.file;
			var shapes:Array<Shape> = ShapeJsonReader.readJson(data);
			
			var field = {
				name: name,
				doc: null,
				meta: [],
				access: [APublic, AStatic],
				kind: FVar(macro:Array<String>, macro $v{shapes}),
				pos: Context.currentPos()
			}
			
			fields.push(field);
			
		} catch (e:Dynamic) {
			Context.error('Failed to find file $filePath: $e', Context.currentPos());
		}
		
		return fields;
	}
}