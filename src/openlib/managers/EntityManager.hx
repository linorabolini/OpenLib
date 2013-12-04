package openlib.managers;
import openlib.entity.Entity;

/**
 * ...
 * @author Lean
 */
class EntityManager
{
	
	private static var entities:Map < String, Map < String, Dynamic >> ;
	private static var groups:Array<String>;
	private static var groupIndexes:Map<String, Int>;
	
	private static function getEntities(group:String):Map<String,Dynamic>
	{
		if (entities == null)
			entities = new Map < String, Map < String, Dynamic >> ();
		
		if (groups == null)
			groups = new Array<String>();
		
		if (Lambda.indexOf(groups, group) < 0)
			groups.push(group);
		
		if (entities.get(group) == null)
			entities.set(group, new Map<String,Dynamic>());
		
		return entities.get(group);
	}
	
	public static function groupIndex(group:String):Int
	{
		if (groupIndexes == null)
			groupIndexes = new Map<String, Int>();
		
		if (groupIndexes.get(group) == null)
			groupIndexes.set(group, -1);
		
		groupIndexes.set(group, groupIndexes.get(group) + 1);
		
		return groupIndexes.get(group);
	}

	public static function addEntity(name:String, entity:Entity, group:String = "default"):Void
	{
		getEntities(group).set(name, { index: groupIndex(group), entity: entity } );
	}
	
	public static function getEntity(name:String, group:String = "default"):Entity
	{
		if (getEntities(group).get(name) == null)
			return null;
		else
			return getEntities(group).get(name).entity;
	}
	
	public static function getEntityNamesByGroup(group:String):Map<Int, String>
	{
		//var names:Array<String> = new Array<String>();
		var names:Map<Int, String> = new Map<Int, String>();
		
		for (entityName in getEntities(group).keys())
		{
			var entity = getEntities(group).get(entityName);
			names.set(entity.index, entityName);
		}
		
		return names;
	}
	
	public static function removeEntity(name:String, group:String = "default"):Void
	{
		getEntities(group).remove(name);
	}
	
	public static function update():Void
	{
		if (groups != null)
			for (group in groups)
			{
				var es = getEntities(group);
			
				for (k in es.keys())
					es.get(k).entity.update();
			}
	}
	
	public static function disposeGroup(group:String):Void
	{
		if (groups == null)
			return;

		var es = getEntities(group);
	
		for (k in es.keys())
		{
			es.get(k).entity.dispose();
			removeEntity(k, group);
		}
		entities.set(group, null);
		groups.remove(group);
		groupIndexes.set(group, 0);
	}
	
	public static function dispose():Void
	{
		if (groups == null)
			return;
		
		for (group in groups)
		{
			var es = getEntities(group);
		
			for (k in es.keys())
			{
				es.get(k).entity.dispose();
				removeEntity(k, group);
			}
		}
		
		entities = null;
		groups = null;
		groupIndexes = null;
	}
	
}