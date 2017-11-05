package;

import flixel.FlxSprite;
import flixel.FlxState;

/**
 * ...
 * @author ninjaMuffin
 */
class GameOverState extends FlxState 
{
	private var _gameOver:FlxSprite;
	
	override public function create():Void 
	{
		_gameOver = new FlxSprite(0, 0);
		_gameOver.loadGraphic("assets/images/gameOverTemp.png", true, 1920, 1080);
		_gameOver.setGraphicSize(940);
		_gameOver.updateHitbox();
		_gameOver.animation.add("play", [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 10, 11, 12, 13, 13, 14, 15, 16, 16, 17, 18, 19, 19, 20, 21], 24, true);
		_gameOver.animation.play("play");
		
		add(_gameOver);
		
		
		super.create();
	}
}