package utils;

import flixel.FlxG;

import utils.HelperFunctions;

class GameInfo 
{
    public static var gameVer:String = "1.0";

    // 0 - EASY, 1 - NORMAL, 2 - HARD
    public static var gameDifficulty:Int = 1;
    //public static var gameStyle:Int = 1; - maybe one day

    public static var bulletMoveVelocity:Int = 75;
    public static var bulletTimerTime:Float = 0.50;

    public static var playerMoveVelocity:Int = 150;

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
                bulletMoveVelocity = 150;
                bulletTimerTime = 0.12;

        }
    }

    public static function initSave()
    {
        if (FlxG.save.data.bestTime == null)
            FlxG.save.data.bestTime = 0;

        if (FlxG.save.data.showFPS == null)
            FlxG.save.data.showFPS = true;

        FlxG.save.flush();
    }
}