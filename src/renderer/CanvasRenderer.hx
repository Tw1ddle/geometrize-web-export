package src.renderer;

import js.Browser;
import js.html.Document;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

import src.shape.Shape;
import src.shape.ShapeTypes;

/**
 * Code for rendering shapes using HTML5 Canvas.
 * @author Sam Twidale (http://samcodes.co.uk/)
 */
@:keep
class CanvasRenderer {
	private var canvas:CanvasElement;
	private var context:CanvasRenderingContext2D;
	
	public function new() {
		canvas = cast Browser.window.document.getElementById("basic_logo"); // TODO make this less broken
		context = canvas.getContext2d();
		
		canvas.width  = 800;
		canvas.height = 600; // TODO
	}
	
	public function render(shapes:Array<Shape>) {
		for (shape in shapes) {
			context.fillStyle = colorToRgbaAttrib(shape.color);
			
			switch(shape.type) {
				case ShapeTypes.RECTANGLE:
					drawRectangle(shape);
				case ShapeTypes.ROTATED_RECTANGLE:
					drawRotatedRectangle(shape);
				case ShapeTypes.TRIANGLE:
					drawTriangle(shape);
				case ShapeTypes.ELLIPSE:
					drawEllipse(shape);
				case ShapeTypes.ROTATED_ELLIPSE:
					drawRotatedEllipse(shape);
				case ShapeTypes.CIRCLE:
					drawCircle(shape);
				case ShapeTypes.LINE:
					drawLine(shape);
				case ShapeTypes.QUADRATIC_BEZIER:
					drawQuadraticBezier(shape);
				case ShapeTypes.POLYLINE:
					drawPolyline(shape);
				default:
					throw "Encountered unsupported shape type";
			}
		}
	}
	
	private inline function drawRectangle(s:Shape) {
		
		context.strokeRect(s.data[0], s.data[1], s.data[2], s.data[3]);
	}
	
	private inline function drawRotatedRectangle(s:Shape) {
		
	}
	
	private inline function drawTriangle(s:Shape) {
		context.beginPath();
		context.moveTo(s.data[0], s.data[1]);
		context.lineTo(s.data[2], s.data[3]);
		context.lineTo(s.data[4], s.data[5]);
		context.lineTo(s.data[0], s.data[1]);
		context.fill();
	}
	
	private inline function drawEllipse(s:Shape) {
		
	}
	
	private inline function drawRotatedEllipse(s:Shape) {
		
	}
	
	private inline function drawCircle(s:Shape) {
		
	}
	
	private inline function drawLine(s:Shape) {
		
	}
	
	private inline function drawQuadraticBezier(s:Shape) {
		
	}
	
	private inline function drawPolyline(s:Shape) {
		
	}
	
	// TODO this is a bit horrible
	private inline function colorToRgbaAttrib(color:Int):String {
		return "rgba(" + ((color >> 24) & 0xFF) + "," + ((color >> 16) & 0xFF) + "," + ((color >> 8) & 0xFF) + "," + ((color & 0xFF) / 255) + ")";
	}
}