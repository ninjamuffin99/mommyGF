package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	private var _mom:Mom;
	private var _player:Player;
	
	override public function create():Void
	{
		
		_mom = new Mom(300, 100);
		add(_mom);
		
		_player = new Player(50, 260);
		add(_player);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}