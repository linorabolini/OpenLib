package openlib.tasks;
import openlib.tasks.Task;

/** Abstract base class for all tasks that have a fixed duration. */
class TimeBasedTask extends Task
{
	/** Task duration */
	public var duration:Int;

	public function new(duration:Int)
	{
		super();
		this.duration = duration;
	}

	/**
	 * Amount of time that must be elapsed until the animation finishes.
	 */
	public var timeLeft(get_timeLeft, null):Int;
	
	function get_timeLeft():Int 
	{
		return duration - elapsed;
	}
	
	/** @inheritDoc */
	public override function update(milliseconds:Int):Void
	{
		var consumed:Int = cast Math.min(milliseconds, this.timeLeft);
		super.update(consumed);
		updateState(consumed);
		if (elapsed == duration)
			this.taskComplete();
	}

	public function updateState(milliseconds:Int):Void
	{
	}
}
