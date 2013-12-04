package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Quad
{

	public function new() 
	{
	}
	
	public static function easeIn(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return change * (time /= duration) * time + start;
	}
	
	public static function easeOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return -change * (time /= duration) * (time - 2) + start;
	}
	
	public static function easeInOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if ((time /= duration / 2) < 1)
			return change / 2 * time * time + start;
		return -change / 2 * ((--time) * (time - 2) - 1) + start;
	}
	
}