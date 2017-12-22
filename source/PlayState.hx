package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.nape.FlxNapeSpace;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import nape.geom.Vec2;
import openfl.Assets;

class PlayState extends FlxState
{
	
	//MOM SHIT
	private var _mom:Mom;
	private var _distanceBar:FlxSprite;
	private var _momIcon:FlxSprite;
	private var _pickupMom:Float = 0;
	private var _pickupMomNeeded:Float = 15;
	private var _momCatOverlap:Bool = false;
	private var _pickupTimeBuffer:Float = 0;
	
	//KID SHIT
	private var _player:Player;
	private var _playerPunchHitBox:FlxObject;
	private var _playerY:Float = 200;
	private var _playerTrail:FlxTrailArea;
	private var punchMultiplier:Float = 1;
	
	private var _playerAnims:PlayerAnims;
	
	//Cnady Stuff
	private var _candy:Candy;
	private var _candyMode:Bool = false;
	private var _candyTimer:Float = 0.6;
	private var _candyBoost:Float = 0;
	
	//OBSTACLE SHIT
	private var _retard:Retard;
	private var _moped:MopedBoy;
	private var _mopedWarning:Warning;
	private var _mopedTimer:Float = 1;
	
	//CAT SHIT
	private var _cat:Cat;
	private var _catLeft:Bool = false;
	
	//BACKGROUND
	private var _BG:FlxSprite;
	
	//HUD SHIT
	private var _pointsText:FlxText;
	private var _highScoreText:FlxText;
	
	private var _timer:Float = 180;
	private var _timerText:FlxText;
	
	private var _timerCat:Float = 10;
	private var _catActive:Bool = false;
	
	private var _distanceGoal:Float = 6000;
	private var _distaceGoalText:FlxText;
	
	
	private var boostText:FlxText;
	
	//Recording/Replaying
	private static var recording:Bool = false;
	private static var replaying:Bool = false;
	
	//public var pitchedSound:SoundPitch = new SoundPitch();
	

	override public function create():Void
	{
		FlxG.sound.playMusic("assets/music/Music/Main Theme.mp3", 1);
		/*
		pitchedSound.MP3Pitch("https://audio.ngfiles.com/778000/778677_Alice-Mako-IM-SORRY.mp3");
		add(pitchedSound);
		pitchedSound.set_rate(0.1);
		*/
		
		
		FlxG.mouse.visible = false;
		FlxNapeSpace.init();
		
		//BG
		_BG = new FlxSprite(0, 0);
		_BG.loadGraphic(AssetPaths.houseBG__png, false, 5500, 540);
		_BG.setGraphicSize(0, FlxG.height);
		_BG.updateHitbox();
		add(_BG);
		
		
		//MAIN STUFF EHEHEH
		
		_playerAnims = new PlayerAnims(-90, -32);
		add(_playerAnims);
		
		_mom = new Mom(530, -25 + 1000);
		add(_mom);
		
		_cat = new Cat(0 - 200, FlxG.height + 10);
		add(_cat);
		
		spawnCat();
		
		_candy = new Candy(-32);
		add(_candy);
		
		_player = new Player(50, _playerY);
		add(_player);
		
		
		
		//OBSTACLES AND WHATNOT
		_moped = new MopedBoy(FlxG.width, 200);
		add(_moped);
		_mopedTimer = FlxG.random.float(10, 20);
		
		_mopedWarning = new Warning(FlxG.width, 40);
		add(_mopedWarning);
		
		//_retard = new Retard(0, 300);
		//add(_retard);
		
		//Trail effect
		_playerTrail = new FlxTrailArea(0, 0, FlxG.width, FlxG.height, 0.75);
		_playerTrail.add(_player);
		add(_playerTrail);
		
		_playerPunchHitBox = new FlxObject(_player.x + 60, _player.y, 75, 75);
		add(_playerPunchHitBox);
		
		createHUD();
		
		FlxNapeSpace.space.gravity.setxy(0, 0);
		
		//FlxG.camera.follow(_mom);
		FlxG.camera.maxScrollY = FlxG.height;
		FlxG.camera.minScrollY = 0;
		FlxG.camera.bgColor = 0xFF222222;
		
		super.create();
	}
	
