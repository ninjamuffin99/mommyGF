package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.nape.FlxNapeSpace;
import flixel.effects.particles.FlxEmitter;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ninjaMuffin
 */
class AnvilState extends FlxState 
{
	private var _player:Player;
	private var _playerTrail:FlxTrailArea;
	
	private var _mom:Mom;
	
	private var wallLeft:FlxSprite;
	private var wallDown:FlxSprite;
	private var wallRight:FlxSprite;
	private var _grpWalls:FlxGroup;
	
	private var _caseEmitter:FlxEmitter;
	
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
		CasesEffects();
		
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
	
	private function CasesEffects():Void
	{
		_grpWalls = new FlxGroup();
		
		wallLeft = new FlxSprite(-10);
		wallLeft.makeGraphic(10, FlxG.height);
		wallLeft.immovable = true;
		wallLeft.solid = true;
		_grpWalls.add(wallLeft);
		
		wallDown = new FlxSprite(0, FlxG.height);
		wallDown.makeGraphic(FlxG.width, 10);
		wallDown.immovable = true;
		wallDown.solid = true;
		_grpWalls.add(wallDown);
		
		
		wallRight = new FlxSprite(FlxG.width);
		wallRight.makeGraphic(10, FlxG.height);
		wallRight.immovable = true;
		wallRight.solid = true;
		_grpWalls.add(wallRight);
		
		add(_grpWalls);
		
		_caseEmitter = new FlxEmitter(FlxG.width / 2, -10);
		_caseEmitter.makeParticles(40, 60, FlxColor.WHITE, 600);
		_caseEmitter.solid = true;
		_caseEmitter.acceleration.set(0, 500);
		_caseEmitter.velocity.set( -50, 50, 50, 100);
		_caseEmitter.angularVelocity.set( -720, 720);
		//add(_caseEmitter);
		
		FlxG.log.add("added walls and emitter");
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
				FlxG.sound.play(AssetPaths.PowerEcho__mp3);
				FlxG.sound.play(AssetPaths.glassBreak__mp3, 0.4);
				FlxG.sound.play(AssetPaths.bassDrum__mp3, 1);
				FlxG.sound.play(AssetPaths.snapBass__mp3, 2);
				
				new FlxTimer().start(1.8, killMom);
				
				
				
				hellYeah.visible = true;
				hellYeah.animation.play("play", true);
				
				test.visible = true;
				test.animation.play("test", true);
				
				
				
				
				FlxG.sound.music.fadeOut(FlxG.elapsed * 10);
				_rope.animation.play("break");
				FlxG.camera.flash(FlxColor.WHITE);
				sfxHit();
				FlxG.camera.shake();
				_ropeBroke = true;
				
				_caseEmitter.start(false, 0.025);
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
		FlxG.sound.play("assets/sounds/hyper" + FlxG.random.int(1, 5) + ".mp3", 0.8);
	}
	
	private function finishingGame():Void
	{
		if (_rope.animation.curAnim.finished)
		{
			if (_endTimer <= 0)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function(){FlxG.switchState(new WinState()); });
			}
			else
			{
				_endTimer -= FlxG.elapsed;
			}
			
		}
		
	}
}

