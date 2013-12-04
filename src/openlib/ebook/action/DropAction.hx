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

 typedef DropActionFormat = {
	 id:String
 }
 
class DropAction extends Task
{
	
	private var data:DropActionFormat;

	public function new(data:DropActionFormat) 
	{
		super();
		
		this.data = data;
	}
	
	override public function start():Void 
	{
		super.start();

		var source = cast EntityManager.getEntity(data.id);
		
		if (source != null)
			source.removeAllListeners();
		
		this.taskComplete();
	}
	
}