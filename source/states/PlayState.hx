package states;

import utils.Difficulty;
import utils.Language;
import flixel.group.FlxSpriteGroup;
import props.hud.ScoreTracker;
import flixel.tweens.FlxTween;
import props.hud.LifeHUD;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;

import props.Bullet;
import props.Player;
import props.NowPlaying;

import utils.HelperFunctions;
import utils.Score;
import utils.GameInfo;
#if ng
import utils.NGio;
#end

class LayeredBackground extends FlxSpriteGroup
{
	public var onTweenComplete:Void->Void;

	public var previousDiff:Int = 0;

	public var backgroundSprites:Array<Dynamic> = [];
	public var background:FlxSprite;

	public function new(X:Float, Y:Float, curDiff:Int, prefix:String, max:Int)
	{
		super(X, Y);

		previousDiff = curDiff;

		for (i in 0...max)
		{
			var background:FlxSprite = new FlxSprite(X, Y);
			background.loadGraphic("assets/images/" + prefix + i + ".png");
			background.ID = i;

			backgroundSprites.push(background);
		}

		background = new FlxSprite(X, Y).loadGraphicFromSprite(backgroundSprites[previousDiff]);
		add(background);
	}

	public function transition(newDiff:Int)
	{
		// we create a temp bg so we can do a cool lookin transition
		var tempBG:FlxSprite = new FlxSprite(x, y).loadGraphicFromSprite(backgroundSprites[previousDiff]);
		add(tempBG);

		if (newDiff < backgroundSprites.length - 1)
			background.loadGraphicFromSprite(backgroundSprites[newDiff]);
		else
			background.loadGraphicFromSprite(backgroundSprites[backgroundSprites.length - 1]);

		previousDiff = newDiff;

		FlxTween.tween(tempBG, {alpha: 0}, 1.75, {onComplete: function(t:FlxTween)
		{
			//FlxG.log.add("im like done");
			remove(tempBG);
			onTweenComplete();
		}});
	}
}

class PlayState extends BeatState
{
	public static var instance:PlayState;

	public static var aliveTimeStart:Float = 0;
	public static var aliveTimeEnd:Float = 0;
	public static var finalTime:Float = 0;

	public static var spawnTimer:FlxTimer;

	public static var destroyedDonuts:Int = 0;

	var maxX:Float = 0;

	public static var score:Score;
	public static var finalScore:Int = 0;

	var diffTransition:Bool = false;
	var layerBG:LayeredBackground;

	public static var player:Player;

	var bullets:FlxTypedGroup<Bullet>;

	var nowPlaying:NowPlaying;

	var diffText:FlxText;
	var lifeHUD:LifeHUD;
	var scoreText:FlxText;

	// POWERUP STUFF
	// SPEED BOOST
	var speedBar:FlxBar;

	var regen:Bool = false;
	var maxBoost:Int = 5;
	var boostTime:Float = 5;

	var scoreTracker:ScoreTracker;

