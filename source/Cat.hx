package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Cat extends FlxNapeSprite 
{
	public var _punched:Bool = false;
	public var _timesPunched:Int = 0;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, CreateRectangularBody:Bool=true, EnablePhysics:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateRectangularBody, EnablePhysics);
		
		loadGraphic(AssetPaths.catSpriteSheet__png, true, 710, 429);
		animation.add("punched", [0, 1], 12, false);
		animation.add("peek", [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31], 24, false);
		animation.add("fly", [32]);
		setGraphicSize(Std.int(width / 3), Std.int(height / 3));
		updateHitbox();
		
		width = width / 2;
		centerOffsets();
		
		createRectangularBody(width / 2, height / 2);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
	}
	
	public function fly(xVel:Float, yVel:Float):Void
	{
		acceleration.y = 800;
		body.velocity.x = xVel;
		body.velocity.y = yVel;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (y >= FlxG.height)
		{
			_timesPunched = 0;
		}
		
		if (_punched)
		{
			angularVelocity = velocity.x * -0.9;
			animation.play("punched");
		}
		if (!_punched && velocity.x != 0)
		{
			animation.play("fly");
		}
		
	}
	
}