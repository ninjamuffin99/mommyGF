package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.phys.BodyType;

/**
 * ...
 * @author ninjaMuffin
 */
class Retard extends FlxNapeSprite 
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, CreateRectangularBody:Bool=true, EnablePhysics:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateRectangularBody, EnablePhysics);
		makeGraphic(250, 200);
		
		createRectangularBody(500, 400);
		
		body.allowMovement = false;
		body.allowRotation = false;
		
		setBodyMaterial(100);
		
		
	}
	
}