	override public function create()
	{
		instance = this;

		//Difficulty.init();
		Difficulty.currentDifficulty = Easy;
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		if (FlxG.sound.music.playing)
			FlxG.sound.music.stop();

		layerBG = new LayeredBackground(0, 0, GameInfo.curDifficulty, "bg", 4);
		add(layerBG);

		bullets = new FlxTypedGroup<Bullet>();
		add(bullets);

		score = new Score();

		player = new Player();
		player.screenCenter();
		player.y += 150;
		add(player);

		maxX = FlxG.width - player.width;

		initPowerup();

		nowPlaying = new NowPlaying();
		add(nowPlaying);

		lifeHUD = new LifeHUD(3.5, 7.5, GameInfo.equippedPowerup);
		lifeHUD.updateLives(player.lives);
		add(lifeHUD);

		scoreText = new FlxText(5, 0, 0, '${Language.data.PlayState.score}: 0', 16);
		scoreText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
		scoreText.y = (lifeHUD.y + scoreText.height) * 2;
		add(scoreText);

		diffText = new FlxText(0, 80, FlxG.width, "", 22);
		diffText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
		diffText.alpha = 0;
		diffText.screenCenter(X);
		add(diffText);

		FlxG.watch.addQuick("curPoints", FlxG.save.data.points);

		spawnTimer = new FlxTimer().start(Difficulty.settings.donutSpawnTime, 
			function(tmr:FlxTimer)
			{
				var donutType:Int = 0;
				var randomOffset:Int = FlxG.random.int(0, -75);

				if (GameInfo.curDifficulty > 1)
				{
					if (FlxG.random.bool(70))
						donutType = 1;
					if (FlxG.random.bool(40))
						donutType = 1;
					if (FlxG.random.bool(25))
						donutType = 1;
				}

				var bullet:Bullet = new Bullet(FlxG.random.int(0, 640), FlxG.save.data.scrollType == 0 ? randomOffset : Math.abs(randomOffset), donutType);
				bullets.add(bullet);
			}, 
		0);

		scoreTracker = new ScoreTracker(15, 120);
		add(scoreTracker);

		aliveTimeStart = Sys.time();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		aliveTimeEnd = Sys.time();
		finalTime = aliveTimeEnd - aliveTimeStart;

		FlxG.watch.addQuick('donutsDestroyed', destroyedDonuts);
		FlxG.watch.addQuick('elapsedTime', HelperFunctions.truncateFloat(finalTime, 2));
		FlxG.watch.addQuick('activeTimer', spawnTimer.active);

		updatePowerup();
		checkDifficultyChange();

		finalScore = score.calculateScore(HelperFunctions.truncateFloat(finalTime, 2), score.donutHits, score.reachedInsane, score.xpDonutHits);
		scoreText.text = '${Language.data.PlayState.score}: ' + finalScore;
		
		//bullets.forEach(function(b:Bullet){b.velocity.y = Difficulty.settings.donutVelocity;});
		spawnTimer.time = HelperFunctions.truncateFloat(Difficulty.settings.donutSpawnTime, 2);

		if (!FlxG.sound.music.playing)
			nowPlaying.playSong();

		//aliveTime += elapsed;

		if (player.x >= maxX)
			player.x = maxX;

		if (player.x <= 0)
			player.x = 0;

		if (FlxG.keys.justPressed.ENTER)
		{
			initSubstate(new PauseSubstate());
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new DebugState());
		}

		#if debug
		if (FlxG.keys.justPressed.NINE)
		{
			FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
		}
		#end

		bullets.forEachAlive(function(bullet:Bullet)
		{
			if (!bullet.isOnScreen(FlxG.camera) && bullet.y > 480)
			{
				bullet.kill();
				bullets.remove(bullet);
				bullet.destroy();
				destroyedDonuts++;
			}

			if (FlxG.collide(player, bullet))
			{
				donutHit(bullet, bullet.donutType);
			}
		});

