package;

import utils.Conductor;
import flixel.math.FlxAngle;
import openfl.Lib;
import utils.GameInfo;
import props.hud.ScoreTracker;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
#if ng
import utils.NGio;
#end

class DebugState extends BeatState
{
    var test:FlxSprite;
	var debugObject:ScoreTracker;

    override function create()
    {
        if (FlxG.sound.music.playing)
            FlxG.sound.music.stop();

        #if ng
        if (NGio.loggedIn)
        {
            NGio.unlockMedal(65994);
        }
        #end

        Conductor.changeBPM(130);

        //FlxG.sound.cache("assets/music/kgen_d_rip" + GameInfo.audioExtension);
        FlxG.sound.playMusic("assets/music/kgen_d_rip" + GameInfo.audioExtension);
        FlxG.sound.music.onComplete = () ->
        {
			resetValues();
        }

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFCFFFF7);
        add(bg);

        test = new FlxSprite().loadGraphic("assets/images/hud/ngmedals/63898.png");
        test.screenCenter();
        add(test);

        debugObject = new ScoreTracker(50, 120);
        add(debugObject);

        //trace(FlxAngle.angleBetween(test, debugObject));

		super.create();
    }

    //var halt:Bool = false;
    override function update(elapsed:Float):Void
	{
		Conductor.songPosition = FlxG.sound.music.time;

		everyStep();
		everyBeat();

        super.update(elapsed);

        if (FlxG.keys.justPressed.M && FlxG.sound.music.playing)
        {
            FlxG.sound.music.stop();
        }

        if (FlxG.keys.justPressed.T)
        {
            debugObject.showScore("Test", FlxG.random.int(1, 100), 1.75);
        }

        if (FlxG.keys.pressed.T && FlxG.keys.pressed.SHIFT)
        {
			debugObject.showScore("Spam", FlxG.random.int(1, 1000), 1.75);
        }

        if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.sound.music.stop();
            FlxG.switchState(new TitleState());
        }
    }

    override function customStepHit():Void
    {
        if (curStep > 62 && curStep < 320)
        {
            if (curStep % 2 == 0)
            {
                test.flipX = !test.flipX;
            }
        }
    }
}