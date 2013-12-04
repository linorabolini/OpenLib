package openlib.animation;

import flash.display.Sprite;
import flash.geom.Point;
import openlib.entity.Entity;
import openlib.math.FMath;

/**
 * ...
 * @author Lean
 */
class Mover
{
	
	private var asset:Sprite;
	private var path:Array<Point>;
	private var duration:Float;
	private var loop:Bool;
	
	private var elapsed:Float = 0;
	private var pos:Int = 0;
	private var finished:Bool;

	public function new(asset:Sprite, path:Array<Point>, duration:Float, loop:Bool = false) 
	{
		this.asset = asset;
		this.path = path;
		this.duration = duration;
		this.loop = loop;
	}
	
	public function update(dt:Float):Void
	{
		if (finished)
			return;
		
		var frame:Int;	
			
			
			
		elapsed += dt;
		
		if(!loop && elapsed >= duration) {
			elapsed = 0;
			frame = path.length - 1;
			asset.x = path[frame].x;
			asset.y = path[frame].y;
		} else {
			var tmp:Float = elapsed * (path.length-1) / duration;
			frame = Std.int(tmp);
			var alpha:Float = tmp - frame;
			var nextFrame = (frame + 1) % path.length;
			asset.x = FMath.interpolate( path[frame].x,  path[nextFrame].x, alpha);
			asset.y = FMath.interpolate( path[frame].y,  path[nextFrame].y, alpha);
		}
				
		if (frame == path.length - 1)
		{
			elapsed = 0;
			finished = !loop;
		}
	}
	
	public function dispose():Void
	{
		asset = null;
		path = null;
	}
	
}