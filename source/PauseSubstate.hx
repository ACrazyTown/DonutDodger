package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;

import props.NowPlaying;

import utils.GameInfo;

class PauseSubstate extends FlxSubState
{
    var pauseOptions:Array<String> = ["Resume", "Reset the Stage", "Return to the Menu"];
    var pauseTxtGroup:FlxTypedGroup<FlxText>;

    var curSelected:Int = 0;

    var pausedMusic:Bool = false;

    public function new()
    {   
        super();

        FlxG.sound.play("assets/sounds/pause" + GameInfo.audioExtension);

		PlayState.spawnTimer.active = false;

        if (NowPlaying.activeTimer)
            NowPlaying.tweenTimer.active = false;

        if (NowPlaying.playingMusic)
            FlxG.sound.music.pause();
            pausedMusic = true;

        var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.alpha = 0.7;
        add(overlay);

		pauseTxtGroup = new FlxTypedGroup<FlxText>();
		add(pauseTxtGroup);

        var pausedTxt:FlxText = new FlxText(0, 120, 0, "PAUSED", 42);
        pausedTxt.screenCenter(X);
        add(pausedTxt);

        // pausedTxt.y + 140
        for (i in 0...pauseOptions.length)
        {
			var controlsTxt:FlxText = new FlxText(0, (i * 40), 0, pauseOptions[i], 24);
            controlsTxt.ID = i;
            controlsTxt.y += pausedTxt.y + 140;
			controlsTxt.screenCenter(X);
			pauseTxtGroup.add(controlsTxt);
        }

        changeSelection(0, true);
    }

    override function update(elapsed:Float)
    {
		if (FlxG.keys.anyJustPressed([UP, W]))
			changeSelection(-1);

		if (FlxG.keys.anyJustPressed([DOWN, S]))
			changeSelection(1);

		if (FlxG.keys.justPressed.ENTER) 
        {
            doOption();
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

		pauseTxtGroup.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
			{
				txt.color = FlxColor.YELLOW;
			}
		});   
    }

    function doOption()
    {
        switch (curSelected)
        {
            case 0:
				PlayState.spawnTimer.active = true;

				if (!NowPlaying.tweenTimer.active)
					NowPlaying.tweenTimer.active = true;

                if (pausedMusic)
                    FlxG.sound.music.resume();

                close();
            case 1:
                FlxG.resetState();
            case 2:
                FlxG.switchState(new TitleState());
        }
    }
}