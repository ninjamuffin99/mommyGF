package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class WarningAsteroid extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.asteroidWarningSheet__png, AssetPaths.asteroidWarningSheet__txt);
		
		frames = tex;
		animation.add("warn", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 , 17, 18, 19], 24, false);
		animation.play("warn");
		
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (animation.curAnim.finished)
		{
			kill();
		}
	}
	
}