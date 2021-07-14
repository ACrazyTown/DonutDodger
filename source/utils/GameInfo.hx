package utils;

#if ng
import io.newgrounds.NG;
#end

import haxe.Http;

import flixel.FlxG;

import utils.HelperFunctions;

using StringTools;

class GameInfo 
{
    public static var gameVer:String = "1.0.1";

    // 0 - EASY, 1 - NORMAL, 2 - HARD
    public static var gameDifficulty:Int = 1;
    //public static var gameStyle:Int = 1; - maybe one day

    public static var bulletMoveVelocity:Int = 75;
    public static var bulletTimerTime:Float = 0.50;

    public static var playerMoveVelocity:Int = 150;
    //public static var useAltHitbox:Bool = FlxG.save.data.altHitboxes;

    // extension shit lmao
    #if desktop
    public static var audioExtension:String = ".ogg";
    #else
	public static var audioExtension:String = ".mp3";
    #end

    public static function adjustByDiff()
    {
        switch (gameDifficulty)
        {
            case 0:
                bulletMoveVelocity = 80;
                bulletTimerTime = 0.55;
            case 1:
                bulletMoveVelocity = 130;
                bulletTimerTime = 0.35;
            case 2:
                bulletMoveVelocity = 160;
                bulletTimerTime = 0.10;

        }
    }

    public static function initSave()
    {
        if (FlxG.save.data.bestTime == null)
            FlxG.save.data.bestTime = 0;

        if (FlxG.save.data.showFPS == null)
            FlxG.save.data.showFPS = true;

		if (FlxG.save.data.altHitboxes == null)
			FlxG.save.data.altHitboxes = true;

        FlxG.save.flush();
    }

    public static function getLatestVersion()
    {
		var versionRequest = new Http("https://raw.githubusercontent.com/ACrazyTown/DonutDodger/main/latest.version");

        versionRequest.onData = function(latestVer:String)
        {
            latestVer = latestVer.trim();
            var latestVerInt:Int = Std.parseInt(latestVer.replace(".", ""));
            trace(latestVerInt);

            var gameVerInt:Int = Std.parseInt(gameVer.replace(".", ""));
            trace(gameVerInt);

            trace("Latest Version: " + latestVer + "|");
            trace("Current Version: " + gameVer + "|");

            if (gameVerInt > latestVerInt)
            {
                trace("Game Version is bigger than Latest Version ???");
            }

            if (gameVerInt < latestVerInt)
            {
                trace("Outdated version!");
                TitleState.versionTxt.text += " [OUTDATED]";
            }

            if (gameVerInt == latestVerInt)
            {
                trace("Game Version is the same as the Latest Version, ignoring!");
            }
        }

        versionRequest.onError = function(error)
        {
            trace('Failed to fetch latest version! Error: ' + error);
            gameVer = gameVer + " (FAILED TO FETCH LATEST VER.)";
        }

        versionRequest.request();
    }
}