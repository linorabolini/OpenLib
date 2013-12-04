package openlib.ebook.action;
import flash.geom.Point;
import openlib.entityManager;
import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;
import openlib.ui.UIUtil;

/**
 * ...
 * @author Lean
 */
 typedef FadeOutActionFormat = {
	id:String,
	duration:Int
 }
 
class FadeOutAction extends TimeBasedTask
{
	var data:FadeOutActionFormat;
	var target:Dynamic;

	public function new(data:FadeOutActionFormat) 
	{
		super(data.duration);
		this.data = data;
	}
	
	override public function start():Void 
	{
		super.start();
		target = EntityManager.getEntity(data.id);
	}
	
	override public function updateState(milliseconds:Int):Void 
	{
		super.updateState(milliseconds);
		
		if (target.alpha <= 0)
			return;
		
		target.alpha -= (milliseconds / data.duration);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		target = null;
		data = null;
	}
	
}