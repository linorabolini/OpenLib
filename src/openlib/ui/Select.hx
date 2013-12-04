package openlib.ui;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import openlib.util.OpenlibAssets;

/**
 * ...
 * @author Jeremias
 */
class Select extends Sprite
{
	
	private var idleImg:Bitmap;
	private var onUpCB:MouseEvent -> Void;
	private var onDownCB:MouseEvent -> Void;
	private var m:Int = 0;
	private var backgrounds:Array<String>;
	private var options:Array<String>;
	private var current:String;
	
	//backgrounds = data.idle;
	//options = data.opt;
	
	// data.idle:Array, data.opt:Array, data.cOpt
	
	public function new(data:Dynamic, onPressed:Dynamic->Void = null) 
	{
		super();		
	
	
		current = data.cOpt;
		backgrounds = data.idle;
		options = data.opt;
		
		if(backgrounds.length != options.length){ throw "Different number of assets ans options"; }
		
		var i:Int = 0;
		while(i < options.length) {
        if (options[i] == current) { m = i; }
        i++;
    }
		idleImg = new Bitmap (OpenlibAssets.getBitmapData(backgrounds[m]));
		addChild(idleImg);
		
				
		addEventListener(MouseEvent.CLICK, onClickSelect);		
		
		
		if (onPressed != null)
			addEventListener(MouseEvent.CLICK, onPressed);
		
	}
	private function onClickSelect(e:MouseEvent):Void
	{
		if(options.length > m + 1){
		m++;
		} else {
			m = 0;
		
		}
		
		removeChild(idleImg);
		idleImg = new Bitmap (OpenlibAssets.getBitmapData(backgrounds[m]));
		addChild(idleImg);
		
	}
	public function getOption():String {
		return options[m];
	}
	public function dispose():Void
	{
		removeEventListener(MouseEvent.CLICK, onClickSelect);
	}
	
	
}