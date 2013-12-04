package openlib.screen.transition;

import motion.Actuate;
import flash.Lib;

import openlib.screen.Screen;

class LeftToRightTransition implements Transition
{
	
	public static var ID:String = "LEFT_TO_RIGHT";

	private var duration:Float = 1.0;

	public function new() {}

	public function change(current:Screen, next:Screen, cb:Void -> Void):Void
	{
		next.x = -current.width;

		Actuate.tween (current, duration, { x: Lib.current.stage.stageWidth }, 
			false).onComplete(tweenComplete,[next,cb]).onUpdate(onChangeUpdate, [current, next]);
	}
	
	public function popup(next:Screen, cb:Void -> Void):Void
	{
		next.x = Lib.current.stage.stageWidth;

		Actuate.tween (next, duration, { x: 0 }, false).onComplete(tweenComplete,[next,cb]);
	}

	private function onChangeUpdate(current:Screen, next:Screen):Void
	{
		next.x = current.x - Lib.current.stage.stageWidth;
	}

	public function close(current:Screen, cb:Void -> Void):Void
	{
		Actuate.tween (current, duration, { x: Lib.current.stage.stageWidth }, false).onComplete(cb);
	}

	private function tweenComplete(next:Screen,cb:Void -> Void):Void
	{
		cb();
	}
}