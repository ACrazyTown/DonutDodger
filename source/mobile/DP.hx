package mobile;

import flixel.FlxG;

class DP
{
    public static var gameWidth:Int = 640;
    public static var gameHeight:Int = 480;

    public static inline function x():Float
    {
        return (FlxG.width - gameWidth) / 2;
    }

    public static inline function y():Float
    {
        return (FlxG.height - gameHeight) / 2;
    }

    public static inline function getX(X:Float = 0):Float
    {
        return x() + X;
    }

    public static inline function getY(Y:Float = 0):Float
    {
        return y() + Y;
    }
}