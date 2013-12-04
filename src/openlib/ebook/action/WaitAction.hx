package openlib.ebook.action;

import openlib.tasks.TimeBasedTask;

/**
 * ...
 * @author Lean
 */
 typedef WaitActionFormat = {
	duration:Int
 }
 
class WaitAction extends TimeBasedTask
{
	var data:WaitActionFormat;

	public function new(data:WaitActionFormat) 
	{
		super(data.duration);
		this.data = data;
	}
	
}