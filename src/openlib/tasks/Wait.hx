package openlib.tasks;

/**
 * A task that does nothing for a given duration.
 *
 * @see TaskRunner
 */
class Wait extends TimeBasedTask
{
	public function new(duration:Int)
	{
		super(duration);
	}
}

