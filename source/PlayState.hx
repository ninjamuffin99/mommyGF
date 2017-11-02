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
	
	private var _timer:Float = 180;
	private var _timerText:FlxText;
	
	
	override public function create():Void
	{
		
		
		_mom = new Mom(300, 20);
		add(_mom);
		
		_player = new Player(50, 260);
		add(_player);
		
		_timerText = new FlxText(10, FlxG.height - 35, 0, Std.string(Math.ffloor(_timer)), 20);
		add(_timerText);
		
		_timerText.scrollFactor.x = 0;
		
		FlxG.camera.follow(_mom);
		FlxG.camera.maxScrollY = FlxG.height;
		
		super.create();
	}
	
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.watch.addQuick("momm y", _mom.y);
		
		_timer -= FlxG.elapsed;
		_timerText.text = "seconds " + Math.ffloor(_timer);
		
		if (FlxG.keys.justPressed.L)
		{
			_timer = 30;
		}
		
		#if (web || desktop)
		if (FlxG.keys.pressed.RIGHT)
		{
			_player.setPosition(_mom.x + 250, 260);
			_player._left = false;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			_player.setPosition(_mom.x - 150, 260);
			_player._left = true;
		}
		
		if (FlxG.keys.justPressed.Z)
		{
			sfxHit();
			if (_player._left)
			{
				_player.setPosition(_mom.x - 50, 260);
			}
			else
			{
				_player.setPosition(_mom.x + 150, 260);
			}
			
		}
		else
		{
			if (_player._left)
			{
				_player.setPosition(_mom.x - 150, 260);
			}
			else
			{
				_player.setPosition(_mom.x + 250, 260);
			}
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
		if (_timer >= 30)
		{
			FlxG.sound.play("assets/sounds/mom-game/Mom Game/Normal Sounds/smack " + FlxG.random.int(1, 3) + ".mp3", 0.7);
		}
		else
		{
			FlxG.sound.play("assets/sounds/mom-game/Mom Game/HYPER Sounds/hyper (" + FlxG.random.int(1, 5) + ").wav", 0.8);
		}
	}
	
}