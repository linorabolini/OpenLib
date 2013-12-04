package openlib.managers;
import flash.Assets;
import flash.text.Font;
import flash.text.TextFormat;
import openlib.ui.UIUtil;

typedef TextStyleFormat = {
	id:String,
	font:String,
	size:Float,
	color:Int,
	bold:Bool,
	italic:Bool,
	underline:Bool
}


/**
 * ...
 * @author Lean
 */
class TextStyleManager
{
	static public var FONT_ROOT_DIR:String = "assets/fonts/";
	private static var _styles:Map<String,TextFormat>;
	
	public static function load(styleArray:Array<TextStyleFormat>, ?createStyleFunction:TextStyleFormat->TextFormat):Void
	{
		createStyleFunction = createStyleFunction == null ? createStyle : createStyleFunction;
		
		for (style in styleArray)
			getStyles().set(style.id, createStyleFunction(style));
	}
	
	static private function createStyle(tsf:TextStyleFormat):TextFormat
	{
		var f = Assets.getFont(FONT_ROOT_DIR + tsf.font);
		if (f == null)
			throw "Font " + tsf.font + " not found";
		
		var tff = new TextFormat(f.fontName, UIUtil.percToPixelY(tsf.size), tsf.color);
		
		return tff;
	}
	
	static private function getFont(font:String):Font
	{
		return Assets.getFont(FONT_ROOT_DIR + font);
	}
	
	public static function unload():Void
	{
		setStyles(null);
	}
	
	public static function getStyle(id:String):TextFormat
	{
		if (getStyles() == null) return null;
		if(getStyles().exists(id))
			return getStyles().get(id);
		else
			return null;
	}
	
	
	// ==================================
	// STYLES STATIC HASH
	

	static function getStyles():Map<String,TextFormat> 
	{
		if (_styles == null) setStyles(new Map<String,TextFormat>());
		return _styles;
	}
	
	static function setStyles(value:Map<String,TextFormat>):Map<String,TextFormat> 
	{
		return _styles = value;
	}
	
	//===================================
	
	
}