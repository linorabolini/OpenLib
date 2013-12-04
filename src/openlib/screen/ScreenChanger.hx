package openlib.screen;

import openlib.screen.ScreenManager;
import openlib.screen.transition.NoneTransition;
import openlib.screen.transition.Transition;
import openlib.screen.transition.LeftToRightTransition;
import openlib.screen.transition.RightToLeftTransition;
import openlib.screen.transition.FadeTransition;
	
class ScreenChanger
{
	
	private var transitions:Map<String, Class<Transition>>;
	
	public function new()
	{
		transitions = new Map<String, Class<Transition>>();
	}

	private function getTransition(transition:Dynamic):Transition
	{
		if (transition == LeftToRight)
			return new LeftToRightTransition();
		else if (transition == RightToLeft)
			return new RightToLeftTransition();
		else if (transition == Fade)
			return new FadeTransition();
		if (transition == None)
			return new NoneTransition();
		else
		{
			var id:String = cast transition;
			var tc:Class<Transition> = transitions.get(id);
				
			if (tc == null)
				throw "Invalid transition: " + id;
				
			var	t = Type.createInstance(tc, []);
			
			return t;
		}
	}
	
	public function registerTransition(id:String, type:Class<Transition>):Void
	{
		transitions.set(id, type);
	}

	public function change(current:Screen, next:Screen, cb:Void -> Void):Void
	{
		getTransition(next.transition).change(current, next, cb);
	}

	public function popup(next:Screen, cb:Void -> Void):Void
	{
		getTransition(next.transition).popup(next, cb);
	}

	public function close(current:Screen, cb:Void -> Void):Void
	{
		getTransition(current.transition).close(current, cb);
	}

}