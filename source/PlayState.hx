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
	private var _player:Player;
	private var _playerPunchHitBox:FlxObject;
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
		
		_cat = new Cat(0 - 200, 110);
		add(_cat);
		
		_player = new Player(50, 260);
		add(_player);
		
		_playerPunchHitBox = new FlxObject(_player.x + 60, _player.y, 75, 75);
		add(_playerPunchHitBox);
		
		_timerText = new FlxText(10, FlxG.height - 35, 0, Std.string(Math.ffloor(_timer)), 20);
		add(_timerText);
		
		_timerText.scrollFactor.x = 0;
		
		FlxG.camera.follow(_mom);
		FlxG.camera.maxScrollY = FlxG.height;
		FlxG.camera.minScrollY = 0;
		
		super.create();
	}
	
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.watch.addQuick("momm y", _mom.y);
		FlxG.watch.addQuick("player X", _player.x);
		
		if (FlxG.keys.justPressed.C)
		{
			spawnCat();
			//_cat.fly(400, -400);
		}
		
		_timer -= FlxG.elapsed;
		_timerText.text = "seconds " + Math.ffloor(_timer);
		
		_timerCat -= FlxG.elapsed;
		
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
		
		
		if (FlxG.keys.pressed.RIGHT)
		{
			_player.setPosition(_mom.x + 500, 260);
			_player._left = false;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			_player.setPosition(_mom.x - 300, 260);
			_player._left = true;
		}
		
		if (FlxG.keys.pressed.Z)
		{
			if (FlxG.keys.justPressed.Z)
			{
				sfxHit();
			}
			if (_player._left)
			{
				_player.setPosition(_mom.x - 200, 260);
				_mom.angularVelocity += 4;
			}
			else
			{
				_player.setPosition(_mom.x + 300, 260);
				_mom.angularVelocity -= 4;
			}
		}
		else
		{
			if (_player._left)
			{
				_player.setPosition(_mom.x - 300, 260);
			}
			else
			{
				_player.setPosition(_mom.x + 400, 260);
			}
			_player.animation.play("idle");
		}
		
		if (FlxG.keys.justPressed.UP)
		{
			
			if (_player._left)
			{
				_player.setPosition(_player.x + 70, 155);
				_playerPunchHitBox.setPosition(_player.x + 175, _player.y + 25);
			}
			else
			{
				_player.setPosition(_player.x - 70, 155);
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
			_player.y = 260;
			_playerPunchHitBox.active = false;
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
			_cat.fly(_cat.velocity.x * 0.5, -400);
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
			_cat.x = 10 - _cat.width;
			
		}
		else
		{
			_cat.facing = FlxObject.LEFT;
			_cat.x = FlxG.width - 60;
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
					_player.setPosition(_mom.x + 150, 260);
					
					sfxHit();
				}
			}
			else
			{
				_player._left = true;
				
				if (touch.justPressed) 
				{
					_player.setPosition(_mom.x - 50, 260);
					sfxHit();
				}
				
			}
			if (touch.justReleased) 
			{
				if (!_player._left)
				{
					_player.setPosition(_mom.x + 250, 260);
				}
				else
				{
					_player.setPosition(_mom.x - 150, 260);
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
					_player.setPosition(_mom.x + 150, 260);
					sfxHit();
				}
			}
			else
			{
				_player._left = true;
				
				if (FlxG.mouse.justPressed) 
				{
					_player.setPosition(_mom.x - 50, 260);
					sfxHit();
				}
			}
			if (FlxG.mouse.justReleased) 
			{
				if (!_player._left)
				{
					_player.setPosition(_mom.x + 250, 260);
				}
				else
				{
					_player.setPosition(_mom.x - 150, 260);
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