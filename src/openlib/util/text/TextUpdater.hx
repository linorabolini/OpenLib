package openlib.util.text;
import flash.display.Sprite;
import flash.text.TextField;

/**
 * ...
 * @author Lean
 */
class TextUpdater
{
	
	private var container:Sprite;
	private var onWordShown:String->Void;
	private var timedWords:Array<Dynamic>;
	private var currentWordDuration:Float;
	private var elapsed:Float;
	private var config:TextUpdaterConfig;
	private var onFinish:Void -> Void;

	public function new(config:TextUpdaterConfig, onWordShown:String->Void,?onFinish:Void->Void) 
	{
		this.onFinish  = onFinish;
		this.config = config;
		this.onWordShown = onWordShown;
		this.timedWords = new Array<Dynamic>();
		
		setup();
	}
	
	private function setup():Void
	{
		// config.text: "This is Sparta"
		// config.duration: [ 0.5, 1, 3 ]
		
		var words = config.text.split(" ");
		
		for( i in 0...words.length )
			addWord(words[i], config.times[i]);
	}
	
	private function addWord(word:String, duration:Float):Void
	{
		timedWords.push( { word: word, duration: duration } );
	}
	
	public function update(dt:Float):Void
	{
		elapsed += dt;
		
		if (elapsed < currentWordDuration * 1000)
			return;
			
		if (timedWords.length == 0) {
			if (onFinish != null)
				onFinish();
			return;
		}
		
		elapsed = 0;
		var timedWord = timedWords.shift();
		currentWordDuration = timedWord.duration;
			
		onWordShown(timedWord.word);
	}
	
}