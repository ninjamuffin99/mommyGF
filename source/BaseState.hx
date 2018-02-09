package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.nape.FlxNapeSpace;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
 
class BaseState extends FlxState 
{
	//MOM SHIT
	private var _mom:Mom;
	private var _pickupMom:Float = 0;
	private var _pickupMomNeeded:Float = 15;
	private var _momCatOverlap:Bool = false;
	private var _pickupTimeBuffer:Float = 0;
	
	//KID SHIT
	private var _player:Player;
	private var _playerPunchHitBox:FlxObject;
	private var _playerY:Float = 200;
	private var _playerTrail:FlxTrailArea;
	
	private var _playerAnims:PlayerAnims;
	
	//CAT SHIT
	private var _cat:Cat;
	private var _catLeft:Bool = false;

	
	//Cnady Stuff
	private var _candy:Candy;
	private var _candyMode:Bool = false;
	private var _candyTimer:Float = 0.6;
	private var _candyBoost:Float = 0;
	
	private var _candyAmount:Int = 0;
	
	private var _grpCandyDisplay:FlxTypedGroup<Candy>;
	
	
	//OBSTACLE SHIT
	private var _retard:Retard;
	private var _moped:MopedBoy;
	private var _mopedWarning:Warning;
	private var _mopedTimer:Float = 1;
	private var _asteroidTimer:Float = 1;
	private var _asteroid:Asteroid;
	
	
	private var _timer:Float = 180;
	
	//text that shows when leaning too far??
	private var boostText:FlxText;
	

	override public function create():Void 
	{
		//FlxG.mouse.visible = false;
		FlxNapeSpace.init();
		
		FlxNapeSpace.space.gravity.setxy(0, 0);
		
		FlxG.camera.maxScrollY = FlxG.height;
		FlxG.camera.minScrollY = 0;
		
		FlxG.camera.bgColor = 0xFF222222;
		
		super.create();
	}
	
	/**
	 * CALL THIS WHEN SETTING UP THE PLAYSTATES, AFTER THE BG???
	 */
	private function addMainStuff():Void
	{
		_playerAnims = new PlayerAnims(-90, -32);
		add(_playerAnims);
		
		_mom = new Mom(530, -25 + 600);
		add(_mom);
		
		_cat = new Cat(0 - 200, FlxG.height + 10);
		add(_cat);
		
		
		_candy = new Candy(-70);
		add(_candy);
		
		_player = new Player(50, _playerY);
		add(_player);
		
		
		//OBSTACLES AND WHATNOT
		_moped = new MopedBoy(FlxG.width, 200);
		add(_moped);
		_mopedTimer = FlxG.random.float(10, 20);
		
		_mopedWarning = new Warning(FlxG.width, 40);
		add(_mopedWarning);
		
		_asteroid = new Asteroid(0, 0);
		_asteroid.kill();
		_asteroidTimer = FlxG.random.float(50, 100);
		add(_asteroid);
		
		//_retard = new Retard(0, 300);
		//add(_retard);
		
		//Trail effect
		_playerTrail = new FlxTrailArea(0, 0, FlxG.width, FlxG.height, 0.75);
		_playerTrail.add(_player);
		add(_playerTrail);
		
		_playerPunchHitBox = new FlxObject(_player.x + 60, _player.y, 75, 75);
		add(_playerPunchHitBox);
		
		
		hudInit();
		
		FlxG.debugger.addTrackerProfile(new TrackerProfile(Mom, ["angleAcceleration", "angleDrag", "timeSwapMin", "timeSwapMax"], []));
		FlxG.debugger.track(_mom, "Mom");
		
		FlxG.debugger.addTrackerProfile(new TrackerProfile(Player, ["punchMultiplier", "smackPower", "pushMultiplier"], []));
		FlxG.debugger.track(_player, "Player");
		
	}
	
	private function hudInit():Void
	{
		_grpCandyDisplay = new FlxTypedGroup<Candy>();
		add(_grpCandyDisplay);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		controls();
		
		boostText.visible = _mom.boosting;
		
		if (FlxG.overlap(_candy, _player))
		{
			_candy.kill();
			
			var candyDisplay:Candy;
			candyDisplay = new Candy((48 * _grpCandyDisplay.length) + 30, (FlxG.height - _candy.height) - 30);
			_grpCandyDisplay.add(candyDisplay);
			
			_candyAmount += 1;
		}
		
		if (FlxG.keys.anyJustPressed(["E", "O", "CTRL", "SHIFT"]) && _candyAmount >= 1)
		{
			_grpCandyDisplay.remove(_grpCandyDisplay.getFirstExisting(), true);
			
			_grpCandyDisplay.forEachExists(candyGroupMove);
			
			activateCandy();
			_candyAmount -= 1;
		}
		
		
		if (_mom.boosting)
		{
			boostText.text = "Close Call Bonus: " + FlxMath.roundDecimal(_mom.boostBonus, 2);
		}
	}
	
	private function candyGroupMove(c:Candy):Void
	{
		c.x -= 48;
	}
	
