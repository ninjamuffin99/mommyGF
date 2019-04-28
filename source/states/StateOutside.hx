package states;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import states.StateBaseLevel;

/**
 * ...
 * @author ninjaMuffin
 */
class StateOutside extends states.StateBaseLevel 
{
	private var _BG1:FlxSprite;
	private var _BG2:FlxSprite;
	
	override public function create():Void 
	{
		super.create();
		_distanceGoal = 12000;
		
		
		_BG1 = new FlxSprite().loadGraphic(AssetPaths.Mom_Game_Outide_1_small__png, false, 5500, 540);
		_grpBackgrounds.add(_BG1);
		
		_BG2 = new FlxSprite(_BG1.width, 0).loadGraphic(AssetPaths.Mom_Game_Outide_2_small__png, false, 5500, 540);
		_grpBackgrounds.add(_BG2);
		
		
		//_skyBG from StateBaseLevel
		_skyBG.loadGraphic(AssetPaths.skyBGSmall__png, false, 1212, 1469);
		_skyBG.y -= _skyBG.height;
		
		
		_grpBackgrounds.add(_skyBG);
		
		addMainStuff();
		spawnCat();
		createHUD();
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		_BG1.x = -FlxMath.remapToRange(_mom._distanceX, 0, _distanceGoal, 0, (_BG1.width * 2) - FlxG.width);
		_BG2.x = -FlxMath.remapToRange(_mom._distanceX, 0, _distanceGoal, 0, (_BG2.width * 2) - FlxG.width) + _BG1.width;
		
		if (_mom._distanceX >= _distanceGoal)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function()
			{
				FlxG.switchState(new StateAnvil());
			});
			
		}
	}
}