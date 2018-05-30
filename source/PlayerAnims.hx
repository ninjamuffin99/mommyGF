package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author ninjaMuffin
 */
class PlayerAnims extends FlxSpriteGroup
{
	
	public var hitByVehicle:FlxSprite;
	public var pickingUp:FlxSprite;
	public var sideSwitch:FlxSprite;
	
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
		
		sideSwitch = new FlxSprite();
		sideSwitch.loadGraphic("assets/images/swfs/kidSideSwitch.png", true, 1024, Std.int(2048 / 4));
		sideSwitch.animation.add("switch", [1, 1, 1], 12, false);
		add(sideSwitch);
		
		
		hitByVehicle.setFacingFlip(FlxObject.RIGHT, true, false);
		hitByVehicle.setFacingFlip(FlxObject.LEFT, false, false);	
		/*
		pickingUp.setFacingFlip(FlxObject.RIGHT, true, false);
		pickingUp.setFacingFlip(FlxObject.LEFT, false, false);
		*/
		forEach(checkAlive);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		hitByVehicle.facing = facing;
	}
	
	
	/**
	 * Sets PlayerAnims class to visible and does other stuff who cares heehh
	 * 
	 * @param	sprite 
	 * Which sprite it's gonna use
	 * @param	X
	 * whatever
	 * @param	Y
	 * whatever its y
	 */
	public function updateCurSprite(sprite:FlxSprite, ?X:Float, ?Y:Float):Void
	{
		if (X == null)
			X = x;
		if (Y == null)
			Y = y;
		
		x = X;
		y = Y;
		
		curSprite = sprite;
		sprite.animation.curAnim.restart();
		sprite.visible = true;
		visible = true;
		
		forEach(checkAlive);
	}
	
	/**
	 * function that is used by updateCurSprite, don't worry about it too much
	 * @param	spriteAlive
	 */
	private function checkAlive(spriteAlive:FlxSprite):Void
	{
		if (curSprite == null)
			spriteAlive.visible = false;
		
		if (spriteAlive != curSprite)
		{
			spriteAlive.visible = false;
		}
	}
	
	
}