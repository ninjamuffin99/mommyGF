package;

import flixel.FlxG;
import flixel.FlxObject;
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
	
	private var _map:FlxSprite;
	private var _camTrack:FlxObject;
	
	override public function create():Void
	{
		_map = new FlxSprite(0, 0);
		_map.loadGraphic(AssetPaths.map__png, false, 2400, 1350);
		add(_map);	
		
		for (i in 1...3)
		{
			var levelLabel:FlxSprite = new FlxSprite(100, (i * 240) - 170).loadGraphic("assets/images/level_label_" + i + ".png", false, 281, 102);
			levelLabel.scrollFactor.set();
			levelLabel.scale.set(2, 2);
			levelLabel.updateHitbox();
			add(levelLabel);
		}
		
		_selector = new FlxSprite();
		_selector.loadGraphic("assets/images/Selector.png", false, 99, 166);
		_selector.setGraphicSize(Std.int(_selector.width / 2));
		_selector.updateHitbox();
		_selector.scrollFactor.set();
		add(_selector);
		
		_selector.x = 50;
		_selector.y = 70;
		
		
		FlxG.camera.zoom = 0.5;
		_camTrack = new FlxObject(0, 0, 16, 16);
		add(_camTrack);
		
		FlxG.camera.follow(_camTrack);
		FlxG.camera.followLerp = 0.04;
		FlxG.camera.setScrollBounds(0, _map.width, 0, _map.height);
		
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
				selectorPos = 2;
			if (selectorPos > 2)
				selectorPos = 0;
			
			var selectorOffset:Float = 50;
			switch (selectorPos) 
			{
				case 0:
					_camTrack.setPosition(800, 170);
				case 1:
					_camTrack.setPosition(1500, 170);
				case 2:
					_camTrack.setPosition(1100, 950);
			}
			
			_selector.y = (selectorPos * 240) + 240;
			
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
				/*
				if (touch.y > levels.y + 66)
				{
					FlxG.switchState(new OutsideState());
				}
				else
				{
					FlxG.switchState(new PlayState());
				}
				*/
			}
		}
	}
	
}