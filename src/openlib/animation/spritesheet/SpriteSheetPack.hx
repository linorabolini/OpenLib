package openlib.animation.spritesheet;
import haxe.Json;
import flash.Assets;
import flash.display.Sprite;
import flash.geom.Point;
import flash.Lib;
import openlib.animation.spritesheet.Tilesheet;
import openlib.animation.Animation;
import openlib.animation.Format;
import openlib.util.Time;

typedef SpriteSheetPackModel = {
	root:String, 
	animsArray:Array<String>,
	fps:Int
}


/**
 * ...
 * @author Lean
 */
class SpriteSheetPack extends Animation
{
	
	public var packs:Map<String,Dynamic>; 						// store frames
	public var animationSequences:Map<String,Array<Int>>; 		// store anim sequences
	private var currentSequence:Array<Int>;						// current sequence
	private var hasSequence:Bool;
	private var tilesheet:Tilesheet;
	private var currentTime:Int = 0;
	private var currentStep:Int = 0;							// current frame index playing
	private var firstTime:Bool;
	private var fps:Int;
	private var currentAnim:SpriteSheetAnimation;				// current animation
	
	public static var defaultLoader:SpriteSheetPackAssetLoader = new SpriteSheetPackLoader();

	public function new( root:String, anims:Array<String>, fps:Int = 24, ?loader:SpriteSheetPackAssetLoader) 
	{
		super();
		this.packs = new Map<String,Dynamic>();
		this.animationSequences = new Map<String,Array<Int>>();
		this.fps = fps;
		
		if (loader == null) loader = defaultLoader;
		
		loader.loadAssets(this, root, anims);
		
		// first anim as default
		playDefaultAnimation(anims[0]);
	}
	
	function playDefaultAnimation(anim:String) 
	{
		play(anim);
		doDraw();
	}
	
	override public function play(id:String, repeat:Bool = true, ?onFinish:Void -> Void):Void
	{
		super.play(id, repeat,onFinish);
		if (currentAnim != null)
			stop();

		firstTime = true;

		currentAnim = packs.get(id);

		if (currentAnim == null)
			throw "Invalid animation id \"" + id + "\"";
		
		// load the sequence
		if (animationSequences.exists(id))
			currentSequence = animationSequences.get(id);
		else 
			throw "ANIMATION HAS NO SEQUENCE";
		
		currentStep = 0;
	}
	
	override public function update():Void
	{
		super.update();
		if (currentAnim == null)
			return;
		
		var elapsed = Time.dt;
		var frameTime = 1000 / fps;

		if (elapsed >= frameTime || firstTime)
		{
			firstTime = false;
			
			// draw the tilesheet
			doDraw();

			if (++currentStep >= currentSequence.length)
			{
				currentStep = 0;

				if (!repeat)
					stop();
				
				if (onFinish != null)
					onFinish();
			}
		}
	}
	
	function doDraw() 
	{
		graphics.clear();
			
		var flags:Int = 0;
		var tileData:Array<Float>;
		
		// goto a frame (looks for a frame and loads the info
		var currentFrameIndex:Int = currentSequence[currentStep];
		currentAnim.goto(currentFrameIndex);
		
		// get the neeeded data
		var frame: SpriteSheetFrameParsed = currentAnim.currentFrame;
		var index: Int = currentAnim.currentIndex;
		tilesheet = currentAnim.currentTilesheet;
		
		// apply traslation (if trimmed or not)
		tileData = [frame.spriteSourceSize.x, frame.spriteSourceSize.y, index];
		
		if (frame.rotated) {
			flags &= Tilesheet.TILE_ROTATION;
			tileData.push(-90);
		}
		
		try
		{
			tilesheet.drawTiles(graphics, tileData, true, flags);
		}
		catch (e:Dynamic)
		{
			trace(e);
			// Ignore this error
		}
	}
	
	override public function stop():Void
	{
		super.stop();
		currentAnim = null;
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		for (anim in packs)
			anim.dispose();
			
		packs = null;
		currentSequence = null;
		animationSequences = null;
	}
	
}