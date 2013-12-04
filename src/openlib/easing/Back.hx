package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Back
{

	public function new() 
	{
	}
	
	private static var s:Float = 1.70158; // Should be a parameter
	
	public static function easeIn(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return change*(time/=duration)*time*((s+1)*time - s) + start;
	}
	
	public static function easeOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		return change*((time=time/duration-1)*time*((s+1)*time + s) + 1) + start;
	}
	
	public static function easeInOut(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
	{
		if ((time /= duration / 2) < 1) 
			return change/2*(time*time*(((s*=(1.525))+1)*time - s)) + start;
		
		return change/2*((time-=2)*time*(((s*=(1.525))+1)*time + s) + 2) + start;
	}
	
}