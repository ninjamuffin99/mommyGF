package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxTiledSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class SubstateOptions extends FlxSubState 
{
	
	private var scrollingHeads:FlxTiledSprite;
	
	public static var masterVol:Float = 1;
	public static var musicVol:Float = 1;
	public static var soundVol:Float = 1;
	public static var antialias:Bool = true;
	
	private var curSelected:Int = 0;
	
	private var menuItems:Array<Dynamic> = 
	[
		["masterVol", "musicVol", "sfx", "antialiasing"],
		["slider", "slider", "slider", "checkBox"]
		
	];
	
	private var grpMenuItems:FlxTypedGroup<FlxSprite>;

	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(AssetPaths.options_screen__png);
		add(bg);
		
		var blueShit:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF64CFEE);
		blueShit.alpha = 0.7;
		add(blueShit);
		
		// NOTE TO SELF: This will have to be redone at some point in the future,
		// since it does some weird shit on the windows build
		scrollingHeads = new FlxTiledSprite(AssetPaths.HeadPattern__png, 968, 540);
		// scrollingHeads.blend = "lighten";
		add(scrollingHeads);
		scrollingHeads.alpha = 0.6;
		scrollingHeads.scrollY = 50;
		
		var optTex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.optionsSheet__png, AssetPaths.optionsSheet__txt);
		
		var optionsTitle:FlxSprite = new FlxSprite(0, 20);
		optionsTitle.frames = optTex;
		optionsTitle.animation.add("idle", [0, 2], 12);
		optionsTitle.animation.play("idle");
		optionsTitle.screenCenter(X);
		add(optionsTitle);
		
		grpMenuItems = new FlxTypedGroup<FlxSprite>();
		add(grpMenuItems);
		
		for (i in 0...menuItems[0].length)
		{
			var menuShit:FlxSprite = new FlxSprite(20, 130 + 80 * i);
			var tex = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/UI/options/" + menuItems[0][i] + "Sheet.png", "assets/images/UI/options/" + menuItems[0][i] +"Sheet.txt");
			menuShit.frames = tex;
			menuShit.animation.add("idle", [0]);
			menuShit.animation.add("selected", [1, 2, 3, 4], 12);
			menuShit.animation.play("idle");
			grpMenuItems.add(menuShit);
			
			FlxG.log.add(i);
			
			var menuSel:FlxSprite = new FlxSprite(400, 150 + 80 * i);
			tex = FlxAtlasFrames.fromSpriteSheetPacker("assets/images/UI/options/" + menuItems[1][i] + "Sheet.png", "assets/images/UI/options/" + menuItems[1][i] +"Sheet.txt");
			menuSel.frames = tex;
			add(menuSel);
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.anyJustPressed(["DOWN", "S", "K"]))
			curSelected += 1;
		else if (FlxG.keys.anyJustPressed(["UP", "W", "I"]))
			curSelected -= 1;
		
		if (curSelected < 0)
			curSelected = Std.int(menuItems[0].length - 1);
		else if (curSelected > menuItems[0].length - 1)
			curSelected = 0;
	
		grpMenuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play("idle");
		});	
		
		grpMenuItems.members[curSelected].animation.play("selected");
			
		FlxG.watch.addQuick("curSel", curSelected);
		
		var scrollShit:Float = FlxG.height * 0.4 * 0.25 * FlxG.elapsed;
		
		scrollingHeads.scrollY += scrollShit;
		scrollingHeads.scrollX += scrollShit;
		
	}
	
}