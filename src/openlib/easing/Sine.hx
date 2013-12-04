package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Sine
{

	public function new() 
	{
	}
	
	public static function easeIn(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return -change * Math.cos(time/duration * (Math.PI/2)) + change + start;
	}
	
	public static function easeOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return change * Math.sin(time/duration * (Math.PI/2)) + start;
	}
	
	public static function easeInOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return -change/2 * (Math.cos(Math.PI*time/duration) - 1) + start;
	}
	
}