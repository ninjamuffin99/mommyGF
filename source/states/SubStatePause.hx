package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.ui.FlxSlider;
import flixel.addons.ui.FlxUICheckBox;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

/**
 * ...
 * @author ninjaMuffin
 */
class SubStatePause extends FlxSubState 
{
	private var _pauseText:FlxText;
	
	private var _musicVolumeSlider:FlxSlider;
	private var _soundVolumeSlider:FlxSlider;
	
	private var _btnAA:FlxUICheckBox;
	
	private var menuButton:FlxButton;
	private var tempRotVel:Float = 0;
	
	private var theState:StateBaseLevel;
	
	//the hex is an translucent black
	public function new(BGColor:FlxColor = 0xAA000000, curState:StateBaseLevel) 
	{
		super(BGColor);
		
		_pauseText = new FlxText(0, 0, 0, "PAUSED", 32);
		_pauseText.color = FlxColor.BLUE;
		_pauseText.screenCenter();
		add(_pauseText);
		
		_musicVolumeSlider = new FlxSlider(Global, "musicVolume", 100, 100, 0, 1, 500, 50, 10, FlxColor.WHITE, FlxColor.WHITE);
		add(_musicVolumeSlider);
		
		_soundVolumeSlider = new FlxSlider(Global, "masterVolume", 100, 300, 0, 1, 500, 50, 10, FlxColor.WHITE, FlxColor.WHITE);
		add(_soundVolumeSlider);
		
		_btnAA = new FlxUICheckBox(100, 200, null, null, "Antialiasing", 100, null, clickAA);
		add(_btnAA);
		
		
		tempRotVel = curState._mom.body.angularVel;
		curState._mom.body.angularVel = 0;
		theState = curState;
		
		
		_soundVolumeSlider.clickSound = "assets/sounds/oof.mp3";
		
		menuButton = new FlxButton(50, 50, "main Menu", function(){FlxG.switchState(new StateMenu()); });
		add(menuButton);
		
		FlxG.mouse.visible = true;
	}
	
	private function clickAA():Void
	{
		if (_btnAA.checked)
		{
			_btnAA.checked = false;
		}
		else
		{
			_btnAA.checked = true;
		}
		
		Global.antiAliasing =  _btnAA.checked;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		Global.paused = true;
		/*
		FlxG.watch.add(Global, "musicVolume");
		
		FlxG.sound.music.volume = Global.musicVolume;
		FlxG.sound.volume = Global.masterVolume;
		*/
		#if !mobile
		if (FlxG.keys.justPressed.ENTER)
		{
			close();
		}
		#end
		
	}
	
	override public function close():Void 
	{
		
		theState._mom.body.angularVel = tempRotVel;
		super.close();
	}
	
}