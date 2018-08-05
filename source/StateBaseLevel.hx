package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.nape.FlxNapeSpace;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 * 
 * Where all the magic happens
 */
 
class StateBaseLevel extends FlxState 
{
	//bg shit
	public var _skyBG:FlxSprite;
	
	public var _grpBackgrounds:FlxSpriteGroup;
	
	//basically the Y position that controls the background elements
	public var curY:FlxObject;
	public var flying:Bool = false;
	public var txtSpinning:FlxText;
	
	//MOM SHIT
	public var _mom:Mom;
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
	
	//Candy Stuff
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
	private var _asteroid:Asteroid;
	private var _asteroidWarning:WarningAsteroid;
	private var _asteroidJustHit:Bool = false;
	
	//HUD STUFF AND WHATNOT
	private var _timerText:FlxText;
	private var _timer:Float = 180;
	private var _distanceBar:FlxSprite;
	private var _momIcon:FlxSprite;
	
	private var _pointsText:FlxText;
	private var _highScoreText:FlxText;
	private var _distanceGoal:Float = 0;
	private var _distaceGoalText:FlxText;
	
	//text that shows when leaning too far??
	private var boostText:FlxText;

	override public function create():Void 
	{
		//FlxG.mouse.visible = false;
		FlxNapeSpace.init();
		
		FlxNapeSpace.space.gravity.setxy(10, 0);
		
		FlxG.camera.maxScrollY = FlxG.height;
		FlxG.camera.minScrollY = 0;
		
		FlxG.camera.bgColor = 0xFF222222;
		
		curY = new FlxObject(0, 0, 1, 1);
		add(curY);
		
		_grpBackgrounds = new FlxSpriteGroup();
		add(_grpBackgrounds);
		
		_skyBG = new FlxSprite(-50);
		_skyBG.scrollFactor.x = 0;
		//_skyBG.visible = false;
		
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
		
		_mopedWarning = new Warning(FlxG.width, 40);
		add(_mopedWarning);
		
		_asteroidWarning = new WarningAsteroid(FlxG.width, -60);
		add(_asteroidWarning);
		
		_asteroid = new Asteroid(0, 0);
		_asteroid.kill();
		_asteroid.timer = FlxG.random.float(50, 100);
		add(_asteroid);
		
		//_retard = new Retard(0, 300);
		//add(_retard);
		
		//Trail effect
		_playerTrail = new FlxTrailArea(0, 0, FlxG.width, FlxG.height, 0.75);
		_playerTrail.add(_player);
		add(_playerTrail);
		
		_playerPunchHitBox = new FlxObject(_player.x + 60, _player.y, 75, 75);
		add(_playerPunchHitBox);
		
		FlxG.debugger.addTrackerProfile(new TrackerProfile(Mom, ["angleAcceleration", "angleDrag", "timeSwapMin", "timeSwapMax"], []));
		FlxG.debugger.track(_mom, "Mom");
		
		FlxG.debugger.addTrackerProfile(new TrackerProfile(Player, ["punchMultiplier", "smackPower", "pushMultiplier"], []));
		FlxG.debugger.track(_player, "Player");
		
	}
	
