package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class ObstacleBase extends FlxSprite 
{

	public var timer:Float = 0;
	
	public static inline var BIKE:Int = 0;
	public static inline var ASTEROID:Int = 1;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
}