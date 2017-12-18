package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class PlayerAnims extends FlxSpriteGroup
{
	
	public var hitByVehicle:FlxSprite;
	public var pickingUp:FlxSprite;
	
	public static var curSprite:FlxSprite;

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
		
		pickingUp = new FlxSprite();
		pickingUp.loadGraphic("assets/images/swfs/kidPickingUp.png", true, Std.int( 2048 / 4), Std.int(512 / 2));
		pickingUp.animation.add("pickingUp", [0, 1, 2], 24);
		pickingUp.animation.play("pickingUp");
		add(pickingUp);
		
		
		hitByVehicle.setFacingFlip(FlxObject.RIGHT, true, false);
		hitByVehicle.setFacingFlip(FlxObject.LEFT, false, false);	
		
		forEach(checkAlive);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		hitByVehicle.facing = facing;
		
	}
	
	public function updateCurSprite(sprite:FlxSprite):Void
	{
		curSprite = sprite;
		
		forEach(checkAlive);
	}
	
	private function checkAlive(spriteAlive:FlxSprite):Void
	{
		if (spriteAlive != curSprite)
		{
			spriteAlive.visible = false;
		}
		else
			spriteAlive.visible = true;
	}
	
	
}