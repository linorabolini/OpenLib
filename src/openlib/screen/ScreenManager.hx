package openlib.screen;

import flash.display.Sprite;
import openlib.screen.transition.LeftToRightTransition;
import openlib.screen.transition.RightToLeftTransition;
import openlib.screen.transition.FadeTransition;
import openlib.screen.transition.NoneTransition;
import openlib.screen.transition.Transition;

class ScreenManager
{

	private var currentScreen:Screen;
	public var currentScreenID:String;
	private var screens:Map<String,Class<Screen>>;
	private var bluredScreens:Array<Screen>;
	private var root:Sprite;
	private var defaultTransition:Dynamic;
	private var screenChanger:ScreenChanger;
	
	private var pendingChange:Bool;
	private var pendingChangeId:String;
	private var pendingChangeParams:Dynamic;
	private var pendingChangeTransition:Dynamic;

	public function new(root:Sprite)
	{
		this.root = root;
		screens = new Map<String,Class<Screen>>();
		bluredScreens = [];
		screenChanger = new ScreenChanger();
		screenChanger.registerTransition(LeftToRightTransition.ID, LeftToRightTransition);
		screenChanger.registerTransition(RightToLeftTransition.ID, RightToLeftTransition);
		screenChanger.registerTransition(FadeTransition.ID, FadeTransition);
		screenChanger.registerTransition(NoneTransition.ID, NoneTransition);
	}

	public function registerScreen(id:String, type:Class<Screen>):Void
	{
		screens.set(id, type);
	}
	
	public function registerTransition(id:String, type:Class<Transition>):Void
	{
		screenChanger.registerTransition(id, type);
	}

	public function start(id:String, ?params:Dynamic, ?defaultTransition:ScreenTransition):Void
	{
		this.defaultTransition = defaultTransition;

		if (this.defaultTransition == null)
			this.defaultTransition = ScreenTransition.None;

		change(id, params, ScreenTransition.None);
	}

	public function popup(id:String, ?params:Dynamic, ?transition:String):Void
	{
		currentScreen.blur();
		bluredScreens.push(currentScreen);

		change(id, params, transition, true);
	}

	public function close():Void
	{
		if (!currentScreen.isPopup)
			throw "Only popups can be closed";
			
		currentScreen.transitionBegin();
		screenChanger.close(currentScreen, function() {
			currentScreen.exit();
			root.removeChild(currentScreen);

			currentScreen = bluredScreens.pop();
			currentScreen.focus();
			currentScreen.transitionFinished();
			
			if (pendingChange) {
				if(currentScreen.isPopup) {
					close();
				}else {
					change(pendingChangeId, pendingChangeParams, pendingChangeTransition);
					pendingChange = false;
					pendingChangeId = "";
					pendingChangeParams = null;
					pendingChangeTransition = null;
				}
			}
		});
	}

	public function change(id:String, ?params:Dynamic, ?transition:Dynamic, popup:Bool = false):Void
	{
		if (currentScreen != null && !popup && currentScreen.isPopup) {
			pendingChange = true;
			pendingChangeId = id;
			pendingChangeParams = params;
			pendingChangeTransition = transition;
			
			close();
			return;
		}
		var t:Dynamic = this.defaultTransition;
		
		if(!popup)
			currentScreenID = id;

		if (transition != null)
			t = transition;

		var nextScreen = load(id);
		nextScreen.isPopup = popup;
		nextScreen.transition = t;
		root.addChild(nextScreen);

		if (currentScreen == null)
		{
			currentScreen = nextScreen;
			currentScreen.enter(params);
		}
		else
		{
			if (!popup)
			{
				nextScreen.enter(params);
				nextScreen.transitionBegin();
				currentScreen.transitionBegin();
				
				screenChanger.change(currentScreen, nextScreen, function() {
					currentScreen.exit();
					root.removeChild(currentScreen);

					for (bs in bluredScreens)
					{
						bs.exit();
						root.removeChild(bs);
					}
					
					bluredScreens = [];
					currentScreen = nextScreen;
					currentScreen.transitionFinished();
				});
			}
			else
			{
				currentScreen.transitionBegin();
				nextScreen.transitionBegin();
				screenChanger.popup(nextScreen, function() {
					currentScreen = nextScreen;
					currentScreen.enter(params);
					currentScreen.transitionFinished();
				});
			}

		}

	}

	private function load(id:String):Screen
	{
		var sc:Class<Screen> = screens.get(id);

		if (sc == null)
			throw "Invalid Screen: " + id;

		var sci = Type.createInstance(sc, []);

		sci.id = id;
		sci.manager = this;

		return sci;
	}
	
	public function update():Void
	{
		currentScreen.update();
	}

}

enum ScreenTransition
{
	None;
	RightToLeft;
	LeftToRight;
	Fade;
	Custom;
}