	private function createHUD():Void
	{
		_timerText = new FlxText(10, FlxG.height - 35, 0, Std.string(Math.ffloor(_timer)), 20);
		add(_timerText);
		
		_distanceBar = new FlxSprite(175, 6);
		_distanceBar.loadGraphic("assets/images/Distance Bar.png", false, 1387, 56);
		_distanceBar.setGraphicSize(Std.int(_distanceBar.width / 2));
		_distanceBar.updateHitbox();
		add(_distanceBar);
		
		_momIcon = new FlxSprite(0, 3);
		_momIcon.loadGraphic("assets/images/momshit/Mom Icon0001.png", false, 44, 100);
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
		
		Points.curPoints = 0;
		Points.curTime = 0;
		
		
		_distanceBar.scrollFactor.x = 0;
		_timerText.scrollFactor.x = 0;
	}
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_BG.x = -FlxMath.remapToRange(_mom._distanceX, 0, _distanceGoal, 0, _BG.width - FlxG.width);
		
		FlxG.sound.music.volume = Global.musicVolume;
		
		FlxG.camera.antialiasing = Global.antiAliasing;
		
		Global.paused = false;
		
		boostText.visible = _mom.boosting;
		
		if (_mom.boosting)
		{
			boostText.text = "Close Call Bonus: " + FlxMath.roundDecimal(_mom.boostBonus, 2);
		}
		
		if (!_player._pickingUpMom)
		{
			_playerAnims.facing = _player.facing;
		}
		/*
		if (_player.justSwitched)
		{
			_playerAnims.updateCurSprite(_playerAnims.sideSwitch);
		}
		*/
		sceneSwitch();
		updateHUD();	
		catManagement();
		controls();
		mopedCheck();
		
		watching();
		
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
		
		if (_pickupTimeBuffer >= 0.25 * FlxG.timeScale)
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
	
	private function updateHUD():Void
	{
		_momIcon.x = FlxMath.remapToRange(_mom._distanceX,  0, _distanceGoal, _distanceBar.x + 10, _distanceBar.x + _distanceBar.width - _momIcon.width - 10);
		
		
		_timer -= FlxG.elapsed;
		_timerText.text = "seconds " + Math.ffloor(_timer);
		
		
		Points.curTime += FlxG.elapsed * 100 * FlxG.timeScale;
		
		_pointsText.text = "Current Time: " + Math.floor(Points.curTime);
		_highScoreText.text = "Highscore: " + Points.highScoreTime;
		
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
			_timerCat -= FlxG.elapsed;
			_momCatOverlap = false;
		}
		
		if (_timerCat <= 0)
		{
			_timerCat = FlxG.random.float(8, 15);
			spawnCat();
		}
		
