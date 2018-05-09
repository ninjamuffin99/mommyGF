package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class StateChallenge extends FlxState 
{
	private var boxOpened:FlxSpriteGroup;
	private var _grpThumbnails:FlxTypedGroup<FlxSpriteButton>;
	
	override public function create():Void 
	{
		boxOpened = new FlxSpriteGroup();
		
		var boxWhole:FlxSprite;
		boxWhole = new FlxSprite(0, 0);
		boxWhole.makeGraphic(Std.int(FlxG.width * 0.7), Std.int(FlxG.height * 0.6), FlxColor.BLUE);
		boxOpened.add(boxWhole);
		
		var boxText:FlxText;
		boxText = new FlxText(32, 32, boxWhole.width - 32, "", 16);
		boxOpened.add(boxText);
		
		_grpThumbnails = new FlxTypedGroup<FlxSpriteButton>();
		add(_grpThumbnails);
		
		for (a in 0...challengeList.length)
		{
			var box:FlxSpriteButton;
			box = new FlxSpriteButton(110 * (a % 8) + 16, (110 * Std.int(a / 8)) + 110 , null, function()
			{
				boxText.text = challengeList[a][0] + "\n" + challengeList[a][2];
				boxOpened.visible = true;
			});
			box.makeGraphic(100, 100);
			//if its locked, lower opacity
			if (!challengeList[a][4])
			{
				box.alpha = 0.6;
			}
			_grpThumbnails.add(box);
		}
		
		add(boxOpened);
		boxOpened.visible = false;
		boxOpened.screenCenter();
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(boxOpened) && !FlxG.mouse.overlaps(_grpThumbnails))
		{
			boxOpened.visible = false;
		}
		
	}
	
	//Syntax
	//Title
	//Short description/subtitle
	//longer in depth description
	//link to image file to be used
	//unlocked
	private var challengeList:Array<Dynamic> = 
	[
		[
			"Locked medal", 
			"Test Medal Description Short", 
			"This is a longer version of the description. I can put whatever words here I think... this description is just placeholder, and it will be deleted eventually. Just like all of us. We will all die one day. We are all achievements.",
			"link to image file here",
			false
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		],
		[
			"Unlocked medal",
			"Test desc unlocked",
			"This medal has been unlocked somehow.... thats why the button was at full opacity",
			"link to image file here",
			true
		]
	];
	
	
}