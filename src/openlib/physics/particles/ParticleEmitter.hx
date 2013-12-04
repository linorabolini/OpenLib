package openlib.physics.particles;
import nape.geom.Vec2;
import openlib.entity.Entity;
import openlib.physics.particles.Particle;
import openlib.physics.particles.ParticleType;

/**
 * ...
 * @author 
 */
class ParticleEmitter implements Entity
{
	private var elapsed:Float;
	public var system:ParticleSystem;
	public var position:Vec2;
	
	private var particleTypes:Array<ParticleType>;
	var particlesToStream:Int = 0;
	var timeToStream:Float = 0;
	var counter:Float = 0;
	
	public function new(?system:ParticleSystem, ?position:Vec2) 
	{
		particleTypes = new Array<ParticleType>();
		
		if ((this.system = system) != null)
			system.addEmitter(this);
		
		if (position == null) 
		{
			setPosition(0, 0);
		} else {
			setPosition(position.x, position.y);
			position.dispose();
		}

	}
	
	public function addParticleType(type:ParticleType) : Void 
	{
		particleTypes.push(type);
	}
	
	public function removeParticleType(type:ParticleType) : Void 
	{
		particleTypes.remove(type);
	}
	
	public function streamParticles(number:Int, timeToStream:Float):Void 
	{
		particlesToStream = number;
		this.timeToStream = timeToStream;
	}
	
	public function burstParticles(particles:Int, ?typeIndex:Int):Void 
	{
		for (i in 0...particles) {
			createParticle(getRandom(particleTypes, typeIndex));
		}
	}
	
	function getRandom(particleTypes:Array<ParticleType>, ?particleTypeIndex:Int) 
	{
		particleTypeIndex = particleTypeIndex == null ? Math.floor(Math.random() * particleTypes.length) : particleTypeIndex;
		return particleTypes[particleTypeIndex];
	}
	
	public function createParticle(particleType:ParticleType):Void
	{
		system.createParticle(this, particleType);
	}
	
	function addParticle(particle:Particle) 
	{
		system.container.addChild(particle.getView());
	}
	
	public function getNewParticlePosition() :Vec2
	{
		return new Vec2(position.x, position.y);
	}
		
	public function update(dt:Float):Void 
	{
		elapsed += dt;
		
		if (timeToStream != 0)
		{
			counter += dt;
			if (counter >= timeToStream)
			{
				counter -= timeToStream;
				burstParticles(particlesToStream);
			}
		}
	}
	
	public function dispose():Void 
	{
		system = null;
	}
	
	public function setPosition(x:Float, y:Float)
	{
		if (this.position == null)
			this.position = new Vec2();
		
		this.position.setxy(x, y);
		
		return this;
	}

	
}