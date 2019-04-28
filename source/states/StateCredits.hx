package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class StateCredits extends FlxState 
{
	
	private var _txtCreds:FlxText;
	
	override public function create():Void 
	{
		_txtCreds = new FlxText(0, FlxG.height, 0, "", 16);
		add(_txtCreds);
		_txtCreds.screenCenter(X);
		
		for (i in 0...creds.length)
		{
			_txtCreds.text += creds[i] + "\n";
		}
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		_txtCreds.y -= 1;
		
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.switchState(new states.StateMenu());
		}
		
	}
	
	public var creds:Array<String> = 
	[
		"Created by PhantomArcade and NinjaMuffin99",
		"For Newgrounds.com",
		"lov u tom fulp",
		"",
		"man I like sweet ice tea so much",
		"that shit is tasty as hell",
		"so shoutouts to ice tea",
		"Made with HaxeFlixel",
		"and a lotta love",
		"-grandma"
	];

	
}