	private function activateCandy():Void
	{
		FlxG.camera.color = 0xFFFEFEFE;
		FlxTween.tween(FlxG.camera, {color:FlxColor.WHITE}, _candyTimer);
		FlxG.sound.play("assets/sounds/CandyMode.mp3", 0.7);
			
		_candyMode = true;
		FlxG.camera.flash(FlxColor.WHITE, 0.075);
		_candy.x = -_candy.width;
		_candy.velocity.y = 0;
		_candy.acceleration.y = 0;
	}
	
	private function controls():Void
	{
		#if !mobile
		if (FlxG.keys.justPressed.ENTER)
		{
			openSubState(new PauseSubState(0xAA000000));
		}
		#end
		
		if (_player.right && !_player.poking)
		{
			_player.setPosition(FlxG.width * 0.6, _playerY);
			_player._left = false;
		}
		if (_player.left && !_player.poking)
		{
			_player.setPosition(FlxG.width * 0.15, _playerY);
			_player._left = true;
		}
		
		if (_player.poking && !_player._pickingUpMom)
		{
			//converted to rads
			var smackPower:Float = FlxAngle.asRadians(_player.smackPower) * _player.punchMultiplier;
			//converted to rads
			var pushMultiplier:Float = FlxAngle.asRadians(_player.smackPower) * _player.punchMultiplier;
			if (_player.poked)
			{
				sfxHit();
				if (_player._left)
				{
					_mom.body.angularVel += smackPower;
				}
				else
				{
					_mom.body.angularVel -= smackPower;
				}
				
				if (!_mom._fallenDown)
				{
					_mom._distanceX += FlxG.random.float(0, 5);
					_mom._speedMultiplier += FlxG.random.float(0, 0.01);
					_player.punchMultiplier += FlxG.random.float(0, 0.025);
				}
				
				_mom.swapRotating();
				
			}
			if (_player._left)
			{
				_player.setPosition(_player.curPostition.x + FlxG.width * 0.1, _playerY);
				_mom.body.angularVel += pushMultiplier;
			}
			else
			{
				_player.setPosition(_player.curPostition.x - FlxG.width * 0.1, _playerY);
				_mom.body.angularVel -= pushMultiplier;
			}
		}
		else
		{
			if (_player._left)
			{
				_player.setPosition(FlxG.width * 0.025, _playerY);
				_player.curPostition = _player.getPosition();
			}
			else
			{
				_player.setPosition(FlxG.width * 0.65, _playerY);
			}
			
			_player.curPostition = _player.getPosition();
			_player.animation.play("idle");
		}
		
		if (_player.punched)
		{
			
			if (_player._left)
			{
				_player.setPosition(_player.x + 70, _playerY - 100);
				_playerPunchHitBox.setPosition(_player.x + 175, _player.y + 25);
			}
			else
			{
				_player.setPosition(_player.x - 70, _playerY - 100);
				_playerPunchHitBox.setPosition(_player.x + 75, _player.y + 25);
			}
			punch();
		}
		
		
		
		
		if (_player.punching)
		{
			_player.animation.play("punch");
		}
		if (!_player.punching)
		{
			_player.y = _playerY;
			_playerPunchHitBox.active = false;
		}
		
		/*
		if (_player.ducked)
		{
			
		}
		*/
		if (_player.ducking)
		{
			_player.animation.play("ducking", true);
			_player.y = _playerY + 50;
		}
		
		#if !mobile
		if (FlxG.keys.justPressed.ANY && _mom._fallenDown && !_player._pickingUpMom)
		{
			_player._pickingUpMom = true;
			_player.visible = false;
			
			if (_mom._fallenLeft)
			{
				_playerAnims.pickingUp.facing = FlxObject.RIGHT;
				_playerAnims.x = 100;
			}
			
			else
			{
				_playerAnims.pickingUp.facing = FlxObject.LEFT;
				_playerAnims.x = 600;
			}
			
			_playerAnims.updateCurSprite(_playerAnims.pickingUp, null, 260);
		}
		#end
		
		if (_player._pickingUpMom && _player.poked)
		{
			sfxHit();
			
			_pickupMom += 1;
			FlxG.camera.shake(0.02, 0.02);
		}
		
		if (_player._left)
		{
			_player.facing = FlxObject.LEFT;
		}
		else
		{
			_player.facing = FlxObject.RIGHT;
		}
		
	}
	
	private function punch():Void
	{
		_playerPunchHitBox.active = true;
		
		if (FlxG.overlap(_cat, _playerPunchHitBox))
		{
			_cat._punched = true;
			if (_cat._timesPunched >= 1)
			{
				_cat.fly(-_cat.body.velocity.x, FlxG.random.float( -400, -450));
			}
			else
			{
				_cat.fly(_cat.body.velocity.x, -400);
			}
			
			if (_cat._timesPunched == 5)
			{
				_candy.revive();
				
				_candy.setPosition(_cat.x, _cat.y - (_candy.height * 1.5));
				_candy.velocity.y -= 250;
				_candy.acceleration.y = 600;
			}
			
			_cat._timesPunched += 1;
			
			sfxHit();
			_cat.smackedSound();
		}
	}
	
	
	private function sfxHit():Void
	{
		if (_timer >= 30)
		{
			FlxG.sound.play("assets/sounds/smack" + FlxG.random.int(1, 3) + ".mp3", 0.7);
		}
		else
		{
			FlxG.sound.play("assets/sounds/hyper" + FlxG.random.int(1, 5) + ".mp3", 0.8);
		}
	}
	
	
}