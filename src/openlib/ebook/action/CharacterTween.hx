package openlib.ebook.action;
import flash.geom.Matrix;
import flash.geom.Point;
import openlib.animation.Animation;
import openlib.easing.Ease;
import openlib.entityManager;
import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;
import openlib.ui.UIUtil;

/**
 * ...
 * @author Nacho :)
 */

 
class CharacterTween extends TweenAction
{
	override public function start():Void
	{
		super.start();
		
		if (!data.flip)
			return;
			
		var centerAnchor = new Point(target.x + target.width / 2, target.y + target.height / 2);
		var m = target.transform.matrix;
		
		m.tx -= Std.int(centerAnchor.x);
		m.ty -= Std.int(centerAnchor.y);
		
		if ((direction.x < 0 && m.a > 0) || (direction.x >= 0 && m.a < 0))
			m.scale(-1, 1);
		
		m.tx += Std.int(centerAnchor.x);
		m.ty += Std.int(centerAnchor.y);
		
		target.transform.matrix = m;
	}
	
	override public function updateState(milliseconds:Int):Void 
	{
		super.updateState(milliseconds);
		
	}
	
	
	
}