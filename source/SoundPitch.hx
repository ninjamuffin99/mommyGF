package;

import flixel.FlxBasic;
import flixel.system.FlxSound;
import openfl.events.Event;
import openfl.events.SampleDataEvent;
import openfl.media.Sound;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

/**
 * ...
 * @author ninjaMuffin
 */
class SoundPitch extends FlxBasic
{

	inline private static var BLOCK_SIZE:Float = 3072;	
	private var _mp3:Sound;
	private var _sound:Sound;

	private var _target:ByteArray;
	
	private var _position:Float;
	private var _rate:Float;
	
	public function new():Void
	{
		super();
	}
	
	public function MP3Pitch(url:String)
	{
		_target = new ByteArray();
		
		_mp3 = new Sound();
		_mp3.addEventListener(Event.COMPLETE, complete );
		_mp3.load(new URLRequest(url));
		_position = 0.0;
		_rate = 1.0;
		_sound = new Sound();
		_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleData );
	}
	
	public function get_rate(): Float
	{
		return _rate;
	}
	
	public function set_rate( value: Float ): Void
	{
		if ( value < 0.0 )
		{
			value = 0;
			_rate = value;
		}
	}
	
	private function complete(event:Event):Void
	{
		_sound.play();
	}
	
	private function sampleData(event:SampleDataEvent):Void
	{
		//-- REUSE INSTEAD OF RECREATION
		_target.position = 0;
		
		//-- SHORTCUT
		var data: ByteArray = event.data;
		
		var scaledBlockSize:Float = BLOCK_SIZE * _rate;
		var positionInt:Float = _position;
		var alpha:Float = _position - positionInt;
		var positionTargetNum:Float = alpha;
		var positionTargetInt: Int = -1;
		//-- COMPUTE Number OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR IntERPOLATION)
		var need: Int = Math.ceil( scaledBlockSize ) + 2;
		
		//-- EXTRACT SAMPLES
		var read:Float = _mp3.extract( _target, need, positionInt );
		var n:Float = read == need ? BLOCK_SIZE : read / _rate;
		var l0:Float = 0;
		var r0:Float = 0;
		var l1:Float = 0;
		var r1:Float = 0;
		
		for(i in 0...Std.int(n))
		{
			//-- Avoid READING EQUAL SAMPLES, IF RATE < 1.0
			if(Std.int(positionTargetNum) != positionTargetInt)
			{
				positionTargetInt = Std.int(positionTargetNum);
				
				//-- SET TARGET READ POSITION
				_target.position = positionTargetInt << 3;
				
				//-- READ TWO STEREO SAMPLES FOR LINEAR IntERPOLATION
				l0 = _target.readFloat();
				r0 = _target.readFloat();
				
				l1 = _target.readFloat();
				r1 = _target.readFloat();
			}
			
			//-- WRITE IntERPOLATED AMPLITUDES IntO STREAM
			data.writeFloat( l0 + alpha * ( l1 - l0 ) );
			data.writeFloat( r0 + alpha * ( r1 - r0 ) );
			
			//-- INCREASE TARGET POSITION
			positionTargetNum += _rate;
			
			//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
			alpha += _rate;
			while( alpha >= 1.0 ) --alpha;
			
			
			
		}
		
		//-- FILL REST OF STREAM WITH ZEROs
		var i:Int = 0;
		if(i < BLOCK_SIZE )
		{
			while( i < BLOCK_SIZE )
			{
				data.writeFloat( 0.0 );
				data.writeFloat( 0.0 );
				
				++i;
			}
		}
		
		//-- INCREASE SOUND POSITION
		_position += scaledBlockSize;
	}
}