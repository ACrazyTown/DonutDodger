package;

import flixel.addons.transition.FlxTransitionableState;
import utils.Conductor;

/*
* This is stolen from like the FNF init commit
*/

class BeatState extends FlxTransitionableState
{
	//var init:Bool = false;
	var curBeat:Int = 0;
	var curStep:Int = 0;

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var totalBeats:Int = 0;
	private var totalSteps:Int = 0;

	override function create()
	{
		super.create();
	}

	private function everyBeat():Void
	{
		if (Conductor.songPosition > lastBeat + Conductor.crochet - Conductor.safeZoneOffset
			|| Conductor.songPosition < lastBeat + Conductor.safeZoneOffset)
		{
			if (Conductor.songPosition > lastBeat + Conductor.crochet)
			{
				beatHit();
				customBeatHit();
			}
		}
	}

	private function everyStep():Void
	{
		if (Conductor.songPosition > lastStep + Conductor.stepCrochet - Conductor.safeZoneOffset
			|| Conductor.songPosition < lastStep + Conductor.safeZoneOffset)
		{
			if (Conductor.songPosition > lastStep + Conductor.stepCrochet)
			{
				stepHit();
				customStepHit();
			}
		}
	}

	public function resetValues():Void
	{
		curStep = 0;
		curBeat = 0;

		lastStep = 0;
		lastBeat = 0;
	}

	public function stepHit():Void
	{
		totalSteps += 1;
		lastStep += Conductor.stepCrochet;

		curStep += 1;

		//trace("STEP: " + curStep);
	}

	public function beatHit():Void
	{
		lastBeat += Conductor.crochet;
		totalBeats += 1;

		curBeat += 1;

		//trace("BEAT: " + curBeat);
	}

	public function customStepHit():Void {}

	public function customBeatHit():Void {}
}