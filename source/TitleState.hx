package;

import lime.app.Application;
import flixel.effects.FlxFlicker;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.TransitionData;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import utils.Conductor;
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

import props.Background;

class TitleState extends BeatState
{
	public static var ngMessage:String = "";
    public static var firstTime:Bool = true;
	public static var versionTxt:FlxText;

    var init:Bool = false;
    var skippedIntro:Bool = false;

	var curSelected:Int = 0;
    var curDifficulty:Int = 1;

    var transitioning:Bool = false;

    var menuOptions:Array<String> = ["PLAY", "OPTIONS", "SHOP"];
    var menuGroup:FlxTypedGroup<FlxText>;

    var resetHold:Bool = false;
    var resetTimer:Float = 0;

    var introText:FlxText;

	override public function create()
	{
		FlxG.mouse.visible = false;
        FlxG.save.bind("donutdodger", "acrazytown");

		if (!Global.titleInit)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.4, new FlxPoint(0, -1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.4, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

            GameInfo.initSave();

            #if ng
            trace("NGio is active");

            var ng:NGio = new NGio(APIKeys.AppID, APIKeys.EncKey, FlxG.save.data.sessionID);
            #end

			Global.titleInit = true;
		}

		versionTxt = new FlxText(0, (FlxG.height - 20), 0, "", 14);

		#if ng
        trace(NGio.loggedIn);

        if (NGio.loggedIn)
        {
            versionTxt.text = "v" + GameInfo.gameVer + " [Logged in]";
        }
		else
		{
            versionTxt.text = "v" + GameInfo.gameVer + " [Not logged in]";
        }
        #else
		versionTxt.text = "v" + GameInfo.gameVer + "";
        #end

        trace("DUMBASS: " + FlxG.save.data.points);

        #if ng
		if (NGio.loggedIn)
		{
			var pointBoard = APIKeys.pointsLeaderboard;
			NGio.postScore(pointBoard, FlxG.save.data.points);
		}
		#end

        switch (GameInfo.verType)
        {
            case 1:
              versionTxt.text += " [OUTDATED]";
        }

        if (firstTime)
        {
			Conductor.changeBPM(150);

			FlxG.sound.playMusic("assets/music/title/title" + GameInfo.audioExtension, 0.7);
			FlxG.sound.music.onComplete = () ->
			{
				resetValues();
			}

            if (!GameInfo.gotLatestVer)
			    GameInfo.getLatestVersion();

            introText = new FlxText(0, 0, 0, "A Crazy Town\n presents", 28);
            introText.alignment = FlxTextAlign.CENTER;
            introText.screenCenter();
            add(introText);
        }
        else
        {
            showMenu();
        }

		super.create();
	}

    function skipIntro()
    {
		FlxG.camera.flash(FlxColor.WHITE, 3);
		introText.destroy();
		firstTime = false;
		showMenu();
    }

    function showMenu()
    {
		skippedIntro = true;

		var bg:Background = new Background(-5.5, -25.8, "assets/images/bg/background.png");
		bg.addAdditionalImageAssets([[-11.35, -53.15]], [['assets/images/bg/circles.png']]);
		bg.tweenAsset(bg.additionalAssets[0], {y: -836.55}, 35, null, true);
		add(bg);

		menuGroup = new FlxTypedGroup<FlxText>();
		add(menuGroup);

		var logo:FlxSprite = new FlxSprite(0, 20).loadGraphic("assets/images/logo.png");
		logo.screenCenter(X);
		logo.antialiasing = true;
		add(logo);

		add(versionTxt);

		for (i in 0...menuOptions.length)
		{
			var menuText:FlxText = new FlxText(0, (i * 70), 0, menuOptions[i], 32);
			menuText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
			menuText.y += 280;
			menuText.screenCenter(X);
			menuText.ID = i;
			menuGroup.add(menuText);
		}

		changeSelection(0, true);
    }

	override public function update(elapsed:Float)
	{
        #if ng
        if (NGio.loggedIn)
        {
            versionTxt.text = "v" + GameInfo.gameVer + " [Logged in]";
        }
		else
		{
            versionTxt.text = "v" + GameInfo.gameVer + " [Not logged in]";
        }
        #else
		versionTxt.text = "v" + GameInfo.gameVer + "";
        #end

        if (skippedIntro)
        {
            if (!FlxG.sound.music.playing)
            {
                if (Conductor.bpm != 150)
				    Conductor.changeBPM(150);

				FlxG.sound.playMusic("assets/music/title/title" + GameInfo.audioExtension, 0.7);
                FlxG.sound.music.onComplete = () ->
                {
                    resetValues();
                }
            }

            if (FlxG.keys.anyJustPressed([UP, W]))
                changeSelection(-1);

            if (FlxG.keys.anyJustPressed([DOWN, S]))
                changeSelection(1);

            if (FlxG.keys.justPressed.ENTER && !transitioning)
            {
                transitioning = true;

                goToState();
            }

            /*
            if (FlxG.keys.pressed.DELETE && !resetHold)
            {
                resetHold = true;
                resetTimer += elapsed;

                if (resetTimer >= 3)
                    trace("SHOULD'VE RESET DATA!");
                    new FlxTimer().start(2, function(t:FlxTimer) 
                    {
                        resetHold = false;
                    }); // 2s cooldown so that it doesn't erase data in a loop
            }
            else {
                resetTimer = 0;
            }
            */
		}
        else
        {
            if (FlxG.keys.justPressed.ENTER)
            {
                skipIntro();
            }
        }

		Conductor.songPosition = FlxG.sound.music.time;

		everyStep();
		everyBeat();

		super.update(elapsed);
	}

    override function customBeatHit():Void
    {
        FlxG.log.add(curBeat);

        if (!skippedIntro)
        {
            switch (curBeat)
            {
                case 4:
                    introText.text = "DingDongDirt by\n Dorbellprod";
                
                case 8:
                    introText.text = "Newgrounds is\n Swag and Awesome";

                case 12:
                    introText.text = "AAA Gameplay\n -Literally Everyone";

                case 16:
                    skipIntro();
            }

            introText.screenCenter();
        }
    }

    function changeSelection(change:Int = 0, ?noSound:Bool = false)
    {
        if (!noSound)
		    FlxG.sound.play("assets/sounds/select" + GameInfo.audioExtension);

        curSelected += change;

        if (curSelected < 0)
            curSelected = 2;
        if (curSelected > 2)
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
        var state:FlxState = new PlayState();

        FlxG.sound.play("assets/sounds/confirm" + GameInfo.audioExtension);

        for (item in menuGroup)
        {
            if (item.ID != curSelected)
            {
                FlxTween.tween(item, {alpha: 0, y: item.y + 15}, 1, {ease: FlxEase.quadOut});
            }
        }

        switch (curSelected)
        {
            case 0:
                state = new PlayState();

            case 1:
                state = new OptionsState();

            case 2:
                state = new ExtrasState.ShopState();
        }

        new FlxTimer().start(1.25, function(t:FlxTimer) 
        {
            FlxG.switchState(state);
        });
    }
}