package openlib.ebook.action;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import openlib.animation.Animation;
import openlib.easing.Ease;
import openlib.ebook.Camera;
import openlib.entityManager;
import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;
import openlib.ui.UIUtil;

/**
 * ...
 * @author Lean
 */
 typedef MoveCameraActionFormat = {
	to: { x:Float, y:Float },
	duration: Int,
	layer:String,
	ease:String
 }
 
class MoveCameraAction extends TimeBasedTask
{
	var data:MoveCameraActionFormat;
	var easeX:Ease;
	var easeY:Ease;
	var direction:Point;
	var targets:Map<Int,DisplayObject>; // array crashes con cpp targets
	var target:DisplayObject;

	public function new(data:MoveCameraActionFormat) 
	{
		super(data.duration);
		this.data = data;
		targets = new Map<Int,DisplayObject>();
	}
	
	override public function start():Void 
	{
		super.start();
		
		if (data.layer == null)
			targets.set(0, Lib.current.stage);
		else
		{
			var layers = EntityManager.getEntityNamesByGroup("layers");
			var layerIndex = 0;
			
			for (key in layers.keys())
			{
				layerIndex = key;
				if (layers.get(key) == data.layer)
					break;
				
				layerIndex = -1;
			}
			
			if (layerIndex == -1)
				throw "Invalid index value";
			
			var count = 0;
			for (key in layers.keys())
			{
				if (key <= layerIndex)
				{
					var layer = layers.get(key);
					targets.set(count, cast EntityManager.getEntity(layer, "layers"));
					count++;
				}
			}
		}
		
		direction = new Point();
		
		var extra = 0.0;
		
		if (data.to.x != 0)
			extra = UIUtil.HEIGHT % UIUtil.STAGE_HEIGHT;
		
		var dataClone:Dynamic = { x: (data.to.x / UIUtil.getHeightRatio()) + extra, y: data.to.y / UIUtil.getHeightRatio() };
		
		if (data.ease != null)
		{
			easeX = new Ease(easeXUpdate, data.duration, Camera.x, dataClone.x, data.ease);
			easeX.start();
			
			easeY = new Ease(easeYUpdate, data.duration, Camera.y, dataClone.y, data.ease);
			easeY.start();
		}
		else
		{
			Camera.x = dataClone.x;
			Camera.y = dataClone.y;
		}
	}
	
	private function easeXUpdate(vals:Array<Float>):Void
	{
		Camera.px = Camera.x;
		Camera.x = vals[0];
	}
	
	private function easeYUpdate(vals:Array<Float>):Void
	{
		Camera.py = Camera.y;
		Camera.y = vals[0];
	}
	
	override public function update(milliseconds:Int):Void 
	{
		super.update(milliseconds);
		
		if (easeX != null && easeY != null)
		{
			easeX.update(milliseconds);
			easeY.update(milliseconds);
			
			for (key in targets.keys())
			{
				var target = targets.get(key);
				var m = target.transform.matrix;
				m.translate(Camera.x - Camera.px, Camera.y - Camera.py);
				target.transform.matrix = m;
			}
		}
		else
		{
			// TODO: Esto no funca!!
			var m = targets.get(0).transform.matrix;
			m.translate(Camera.x, Camera.y);
			targets.get(0).transform.matrix = m;
			
			this.taskComplete();
		}
		
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		data = null;
		direction = null;
		
		if (easeX != null && easeY != null)
		{
			easeX.dispose();
			easeY.dispose();
		}
	}
	
}