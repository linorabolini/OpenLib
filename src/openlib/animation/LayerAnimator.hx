package openlib.animation;

import flash.display.Sprite;
import openlib.animation.MovieSymbol;
import flash.geom.Matrix;

/**
 * ...
 * @author Lino
 */

class LayerAnimator
{
    public var changedKeyframe :Bool;
    public var keyframeIdx :Int;

    public var layer :MovieLayer;
	
	public var container:Sprite;
	
	public var current:Sprite;

    public function new (layer :MovieLayer)
    {
        changedKeyframe = false;
        keyframeIdx = 0;
        this.layer = layer;
		container = new Sprite();

        if (layer.multipleSymbols) {
            _sprites = new Array();
            for (ii in 0...layer.keyframes.length) {
                var kf = layer.keyframes[ii];
                _sprites.push( (kf.symbol != null) ? kf.symbol.createSprite() : new Sprite() );
            }
            current = _sprites[0];

        } else if (layer.lastSymbol != null) {
            current = layer.lastSymbol.createSprite();

        } else {
            current = new Sprite(); // Empty container layer
        }

        this.container.addChild(current);
    }

    public function composeFrame (frame :Float)
    {
        var keyframes = layer.keyframes;
        var finalFrame = keyframes.length - 1;

        while (keyframeIdx < finalFrame && keyframes[keyframeIdx+1].index <= frame) {
            ++keyframeIdx;
            changedKeyframe = true;
        }
		
        if (changedKeyframe && _sprites != null) {
            // Switch to the next instance if this is a multi-layer symbol
			/*container.removeChild(current);
			current = _sprites[keyframeIdx];
			this.container.addChild(current);
			*/
			current.visible = false;
            current = _sprites[keyframeIdx];
			if(current.parent != this.container)
				this.container.addChild(current);
			current.visible = true;
			
			
        }

        changedKeyframe = false;

        var kf = keyframes[keyframeIdx];
        var visible = kf.visible && kf.symbol != null;
        current.visible = visible;
        if (!visible) {
            return; // Don't bother animating invisible layers
        }

        var x = kf.x;
        var y = kf.y;
        var scaleX = kf.scaleX;
        var scaleY = kf.scaleY;
        var skewX = kf.skewX;
        var skewY = kf.skewY;
        var alpha = kf.alpha;

        if (kf.tweened && keyframeIdx < finalFrame) {
            var interp = (frame-kf.index) / kf.duration;
            var ease = kf.ease;
            if (ease != 0) {
                var t;
                if (ease < 0) {
                    // Ease in
                    var inv = 1 - interp;
                    t = 1 - inv*inv;
                    ease = -ease;
                } else {
                    // Ease out
                    t = interp*interp;
                }
                interp = ease*t + (1 - ease)*interp;
            }

            var nextKf = keyframes[keyframeIdx + 1];
            x += (nextKf.x-x) * interp;
            y += (nextKf.y-y) * interp;
            scaleX += (nextKf.scaleX-scaleX) * interp;
            scaleY += (nextKf.scaleY-scaleY) * interp;
            skewX += (nextKf.skewX-skewX) * interp;
            skewY += (nextKf.skewY-skewY) * interp;
            alpha += (nextKf.alpha-alpha) * interp;
        }

        // From an identity matrix, append the translation, skew, and scale

        var sinX = Math.sin(skewX), cosX = Math.cos(skewX);
        var sinY = Math.sin(skewY), cosY = Math.cos(skewY);
		current.x += 1;
		var matrix:Matrix = current.transform.matrix;
        
		matrix.a = cosY * scaleX;
		matrix.b = sinY * scaleX;
		matrix.c = -sinX * scaleY;
		matrix.d = cosX * scaleY;
		matrix.tx = x;
		matrix.ty = y;

		matrix.tx += matrix.a * ( -kf.pivotX) + matrix.c * ( -kf.pivotY);
		matrix.ty += matrix.d * ( -kf.pivotY) + matrix.b * ( -kf.pivotX);
		
        //Append the pivot
		//matrix.translate(-kf.pivotX, -kf.pivotY);
	
		current.transform.matrix = matrix;
		
        current.alpha = alpha;
		current.x -= 1;
    }

    // Only created if there are multiple symbols on this layer. If it does exist, the appropriate
    // sprite is swapped in at keyframe changes. If it doesn't, the sprite is only added to the
    // parent on layer creation.
    private var _sprites :Array<flash.display.Sprite> = null;
}