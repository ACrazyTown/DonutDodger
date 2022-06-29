package states;
import utils.Conductor;
import utils.GameInfo;
import props.hud.ScoreTracker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
#if ng
import utils.NGio;
#end

class DebugState extends BeatState
{
    var test:FlxSprite;
	var debugObject:ScoreTracker;

    #if ng
    var ngText:FlxText;
    #end

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

        #if ng
        ngText = new FlxText(10, 10, 0, "NG Status: ?", 24);
        ngText.color = 0xFF000000;
        add(ngText);
        #end

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

        #if ng
        ngText.text = "NG Status: n";
        #end

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