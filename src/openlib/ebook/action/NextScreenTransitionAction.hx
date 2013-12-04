package openlib.ebook.action;
import openlib.tasks.Func;


typedef TrasitionFormat = {
	transition:String,
	nextScreenFunction:Void->Void
}


class NextScreenTransitionAction extends Func
{

	public function new(data:TrasitionFormat) 
	{
		super(cast screenTransition, data);
	}
	
	private function screenTransition(data:TrasitionFormat):Void {
		trace("Playing transition: " + data.transition);
		data.nextScreenFunction();
	}
	
}