	/**
	 * Gets called in the create state of the OTHER states, like OutsideState, Playstate, rather than in this state.
	 */
	private function createHUD():Void
	{
		_timerText = new FlxText(10, FlxG.height - 35, 0, Std.string(Math.ffloor(_timer)), 20);
		add(_timerText);
		
		_distanceBar = new FlxSprite(175, 6);
		_distanceBar.loadGraphic(AssetPaths.DistanceBar__png, false, 1387, 56);
		_distanceBar.setGraphicSize(Std.int(_distanceBar.width / 2));
		_distanceBar.updateHitbox();
		add(_distanceBar);
		
		_momIcon = new FlxSprite(0, 3);
		_momIcon.loadGraphic(AssetPaths.MomIcon0001__png, false, 44, 100);
		_momIcon.setGraphicSize(Std.int(_momIcon.width / 2));
		_momIcon.updateHitbox();
		add(_momIcon);
		
		_momIcon.x = _distanceBar.x + _momIcon.width;
		
		_distaceGoalText = new FlxText(25, 15, 0, "", 20);
		add(_distaceGoalText);
		
		
		_pointsText = new FlxText(0, 30, 0, "Current Time: " + Math.floor(Points.curTime), 20);
		_pointsText.screenCenter(X);
		_pointsText.scrollFactor.x = 0;
		//add(_pointsText);
		
		_highScoreText = new FlxText(0, 52, 0, "Highscore: " + Points.highScoreTime, 20);
		_highScoreText.screenCenter(X);
		_highScoreText.scrollFactor.x = 0;
		//add(_highScoreText);
		
		boostText = new FlxText(0, 50);
		boostText.size = 20;
		boostText.screenCenter(X);
		add(boostText);
		
		_grpCandyDisplay = new FlxTypedGroup<Candy>();
		add(_grpCandyDisplay);
		
		Points.curPoints = 0;
		Points.curTime = 0;
		
		
		_distanceBar.scrollFactor.x = 0;
		_timerText.scrollFactor.x = 0;
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (_mom.body == null)
		{
			_mom.body.space = FlxNapeSpace.space;
		}
		
		controls();
		catManagement();
		updateHUD();	
		mopedCheck();
		pickupHandle();
		candyHandle();
		
		boostText.visible = _mom.boosting || _mom.flying;
		
		_grpBackgrounds.y = curY.y;
		_mom.flying = flying;
		_player.flying = flying;
		
		
		if (FlxG.keys.justPressed.Y)
		{
			asteroidHit();
		}
		
		if (!_player._pickingUpMom)
		{
			_playerAnims.facing = _player.facing;
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
		if (_mom.flying)
		{
			boostText.text = "Spin Multiplier: " + FlxMath.roundDecimal(_mom.flyBoost, 2);
		}
	}
	
	private function updateHUD():Void
	{
		_momIcon.x = FlxMath.remapToRange(_mom._distanceX,  0, _distanceGoal, _distanceBar.x + 10, _distanceBar.x + _distanceBar.width - _momIcon.width - 10);
		
		_timer -= FlxG.elapsed;
		
		var timMin:Float = _timer / 60;
		var timSec:Float = _timer % 60;
		
		
		_timerText.text = Std.int(timMin) + ":" + Std.int(timSec);
		
		/*
		
		_winText.text += "\nYou killed mom in ";
		_winText.text += Std.int(winMin) + ":" + Std.int(winSec) + "!!";
		*/
		
		_pointsText.text = "Current Time: " + Math.floor(Points.curTime);
		_highScoreText.text = "Highscore: " + Points.highScoreTime;
		
	}
	
	private function activateCandy():Void
	{
		FlxG.camera.color = 0xFFFEFEFE;
		_player.clearStatus();
		FlxTween.tween(FlxG.camera, {color:FlxColor.WHITE}, _candyTimer);
		#if flash
		FlxG.sound.play("assets/sounds/CandyMode.mp3", 0.7);
		#end
		
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
			openSubState(new SubStatePause(0xAA000000, this));
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
			
			if (flying)
			{
				pushMultiplier = 0;
				smackPower *= 15;
			}
			
			if (_player.poked)
			{
				FlxG.camera.shake(0.005, 0.1);
				//If flying then pokes are stronger than holding
				
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
			if (!flying)
			{
				_player.animation.play("idle");
			}
			else
			{
				_player.animation.play("flying");
			}
			
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
		
		if (_player._pickingUpMom && _player.spamP)
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
	
	
	private function catManagement():Void
	{
		if (FlxG.overlap(_cat, _mom) && !_cat._punched && !_momCatOverlap)
		{
			//_mom.body.angularVel += _cat.velocity.x * FlxG.random.float(0.001, 0.025);
			sfxHit();
			_momCatOverlap = true;
		}
		
		if (_cat.y >= FlxG.height)
		{
			_cat.timer -= FlxG.elapsed;
			_momCatOverlap = false;
		}
		
		if (_cat.timer <= 0)
		{
			_cat.timer = FlxG.random.float(8, 15);
			spawnCat();
		}
		
		if (_cat.peeking)
		{
			if (_cat.animation.frameIndex == 30)
			{
				if (_cat.goingRight)
				{
					_cat.fly(400, -400);
				}
				else
				{
					_cat.fly( -400, -400);
				}
				_cat.peeking = false;
			}
		}
	}
	
	
	private function spawnCat():Void
	{
		FlxG.log.add("Cat spawned");
		_cat._punched = false;
		_cat.resetCat();
		_cat.y = 140 + 200;
		_cat.body.position.y = _cat.y;
		
		if (_cat.goingRight)
		{
			_cat.facing = FlxObject.RIGHT;
			_cat.x = 35 + _cat.width * 2;
			_cat.body.position.x = _cat.x;
			
		}
		else
		{
			_cat.facing = FlxObject.LEFT;
			_cat.x = FlxG.width + _cat.width * 2;
			_cat.body.position.x =_cat.x;
		}
		
		_cat.peeking = true;
		_cat.animation.play("peek");
		
	}
	
	private var justSpawnedAsteroid:Bool = false;
	
	/**
	 * currently called in mopedCheck() !!!! CHANGE THIS EVENTUALLY
	 */
	private function asteroidCheck():Void
	{
		
		if (FlxG.keys.justPressed.Q)
		{
			spawnObstacle(ObstacleBase.ASTEROID);
		}
		
		if (_asteroid.timer > 0)
		{
			_asteroid.timer -= FlxG.elapsed;
			
			if (!_asteroid.isOnScreen())
			{
				_asteroid.kill();
			}
		}
		else
		{
			spawnObstacle(ObstacleBase.ASTEROID);	
		}
		
		if (justSpawnedAsteroid && _asteroidWarning.animation.curAnim.finished)
		{
			_asteroid.revive();
			
			
			if (_asteroid.left)
			{
				_asteroid.x = 20;
			}
			else
			{
				_asteroid.x = FlxG.width * 0.6;
			}
			
			justSpawnedAsteroid = false;
		}
		
		if (FlxG.overlap(_asteroid, _player) && !_asteroidJustHit)
		{
			//_player.disable(FlxG.random.float(6, 15), 1);
			asteroidHit();
		}
		
	}
	
	
	private var justSpawnedMoped:Bool = false;
	private var mopedLeft:Bool = false;
	private var mopedCollision:Bool = false;
	
	//runs every frame
	private function mopedCheck():Void
	{
		//MOVE THIS EVENTUALLY!!!!!!
		asteroidCheck();
		
		if (_moped.timer > 0)
		{
			_moped.timer -= FlxG.elapsed;
			
			if (!_moped.isOnScreen())
			{
				_moped.kill();
			}
		}
		else
		{
			spawnObstacle(ObstacleBase.BIKE);
		}
		
		
		if (justSpawnedMoped && _mopedWarning.animation.curAnim.finished)
		{
			var mopedSpeed:Float = FlxG.random.float(2000, 3000);
			
			_moped.revive();
			
			if (mopedLeft)
			{
				_moped.x = FlxG.width;
				_moped.velocity.x = -mopedSpeed;
				_moped.facing = FlxObject.LEFT;
			}
			else
			{
				_moped.x = -_moped.width;
				_moped.velocity.x = mopedSpeed;
				_moped.facing = FlxObject.RIGHT;
			}
			justSpawnedMoped = false;
		}
		
		if (mopedCollision && _playerAnims.hitByVehicle.animation.curAnim.finished)
		{
			_playerAnims.visible = false;
			_player.visible = true;
			
			mopedCollision = false;
		}
		
		
		if (mopedLeft == _player._left && FlxG.overlap(_player, _moped) && !mopedCollision && !_player._pickingUpMom)
		{
			mopedCollision = true;
			
			if (_player._left)
			{
				_playerAnims.x = -90;
			}
			else
			{
				_playerAnims.x = 497;
			}
			
			#if flash
			FlxG.sound.play("assets/sounds/hit_by_vehicle.mp3", 0.7);
			#end
			
			_playerAnims.hitByVehicle.animation.curAnim.restart();
			_playerAnims.updateCurSprite(_playerAnims.hitByVehicle, _playerAnims.x, -32);
			_player.visible = false;
			
			_player.disable(0.7);
			FlxG.camera.shake(0.02, 0.25, null, true, FlxAxes.X);
		}
	}
	
	/**
	 * A handler for spawnin shit
	 * @param	type
	 * TYPES:
	 * -From ObstacleBase class-
	 * 0 == Bike
	 * 1 == Asteroid
	 */
	private function spawnObstacle(type:Int = 0):Void
	{
		var obType = type;
		
		switch (obType) 
		{
			case ObstacleBase.BIKE:
				_mopedWarning.revive();
				_moped.velocity.x = 0;
				mopedLeft = _player._left;
				mopedCollision = false;
				_mopedWarning.x = _player.x + 100;
				_moped.timer = FlxG.random.float(10, 20);
				_mopedWarning.animation.curAnim.restart();
				
				FlxG.sound.play("assets/sounds/MotorBike.wav", 0.7);
				
				justSpawnedMoped = true;
			case ObstacleBase.ASTEROID:
				spawnAsteroid();
			default:
				
		}
	}
	
	private function spawnAsteroid():Void
	{
		_asteroidWarning.revive();
		_asteroidWarning.animation.curAnim.restart();
		_asteroidWarning.x = _player.x + 80;
		_asteroid.animation.curAnim.restart();
		_asteroid.y = 0 - _asteroid.height;
		_asteroid.velocity.y = 6000;
		_asteroid.left = _player._left;
		_asteroid.timer = FlxG.random.float( 50, 100);
		
		justSpawnedAsteroid = true;
	}
	
	private function asteroidHit():Void
	{
		flying = true;
		_asteroidJustHit = true;
		_mom.offset.y -= 200;
		_player.offset.y += 200;
		FlxTween.tween(curY, {y: 1460}, 2.8, {ease: FlxEase.quartOut})
		.then(FlxTween.tween(curY, {y: 0}, 1.7, {ease:FlxEase.quartIn, onComplete: asteroidLand}));
	}
	
	private function asteroidLand(tween:FlxTween):Void
	{
		_mom.body.rotation -= FlxAngle.asRadians(360 * (Math.round(_mom.flyBoost) - 1));
		
		_mom.boostBonus += _mom.flyBoost * FlxG.random.int(7, 14);
		
		if (_mom.boostBonus < 0)
		{
			_mom.boostBonus = -_mom.boostBonus;
		}
		
		_mom.flyBoost = 0;
		flying = false;
		_asteroidJustHit = false;
		_mom.offset.y += 200;
		_player.offset.y -= 200;
	}
	
	private function candyHandle():Void
	{
		if (_candyMode)
		{
			FlxG.timeScale = 0.1;
			
			if (_player.poked)
			{
				_candyBoost += FlxG.random.float(0.5, 3);
			}
			
			_candyTimer -= FlxG.elapsed;
			
			if (_candyTimer <= 0)
			{
				FlxTween.tween(FlxG, {timeScale: 1}, 0.4);
				_candyMode = false;
				_candyTimer = FlxG.random.float(3, 7) * 0.1;
				FlxG.camera.flash(FlxColor.WHITE, 0.075);
				_mom.body.angularVel = _mom.body.angularVel * 0.1;
			}
			
		}
		else
		{
			//FlxG.timeScale = 1;
			if (_candyBoost > 0 && !_mom._fallenDown)
			{
				_mom._distanceX += _candyBoost * 0.065;
				_candyBoost -= 0.8;
			}
			else 
			{
				_candyBoost = 0;
			}
			
		}
		
		if (FlxG.overlap(_candy, _player))
		{
			_candy.kill();
			
			var candyDisplay:Candy;
			candyDisplay = new Candy((48 * _grpCandyDisplay.length) + 30, (FlxG.height - _candy.height) - 30);
			_grpCandyDisplay.add(candyDisplay);
			
			_candyAmount += 1;
		}
		
		_playerTrail.visible = _candyMode;
	}
	
	private function pickupHandle():Void
	{
		
		if (_player._pickingUpMom)
		{
			if (_pickupMom >= _pickupMomNeeded)
			{
				_mom._fallenDown = false;
				_mom.angle = 0;
				_mom.angularAcceleration = 0;
				_mom.body.angularVel = 0;
				_mom.body.rotation = 0;
				_pickupMom = 0;
				
				resetMultipliers();
				
			}
			else
			{
				_player.x = _mom.x;
			}
			
			if (!_mom._fallenDown)
			{
				_pickupTimeBuffer += FlxG.elapsed;
			}
		}
		
		if (_pickupTimeBuffer >= 0.20 * FlxG.timeScale)
		{
			_player._pickingUpMom = false;
			_pickupTimeBuffer = 0;
			
			_playerAnims.visible = false;
			_playerAnims.visible = false;
			_player.visible = true;
			
			if (_player._left)
			{
				_player.setPosition(_mom.x - 100, _playerY);
			}
			else
			{
				_player.setPosition(_mom.x + 600, _playerY);
			}
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
		#if flash
		
		if (_timer >= 30)
		{
			FlxG.sound.play("assets/sounds/smack" + FlxG.random.int(1, 3) + ".mp3", 0.7);
		}
		else
		{
			FlxG.sound.play("assets/sounds/hyper" + FlxG.random.int(1, 5) + ".mp3", 0.8);
		}
		
		#end
	}
	
	private function resetMultipliers():Void
	{
		_mom._speedMultiplier = 1;
		_player.punchMultiplier = 1;
		
		_playerAnims.visible = false;
		_player.visible = true;
	}
	
	private function candyGroupMove(c:Candy):Void
	{
		c.x -= 48;
	}
}