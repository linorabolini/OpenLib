package openlib.animation.perFrameAnimation;
import openlib.animation.perFrameAnimation.PerFrameAnimation;

/**
 * ...
 * @author 
 */
interface PerFrameAnimationAssetLoader
{
	function loadAssets(pfa:PerFrameAnimation, root:String, anims:Array<String>):Void;
}