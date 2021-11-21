#if backend_canvas

package src.renderer;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import src.shape.Rgba;
import src.shape.Shape;
import src.shape.ShapeTypes;
import src.shape.abstracts.Circle;
import src.shape.abstracts.Ellipse;
import src.shape.abstracts.Line;
import src.shape.abstracts.Polyline;
import src.shape.abstracts.QuadraticBezier;
import src.shape.abstracts.Rectangle;
import src.shape.abstracts.RotatedEllipse;
import src.shape.abstracts.RotatedRectangle;
import src.shape.abstracts.Triangle;

/**
 * Code for rendering geometrized images with HTML5 Canvas.
 * @author Sam Twidale (https://samcodes.co.uk/)
 */
@:keep
class CanvasRenderer
{
	private var canvas:CanvasElement;
	private var ctx:CanvasRenderingContext2D;
	
	public function new(containerId:String, intrinsicWidth:Int, intrinsicHeight:Int) {
		var container:DivElement = cast Browser.window.document.getElementById(containerId);
		canvas = Browser.window.document.createCanvasElement();
		canvas.width = intrinsicWidth;
		canvas.height = intrinsicHeight;
		canvas.className = Renderer.GEOMETRIZE_CANVAS_TYPE_NAME;
		ctx = canvas.getContext2d();
		
		container.appendChild(canvas);
	}
	
	public function render(shapes:Array<Shape>) {
		ctx.clearRect(0, 0, canvas.width, canvas.height);
		
		for (shape in shapes) {
			switch(shape.type) {
				case ShapeTypes.RECTANGLE:
					drawRectangle(shape.data, shape.color);
				case ShapeTypes.ROTATED_RECTANGLE:
					drawRotatedRectangle(shape.data, shape.color);
				case ShapeTypes.TRIANGLE:
					drawTriangle(shape.data, shape.color);
				case ShapeTypes.ELLIPSE:
					drawEllipse(shape.data, shape.color);
				case ShapeTypes.ROTATED_ELLIPSE:
					drawRotatedEllipse(shape.data, shape.color);
				case ShapeTypes.CIRCLE:
					drawCircle(shape.data, shape.color);
				case ShapeTypes.LINE:
					drawLine(shape.data, shape.color);
				case ShapeTypes.QUADRATIC_BEZIER:
					drawQuadraticBezier(shape.data, shape.color);
				case ShapeTypes.POLYLINE:
					drawPolyline(shape.data, shape.color);
				default:
					throw "Encountered unsupported shape type";
			}
		}
	}
	
	private inline function drawRectangle(g:Rectangle, c:Rgba) {
		ctx.fillStyle = c.toRgbaAttrib();
		
		ctx.fillRect(g.x1, g.y1, g.x2 - g.x1, g.y2 - g.y1);
	}
	
	private inline function drawRotatedRectangle(g:RotatedRectangle, c:Rgba) {
		ctx.fillStyle = c.toRgbaAttrib();
		
		ctx.save();
		ctx.translate(g.x1 + (g.x2 - g.x1) / 2, g.y1 + (g.y2 - g.y1) / 2);
		ctx.rotate(g.angle * (Math.PI/180));
		ctx.fillRect(-(g.x2 - g.x1) / 2, -(g.y2 - g.y1) / 2, g.x2 - g.x1, g.y2 - g.y1);
		ctx.restore();
	}
	
	private inline function drawTriangle(g:Triangle, c:Rgba) {
		ctx.fillStyle = c.toRgbaAttrib();
		
		ctx.beginPath();
		ctx.moveTo(g.x1, g.y1);
		ctx.lineTo(g.x2, g.y2);
		ctx.lineTo(g.x3, g.y3);
		ctx.lineTo(g.x1, g.y1);
		ctx.fill();
	}
	
	private inline function drawEllipse(g:Ellipse, c:Rgba) {
		ctx.fillStyle = c.toRgbaAttrib();
		
		ctx.beginPath();
		ctx.ellipse(g.x, g.y, g.rx, g.ry, 0, 0, 360);
		ctx.fill();
	}
	
	private inline function drawRotatedEllipse(g:RotatedEllipse, c:Rgba) {
		ctx.fillStyle = c.toRgbaAttrib();
		
		ctx.beginPath();
		ctx.ellipse(g.x, g.y, g.rx, g.ry, g.angle * (Math.PI/180), 0, 360);
		ctx.fill();
	}
	
	private inline function drawCircle(g:Circle, c:Rgba) {
		ctx.fillStyle = c.toRgbaAttrib();
		
		ctx.beginPath();
		ctx.arc(g.x, g.y, g.r, 0, 2 * Math.PI);
		ctx.fill();
	}
	
	private inline function drawLine(g:Line, c:Rgba) {
		ctx.strokeStyle = c.toRgbaAttrib();
		
		ctx.beginPath();
		ctx.moveTo(g.x1, g.y1);
		ctx.lineTo(g.x2, g.y2);
		ctx.stroke();
	}
	
	private inline function drawQuadraticBezier(g:QuadraticBezier, c:Rgba) {
		ctx.strokeStyle = c.toRgbaAttrib();
		
		ctx.beginPath();
		ctx.moveTo(g.x1, g.y1);
		ctx.quadraticCurveTo(g.cx, g.cy, g.x2, g.y2);
		ctx.stroke();
	}
	
	private inline function drawPolyline(g:Polyline, c:Rgba) {
		ctx.strokeStyle = c.toRgbaAttrib();
		
		ctx.beginPath();
		var i:Int = 0;
		while (i < g.length - 1) {
			ctx.lineTo(g.get(i), g.get(i + 1));
			i += 2;
		}
		ctx.stroke();
	}
}

#end