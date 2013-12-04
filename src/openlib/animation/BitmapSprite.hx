//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package openlib.animation;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Sprite;

/**
 * An instanced Flump atlased texture.
 */
class BitmapSprite extends Sprite
{
    /**
     * The symbol this sprite displays.
     */
    public var symbol (default, null) :BitmapSymbol;
	
	private var bitmap:Bitmap;
	
	private var anchorX:Float;
	private var anchorY:Float;

    public function new (symbol :BitmapSymbol)
    {
        super();
        this.symbol = symbol;
        anchorX = symbol.anchorX;
        anchorY = symbol.anchorY;
		
		this.bitmap = new Bitmap(symbol.bitmapData);
		addChild(bitmap);
    }

    public function getNaturalWidth () :Float
    {
        return symbol.width;
    }

    public function getNaturalHeight () :Float
    {
        return symbol.height;
    }
}
