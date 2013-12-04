package openlib.ebook.action;
import flash.Assets;
import openlib.animation.Animator;
import openlib.entityManager;
import openlib.entity.AudioPlayerEntity;
import openlib.tasks.Task;
import openlib.tasks.TimeBasedTask;

/**
 * ...
 * @author Lean
 */

 typedef PlayAudioActionFormat = {
	id:String,
	root:String,
	loop:String
 }
 
class PlayAudioAction extends Task
{
	var data:PlayAudioActionFormat;
	static public var AUDIO_BASE_DIRECTORY:String = "";

	public function new(data:PlayAudioActionFormat) 
	{
		super();
		this.data = data;
	}
	
	override public function start():Void 
	{
		super.start();
		
		AUDIO_BASE_DIRECTORY = AUDIO_BASE_DIRECTORY == "" ? "": AUDIO_BASE_DIRECTORY;
		
		if (AUDIO_BASE_DIRECTORY != "" && AUDIO_BASE_DIRECTORY.charAt(AUDIO_BASE_DIRECTORY.length - 1) != "/")
			AUDIO_BASE_DIRECTORY += "/";
		
		var id = AUDIO_BASE_DIRECTORY + data.id;
		
		if (data.root != null)
			id = data.root;
		
		var loop = data.loop == "true";
		var ae = new AudioPlayerEntity(id, loop);
		
		EntityManager.addEntity("audio_" + data.id, ae);
		
		ae.play();

		this.taskComplete();
	}
	
}