package mobile.ui;

import flixel.FlxSprite;

class MobileSprite extends FlxSprite
{
    public function new(X:Float = 0, Y:Float = 0):Void
    {
        super(DP.getX(X), DP.getY(Y));
    }

    override function setPosition(X:Float = 0, Y:Float = 0):Void
    {
        this.x = DP.x() + X;
        this.y = DP.y() + Y;
    }

    override public function set_x(NewX:Float):Float
    {
        return x = DP.x() + NewX;
    }

    override public function set_y(NewY:Float):Float
    {
        return y = DP.y() + NewY;
    }
}