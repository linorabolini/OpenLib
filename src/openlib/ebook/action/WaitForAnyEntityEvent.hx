package openlib.ebook.action;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import openlib.entityManager;
import openlib.tasks.Task;


typedef AnyEntityEventFormat = {
	dispatcher:String,
	event:String
}
 
class WaitForAnyEntityEvent extends Task
{
	public var events:Array<AnyEntityEventFormat>;
	
	/**
	 * Create a WaitForEvent task.
	 *
	 * @param dispatcher The element that will dispatch the event
	 * @param event The event name
	 */
	
	public function new(events:Array<AnyEntityEventFormat>)
	{
		super();
		this.events = events;
	}
	
	public function eventDispatched(e:Event):Void
	{
		this.taskComplete();
	}

	/**
	 * @inheritDoc
	 */
	public override function start():Void
	{
		super.start();
		for (data in events) {
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
		for(data in events) {
			var dispatcher:IEventDispatcher = cast EntityManager.getEntity(data.dispatcher);
			dispatcher.removeEventListener(data.event, eventDispatched);
		}
	}
	
}
