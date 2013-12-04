package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Elastic
{

	public function new() 
	{
	}
	
	private static var p:Float = 0.3;
	private static var a:Float = 0;
	
	public static function easeIn(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if (time == 0) return start;  
		if ((time /= duration) == 1) return start + change;
		var s:Float;
		if (a == 0 || a < Math.abs(change))
		{
			a = change; 
			s = p / 4; 
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin(change / a);	
		}
		return -(a * Math.pow(2, 10 * (time -= 1)) * Math.sin((time - s) * (2 * Math.PI) / p)) + start;
	}
	
	public static function easeOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if (time == 0) return start;  
		if ((time /= duration) == 1) return start + change;  
		var s:Float;
		if (a == 0 || a < Math.abs(change))
		{
			a = change; 
			s = p / 4; 
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin(change / a);
		}
		return (a * Math.pow(2, -10 * time) * Math.sin((time - s) * (2 * Math.PI) / p) + change + start);
	}
	
	public static function easeInOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if (time == 0) return start;
		if ((time /= duration / 2) == 2) return start + change;
		var s:Float;
		if (a == 0 || a < Math.abs(change))
		{
			a = change; 
			s = p / 4; 
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin(change / a);
		}
		if (time < 1) return -.5 * (a * Math.pow(2, 10 * (time -= 1)) * Math.sin((time - s) * (2 * Math.PI) / p)) + start;
		return a * Math.pow(2, -10 * (time -= 1)) * Math.sin((time - s) * (2 * Math.PI) / p) * .5 + change + start;
	}
	
}