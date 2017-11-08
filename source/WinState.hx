package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class WinState extends FlxState 
{

	override public function create():Void 
	{
		var _winText:FlxText = new FlxText(0, 0, 0, "GG MOM IS DED AND YOU PLAY SOME VERY FUN VIDEO GAMES \nLIKE SUPER SMASH BROTHERS BRAWL FOR \nTHE NINTENDO WII\n\nPRESS ENTER TO GO BACK", 20);
		_winText.screenCenter();
		add(_winText);
		_winText.angularVelocity = 5;
		
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justReleased.ENTER)
		{
			FlxG.switchState(new PlayState());
		}
		
	}
	
}