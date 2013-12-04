package openlib.easing;

import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;

/**
	 * Generic easing task.  This task will call a given update function on each time step.
	 * 
	 * <p>Example: 
	 * <pre>
	 * var ease:Ease = new Ease(trace, 500, 10.0, 20.0);
	 * </pre>
	 * When added to an TaskRunner, for 0.5 seconds the output will be something like:
	 * <pre>
	 * 10.0
	 * 10.0008232
	 * 10.0056928
	 * ...
	 * 19.9991920
	 * 19.9999013
	 * 20.0
	 * </pre>
	 * </p>
	 *
	 * @see TaskRunner
	 * @see Tween
	 * @see Easing
	 */
class Ease extends TimeBasedTask
{

	private var callback:Array<Float>->Void;
	private var from:Float;
	private var change:Float;
	private var args:Array<Float>;
	private var easeFunction:Float->Float->Float->Float->Float;

	/**
	 * Create an Ease task.
	 *
	 * @param updateFunction The function that will be called for each time step.  It will be passed the current tween value (between <code>from</code> and <code>to</code>), and any additional arguments passed to the constructor.
	 * @param duration Duration (in milliseconds) for the task.
	 * @param from Initial easing value.
	 * @param to Destination easing value.
	 * @param transition Any identifier accepted by <code>Easing.getFunction()</code>. Examples: "linear" (default), "easeIn", "easeOut", "easeInOut", "bounceEaseIn", etc.
	 *
	 * @see flashlib.tasks.TaskRunner
	 * @see Easing
	 */
	public function new(updateFunction:Array<Float>-> Void, duration:Int, from:Float = 0.0, to:Float = 1.0, transition:String = "linear", ?args:Array<Float>)
	{
		super(duration);
		this.callback = updateFunction;
		this.args = args == null ? []: args;
		this.from = from;
		this.change = to - from;
		this.easeFunction = Easing.getFunction(transition);
	}

	/** @inheritDoc */
	public function clone():Task
	{
		var ease:Ease = new Ease(callback, cast duration);
		ease.args = args;
		ease.from = from;
		ease.change = change;
		ease.easeFunction = easeFunction;
		return ease;
	}

	/**
	 * Utility function to create an Ease task from an arguments array.
	 *
	 * @param callback The callback function.
	 * @param args The arguments that will be passed to the callback function.
	 */
	public static function fromArgsArray(updateFunction:Array<Float>-> Void, duration:Int, from:Float = 0.0, to:Float = 1.0, transition:String = "linear", ?args:Array<Float>):Ease
	{
		var e = new Ease(updateFunction, duration, from, to, transition);
		
		if (args != null)
			e.args = args;
		
		return e;
	}
	
	/** @inheritDoc */
	public override function updateState(milliseconds:Int):Void
	{
		var tween:Float = this.easeFunction(this.elapsed, from, change, this.duration);
		
		var r:Array<Float> = [tween];
		
		for (a in args)
			r.push(a);
		
		this.callback(r);
	}
}
