package openlib.ebook.action;

import flash.Assets;
import flash.display.Bitmap;
import flash.events.Event;
import flash.Lib;
import openlib.animation.Animator;
import openlib.animation.spritesheet.SpriteSheetPack;
import openlib.ebook.ActionParser;
import openlib.entity.SpriteEntity;
import openlib.entityManager;
import openlib.entity.ButtonEntity;
import openlib.tasks.Task;
import openlib.tasks.TaskEvent;
import openlib.ui.Button;
import openlib.ui.UIUtil;

/**
 * ...  { "id": "btn1", "layer": "ui", "position": { "x":10, "y":20 }, "data": { "idle": "img/btn1_idle.png", "pressed": "img/btn1_pressed.png" } } },
 * @author 
 */
 typedef CreateButtonActionFormat = {
	id:String,
	layer:String,
	position: { x:Float, y:Float },
	data:ButtonData,
	action:Dynamic,
	visible:Bool
 }
 
 typedef ButtonData = {
	 idle:String,
	 pressed:String
 }
 
class CreateButtonAction extends Task
{
	
	private var nextAction:Dynamic;
	private var seq:Task;
	private var format:CreateButtonActionFormat;

	public function new(format:CreateButtonActionFormat) 
	{
		super();
		
		ActionFormatUtil.fixDefaults(format);
		this.format = format;
	}
	
	override public function start():Void 
	{
		super.start();
		// get the container layer
		var container:SpriteEntity = cast EntityManager.getEntity(format.layer, "layers");
		nextAction = format.action;
		
		var btn = new ButtonEntity(format.data, onButtonPressed);
		
		btn.x = format.position.x / UIUtil.getHeightRatio();
		btn.y = format.position.y / UIUtil.getHeightRatio();
		
		btn.addEventListener(Event.ENTER_FRAME, onButtonUpdate);
		
		if (!format.visible)
		{
			btn.visible = false;
			btn.alpha = 0;
		}
		
		// add the animator to the entity manager
		EntityManager.addEntity(format.id, btn);
		container.addChild(btn);
		
		this.taskComplete();
	}
	
	private function onButtonPressed(e:Event):Void
	{
		var btn:ButtonEntity = cast e.target;
		
		if (!btn.enabled)
			return;
		
		seq = ActionParser.parseActions([nextAction]);
		seq.addEventListener(TaskEvent.COMPLETE, onSeqComplete);
		seq.start();
	}
	
	private function onButtonUpdate(e:Event):Void
	{
		if (seq != null)
			seq.update(10);
	}
	
	private function onSeqComplete(e:Dynamic):Void
	{
		seq.removeEventListener(TaskEvent.COMPLETE, onSeqComplete);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		format = null;
	}
	
}