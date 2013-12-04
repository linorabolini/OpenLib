//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package openlib.animation;

import openlib.animation.Library;
import openlib.animation.MovieSprite;
import flash.display.Sprite;

/**
 * A convenient controller to play though multiple different movies. Designed for characters and
 * objects that have a separate Flump symbol for each of their animations, and need to switch
 * between them. The played movies will be added to a new child entity of the owner.
 */
class MoviePlayer extends Animation
{
    /** The movie currently being shown. */
    public var movie:MovieSprite;

    public function new (lib :Library)
    {
        _lib = lib;
        movie = null;
        setCache(true);
		super();
    }

    /**
     * Configures whether this MoviePlayer will keep a cache of all its MovieSprites, rather than
     * creating a new instance for each play. This makes switching movies faster, at the expense of
     * memory. By default, the cache is enabled. If this MoviePlayer plays lots of different movies,
     * but doesn't switch through them too often, consider disabling the cache.
     * @returns This instance, for chaining.
     */
    public function setCache (cache :Bool) :MoviePlayer
    {
        _cache = cache ? new Map() : null;
        return this;
    }

    /**
     * Shows a movie that plays once. When it completes, the last looping movie is returned to. It
     * is an error to call this without starting a loop() first.
     * @param name The symbol name of the movie to play.
     * @param restart If this movie is already being played, whether it will restart it from the
     *   beginning.
     * @returns This instance, for chaining.
     */
    override public function play (name :String, repeat:Bool = true, ?onFinish:Void -> Void) :Void
    {
		this.onFinish = onFinish;
		this.repeat = repeat;
        if (repeat || movie == null || movie.symbol.name != name) {
            movie = playFromCache(name);
        }
    }

    override public function dispose ()
    {
        movie = null;
		_lib = null;
        movie = null;
		super.dispose();
    }

    override public function update(dt :Float)
    {
        // If this update would end the oneshot movie, replace it with the looping movie
        if (movie != null && movie.getPosition()+dt > movie.symbol.duration) {
			if (onFinish != null)
				onFinish();
			if(repeat)
				movie.setPosition(0); // reset the animation
        } else {
			movie.onUpdate(dt);
		}
    }

    private function playFromCache (name :String) :MovieSprite
    {
        var sprite;
        if (_cache != null) {
            sprite = _cache.get(name);
            if (sprite != null) {
                // Rewind it
                sprite.setPosition(0);
            } else {
                // Not in the cache, create the new entry
                sprite = createMovie(name);
                _cache.set(name, sprite);
            }
        } else {
            // Caching disabled, create a new movie each time
            sprite = createMovie(name);
        }
        return setCurrent(sprite);
    }

    private function createMovie (name :String) :MovieSprite
    {
        var sprite = _lib.createMovie(name);
        if (_decorator != null) {
            _decorator(sprite);
        }
        return sprite;
    }

    private function setCurrent (current :MovieSprite) :MovieSprite
    {
        if (movie == current) return current;
		if(movie != null) {
			movie.visible = false;
		}
        addChild(current);
		if(current.numChildren == 0)
			current.onAdded();
        return movie = current;
    }

    private var _lib :Library;

    private var _decorator :MovieSprite->Void;
    private var _cache :Map<String,MovieSprite>;
}