		if (_catActive)
		{
			if (_cat.animation.frameIndex == 31)
			{
				if (_catLeft)
				{
					_cat.fly(400, -400);
				}
				else
				{
					_cat.fly( -400, -400);
				}
				_catActive = false;
			}
			
		}
	}
	
	
	private function controls():Void
	{
		
		debugControls();
		
		_distaceGoalText.text = "Distance \nneeded: " + _distanceGoal;
		
		#if (web || desktop)
		
		if (FlxG.keys.justPressed.ENTER)
		{
			openSubState(new PauseSubState(0xAA000000));
		}
		
		
		if (_player.right && !_player.poking)
		{
			_player.setPosition(_mom.x + 700, _playerY);
			_player._left = false;
		}
		if (_player.left && !_player.poking)
		{
			_player.setPosition(_mom.x - 100, _playerY);
			_player._left = true;
		}
		
		if (_player.poking && !_player._pickingUpMom)
		{
			//converted to rads
			var smackPower:Float = (40 * Math.PI / 180) * punchMultiplier;
			//converted to rads
			var pushMultiplier:Float = (3.5 * Math.PI / 180) * punchMultiplier;
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
					punchMultiplier += FlxG.random.float(0, 0.025);
				}
				
			}
			if (_player._left)
			{
				_player.setPosition(_mom.x, _playerY);
				_mom.body.angularVel += pushMultiplier;
			}
			else
			{
				_player.setPosition(_mom.x + 400, _playerY);
				_mom.body.angularVel -= pushMultiplier;
			}
		}
		else
		{
			if (_player._left)
			{
				_player.setPosition(_mom.x - 100, _playerY);
			}
			else
			{
				_player.setPosition(_mom.x + 500, _playerY);
			}
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
		
		
		if (_player._pickingUpMom && _player.poked)
		{
			sfxHit();
			
			_pickupMom += 1;
			FlxG.camera.shake(0.02, 0.02);
		}
		
		#end
		#if (html5 || mobile)
		mobileControls();
		#else
		//mouseControls();
		#end
		
		if (_player._left)
		{
			_player.facing = FlxObject.LEFT;
		}
		else
		{
			_player.facing = FlxObject.RIGHT;
		}
		
	}
	
	private function resetMultipliers():Void
	{
		_mom._speedMultiplier = 1;
		punchMultiplier = 1;
		
		_playerAnims.visible = false;
		_player.visible = true;
	}
	
	private function watching():Void
	{
		FlxG.watch.addQuick("mompos", _mom.getPosition());
		FlxG.watch.addQuick("Mom speed multiplier", _mom._speedMultiplier);
	}
	
	private function debugControls():Void
	{
		if (!recording && !replaying)
		{
			startRecording();
		}
		
		if (FlxG.keys.justPressed.R && recording)
		{
			loadReplay();
		}
		
		if (FlxG.keys.justPressed.E)
		{
			spawnMoped();
		}
		
		if ((FlxG.keys.justPressed.V && !_candyMode) || FlxG.overlap(_candy, _player))
		{
			FlxG.camera.color = 0xFFFEFEFE;
			FlxTween.tween(FlxG.camera, {color:FlxColor.WHITE}, _candyTimer);
			FlxG.sound.play("assets/sounds/Candy Mode.mp3", 0.7);
			
			_candyMode = true;
			FlxG.camera.flash(FlxColor.WHITE, 0.075);
			_candy.x = -32;
			_candy.velocity.y = 0;
			_candy.acceleration.y = 0;
		}
		
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
		
		_playerTrail.visible = _candyMode;
		/* changes distance goal thingie you know
		if (FlxG.keys.pressed.W)
		{
			_distanceGoal += 10;
		}
		if (FlxG.keys.pressed.S)
		{
			_distanceGoal -= 10;
		}
		*/
		
		if (FlxG.keys.justPressed.C)
		{
			spawnCat();
		}
		
		if (FlxG.keys.justPressed.L)
		{
			_timer = 35;
			FlxG.sound.music.stop();
			FlxG.sound.play("assets/sounds/speedUp.mp3", 1, false, null, true, function(){FlxG.sound.playMusic("assets/music/Music/HYPER Theme.mp3");});
			
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
			
			if (FlxG.random.bool(15) && _cat._timesPunched >= 6)
			{
				_candy.setPosition(_cat.x, _cat.y);
				_candy.velocity.y -= 250;
				_candy.acceleration.y = 600;
			}
			
			_cat._timesPunched += 1;
			
			sfxHit();
			_cat.smackedSound();
		}
	}
	
	private function spawnCat():Void
	{
		FlxG.log.add("Cat spawned");
		_cat._punched = false;
		_catLeft = FlxG.random.bool();
		_cat.y = 140 + 200;
		_cat.body.position.y = _cat.y;
		_cat.acceleration.y = 0;
		_cat.flying = false;
		_cat.body.rotation = 0;
		_cat.body.velocity.y = _cat.body.velocity.x = 0;
		_cat.velocity.x = _cat.velocity.y = 0;
		_cat.angularVelocity = 0;
		_cat.angle = 0;
		
		
		if (_catLeft)
		{
			_cat.facing = FlxObject.RIGHT;
			_cat.x = 35 + _cat.width * 2;
			_cat.body.position.x = _cat.x;
			
		}
		else
		{
			_cat.facing = FlxObject.LEFT;
			_cat.x = FlxG.width + _cat.width * 2;
			_cat.body.position.x = _cat.x;
		}
		_cat.animation.play("peek");
		_catActive = true;
	}
	
	
	private var justSpawnedMoped:Bool = false;
	private var mopedLeft:Bool = false;
	private var mopedCollision:Bool = false;
	
	//runs every frame
	private function mopedCheck():Void
	{
		if (_mopedTimer > 0)
		{
			_mopedTimer -= FlxG.elapsed;
		}
		else
		{
			spawnMoped();
		}
		
		if (justSpawnedMoped && _mopedWarning.animation.curAnim.finished)
		{
			var mopedSpeed:Float = FlxG.random.float(2000, 3000);
			
			
			
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
			
			FlxG.sound.play("assets/sounds/hit_by_vehicle.mp3", 0.7);
			
			_playerAnims.hitByVehicle.animation.curAnim.restart();
			_playerAnims.updateCurSprite(_playerAnims.hitByVehicle, _playerAnims.x, -32);
			_player.visible = false;
			
			_player.disable(0.7);
			FlxG.camera.shake(0.02, 0.25, null, true, FlxAxes.X);
		}
	}
	
	//runs only when called
	private function spawnMoped():Void
	{
		_mopedWarning.revive();
		_moped.velocity.x = 0;
		mopedLeft = _player._left;
		mopedCollision = false;
		_mopedWarning.x = _player.x + 100;
		_mopedTimer = FlxG.random.float(10, 20);
		_mopedWarning.animation.curAnim.restart();
		
		FlxG.sound.play("assets/sounds/MotorBike.wav", 0.7);
		
		justSpawnedMoped = true;
	}
	
	
	private function mobileControls():Void
	{
		for (touch in FlxG.touches.list)
		{
			if (touch.screenX >= FlxG.width / 2)
			{
				_player._left = false;
				
				if (touch.justPressed) 
				{
					_player.setPosition(_mom.x + 150, _playerY);
					
					sfxHit();
				}
			}
			else
			{
				_player._left = true;
				
				if (touch.justPressed) 
				{
					_player.setPosition(_mom.x - 50, _playerY);
					sfxHit();
				}
				
			}
			if (touch.justReleased) 
			{
				if (!_player._left)
				{
					_player.setPosition(_mom.x + 250, _playerY);
				}
				else
				{
					_player.setPosition(_mom.x - 150, _playerY);
				}
			}
		}
	}
	
	private function mouseControls():Void
	{
		if (FlxG.mouse.screenX >= FlxG.width/2)
			{
				_player._left = false;
					
				if (FlxG.mouse.justPressed) 
				{
					_player.setPosition(_mom.x + 150, _playerY);
					sfxHit();
				}
			}
			else
			{
				_player._left = true;
				
				if (FlxG.mouse.justPressed) 
				{
					_player.setPosition(_mom.x - 50, _playerY);
					sfxHit();
				}
			}
			if (FlxG.mouse.justReleased) 
			{
				if (!_player._left)
				{
					_player.setPosition(_mom.x + 250, _playerY);
				}
				else
				{
					_player.setPosition(_mom.x - 150, _playerY);
				}
			}
	}
	
	private function sfxHit():Void
	{
		if (_timer >= 30)
		{
			FlxG.sound.play("assets/sounds/smack " + FlxG.random.int(1, 3) + ".mp3", 0.7);
		}
		else
		{
			FlxG.sound.play("assets/sounds/hyper (" + FlxG.random.int(1, 5) + ").mp3", 0.8);
		}
	}
	
	override public function onFocusLost():Void 
	{
		super.onFocusLost();
		
		openSubState(new PauseSubState(0xAA000000));
		
	}
	
	private function startRecording():Void
	{
		recording = true;
		replaying = false;
		
		FlxG.vcr.startRecording(false);
	}
	
	private function loadReplay():Void
	{
		replaying = true;
		recording = false;
		
		
		var save:String = FlxG.vcr.stopRecording(false);
		FlxG.vcr.loadReplay(save, new PlayState(), ["ANY"], 0, startRecording);
		
	}
	
	
	private function sceneSwitch():Void
	{
		if (_timer <= 0 || _mom._timesFell >= 5)
		{
			FlxG.switchState(new GameOverState());
		}
		
		if (_mom._distanceX >= _distanceGoal || FlxG.keys.justPressed.F)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function(){FlxG.switchState(new AnvilState());});
			
		}
	}
	
	
}