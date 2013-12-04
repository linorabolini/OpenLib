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

class WaitForEvent extends Task
{
	public var dispatcher:IEventDispatcher;
	public var event:String;
	
	/**
	 * Create a WaitForEvent task.
	 *
	 * @param dispatcher The element that will dispatch the event
	 * @param event The event name
	 */
	
	public function new(dispatcher:IEventDispatcher, event:String)
	{
		super();
		this.dispatcher = dispatcher;
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
		dispatcher.addEventListener(event,eventDispatched);
	}
	
	/**
	 * @inheritDoc
	 */
	public override function stop():Void
	{
		super.stop();
		dispatcher.removeEventListener(event,eventDispatched);
	}
	
}
