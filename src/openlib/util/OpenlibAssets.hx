package openlib.util;
import flash.display.Bitmap;
import flash.geom.Matrix;
import haxe.Json;
import openfl.Assets;
import openlib.graphics.format.SVG;
import openlib.ui.UIUtil;
import openlib.util.OpenlibFile;
import flash.display.BitmapData;
import flash.display.Shape;

/**
 * ...
 * @author 
 */

typedef AssetsInfo =
{
	width:Int,
	height:Int
}

typedef ImageDef =
{
	id:String,
	path:String
}
 
class OpenlibAssets
{
	private static var keys:Map<String, String>;
	
	public static function getText(id:String):String
	{
		return Assets.getText(id);
	}
	
	public static function evictBitmapCache():Void
	{
		Assets.cache.clear();
	}
	
	public static function loadAssetKeys(data:Array<ImageDef>)
	{
		if (keys == null) keys = new Map<String, String>();
		
		for ( value in data)
			keys.set(value.id, value.path);
	}
	
	// bitmap data getter, parses svg and other files aredelegated to flash.Assets
	public static function getBitmapData(asset:String, useCache:Bool = true) :BitmapData
	{
		var fileType:String = OpenlibFile.getFileType(asset);
		var bitmapData:BitmapData;
		
		switch(fileType)
		{
			case ".svg":
				bitmapData = null;
				//bitmapData = getBitmapDataFromSVG(asset, useCache);
			case "":
				bitmapData = null;
			default:
				bitmapData = Assets.getBitmapData(asset, useCache);
		}
		
		return bitmapData;
	}
	
		// bitmap data getter, parses svg and other files aredelegated to flash.Assets
	public static function getBitmapDataByKey(key:String, useCache:Bool = true) :BitmapData
	{
		if (keys == null) throw "No keys were loaded";
		
		var asset = keys.get(key);
		return getBitmapData(asset, useCache);
	}
	
	// bitmap getter wrapper
	public static function getBitmap(asset:String, useCache:Bool = true) :Bitmap {
		return new Bitmap(OpenlibAssets.getBitmapData(asset, useCache));
	}
	
	static public function getBitmapByKey(key:String, useCache:Bool = true) : Bitmap
	{
		return new Bitmap(OpenlibAssets.getBitmapDataByKey(key, useCache));
	}	
	
	static public function getJSONObject(filePath:String) : Dynamic
	{
		return Json.parse(getText(filePath));
	}
}