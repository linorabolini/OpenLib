package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Expo
{

	public function new() 
	{
	}
	
	public static function easeIn(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return (time==0) ? start : change * Math.pow(2, 10 * (time/duration - 1)) + start;
	}
	
	public static function easeOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return (time==duration) ? start + change : change * (-Math.pow(2, -10 * time/duration) + 1) + start;
	}
	
	public static function easeInOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if (time == 0)
			return start;
		
		if (time == duration) 
			return start + change;
		
		if ((time /= duration / 2) < 1) 
			return change / 2 * Math.pow(2, 10 * (time - 1)) + start;
		
		return change/2 * (-Math.pow(2, -10 * --time) + 2) + start;
	}
	
}