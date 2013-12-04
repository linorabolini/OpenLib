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
 typedef FadeInActionFormat = {
	id:String,
	duration:Int
 }
 
class FadeInAction extends TimeBasedTask
{
	var data:FadeInActionFormat;
	var target:Dynamic;

	public function new(data:FadeInActionFormat) 
	{
		super(data.duration);
		this.data = data;
	}
	
	override public function start():Void 
	{
		super.start();
		target = EntityManager.getEntity(data.id);
		target.visible = true;
	}
	
	override public function updateState(milliseconds:Int):Void 
	{
		super.updateState(milliseconds);
		
		if (target.alpha >= 1)
			return;
		
		target.alpha += (milliseconds / data.duration);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		target = null;
		data = null;
	}
	
}