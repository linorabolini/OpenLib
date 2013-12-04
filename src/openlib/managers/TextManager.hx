package openlib.managers;


typedef TextDataFormat = {
	text:String,
	style_base:String,
	style_changed:String
}


/**
 * ...
 * @author Lean
 */
class TextManager
{

	public static function load(pageID:String, object:TextDataFormat):Void
	{
		 get_texts().set(pageID, object);
	}
	
	public static function unload(page:String):Void
	{
		 get_texts().remove(page);
	}
	
	public static function getText(pageID:String,id:String):TextDataFormat
	{
		if (get_texts().get(pageID) == null) return null;
		return Reflect.field( get_texts().get(pageID),id);
	}
	
	
	// ==================================
	
	
	static function get_texts():Map<String,Dynamic> 
	{
		if (_texts == null) set_texts(new Map<String,Dynamic>());
		return _texts;
	}
	
	static function set_texts(value:Map<String,Dynamic>):Map<String,Dynamic> 
	{
		return _texts = value;
	}
	private static var _texts:Map<String,Dynamic>;
	
	
	//===================================
	
}