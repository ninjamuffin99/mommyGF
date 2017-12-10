package;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.Assets;
import openfl.display.Bitmap;

/**
 * ...
 * @author ninjaMuffin
 */
class Player extends FlxSprite 
{
	public var _left:Bool = true;
	public var _pickingUpMom:Bool = false;
	public var paralyzed:Bool = false;
	
	
	private var prevAnim:Int = FlxG.random.int(1, 3);

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.tempKidsShit__png, true, 1327, 800);
		animation.add("idle", [0, 0, 1, 2, 3, 4, 5, 5, 6, 7, 8, 9], 12);
		animation.play("idle");
		
		animation.add("poke1", [14], 30, false, true);
		animation.add("poke2", [15], 30, false, true);
		animation.add("poke3", [16], 30, false, true);
		animation.add("punch", [17, 18], 12, false);
		
		
		setGraphicSize(Std.int(width / 2));
		updateHitbox();
		width = width / 2;
		centerOffsets();
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (!paralyzed)
		{
			if (FlxG.keys.justPressed.Z)
			{
				animation.play("poke" + prevAnim, false);
				//generates new animation for next time?
				prevAnim = FlxG.random.int(1, 3, [prevAnim]);
			}
		}
		
		
		FlxG.watch.addQuick("current animation:", animation.curAnim.name);
	}
	
}