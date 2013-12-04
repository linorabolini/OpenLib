package openlib.animation.spritesheet;
import flash.display.BitmapData;
import openlib.animation.spritesheet.Tilesheet;
import flash.geom.Rectangle;



import openlib.animation.spritesheet.SpriteSheetFormat;

/**
 * ...
 * @author Lean
 */
class SpriteSheetAnimation
{
	public var currentIndex:Int;
	public var currentFrame:SpriteSheetFrameParsed;
	public var currentTilesheet:Tilesheet;
	
	public var images:Array<BitmapData>;
	public var framesArray:Array<Array<SpriteSheetFrameParsed>>;
	public var tilesheets:Array<Tilesheet>;

	public function new() 
	{
		images = new Array<BitmapData>();
		framesArray = new Array<Array<SpriteSheetFrameParsed>>();
		tilesheets = new Array<Tilesheet>();
	}
	
	public function add(image:BitmapData, frames:Array<SpriteSheetFrameParsed>): SpriteSheetAnimation
	{
		this.images.push(image);
		this.framesArray.push(frames);
		var tilesheet:Tilesheet = new Tilesheet(image);
		
		for (frame in frames)
			tilesheet.addTileRect(frame.frame);
		
		tilesheets.push(tilesheet);
		
		return this;
	}
	
	public function getAllFrames(): Array<SpriteSheetFrameParsed>
	{
		var totalFrames:Array<SpriteSheetFrameParsed> = [];
		for ( i in 0...framesArray.length)
			totalFrames = totalFrames.concat(framesArray[i]);

		return totalFrames;
	}
	
	public function goto(currentFrameIndex:Int) 
	{
		var current:Int = 0;
		
		while (framesArray[current].length <= currentFrameIndex)
		{
			currentFrameIndex -= framesArray[current].length;
			current++;
		}
		
		currentIndex = currentFrameIndex;
		currentFrame = framesArray[current][currentIndex];
		currentTilesheet = tilesheets[current];
	}
	
	public function dispose():Void
	{
		currentFrame = null;
		currentTilesheet = null;
		images = null;
		framesArray = null;
		tilesheets = null;
	}
}