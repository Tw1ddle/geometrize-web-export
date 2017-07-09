package src.renderer;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import src.shape.Shape;
import src.shape.ShapeTypes;

/**
 * Code for rendering geometrized images with HTML5 Canvas.
 * @author Sam Twidale (http://samcodes.co.uk/)
 */
@:keep
class CanvasRenderer {
	private var canvas:CanvasElement;
	private var ctx:CanvasRenderingContext2D;
	
	public function new() {
		canvas = cast Browser.window.document.getElementById("basic_logo"); // TODO make this less broken
		ctx = canvas.getContext2d();
		
		canvas.width  = 800;
		canvas.height = 600; // TODO either get size from shapes, or size appropriately?
	}
	
	public function render(shapes:Array<Shape>) {
		ctx.clearRect(0, 0, canvas.width, canvas.height);
		
		for (shape in shapes) {
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
		ctx.fillStyle = colorToRgbaAttrib(s.color);
		
		ctx.fillRect(s.data[0], s.data[1], s.data[2] - s.data[0], s.data[3] - s.data[1]);
	}
	
	private inline function drawRotatedRectangle(s:Shape) {
		ctx.fillStyle = colorToRgbaAttrib(s.color);
		
		ctx.save();
		ctx.translate(s.data[0] + (s.data[2] - s.data[0]) / 2, s.data[1] + (s.data[3] - s.data[1]) / 2);
		ctx.rotate(s.data[4] * (Math.PI/180));
		ctx.fillRect(-(s.data[2] - s.data[0]) / 2, -(s.data[3] - s.data[1]) / 2, s.data[2] - s.data[0], s.data[3] - s.data[1]);
		ctx.restore();
	}
	
	private inline function drawTriangle(s:Shape) {
		ctx.fillStyle = colorToRgbaAttrib(s.color);
		
		ctx.beginPath();
		ctx.moveTo(s.data[0], s.data[1]);
		ctx.lineTo(s.data[2], s.data[3]);
		ctx.lineTo(s.data[4], s.data[5]);
		ctx.lineTo(s.data[0], s.data[1]);
		ctx.fill();
	}
	
	private inline function drawEllipse(s:Shape) {
		ctx.fillStyle = colorToRgbaAttrib(s.color);
		
		ctx.beginPath();
		ctx.ellipse(s.data[0], s.data[1], s.data[2], s.data[3], 0, 0, 360);
		ctx.fill();
	}
	
	static var x:Float = 0;
	private inline function drawRotatedEllipse(s:Shape) {
		ctx.fillStyle = colorToRgbaAttrib(s.color);
		
		ctx.beginPath();
		ctx.ellipse(s.data[0], s.data[1], s.data[2], s.data[3], s.data[4] * (Math.PI/180), 0, 360);
		ctx.fill();
	}
	
	private inline function drawCircle(s:Shape) {
		ctx.fillStyle = colorToRgbaAttrib(s.color);
		
		ctx.beginPath();
		ctx.arc(s.data[0], s.data[1], s.data[2], 0, 2 * Math.PI);
		ctx.fill();
	}
	
	private inline function drawLine(s:Shape) {
		ctx.strokeStyle = colorToRgbaAttrib(s.color);
		
		ctx.beginPath();
		ctx.moveTo(s.data[0], s.data[1]);
		ctx.lineTo(s.data[2], s.data[3]);
		ctx.stroke();
	}
	
	private inline function drawQuadraticBezier(s:Shape) {
		ctx.strokeStyle = colorToRgbaAttrib(s.color);
		
		ctx.beginPath();
		ctx.moveTo(s.data[0], s.data[1]);
		ctx.quadraticCurveTo(s.data[2], s.data[3], s.data[4], s.data[5]);
		ctx.stroke();
	}
	
	private inline function drawPolyline(s:Shape) {
		ctx.strokeStyle = colorToRgbaAttrib(s.color);
		
		ctx.beginPath();
		var i:Int = 0;
		while (i < s.data.length - 1) {
			ctx.lineTo(s.data[i], s.data[i + 1]);
			i += 2;
		}
		ctx.stroke();
	}
	
	// NOTE this is a bit horrible, could maybe precreate these
	private inline function colorToRgbaAttrib(color:Int):String {
		return "rgba(" + ((color >> 24) & 0xFF) + "," + ((color >> 16) & 0xFF) + "," + ((color >> 8) & 0xFF) + "," + ((color & 0xFF) / 255) + ")";
	}
}