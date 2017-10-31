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
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(Std.int(FlxG.width * 0.17), Std.int(FlxG.height * 0.7), FlxColor.GREEN);
		maxVelocity.x = 200;
		acceleration.x = 2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		_timer += FlxG.elapsed;
		if (_timer >= _timerRandom)
		{
			_timer = 0;
			_timerRandom = FlxG.random.float(1, 4);
		}
	}
	
}