package props;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

import utils.GameInfo;

class Player extends FlxSprite
{
    public static var useAltHitbox:Bool;

	var vel = GameInfo.playerMoveVelocity;

    public function new(x:Float, y:Float)
    {
		useAltHitbox = FlxG.save.data.altHitboxes;

        super(x, y);

        //loadGraphic("assets/images/player.png");
		loadGraphic("assets/images/player.png", true, 36, 36);
        animation.add('idle', [0]);
		animation.add('dead', [1]);

        animation.play('idle');

        if (useAltHitbox)
        {
            // 32
            offset.y = 7;
            offset.x = 4;
            width = 27;
            height = 27;
        }
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

    public function playAnim(anim:String)
    {
        animation.play(anim);
        if (anim == 'dead')
            if (useAltHitbox)
                offset.y = 8;
            else
                offset.y = 1;
    }
}