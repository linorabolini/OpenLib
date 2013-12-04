//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package openlib.animation;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import openlib.animation.Format;

/**
 * Defines a Flump atlased texture.
 */
class BitmapSymbol implements Symbol
{
    public var name (get_name, null) :String;
    public var bitmapData (default, default) :BitmapData;
    public var x (default, null) :Int;
    public var y (default, null) :Int;
    public var width (default, null) :Int;
    public var height (default, null) :Int;
    public var anchorX (default, null) :Float;
    public var anchorY (default, null) :Float;
	
	private static var zero:Point = new Point();

    public function new (json :TextureFormat, atlas :BitmapData)
    {
        _name = json.symbol;
        

        var rect = json.rect;
        x = rect[0];
        y = rect[1];
        width = rect[2];
        height = rect[3];

        var origin = json.origin;
        if (origin != null) {
            anchorX = origin[0];
            anchorY = origin[1];
        } else {
            anchorX = 0;
            anchorY = 0;
        }
		
		// nme fix for not using drawTiles
		// save the reference of each bitmapdata in a single bitmapSymbol per sub-texture
		
		this.bitmapData = new BitmapData(width, height); 
		this.bitmapData.copyPixels(atlas, new Rectangle(x, y, width, height), zero);
    }

    public function createSprite () :Sprite
    {
        return new BitmapSprite(this);
    }

    public function get_name () :String
    {
        return _name;
    }

    private var _name :String;
}

