package;

import props.NowPlaying;
import flixel.FlxSubState;
import utils.GameInfo;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.util.FlxCollision;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;

import props.Bullet;
import props.Player;
import props.SongPopup;

import utils.HelperFunctions;

class PlayState extends FlxState
{
	public static var aliveTime:Float;
	public static var spawnTimer:FlxTimer;

	public static var destroyedDonuts:Int;

	public static var player:Player;

	var bullets:FlxTypedGroup<Bullet>;

	var nowPlaying:NowPlaying;

	override public function create()
	{
		aliveTime = 0;
		destroyedDonuts = 0;

		FlxG.worldBounds.set(0, 0);

		GameInfo.initSave();

		super.create();

		var bg:FlxSprite = new FlxSprite().loadGraphic("assets/images/space.png");
		add(bg);

		bullets = new FlxTypedGroup<Bullet>();
		add(bullets);

		player = new Player(0, 0);
		player.screenCenter();

		player.y += 150;
		add(player);

		nowPlaying = new NowPlaying();
		add(nowPlaying);

		spawnBullets();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!FlxG.sound.music.playing)
			nowPlaying.playSong();

		aliveTime += elapsed;
		// thy shall not escape
		// for some reason it's not 640 ????? so confused

		if (player.x >= 608)
			player.x = 608;

		if (player.x <= 0)
			player.x = 0;

		if (FlxG.keys.justPressed.ENTER)
		{
			initSubstate(new PauseSubstate());
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (FlxG.debugger.drawDebug)
				FlxG.debugger.drawDebug = false;
			else
				FlxG.debugger.drawDebug = true;
		}

		bullets.forEachAlive(function(bullet:Bullet)
		{
			if (!bullet.isOnScreen(FlxG.camera) && bullet.y > 480)
			{
				//trace("killed a bullet lmao");
				bullet.kill();
				destroyedDonuts++;
			}

			if (FlxG.collide(player, bullet))
			{
				//trace("dead");
				initSubstate(new GameOverSubstate());
			}
		});
	}

	public function spawnBullets()
	{
		spawnTimer = new FlxTimer().start(GameInfo.bulletTimerTime, function(tmr:FlxTimer)
		{
			var randomOffset:Int = HelperFunctions.getRandomInt(-50);

			var bullet:Bullet = new Bullet(0);
			bullet.x = Std.random(640);
			bullet.y = randomOffset;
			bullets.add(bullet);
		}, 0);
	}

	public function initSubstate(substate:FlxSubState)
	{
		super.openSubState(substate);
	}
}
