package openlib.ebook;
import openlib.ebook.action.AnimAction;
import openlib.ebook.action.CreateAnimationAction;
import openlib.ebook.action.CreateBitmapAction;
import openlib.ebook.action.CreateClickAreaAction;
import openlib.ebook.action.DestroyItemAction;
import openlib.ebook.action.DragAction;
import openlib.ebook.action.DropAction;
import openlib.ebook.action.MoveCameraAction;
import openlib.ebook.action.SetAttributesAction;
import openlib.ebook.action.ShowTextAction;
import openlib.ebook.action.CreateButtonAction;
import openlib.ebook.action.FadeOutAction;
import openlib.ebook.action.FadeInAction;
import openlib.ebook.action.NextScreenTransitionAction;
import openlib.ebook.action.SplineAction;
import openlib.ebook.action.RotateAction;
import openlib.ebook.action.TweenAction;
import openlib.ebook.action.CharacterTween;
import openlib.ebook.action.WaitForAnyEntityEvent;
import openlib.ebook.action.WaitForEntityEvent;
import openlib.ebook.action.WaitForAllAction;
import openlib.ebook.action.WaitAction;
import openlib.ebook.action.DispatchAction;
import openlib.ebook.action.PlayAudioAction;
import openlib.ebook.action.ScaleAction;
import openlib.tasks.Parallel;
import openlib.tasks.Sequence;
import openlib.tasks.Task;
import openlib.tasks.Wait;
import openlib.util.Converter;

/**
 * ...
 * @author ...
 */
class ActionParser
{
	private static var functions:Map < String, (Dynamic->Task) > = null;
	
	public static function parseActions(actions:Array<Dynamic>):Sequence
	{
		if (functions == null) loadFunctionsHash();
		
		var sequence:Sequence = new Sequence();
		for (a in actions)
		{
			var key = Reflect.fields(a)[0];

			if (!functions.exists(key))
				throw "There is no action: " + key;
			
			sequence.add( functions.get(key)(Reflect.field(a,key)) );
		}
		return sequence;
	}
	
	public static function setCallback(key:String, cb:Dynamic->Task):Void {
		if (functions == null) loadFunctionsHash();
		
		functions.set(key, cb);
	}
	
	static function loadFunctionsHash() 
	{
		functions = new Map<String, Dynamic->Task > ();
		
		setCallback("character_tween", parseCharTween);
		setCallback("seq", parseSequence);
		setCallback("par", parseParalell);
		setCallback("create_image", parseCreateImage);
		setCallback("create_animation", parseCreateAnimation);
		setCallback("create_button", parseCreateButton);
		setCallback("anim", parseAnimation);
		setCallback("tween", parseTween);
		setCallback("show_text", parseShowTextAction);
		setCallback("play_audio", parsePlayAudioAction);
		setCallback("waitFor", parseWaitFor);
		setCallback("wait_for", parseWaitFor);
		setCallback("waitForAny", parseWaitForAny);
		setCallback("wait_for_any", parseWaitForAny);
		setCallback("wait_for_all", parseWaitForAll);
		setCallback("splineMover", parseSplineMover);
		setCallback("spline_mover", parseSplineMover);
		setCallback("destroy", parseDestroy);
		setCallback("fadeout", parseFadeOut);
		setCallback("fadein", parseFadeIn);
		setCallback("wait", parseWait);
		setCallback("rotate", parseRotate);
		setCallback("dispatch", parseDispatch);
		setCallback("set_attributes", parseSetAttributes);
		setCallback("drag", parseDrag);
		setCallback("drop", parseDrop);
		setCallback("move_camera", parseMoveCamera);
		setCallback("scale", parseScale);
		setCallback("create_click_area", parseCreateClickArea);
		setCallback("next_screen_transition", parseNextScreenTransition);  // default to wait
	}
	
	static private function parseSplineMover(data:SplineActionFormat) 
	{
		data.controlPoints = Converter.dynamicArrayToPointArray(data.controlPoints);
		return new SplineAction(data);
	}
	
	static private function parseShowTextAction(data:Dynamic) :Task
	{
		return new ShowTextAction(data);
	}
	
	private static function parseSequence(data:Dynamic):Task
	{
		var sequence:Sequence = new Sequence();
		var actions:Array<Dynamic> = cast data;
		for (a in actions)
		{
			var key = Reflect.fields(a)[0];
			
			if (!functions.exists(key))
				throw "There is no action: " + key;
			
			sequence.add( functions.get(key)(Reflect.field(a,key)) );
		}
		return sequence;
	}
	
	private static function parseParalell(data:Dynamic):Task
	{
		var paralell:Parallel = new Parallel();
		var actions:Array<Dynamic> = cast data;
		for (a in actions)
		{
			var key = Reflect.fields(a)[0];
			
			if (!functions.exists(key))
				throw "There is no action: " + key;
			
			paralell.add( functions.get(key)(Reflect.field(a,key)) );
		}
		return paralell;
	}
	
	private static function parseAnimation(data:Dynamic):Task
	{
		return new AnimAction(cast data);
	}
	
	private static function parseTween(data:Dynamic):Task
	{
		var tween = new TweenAction(cast data);
		return tween;
	}
	
	private static function parseWaitFor(data:Dynamic):Task
	{
		return new WaitForEntityEvent( data.dispatcher, data.event );
	}
	
	private static function parseWaitForAny(data: Array<{dispatcher:String,event:String}>):Task
	{
		return new WaitForAnyEntityEvent(data);
	}
	
	private static function parseWaitForAll(data: Array<{dispatcher:String,event:String}>):Task
	{
		return new WaitForAllAction(data);
	}
	
	private static function parseNextScreenTransition(data:Dynamic):Task
	{
		// default 
		return new Wait(0);
	}
	
	private static function parseCreateImage(data:Dynamic):Task
	{
		return new CreateBitmapAction(data);
	}
	
	private static function parsePlayAudioAction(data:Dynamic):Task
	{
		return new PlayAudioAction(data);
	}
	
	private static function parseCreateAnimation(data:Dynamic):Task
	{
		return new CreateAnimationAction(data);
	}
	
	private static function parseCreateButton(data:Dynamic):Task
	{
		return new CreateButtonAction(data);
	}
	
	private static function parseDestroy(data:Dynamic):Task
	{
		return new DestroyItemAction(data);
	}
	
	private static function parseFadeOut(data:Dynamic):Task
	{
		return new FadeOutAction(data);
	}
	
	private static function parseFadeIn(data:Dynamic):Task
	{
		return new FadeInAction(data);
	}
	
	private static function parseWait(data:Dynamic):Task
	{
		return new WaitAction(data);
	}
	
	private static function parseRotate(data:Dynamic):Task
	{
		return new RotateAction(data);
	}
	
	private static function parseDispatch(data:Dynamic):Task
	{
		return new DispatchAction(data);
	}
	
	private static function parseSetAttributes(data:Dynamic):Task
	{
		return new SetAttributesAction(data);
	}
	
	private static function parseDrag(data:Dynamic):Task
	{
		return new DragAction(data);
	}
	
	private static function parseDrop(data:Dynamic):Task
	{
		return new DropAction(data);
	}
	
	private static function parseMoveCamera(data:Dynamic):Task
	{
		return new MoveCameraAction(data);
	}
	
	private static function parseScale(data:Dynamic):Task
	{
		return new ScaleAction(data);
	}
	
	private static function parseCharTween(data:Dynamic):Task
	{
		return new CharacterTween(data);
	}
	
	private static function parseCreateClickArea(data:Dynamic):Task
	{
		return new CreateClickAreaAction(data);
	}
	
}