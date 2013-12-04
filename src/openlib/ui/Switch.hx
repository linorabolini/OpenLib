package openlib.ui;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import openlib.util.OpenlibAssets;

/**
 * ...
 * @author Lean
 */
class Switch extends Sprite
{
	
	private var idleImg:Bitmap;
	private var activeImg:Bitmap;
	private var _active:Bool;
	
	// data.idle, data.pressed

	public function new(data:Dynamic, onPressed:Dynamic->Void = null) 
	{
		super();
		
		if (data.idle == null)
			throw "Missing idle asset for button";
		
		idleImg = new Bitmap (OpenlibAssets.getBitmapData(data.idle));
		addChild(idleImg);
		
		if (data.pressed != null)
		{
			addEventListener(MouseEvent.MOUSE_DOWN, toggle);
			
			activeImg = new Bitmap (OpenlibAssets.getBitmapData(data.pressed));
			addChild(activeImg);
			
			activeImg.visible = false;
		}
		
		if (onPressed != null)
			addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
			
		_active = false;
	}
	
	public function toggle(e:MouseEvent=null):Void
	{
		setActive(!_active);
	}
	
	public function setActive(active:Bool) 
	{
		_active = active;
		activeImg.visible = _active;
		idleImg.visible = !_active;
	}
	
	public function isActive():Bool 
	{
		return _active;
	}
	
	public function dispose():Void
	{
		removeEventListener(MouseEvent.MOUSE_DOWN, toggle);
	}
	
}