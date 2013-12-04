package openlib.ebook.action;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import openlib.entityManager;
import openlib.tasks.Task;


typedef WaitForAllActionFormat = {
	dispatcher:String,
	event:String
}
 
class WaitForAllAction extends Task
{
	
	public var events:Array<WaitForAllActionFormat>;
	private var eventsMatched:Int = 0;
	
	/**
	 * Create a WaitForEvent task.
	 *
	 * @param dispatcher The element that will dispatch the event
	 * @param event The event name
	 */
	
	public function new(events:Array<WaitForAllActionFormat>)
	{
		super();
		this.events = events;

	}
	
	public function eventDispatched(e:Event):Void
	{
		var matches = 0;
		
		for (evt in this.events)
		{
			if (evt.event == e.type)
			{
				eventsMatched++;
				break;
			}
		}
		
		if (eventsMatched == this.events.length)
			this.taskComplete();
	}

	/**
	 * @inheritDoc
	 */
	public override function start():Void
	{
		super.start();
		
		for (data in events)
		{
			var dispatcher:IEventDispatcher = cast EntityManager.getEntity(data.dispatcher);
			dispatcher.addEventListener(data.event, eventDispatched);
		}
	}
	/**
	 * @inheritDoc
	 */
	public override function stop():Void
	{
		super.stop();
		for (data in events)
		{
			var dispatcher:IEventDispatcher = cast EntityManager.getEntity(data.dispatcher);
			
			if (dispatcher != null)
				dispatcher.removeEventListener(data.event, eventDispatched);
		}
	}
	
}
