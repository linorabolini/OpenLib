package openlib.ebook.action;
import openlib.animation.Animator;
import openlib.entityManager;
import openlib.entity.AnimatorEntity;
import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;

/**
 * ...
 * @author Lean
 */

 typedef AnimActionFormat = {
	id:String,
	name:String,
	loop:String
 }
 
class AnimAction extends Task
{
	var data:AnimActionFormat;

	public function new(data:AnimActionFormat) 
	{
		super();
		this.data = data;
	}
	
	override public function start():Void 
	{
		super.start();
		var animator:AnimatorEntity = cast(EntityManager.getEntity(data.id), AnimatorEntity);
		
		var loop = data.loop == null ? false: data.loop == "true" ? true: false;
		
		animator.play(data.name, loop);
		this.taskComplete();
	}
	
}