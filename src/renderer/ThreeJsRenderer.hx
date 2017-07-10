#if backend_threejs

package src.renderer;

import js.Browser;
import js.html.DivElement;
import js.three.Face3;
import js.three.Geometry;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.PerspectiveCamera;
import js.three.Scene;
import js.three.Vector3;
import js.three.WebGLRenderer;
import src.shape.Shape;
import src.shape.ShapeTypes;

/**
 * Code for rendering geometrized images with three.js.
 * @author Sam Twidale (http://samcodes.co.uk/)
 */
@:keep
class ThreeJsRenderer {
	var camera:PerspectiveCamera;
	var renderer:WebGLRenderer = new WebGLRenderer();
	var scene:Scene = new Scene();
	
	public function new() {
		var container:DivElement = cast Browser.window.document.getElementById("basic_logo_container"); // TODO make this less broken
		
		renderer.setClearColor(0x000000, 1); // TODO
		renderer.setSize(800, 600); // TODO make this less broken
		
		container.appendChild(renderer.domElement);
		
		camera = new PerspectiveCamera(45, 800 / 600, 1, 100);
		camera.position.set(0, 0, 10);
		camera.lookAt(scene.position);
		
		scene.add(camera);
		
		// TODO some test code to get something rendering
		var triangleGeometry = new Geometry();
		triangleGeometry.vertices.push(new Vector3(0.0, 1.0, 0.0));
		triangleGeometry.vertices.push(new Vector3(-1.0, -1.0, 0.0));
		triangleGeometry.vertices.push(new Vector3(1.0, -1.0, 0.0));
		triangleGeometry.faces.push(new Face3(0, 1, 2));
		
		var triangleMaterial = new MeshBasicMaterial({color:0xFFFFFF});
		
		var triangleMesh = new Mesh(triangleGeometry, triangleMaterial);
		
		triangleMesh.position.set( -1.5, 0.0, 4.0);
		
		scene.add(triangleMesh);
	}
	
	public function render(shapes:Array<Shape>) {
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
		
		renderer.render(scene, camera);
	}
	
	private inline function drawRectangle(s:Shape) {

	}
	
	private inline function drawRotatedRectangle(s:Shape) {

	}
	
	private inline function drawTriangle(s:Shape) {

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
}

#end