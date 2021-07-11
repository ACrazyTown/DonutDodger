package props;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

import utils.GameInfo;

class Player extends FlxSprite
{
	var vel = GameInfo.playerMoveVelocity;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic("assets/images/player.png");
    }


    override function update(elapsed:Float):Void
    {
		velocity.x = 0;

		if (FlxG.keys.anyPressed([LEFT, A]))
			velocity.x = -vel;

		if (FlxG.keys.anyPressed([RIGHT, D]))
			velocity.x = vel;

        super.update(elapsed);
    }
}