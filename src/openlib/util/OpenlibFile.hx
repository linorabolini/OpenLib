package openlib.util;

/**
 * ...
 * @author 
 */
class OpenlibFile
{

	public static function getFileType(fileName:String):String
	{
		if (fileName == null) return "";
		var termination:String = fileName.substring(fileName.lastIndexOf("."));
		
		return termination;
	}
	
}