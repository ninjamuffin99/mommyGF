package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxTiledSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

/**
 * ...
 * @author 
 */
class SubstateOptions extends FlxSubState 
{
	
	private var scrollingHeads:FlxTiledSprite;
	
	private var menuItems:Array<Dynamic> = 
	[
		["masterVol", "musicVol", "sfx", "antialias"],
		["slider", "slider", "slider", "checkbox"]
		
	];

	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(AssetPaths.options_screen__png);
		add(bg);
		
		var blueShit:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF64CFEE);
		blueShit.alpha = 0.7;
		add(blueShit);
		
		scrollingHeads = new FlxTiledSprite(AssetPaths.HeadPattern__png, 968, 540);
		scrollingHeads.blend = "lighten";
		add(scrollingHeads);
		scrollingHeads.alpha = 0.6;
		scrollingHeads.scrollY = 50;
		
		
		var optTex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.optionsSheet__png, AssetPaths.optionsSheet__txt);
		
		var optionsTitle:FlxSprite = new FlxSprite();
		optionsTitle.frames = optTex;
		add(optionsTitle);
		
		for (i in 0...menuItems[0].length)
		{
			var menuShit:FlxSprite = new FlxSprite(
		}
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	
		var scrollShit:Float = FlxG.height * 0.4 * 0.25 * FlxG.elapsed;
		
		scrollingHeads.scrollY += scrollShit;
		scrollingHeads.scrollX += scrollShit;
		
	}
	
}