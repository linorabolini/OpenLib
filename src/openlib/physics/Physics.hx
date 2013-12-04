package openlib.physics;

import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import flash.display.Sprite;
import flash.Lib;


import nape.util.ShapeDebug;


/**
 * ...
 * @author
 */

class Physics 
{
	public var space:Space;							// world reference
	public var iterations:Int; 						// world step iterations
	static private inline var DEFAULT_ITERATIONS:Int = 10;	// delfault interations
	
	public var debugDraw:Bool;
	public var debug:ShapeDebug;

	
	public function new() 
	{
		// set the debug draw to false
		debugDraw = false;
	}
	
	/**
	 * Create the world
	 * @param	gravity
	 */
	public function createWorld(gravity:Vec2) 
	{
		// dispose if already created
		disposeWorld();
		
		// create a new world
		space = new Space(gravity);
		
		// set the iterations to default
		iterations = DEFAULT_ITERATIONS;
	}
	
	/**
	 * Debug draw / only flash 
	 * @param	width
	 * @param	height
	 */
	public function setupDebugDraw(width:Float, height:Float) 
	{
		debug = new ShapeDebug(Math.floor(width),Math.floor(height));
		Lib.current.stage.addChild(debug.display);
		debug.drawConstraints = true;
		debugDraw = true;
	}
	
	/**
	 * Dispose the space
	 */
	public function disposeWorld() 
	{
		// if doesnt exist return
		if (space == null) return;
		
		// dispose the world
		space.clear();
		space = null;
	}
	
	public function dispose()
	{
		disposeWorld();
	}
	
	/**
	 * Update
	 * @param	dt
	 */
	public function update(dt:Float) 
	{
		space.step(dt, iterations, iterations);
		
		if (debugDraw) 
		{
			debug.clear();
			debug.draw(space);
			debug.flush();
		}
	}
	
	/**
	 * Basic function to create a standard Box
	 * @param	x
	 * @param	y
	 * @param	w
	 * @param	h
	 * @param	type
	 * @param	group
	 * @return
	 */
	public function createBox(x:Float, y:Float, w:Float, h:Float, type:BodyType, group:Int, ?collisionMask:Int): Body {
		
		// create the box
		var box:Body = new Body(type);
		
		//setup shape
		var shape:Polygon = new Polygon(Polygon.box(w, h));
		
		// default collide with everithing but the same group
		if (collisionMask == null)
			collisionMask = ~group;
		
		shape.filter.collisionGroup = group;
		shape.filter.collisionMask = collisionMask;
		
		// setup the body with the shape
		box.shapes.add(shape);
		box.position.setxy(x, y);
		box.space = space;
		
		return box;
	}
	
	/**
	 * Basic function to create a standard circle
	 * @param	x
	 * @param	y
	 * @param	r
	 * @param	type
	 * @param	group
	 * @return
	 */
	public function createCircle(x:Float, y:Float, r:Float, type:BodyType, group:Int, ?collisionMask:Int): Body {
		// create the body
        var ball:Body = new Body(type);
		
		//setup shape
		var shape:Circle = new Circle(r);
		
		// default collide with everithing but the same group
		if (collisionMask == null)
			collisionMask = ~group;
		
		shape.filter.collisionGroup = group;
		shape.filter.collisionMask = collisionMask;
		
		// setup the body with the shape
        ball.shapes.add(shape);
        ball.position.setxy(x, y);
        ball.space = space;
		return ball;
	}
	
	/**
	 * Creates a configurable anchor
	 * @param	body1
	 * @param	body2
	 * @param	anchor1
	 * @param	anchor2
	 * @return
	 */
	public function createPivotJoint(body1:Body,body2:Body=null,anchor1:Vec2=null,anchor2:Vec2=null): PivotJoint
	{
		if (anchor1 == null) anchor1 = Vec2.weak();
		if (anchor2 == null) anchor2 = Vec2.weak();
		var joint:PivotJoint = new PivotJoint(body1, body2, anchor1, anchor2);
        joint.space = space;
		
		return joint;
	}
		
}