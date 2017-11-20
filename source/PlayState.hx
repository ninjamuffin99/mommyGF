package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
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
	
	//CAT SHIT
	private var _cat:Cat;
	private var _catLeft:Bool = false;
	
	//HUD SHIT
	private var _pointsText:FlxText;
	private var _highScoreText:FlxText;
	
	private var _timer:Float = 180;
	private var _timerText:FlxText;
	
	private var _timerCat:Float = 10;
	private var _catActive:Bool = false;
	
	private var _distanceGoal:Float = 6000;
	private var _distaceGoalText:FlxText;
	
	override public function create():Void
	{
		FlxG.sound.playMusic("assets/music/Music/Main Theme.mp3");
		FlxNapeSpace.init();
		
		_mom = new Mom(530, -25 + 1000);
		add(_mom);
		
		_cat = new Cat(0 - 200, FlxG.height);
		add(_cat);
		
		_player = new Player(50, _playerY);
		add(_player);
		
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
		
		
		_pointsText = new FlxText(0, 30, 0, "Points: " + Points.curPoints, 20);
		_pointsText.screenCenter(X);
		_pointsText.scrollFactor.x = 0;
		add(_pointsText);
		
		_highScoreText = new FlxText(0, 52, 0, "Highscore: " + Points.highScorePoints, 20);
		_highScoreText.screenCenter(X);
		_highScoreText.scrollFactor.x = 0;
		add(_highScoreText);
		
		Points.curPoints = 0;
		
		
		_distanceBar.scrollFactor.x = 0;
		_timerText.scrollFactor.x = 0;
	}
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.watch.addQuick("mompos", _mom.getPosition());
		
		FlxG.sound.music.volume = Global.musicVolume;
		
		sceneSwitch();
		
		if (FlxG.overlap(_cat, _mom) && !_cat._punched && !_momCatOverlap)
		{
			_mom.body.angularVel += _cat.velocity.x * FlxG.random.float(0.001, 0.025);
			sfxHit();
			_momCatOverlap = true;
		}
		
		
		updateHUD();
		
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
		
		controls();
		
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
		
		if (_pickupTimeBuffer >= 0.5)
		{
			_player._pickingUpMom = false;
			_pickupTimeBuffer = 0;
			
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
	
	private function sceneSwitch():Void
	{
		if (_timer <= 0 || _mom._timesFell >= 5)
		{
			FlxG.switchState(new GameOverState());
		}
		
		if (_mom._distanceX >= _distanceGoal)
		{
			FlxG.switchState(new WinState());
		}
	}
	
	private function updateHUD():Void
	{
		_momIcon.x = FlxMath.remapToRange(_mom._distanceX,  0, _distanceGoal, _distanceBar.x + 10, _distanceBar.x + _distanceBar.width - 10);
		
		
		_timer -= FlxG.elapsed;
		_timerText.text = "seconds " + Math.ffloor(_timer);
		
		_pointsText.text = "Points: " + Points.curPoints;
		_highScoreText.text = "Highscore: " + Points.highScorePoints;
		
	}
	
	private function controls():Void
	{
		if (FlxG.keys.pressed.W)
		{
			_distanceGoal += 10;
		}
		if (FlxG.keys.pressed.S)
		{
			_distanceGoal -= 10;
		}
		
		_distaceGoalText.text = "Distance \nneeded: " + _distanceGoal;
		
		if (FlxG.keys.justPressed.C)
		{
			spawnCat();
			//_cat.fly(400, -400);
		}
		
		if (FlxG.keys.justPressed.L)
		{
			_timer = 35;
			FlxG.sound.music.stop();
			FlxG.sound.play("assets/sounds/speedUp.mp3", 1, false, null, true, function(){FlxG.sound.playMusic("assets/music/Music/HYPER Theme.mp3");});
			
		}
		
		#if (web || desktop)
		
		if (FlxG.keys.justPressed.ENTER)
		{
			openSubState(new PauseSubState());
		}
		
		
		if (FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.Z)
		{
			_player.setPosition(_mom.x + 700, _playerY);
			_player._left = false;
		}
		if (FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.Z)
		{
			_player.setPosition(_mom.x - 100, _playerY);
			_player._left = true;
		}
		
		if (FlxG.keys.pressed.Z && !_player._pickingUpMom)
		{
			//30 degrees, converted to rads
			var smackPower:Float = 0.52;
			//4 degrees, converted to rads
			var pushMultiplier:Float = 0.07;
			if (FlxG.keys.justPressed.Z )
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
			}
			if (_player._left)
			{
				_player.setPosition(_mom.x - 100, _playerY);
				_mom.body.angularVel += pushMultiplier;
			}
			else
			{
				_player.setPosition(_mom.x + 300, _playerY);
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
				_player.setPosition(_mom.x + 600, _playerY);
			}
			_player.animation.play("idle");
		}
		
		if (FlxG.keys.justPressed.UP)
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
		
		if (FlxG.keys.pressed.UP)
		{
			_player.animation.play("punch");
		}
		if (FlxG.keys.justReleased.UP)
		{
			_player.y = _playerY;
			_playerPunchHitBox.active = false;
		}
		
		if (FlxG.keys.justPressed.DOWN && _mom._fallenDown)
		{
			_player._pickingUpMom = true;
		}
		
		
		if (_player._pickingUpMom && FlxG.keys.justPressed.Z)
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
	
	private function punch():Void
	{
		_playerPunchHitBox.active = true;
		
		if (FlxG.overlap(_cat, _playerPunchHitBox))
		{
			_cat._punched = true;
			if (_cat._timesPunched >= 1)
			{
				_cat.fly( -_cat.velocity.x, FlxG.random.float( -400, -450));
				
				Points.addPoints(50 + (25 * (_cat._timesPunched)));
				FlxG.log.add(25 * (_cat._timesPunched));
			}
			else
			{
				_cat.fly(_cat.velocity.x, -400);
				
				Points.addPoints(50);
			}
			
			_cat._timesPunched += 1;
			
			sfxHit();
			FlxG.sound.play(AssetPaths.oof__mp3);
		}
	}
	
	private function spawnCat():Void
	{
		_cat._punched = false;
		_catLeft = FlxG.random.bool();
		_cat.y = 140;
		_cat.acceleration.y = 0;
		_cat.velocity.x = _cat.velocity.y = 0;
		_cat.angularVelocity = 0;
		_cat.angle = 0;
		
		if (_catLeft)
		{
			_cat.facing = FlxObject.RIGHT;
			_cat.x = 35 - _cat.width;
			
		}
		else
		{
			_cat.facing = FlxObject.LEFT;
			_cat.x = FlxG.width - 35;
		}
		_cat.animation.play("peek");
		_catActive = true;
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
			FlxG.sound.play("assets/sounds/mom-game/Mom Game/HYPER Sounds/hyper (" + FlxG.random.int(1, 5) + ").wav", 0.8);
		}
	}
	
}