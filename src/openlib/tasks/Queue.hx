package openlib.tasks;

/**
 * A task container runs one task at a time. It won't end if empty.
 *
 * @see TaskRunner
 */
class Queue extends TaskContainer
{
	/**
	 * Create a Queue task.
	 *
	 * <p>This constructor accepts either an array of Task objects, or all the
	 * Tasks directly as arguments.</p>
	 */
	public function new(tasks: Array<Task> = null)
	{
		super(false, tasks);
	}

	/**
	 * @inheritDoc
	 */
	public override function start():Void
	{
		if (running)
			return;
		super.start();
		startNext();
	}

	public function startNext():Void
	{
		if (currentTask != null)
		{
			if (!currentTask.running)
				currentTask.start();
		}			
		else
		{
			dispatchEvent(new QueueEvent(QueueEvent.EMPTY));
		}
		
	}

	public override function add(task:Task):Void
	{
		super.add(task);

		if (running && subtasks.length == 1)
			startNext();
	}
	
	override public function remove(task:Task):Void
	{
		var wasFirst:Bool = task == currentTask;
		super.remove(task);
		
		if (running && wasFirst)
			startNext();
	}

	/**
	 * @inheritDoc
	 */
	public override function stop():Void
	{
		if (!running)
			return;
		super.stop();
		if (!empty && currentTask.running)
			currentTask.stop();
	}

	public override function updateSubtasks(milliseconds:Int):Int
	{
		var task:Task;
		var remaining:Int = milliseconds;

		while (remaining > 0 && !empty)
		{
			task=currentTask;
			remaining-=updateSubtask(task, remaining);

			if (task == currentTask)
				break;
		}
		// remaing should never yield less than 0
		// but special tasks like AudioTask make it possible sometimes
		return calculateConsumed(milliseconds,cast Math.max(remaining, 0));
	}

	public function calculateConsumed(total:Int, remaining:Int):Int
	{
		return total;
	}
	
	public var currentTask(get_currentTask, null):Task;
	
	private function get_currentTask():Task
	{
		return cast subtasks[0];
	}
}


