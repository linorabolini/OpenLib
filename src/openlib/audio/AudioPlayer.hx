package openlib.audio;

import flash.Assets;
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

/**
 * ...
 * @author Lean
 */
class AudioPlayer
{
	
	public var loop:Bool;
	
	private var id:String;
	private var sound:Sound;
	private var channel:SoundChannel;
	private var cb:String->Event->Void;

	public function new(id:String, loop:Bool = false, ?cb:String->Event->Void) 
	{
		this.id = id;
		this.loop = loop;
		this.cb = cb;
	}
	
	public function play(?soundTransform:SoundTransform):Bool
	{
		sound = Assets.getSound(id);
		
		if (sound != null)
		{
			if (loop)
				channel = sound.play(0, 1000000, soundTransform);
			else
				channel = sound.play(0, 0, soundTransform);			
			
			if (channel == null)
			{
				trace("Error: No more sound channels available");
				return false;
			}
				
			if (cb != null)
				channel.addEventListener(Event.SOUND_COMPLETE, function(e:Event) {
					cb(this.id, e);
				});
				
			return true;
		}
		
		return false;
	}
	
	public function stop():Void
	{
		if (channel != null)
			channel.stop();
	}
	
}