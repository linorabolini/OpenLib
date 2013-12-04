package openlib.ui;
import flash.geom.Rectangle;
import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import openlib.util.OpenlibAssets;

/**
 * ...
 * @author Lean
 */
class Button extends Sprite
{
	
	private var idleImg:Bitmap;
	private var pressedImg:Bitmap;
	private var onUpCB:MouseEvent -> Void;
	private var onDownCB:MouseEvent -> Void;
	
	// data.idle, data.pressed, data.clickAreaScale, "clickArea": { "scaleX": 1.5, "scaleY": 3, "debug": true }

	public function new(data:Dynamic, onPressed:Dynamic->Void = null) 
	{
		super();
		
		if (data.idle == null)
			throw "Missing idle asset for button";
		
		idleImg = OpenlibAssets.getBitmap(data.idle);
		addChild(idleImg);
		
		if (data.clickArea != null)
		{
			var scaleX:Float = data.clickArea.scaleX == null ? 1: data.clickArea.scaleX;
			var scaleY:Float = data.clickArea.scaleY == null ? 1: data.clickArea.scaleY;
			var debug =  data.clickArea.debug == null ? false: data.clickArea.debug;
		
			var clickArea = new Shape();
			clickArea.graphics.beginFill(0xFF0000, debug ? 0.5: 0);
			clickArea.graphics.drawRect(0, 0, idleImg.width * scaleX, idleImg.height * scaleY);
			clickArea.graphics.endFill();
			
			addChild(clickArea);
		}
		
		
		if (data.pressed != null)
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.MOUSE_UP, onUp);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			pressedImg = OpenlibAssets.getBitmap(data.pressed);
			addChild(pressedImg);
			
			pressedImg.visible = false;
		}
		
		if (onPressed != null)
			addEventListener(MouseEvent.CLICK, onPressed);
	}
	
	private function onDown(e:MouseEvent):Void
	{
		setActive(true);
		
		if (onDownCB != null)
			onDownCB(e);
	}
	
	private function onUp(e:MouseEvent):Void
	{
		setActive(false);
		
		if (onUpCB != null)
			onUpCB(e);
	}
	
	public function setActive(active:Bool) 
	{
		pressedImg.visible = active;
		idleImg.visible = !active;
	}
	
		
	private function onOut(e:MouseEvent):Void
	{
		setActive(false);
	}
	
	public function setOnUpCallBack(func:MouseEvent->Void) :Void 
	{
		onUpCB = func;
	}
	
	public function setOnDownCallBack(func:MouseEvent->Void) :Void 
	{
		onDownCB = func;
	}
	
	public function dispose():Void
	{
		removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		removeEventListener(MouseEvent.MOUSE_UP, onUp);
		removeEventListener(MouseEvent.MOUSE_OUT, onOut);
	}
	
}