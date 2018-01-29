package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author ninjaMuffin
 */
class WinState extends FlxState 
{

	private var _videoGame = ["SUPER SMASH BROTHERS BRAWL FOR \nTHE NINTENDO WII", 
	"CASTLE CRASHERS", 
	"ALIEN HOMINID", 
	"CALL OF DUTY: MODERN WARFARE 3 \nFOR XBOX 360", 
	"METAL GEAR SOLID: TWIN SNAKES\nFOR NINTENDO GAMECUBE",
	"SONIC ADVENTURE 2: BATTLE",
	"SUPER MEAT BOY",
	"E.T. FOR THE ATARI 2600",
	"SPELUNKEY",
	"MINECRAFT",
	"GRAND THEFT AUTO III \nFOR THE SONY PLAYSTATION TWO",
	"HOTLINE MIAMI"];
	
	override public function create():Void 
	{
		var _winText:FlxText = new FlxText(0, FlxG.height * 0.4, 0, "GG MOM IS DED AND YOU PLAY SOME VERY FUN VIDEO GAMES \nLIKE " + FlxG.random.getObject(_videoGame) + "\n\nPRESS ENTER TO GO BACK", 20);
		_winText.screenCenter(X);
		add(_winText);
		
		FlxTween.tween(_winText, {y: FlxG.height * 0.45}, 0.75, {ease:FlxEase.quadInOut, type:FlxTween.PINGPONG});
		
		_winText.text += "\nYou killed mom in ";
		_winText.text += Points.curTime;
		_winText.text += " seconds!";
		
		var test:Explosion = new Explosion(0, 0);
		add(test);
		
		var hellYeah:HellYeah = new HellYeah(0, 0);
		add(hellYeah);
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		#if !mobile
		if (FlxG.keys.justReleased.ENTER)
		{
			FlxG.switchState(new PlayState());
		}
		#end
	}
	
}