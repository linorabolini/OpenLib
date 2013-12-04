package openlib.animation.spritesheet;
import haxe.Json;
import flash.Assets;
import openlib.animation.spritesheet.SpriteSheetPack;
import openlib.util.OpenlibAssets;

/**
 * ...
 * @author 
 */
class SpriteSheetPackLoader implements SpriteSheetPackAssetLoader
{

	public function new() 
	{
		
	}
	
	/* INTERFACE openlib.animation.spritesheet.SpriteSheetPackAssetLoader */
	
	public function loadAssets(ssp:SpriteSheetPack, root:String, anims:Array<String>) 
	{
		for (anim in anims)
		{
			// debug
			// trace("Loading Json: " + root + "/" + anim + ".json");

			var jf:SpriteSheetFormat = Json.parse(Assets.getText(root + "/" + anim + ".json"));
			var image = OpenlibAssets.getBitmapData(root + "/" + anim + ".png", false);
			ssp.animationSequences.set(anim, createSequenceDefault(jf.frames.length));
			ssp.packs.set(anim, new SpriteSheetAnimation( ).add(image, SpriteSheetFramesCreator.create(jf)));
		}
	}
	
	function createSequenceDefault(size:Int) 
	{
		var sequence:Array<Int> = [];
		for (i in 0...size)
		{
			sequence.push(i);
		}
		
		return sequence;
	}
	
}