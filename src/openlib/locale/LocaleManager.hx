package openlib.locale;

/**
 * ...
 * @author Lean
 */
class LocaleManager
{
	
	private static var _lang:String;
	private static var _datas:Map<String,Dynamic>;

	public static function setup(lang:String):Void
	{
		_lang = lang;
		
		if (_datas == null)
			_datas = new Map<String,Dynamic>();
	}
	
	public static function addData(lang:String, id:String, data:Dynamic):Void
	{
		if (_datas == null)
			_datas = new Map<String,Dynamic>();
		
		_datas.set(lang + "-" + id, data);
	}
	
	public static function getData(id:String):Dynamic
	{
		check();
		
		var data = _datas.get(_lang + "-" + id);
		
		if (data == null)
		{
			trace("Data \"" + id + "\" not found for language \"" + _lang + "\"");
			data = id;
		}
		
		return data;
	}
	
	private static function check():Void
	{
		if (_lang == null || _datas == null)
			throw "The LocalManage is not configured";
	}
	
	public static function dispose():Void
	{
		_lang = null;
		_datas = null;
	}
	
}