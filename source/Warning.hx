package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Warning extends FlxSprite 
{
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/swfs/warning.png", true, 128, 256);
		animation.add("blink", [0, 1, 0, 1, 1, 1, 1], 12, false);
		animation.play("blink");
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (animation.curAnim.finished)
		{
			kill();
		}
		
	}
	
	override public function revive():Void 
	{
		super.revive();
		
		FlxG.sound.play("assets/sounds/Car_Warning" + Global.soundEXT, 0.8);
		
	}
	
}