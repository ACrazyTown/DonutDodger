package;

import utils.APIKeys;
#if ng
import io.newgrounds.NG;
import utils.NGio;
#end
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

import utils.GameInfo;
import utils.HelperFunctions;

class TitleState extends FlxState
{
	public static var ngMessage:String = "";
    public static var firstTime:Bool = true;
	public static var versionTxt:FlxText;

    var skippedIntro:Bool = false;

	var curSelected:Int = 0;
    var curDifficulty:Int = 1;

    var menuOptions:Array<String> = ["PLAY", "OPTIONS"];
    var menuGroup:FlxTypedGroup<FlxText>;

    // spaces because haxeflixel hates me
    var diffArray:Array<String> = ["EASY", "NORMAL", "     HARD"];
    var diffGroup:FlxTypedGroup<FlxText>;

    var introText:FlxText;
    var introTimer:FlxTimer;

	override public function create()
	{
		FlxG.mouse.visible = false;

        super.create();
        
        menuGroup = new FlxTypedGroup<FlxText>();
        add(menuGroup);

        diffGroup = new FlxTypedGroup<FlxText>();
        add(diffGroup);

        if (firstTime)
        {
			FlxG.sound.playMusic("assets/music/title/title" + GameInfo.audioExtension, 0.7);

            introText = new FlxText(0, 0, 0, "A Crazy Town\n presents", 28);
            introText.alignment = FlxTextAlign.CENTER;
            introText.screenCenter();
            add(introText);

            new FlxTimer().start(1.50, function(tmr:FlxTimer)
            {
                introText.text = "DingDongDirt by\n Dorbellprod";
				introText.screenCenter();
                tmr.destroy();
            });

			new FlxTimer().start(3.00, function(tmr:FlxTimer)
			{
				introText.text = "Newgrounds is\n Swag and Awesome";
				introText.screenCenter();
				tmr.destroy();
			});

			new FlxTimer().start(4.60, function(tmr:FlxTimer)
			{
				introText.text = "AAA Gameplay\n -Literally Everyone";
				introText.screenCenter();
				tmr.destroy();
			});

            introTimer = new FlxTimer().start(6.20, function(tmr:FlxTimer)
            {
                skipIntro();
            });
        }
        else
        {
            showMenu();
        }

	}

    function skipIntro()
    {
        introTimer.destroy();
		FlxG.camera.flash(FlxColor.WHITE, 3);
		introText.destroy();
		firstTime = false;
		showMenu();
    }

    function showMenu()
    {
		skippedIntro = true;

		#if ng
		trace("NGio is active");

		var ng:NGio = new NGio(APIKeys.AppID, APIKeys.EncKey, FlxG.save.data.sessionID);
		#end

		var logo:FlxSprite = new FlxSprite(0, 20).loadGraphic("assets/images/logo.png");
		logo.screenCenter(X);
		logo.antialiasing = true;
		add(logo);

        #if ng
		versionTxt = new FlxText(0, (FlxG.height - 20), 0, "v" + GameInfo.gameVer + " [Not logged in (NG)]", 14);
        #else
		versionTxt = new FlxText(0, (FlxG.height - 20), 0, "v" + GameInfo.gameVer, 14);
        #end
		add(versionTxt);

		GameInfo.getLatestVersion();

		for (i in 0...menuOptions.length)
		{
			var menuText:FlxText = new FlxText(0, (i * 60), 0, menuOptions[i], 32);
			menuText.y += 280;
			menuText.screenCenter(X);
			menuText.ID = i;
			menuGroup.add(menuText);
		}

		for (i in 0...diffArray.length)
		{
			var diffText:FlxText = new FlxText((i * 120), 410, 0, diffArray[i], 28);
			diffText.x += 130;
			diffText.ID = i;
			diffGroup.add(diffText);
		}

		changeSelection(0, true);
		changeDiff(0, true);
    }

	override public function update(elapsed:Float)
	{
        if (skippedIntro)
        {
            #if ng
                if (NGio.loggedIn)
				    //versionTxt.text = " + NG.core.user.name + ";
				    versionTxt.text = GameInfo.gameVer + " [Logged in (NG)]";
                else
				    versionTxt.text = GameInfo.gameVer + " [Not logged in (NG)]";
            #end

            if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic("assets/music/title/title" + GameInfo.audioExtension, 0.7);

            if (FlxG.keys.anyJustPressed([UP, W]))
                changeSelection(-1);

            if (FlxG.keys.anyJustPressed([DOWN, S]))
                changeSelection(1);

            if (FlxG.keys.anyJustPressed([LEFT, A]))
                changeDiff(-1);

            if (FlxG.keys.anyJustPressed([RIGHT, D]))
                changeDiff(1);

            if (FlxG.keys.justPressed.ENTER)
            {
                /*
                GameInfo.gameDifficulty = curDifficulty;
                GameInfo.adjustByDiff();

                trace("SWAG BOY: " + GameInfo.gameDifficulty);
                FlxG.switchState(new PlayState());
                */

                goToState();
            }
		}
        else
        {
				if (FlxG.keys.justPressed.ENTER)
				{
					skipIntro();
				}
        }

		super.update(elapsed);
	}

    function changeDiff(change:Int = 0, ?noSound:Bool = false)
    {
		if (!noSound)
			FlxG.sound.play("assets/sounds/select" + GameInfo.audioExtension);

        curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		diffGroup.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curDifficulty)
			{
				txt.color = FlxColor.YELLOW;
			}
		});
    }

    function changeSelection(change:Int = 0, ?noSound:Bool = false)
    {
        if (!noSound)
		    FlxG.sound.play("assets/sounds/select" + GameInfo.audioExtension);

        curSelected += change;

        if (curSelected < 0)
            curSelected = 1;
        if (curSelected > 1)
            curSelected = 0;

        menuGroup.forEach(function(txt:FlxText)
        {
            txt.color = FlxColor.WHITE;

            if (txt.ID == curSelected)
            {
                txt.color = FlxColor.YELLOW;
            }
        });
    }

    function goToState()
    {
        // defaults to playstate
        var state:FlxState = new PlayState();

        switch (curSelected)
        {
            case 0:
                FlxG.sound.music.stop();

				GameInfo.gameDifficulty = curDifficulty;
				GameInfo.adjustByDiff();

                state = new PlayState();

            case 1:
                state = new OptionsState();
        }

        FlxG.switchState(state);
    }
}