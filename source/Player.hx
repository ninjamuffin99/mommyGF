package;

import flash.display.BitmapData;
import flixel.FlxG;
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
	

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		
		var playerClip = Assets.getMovieClip("collLib:idkClip");
		var bitmapDate:BitmapData = new BitmapData(Std.int(playerClip.width), Std.int(playerClip.height));
		bitmapDate.draw(playerClip);
		
		loadGraphic(bitmapDate, false, Std.int(playerClip.width), Std.int(playerClip.height));
		
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
	}
	
}