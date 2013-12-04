package openlib.entity;
import flash.display.Sprite;



/**
 * ...
 * @author Lean
 */
class SpriteEntity extends Sprite implements Entity
{
	
	private var events:Map < String, Dynamic -> Void > ;

	public function new() 
	{
		super();
		events = new Map < String, Dynamic -> Void > ();
	}
	
	override public function addEventListener(type : String, listener : Dynamic -> Void, useCapture : Bool = false, priority : Int = 0, useWeakReference : Bool = false) : Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		
		events.set(type, listener);
	}
	
	override public function removeEventListener(type: String, listener : Dynamic -> Void, useCapture : Bool = false):Void
	{
		super.removeEventListener(type, listener, useCapture);
		
		events.remove(type);
	}
	
	public function removeAllListeners():Void
	{
		for (key in events.keys())
		{
			super.removeEventListener(key, events.get(key));
			events.remove(key);
		}
	}
	
	public function update():Void
	{
		// nada
	}
	
	public function dispose():Void
	{
		if (this.parent != null)
			this.parent.removeChild(this);
			
		removeAllListeners();
		events = null;
	}
	
}