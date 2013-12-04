//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package openlib.animation;

import flash.display.Sprite;

/**
 * Defines an exported SWF symbol.
 */
interface Symbol
{
    /**
     * The name of this symbol.
     */
    var name (get_name, null) :String;

    /**
     * Instantiate a sprite that displays this symbol.
     */
    function createSprite () :Sprite;
}
