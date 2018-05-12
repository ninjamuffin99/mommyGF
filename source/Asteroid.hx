package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Asteroid extends ObstacleBase
{
	public var left:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.asteroidSheet__png, AssetPaths.asteroidSheet__txt);
		frames = tex;
		
		animation.add("crash", [0, 2, 3, 3, 4], 24, false);
		
		animation.play("crash");
		
		timer = FlxG.random.float(50, 100);
	}
}