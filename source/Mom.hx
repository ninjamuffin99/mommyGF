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
		makeGraphic(Std.int(FlxG.width * 0.17), Std.int(FlxG.height * 0.7), FlxColor.GREEN);
		maxVelocity.x = 200;
		acceleration.x = 2;
		
		_lean = angle;
		swapRotating();
	}
	
	private function initSpeed():Void
	{
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		_lean = angle;
		FlxG.watch.addQuick("Angle:", _lean);
		
		_timer += FlxG.elapsed;
		if (_timer >= _timerRandom && !_fallenDown)
		{
			swapRotating();
		}
		
		if (_lean >= 60 || _lean <= -60)
		{
			//fall();
		}
	}
	
	private function swapRotating():Void
	{
		_timer = 0;
		angularAcceleration = FlxG.random.float(-20, 20);
	}
	
	private function fall():Void
	{
		FlxG.camera.shake(0.05, 0.02);
		
		_fallenDown = true;
		angularAcceleration = 0;
		angle = 0;
		velocity.x = 0;
		acceleration.x = 0;
	}
	
}