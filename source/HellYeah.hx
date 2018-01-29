package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class HellYeah extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/swfs/HellYeahText/hellYeahSheeet.png", "assets/images/swfs/HellYeahText/hellYeahSheeet.txt");
		
		frames = tex;
		
		animation.add("play", [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7], 24, false);
		animation.play("play");
		
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