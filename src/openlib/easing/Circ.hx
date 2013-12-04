package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Circ
{

	public function new() 
	{
	}
	
	public static function easeIn(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return -change * (Math.sqrt(1 - (time/=duration)*time) - 1) + start;
	}
	
	public static function easeOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return change * Math.sqrt(1 - (time=time/duration-1)*time) + start;
	}
	
	public static function easeInOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if ((time /= duration / 2) < 1) 
			return -change/2 * (Math.sqrt(1 - time*time) - 1) + start;
		
		return change/2 * (Math.sqrt(1 - (time-=2)*time) + 1) + start;
	}
	
}