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
	/**
	 * REFERS TO WHICH SIDE OF THE SCREEN THE PLAYER IS CURRENTLY ON. Not to be confused with the variable 'left' which refers to if a left button control has been pressed
	 */
	public var _left:Bool = true;
	public var _pickingUpMom:Bool = false;
	public var paralyzed:Bool = false;
	
	public var sameSide:Bool = false;
	
	public var poked:Bool = false;
	public var poking:Bool = false;
	
	
	//CONTROLS AND SHIT
	
	//the p means it has been just pressed
	public var leftP:Bool = FlxG.keys.anyJustPressed(["LEFT", "A", "J"]);
	public var rightP:Bool = FlxG.keys.anyJustPressed(["RIGHT", "D", "L"]);
	public var upP:Bool = FlxG.keys.anyJustPressed(["UP", "W", "I"]);
		
	//refers to key being held down
	public var left:Bool = FlxG.keys.anyPressed(["LEFT", "A", "J"]);
	public var right:Bool = FlxG.keys.anyPressed(["RIGHT", "D", "L"]);
	public var up:Bool = FlxG.keys.anyPressed(["UP", "W", "I"]);
	
	
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
		
		controls();
		
		
		if (!paralyzed)
		{
			if (poked)
			{
				animation.play("poke" + prevAnim, false);
				//generates new animation for next time?
				prevAnim = FlxG.random.int(1, 3, [prevAnim]);
			}
		}
		
		
		FlxG.watch.addQuick("current animation:", animation.curAnim.name);
	}
	
	private function controls():Void
	{
		
		leftP = FlxG.keys.anyJustPressed(["LEFT", "A", "J"]);
		rightP = FlxG.keys.anyJustPressed(["RIGHT", "D", "L"]);
		upP = FlxG.keys.anyJustPressed(["UP", "W", "I"]);
		
		left = FlxG.keys.anyPressed(["LEFT", "A", "J"]);
		right = FlxG.keys.anyPressed(["RIGHT", "D", "L"]);
		up = FlxG.keys.anyPressed(["UP", "W", "I"]);
		
		
		if (_left && leftP)
		{
			poked = true;
		}
		else if (!_left && rightP)
		{
			poked = true;
		}
		else
		{
			poked = false;
		}
		
		
		if (poked)
		{
			if (left || right)
			{
				poking = true;
			}
			else
			{
				poking = true;
			}
		}
		
		
		if (left)
		{
			_left = true;
		}
		if (right)
		{
			_left = false;
		}
		
	}
	
}