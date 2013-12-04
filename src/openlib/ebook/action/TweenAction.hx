package openlib.ebook.action;
import flash.geom.Point;
import openlib.animation.Animation;
import openlib.easing.Ease;
import openlib.entityManager;
import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;
import openlib.ui.UIUtil;

/**
 * ...
 * @author Lean
 */
 typedef TweenActionFormat = {
	duration:Int,
	id:String,
	to: { x:Float, y:Float },
	ease: String,
	flip:Bool,
	anchor:String
}
 
class TweenAction extends TimeBasedTask
{
	var data:TweenActionFormat;
	var direction:Point;
	var target:Dynamic;
	var easeX:Ease;
	var easeY:Ease;

	public function new(data:TweenActionFormat) 
	{
		super(data.duration);
		this.data = data;
		direction = new Point();
	}
	
	override public function start():Void 
	{
		super.start();
		target = EntityManager.getEntity(data.id);
		
		// var extra = UIUtil.HEIGHT % UIUtil.STAGE_HEIGHT;
		
		var dataClone:Dynamic = { x: data.to.x / UIUtil.getHeightRatio(), y: data.to.y / UIUtil.getHeightRatio() };
		
		//UIUtil.percToPixelObj(dataClone);
		
		direction.x = dataClone.x - target.x;
		direction.y = dataClone.y - target.y;
		
		var ease = data.ease == null ? "linear": data.ease;
		
		easeX = new Ease(easeXUpdate, data.duration, target.x, dataClone.x, ease);
		easeX.start();
		
		easeY = new Ease(easeYUpdate, data.duration, target.y, dataClone.y, ease);
		easeY.start();
	}
	
	private function easeXUpdate(vals:Array<Float>):Void
	{
		target.x = vals[0];
	}
	
	private function easeYUpdate(vals:Array<Float>):Void
	{
		target.y = vals[0];
	}
	
	override public function updateState(milliseconds:Int):Void 
	{
		super.updateState(milliseconds);
			
		easeX.update(milliseconds);
		easeY.update(milliseconds);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		if (easeX != null && easeY != null)
		{
			easeX.dispose();
			easeY.dispose();
		}
		
		target = null;
		data = null;
		direction = null;
	}
	
}