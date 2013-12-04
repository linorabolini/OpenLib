package openlib.ebook;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import openlib.ebook.action.Action;
import openlib.entity.SpriteEntity;
import openlib.tasks.Sequence;

/**
 * ...
 * @author Lean
 */
class PageScript
{
	
	public var layers:Array<String>;
	public var actions:Sequence;
	private var container:DisplayObjectContainer;
	private var pageFormat:EBookPageFormat;

	public function new(page:EBookPageFormat) 
	{
		this.pageFormat = page;
		this.layers = page.layers;
		this.actions = ActionParser.parseActions(page.actions);
	}
	
	public function getPageFormat():EBookPageFormat
	{
		return this.pageFormat;
	}
	
	public function load(container:DisplayObjectContainer):Void {
		if (this.container != null) 
			throw "Page has already been loaded";
			
		this.container = container;
		for ( layer in layers ) {
			var sprite:SpriteEntity = new SpriteEntity();
			container.addChild(sprite);
			EntityManager.addEntity(layer, sprite, "layers");
		}
		
		this.actions.start();
	}
	
	public function update(dt:Int):Void {
		actions.update(dt);
	}
	
	public function dispose():Void {
		
		if(container != null)
			for ( layer in layers ) {
				var obj:DisplayObject = cast EntityManager.getEntity(layer, "layers");
				container.removeChild(obj);
			}
		
		actions.dispose();
		layers = null;
		container = null;
		actions = null;
	}
	
}