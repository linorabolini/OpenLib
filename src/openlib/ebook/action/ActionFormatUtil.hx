package openlib.ebook.action;

/**
 * ...
 * @author Lean
 */
class ActionFormatUtil
{

	public static function fixDefaults(format:Dynamic):Void
	{
		if (format.visible == null)
			format.visible = true;
	}
	
}