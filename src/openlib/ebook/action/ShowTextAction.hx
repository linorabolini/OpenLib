package openlib.ebook.action;

import flash.Assets;
import flash.display.DisplayObjectContainer;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import openlib.entityManager;
import openlib.ebook.TextStyleManager;
import openlib.locale.LocaleManager;
import openlib.tasks.Task;
import openlib.ui.UIUtil;
import openlib.util.text.TextUpdater;
import openlib.util.text.TextUpdaterConfig;



typedef ShowTextActionFormat = {
	layer:String,
	id:String,
	styleBase:String,
	styleChanged:String,
	align:String,
	position: { x:Float, y:Float }
}

/**
 * ...
 * @author 
 */
class ShowTextAction extends Task
{
	var data:ShowTextActionFormat;
	var config:TextUpdaterConfig;
	var tu:TextUpdater;
	var currentWordIndex:Int;
	var textField:TextField;
	var style_changed:TextFormat;
	var style_base:TextFormat;
	
	public function new(data:ShowTextActionFormat)
	{
		super();
		this.data = data;
	}
	
	override public function start():Void 
	{
		super.start();
		
		var localeTextData = LocaleManager.getData(data.id);

		style_base = TextStyleManager.getStyle(data.styleBase);
		style_changed = TextStyleManager.getStyle(data.styleChanged);
		
		textField = new TextField();
		textField.embedFonts = true;
		textField.defaultTextFormat = style_base;
		textField.text = localeTextData.text.toUpperCase();
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.multiline = true;
		textField.selectable = false;
		
		UIUtil.percToPixelObj(data.position);
		textField.x = data.position.x;
		textField.y = data.position.y;
		
		if (data.align == "center")
			textField.x =  (UIUtil.getStageWidth() / 2) - (textField.textWidth / 2);
		else if (data.align == "right")
			textField.x =  UIUtil.getStageWidth() - textField.textWidth;
		
		
		var container:DisplayObjectContainer = cast EntityManager.getEntity(data.layer, "layers");
		
		container.addChild(textField);	
		
		config = new TextUpdaterConfig(cast(localeTextData.text, String), localeTextData.times);
		tu = new TextUpdater(config, onWordShown, this.taskComplete);
	}
	
	function onWordShown(word:String) 
	{
		var lastIndex = currentWordIndex;
		currentWordIndex += word.length + 1;
		currentWordIndex =  Math.ceil(Math.min(currentWordIndex, textField.text.length));
		if(lastIndex > 0)
			textField.setTextFormat(style_base, -1, lastIndex);
		textField.setTextFormat(style_changed, lastIndex,currentWordIndex);
	}
	
	override public function update(milliseconds:Int):Void 
	{
		super.update(milliseconds);
		tu.update(milliseconds);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		if(textField != null && textField.parent != null)
			textField.parent.removeChild(textField);
		textField = null;
		style_changed = null;
		this.data = null;
	}
	
}