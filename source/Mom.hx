package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.phys.Body;

/**
 * ...
 * @author ninjaMuffin
 */
class Mom extends FlxNapeSprite
{
	private var _timer:Float = 0;
	private var _timerRandom:Float = FlxG.random.float(1, 4);
	
	/**
	 * A value used to update angleAccelertaion
	 */
	public var angleAcceleration:Float = 9;
	public var angleDrag:Float = 0;
	private var rotateRads:Float = FlxG.random.float( -20 * Math.PI / 180, 20 * Math.PI / 180) / 60;
	
	/**
	   Whether or not the mom can spin freely(false) or if she falls down(true)
	   
	**/
	public var locked:Bool = true;
	public var flying:Bool = false;
	public var flyBoost:Float = 0;
	
	public var timeSwapMin:Float = 0.5;
	public var timeSwapMax:Float = 2.5;
	
	public var inCutscene:Bool = false;
	
	public var _lean:Float;
	public var _distanceX:Float = 0;
	public var _speedMultiplier:Float = 1;
	
	public var boostTimer:Float = 0.5;
	public var boostBonus:Float = 0;
	public var boosting:Bool = false;
	
	public var _fallenLeft:Bool = false;
	public var _fallenDown:Bool = false;
	public var _fallAngle:Float = 45 * Math.PI / 180;
	public var _timesFell:Int = 0;
	
