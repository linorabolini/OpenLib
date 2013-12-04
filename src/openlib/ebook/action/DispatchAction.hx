package openlib.ebook.action;

import flash.events.Event;
import flash.events.IEventDispatcher;
import openlib.entity.SpriteEntity;
import openlib.entityManager;
import openlib.tasks.Task;

typedef DispatchActionFormat = {
	dispatcher:String,
	event:String
}

class DispatchAction extends Task
{
	
	private var data:DispatchActionFormat;
	private var dispatcher:SpriteEntity;
	private var removeDispatcher:Bool;
	
	public function new(data:DispatchActionFormat)
	{
		super();
		this.data = data;
		
		dispatcher = cast EntityManager.getEntity(data.dispatcher);
		
		if (dispatcher == null)
		{
			dispatcher = new SpriteEntity();
			EntityManager.addEntity(data.dispatcher, dispatcher);
		}
	}

	/**
	 * @inheritDoc
	 */
	public override function start():Void
	{
		super.start();
		
		dispatcher.dispatchEvent(new Event(data.event));
		
		super.taskComplete();
	}
	
	/**
	 * @inheritDoc
	 */
	public override function stop():Void
	{
		super.stop();

	}
	
}
