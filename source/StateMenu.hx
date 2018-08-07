package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

class StateMenu extends FlxState
{
	private var _titleStart:FlxSprite;
	private var _titleChallenges:FlxSprite;
	private var _titleOptions:FlxSprite;
	private var _titleCredits:FlxSprite;
	private var _selector:FlxSprite;
	
	private var selectorPos:Int = 0;

	override public function create():Void
	{
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(AssetPaths.TitleScreen__png, false, 1927, 1080);
		bg.setGraphicSize(960, 540);
		bg.updateHitbox();
		add(bg);
		
		var _titleText:FlxSprite = new FlxSprite(0, FlxG.height * 0.03);
		_titleText.loadGraphic(AssetPaths.titleTextsheet__png, true, 1120, 452);
		_titleText.setGraphicSize(Std.int(_titleText.width / 2));
		_titleText.updateHitbox();
		_titleText.screenCenter(X);
		_titleText.animation.add("idle", [0, 1, 2], 12);
		_titleText.animation.play("idle");
		add(_titleText);
		
		/*
		var scaleMode:StageSizeScaleMode = new StageSizeScaleMode();
		
		FlxG.scaleMode = scaleMode;
		*/
		
		createMenu();
		
		_selector = new FlxSprite(25, 20);
		_selector.loadGraphic(AssetPaths.Selector__png, false, 99, 166);
		_selector.setGraphicSize(Std.int(_selector.width / 2));
		_selector.updateHitbox();
		add(_selector);
		
		_selector.x = _titleStart.x - 25;
		_selector.y = _titleStart.y;
		super.create();
	}
	
	private function createMenu():Void
	{
		_titleStart = new FlxSprite(0, FlxG.height * 0.43);
		_titleStart.loadGraphic(AssetPaths.titleStart__png, false, 450, 136);
		_titleStart.setGraphicSize(Std.int(_titleStart.width / 2));
		_titleStart.updateHitbox();
		_titleStart.screenCenter(X);
		add(_titleStart);
		
		_titleChallenges = new FlxSprite(0, FlxG.height * 0.55);
		_titleChallenges.loadGraphic(AssetPaths.titleChallenge__png, false, 788, 153);
		_titleChallenges.setGraphicSize(Std.int(_titleChallenges.width / 2));
		_titleChallenges.updateHitbox();
		_titleChallenges.screenCenter(X);
		add(_titleChallenges);
		
		_titleOptions = new FlxSprite(0, FlxG.height * 0.7);
		_titleOptions.loadGraphic(AssetPaths.titleOptions__png, false, 652, 165);
		_titleOptions.setGraphicSize(Std.int(_titleOptions.width / 2));
		_titleOptions.updateHitbox();
		_titleOptions.screenCenter(X);
		add(_titleOptions);
		
		_titleCredits = new FlxSprite(0, FlxG.height * 0.84);
		_titleCredits.loadGraphic(AssetPaths.titleCredits__png, false, 530, 150);
		_titleCredits.setGraphicSize(Std.int(_titleCredits.width / 2));
		_titleCredits.updateHitbox();
		_titleCredits.screenCenter(X);
		add(_titleCredits);
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
				selectorPos = 3;
			if (selectorPos > 3)
				selectorPos = 0;
			
			var selectorOffset:Float = 50;
			switch (selectorPos) 
			{
				case 1:
					_selector.x = _titleChallenges.x - selectorOffset;
					_selector.y = _titleChallenges.y;
				case 2: 
					_selector.x = _titleOptions.x - selectorOffset;
					_selector.y = _titleOptions.y;
				case 3:
					_selector.x = _titleCredits.x - selectorOffset;
					_selector.y = _titleCredits.y;
				default:
					// is 0 pos, refering to starting i guess
					_selector.x = _titleStart.x - selectorOffset;
					_selector.y = _titleStart.y;
			}
		}
		#end
		
		if (FlxG.keys.anyJustPressed(["SPACE", "ENTER"]))
		{
			switch (selectorPos) 
			{
				case 0:
					FlxG.switchState(new StateLevelSelect());
				case 1:
					FlxG.switchState(new StateChallenge());
				case 2: 
					FlxG.log.add("Options Slected");
					openSubState(new SubstateOptions());
				case 3:
					FlxG.switchState(new StateCredits());
				default:
					FlxG.log.add("Defualt selection???");
			}
		}
		
		if (FlxG.onMobile)
		{
			for (touch in FlxG.touches.list)
			{
				if (touch.justPressed)
				{
					FlxG.switchState(new StateLevelSelect());
				}	
			}
		}
	}
}