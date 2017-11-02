package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class PauseSubState extends FlxSubState 
{
	private var _pauseText:FlxText;
	
	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		_pauseText = new FlxText(0, 0, 0, "PAUSED", 32);
		_pauseText.color = FlxColor.BLUE;
		_pauseText.screenCenter();
		add(_pauseText);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ENTER)
		{
			close();
		}
		
	}
	
}