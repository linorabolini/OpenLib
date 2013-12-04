package openlib.animation;
import flash.errors.Error;
import openlib.animation.perFrameAnimation.PerFrameAnimation;
import openlib.animation.spritesheet.SpriteSheetPack;

/**
 * ...
 * @author 
 */
class AnimationFactory
{
	static public inline var SPRITESHEET:String = "spritesheet";
	static public inline var DYNAMIC_ANIMATION:String = "dynamicAnimation";
	static public inline var PER_FRAME_ANIMATION:String = "perFrameAnimation";

	public function new() 
	{
		
	}
	
	static public function getAnimation(type:String, data:Dynamic, ?config:Dynamic): Animation
	{
		var animation:Animation = null;
		if (type == SPRITESHEET) {
			animation = new SpriteSheetPack(data.root, data.clips, data.fps, config);
		} else if (type == DYNAMIC_ANIMATION) {
			animation = new MoviePlayer(new Library(data.root));
		} else if (type == PER_FRAME_ANIMATION) {
			animation = new PerFrameAnimation(data.root, data.clips, data.fps, config);
		}
		
		if (animation == null)
			throw new Error("Tipo de animación no contemplado");
			
		return animation;
	}
	
}