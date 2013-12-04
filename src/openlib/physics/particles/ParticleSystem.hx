package openlib.physics.particles;
import openlib.entity.SpriteEntity;
import openlib.physics.particles.ParticleType;
import openlib.physics.Physics;

import nape.geom.Vec2;
import flash.display.DisplayObjectContainer;
import openlib.entity.Entity;
import openlib.physics.particles.ParticleEmitter;

/**
 * ...
 * @author 
 */
class ParticleSystem extends Physics implements Entity
{
	public var particles:Array<Particle>;
	public var emitters:Array<ParticleEmitter>;
	public var container:DisplayObjectContainer;
	
	public function new(container:DisplayObjectContainer, gravity:Vec2) 
	{
		emitters = [];
		particles = [];
		this.container = container;
		
		super();
		
		
		createWorld(gravity);
	}
	
	public function addEmitter(emitter:ParticleEmitter):Void
	{
		emitters.push(emitter);
	}
	
	public function removeEmitter(emitter:ParticleEmitter):Void
	{
		emitters.remove(emitter);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		
		for (emitter in emitters)
			emitter.dispose();
		
		emitters = null;
		
		for (particle in particles)
			particle.dispose();
			
		particles = null;
	}
	
	override public function update(dt:Float):Void 
	{
		super.update(dt);
		
		// update emitters
		for (emitter in emitters)
			emitter.update(dt);
		
		// copy the array of particles
		var tmp:Array<Particle> = particles.copy();
		
		// check if living particles should die
		for (particle in tmp)
		{
			particle.update(dt);
			
			if (particle.toDispose) {
				particle.dispose();
				particles.remove(particle);
			}
		}
		
		// free the copied array
		tmp = null;
		
	}
	
	public function createParticle(particleEmitter:ParticleEmitter, particleType:ParticleType) 
	{
		var particle:Particle = new Particle(particleEmitter, particleType);
		this.container.addChild(particle.getView());
		this.particles.push(particle);
	}
	
	
	
}