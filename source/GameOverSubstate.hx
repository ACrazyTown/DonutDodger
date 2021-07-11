package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;

import utils.HelperFunctions;
import utils.GameInfo;

import props.NowPlaying;

class GameOverSubstate extends FlxSubState
{
    var aliveTimeTruncated = HelperFunctions.truncateFloat(PlayState.aliveTime, 2);

	var pausedMusic:Bool = false;

	public function new()
	{
		super();

		FlxG.sound.play("assets/sounds/gameover" + GameInfo.audioExtension);

        PlayState.spawnTimer.destroy();

		if (NowPlaying.activeTimer)
			NowPlaying.tweenTimer.active = false;

		if (NowPlaying.playingMusic)
			FlxG.sound.music.pause();
			pausedMusic = true;

		if (FlxG.save.data.bestTime == 0 || aliveTimeTruncated > FlxG.save.data.bestTime)
        {
            saveBestTime(aliveTimeTruncated);
        }

		var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0.7;
		add(overlay);

		var gameOverTxt:FlxText = new FlxText(0, 110, 0, "GAME OVER", 42);
		gameOverTxt.screenCenter(X);
		add(gameOverTxt);

        var surviveText:FlxText = new FlxText(0, gameOverTxt.y + 100, 0, "You survived for " + aliveTimeTruncated + "s!", 26);
        surviveText.screenCenter(X);
        add(surviveText);

		var bestText:FlxText = new FlxText(0, gameOverTxt.y + 140, 0, "Best Time: " + FlxG.save.data.bestTime + "s", 20);
		bestText.screenCenter(X);
		add(bestText);

		var controlsTxt:FlxText = new FlxText(0, gameOverTxt.y + 180, 0, "Press ENTER to play again\n" + "Or ESC to return to the Menu", 24);
		controlsTxt.alignment = FlxTextAlign.CENTER;
		controlsTxt.screenCenter(X);
		add(controlsTxt);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			if (!NowPlaying.tweenTimer.active)
				NowPlaying.tweenTimer.active = true;

			if (pausedMusic)
				FlxG.sound.music.resume();

			FlxG.resetState();
		}

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new TitleState());
        }
	}

    function saveBestTime(time:Float)
    {
        FlxG.save.data.bestTime = time;
        FlxG.save.flush();
    }
}