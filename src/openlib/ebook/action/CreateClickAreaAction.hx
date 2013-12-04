package openlib.ebook.action;
import flash.Assets;
import flash.events.Event;
import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.Lib;
import openlib.ebook.ActionParser;
import openlib.entity.ShapeEntity;
import openlib.entity.SpriteEntity;
import openlib.entity.BitmapEntity;
import openlib.entityManager;
import openlib.tasks.Func;
import openlib.tasks.Task;
import openlib.tasks.TaskEvent;
import openlib.ui.UIUtil;

/**
 * { "create_click_area": { "id": "sun_click", "area": { "x":2669, "y":135, "w": 200, "h": 200 } } }
 * @author Carlos Baute
 */
 typedef CreateClickAreaActionFormat = {
	id:String,
	layer:String,
	area: { x:Float, y:Float, w:Float, h:Float },
	action:Dynamic
 }
 
class CreateClickAreaAction extends Func
{
	
	private var nextAction:Dynamic;
	private static var centerAdjust = 0;
	private var seq:Task;

	public function new(data:CreateClickAreaActionFormat) 
	{
		super(cast createShape, data);
		
		ActionFormatUtil.fixDefaults(data);
	}
	
	private function createShape(data:CreateClickAreaActionFormat):Void {
		var container = cast(EntityManager.getEntity(data.layer, "layers"), SpriteEntity);
		nextAction = data.action;
		
		var dataClone = { x: data.area.x, y: data.area.y, w: data.area.w, h: data.area.h };
		
		var ca = new ShapeEntity();
		ca.graphics.beginFill(0, 0);
		ca.graphics.drawRect(data.area.x / UIUtil.getHeightRatio(), data.area.y / UIUtil.getHeightRatio(),
			data.area.w / UIUtil.getHeightRatio(), data.area.h / UIUtil.getHeightRatio());
		ca.graphics.endFill();
		
		var spe = new SpriteEntity();
		spe.addChild(ca);
		
		spe.addEventListener(Event.ENTER_FRAME, onButtonUpdate);
		
		EntityManager.addEntity(data.id, spe);
		container.addChild(spe);
		
		spe.addEventListener(MouseEvent.CLICK, onShapePressed);
	}
	
	private function onButtonUpdate(e:Event):Void
	{
		if (seq != null)
			seq.update(10);
	}
	
	private function onShapePressed(e:Event):Void
	{
		seq = ActionParser.parseActions([nextAction]);
		seq.addEventListener(TaskEvent.COMPLETE, onSeqComplete);
		seq.start();
	}
	
	private function onSeqComplete(e:Dynamic):Void
	{
		seq.removeEventListener(TaskEvent.COMPLETE, onSeqComplete);
	}
	
}