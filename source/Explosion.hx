package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Explosion extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/swfs/ExplosionFrames/explosionSheet.png", "assets/images/swfs/ExplosionFrames/explosionSheet.txt");
		
		frames = tex;
		
		//test is just explosion
		animation.add("test", [0, 1, 2, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 6, 7, 8, 9], 24, false);
		animation.play("test");
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (animation.curAnim.finished)
			kill();
		
	}
	
}