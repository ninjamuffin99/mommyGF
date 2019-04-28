package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class EffectBase extends FlxSprite 
{
	public static inline var EXPLOSION:Int = 1;
	public static inline var HELLYEAH:Int = 2;
	public static inline var ASTEROIDWARNING:Int = 3;

	public function new(?X:Float=0, ?Y:Float=0, type:Int) 
	{
		super(X, Y);
		
		switch(type)
		{
			case EffectBase.EXPLOSION:
				
				var tex = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/swfs/ExplosionFrames/explosionSheet.png", "assets/images/swfs/ExplosionFrames/explosionSheet.txt");
				
				frames = tex;
				
				//test is just explosion
				animation.add("test", [0, 1, 2, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 6, 7, 8, 9], 24, false);
				animation.play("test");
			case EffectBase.HELLYEAH:
				var tex = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/swfs/HellYeahText/hellYeahSheeet.png", "assets/images/swfs/HellYeahText/hellYeahSheeet.txt");
				
				frames = tex;
				
				animation.add("play", [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7], 24, false);
				animation.play("play");
			case EffectBase.ASTEROIDWARNING:
				
				var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.asteroidWarningSheet__png, AssetPaths.asteroidWarningSheet__txt);
				
				frames = tex;
				animation.add("warn", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 , 17, 18, 19], 24, false);
				animation.play("warn");
				
		}
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (animation.curAnim.finished)
			kill();
		
	}
	
}