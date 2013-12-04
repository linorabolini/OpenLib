package openlib.ebook.action;

import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Rectangle;
import flash.Lib;
import openlib.ebook.ActionParser;
import openlib.entity.SpriteEntity;
import openlib.entityManager;
import openlib.tasks.Task;
import openlib.tasks.TaskEvent;

// { "drag": { "id": "obj1", "destination": { "position": "x": 20, "y": 20, "onSuccess": {}, "onFail": {}  } } }

 typedef DragActionFormat = {
	 id:String,
	 destination:DragDestination
 }
 
 typedef DragDestination = {
	 id:String,
	 onSuccess:Dynamic,
	 onFail:Dynamic
 }
 
class DragAction extends Task
{
	
	private var seq:Task;
	private var data:DragActionFormat;
	private var dragging:Bool;
	private var succeed:Bool;
	private var source:SpriteEntity;
	private var target:SpriteEntity;
	private var offsetX:Float;
	private var offsetY:Float;

	public function new(data:DragActionFormat) 
	{
		super();
		
		this.data = data;
	}
	
	override public function start():Void 
	{
		super.start();

		source = cast EntityManager.getEntity(data.id);
		
		if (source == null)
			throw "Cannot drag an unexisting object: " + data.id;
		
		source.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		source.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		
		source.addEventListener(TouchEvent.TOUCH_BEGIN, onPressed);
		source.addEventListener(TouchEvent.TOUCH_END, onReleased);
		
		if (data.destination != null)
			target = cast EntityManager.getEntity(data.destination.id);
		
		this.taskComplete();
	}
	
	private function onPressed(e:Dynamic):Void 
	{
		dragging = true;
		
		offsetX = Lib.stage.mouseX - source.x;
		offsetY = Lib.stage.mouseY - source.y;
		
		source.addEventListener(Event.ENTER_FRAME, onButtonUpdate);
	}
	
	private function onReleased(e:MouseEvent):Void 
	{
		dragging = false;
		source.removeEventListener(Event.ENTER_FRAME, onButtonUpdate);
		
		if (target == null)
			return;
		
		var sr = new Rectangle(source.x, source.y, source.width, source.height);
		var tr = new Rectangle(target.x, target.y, target.width, target.height);
		
		if (sr.intersects(tr))
			onSuccess();
		else
			onFail();
	}
	
	private function onButtonUpdate(e:Event):Void
	{
		if (!dragging)
			return;
		
		source.x = Lib.stage.mouseX - offsetX;
		source.y = Lib.stage.mouseY - offsetY;
	}
	
	private function onSuccess():Void
	{
		if (data.destination == null || data.destination.onSuccess == null)
			return;
		
		seq = ActionParser.parseActions([data.destination.onSuccess]);
		seq.addEventListener(TaskEvent.COMPLETE, onSeqComplete);
		seq.start();
	}
	
	private function onFail():Void
	{
		if (data.destination == null)
			return;
		
		if (data.destination.onFail == null)
			return;
		
		seq = ActionParser.parseActions([data.destination.onFail]);
		seq.addEventListener(TaskEvent.COMPLETE, onSeqComplete);
		seq.start();
	}
	
	public override function update(milliseconds:Int):Void
	{
		super.update(milliseconds);
		
		if (seq != null)
			seq.update(milliseconds);
	}
	
	private function onSeqComplete(e:Dynamic):Void
	{
		seq.removeEventListener(TaskEvent.COMPLETE, onSeqComplete);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
	}
	
}