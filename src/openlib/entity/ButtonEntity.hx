package openlib.entity;

import openlib.ui.Button;

/**
 * ...
 * @author Lean
 */
class ButtonEntity extends Button implements Entity
{
	
	public var enabled:Bool = true;

	public function new(data:Dynamic, onPressed:Dynamic->Void = null) 
	{
		super(data, onPressed);
	}
	
	public function update():Void
	{
		// nada
	}
	
}