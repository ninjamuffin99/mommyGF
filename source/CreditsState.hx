package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class CreditsState extends FlxState 
{
	
	private var _txtCreds:FlxText;
	
	override public function create():Void 
	{
		_txtCreds = new FlxText(0, FlxG.height, 0, "", 16);
		add(_txtCreds);
		
		for (i in 0...creds.length)
		{
			_txtCreds.text += creds[i] + "\n";
		}
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.switchState(new MenuState());
		}
		
	}
	
	public var creds:Array<String> = 
	[
		"Created by PhantomArcade and NinjaMuffin99",
		"For Newgrounds.com",
		"lov u tom fulp"
	];

	
}