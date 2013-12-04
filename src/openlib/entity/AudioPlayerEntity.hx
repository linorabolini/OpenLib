package openlib.entity;

import openlib.audio.AudioPlayer;

/**
 * ...
 * @author Lean
 */
class AudioPlayerEntity extends AudioPlayer implements Entity
{

	public function new(id:String, loop:Bool = false) 
	{
		super(id, loop);
	}
	
	public function update():Void
	{
		// nada
	}
	
	public function dispose():Void
	{
		stop();
	}
	
}