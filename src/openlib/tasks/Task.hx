package openlib.tasks;

import flash.events.Event;
import flash.events.EventDispatcher;
/**
 * ...
 * @author ...
 */
class Task extends EventDispatcher
{

	public var running:Bool;
	public var elapsed:Int;

	public function new()
	{
		super();
		elapsed = 0;
		running = false;
	}

	/**
	 * @inheritDoc
	 */
	public function start():Void
	{
		if (running) return;
			running = true;
	}
	
	/**
	 * @inheritDoc
	 */
	public function stop():Void
	{
		if (!running) return;
			running = false;
	}
	
	/**
	 * @inheritDoc
	 */
	public function dispose():Void
	{
		if (running)
			stop();
	}
	
	/** @inheritDoc */
	public function update(milliseconds:Int):Void
	{
		elapsed += milliseconds;
	}

	public function taskComplete():Void
	{
		this.stop();
		dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
	}

	public function updateSubtask(task:Task, milliseconds:Int):Int
	{
		var prev:Int = task.elapsed;
		task.update(milliseconds);
		return task.elapsed - prev;
	}
	


	
}