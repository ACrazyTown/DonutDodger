package props;

import utils.GameAssets;
import flixel.FlxG;
import flixel.FlxSprite;

import utils.GameInfo;

class Player extends FlxSprite
{
    public var maxAngle:Int = 35;
    public var lives:Int = 3;

    public var boosted:Bool = false;

	var vel:Int = GameInfo.playerMoveVelocity;

    //public var boostTime:Float = 5;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        //loadGraphic("assets/images/player.png");
		loadGraphic(GameAssets.getAsset("player"), true, 36, 36);
        animation.add('idle', [0]);
		animation.add('dead', [1]);
        animation.add('regen', [2]);

        animation.play('idle');

        immovable = true;

        if (FlxG.save.data.altHitboxes)
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
        angle = 0;
		velocity.x = 0;

        if (!boosted)
        {
            if (FlxG.keys.anyPressed([LEFT, A]))
                velocity.x = -vel;

            if (FlxG.keys.anyPressed([RIGHT, D]))
                velocity.x = vel;
        }
        else
        {
            if (FlxG.keys.anyPressed([LEFT, A]))
            {
                velocity.x = -(vel + 50);
                angle = -25;
                //FlxTween.angle(this, 0, -25, 0.25);
            }
            else if (FlxG.keys.anyPressed([RIGHT, D]))
            {
                velocity.x = (vel + 50);
                angle = 25;
                //FlxTween.tween(this, {angle: 25}, 0.25);
            }
        }

        super.update(elapsed);
    }

    public function playAnim(anim:String)
    {
        animation.play(anim);
        if (anim == 'dead')
            if (FlxG.save.data.altHitboxes)
                offset.y = 8;
            else
                offset.y = 1;
    }
}