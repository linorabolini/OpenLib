package openlib.animation.perFrameAnimation;
import haxe.Json;
import flash.Assets;
import flash.display.BitmapData;
import openlib.animation.perFrameAnimation.PerFrameAnimation;
import openlib.util.OpenlibAssets;

/**
 * ...
 * @author 
 */
class PerFrameAnimationLoader implements PerFrameAnimationAssetLoader
{

	public function new() 
	{
		
	}
	
	/* INTERFACE openlib.animation.spritesheet.PerFrameAnimationAssetLoader */
	
	public function loadAssets(pfa:PerFrameAnimation, root:String, anims:Array<String>) 
	{
		for (anim in anims)
		{	
			var images:Array<BitmapData> = [];
			var txt:String = Assets.getText(root + "/" + anim + ".json");
			var info = Json.parse(txt);
			
			var frames:Array<String> = info.animationFrames;
			
			for (i in 0...frames.length) {
				images.push(OpenlibAssets.getBitmapData(root + "/" + frames[i]));
			}
			
			pfa.packs.set(anim, images);
		}
	}
	
}