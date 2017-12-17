package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class PlayerAnims extends FlxSpriteGroup
{
	
	public var hitByVehicle:FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super();
		
		this.x = X;
		this.y = Y;
		
		hitByVehicle = new FlxSprite();
		hitByVehicle.loadGraphic("assets/images/swfs/kidHitByVehicle.png", true, Std.int(4096 / 8), Std.int(2048 / 2));
		hitByVehicle.animation.add("hit", [0, 0, 1, 2, 2, 3, 4, 4, 5, 6, 8, 8, 9, 9, 10, 10], 24, false);
		hitByVehicle.animation.play("hit");
		add(hitByVehicle);
		
		hitByVehicle.setFacingFlip(FlxObject.RIGHT, true, false);
		hitByVehicle.setFacingFlip(FlxObject.LEFT, false, false);
		
		visible = false;	
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		hitByVehicle.facing = facing;
		
	}
	
}