package;

import flash.text.TextField;
import flixel.FlxGame;
import lime.app.Application;
import lime.app.Config;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		addChild(new FlxGame(0, 0, MenuState));
		addChild(new FPS(10, 3, 0xFFFFFF));
		addChild(new BuildInfo(50, 3));
	}
}