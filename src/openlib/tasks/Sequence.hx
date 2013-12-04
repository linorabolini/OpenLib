package openlib.tasks;

import flash.events.Event;

/**
 * A set of tasks that will run in sequence.
 *
 * @see TaskRunner
 */
class Sequence extends Queue
{
	/**
	 * Create a Sequence task.
	 *
	 * <p>This constructor accepts either an array of Task objects, or all the
	 * Tasks directly as arguments.</p>
	 */
	public function new(tasks: Array<Task> = null)
	{
		super(tasks);
	}
	
	/** @inheritDoc */
	public override function startNext():Void
	{
		if (empty)
			taskComplete();
		else
			super.startNext();				
	}
	
	public override function calculateConsumed(total:Int, remaining:Int) : Int
	{
		return total - remaining;
	}

}


