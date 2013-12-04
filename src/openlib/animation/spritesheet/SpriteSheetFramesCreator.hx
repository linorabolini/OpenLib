package openlib.animation.spritesheet;
import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * ...
 * @author Lean
 */
class SpriteSheetFramesCreator
{
	
	public static function create(format:SpriteSheetFormat):Array<SpriteSheetFrameParsed>
	{
		var frecs:Array<SpriteSheetFrameParsed> = new Array<SpriteSheetFrameParsed>();
				
		for (frame in format.frames)
			frecs.push(new SpriteSheetFrameParsed(frame));
		
		return frecs;
	}
}