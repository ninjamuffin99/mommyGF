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
	//BACKGROUND
	private var _BG:FlxSprite;
	
	//Recording/Replaying
	private static var recording:Bool = false;
	private static var replaying:Bool = false;
	
	//public var pitchedSound:SoundPitch = new SoundPitch();
	

	override public function create():Void
	{
		super.create();
		
		//set this variable per level
		_distanceGoal = 6000;
		
		#if flash
		FlxG.sound.playMusic("assets/music/MainTheme.mp3", 1);
		#end
		
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
	}
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_BG.x = -FlxMath.remapToRange(_mom._distanceX, 0, _distanceGoal, 0, _BG.width - FlxG.width);
		
		//FlxG.sound.music.volume = Global.musicVolume;
		
		//FlxG.camera.antialiasing = Global.antiAliasing;
		
		Global.paused = false;
		
		
		/*
		if (_player.justSwitched)
		{
			_playerAnims.updateCurSprite(_playerAnims.sideSwitch);
		}
		*/
		sceneSwitch();
		watching();
	}
	
	override function controls():Void 
	{
		super.controls();
		
		debugControls();
		
		_distaceGoalText.text = "Distance \nneeded: " + _distanceGoal;
		
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
			spawnObstacle(0);
		}
		if (FlxG.keys.justPressed.Q)
		{
			spawnObstacle(1);
		}
		
		if ((FlxG.keys.justPressed.V && !_candyMode))
		{
			activateCandy();
		}
		#end
		
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
			#if flash
			FlxG.sound.play("assets/sounds/speedUp.mp3", 1, false, null, true, function(){FlxG.sound.playMusic("assets/music/Music/HYPERTheme.mp3");});
			#end
		}
		#end
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