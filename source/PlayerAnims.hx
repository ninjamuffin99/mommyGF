package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class PlayerAnims extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic("assets/images/swfs/kidHitByVehicle.png", true, Std.int(4096 / 8), Std.int(2048 / 2));
		animation.add("hit", [0, 0, 1, 2, 2, 3, 4, 4, 5, 6, 8, 8, 9, 9, 10, 10], 24, false);
		animation.play("hit");
		
		
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.LEFT, false, false);
		
	}
	
}