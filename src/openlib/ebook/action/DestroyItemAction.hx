package openlib.ebook.action;

import flash.Assets;
import flash.display.Bitmap;
import flash.display.DisplayObject;
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
 typedef DestroyItemActionFormat = {
	id:String,
 }
 
class DestroyItemAction extends Task
{
	
	private var nextAction:Dynamic;
	private var seq:Task;
	private var format:DestroyItemActionFormat;

	public function new(format:DestroyItemActionFormat) 
	{
		super();
		
		this.format = format;
	}
	
	override public function start():Void 
	{
		super.start();
		
		try
		{
			var e:DisplayObject = cast EntityManager.getEntity(format.id);
			
			if (e != null)
			{
				e.parent.removeChild(e);
			
				EntityManager.removeEntity(format.id);
			}
		}
		catch (ex:Dynamic)
		{
			// Ok I guess
		}
		
		this.taskComplete();
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		format = null;
	}
	
}