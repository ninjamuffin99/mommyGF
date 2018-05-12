package;

import openfl.text.TextField;
import ApplicationMain;
import openfl.text.TextFormat;

/**
 * ...
 * @author ninjaMuffin
 */
class BuildInfo extends TextField 
{

	public function new (x:Float = 100, y:Float = 6, color:Int = 0xffffff) {
		
		super ();
		
		this.x = x;
		this.y = y;
		
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat ("_sans", 12, color);
		#if flash
		//text = "build " + ApplicationMain.main.config.build;
		#end
		
	}
	
	
}