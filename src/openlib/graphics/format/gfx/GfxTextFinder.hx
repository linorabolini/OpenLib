package openlib.graphics.format.gfx;

import openlib.graphics.format.svg.Text;

class GfxTextFinder extends Gfx
{
   public var text : Text;

   public function new() { super(); }

   override public function geometryOnly() { return true; }
   override public function renderText(inText:Text) { if (text==null) text = inText; }
}

