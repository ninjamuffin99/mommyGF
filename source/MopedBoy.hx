package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class MopedBoy extends ObstacleBase
{
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic("assets/images/swfs/mopen.png", true, Std.int(2048 / 4), Std.int(1024 / 2));
		animation.add("ride", [0, 1, 2, 4], 24);
		animation.play("ride");
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
		width -= 150;
		
		timer = FlxG.random.float(10, 20);
	}
	
}