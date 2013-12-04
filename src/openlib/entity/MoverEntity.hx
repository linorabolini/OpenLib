package openlib.entity;

import flash.display.Sprite;
import flash.geom.Point;
import openlib.animation.Mover;

/**
 * ...
 * @author Lean
 */
class MoverEntity extends Mover implements Entity
{

	public function new(asset:Sprite, path:Array<Point>, duration:Float, loop:Bool = false)
	{
		super(asset, path, duration, loop);
	}	
}