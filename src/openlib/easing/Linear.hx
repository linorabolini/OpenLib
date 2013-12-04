package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Linear
{

	public function new() 
	{
	}
	
	/**
		 * Linear easing, by Robert Penner.
		 *
		 * @param time Easing time, normally between 0 and <code>duration</code>.
		 * @param start Value to be returned when <code>time = 0</code>.
		 * @param change Output change. When <code>time = duration</code>, the value returned will be <code>start + change</code>.
		 * @param duration Easing duration.
		 */
		public static function ease(time:Float, start:Float = 0, change:Float = 1, duration:Float = 1):Float
		{
			return change * time / duration + start;
		}

		/**
		 * Linear interpolation: given two coordinates <code>(x1,y1)</code>
		 * and <code>(x2,y2)</code>, return the <code>y</code> value that
		 * corresponds to the given <code>x</code>.
		 *
		 * <p> This function is equivalent to
		 * <code>Linear.ease(x - x1, y1, y2 - y1, x2 - x1)</code>
		 * </p>
		 *
		 * @param x Target <code>x</code> coordinate, for which the <code>y</code> coordinate will be returned.
		 * @param x1 x coordinate of the first known point.
		 * @param y1 y coordinate of the first known point.
		 * @param x2 x coordinate of the second known point.
		 * @param y2 y coordinate of the second known point.
		 */
		public static function lerp(x:Float, x1:Float = 0, y1:Float = 0, x2:Float = 1, y2:Float = 1):Float
		{
			return ease(x - x1, y1, y2 - y1, x2 - x1);
		}
		
		/**
		 * Eases a Float between two values within an <i>n</i> amount of ticks/calls.
		 *
		 * @param value Current value
		 * @param n Amount of calls required to get from start to end
		 * @param start Starting value
		 * @param end Final value
		 */
		public static function step(value:Float, n:Int, start:Float = 0, end:Float = 1):Float
		{
			return openlib.math.FMath.clamp(value + (end - start) / n, start, end); 
		}
	
}