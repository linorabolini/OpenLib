package openlib.easing;

/**
 * ...
 * @author Lean
 */
class Easing
{
	
	private static var functions:Map < String, Float->Float->Float->Float->Float >;
	
	static function __init__()
	{
		functions = new Map<String, Float->Float->Float->Float->Float>();
	
		// Linear
		registerFunction("linear", Linear.ease);
		
		// Default
		registerFunction("easein", Quad.easeIn);
		registerFunction("easeout", Quad.easeOut);
		registerFunction("easeinout", Quad.easeInOut);
		
		// Quad
		registerFunction("quadeasein", Quad.easeIn);
		registerFunction("quadeaseout", Quad.easeOut);
		registerFunction("quadeaseinout", Quad.easeInOut);
		
		// Back
		registerFunction("backeasein", Back.easeIn);
		registerFunction("backeaseout", Back.easeOut);
		registerFunction("backeaseinout", Back.easeInOut);
		
		// Bounce
		registerFunction("bounceeasein", Bounce.easeIn);
		registerFunction("bounceeaseout", Bounce.easeOut);
		registerFunction("bounceeaseinout", Bounce.easeInOut);
		
		// Circ
		registerFunction("circeasein", Circ.easeIn);
		registerFunction("circeaseout", Circ.easeOut);
		registerFunction("circeaseinout", Circ.easeInOut);
		
		// Cubic
		registerFunction("cubiceasein", Cubic.easeIn);
		registerFunction("cubiceaseout", Cubic.easeOut);
		registerFunction("cubiceaseinout", Cubic.easeInOut);
		
		// Elastic
		registerFunction("elasticeasein", Elastic.easeIn);
		registerFunction("elasticeaseout", Elastic.easeOut);
		registerFunction("elasticeaseinout", Elastic.easeInOut);
		
		// Expo
		registerFunction("expoeasein", Expo.easeIn);
		registerFunction("expoeaseout", Expo.easeOut);
		registerFunction("expoeaseinout", Expo.easeInOut);
		
		// Quart
		registerFunction("quarteasein", Quart.easeIn);
		registerFunction("quarteaseout", Quart.easeOut);
		registerFunction("quarteaseinout", Quart.easeInOut);
		
		// Quint
		registerFunction("quinteasein", Quint.easeIn);
		registerFunction("quinteaseout", Quint.easeOut);
		registerFunction("quinteaseinout", Quint.easeInOut);
		
		// Sine
		registerFunction("sineeasein", Sine.easeIn);
		registerFunction("sineeaseout", Sine.easeOut);
		registerFunction("sineeaseinout", Sine.easeInOut);
	}

	/**
	 * Return the easing function that corresponds to the given identifier.
	 *
	 * <p>The following special identifiers are accepted: "linear", "easeIn", "easeOut", "easeInOut",
	 * which map to the Linear and Quad easing functions.</p>
	 *
	 * <p>The rest of the easing functions have <code>class + function</code> identifiers.  For example,
	 * the <code>Cubic.easeIn</code> function can be accessed with the "cubicEaseIn" id.  See the example
	 * at <code>examples/easing</code> to see the full list of supported functions.
	 * </p>
	 *
	 * <p>Identifiers are case insensitive, and any periods (.) are ignored: "expoEaseOut", "ExpoEaseOut", "expoeaseout", "Expo.easeOut" all map
	 * to the same function: <code>Expo.easeOut</code>.</p>
	 */
	public static function getFunction(id:String = "linear"):Float->Float->Float->Float->Float
	{
		if (id == "" || id == null) 
			id = "linear";
		
		id = normalizedId(id);
		
		var f = functions.get(id);
		
		if (f == null)
			throw "Undefinied transition function \"" + id + "\"";
		
		return f;
	}

	/**
	 * Register a new easing function.
	 *
	 * <p>After this call, the function can be accessed with getFunction().</p>
	 */
	public static function registerFunction(id:String, func:Float->Float->Float->Float->Float):Void
	{
		// (time:Number, start:Number = 0, change:Number = 1, duration:Number = 1):Number
		id = normalizedId(id);
		
		var f = functions.get(id);
		
		if (f != null)
			throw "Easing function with identifier \"" + id + "\" already exists.";
		
		
		functions.set(id, func);
	}
	
	/** Return the normalized version of a function identifier (lower case & ignore periods). */
	private static function normalizedId(id:String):String
	{
		return StringTools.replace(id, ".", "").toLowerCase();
	}

}

 
	
