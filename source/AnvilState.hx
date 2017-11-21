package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class AnvilState extends FlxState 
{
	private var _player:Player;
	private var _playerTrail:FlxTrailArea;
	
	private var _rope:FlxSprite;
	private var _ropeHP:Float = 1;
	private var _ropeBroke:Bool = false;
	
	override public function create():Void 
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.3, true);
		
		_player = new Player(FlxG.width * 0.05, FlxG.height * 0.3);
		add(_player);
		
		_playerTrail = new FlxTrailArea(0, 0, FlxG.width, FlxG.height, 0.75);
		_playerTrail.add(_player);
		add(_playerTrail);
		
		
		_rope = new FlxSprite(FlxG.width * 0.35);
		_rope.loadGraphic(AssetPaths.ropeSheet__png, true, 713, 1080);
		_rope.animation.add("punched1", [1, 0], 12, false);
		_rope.animation.add("punched2", [3, 2], 12, false);
		_rope.animation.add("punched3", [5, 4], 12, false);
		_rope.animation.add("punched4", [7, 6], 12, false);
		_rope.animation.add("break", [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
		9, 9, 9, 9, 9, 9, 9, 9,
		10, 10, 10, 10, 10, 10, 10, 
		11, 11, 11, 11, 11, 11, 
		12, 13, 14], 12, false);
		_rope.animation.frameIndex = 0;
		_rope.setGraphicSize(Std.int(_rope.width / 2));
		_rope.updateHitbox();
		add(_rope);
		
		
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.Z && !_ropeBroke)
		{
			if (_ropeHP < 5)
			{
				_rope.animation.play("punched" + Math.floor(_ropeHP), true);
				
				_ropeHP += FlxG.random.float(0.05, 0.2);
				
				FlxG.log.add(Math.floor(_ropeHP));
				FlxG.log.add(_ropeHP);
				FlxG.camera.shake(0.02, FlxG.elapsed * 6);
				sfxHit();
			}
			else
			{
				FlxG.sound.play(AssetPaths.PowerEcho__mp3);
				FlxG.sound.play(AssetPaths.glassBreak__mp3, 0.4);
				FlxG.sound.music.fadeOut(FlxG.elapsed * 10);
				_rope.animation.play("break");
				FlxG.camera.flash(FlxColor.WHITE);
				sfxHit();
				FlxG.camera.shake();
				_ropeBroke = true;
			}
			
		}
		
		if (_rope.animation.frameIndex == 14)
		{
			_rope.visible = false;
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.switchState(new MenuState());
		}
	}
	
	private function sfxHit():Void
	{
		FlxG.sound.play("assets/sounds/mom-game/Mom Game/HYPER Sounds/hyper (" + FlxG.random.int(1, 5) + ").wav", 0.8);
	}
	
}