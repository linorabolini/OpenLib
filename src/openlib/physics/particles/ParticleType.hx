package openlib.physics.particles;
import haxe.remoting.FlashJsConnection;
import flash.display.DisplayObject;
import openlib.math.FMath;
import openlib.physics.particles.ParticleEmitter;
import openlib.util.OpenlibAssets;

/**
 * ...
 * @author 
 */
class ParticleType
{

	public var angleMin:Float = 0;
	public var angleMax:Float = 0;
	public var angleIncrMin:Float = 0;
	public var angleIncrMax:Float = 0;
	public var angleWiggle:Float = 0;
	
	public var directionMin:Float = 0;
	public var directionMax:Float = 0;
	public var directionIncrMin:Float = 0;
	public var directionIncrMax:Float = 0;
	public var directionWiggle:Float = 0;
	
	public var velocityMin:Float = 1;
	public var velocityMax:Float = 600;
	public var velocityIncrMin:Float = 0;
	public var velocityIncrMax:Float = 0;
	public var velocityWiggle:Float = 0;
	
	public var sizeMin:Float = 10;
	public var sizeMax:Float = 10;
	public var sizeIncrMin:Float = 0;
	public var sizeIncrMax:Float = 0;
	public var sizeWiggle:Float = 0;
	
	public var lifeMin:Float = 1;
	public var lifeMax:Float = 1;
	
	public var scaleMin:Float = 1;
	public var scaleMax:Float = 1;
	public var scaleIncrMin:Float = 0;
	public var scaleIncrMax:Float = 0;
	public var scaleWiggle:Float = 0;
	
	public var linear_dampening:Float = 0.1;
	public var angular_dampening:Float = 0.1;
	
	// arrays
	public var colours:Array<Float>;
	public var alphas:Array<Float>;
	public var imagePaths:Array<String>;
	
	// collision mask
	public var collisionMask:Int;
	public var group:Int = 1;
	
	// collision mask constants
	public static var COLLISION_ALL:Int = 255;
	public static var COLLISION_NONE:Int = 0;
	
	// particle static storage
	private var isSaved = false; // do not dispose if particle is saved
	static private var storage:Map<String, ParticleType> = null;
	
	
	//===============================================================
	
	//  PARTICLE TYPE
	
	//===============================================================
	
	
	public function new(?emitter:ParticleEmitter) 
	{
		setParticleEmitter(emitter);
		
		// default alpha
		alphas = [1];
		imagePaths = [];
	}
	
	public function setParticleEmitter(emitter:ParticleEmitter) 
	{
		if (emitter != null)
			emitter.addParticleType(this);
	}
	
	
	//===============================================================
	
	
	public function setParticleScale(min:Float, max:Float, incrMin:Float = 0, incrMax:Float = 0, wiggle:Float = 0):ParticleType
	{
		scaleIncrMin = incrMin;
		scaleIncrMax = incrMax;
		scaleWiggle = wiggle;
		scaleMin = min;
		scaleMax = max;
		return this;
	}
	
	public function getScaleIncr():Float
	{
		return FMath.getRandomBetween(scaleIncrMin, scaleIncrMax);
	}
	
	public function getScale():Float
	{
		return FMath.getRandomBetween(scaleMin, scaleMax);
	}
	
	
	//===============================================================
	
	
	public function setParticleLife(min:Float, max:Float):ParticleType
	{
		lifeMin = min;
		lifeMax = max;
		
		return this;
	}
	
		
	public function getLife():Float
	{
		return FMath.getRandomBetween(lifeMin, lifeMax);
	}
		
	
	//===============================================================
	
	
	public function setParticleSize(min:Float, max:Float, incrMin:Float = 0, incrMax:Float = 0, wiggle:Float = 0):ParticleType
	{
		sizeIncrMin = incrMin;
		sizeIncrMax = incrMax;
		sizeWiggle = wiggle;
		sizeMin = min;
		sizeMax = max;
		
		return this;
	}
	
	public function getSizeIncr():Float
	{
		return FMath.getRandomBetween(sizeIncrMin, sizeIncrMax);
	}
	
