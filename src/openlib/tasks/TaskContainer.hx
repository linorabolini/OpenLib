package openlib.tasks;

	/** Abstract base class for all task collection classes. */
	class TaskContainer extends Task
	{
		public var taskCompleteCallback:Task->Void;
		public var subtasks:Array<Task>;
		public var autoStartAddedTasks:Bool;
		
		public function new(autoStartAddedTasks:Bool = true, tasks: Array<Task> = null)
		{
			super();
			this.autoStartAddedTasks = autoStartAddedTasks;
			this.subtasks = new Array<Task>();
			if(tasks != null)
				this.addTasks(tasks);
		}

		/** Add a task to the container. */
		public function add(task:Task):Void
		{
			this.subtasks.push(task);
			task.addEventListener(TaskEvent.COMPLETE, this.onSubTaskComplete);
			if (autoStartAddedTasks && this.running)
				task.start();
		}

		public function addTasks(tasks:Array<Task>):Void
		{
			for (task in tasks)
				this.add(task);
		}

		public function disposeTask(task:Task):Void
		{
			task.removeEventListener(TaskEvent.COMPLETE, this.onSubTaskComplete);
			task.dispose();
		}
		
		/** @inheritDoc */
		public function remove(task:Task):Void
		{
			disposeTask(task);
			subtasks.remove(task);
		}

		public function onSubTaskComplete(ev:TaskEvent):Void
		{
			var task:Task = cast ev.target;
			if (taskCompleteCallback != null) {
				taskCompleteCallback(task);
			}
			this.remove(task);
		}

		/**
		 * @inheritDoc
		 */
		public override function start():Void
		{
			if (running) return;
			super.start();
			if (autoStartAddedTasks)
				for (task in subtasks.copy())
					task.start();
		}
		
		/**
		 * @inheritDoc
		 */
		public override function stop():Void
		{
			if (!running) return;
			super.stop();
			if (autoStartAddedTasks)
				for (task in subtasks.copy())
					task.stop();
		}
		
		/** @inheritDoc */
		public override function dispose():Void
		{
			super.dispose();
			
			for (task in subtasks)
				disposeTask(task);
			
			subtasks = [];
		}

		/** @inheritDoc */
		public override function update(milliseconds:Int):Void
		{
			super.update(updateSubtasks(milliseconds));
		}

		public function updateSubtasks(milliseconds:Int):Int
		{
			var consumed:Int = 0;
			for (task in subtasks.copy())
			{
				if (task.running)
					consumed = cast Math.max(consumed, updateSubtask(task, milliseconds));
			}
			return running ? consumed : milliseconds;
		}

		function get_empty():Bool 
		{
			return subtasks.length == 0;
		}
		
		public var empty(get_empty, null):Bool;
	}