		super.update(elapsed);
	}

	public function initSubstate(substate:FlxSubState)
	{
		super.openSubState(substate);
	}

	function donutHit(donut:Bullet, donutType:Int)
	{
		donut.kill();
		bullets.remove(donut);
		donut.destroy();

		switch (donutType)
		{
			case 0:
				FlxG.sound.play("assets/sounds/hit" + GameInfo.audioExtension);

				player.lives -= 1;
				score.donutHits++;

				lifeHUD.updateLives(player.lives);
				player.animation.play("dead");

				FlxG.camera.shake(0.0075, 0.25);
				if (player.lives > 0)
				{
					new FlxTimer().start(0.25, function(tmr:FlxTimer)
					{
						player.animation.play("idle");
					});
				}

			case 1:
				FlxG.sound.play("assets/sounds/hit" + GameInfo.audioExtension);

				player.lives -= 2;
				score.donutHits++;

				lifeHUD.updateLives(player.lives);
				player.animation.play("dead");

				FlxG.camera.shake(0.0025, 0.25);
				if (player.lives > 0)
				{
					new FlxTimer().start(0.25, function(tmr:FlxTimer)
					{
						player.animation.play("idle");
					});
				}

			case 2:
				score.xpDonutHits++;
				scoreTracker.showScore(Language.data.PlayState.xp_donut_hit, 15);

			case 3:
				FlxG.sound.play("assets/sounds/regen" + GameInfo.audioExtension);

				var maxLives:Int = 3;
				if (GameInfo.equippedPowerup == 0)
					maxLives = 4;

				if (player.lives < maxLives)
				{
					player.lives += 1;
					lifeHUD.updateLives(player.lives);
				}

				player.animation.play("regen");

				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					player.animation.play("idle");
				});
		}

		if (player.lives <= 0)
		{
			initSubstate(new GameOverSubstate());
		}
	}

	function checkDifficultyChange()
	{
		if (!diffTransition)
		{
			if (HelperFunctions.truncateFloat(finalTime, 2) >= 5 && HelperFunctions.truncateFloat(finalTime, 2) <= 10)
				startCurveDifficulty(0);

			if (HelperFunctions.truncateFloat(finalTime, 2) >= 60 && HelperFunctions.truncateFloat(finalTime, 2) <= 65)
				startCurveDifficulty(1);

			if (HelperFunctions.truncateFloat(finalTime, 2) >= 180 && HelperFunctions.truncateFloat(finalTime, 2) <= 185)
				startCurveDifficulty(2);

			if (HelperFunctions.truncateFloat(finalTime, 2) >= 480 && HelperFunctions.truncateFloat(finalTime, 2) <= 10)
				startCurveDifficulty(3);
		}
	}

	function startCurveDifficulty(diff:Int)
	{
		diffTransition = true;

		// 0 - EASY, 1 - NORMAL, 2 - HARD, 3 - INSANE
		switch (diff)
		{
			case 0:
				GameInfo.curDifficulty = 0;
				//GameInfo.bulletMoveVelocity = 80;
				//GameInfo.bulletTimerTime = 0.55;

				changeDiffText(Language.data.PlayState.diff_text[0]);
			case 1:
				GameInfo.curDifficulty = 1;
				//GameInfo.bulletMoveVelocity = 140;
				//GameInfo.bulletTimerTime = 0.30;

				changeDiffText(Language.data.PlayState.diff_text[1]);

			case 2:
				GameInfo.curDifficulty = 2;
				//GameInfo.bulletMoveVelocity = 175;
				//GameInfo.bulletTimerTime = 0.10;

				changeDiffText(Language.data.PlayState.diff_text[2]);

			case 3:
				#if ng
				if (NGio.loggedIn)
				{
					NGio.unlockMedal(65993);
				}
				#end

				GameInfo.curDifficulty = 3;
				//GameInfo.bulletMoveVelocity = 200;
				//GameInfo.bulletTimerTime = 0.05;

				score.reachedInsane++;

				changeDiffText(Language.data.PlayState.diff_text[3]);
		}

		layerBG.transition(diff);
		layerBG.onTweenComplete = function() { diffTransition = false; }
	}

	function changeDiffText(text:String)
	{
		diffText.text = text;
		diffText.screenCenter(X);
		diffText.alignment = FlxTextAlign.CENTER;
		FlxTween.tween(diffText, {alpha: 1.0}, 1.25, {onComplete: function(tween:FlxTween) 
		{
			new FlxTimer().start(5, function(tmr:FlxTimer)
			{
				FlxTween.tween(diffText, {alpha: 0}, 1.25);
			});
		}});
	}

	var boostCharging:Bool = false;

	function updatePowerup()
	{
		if (GameInfo.equippedPowerup != Std.int(Math.NEGATIVE_INFINITY))
		{
			switch (GameInfo.equippedPowerup)
			{
				case 1:
					if (boostTime < 0)
						boostTime = 0;

					if (FlxG.keys.pressed.SHIFT && !boostCharging)
					{
						if (boostTime > 0)
							player.boosted = true;
						else
							player.boosted = false;

						boostTime -= 0.04;
					}
					else
					{
						player.boosted = false;

						if (boostTime <= 5)
						{
							boostCharging = true;
							boostTime += 0.02;
						}
						else
						{
							boostCharging = false;
						}
					}
			}
		}
	}

	function initPowerup():Void
	{
		if (GameInfo.equippedPowerup != Std.int(Math.NEGATIVE_INFINITY))
		{
			switch (GameInfo.equippedPowerup)
			{
				case 0:
					trace("4 lives");
					player.lives++;

				case 1:
					trace("speed boost");
					
					var barBackground:FlxSprite = new FlxSprite(10, FlxG.height - 65).loadGraphic("assets/images/hud/powerups/bar.png");
					barBackground.alpha = 0.6;
					add(barBackground);

					speedBar = new FlxBar(barBackground.x + 9, barBackground.y + 9, FlxBarFillDirection.LEFT_TO_RIGHT, 120, 32, this, "boostTime", 0, maxBoost);
					speedBar.createFilledBar(FlxColor.TRANSPARENT, 0xFFFFFFFF);
					speedBar.alpha = 0.6;
					add(speedBar);
			}
		}
		else
		{
			trace("NO POWERUP");
		}
	}
}
