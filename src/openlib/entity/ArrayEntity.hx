package openlib.entity;

import openlib.entity.Entity;

/**
 * ...
 * @author Lino
 */
class ArrayEntity<T:Entity> implements Entity
{
	
	var entities:Array<T>;
	public function new() 
	{
		entities = [];
	}	
	
	public function update():Void 
	{
		for (e in entities)
		{
			e.update();
		}
	}
	
	public function dispose():Void 
	{
		for (e in entities)
		{
			e.dispose();
		}
		
		entities = null;
	}
	
	public function getEntities():Array<T>
	{
		return entities;
	}
	
}