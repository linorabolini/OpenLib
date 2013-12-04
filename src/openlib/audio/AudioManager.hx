package openlib.audio;
import flash.events.Event;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import openlib.audio.AudioPlayer;

/**
 * ...
 * @author Lean
 */

 typedef AudioFormat = {
	sounds:Array<Sound>
 }
 
 typedef Sound = {
	id:String,
	root:String,
	loop:Bool
 }
 
class AudioManager
{
	
	private var sounds:Map<String, AudioPlayer>;
	private var ids:Map<String, String>;
	private var callbacks:Map<String, Void->Void>;
	private var playlist:Map<String, AudioPlayer>;
	
	private var soundTransform:SoundTransform;
	
	public function new(data:AudioFormat) 
	{
		sounds = new Map<String, AudioPlayer>();
		ids = new Map<String, String>();
		callbacks = new Map<String, Void->Void>();
		playlist = new Map<String, AudioPlayer>();
		soundTransform = new SoundTransform();
		
		for (sound in data.sounds)
		{
			var a = new AudioPlayer(sound.root, sound.loop, soundComplete);
			sounds.set(sound.id, a);
			ids.set(sound.root, sound.id);
		}
	}
	
	private function soundComplete(root:String, e:Event):Void
	{
		var id = ids.get(root);
		playlist.remove(id);
		
		var cb = callbacks.get(id);
		
		if (cb != null)
			cb();
	}
	
	public function play(id:String, ?onPlaybackFinished:Void->Void):Bool
	{
		var s = sounds.get(id);
		
		if (s == null)
		{
			trace("Sound " + id + " not found");
			return false;
		}
		
		playlist.set(id, s);
		
		if (onPlaybackFinished != null)
			callbacks.set(id, onPlaybackFinished);
		
		return s.play(soundTransform);
	}
	
	public function stop(id:String):Void
	{
		var s = playlist.get(id);
		
		if (s == null)
		{
			trace("Sound " + id + " is not playing");
			return;
		}
		
		s.stop();
		playlist.remove(id);
	}
	
	public function isPlaying(id:String):Bool
	{
		return playlist.exists(id);
	}
	
	public function stopAll():Void
	{
		for (k in playlist.keys())
			stop(k);
	}
	
	public function stopAllBut(id:String):Void
	{
		for (k in playlist.keys())
			if (id != k)
				stop(k);
	}
	
	public function setVolume(vol:Float) 
	{
		if (vol > 1) throw "ERROR: VOLUME GOES FROM 0 TO 1";
		soundTransform.volume = vol;
	}
	
	public function getVolume() :Float
	{
		return soundTransform.volume;
	}
	
	public function dispose()
	{
		sounds = null;
		ids = null;
		callbacks = null;
		playlist = null;
		soundTransform = null;
	}
	
}