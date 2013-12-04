package openlib.screen.transition;

interface Transition
{
	
	function popup(next:Screen, cb:Void -> Void):Void;

	function change(current:Screen, next:Screen, cb:Void -> Void):Void;

	function close(current:Screen, cb:Void -> Void):Void;

}