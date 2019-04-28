package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.FlxSwipe;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.Assets;


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
	public var confused:Bool = false;
	private var confusedCounter:Int = 0;
	public var curPostition:FlxPoint;
	
	public var sameSide:Bool = false;
	
	public var poked:Bool = false;
	public var poking:Bool = false;
	
	public var punched:Bool = false;
	public var punching:Bool = false;
	
	public var ducked:Bool = false;
	public var ducking:Bool = false;
	
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
	public var downP:Bool = false;
	public var spamP:Bool = false;
	public var actionP:Bool = false;
	
	//refers to key being held down
	public var left:Bool = false;
	public var right:Bool = false;
	public var up:Bool = false;
	public var down:Bool = false;
	public var action:Bool = false;
	
	//Refers to keys being pressed down, doesnt have that FlxG.keys shit because the upper stuff is still there because lol im lazy
	public var leftR:Bool = false;
	public var rightR:Bool = false;
	public var upR:Bool = false;
	public var downR:Bool = false;
	public var actionR:Bool = false;
	
	private var disableTimer:Float = 0;
	private var confuseTimer:Float = 0;
	private var prevAnim:Int = FlxG.random.int(1, 3);
	public var flying:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		
		// NOTE TO FUTURE SELF: USE THE SPARROW SPRITESHEET EXPORT IN ADOBE ANIMATE!!!
		// THEN USE `FlxAtlasFrames.fromSparrow()` IN THIS NEXT LINE
		// AND THEN USE `animation.addByPrefix()` to load in animations EZ!!!!
		//var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.kidSheetJune6__png, AssetPaths.kidSheetJune6__txt);
		
		var tex = FlxAtlasFrames.fromSparrow(AssetPaths.kidSheetFeb18__png, Assets.getText("assets/images/kidSheetFeb18.xml"));
		
		frames = tex;
		
		animation.addByPrefix("idle", "Kid Walking Left", 24);
		animation.play("idle");
		
		animation.addByPrefix("poke1", "Poke 1", 24, false, true);
		animation.addByPrefix("poke2", "Poke 2", 24, false, true);
		animation.addByPrefix("poke3", "Poke 3", 24, false, true);
		animation.addByPrefix("punch", "Kid Cat Punch", 24, false);
		animation.addByPrefix("ducking", "Poke 3", 24, false, true);
		animation.addByPrefix("pickingUp", "Kid Lifting", 24);
		animation.addByPrefix("flying", "Kid Falling", 24);
		animation.addByPrefix("momFalls", "Kid Panic at Fall Mom", 24, false, true);
		
		
		setGraphicSize(Std.int(width * 0.45));
		updateHitbox();
		
		/*
		animation.addByIndices("idle", "kidWalkNew", [0, 1, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 11], "", 12);
		animation.play("idle");
		
		animation.addByIndices("poke1", "kidPokeV1", [1, 1, 2, 2, 3, 3, 4, 5, 6, 7, 8], "", 24, false, true);
		animation.addByIndices("poke2", "kidPokeV2", [1, 2, 3, 4], "",  12, false, true);
		animation.addByIndices("poke3", "kidPokeV3", [1, 1, 2, 2, 3, 4, 5, 6], "", 24, false, true);
		animation.add("punch", [66, 67, 68, 69], 12, false);
		animation.addByNames("ducking", ["kidPokeV30001"], 1, false, true);
		// animation.add("pickingUp", [31, 32, 33], 24);
		animation.addByIndices("flying", "kidFalling_", [1, 1, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8], "", 24);
		*/
		
		width = width / 2;
		centerOffsets();
		
		offset.y += -40;
		offset.x -= 30;
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		//Updates the points as long as the player is on screen
		Global.curTime += FlxG.elapsed * FlxG.timeScale;
		
		statusChecks();
		
		
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
	
	private function statusChecks():Void
	{
		if (disableTimer > 0)
		{
			disableTimer -= FlxG.elapsed;
			paralyzed = true;
		}
		else 
		{
			paralyzed = false;
		}
		
		
		if (confuseTimer > 0)
		{
			confuseTimer -= FlxG.elapsed;
			confused = true;
		}
		else
			confused = false;
		
	}
	
	private function controls():Void
	{
		#if !mobile
		leftP = FlxG.keys.anyJustPressed(["LEFT", "A", "J"]);
		rightP = FlxG.keys.anyJustPressed(["RIGHT", "D", "L"]);
		upP = FlxG.keys.anyJustPressed(["UP", "W", "I"]);
		downP = FlxG.keys.anyJustPressed(["DOWN", "S", "K"]);
		actionP = FlxG.keys.anyJustPressed(["Z", "SPACE", "X", "N", "M"]);
		
		
		left = FlxG.keys.anyPressed(["LEFT", "A", "J"]);
		right = FlxG.keys.anyPressed(["RIGHT", "D", "L"]);
		up = FlxG.keys.anyPressed(["UP", "W", "I"]);
		down = FlxG.keys.anyPressed(["DOWN", "S", "K"]);
		action = FlxG.keys.anyPressed(["Z", "SPACE", "X", "N", "M"]);
		
		leftR = FlxG.keys.anyJustReleased(["LEFT", "A", "J"]);
		rightR = FlxG.keys.anyJustReleased(["RIGHT", "D", "L"]);
		upR = FlxG.keys.anyJustReleased(["UP", "W", "I"]);
		downR = FlxG.keys.anyJustReleased(["DOWN", "S", "K"]);
		actionR = FlxG.keys.anyJustReleased(["Z", "SPACE", "X", "N", "M"]);
		#end
		
		mouseControls();
		
		if (FlxG.onMobile)
		{
			mobileControls();
					
			
		}
		
		spamP = (leftP || rightP);
		
		#if android
			if (spamP)
			{
				Hardware.vibrate(FlxG.random.int(50, 90));
			}
			
		#end
		
		
		if (confused)
		{
			if (leftP || rightP || upP || downP || actionP)
			{
				confusedCounter += 1;
				if (confusedCounter >= 4)
				{
					confusedCounter = 0;
					FlxG.camera.flash();
				}
			}
		}
		
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
		
		if (down)
		{
			if (downP)
			{
				ducked = true;
				
			}
			else
			{
				ducked = false;
			}
			ducking = true;
		}
		else
		{
			ducking = false;
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
	
	public function disable(time:Float = 1, ?type:Int = 0):Void
	{
		switch (type) 
		{
			case 0:
				disableTimer += time;
			case 1:
				confuseTimer += time;
			default:
				
		}
	}
	
	public function clearStatus():Void
	{
		paralyzed = false;
		disableTimer = 0;
		
		confused = false;
		confuseTimer = 0;
		confusedCounter = 0;
	}
	
	private function mobileControls():Void
	{
		leftP = rightP = upP = leftR = rightR = upR = left = right = up = false;
		
		//Touch controls
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed) 
			{
				if (touch.x <= FlxG.width / 2)
				{
					leftP = true;
				}
				else
				{
					rightP = true;
				}
				
				if (touch.y <= FlxG.height * 0.15)
				{
					upP = true;
				}
			}
			
			if (touch.pressed)
			{
				if (touch.x <= FlxG.width / 2)
				{
					left = true;
				}
				else
				{
					right = true;
				}
				
				if (touch.y <= FlxG.height * 0.15)
				{
					up = true;
				}
			}
			
			if (touch.justReleased) 
			{
				if (touch.x <= FlxG.width / 2)
				{
					leftR = true;
				}
				else
				{
					rightR = true;
				}
				
				if (touch.y <= FlxG.height * 0.15)
				{
					upR = true;
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
			if (FlxG.mouse.screenX >= FlxG.width / 2)
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
			if (FlxG.mouse.screenX >= FlxG.width / 2)
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
			if (FlxG.mouse.screenX >= FlxG.width / 2)
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