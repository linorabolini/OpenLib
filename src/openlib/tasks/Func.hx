package openlib.tasks;

/**
 * Function call task.  This is a special task that calls a callback function and ends immediately after.
 * 
 * @example This example will wait 0.5 secs, execute someFunction with no arguments, then wait another 0.5 secs, and finally trace "Done.":
 * <listing version="3.0">
 * 	tasks.add(
 * 		new Sequence(
 *			new Wait(500),
 * 			new Func(someFunction),
 *			new Wait(500),
 * 			new Func(trace, "Done."),
 * 		)
 * 	)
 * </listing>
 *
 * @see TaskRunner
 */
class Func extends Task
{
	private var cb:?Dynamic->Void;
	var arg:Dynamic;

	/**
	 * Create a Func task.
	 *
	 * @param callback The callback function.
	 */
	public function new(cb:?Dynamic->Void, arg:Dynamic = null)
	{
		super();
		this.cb = cb;
		this.arg = arg;
	}
			
	/**
	 * @inheritDoc
	 */
	public override function start():Void
	{
		super.start();
		if (this.cb != null)
			if(arg != null)
				this.cb(arg);
			else
				this.cb();
		this.taskComplete();
	}
}