	public function getSize():Float
	{
		return FMath.getRandomBetween(sizeMin, sizeMax);
	}
		
	
	//===============================================================
	
	
	public function setParticleVelocity(min:Float, max:Float, incrMin:Float = 0, incrMax:Float = 0, wiggle:Float = 0):ParticleType
	{
		velocityIncrMin = incrMin;
		velocityIncrMax = incrMax;
		velocityWiggle = wiggle;
		velocityMin = min;
		velocityMax = max;
		
		return this;
	}
	
	public function getVelocityIncr():Float
	{
		return FMath.getRandomBetween(velocityIncrMin, velocityIncrMax);
	}
	
	public function getVelocity():Float
	{
		return FMath.getRandomBetween(velocityMin, velocityMax);
	}
		
	
	//===============================================================
	
	
	public function setParticleDirection(min:Float, max:Float, incrMin:Float = 0, incrMax:Float = 0, wiggle:Float = 0):ParticleType
	{
		directionIncrMin = FMath.toRadians(incrMin);
		directionIncrMax = FMath.toRadians(incrMax);
		directionWiggle = FMath.toRadians(wiggle);
		directionMin = FMath.toRadians(min);
		directionMax = FMath.toRadians(max);
		
		return this;
	}
	
	public function getDirectionIncr():Float
	{
		return FMath.getRandomBetween(directionIncrMin, directionIncrMax);
	}
	
	public function getDirection():Float
	{
		return FMath.getRandomBetween(directionMin, directionMax);
	}
		
	
	//===============================================================
	
	
	public function setParticleAngle(min:Float, max:Float, incrMin:Float = 0, incrMax:Float = 0, wiggle:Float = 0):ParticleType
	{
		angleIncrMin = FMath.toRadians(incrMin);
		angleIncrMax = FMath.toRadians(incrMax);
		angleWiggle = FMath.toRadians(wiggle);
		angleMin = FMath.toRadians(min);
		angleMax = FMath.toRadians(max);
		
		return this;
	}
	
	public function getAngleIncr():Float
	{
		return FMath.getRandomBetween(angleIncrMin, angleIncrMax);
	}
	
	public function getAngle():Float
	{
		return FMath.getRandomBetween(angleMin, angleMax);
	}
		
	
	//===============================================================
	
	
	public function setParticleAlphas(alphas:Array<Float>):ParticleType
	{
		this.alphas = alphas;
		
		return this;
	}
		
	
	//===============================================================
	
	
	public function setParticleColours(colours:Array<Float>):ParticleType
	{
		this.colours = colours;
		
		return this;
	}
		
	
	//===============================================================
	
	
	public function addParticleImage(path:String):ParticleType
	{
		this.imagePaths.push(path);
		return this;
	}
		
	
	//===============================================================
		
	
	public function addParticleImages(paths:Array<String>):ParticleType
	{
		for (path in paths)
			addParticleImage(path);
		return this;
	}
		
	
	//===============================================================
	
	
		
	public function removeParticleImage(path:String):ParticleType
	{
		this.imagePaths.remove(path);
		return this;
	}
	
	
	//===============================================================
	
	
	public function setParticleCollisionMask(collisionMask:Int):ParticleType
	{
		this.collisionMask = collisionMask;
		return this;
	}
		
	
	//===============================================================
	
	
	public function setParticleGroup(group:Int):ParticleType
	{
		this.group = group;
		return this;
	}
	
	public function getView():DisplayObject
	{
		return OpenlibAssets.getBitmap(getArrayRandom(imagePaths));
	}
	
	public function getArrayRandom(a:Array<Dynamic>) 
	{
		if (a.length == 0) throw "ARRAY SHOULD NOT BE EMPTY";
		return a[Math.floor(Math.random() * a.length )];
	}
	
	public function dispose() 
	{
		if (isSaved) return;
		colours = null;
		alphas = null;
		imagePaths = null;
	}
	
	public function getAlphas() :Array<Float>
	{
		return this.alphas;
	}
	
		
	
	//===============================================================
	
	// STATIC STORAGE ACCESS

	//===============================================================
	
	static public function saveType(name:String, particleType:ParticleType) : Void 
	{
		if (storage == null) storage = new Map<String, ParticleType>();
		storage.set(name, particleType);
	}
	
	static public function getType(name:String) : ParticleType 
	{
		return storage.get(name);
	}
	
	//===============================================================
	
	
	
}