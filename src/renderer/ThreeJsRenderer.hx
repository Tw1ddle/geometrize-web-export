#if backend_threejs

package src.renderer;
import src.shape.abstracts.Triangle;
import src.shape.abstracts.Rectangle;

import js.Browser;
import js.html.DivElement;
import js.three.Geometry;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.Object3D;
import js.three.OrthographicCamera;
import js.three.PlaneGeometry;
import js.three.Scene;
import js.three.WebGLRenderer;
import src.shape.Shape;
import src.shape.ShapeTypes;
import js.three.Vector3;
import js.three.Face3;

/**
 * Code for rendering geometrized images with three.js.
 * @author Sam Twidale (http://samcodes.co.uk/)
 */
@:keep
class ThreeJsRenderer {
	var camera:OrthographicCamera;
	var renderer:WebGLRenderer = new WebGLRenderer();
	var scene:Scene = new Scene();
	var meshes:Object3D = new Object3D();
	
	public function new() {
		var container:DivElement = cast Browser.window.document.getElementById("basic_logo_container"); // TODO make this less broken
		
		renderer.setClearColor(0xFFFFFF, 1); // TODO
		renderer.setSize(800, 600); // TODO make this less broken
		
		container.appendChild(renderer.domElement);
		
		camera = new OrthographicCamera(0, 800, 0, 600, 0, 1000);
		camera.position.set(200, 100, 200);
		camera.position.set(0, 0, 200);
		camera.lookAt(scene.position);
		scene.add(camera);
		scene.add(meshes);
	}
	
	public function render(shapes:Array<Shape>) {
		for (shape in shapes) {
			switch(shape.type) {
				case ShapeTypes.RECTANGLE:
					addRectangle(shape);
				case ShapeTypes.ROTATED_RECTANGLE:
					addRotatedRectangle(shape);
				case ShapeTypes.TRIANGLE:
					addTriangle(shape);
				case ShapeTypes.ELLIPSE:
					addEllipse(shape);
				case ShapeTypes.ROTATED_ELLIPSE:
					addRotatedEllipse(shape);
				case ShapeTypes.CIRCLE:
					addCircle(shape);
				case ShapeTypes.LINE:
					addLine(shape);
				case ShapeTypes.QUADRATIC_BEZIER:
					addQuadraticBezier(shape);
				case ShapeTypes.POLYLINE:
					addPolyline(shape);
				default:
					throw "Encountered unsupported shape type";
			}
		}
		
		renderer.render(scene, camera);
		
		clearScene();
	}
	
	private inline function addRectangle(s:Shape) {
		var geometry = new PlaneGeometry(s.data[2] - s.data[0], s.data[3] - s.data[1]);
		var mesh = makeMesh(geometry, s.color);
		mesh.position.set(s.data[0] + ((s.data[2] - s.data[0]) / 2), s.data[1] + ((s.data[3] - s.data[1]) / 2), 4.0);
		meshes.add(mesh);
	}
	
	private inline function addRotatedRectangle(s:Shape) {
		var geometry = new PlaneGeometry(s.data[2] - s.data[0], s.data[3] - s.data[1]);
		var mesh = makeMesh(geometry, s.color);
		mesh.rotation.z = s.data[4] * 3.141 / 180.0;
		mesh.position.set(s.data[0] + ((s.data[2] - s.data[0]) / 2), s.data[1] + ((s.data[3] - s.data[1]) / 2), 4.0);
		meshes.add(mesh);
	}
	
	private inline function addTriangle(s:Shape) {
		var geometry = new Geometry();
		geometry.vertices.push(new Vector3(s.data[0], s.data[1], 0));
		geometry.vertices.push(new Vector3(s.data[2], s.data[3], 0));
		geometry.vertices.push(new Vector3(s.data[4], s.data[5], 0));
		geometry.faces.push(new Face3(0, 1, 2));
		var mesh = makeMesh(geometry, s.color);
		meshes.add(mesh);
	}
	
	private inline function addEllipse(s:Shape) {

	}
	
	private inline function addRotatedEllipse(s:Shape) {

	}
	
	private inline function addCircle(s:Shape) {

	}
	
	private inline function addLine(s:Shape) {

	}
	
	private inline function addQuadraticBezier(s:Shape) {

	}
	
	private inline function addPolyline(s:Shape) {

	}
	
	private inline function clearScene() {
		for (mesh in meshes.children) {
			var m:Mesh = cast mesh;
			var g:Geometry = cast m.geometry;
			g.dispose();
			
			m.material.dispose();
		}
		
		meshes = new Object3D();
	}
	
	// Creates a material from an RGBA8888 color value
	private inline function makeMaterial(color:Int):MeshBasicMaterial {
		var rgb:Int = color >> 8;
		
		if (color & 0xFF == 0xFF) {
			return new MeshBasicMaterial({color:rgb, side:js.Three.DoubleSide});
		}
		var opacity:Float = (color & 0xFF) / 255.0;
		return new MeshBasicMaterial({color:rgb, transparent:true, opacity:opacity, side:js.Three.DoubleSide});
	}
	
	private inline function makeMesh(geometry:Geometry, color:Int):Mesh {
		return new Mesh(geometry, makeMaterial(color));
	}
}

#end