package openlib.ebook.action;

import flash.Assets;
import flash.Lib;
import flash.display.Bitmap;
import openlib.animation.Animator;
import openlib.animation.spritesheet.SpriteSheetPack;
import openlib.entity.AnimatorEntity;
import openlib.entity.SpriteEntity;
import openlib.entityManager;
import openlib.tasks.Func;
import openlib.ui.UIUtil;

/**
 * ...
 * @author 
 */
 typedef CreateAnimationActionFormat = {
	id:String,
	layer:String,
	position: { x:Float, y:Float },
	type:String,
	data:Dynamic,
	visible:Bool
 }
 
class CreateAnimationAction extends Func
{

	public function new(data:CreateAnimationActionFormat) 
	{
		super(cast createAnimation, data);
		
		ActionFormatUtil.fixDefaults(data);
	}
	
	private function createAnimation(data:CreateAnimationActionFormat):Void {
		
		// get the container layer
		var container:SpriteEntity = cast EntityManager.getEntity(data.layer, "layers");
		
		// get the animation
		var animator = new AnimatorEntity(data);
		
		// set the position
		var dataClone = { x: data.position.x / UIUtil.getHeightRatio(), y: data.position.y / UIUtil.getHeightRatio() };
		
		animator.x = dataClone.x;
		animator.y = dataClone.y;
		
		if (!data.visible)
		{
			animator.visible = false;
			animator.alpha = 0;
		}
		
		// add the animator to the entity manager
		EntityManager.addEntity(data.id, animator);
		container.addChild(animator);
	}
	
}