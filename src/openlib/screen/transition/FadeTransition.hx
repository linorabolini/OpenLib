package openlib.screen.transition;

import motion.Actuate;
import openlib.screen.Screen;

class FadeTransition implements Transition
{
	
	public static var ID:String = "FADE";

	private static var duration_popup:Float = 0.5;
	private static var duration_close:Float = 0;
	private static var duration_change:Float = 0.3;

	public function new() {}
	
	public function change(current:Screen, next:Screen, cb:Void -> Void):Void
	{
		next.alpha = 0;
		Actuate.tween (next, duration_change, { alpha: 1 }, false).onComplete(tweenComplete,[next,cb]);
	}

	public function popup(next:Screen, cb:Void -> Void):Void
	{
		next.alpha = 0;
		Actuate.tween (next, duration_popup, { alpha: 1 }, false).onComplete(tweenComplete,[next,cb]);
	}

	public function close(current:Screen, cb:Void -> Void):Void
	{
		Actuate.tween (current, duration_close, { alpha: 0 }, false).onComplete(cb);
	}
	
	private function tweenComplete(next:Screen,cb:Void -> Void):Void
	{
		next.transitionFinished();
		cb();
	}

}