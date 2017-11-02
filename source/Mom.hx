package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class Mom extends FlxSprite 
{
	private var _timer:Float = 0;
	private var _timerRandom:Float = FlxG.random.float(1, 4);
	
	public var _lean:Float;

	public var _fallenDown:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.momTemp__png, true, 860, 1146);
		
		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8);
		animation.add("fallLeft", [8, 9, 10], 12);
		animation.add("fallRight", [11, 12, 13], 12);
		
		animation.play("idle");
		setGraphicSize(Std.int(width / 2));
		updateHitbox();
		origin.y = 1000;
		
		initSpeed();
		_lean = angle;
		swapRotating();
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
		
		_timer += FlxG.elapsed;
		if (_timer >= _timerRandom && !_fallenDown)
		{
			swapRotating();
		}
		
		if (_lean >= 60 || _lean <= -60)
		{
			fall();
		}
		
		if (angle >= 20)
		{
			animation.play("fallRight");
		}
		else if (angle <= -20)
		{
			animation.play("fallLeft");
		}
		else
		{
			animation.play("idle");
		}
	}
	
	private function swapRotating():Void
	{
		_timer = 0;
		//old rotatinbg logic
		angularAcceleration = FlxG.random.float(-20, 20);
	}
	
	private function fall():Void
	{
		FlxG.camera.shake(0.05, 0.02);
		
		_lean = 0;
		_fallenDown = true;
		angle = 0;
		velocity.x = 0;
		acceleration.x = 0;
	}
	
}