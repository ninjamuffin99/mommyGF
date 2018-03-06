package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class LevelSelect extends FlxState 
{
	private var levels:FlxText;
	
	private var _selector:FlxSprite;
	private var selectorPos:Int = 0;
	
	override public function create():Void 
	{
		levels = new FlxText(200, 200, 0, "Home\nOutside", 64);
		add(levels);
		
		_selector = new FlxSprite(25, 20);
		_selector.loadGraphic("assets/images/Selector.png", false, 99, 166);
		_selector.setGraphicSize(Std.int(_selector.width / 2));
		_selector.updateHitbox();
		add(_selector);
		
		_selector.x = levels.x - 50;
		_selector.y = levels.y;
		
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		
		#if !mobile
		if (FlxG.keys.anyJustPressed(["UP", "W", "I", "DOWN", "S", "K"]))
		{
			if (FlxG.keys.anyJustPressed(["UP", "W", "I"]))
			{
				selectorPos -= 1;
			}
			else if (FlxG.keys.anyJustPressed(["DOWN", "S", "K"]))
			{
				selectorPos += 1;
			}
			
			if (selectorPos < 0)
				selectorPos = 1;
			if (selectorPos > 1)
				selectorPos = 0;
			
			var selectorOffset:Float = 50;
			switch (selectorPos) 
			{
				case 0:
					_selector.y = levels.y;
				case 1:
					_selector.y = levels.y + 66;
			}
			
		}
		
		#end
		
		
		
		if (FlxG.keys.anyJustPressed(["SPACE", "ENTER"]))
		{
			switch (selectorPos) 
			{
				case 0:
					FlxG.switchState(new PlayState());
				case 1:
					FlxG.switchState(new OutsideState());
				default:
					FlxG.log.add("Defualt selection???");
			}
		}
		
		#if (html5 || mobile)
		mobileStuff();
		#end
	}
	
	private function mobileStuff():Void
	{
		if (FlxG.onMobile)
		{
			for (touch in FlxG.touches.list)
			{
				if (touch.y > levels.y + 66)
				{
					FlxG.switchState(new OutsideState());
				}
				else
				{
					FlxG.switchState(new PlayState());
				}
			}
		}
	}
	
}