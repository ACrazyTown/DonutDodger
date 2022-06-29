package utils;

#if ng
import io.newgrounds.NG;
#end

#if VERCHECK
import haxe.Http;
#end

import flixel.FlxG;

using StringTools;

class GameInfo 
{
	// extension shit lmao
	#if desktop
	public static var audioExtension:String = ".ogg";
	#else
	public static var audioExtension:String = ".mp3";
	#end

    public static var gameVer:String = "1.2";
    public static var gotLatestVer:Bool = false;
    public static var verType:Int = 0;

    // 0 - EASY, 1 - NORMAL, 2 - HARD
   // public static var gameDifficulty:Int = 1;
    public static var curDifficulty:Int = 0;
    //public static var gameStyle:Int = 1; - maybe one day

    public static var playerMoveVelocity:Int = 150;

    public static var equippedPowerup:Int = Std.int(Math.NEGATIVE_INFINITY);

    public static function initSave()
    {
        if (FlxG.save.data.equippedPowerup == null)
            FlxG.save.data.equippedPowerup = Std.int(Math.NEGATIVE_INFINITY);

       if (FlxG.save.data.bestTime == null)
            FlxG.save.data.bestTime = 0;

        if (FlxG.save.data.showFPS == null)
            FlxG.save.data.showFPS = true;

		if (FlxG.save.data.altHitboxes == null)
			FlxG.save.data.altHitboxes = true;

        if (FlxG.save.data.points == null)
            FlxG.save.data.points = 0;

        if (FlxG.save.data.autoPause == null)
            FlxG.save.data.autoPause = true;

        if (FlxG.save.data.scrollType == null)
            FlxG.save.data.scrollType = 0;

        FlxG.autoPause = FlxG.save.data.autoPause;
        GameInfo.equippedPowerup = FlxG.save.data.equippedPowerup;

        FlxG.save.flush();
    }

    public static function resetSave()
    {
        FlxG.save.data.equippedPowerup = Std.int(Math.NEGATIVE_INFINITY);
        FlxG.save.data.bestTime = 0;
        FlxG.save.data.showFPS = true;
        FlxG.save.data.altHitboxes = true;
        FlxG.save.data.points = 0;
        FlxG.save.data.autoPause = false;
        FlxG.save.data.scrollType = 0;

        trace("Should've reset data!!");
    }

    public static function getLatestVersion()
    {
        #if VERCHECK // have to make this a conditional otherwise hashlink will fuck everything
		var versionRequest = new Http("https://raw.githubusercontent.com/ACrazyTown/DonutDodger/main/latest.version");

        versionRequest.onData = function(latestVer:String)
        {
            latestVer = latestVer.trim();
            var latestVerInt:Int = Std.parseInt(latestVer.replace(".", ""));
            trace(latestVerInt);

            var gameVerInt:Int = Std.parseInt(gameVer.replace(".", ""));
            trace(gameVerInt);

            if (latestVerInt < 100)
                latestVerInt = latestVerInt * 10;

            if (gameVerInt < 100)
                gameVerInt = gameVerInt * 10;

            trace("Latest Version: " + latestVer);
            trace("Current Version: " + gameVer );

            if (gameVerInt > latestVerInt)
            {
                trace("Game Ver > Latest Ver??? Probably a development build/mod??");
				verType = 2;
            }

            if (gameVerInt < latestVerInt)
            {
                trace("outdated :(");
				verType = 1;
                TitleState.versionTxt.text += " [OUTDATED]";
            }

            if (gameVerInt == latestVerInt)
            {
                trace("All up to date, swag!");
                verType = 0;
            }
        }

        versionRequest.onError = function(error)
        {
            trace('Failed to fetch latest version! Error: ' + error);
            gameVer = gameVer + " (FAILED TO FETCH LATEST VER.)";
        }

        versionRequest.request();
        #else
        trace("unsupported target for version check");
        #end
    }
}