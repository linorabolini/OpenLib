//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package openlib.animation;

import flash.display.Sprite;
import openlib.math.FMath;
import openlib.animation.MovieSymbol;
import openlib.util.Signal0;

using openlib.util.BitSets;

/**
 * An instanced Flump animation.
 */
class MovieSprite extends Sprite
{
	private var _flags :Int;
	
	private static inline var VISIBLE = 1 << 0;
    private static inline var POINTER_ENABLED = 1 << 1;
    private static inline var LOCAL_MATRIX_DIRTY = 1 << 2;
    private static inline var VIEW_MATRIX_DIRTY = 1 << 3;
    private static inline var MOVIESPRITE_PAUSED = 1 << 4;
    private static inline var TEXTSPRITE_DIRTY = 1 << 5;
	
    /** The symbol this sprite displays. */
    public var symbol (default, null) :MovieSymbol;

    /**
     * The playback speed multiplier of this movie, defaults to 1.0. Higher values will play faster.
     */
    public var speed (default, null) :Float;

    public function new (symbol :MovieSymbol)
    {
        super();
        this.symbol = symbol;

        speed = 1;

        _animators = new Array();
        for (ii in 0...symbol.layers.length) {
            var layer = symbol.layers[ii];
            _animators.push(new LayerAnimator(layer));
        }

        _frame = 0;
        _position = 0;
        goto(1);
    }

    /**
     * Retrieves a named layer from this movie. Children can be added to the returned entity to add
     * sprites that move with the layer, which for example, can be used to add equipment sprites to
     * an avatar.
     * @param required If true and the layer is not found, an error is thrown.
     */
    public function getLayer (name :String, required :Bool = true) :Sprite
    {
        for (animator in _animators) {
            if (animator.layer.name == name) {
                return animator.container;
            }
        }
        if (required) {
            throw "Missing layer " + name;
        }
        return null;
    }

    public function onAdded ()
    {
        for (animator in _animators) {
            this.addChild(animator.container);
        }
    }

    public function onRemoved ()
    {
        // Detach the animator content layers so they don't get disconnected during a disposal. This
        // may be a little hacky as it prevents child components from ever being formally removed.
        for (animator in _animators) {
            this.removeChild(animator.container);
        }
    }

    public function onUpdate (dt :Float)
    {
        var looped = false;
        if (!isPaused()) {
            _position += speed*dt;
            if (_position > symbol.duration) {
                _position = _position % symbol.duration;
                looped = true;
            }
        }

        var newFrame = _position*symbol.frameRate;
        goto(newFrame);

		/*
		 * TEMPORARY DISABLED!
        if (looped && _looped != null) {
            _looped.emit();
        }
		*/
    }

    private function goto (newFrame :Float)
    {
        if (_frame == newFrame) {
            return; // No change
        }

        var wrapped = newFrame < _frame;
        if (wrapped) {
            for (animator in _animators) {
                animator.changedKeyframe = true;
                animator.keyframeIdx = 0;
            }
        }
        for (animator in _animators) {
            animator.composeFrame(newFrame);
        }

        _frame = newFrame;
    }

    public function getPosition () :Float
    {
        return _position;
    }

    public function setPosition (position :Float) :Float
    {
        return _position = FMath.clamp(position, 0, symbol.duration);
    }

    public function isPaused () :Bool
    {
        return _flags.contains(MOVIESPRITE_PAUSED);
    }

    private function setPaused (paused :Bool)
    {
        _flags = _flags.set(MOVIESPRITE_PAUSED, paused);
        return paused;
    }

   /* public function looped () :Signal0
    {
        if (_looped == null) {
            _looped = new Signal0();
        }
        return _looped;
    }*/

    private var _animators :Array<LayerAnimator>;

    private var _position :Float;
    private var _frame :Float;

    private var _looped :Signal0 = null;
}
