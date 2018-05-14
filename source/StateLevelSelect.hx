package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class StateLevelSelect extends FlxState 
{
	private var levels:FlxText;
	
	private var _selector:FlxSprite;
	private var selectorPos:Int = 0;
	
	private var _map:FlxSprite;
	private var _camTrack:FlxObject;
	
	private var _grpLevelLabel:FlxTypedGroup<FlxSprite>;
	
	override public function create():Void
	{
		_map = new FlxSprite(0, 0);
		_map.loadGraphic(AssetPaths.map__png, false, 2400, 1350);
		add(_map);
		
		FlxG.camera.zoom = 0.5;
		_camTrack = new FlxObject(0, 0, 16, 16);
		add(_camTrack);
		
		FlxG.camera.follow(_camTrack);
		FlxG.camera.followLerp = 0.06;
		FlxG.camera.setScrollBounds(0, _map.width, 0, _map.height);
		
		
		_grpLevelLabel = new FlxTypedGroup<FlxSprite>();
		add(_grpLevelLabel);
		
		for (i in 0...3)
		{
			var levelLabel:FlxSprite = new FlxSprite(-400, (i * 240) - 170).loadGraphic("assets/images/UI/level_label_" + i + ".png", false, 281, 102);
			levelLabel.scrollFactor.set();
			levelLabel.scale.set(2, 2);
			levelLabel.updateHitbox();
			_grpLevelLabel.add(levelLabel);
			
			FlxG.log.add(levelLabel.x + " " + i);
		}
		
		_selector = new FlxSprite();
		_selector.loadGraphic(AssetPaths.Selector__png, false, 99, 166);
		_selector.setGraphicSize(Std.int(_selector.width / 2));
		_selector.updateHitbox();
		_selector.scrollFactor.set();
		add(_selector);
		
		
		_selector.x = _grpLevelLabel.members[0].x - 50;
		_selector.y = 70;
		
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
					_camTrack.setPosition(FlxG.width + 90, FlxG.height);
				case 1:
					_camTrack.setPosition(_map.width - FlxG.width, FlxG.height + 50);
				case 2:
					_camTrack.setPosition(1100, _map.height - FlxG.height);
			}
			
			_selector.y = (_grpLevelLabel.members[selectorPos].y) + 50;
		}
		#end
		
		if (FlxG.keys.anyJustPressed(["SPACE", "ENTER"]))
		{
			switch (selectorPos) 
			{
				case 0:
					FlxG.switchState(new StateHouse());
				case 1:
					FlxG.switchState(new StateOutside());
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
				if (touch.justPressed) 
				{
					if (touch.overlaps(_grpLevelLabel.members[0]))
					{
						FlxG.switchState(new StateHouse());
					}
					if (touch.overlaps(_grpLevelLabel.members[1]))
					{
						FlxG.switchState(new StateOutside());
					}
				}
			}
		}
	}
	
}