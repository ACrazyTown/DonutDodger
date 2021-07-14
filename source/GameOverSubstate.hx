package;

import utils.APIKeys;
#if ng
import utils.NGio;
#end

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;

import utils.HelperFunctions;
import utils.GameInfo;

import props.NowPlaying;
import props.Player;

class GameOverSubstate extends FlxSubState
{
	var controlsArray:Array<String> = ["Play Again", "Return to the Menu"];
	var controlsTxtGroup:FlxTypedGroup<FlxText>;

    public var aliveTimeTruncated = HelperFunctions.truncateFloat(PlayState.aliveTime, 2);

	var pausedMusic:Bool = false;

	var curSelected:Int = 0;

	public function new()
	{
		super();

		FlxG.sound.play("assets/sounds/gameover" + GameInfo.audioExtension);

        PlayState.spawnTimer.destroy();
		PlayState.player.playAnim('dead');

		if (NowPlaying.activeTimer)
			NowPlaying.tweenTimer.active = false;

		if (NowPlaying.playingMusic)
			FlxG.sound.music.pause();
			pausedMusic = true;

		if (FlxG.save.data.bestTime == 0 || aliveTimeTruncated > FlxG.save.data.bestTime)
        {
            saveBestTime(aliveTimeTruncated);
        }

		#if ng
		if (NGio.loggedIn)
		{
			// posts score

			// default is normal
			var leaderboard = APIKeys.leaderboardNormal;

			switch (GameInfo.gameDifficulty)
			{
				case 0:
					leaderboard = APIKeys.leaderboardEasy;
				case 1:
					leaderboard = APIKeys.leaderboardNormal;
				case 2:
					leaderboard = APIKeys.leaderboardHard;
			}

			NGio.postScore(leaderboard, aliveTimeTruncated);

			if (aliveTimeTruncated >= 69420.00)
				NGio.unlockMedal(63898);
		}
		#end

		var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0.7;
		add(overlay);

		controlsTxtGroup = new FlxTypedGroup<FlxText>();
		add(controlsTxtGroup);

		var gameOverTxt:FlxText = new FlxText(0, 110, 0, "GAME OVER", 42);
		gameOverTxt.screenCenter(X);
		add(gameOverTxt);

        var surviveText:FlxText = new FlxText(0, gameOverTxt.y + 100, 0, "You survived for " + aliveTimeTruncated + "s!", 26);
        surviveText.screenCenter(X);
        add(surviveText);

		var bestText:FlxText = new FlxText(0, gameOverTxt.y + 140, 0, "Best Time: " + FlxG.save.data.bestTime + "s", 20);
		bestText.screenCenter(X);
		add(bestText);

		// var controlsTxt:FlxText = new FlxText(0, gameOverTxt.y + 180, 0, "Press ENTER to play again\n" + "Or ESC to return to the Menu", 24);

		for (i in 0...controlsArray.length)
		{
			var controlsTxt:FlxText = new FlxText(0, (i * 40), 0, controlsArray[i], 24);
			controlsTxt.y += gameOverTxt.y + 180;
			controlsTxt.ID = i;
			controlsTxt.screenCenter(X);
			controlsTxtGroup.add(controlsTxt);
		}

		changeSelection(0, true);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			doOption();
		}

		if (FlxG.keys.anyJustPressed([UP, W]))
			changeSelection(-1);

		if (FlxG.keys.anyJustPressed([DOWN, S]))
			changeSelection(1);
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

		controlsTxtGroup.forEach(function(txt:FlxText)
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
				if (!NowPlaying.tweenTimer.active)
					NowPlaying.tweenTimer.active = true;

				if (pausedMusic)
					FlxG.sound.music.resume();

				FlxG.resetState();
			case 1:
				FlxG.switchState(new TitleState());
		}
	}

    function saveBestTime(time:Float)
    {
        FlxG.save.data.bestTime = time;
        FlxG.save.flush();
    }
}