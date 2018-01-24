package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.nape.FlxNapeSpace;
import flixel.math.FlxAngle;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxHorizontalAlign;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import nape.geom.Vec2;
import openfl.Assets;

class PlayState extends BaseState
{
	
	//MOM STUFF
	private var _distanceBar:FlxSprite;
	private var _momIcon:FlxSprite;
	
	//BACKGROUND
	private var _BG:FlxSprite;
	
	//HUD SHIT
	private var _pointsText:FlxText;
	private var _highScoreText:FlxText;
	
	
	private var _timerText:FlxText;
	
	private var _timerCat:Float = 10;
	private var _catActive:Bool = false;
	
	private var _distanceGoal:Float = 6000;
	private var _distaceGoalText:FlxText;
	
	//Recording/Replaying
	private static var recording:Bool = false;
	private static var replaying:Bool = false;
	
	
	
	//public var pitchedSound:SoundPitch = new SoundPitch();
	

	override public function create():Void
	{
		super.create();
		
		FlxG.sound.playMusic("assets/music/MainTheme.mp3", 1);
		/*
		pitchedSound.MP3Pitch("https://audio.ngfiles.com/778000/778677_Alice-Mako-IM-SORRY.mp3");
		add(pitchedSound);
		pitchedSound.set_rate(0.1);
		*/
		
		//BG
		_BG = new FlxSprite(0, 0);
		_BG.loadGraphic(AssetPaths.houseBG__png, false, 5500, 540);
		_BG.setGraphicSize(0, FlxG.height);
		_BG.updateHitbox();
		add(_BG);
		
		//MAIN STUFF EHEHEH
		
		addMainStuff();
		
		spawnCat();
		
		createHUD();
		
		//FlxG.camera.follow(_mom);
		
	}
	
	private function createHUD():Void
	{
		_timerText = new FlxText(10, FlxG.height - 35, 0, Std.string(Math.ffloor(_timer)), 20);
		add(_timerText);
		
		_distanceBar = new FlxSprite(175, 6);
		_distanceBar.loadGraphic("assets/images/DistanceBar.png", false, 1387, 56);
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
	
	private function updateHUD():Void
	{
		_momIcon.x = FlxMath.remapToRange(_mom._distanceX,  0, _distanceGoal, _distanceBar.x + 10, _distanceBar.x + _distanceBar.width - _momIcon.width - 10);
		
		
		_timer -= FlxG.elapsed;
		_timerText.text = "seconds " + Math.ffloor(_timer);
		
		
		
		
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
	
	override function controls():Void 
	{
		super.controls();
		
		debugControls();
		
		_distaceGoalText.text = "Distance \nneeded: " + _distanceGoal;
		
	}
	
	private function resetMultipliers():Void
	{
		_mom._speedMultiplier = 1;
		_player.punchMultiplier = 1;
		
		_playerAnims.visible = false;
		_player.visible = true;
	}
	
	private function watching():Void
	{
		
	}
	
	private function debugControls():Void
	{
		if (!recording && !replaying)
		{
			startRecording();
		}
		
		#if !mobile
		if (FlxG.keys.justPressed.R && recording)
		{
			loadReplay();
		}
		
		if (FlxG.keys.justPressed.E)
		{
			spawnMoped();
		}
		
		if ((FlxG.keys.justPressed.V && !_candyMode))
		{
			activateCandy();
		}
		#end
		
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
		#if !mobile
		if (FlxG.keys.justPressed.C)
		{
			spawnCat();
		}
		
		if (FlxG.keys.justPressed.L)
		{
			_timer = 35;
			FlxG.sound.music.stop();
			FlxG.sound.play("assets/sounds/speedUp.mp3", 1, false, null, true, function(){FlxG.sound.playMusic("assets/music/Music/HYPERTheme.mp3");});
			
		}
		#end
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
			
			if (!_moped.isOnScreen())
			{
				_moped.kill();
			}
		}
		else
		{
			spawnMoped();
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
		
		#if !mobile
		if (_mom._distanceX >= _distanceGoal || FlxG.keys.justPressed.F)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function(){FlxG.switchState(new AnvilState());});
			
		}
		#end
	}
	
	
}