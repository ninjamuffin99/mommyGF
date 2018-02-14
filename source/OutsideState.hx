package;

/**
 * ...
 * @author ninjaMuffin
 */
class OutsideState extends BaseState 
{

	override public function create():Void 
	{
		super.create();
		
		addMainStuff();
		
		//spawnCat();
		
		createHUD();
		
	}

}