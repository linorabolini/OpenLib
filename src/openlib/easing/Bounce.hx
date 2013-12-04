package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Bounce
{

	public function new() 
	{
	}
	
	public static function easeIn(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if ((time /= duration) < (1 / 2.75))
		{
			return change * (7.5625 * time * time) + start;
		} else if (time < (2 / 2.75))
		{
			return change * (7.5625 * (time -= (1.5 / 2.75)) * time + .75) + start;
		} else if (time < (2.5 / 2.75))
		{
			return change * (7.5625 * (time -= (2.25 / 2.75)) * time + .9375) + start;
		}
		else
		{
			return change * (7.5625 * (time -= (2.625 / 2.75)) * time + .984375) + start;
		}
	}
	
	public static function easeOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return change - easeIn(duration - time, 0, change, duration) + start;
	}
	
	public static function easeInOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if (time < (duration / 2))
		{
			return easeIn((time * 2), 0, change, duration) * .5 + start;
		}
		else
		{
			return easeOut((time * 2) - duration, 0, change, duration) * .5 + change*.5 + start;
		}
	}
	
}