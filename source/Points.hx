package;

/**
 * ...
 * @author ninjaMuffin
 */
class Points 
{
	public static var curPoints:Int = 0;
	public static var highScorePoints:Int = 0;
	
	//in milliseconds
	public static var curTime:Float = 0;
	public static var highScoreTime:Float = 0;	
	
	/**
	 * Function to add or subtract points
	 * @param	points
	 * Amount of points that will be added to curPoints
	 */
	public static function addPoints(points:Int):Void
	{
		curPoints += points;
		
		if (Points.curPoints > Points.highScorePoints)
		{
			Points.highScorePoints = Points.curPoints;
		}
	}
	
}