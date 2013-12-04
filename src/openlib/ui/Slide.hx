package openlib.ui;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import openlib.util.OpenlibAssets;

/**
 * ...
 * @author Jeremias
 */
class Slide extends Sprite
{
	
	private var backgroundImg:Bitmap;
	private var slideImg:Bitmap;
	private var onUpCB:MouseEvent -> Void;
	private var onDownCB:MouseEvent -> Void;
	private var ini:Float = 50;
	private var percent:Float;
	private var flag:Bool;
	
	
	// data.idle, data.slide, data.ini, data.ver
	
	public function new(data:Dynamic, onMoved:Dynamic->Void = null) 
	{
		super();		
		
		backgroundImg = new Bitmap (OpenlibAssets.getBitmapData(data.idle));
		addChild(backgroundImg);	
		
		slideImg = new Bitmap (OpenlibAssets.getBitmapData(data.slide));
		addChild(slideImg);
		
		ini = (data.ini * backgroundImg.width);
			if (ini > backgroundImg.width - slideImg.width) {
				ini = backgroundImg.width - slideImg.width;
			}
		
		slideImg.x = ini;
		
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		
		if (onMoved != null) {
			addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		}
		
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		if(flag == true){
			updateSlide(e);
			
		}
	}
	
	private function onMouseUp(e:MouseEvent):Void 
	{
		flag = false;
		updateSlide(e);
	}
	
	private function onMouseDown(e:MouseEvent):Void 
	{
		flag = true;
		updateSlide(e);
	}
	
	
	private function updateSlide(e:MouseEvent):Void
	{
		if(e.localX > backgroundImg.width - slideImg.width * 0.5){
			slideImg.x = backgroundImg.width - slideImg.width * 0.5;
		}else if(e.localX < slideImg.width * 0.5){
			slideImg.x = slideImg.width * 0.5;
		} else {
			slideImg.x = e.localX - (slideImg.width * 0.5);
		}
	}
	
	public function getCurrentSlide():Float {
		return slideImg.x / backgroundImg.width;
	}
	
	public function dispose():Void
	{
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	
	
}