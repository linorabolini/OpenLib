package openlib.screen.transition;

class NoneTransition implements Transition
{
	
	public static var ID:String = "NONE";
	
	public function new() {}
	
	public function popup(next:Screen, cb:Void -> Void):Void
	{
		cb();
	}

	public function change(current:Screen, next:Screen, cb:Void -> Void):Void
	{
		cb();
	}

	public function close(current:Screen, cb:Void -> Void):Void
	{
		cb();
	}

}