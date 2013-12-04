package openlib.util;
import flash.geom.Point;

/**
 * ...
 * @author 
 */
class Converter
{
	static public function dynamicArrayToPointArray(dynamicArray:Array<Dynamic>):Array<Point>
	{
		var tmp:Array<Point> = new Array<Point>();
		
		for (p in dynamicArray) {
			tmp.push(new Point(p.x, p.y));
		}
		
		return tmp;
	}
	
}