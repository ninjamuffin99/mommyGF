package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ninjaMuffin
 */
class StateAnvil extends FlxState 
{
	private var _player:Player;
	private var _playerTrail:FlxTrailArea;
	
	private var _mom:Mom;
	
	private var _rope:FlxSprite;
	private var _ropeHP:Float = 1;
	private var _ropeBroke:Bool = false;
	
	private var test:Explosion;
	private var hellYeah:HellYeah;
	
	private var _anvil:FlxSprite;
	
	private var _endTimer:Float = FlxG.elapsed * 24;
	
	override public function create():Void 
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.3, true);
		FlxG.log.add("Before Emitter");
		
		_anvil = new FlxSprite(FlxG.width * 0.6, FlxG.width * 0);
		_anvil.loadGraphic(AssetPaths.anvil__png, false, 1024, 512);
		_anvil.setGraphicSize(Std.int(_anvil.width / 2));
		_anvil.updateHitbox();
		
		_mom = new Mom(_anvil.x + (_anvil.width / 2), FlxG.height * 1.1);
		_mom.inCutscene = true;
		
		add(_mom);
		add(_anvil);
		
		test = new Explosion();
		add(test);
		test.visible = false;
		test.animation.pause();
		
		hellYeah= new HellYeah(0, 0);
		add(hellYeah);
		hellYeah.animation.pause();
		hellYeah.visible = false;
		
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
		
		_mom.body.rotation = 0;
		
		if (_player.spamP && !_ropeBroke)
		{
			
			_player.poked = true;
			
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
				#if flash
				FlxG.sound.play(AssetPaths.PowerEcho__mp3);
				FlxG.sound.play(AssetPaths.glassBreak__mp3, 0.4);
				FlxG.sound.play(AssetPaths.bassDrum__mp3, 1);
				FlxG.sound.play(AssetPaths.snapBass__mp3, 2);
				#end
				
				new FlxTimer().start(1.8, killMom);
				
				
				
				hellYeah.visible = true;
				hellYeah.animation.play("play", true);
				
				test.visible = true;
				test.animation.play("test", true);
				
				
				
				if (FlxG.sound.music.playing)
				{
					FlxG.sound.music.fadeOut(FlxG.elapsed * 10);
				}
				
				_rope.animation.play("break");
				FlxG.camera.flash(FlxColor.WHITE);
				sfxHit();
				FlxG.camera.shake();
				_ropeBroke = true;
			}
		}
		else
		{
			_player.poked = false;
		}
		
		if (_ropeBroke)
		{
			finishingGame();
		}
		
		if (_rope.animation.frameIndex == 14)
		{
			_rope.visible = false;
		}
	}
	
	private function killMom(t:FlxTimer):Void
	{
		_mom.animation.play("squished", true);
		_mom.offset.y -= FlxG.height * 0.45;
		_mom.offset.x += FlxG.width * 0.22;
		
		_anvil.y = _mom.y + (_anvil.height * 0.5);
	}
	
	private function sfxHit():Void
	{
		#if flash
		FlxG.sound.play("assets/sounds/hyper" + FlxG.random.int(1, 5) + ".mp3", 0.8);
		#end
	}
	
	private function finishingGame():Void
	{
		if (_rope.animation.curAnim.finished)
		{
			if (_endTimer <= 0)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function(){FlxG.switchState(new StateWin()); });
			}
			else
			{
				_endTimer -= FlxG.elapsed;
			}
		}
	}
}

