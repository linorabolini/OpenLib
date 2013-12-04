package openlib.data;

/**
 * ...
 * @author 
 */
class Tile
{
	public var x:Int = -1;
	public var y:Int = -1;
	
	public function new(x:Int,y:Int) 
	{
		this.x = x;
		this.y = y;
	}
	
	public function toString():String
	{
		return "["+x+","+y+"]";
	}
	
	public function equals(tile:Tile):Bool
	{
		return (tile.x == x && tile.y == y);
	}
	
	public function copy():Tile
	{
		return new Tile(x, y);
	}
}