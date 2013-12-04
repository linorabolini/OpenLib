package openlib.ebook.action;

import flash.Assets;
import flash.geom.Point;
import flash.Lib;
import flash.display.Bitmap;
import openlib.animation.Animator;
import openlib.animation.spritesheet.SpriteSheetPack;
import openlib.entity.AnimatorEntity;
import openlib.entity.Entity;
import openlib.entity.MoverEntity;
import openlib.entity.SpriteEntity;
import openlib.entityManager;
import openlib.geom.Spline;
import openlib.tasks.Func;
import openlib.ui.UIUtil;

/**
 * ...
 * @author 
 */
 typedef SplineActionFormat = {
	id: String,
	target: String,
	controlPoints: Array<Dynamic>,
	duration: Float,
	loop: Bool
 }
 
class SplineAction extends Func
{
	private var path:Array<Point>;
	public function new(data:SplineActionFormat) 
	{
		path = Spline.getCubicPath(cast data.controlPoints, data.loop, 0.1);
		super(cast createSpline, data);
	}
	
	private function createSpline(data:SplineActionFormat):Void {
		
		// get the container layer

		var target = cast EntityManager.getEntity(data.target);
		trace(target);
		
		if (target == null)
			throw "Target cannot be null";
		
		var mover:MoverEntity = new MoverEntity(target,path, data.duration);
		trace(mover);
		EntityManager.addEntity(data.id, mover);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		path = null;
	}
	
}