	public var justFell(default, null):FlxSignal = new FlxSignal();
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, CreateRectangularBody:Bool=true, EnablePhysics:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateRectangularBody, EnablePhysics);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.momSheet__png, AssetPaths.momSheet__txt);
		
		frames = tex;
		
		//loadGraphic(AssetPaths.momTemp__png, true,  Std.int(7740/18), 838);
		
		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8);
		animation.add("fallLeft", [8, 9, 10], 12);
		animation.add("fallRight", [11, 12], 12);
		animation.add("hitGround", [13, 14, 15], 12, false);
		animation.add("squished", [18, 19, 20], 12, false);
		animation.add("flying", [26, 27, 28, 29, 30], 12);
		
		animation.play("idle");
		
		width = width * 0.6;
		
		
		//body.position.x = -100;
		origin.y = 500;
		
		createRectangularBody(width, FlxG.height - y);
		offset.set(25); //y offset is set throughout code
		body.translateShapes(Vec2.get(0, -120));
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		initSpeed();
		_lean = angle;
		swapRotating();
		
		body.allowMovement = false;
		
		setBodyMaterial(1, 0.3, 0.2, 0.6, 1);
		
		FlxG.log.add("mom added");
		
		antialiasing = true;
		
		//ogPos.set(offset.x, 0);
		
	}
	/*
	private var ogPos:FlxPoint;
	
	private function shake():Void
	{
		offset.x = FlxG.random.float( -4, 4);
		offset.y = FlxG.random.float( -4, 4);
	}
	*/
	public function initSpeed():Void
	{
		maxVelocity.x = 200;
		//acceleration.x = 2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		
		
		//animation.curAnim.frameRate = Std.int(12 * _speedMultiplier);
		
		//_lean = angle;
		FlxG.watch.addQuick("Angle:", body.rotation);
		FlxG.watch.addQuick("Angle in degs:", body.rotation * 180 / Math.PI);
		FlxG.watch.addQuick("SPin Speed", body.angularVel);
		
		_timer += FlxG.elapsed;
		
		angleAccel(rotateRads);
		
		locked = !flying;
		
		
		lowBoost();
		fallLogic();
		
		if (animation.curAnim.name == "idle")
		{
			_distanceX += 1 * _speedMultiplier * FlxG.timeScale;
			offset.y = 20;
		}
		if (animation.curAnim.name == "fallLeft" || animation.curAnim.name == "fallRight")
		{
			_distanceX += FlxG.random.float(0.35, 0.6) * _speedMultiplier * FlxG.timeScale;
			//shake();
		}
		if (animation.curAnim.name == "hitGround")
		{
			if (_fallenLeft)
			{
				offset.y = width * 0.25;
			}
			else
			{
				offset.y = width * 0.15;
			}
			
		}
		
		if (flying)
		{
			animation.play("flying");
			origin.y = 300;
			// dont know why the hell this offset works, but it's here so that it moves the Mom up???? the higher the value is???
			offset.y = FlxG.height * 0.55;
			flyBoost = (FlxAngle.asDegrees(body.rotation) / 360) + 1;
			FlxG.watch.addQuick("flight boost", flyBoost);
		}
		else
		{
			origin.y = 500;
		}
	}
	
	private function fallLogic():Void
	{
		
		if (_fallenDown)
		{
			var sideways:Float = 90 * Math.PI / 180;
			if (body.rotation >= 0)
			{
				body.rotation = sideways;
			}
			else
			{
				body.rotation = -sideways;
				facing = FlxObject.LEFT;
			}
			
			body.angularVel = 0;
			
			if (animation.curAnim.name != "hitGround")
			{
				animation.play("hitGround");
			}
		}
		else
		{
			facing = FlxObject.RIGHT;
			
			var stumbleAngle:Float = FlxAngle.asRadians(12.5);
			
			if (body.rotation >= stumbleAngle)
			{
				_fallenLeft = false;
				animation.play("fallRight");
			}
			else if (body.rotation <= -stumbleAngle)
			{
				_fallenLeft = true;
				animation.play("fallLeft");
			}
			else if (!inCutscene)
			{
				animation.play("idle");
			}
		}
		
		if (_timer >= _timerRandom && !_fallenDown)
		{
			swapRotating();
		}
		
		if ((body.rotation >= _fallAngle || body.rotation <= -_fallAngle) && !_fallenDown && locked)
		{
			fall();
		}
		
	}
	
	public  function swapRotating():Void
	{
		_timer = 0;
		_timerRandom = FlxG.random.float(timeSwapMin, timeSwapMax);
		//old rotatinbg logic
		updateAngleAccel();
	}
	
	private function fall():Void
	{
		justFell.dispatch();
		
		FlxG.camera.shake(0.05, 0.02);
		
		_lean = 0;
		_fallenDown = true;
		velocity.x = 0;
		acceleration.x = 0;
		_timesFell += 1;
		boostBonus = 0;
	}
	
	/**
	 * Function to replace the old rotate system. Call when need to update the angular acceleration of the physics body
	 * Also has a 50% chance to multiply it by 1.5-3 * speedMultiplier or somethin
	 */
	private function updateAngleAccel():Void
	{
		rotateRads = FlxAngle.asRadians(FlxG.random.float(-angleAcceleration , angleAcceleration)) * (_speedMultiplier * 0.30);
		
		if (FlxG.random.bool())
		{
			rotateRads *= FlxG.random.float(1.5, 3) * (_speedMultiplier * 0.33);
		}
	}
	
	public function lowBoost():Void
	{
		if ((body.rotation >= _fallAngle - FlxAngle.asRadians(20) || body.rotation <= -_fallAngle + FlxAngle.asRadians(20)) && !_fallenDown && locked)
		{
			if (boostTimer >= 0)
			{
				boostTimer -= FlxG.elapsed;
			}
			else
			{
				boostBonus += FlxG.random.float(0.05, 0.2);
				boosting = true;
			}
		}
		else
		{
			boostTimer = 0.5;
			boosting = false;
		}
		
		
		
		if ((body.rotation >= _fallAngle - FlxAngle.asRadians(10) || body.rotation <= -_fallAngle + FlxAngle.asRadians(10)) && !_fallenDown && locked)
		{
			color = FlxColor.RED;
			boosting = true;
			boostBonus += FlxG.random.float(0.025, 0.1);
		}
		else
		{
			color = FlxColor.WHITE;
		}
		
		
		if (!boosting && boostBonus > 0)
		{
			_distanceX += boostBonus * 0.4;
			boostBonus -= (boostBonus * 0.025) - 0.001;
		}
	}
	
	
	/**
	 * Funciton that runs every frame that adds a value to body.angularVel to simulate angular acceleration.
	 * 
	 * @param	rads
	 * In rads, this value is added to ody.angularVel, every frame, so make sure its a value divided by 60 or something
	 */
	private function angleAccel(rads:Float):Void
	{
		//body.angularVel += rads * 1.3 * _speedMultiplier;
		
		var velDelta = 0.5 * (FlxVelocity.computeVelocity(body.angularVel, rads, angleDrag, 0, FlxG.elapsed) - body.angularVel);
		body.angularVel += velDelta;
		body.rotation += body.angularVel * FlxG.elapsed;
		body.angularVel += velDelta;
		
		
		/* //code from FlxObject.updateMotion()
		var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(angularVelocity, angularAcceleration, angularDrag, maxAngular, elapsed) - angularVelocity);
		angularVelocity += velocityDelta; 
		angle += angularVelocity * elapsed;
		angularVelocity += velocityDelta;
		*/
	}
	
}