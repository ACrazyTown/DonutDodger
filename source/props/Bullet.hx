package props;

import flixel.FlxG;
import flixel.FlxSprite;

import utils.GameInfo;

class Bullet extends FlxSprite
{
    public function new(x:Float)
    {
        super(x);

        loadGraphic("assets/images/donut.png");
		velocity.y = 0;

        move();
    }

    public function move()
    {
		velocity.y = GameInfo.bulletMoveVelocity;
    }

    public function stop()
    {
        velocity.y = 0;
    }
}