package;

import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import props.NowPlaying;
import props.Player;
import utils.APIKeys;
import utils.GameInfo;
import utils.HelperFunctions;
#if ng
import utils.NGio;
#end

class GameOverSubstate extends FlxSubState
{
	var controlsArray:Array<String> = ["Play Again", "Return to the Menu"];
	var controlsTxtGroup:FlxTypedGroup<FlxText>;

    public var aliveTimeTruncated = HelperFunctions.truncateFloat(PlayState.aliveTime, 2);

	var pausedMusic:Bool = false;

	var scoreText:FlxText;

	var displayScore:Int = 0;
	var curSelected:Int = 0;

	public function new()
	{
		super();

		//persistentUpdate = false;

		FlxG.sound.play("assets/sounds/gameover" + GameInfo.audioExtension);

        PlayState.spawnTimer.destroy();
		PlayState.player.playAnim('dead');

		//if (NowPlaying.activeTimer)
		//	NowPlaying.tweenTimer.active = false;

		if (FlxTimer.globalManager.active)
            FlxTimer.globalManager.active = false;

		if (NowPlaying.playingMusic)
			FlxG.sound.music.pause();
			pausedMusic = true;

		if (FlxG.save.data.bestTime == 0 || aliveTimeTruncated > FlxG.save.data.bestTime)
        {
            saveBestTime(aliveTimeTruncated);
        }

		savePoints(Std.int(PlayState.finalScore / 10));

		#if ng
		if (NGio.loggedIn)
		{
			// posts score

			// default is normal
			var timeBoard = APIKeys.timeLeaderboard;
			var pointBoard = APIKeys.pointsLeaderboard;

			//NGio.postScore(leaderboard, aliveTimeTruncated);
			NGio.postScore(timeBoard, aliveTimeTruncated);
			NGio.postScore(pointBoard, FlxG.save.data.points);

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

        var surviveText:FlxText = new FlxText(0, gameOverTxt.y + 80, 0, "You survived for " + aliveTimeTruncated + "s!", 26);
        surviveText.screenCenter(X);
        add(surviveText);

		//var scoreText:FlxText = new FlxText(0, gameOverTxt.y + 120, 0, "Score: " + PlayState.finalScore, 24);
		scoreText = new FlxText(0, gameOverTxt.y + 120, 0, "Score: ", 24);
		scoreText.screenCenter(X);
		add(scoreText);

		var bestText:FlxText = new FlxText(0, gameOverTxt.y + 160, 0, "Best Time: " + FlxG.save.data.bestTime + "s", 20);
		bestText.screenCenter(X);
		add(bestText);

		//var debug:FlxText = new FlxText(20, FlxG.height - 40, 0, "Points gained: " + Std.int(PlayState.finalScore / 10), 24);
		//debug.color = FlxColor.RED;
		//add(debug);

		// var controlsTxt:FlxText = new FlxText(0, gameOverTxt.y + 180, 0, "Press ENTER to play again\n" + "Or ESC to return to the Menu", 24);

		for (i in 0...controlsArray.length)
		{
			var controlsTxt:FlxText = new FlxText(0, (i * 40), 0, controlsArray[i], 24);
			controlsTxt.y += gameOverTxt.y + 220;
			controlsTxt.ID = i;
			controlsTxt.screenCenter(X);
			controlsTxtGroup.add(controlsTxt);
		}

		changeSelection(0, true);
	}

	override function update(elapsed:Float)
	{
		//PlayState.score.updateDisplayScore(PlayState.finalScore);
		updateScore();
		updateScoreText();

		/*
		if (FlxG.keys.justPressed.ENTER)
		{
			doOption();
		}

		if (FlxG.keys.anyJustPressed([UP, W]))
			changeSelection(-1);

		if (FlxG.keys.anyJustPressed([DOWN, S]))
			changeSelection(1);
		*/
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
		if (!FlxTimer.globalManager.active)
			FlxTimer.globalManager.active = true;

		switch (curSelected)
		{
			case 0:
				/*
				if (!NowPlaying.tweenTimer.active)
					NowPlaying.tweenTimer.active = true;
				*/

				FlxG.resetState();

			case 1:
				trace("I REAALY SHOULD TRANSITION RN");
				FlxG.switchState(new TitleState());
		}
	}

    function saveBestTime(time:Float)
    {
        FlxG.save.data.bestTime = time;
        FlxG.save.flush();
    }

	function savePoints(score:Int)
	{
		FlxG.save.data.points += score;
		FlxG.save.flush();
	}

	function updateScore()
	{
		if (displayScore > PlayState.finalScore)
		{
			displayScore = PlayState.finalScore;
		}

		if (displayScore != PlayState.finalScore)
		{
			trace("SCORE LENGTH LOL: " + Std.string(PlayState.finalScore).length);
			
			FlxG.sound.play("assets/sounds/score" + GameInfo.audioExtension, 0.7);

			// I KNOW THIS IS SHIT CODE BUT I DONT KNOW HWO TO MAKE IT BETTER
			//TODO: Replace this weird code block with FlxMath.lerp? Dynamically decide how much time it's gonna take through math??
			//TODO PART 2: I tried doing some weird Math shit but it didn't work, I'll probably revisit this
			
			if (PlayState.finalScore >= 10000000)
				displayScore += 100005;

			else if (PlayState.finalScore >= 1000000)
				displayScore += 10005;

			else if (PlayState.finalScore >= 100000)
				displayScore += 755;

			else if (PlayState.finalScore >= 10000)
				displayScore += 105;

			else if (PlayState.finalScore >= 1000)
				displayScore += 25;
			else
				displayScore += 5;

			//displayScore += 5;
			//displayScore += Math.floor(Std.string(PlayState.finalScore).length / 40);
		}
	}
	
	function updateScoreText()
	{
		scoreText.text = "Score: " + displayScore;
		scoreText.screenCenter(X);
	}

	/*
	function getBestTime(finalTime:Float)
	{
		var bestTime = FlxG.save.data.bestTime;

		if (bestTime == null || finalTime > bestTime)
			bestTime = finalTime;

		FlxG.save.flush();
		return bestTime;
	}
	*/
}