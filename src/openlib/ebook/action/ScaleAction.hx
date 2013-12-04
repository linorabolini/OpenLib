package openlib.ebook.action;
import flash.display.DisplayObject;
import flash.geom.Point;
import openlib.animation.Animation;
import openlib.easing.Ease;
import openlib.entity.SpriteEntity;
import openlib.entityManager;
import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;
import openlib.ui.UIUtil;

/**
 * ... "id": "bamScale", "duration": 1000, "scaleX": 2, "scaleY": 1.5, "ease": "linear"
 * @author Lean
 */
 typedef ScaleActionFormat = {
	id:String,
	duration:Int,
	scaleX:Float,
	scaleY:Float,
	anchor:String,
	ease:String
 }
 
class ScaleAction extends TimeBasedTask
{
	var data:ScaleActionFormat;
	var target:DisplayObject;
	var easeX:Ease;
	var easeY:Ease;
	var valX:Float = 0;
	var valY:Float = 0;
	var pValX:Float = 0;
	var pValY:Float = 0;
	var scaleAnchor:Point;

	public function new(data:ScaleActionFormat) 
	{
		super(data.duration);
		this.data = data;
	}
	
	override public function start():Void 
	{
		super.start();
		target = cast EntityManager.getEntity(data.id);
		
		if (data.anchor == null || data.anchor == "top_left")
			scaleAnchor = new Point(target.x, target.y);
		else if (data.anchor == "top_right")
			scaleAnchor = new Point(target.x + target.width, target.y);
		else if (data.anchor == "top_center")
			scaleAnchor = new Point(target.x + target.width / 2, target.y);
		else if (data.anchor == "bottom_left")
			scaleAnchor = new Point(target.x, target.y + target.height);
		else if (data.anchor == "bottom_right")
			scaleAnchor = new Point(target.x + target.width, target.y + target.height);
		else if (data.anchor == "bottom_center")
			scaleAnchor = new Point(target.x + target.width / 2, target.y + target.height);
		else if (data.anchor == "left_center")
			scaleAnchor = new Point(target.x, target.y + target.height / 2);
		else if (data.anchor == "right_center")
			scaleAnchor = new Point(target.x + target.width, target.y + target.height / 2);
		else if (data.anchor == "center")
			scaleAnchor = new Point(target.x + target.width / 2, target.y + target.height / 2);
		else 
			throw "Invalid anchor attribute: " + data.anchor;
			
		
		if (data.ease != null)
		{
			easeX = new Ease(easeXUpdate, data.duration, target.scaleX, data.scaleX, data.ease);
			easeX.start();
		
			easeY = new Ease(easeYUpdate, data.duration, target.scaleY, data.scaleY, data.ease);
			easeY.start();
		}
		else
		{
			valX = data.scaleX;
			valY = data.scaleY;
		}
	}
	
	private function easeXUpdate(vals:Array<Float>):Void
	{
		pValX = valX;
		valX = vals[0];
	}
	
	private function easeYUpdate(vals:Array<Float>):Void
	{
		pValY = valY;
		valY = vals[0];
	}
	
	override public function updateState(milliseconds:Int):Void 
	{
		super.updateState(milliseconds);
		
		if (data.ease != null)
		{
			easeX.update(milliseconds);
			easeY.update(milliseconds);
			
			if (!(pValX == 0 || pValY == 0))
				scaleFromPoint(target, 1 + valX - pValX, 1 + valY - pValY, scaleAnchor);
		}
		else
		{
			target.scaleX = valX;
			target.scaleY = valY;
		
			this.taskComplete();
		}
	}
	
	private function scaleFromPoint(ob:DisplayObject, sx:Float, sy:Float, ptScalePoint:Point)
	{
		var m = ob.transform.matrix;
		
		m.tx -= ptScalePoint.x;
		m.ty -= ptScalePoint.y;
		
		m.scale(sx, sy);
		
		m.tx += ptScalePoint.x;
		m.ty += ptScalePoint.y;
		
		ob.transform.matrix = m;
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		if (data.ease != null)
		{
			easeX.dispose();
			easeY.dispose();
		}
		
		target = null;
		data = null;
	}
	
}