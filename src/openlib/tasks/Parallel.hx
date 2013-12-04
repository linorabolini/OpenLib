package openlib.tasks;

	/**
	 * A set of tasks that will run in parallel.
	 *
	 * <p>When the Parallel task is started, all contained tasks are started
	 * at once.</p>
	 *
	 * @see TaskRunner
	 */
	class Parallel extends TaskContainer
	{
		/**
		 * Create a Parallel task.
		 *
		 * <p>This constructor accepts either an array of Task objects, or all the
		 * Tasks directly as the function arguments.</p>
		 */
		public function new(tasks: Array<Task> = null)
		{
			super(true, tasks);
		}

		/** @inheritDoc */
		public override function start():Void
		{
			super.start();
			checkComplete();
		}

		public function checkComplete():Void
		{
			if (this.subtasks.length == 0)
				this.taskComplete();
		}

		public override function onSubTaskComplete(ev:TaskEvent):Void
		{
			super.onSubTaskComplete(ev);
			checkComplete();
		}
	}


