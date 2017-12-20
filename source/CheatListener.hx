package;

import flixel.addons.ui.FlxInputText;

/**
 * ...
 * @author ninjaMuffin
 */
class CheatListener extends FlxInputText 
{

	public function new(X:Float=0, Y:Float=0, Width:Int=150, ?Text:String, size:Int=8, TextColor:Int=FlxColor.BLACK, BackgroundColor:Int=FlxColor.WHITE, EmbeddedFont:Bool=true) 
	{
		super(X, Y, Width, Text, size, TextColor, BackgroundColor, EmbeddedFont);
		
	}
}