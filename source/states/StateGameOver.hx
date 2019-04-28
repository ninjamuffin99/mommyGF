package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;

/**
 * ...
 * @author ninjaMuffin
 */
class StateGameOver extends FlxState 
{
	private var _gameOver:FlxSprite;
	
	private var _no:FlxSprite;
	private var _yes:FlxSprite;
	
	private var _selector:FlxSprite;
	
	private var _selectionInt:Int = 0;
	
	override public function create():Void 
	{
		_gameOver = new FlxSprite(0, 0);
		_gameOver.loadGraphic("assets/images/gameOverTemp.png", true, 1920, 1080);
		_gameOver.setGraphicSize(960);
		_gameOver.updateHitbox();
		_gameOver.animation.add("play", [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 10, 11, 12, 13, 13, 14, 15, 16, 16, 17, 18, 19, 19, 20, 21], 24, true);
		_gameOver.animation.play("play");
		
		add(_gameOver);
		
		
		_no = new FlxSprite(550, 450);
		_no.loadGraphic(AssetPaths.noSheet__png, true, 301, 177);
		_no.setGraphicSize(Std.int(_no.width / 2));
		_no.updateHitbox();
		_no.animation.add("play", [1, 2, 0], 12);
		_no.animation.play("play");
		add(_no);
		
		_yes = new FlxSprite(240, 435);
		_yes.loadGraphic(AssetPaths.YesSheet__png, true, 366, 199);
		_yes.setGraphicSize(Std.int(_yes.width / 2));
		_yes.updateHitbox();
		_yes.animation.add("play", [0, 1, 2], 12);
		_yes.animation.play("play");
		add(_yes);
		
		
		_selector = new FlxSprite(_yes.x - 25, _yes.y + 20);
		_selector.loadGraphic(AssetPaths.Selector__png, false, 99, 166);
		_selector.setGraphicSize(Std.int(_selector.width / 2));
		_selector.updateHitbox();
		add(_selector);
		
		#if flash
		FlxG.sound.playMusic("assets/music/Music/768434_dumb-916-riff.mp3");
		#end
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);
		
		#if !mobile
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT)
		{
			_selectionInt += 1;
			if (_selectionInt >= 2)
			{
				_selectionInt = 0;
			}
		}
		#end
		
		
		if (_selectionInt == 0)
		{
			_no.animation.stop();
			_yes.animation.play("play");
			_selector.x = _yes.x - 30;
		}
		if (_selectionInt == 1)
		{
			_yes.animation.stop();
			_no.animation.play("play");
			_selector.x = _no.x - 45;
		}
		
		
		#if !mobile
		if (FlxG.keys.justReleased.Z)
		{
			if (_selectionInt == 0)
			{
				FlxG.switchState(new StateHouse());
			}
			if (_selectionInt == 1)
			{
				FlxG.switchState(new StateHouse());
			}
		}
		#end
		
	}
}