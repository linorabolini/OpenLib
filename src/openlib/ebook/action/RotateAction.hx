package openlib.ebook.action;
import flash.geom.Point;
import openlib.entityManager;
import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;
import openlib.ui.UIUtil;

/**
 * ... { "rotate": { "id": "magic", "angle": 15, "duration": 1000 } },
 * @author Lean
 */
 typedef RotateActionFormat = {
	id:String,
	angle:Float,
	duration:Int,
	loop:Bool,
	reverse:Bool
 }
 
class RotateAction extends Task
{
	var data:RotateActionFormat;
	var target:Dynamic;

	public function new(data:RotateActionFormat) 
	{
		super();
		this.data = data;
		
		if (data.loop)
		{
			if (data.reverse)
				data.angle = -360;
			else
				data.angle = 360;
		}
	}
	
	override public function start():Void 
	{
		super.start();
		target = EntityManager.getEntity(data.id);
	}
	
	override public function update(milliseconds:Int):Void 
	{
		super.update(milliseconds);
		
		if (!data.loop)
		{
			if (elapsed > data.duration)
			{
				this.taskComplete();
				return;
			}
			
			if (data.angle < 0 && target.rotation <= data.angle)
				return;
			else if (data.angle > 0 && data.angle < 360 && target.rotation >= data.angle)
				return;
		}
		
		target.rotation += (milliseconds * data.angle / data.duration);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		target = null;
		data = null;
	}
	
}