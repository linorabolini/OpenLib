package openlib.animation;

import openlib.entity.Entity;
import openlib.entity.SpriteEntity;

/**
 * ...
 * @author 
 */
class Animation extends SpriteEntity
{
	/** on finis callback */
	public var onFinish:Void -> Void;
	
	/** Whether the current movie is being looped. */
    public var repeat:Bool;
	
	public var dataHolder:Dynamic;
	
	public var currentClip:String = null;
	
	public function new() 
	{
		super();
	}
	
	public function stop():Void {}
	
	public function play(id:String, repeat:Bool = true, ?onFinish:Void -> Void):Void {
		this.onFinish = onFinish;
		this.repeat = repeat;
		currentClip = id;
	}
	
	public function dispose():Void {
		super.dispose();
			
		onFinish = null;
		currentClip = null;
	}	
}