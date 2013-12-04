package openlib.entity;
import openlib.entity.Entity;

/**
 * ...
 * @author 
 */
class MatrixEntity<T:Entity> implements Entity
{
	public var width:Int;
	public var height:Int;
	public var slots:Int;
	
	var data:Array<T>;
	
	public function new(width:Int, height:Int) 
	{
		//============================================
		
		this.width = width;
		this.height = height;
		this.slots = width * height;
		
		// init the data
		data = [];
		
		for (i in 0...slots)
		{
			data[i] = null;
		}
		
		//============================================
	}
	
	
	public function set(row:Int, col:Int, value:T) :Void
	{
		data[col + row * width] = value;
	}
	

	public function get(row:Int, col:Int) :T
	{
		return data[col + row * width] ;
	}
	

	public function update():Void 
	{
		//============================================
		
		// init the data
		for (i in 0...slots)
		{
			if(data[i] != null)
				data[i].update();
		}
		
		//============================================
	}
	
	public function dispose():Void 
	{
		//============================================
		
		// CLEAR THE DATA
		for (i in 0...slots)
		{
			if(data[i] != null)
				data[i].dispose();
			data[i] = null;
		}
		data = null;
		
		//============================================
	}
	
}