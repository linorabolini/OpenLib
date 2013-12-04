package openlib.ui;

import haxe.Json;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.events.MouseEvent;
import flash.Lib;

class UILayout
{
	public static var LEFT:Int = -1;
	public static var CENTER:Int = 2;
	public static var RIGHT:Int = 4;
	public static var UP:Int = 6;
	public static var DOWN:Int = 5;
	
}

class UIUtil
{
	
	private static inline var TO_PERC:Float = 1 / 100;
	
	public static var STAGE_WIDTH:Float;
	public static var STAGE_HEIGHT:Float;
	
	public static var PIXEL_WIDTH:Float = 1024;
	public static var PIXEL_HEIGHT:Float = 768;
	
	public static var ASSETS_WIDTH:Float = 1024;
	public static var ASSETS_HEIGHT:Float = 768;
	public static var RATIO:Float = 1;
	
	
	public static var instance:Main;
	
	
	// screen offset used for secure area config
	static public var MARGIN_DOWN:Float = 0;
	
	static function __init__()
	{
	}
		
	public static function getStage():Stage
	{
		return Lib.current.stage;
	}
	
	public static function getAssetsRatio():Float
	{
		return ASSETS_HEIGHT / getStageHeight();
	}
	
	public static function getStageWidth():Float
	{
		return STAGE_WIDTH;
	}
	
	public static function getStageHeight():Float
	{
		return STAGE_HEIGHT;
	}
	
	public static function getAssetHeight():Float
	{
		return ASSETS_HEIGHT;
	}
	
	public static function getAssetWidth():Float
	{
		return ASSETS_WIDTH;
	}
	
	public static function virtualToPixelX(x:Float):Float {
		return x * RATIO;
	}
	
	public static function virtualToPixelY(y:Float):Float {
		return y * RATIO;
	}
	
	public static function pixelToVirtualX(x:Float):Float {
		return (x - instance.x) / RATIO;
	}
	
	public static function pixelToVirtualY(y:Float):Float {
		return (y - instance.y) / RATIO;
	}
	
	/**
	 * Modifies and object's x and y properties converting them from percetange to pixels
	 * @param	data
	 */
	public static function percToPixelObj(data:Dynamic):Void
	{
		data.x = percToPixelX(data.x);
		data.y = percToPixelY(data.y);
	}
	
	public static function virtualToPixelObj(data:Dynamic, x:Float, y:Float):Void {
		data.x = virtualToPixelX(x);
		data.y = virtualToPixelY(y);
	}
			
	/**
	 * Modifies and object's x property converting it from percetange to pixels
	 * @param	data
	 */
	public static function percToPixelX(x:Float):Float
	{
		return x * ASSETS_WIDTH * TO_PERC;
	}
	
	/**
	 * Modifies and object's x property converting it from percetange to pixels
	 * @param	data
	 */
	public static function percToPixelAbsX(x:Float):Float
	{
		return x * ASSETS_WIDTH * TO_PERC;
	}
	
	/**
	 * Modifies and object's y property converting it from percetange to pixels
	 * @param	data
	 */
	public static function percToPixelY(y:Float):Float
	{
		return y * (ASSETS_HEIGHT - MARGIN_DOWN) * TO_PERC;
	}
	
	/**
	 * Modifies and object's y property converting it from percetange to pixels
	 * @param	data
	 */
	public static function percToPixelAbsY(y:Float):Float
	{
		return y * ASSETS_HEIGHT * TO_PERC;
	}
	
	public static function createButton(parent:DisplayObjectContainer, buttonNormal:String, buttonPressed:String, cb:Dynamic->Void, layoutX:Int = -1, layoutY:Int = -1):Button
	{
		var btn:Button = new Button( { idle: buttonNormal, pressed: buttonPressed }, cb );
		
		parent.addChild(btn);
		
		align(btn, layoutX, layoutY, true, true);
		
		return btn;
	}
	
	public static function createSwitch(parent:Sprite, switchIdle:String, switchActive:String, cb:Dynamic->Void,layoutX:Int = -1, layoutY:Int = -1):Switch
	{
		var swt:Switch = new Switch( { idle: switchIdle, pressed: switchActive }, cb );
		
		parent.addChild(swt);
		
		align(swt, layoutX, layoutY);
		
		return swt;
	}
	
	public static function createSelect(parent:Sprite, imgBackground:Array<String>, selectOpt:Array<String>, currentOpt:String, cb:Dynamic->Void,layoutX:Int = -1, layoutY:Int = -1):Select
	{
		var slt:Select = new Select( { idle: imgBackground, opt: selectOpt, cOpt: currentOpt }, cb);
		
		parent.addChild(slt);
		
		align(slt, layoutX, layoutY);
		
		return slt;
	}
	
	public static function createSlide(parent:Sprite, imgBackground:String, imgSlide:String, initialPos:Float, cb:Dynamic->Void,layoutX:Int = -1, layoutY:Int = -1):Slide
	{
		var sld:Slide = new Slide( { idle:imgBackground, slide:imgSlide, ini:initialPos }, cb);
		
		parent.addChild(sld);
		
		align(sld, layoutX, layoutY);
		
		return sld;
	}
	
	public static function align(object:DisplayObject, layoutX:Int, layoutY:Int, useAssetsWidth:Bool = false, useAssetsHeight:Bool = false) {
		alignX(object, layoutX, useAssetsWidth);
		alignY(object, layoutY, useAssetsHeight);
	}
	
	public static function alignX(object:DisplayObject, layout:Int, useAssetsWidth:Bool = false) {
		var parentWidth = useAssetsWidth ? ASSETS_WIDTH: object.parent.width;
		
		switch (layout)
		{
			case UILayout.CENTER:
				object.x = (parentWidth - object.width) * 0.5;
			case UILayout.RIGHT:
				object.x = parentWidth - object.width;
			default:
				object.x = 0;
		}
	}	
	
	public static function alignY(object:DisplayObject, layout:Int, useAssetsHeight:Bool = false) {
		var parentHeight = useAssetsHeight ? ASSETS_HEIGHT - MARGIN_DOWN: object.parent.height;
		
		switch (layout)
		{
			case UILayout.DOWN:
				object.y = parentHeight - object.height;
			case UILayout.CENTER:
				object.y = (parentHeight - object.height) * 0.5;
			default:
				object.y = 0;
		}
	}
	
	public static function rotateAroundCenter(ob:DisplayObject, angleDegrees:Float):Void
	{
		if (ob.parent == null)
			return;
		
		var matrix:Matrix = ob.transform.matrix;
		var rect:Rectangle = ob.getBounds(ob.parent); 

		matrix.translate(- (rect.left + (rect.width *0.5)), - (rect.top + (rect.height * 0.5))); 
		matrix.rotate((angleDegrees/180)*Math.PI); 
		matrix.translate(rect.left + (rect.width * 0.5), rect.top + (rect.height * 0.5));

		ob.transform.matrix = matrix;
	}
	
	static public function init(main:Main) 
	{
		instance = main;
		var info:Dynamic = Json.parse(Assets.getText("img/info.json"));
		
		ASSETS_HEIGHT = info.height;
		ASSETS_WIDTH = info.width;
		STAGE_HEIGHT = ASSETS_HEIGHT; //getStage().stageHeight;
		STAGE_WIDTH = ASSETS_WIDTH; //getStage().stageWidth;
		
		trace("Stage size = " + STAGE_WIDTH + "x" + STAGE_HEIGHT);
		trace("Assets size = " + ASSETS_WIDTH + "x" + ASSETS_HEIGHT);
		trace("Assets ratio = " + getAssetsRatio());
	}

}
