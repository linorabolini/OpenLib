package openlib.ebook;

/**
 * ...
 * @author Lean
 */
class Camera
{
	
	public static var x:Float = 0;
	public static var y:Float = 0;
	public static var px:Float = 0;
	public static var py:Float = 0;
	
	public static function info():String
	{
		return "Camera [x: " + x + ", y: " + y + "]";
	}
	
	public static function reset():Void
	{
		x = y = px = py = 0;
	}

	public function new() 
	{
		throw "Cannot instantiate a Camera";
	}
	
}