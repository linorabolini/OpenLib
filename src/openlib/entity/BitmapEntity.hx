package openlib.entity;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;

/**
 * ...
 * @author Lean
 */
class BitmapEntity extends Bitmap implements Entity
{

	public function new(?bitmapData : BitmapData, ?pixelSnapping : PixelSnapping, ?smoothing : Bool)
	{
		if (bitmapData != null && pixelSnapping != null && smoothing != null)
			super(bitmapData, pixelSnapping, smoothing);
		else if (bitmapData != null && pixelSnapping != null && smoothing == null)
			super(bitmapData, pixelSnapping);
		else if (bitmapData != null && pixelSnapping == null && smoothing == null)
			super(bitmapData);
		else
			super();
	}
	
	public function update():Void
	{
		// nada
	}
	
	public function dispose():Void
	{
		// nada
	}
	
}