package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	override public function create():Void
	{
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(AssetPaths.TitleScreen__png, false, 1927, 1080);
		bg.setGraphicSize(1920, 1080);
		bg.updateHitbox();
		bg.setGraphicSize(Std.int(bg.width / 2));
		bg.updateHitbox();
		add(bg);
		
		var _titleText:FlxSprite = new FlxSprite(0, FlxG.height * 0.04);
		_titleText.loadGraphic(AssetPaths.titleTextsheet__png, true, 1120, 452);
		_titleText.setGraphicSize(Std.int(_titleText.width / 2));
		_titleText.updateHitbox();
		_titleText.screenCenter(X);
		_titleText.animation.add("idle", [0, 1, 2], 12);
		_titleText.animation.play("idle");
		add(_titleText);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}