package props;

import flixel.FlxG;
import flixel.FlxSprite;

import utils.GameInfo;

class Bullet extends FlxSprite
{
	public static var useAltHitbox:Bool;

    public function new(x:Float)
    {
		useAltHitbox = FlxG.save.data.altHitboxes;

        super(x);

        loadGraphic("assets/images/donut.png");
		velocity.y = 0;

		if (useAltHitbox)
		{
			// 32
			offset.y = 6;
			offset.x = 6;
			width = 16;
			height = 16;
		}

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