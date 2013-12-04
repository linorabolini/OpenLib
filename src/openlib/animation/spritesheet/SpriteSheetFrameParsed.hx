package openlib.animation.spritesheet;
import flash.geom.Rectangle;


/**
 * ...
 * @author 
 */
class SpriteSheetFrameParsed
{
	public var filename:String;
	public var frame:Rectangle;
	public var rotated:Bool;
	public var trimmed:Bool;
	public var spriteSourceSize:Rectangle;
	public var sourceSize:SpriteSheetFormat.Size;
	
	public function new(frame:SpriteSheetFormat.SpriteSheetFrame) 
	{
		this.filename = frame.filename;
		this.frame = createRect(frame.frame);
		this.rotated = frame.rotated;
		this.trimmed = frame.trimmed;
		this.spriteSourceSize = createRect(frame.spriteSourceSize);
		this.sourceSize = frame.sourceSize;
	}
	
	public function createRect(s:SpriteSheetFormat.SourceSize):Rectangle
	{
		return new Rectangle(s.x, s.y, s.w, s.h);
	}
	
}