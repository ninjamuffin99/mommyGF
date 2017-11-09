package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.Assets;

class PlayState extends FlxState
{
	private var _mom:Mom;
	private var _distanceBar:FlxSprite;
	private var _momIcon:FlxSprite;
	private var _pickupMom:Float = 0;
	private var _pickupMomNeeded:Float = 15;
	private var _momCatOverlap:Bool = false;
	
	
	
	private var _distanceGoal:Float = 5000;
	private var _distaceGoalText:FlxText;
	
	
	private var _player:Player;
	private var _playerPunchHitBox:FlxObject;
	private var _playerY:Float = 200;
	
	
	private var _cat:Cat;
	private var _catLeft:Bool = false;
	
	private var _timer:Float = 180;
	private var _timerText:FlxText;
	
	private var _timerCat:Float = 10;
	private var _catActive:Bool = false;
	
	override public function create():Void
	{
		FlxG.sound.playMusic("assets/music/Music/Main Theme.mp3");
		
		_mom = new Mom(300, -165);
		add(_mom);
		
		_cat = new Cat(0 - 200, FlxG.height);
		add(_cat);
		
		_player = new Player(50, _playerY);
		add(_player);
		
		_playerPunchHitBox = new FlxObject(_player.x + 60, _player.y, 75, 75);
		add(_playerPunchHitBox);
		
		createHUD();
		
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
		
		
		_distanceBar.scrollFactor.x = 0;
		_timerText.scrollFactor.x = 0;
	}
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.watch.addQuick("momm y", _mom.getPosition());
		FlxG.watch.addQuick("player pos", _player.getPosition());
		
		FlxG.sound.music.volume = Global.musicVolume;
		
		if (_timer <= 0)
		{
			FlxG.switchState(new GameOverState());
		}
		
		if (_mom._distanceX >= _distanceGoal)
		{
			FlxG.switchState(new WinState());
		}
		
		
		if (_mom.animation.curAnim.name == "idle")
		{
			_mom._distanceX += 1;
		}
		
		if (FlxG.overlap(_cat, _mom) && !_cat._punched && !_momCatOverlap)
		{
			_mom.angularVelocity += _cat.velocity.x * FlxG.random.float(0.2, 0.5);
			sfxHit();
			_momCatOverlap = true;
		}
		
		_momIcon.x = FlxMath.remapToRange(_mom._distanceX,  0, _distanceGoal, _distanceBar.x + 10, _distanceBar.x + _distanceBar.width - 10);
		FlxG.watch.addQuick("momsii", _momIcon.x);
		
		_timer -= FlxG.elapsed;
		_timerText.text = "seconds " + Math.ffloor(_timer);
		
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
			_player.x = _mom.x - 50;
			
			if (_pickupMom >= _pickupMomNeeded)
			{
				_mom._fallenDown = false;
				_mom.angle = 0;
				_player._pickingUpMom = false;
				_pickupMom = 0;
			}
			
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
			_player.setPosition(_mom.x + 500, _playerY);
			_player._left = false;
		}
		if (FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.Z)
		{
			_player.setPosition(_mom.x - 300, _playerY);
			_player._left = true;
		}
		
		if (FlxG.keys.pressed.Z)
		{
			if (FlxG.keys.justPressed.Z)
			{
				sfxHit();
				if (_player._left)
				{
					_mom.angularVelocity += 20;
				}
				else
				{
					_mom.angularVelocity -= 20;
				}
			}
			if (_player._left)
			{
				_player.setPosition(_mom.x - 200, _playerY);
				_mom.angularVelocity += 4;
			}
			else
			{
				_player.setPosition(_mom.x + 300, _playerY);
				_mom.angularVelocity -= 4;
			}
		}
		else
		{
			if (_player._left)
			{
				_player.setPosition(_mom.x - 300, _playerY);
			}
			else
			{
				_player.setPosition(_mom.x + 400, _playerY);
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
		
		
		if (_player._pickingUpMom && FlxG.keys.justPressed.LEFT)
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
		
		
		
	}
	
	private function punch():Void
	{
		_playerPunchHitBox.active = true;
		
		if (FlxG.overlap(_cat, _playerPunchHitBox))
		{
			_cat._punched = true;
			if (_cat._timesPunched >= 1)
			{
				_cat.fly(-_cat.velocity.x, FlxG.random.float(-400, -450));
			}
			else
			{
				_cat.fly(_cat.velocity.x, -400);
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
		FlxG.log.add("SFX");
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