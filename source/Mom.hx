package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class Mom extends FlxNapeSprite
{
	private var _timer:Float = 0;
	private var _timerRandom:Float = FlxG.random.float(1, 4);
	
	public var _lean:Float;
	public var _distanceX:Float = 0;

	public var _fallenDown:Bool = false;
	
	public var _fallAngle:Float = 45;
	
	public var _timesFell:Int = 0;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, CreateRectangularBody:Bool=true, EnablePhysics:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateRectangularBody, EnablePhysics);
		loadGraphic(AssetPaths.momTemp__png, true, 860, 1676);
		
		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8);
		animation.add("fallLeft", [8, 9, 10], 12);
		animation.add("fallRight", [11, 12, 13], 12);
		animation.add("hitGround", [14, 15, 16], 12, false);
		
		animation.play("idle");
		setGraphicSize(Std.int(width / 2));
		
		updateHitbox();
		width = width * 0.75;
		createRectangularBody(width);
		//body.position.x = -100;
		origin.y = 1000;
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		initSpeed();
		_lean = angle;
		swapRotating();
		
		FlxG.log.add("mom added");
	}
	
	public function initSpeed():Void
	{
		maxVelocity.x = 200;
		//acceleration.x = 2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		//_lean = angle;
		FlxG.watch.addQuick("Angle:", angle);
		FlxG.watch.addQuick("SPin Speed", angularVelocity);
		
		
		
		_timer += FlxG.elapsed;
		
		if (_fallenDown)
		{
			if (angle >= 0)
			{
				angle = 90;
			}
			else
			{
				angle = -90;
				facing = FlxObject.LEFT;
			}
			
			angularVelocity = 0;
			
			if (animation.curAnim.name != "hitGround")
			{
				animation.play("hitGround");
			}
		}
		else
		{
			facing = FlxObject.RIGHT;
			if (angle >= 10)
			{
				animation.play("fallRight");
			}
			else if (angle <= -10)
			{
				animation.play("fallLeft");
			}
			else
			{
				animation.play("idle");
			}
		}
		
		if (_timer >= _timerRandom && !_fallenDown)
		{
			swapRotating();
		}
		
		if ((angle >= _fallAngle || angle <= -_fallAngle) && !_fallenDown)
		{
			fall();
		}
		
		if (animation.curAnim.name == "idle")
		{
			_distanceX += 1;
		}
		if (animation.curAnim.name == "fallLeft" || animation.curAnim.name == "fallRight")
		{
			_distanceX += FlxG.random.float(0.25, 0.5);
		}
	}
	
	private function swapRotating():Void
	{
		_timer = 0;
		//old rotatinbg logic
		//angularAcceleration = FlxG.random.float(-20, 20);
	}
	
	private function fall():Void
	{
		FlxG.camera.shake(0.05, 0.02);
		
		_lean = 0;
		_fallenDown = true;
		velocity.x = 0;
		acceleration.x = 0;
		_timesFell += 1;
	}
	
}