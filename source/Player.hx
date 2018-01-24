package;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.FlxSwipe;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
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
	public var curPostition:FlxPoint;
	
	public var sameSide:Bool = false;
	
	public var poked:Bool = false;
	public var poking:Bool = false;
	
	public var punched:Bool = false;
	public var punching:Bool = false;
	
	public var justSwitched:Bool = false;
	
	//PUNCHING POWER VARS
	public var punchMultiplier:Float = 1;
	
	
	
	/**
	 * In degrees
	 */
	public var smackPower:Float = 3;
	/**
	 * in Degrees
	 */
	public var pushMultiplier:Float = 1.5;
	
	
	//CONTROLS AND SHIT
	
	//the p means it has been just pressed
	public var leftP:Bool = false;
	public var rightP:Bool = false;
	public var upP:Bool = false;
	public var actionP:Bool = false;
	
	//refers to key being held down
	public var left:Bool = false;
	public var right:Bool = false;
	public var up:Bool = false;
	public var action:Bool = false;
	
	//Refers to keys being pressed down, doesnt have that FlxG.keys shit because the upper stuff is still there because lol im lazy
	public var leftR:Bool = false;
	public var rightR:Bool = false;
	public var upR:Bool = false;
	public var actionR:Bool = false;
	
	private var disableTimer:Float = 0;
	private var prevAnim:Int = FlxG.random.int(1, 3);

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.tempKidsShit__png, true, Std.int(12607/19), 400);
		animation.add("idle", [0, 0, 1, 2, 3, 4, 5, 5, 6, 7, 8, 9], 12);
		animation.play("idle");
		
		animation.add("poke1", [14], 30, false, true);
		animation.add("poke2", [15], 30, false, true);
		animation.add("poke3", [16], 30, false, true);
		animation.add("punch", [17, 18], 12, false);
		
		
		width = width / 2;
		centerOffsets();
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		//Updates the points as long as the player is on screen
		Points.curTime += FlxG.elapsed * FlxG.timeScale;
		
		
		if (disableTimer > 0)
		{
			disableTimer -= FlxG.elapsed;
			paralyzed = true;
		}
		else 
		{
			paralyzed = false;
		}
		
		
		
		if (!paralyzed)
		{
			controls();
			
			if (poked)
			{
				animation.play("poke" + prevAnim, false);
				//generates new animation for next time?
				prevAnim = FlxG.random.int(1, 3, [prevAnim]);
			}
		}
	}
	
	private function controls():Void
	{
		#if !mobile
		leftP = FlxG.keys.anyJustPressed(["LEFT", "A", "J"]);
		rightP = FlxG.keys.anyJustPressed(["RIGHT", "D", "L"]);
		upP = FlxG.keys.anyJustPressed(["UP", "W", "I"]);
		actionP = FlxG.keys.anyJustPressed(["Z", "SPACE", "X", "N", "M"]);
		
		left = FlxG.keys.anyPressed(["LEFT", "A", "J"]);
		right = FlxG.keys.anyPressed(["RIGHT", "D", "L"]);
		up = FlxG.keys.anyPressed(["UP", "W", "I"]);
		action = FlxG.keys.anyPressed(["Z", "SPACE", "X", "N", "M"]);
		
		leftR = FlxG.keys.anyJustReleased(["LEFT", "A", "J"]);
		rightR = FlxG.keys.anyJustReleased(["RIGHT", "D", "L"]);
		upR = FlxG.keys.anyJustReleased(["UP", "W", "I"]);
		actionR = FlxG.keys.anyJustReleased(["Z", "SPACE", "X", "N", "M"]);
		#end
		
		mouseControls();
		
		
		
		//punching, if they're on the corrrect side. Only checks if not punching (holding an action button)
		
		if (actionP || upP)
		{
			punched = true;
		}
		else
		{
			punched = false;
		}
		
		if (action || up)
		{
			punching = true;
		}
		else 
		{
			punching = false;
		}
		
		
		
		//Checks if needs to switch sides
		if (_left && rightP || !_left && leftP)
		{
			justSwitched = true;
		}
		else if (justSwitched && (rightR || leftR))
			justSwitched = false;
		
		
		if (!justSwitched && !punching) 
		{
			//Checks if holding down buttons on correct sides for pokin
			if (left && _left || right && !_left)
			{
				poking = true;
			}
			else 
			{
				poking = false;
			}
			
			//checks if player just poked
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
		}
		
		
		//Sets player position depending on whats bein held
		
		if (left)
		{
			_left = true;
		}
		if (right)
		{
			_left = false;
		}
		
	}
	
	public function disable(time:Float = 1):Void
	{
		disableTimer += time;
	}
	
	
	private function mobileControls():Void
	{
		//Touch controls
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed) 
			{
				if (touch.screenX >= FlxG.width / 2)
				{
					leftP = true;
				}
				else
				{
					rightP = true;
				}
			}
			
			if (touch.pressed)
			{
				if (touch.screenX >= FlxG.width / 2)
				{
					left = true;
				}
				else
				{
					right = true;
				}
			}
			
			if (touch.justReleased) 
			{
				if (touch.screenX >= FlxG.width / 2)
				{
					leftR = true;
				}
				else
				{
					rightR = true;
				}
			}
		}
		
		//Swipe controls
		//swipeManager();
		
	}
	
	private function mouseControls():Void
	{
		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.screenX >= FlxG.width/2)
			{
				
				rightP = true;
				
			}
			else
			{
				leftP = true;
			}
		}
		
		if (FlxG.mouse.pressed)
		{
			if (FlxG.mouse.screenX >= FlxG.width/2)
			{
				
				right = true;
				
			}
			else
			{
				left = true;
			}
		}
		
		
		if (FlxG.mouse.justReleased) 
		{
			if (FlxG.mouse.screenX >= FlxG.width/2)
			{
				
				rightR = true;
				
			}
			else
			{
				leftR = true;
			}
		}
		
		//swipeManager();
		
	}
	
	private function swipeManager():Void
	{
		var swipe:FlxSwipe = null;
		
		for (s in FlxG.swipes)
		{
			swipe = s;
			
			FlxG.log.add("SwipeAngle: " + swipe.angle);
			
			if (swipe.angle >= -15 && swipe.angle <= 15)
			{
				upP = true;
			}
			
		}
		
	}
	
	
}