package openlib.ebook.action;

import flash.events.Event;
import flash.events.IEventDispatcher;
import openlib.entityManager;
import openlib.tasks.Task;


class WaitForEntityEvent extends Task
{
	public var dispatcherID:String;
	public var event:String;
	
	/**
	 * Create a WaitForEvent task.
	 *
	 * @param dispatcher The element that will dispatch the event
	 * @param event The event name
	 */
	
	public function new(dispatcherID:String, event:String)
	{
		super();
		this.dispatcherID = dispatcherID;
		this.event = event;
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
		var dispatcher:Dynamic = cast EntityManager.getEntity(dispatcherID);
		dispatcher.addEventListener(event,eventDispatched);
	}
	
	/**
	 * @inheritDoc
	 */
	public override function stop():Void
	{
		super.stop();
		var dispatcher:IEventDispatcher = cast EntityManager.getEntity(dispatcherID);
		
		if (dispatcher != null)
			dispatcher.removeEventListener(event,eventDispatched);
	}
	
}
