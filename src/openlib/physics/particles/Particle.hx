package openlib.physics.particles;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Shape;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Point;
import openlib.entity.Entity;
import openlib.entity.SpriteEntity;
import openlib.math.FMath;

/**
 * ...
 * @author 
 */
class Particle implements Entity
{
	public var toDispose:Bool = false;
	
	var body:Body;
	var view:SpriteEntity;
	
	var _elapsedTime:Float = 0;
	var _scale:Float;
	var _scaleIncr:Float;
	
	var _life:Float;
	var _type:ParticleType;
	
	var _angleIncr:Float;
	
	var _direction:Float;
	var _directionIncr:Float;
		
	var _velocity:Float;
	var _velocityIncr:Float;
	
	var _colours:Array<Float>;
	var _alphas:Array<Float>;
	var vel:Vec2;
	
	
	public function new(emitter:ParticleEmitter, type:ParticleType) 
	{
		var pos:Vec2 = emitter.getNewParticlePosition();
		_type = type;
		
		
		body = emitter.system.createCircle(pos.x, pos.y,
										   FMath.getRandomBetween(_type.sizeMin, _type.sizeMax),
										   BodyType.DYNAMIC, type.group, type.collisionMask);
										   
		 
		_life = type.getLife();
		
		_scale = type.getScale();
		_scaleIncr = type.getScaleIncr();
		
		// angle & rotation
		body.rotation = type.getAngle();
		_angleIncr = type.getAngleIncr();
		
		
		// alpha
		_alphas = type.getAlphas();
		
		// direction and velocity
		_direction = type.getDirection();
		_directionIncr = type.getDirectionIncr();
		_velocity = type.getVelocity();
		_velocityIncr = type.getVelocityIncr();
		
		
		// view configuration
		var view = new SpriteEntity();
		
		setupParticleView(view);
		
		setView(view);
				
		vel = new Vec2();
		
	}
	
	function setupParticleView(container:DisplayObjectContainer) 
	{
		var view = _type.getView();
		view.x = -(view.width / 2);
		view.y = -(view.height / 2);
		container.addChild(view);
	}
	
	public function setView(view) 
	{
		this.view = view;
	}
	
	public function getView() :SpriteEntity
	{
		return view;
	}
		
	public function update(dt:Float):Void 
	{
		_elapsedTime += dt;
		
		_velocity += _velocityIncr;
		
		if (_elapsedTime < _life)
		{
			updateLinearDamping(dt);
			updateAngularDamping(dt);
			updateScale(dt);
			updatePosition(dt);
			updateRotation(dt);
			updateAlpha(dt);
			updateColour(dt);
		}
		else 
		{
			this.toDispose = true;
		}
	}
	
	function updateScale(dt:Float) 
	{
		_scale += _scaleIncr * dt;
		setScale(_scale);
	}
	
	function setScale(scale:Float) 
	{
		this.view.scaleX = this.view.scaleY = scale;
	}
	
	private inline function updateColour(dt:Float) 
	{

	}
	
	private inline function updateAlpha(dt:Float) 
	{
		if (_alphas.length == 1) 
		{
			setAlpha(_alphas[0]);
		} else {
			
			var phaseStep:Float = _life / (_alphas.length - 1) ;
			var phasesPassed:Float = (_elapsedTime / _life) * (_alphas.length - 1) ;
			
			var initPhase:Int = Math.floor(phasesPassed);
			var nextPhase:Int = initPhase + 1;
			var deltaPhasePassed = phasesPassed - initPhase;
			
			var newAlpha = _alphas[initPhase] +  deltaPhasePassed * (_alphas[nextPhase] - _alphas[initPhase]) ;
			
			setAlpha(newAlpha);
		}
	}
	
	public function setAlpha(alpha:Float) 
	{
		view.alpha = alpha;
	}
	
	private inline function updateAngularDamping(dt:Float) 
	{
		body.angularVel *= 1-(_type.angular_dampening * dt);
	}
	
	private inline function updateLinearDamping(dt:Float) 
	{
		body.velocity.muleq(1-(_type.linear_dampening * dt));
	}
	
	private function updateRotation(dt:Float) 
	{
		this.body.rotation += _angleIncr * dt;
		getView().rotation = FMath.toDegrees(this.body.rotation);
	}
	
	private function updatePosition(dt:Float) 
	{
		_velocity += _velocityIncr * dt;
		_direction += _directionIncr * dt;
		
		if (_velocity != 0)
		{
			vel.x = ( Math.cos(_direction )  * _velocity ) * dt;
			vel.y = ( Math.sin(_direction )  * _velocity ) * dt;
			this.body.position.x += vel.x;
			this.body.position.y -= vel.y;
		}

		var pos: Vec2 =  this.body.position;
		
		getView().x = pos.x;
		getView().y = pos.y;
	}
	
	public function setxy(x:Float, y:Float):Particle 
	{
		body.position.setxy(x, y);
		return this;
	}
	
	public function dispose():Void 
	{
		_alphas = null;
		_colours = null;
		
		getView().dispose();
		body.space = null;
		body.shapes.at(0).userData.particle = null;
		body = null;
	}
	
}