package props;

import flixel.FlxG;
import flixel.FlxSprite;

import utils.Difficulty;
import utils.GameInfo;

class Bullet extends FlxSprite
{
	public static var useAltHitbox:Bool;
    public var donutType:Int = 0;

    public function new(x:Float = 0, y:Float = 0, ?type:Int = 0)
    {
		useAltHitbox = FlxG.save.data.altHitboxes;
        donutType = type;
        
        super(x, y);

        loadGraphic(getImageByType(type));
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

    function getImageByType(donutType:Int)
    {
        var imagePath = "assets/images/bullet/donut";

        if (donutType > 4)
            donutType = 0;

        return imagePath + donutType + ".png";
    }

    public function move()
    {
		velocity.y = Difficulty.settings.donutVelocity;
    }

    public function stop()
    {
        velocity.y = 0;
    }
}