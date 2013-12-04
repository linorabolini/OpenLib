//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package openlib.math;

/**
 * Some handy math functions, and inlinable constants.
 */
class FMath
{
    public static inline var E:Float = 2.718281828459045;
    public static inline var LN2:Float = 0.6931471805599453;
    public static inline var LN10:Float = 2.302585092994046;
    public static inline var LOG2E:Float = 1.4426950408889634;
    public static inline var LOG10E:Float = 0.43429448190325176;
    public static inline var PI:Float = 3.141592653589793;
    public static inline var SQRT1_2:Float = 0.7071067811865476;
    public static inline var SQRT2:Float = 1.4142135623730951;

    /** Converts an angle in degrees to radians. */
    inline public static function toRadians (degrees :Float) :Float
    {
        return degrees * PI/180;
    }

    /** Converts an angle in radians to degrees. */
    inline public static function toDegrees (radians :Float) :Float
    {
        return radians * 180/PI;
    }

    inline public static function max (a :Float, b :Float) :Float
    {
        return (a > b) ? a : b;
    }

    inline public static function min (a :Float, b :Float) :Float
    {
        return (a < b) ? a : b;
    }

    public static function clamp (value :Float, min :Float, max :Float) :Float
    {
        return if (value < min) min
            else if (value > max) max
            else value;
    }

    public static function sign (value :Float) :Int
    {
        return if (value < 0) -1
            else if (value > 0) 1
            else 0;
    }
	
	public static function interpolate(value1:Float, value2:Float, alpha:Float):Float
	{
		return (1 - alpha) * value1 + value2 * alpha;
	}
	
	public static inline function getRandomBetween(min:Float, max:Float):Float {
		return min + Math.random() * (max - min);
	}
}
