package openlib.util;
import flash.Lib;

/**
 * ...
 * @author Lino
 */
class Time
{
	static public var dt:Float;
	
	static private inline var MIN_STEP:Float = 0.2;
	static private var lastTime;

	static public function update():Void {
		dt = (Lib.getTimer() - lastTime) * 0.001;
		dt = Math.min(MIN_STEP, dt);
		
		// update current time
		lastTime = Lib.getTimer();
	}
	
	static public function init() 
	{
		lastTime = Lib.getTimer();
	}
	
	
	
}