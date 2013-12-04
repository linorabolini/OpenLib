package openlib.tasks;

import flash.events.Event;
import flash.events.IEventDispatcher;

/**
 * Task that finishes when certain event is triggered.
 * 
 * @example This example will trace only done after the "foo" event is triggered on a certain EventDispatcher  
 * <listing version="3.0">
 *  var d:EventDispatcher = new EventDispatcher();
 * 	tasks.add(
 * 		new Sequence(
 *			new WaitForEvent(d, "foo"),
 * 			new Func(trace, "Done."),
 * 		)
 * 	);
 *  setTimeout(d.dispatchEvent, 1000, new Event("foo"));
 * </listing>
 *
 * @see TaskRunner
 */

typedef AnyEventFormat = {
	dispatcher:IEventDispatcher,
	event:String
}
 
class WaitForAnyEvent extends Task
{
	public var events:Array<AnyEventFormat>;
	
	/**
	 * Create a WaitForEvent task.
	 *
	 * @param dispatcher The element that will dispatch the event
	 * @param event The event name
	 */
	
	public function new(events:Array<AnyEventFormat>)
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
		for (event in events)
			event.dispatcher.addEventListener(event.event,eventDispatched);
	}
	
	/**
	 * @inheritDoc
	 */
	public override function stop():Void
	{
		super.stop();
		for(event in events)
			event.dispatcher.removeEventListener(event.event,eventDispatched);
	}
	
}
