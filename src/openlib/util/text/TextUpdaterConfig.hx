package openlib.util.text;

/**
 * ...
 * @author Lean
 */
class TextUpdaterConfig
{
	
	public var text:String;
	public var times:Array<Float>;

	public function new(text:String, times:Array<Float>) 
	{
		this.text = text;
		this.times = times;
	}
	
}