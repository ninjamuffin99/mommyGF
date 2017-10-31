package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Player extends FlxSprite 
{
	public var _left:Bool = true;
	

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		makeGraphic(Std.int(FlxG.width * 0.15), Std.int(FlxG.height * 0.5));
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
	}
	
}