package openlib.screen;

import flash.display.Sprite;
import openlib.screen.ScreenManager;

class Screen extends Sprite
{

	public var id:String;
	public var view:Sprite;
	public var manager:ScreenManager;
	public var isPopup:Bool;
	public var transition:String;

	public function enter(params:Dynamic):Void
	{
		
	}
	
	public function transitionBegin():Void
	{
		this.mouseChildren = false;
		this.mouseEnabled = false;
	}

	public function exit():Void
	{
		
	}

	public function blur():Void
	{

	}

	public function focus():Void
	{
		
	}
	
	public function update():Void
	{
		
	}
	
	public function transitionFinished():Void
	{
		this.mouseChildren = true;
		this.mouseEnabled = true;
	}

}