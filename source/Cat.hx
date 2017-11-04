package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Cat extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.catSpriteSheet__png, true, 710, 429);
		animation.add("punched", [0, 1], 12, false);
		animation.add("peek", //2-31 to do and then frame 32(0 based) is flying anim
		
		
	}
	
}