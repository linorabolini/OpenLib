package openlib.animation.perFrameAnimation;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.Lib;
import openlib.animation.Animation;
import openlib.util.Time;

/**
 * ...
 * @author 
 */
class PerFrameAnimation extends Animation
{
	public var packs:Map<String,Dynamic>;
	private var bitmap:Bitmap;	
	private var currentTime:Int = 0;
	private var currentStep:Int = 0;
	private var firstTime:Bool;
	private var fps:Int;
	
	private var currentAnim:Dynamic;
	
	public static var defaultLoader:PerFrameAnimationAssetLoader = new PerFrameAnimationLoader();
	
	public function new(root:String, anims:Array<String>, fps:Int = 24, ?loader:PerFrameAnimationAssetLoader) 
	{
		super();
		this.packs = new Map<String,Dynamic>();
		this.fps = fps;
		
		if (loader == null) loader = defaultLoader;
		
		this.bitmap = new Bitmap();

		addChild(bitmap);
		
		loader.loadAssets(this, root, anims);
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
			
		currentStep = 0;
		update(0);
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
			
			this.bitmap.bitmapData = currentAnim[currentStep];
			this.bitmap.smoothing = true;

			if (++currentStep >= currentAnim.length)
			{
				currentStep = 0;
				
				if (!repeat)
					stop();
				
				if (onFinish != null)
					onFinish();

			}
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
		for ( element in packs ) {
			element = null;
		}
		packs = null;
		bitmap = null;
	}
	
	
}