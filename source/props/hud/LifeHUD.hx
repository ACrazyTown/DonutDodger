package props.hud;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class LifeHUD extends FlxSpriteGroup
{
    var heartAmount:Int = 3;

    var heartArray:Array<FlxSprite> = [];

    public function new(X:Float = 0, Y:Float = 0, equippedPowerup:Int)
    {
        super(X, Y);

        if (equippedPowerup == 0)
            heartAmount = 4; // it's supposed to be 4, but it's 3 because it starts from 0
        
        for (i in 0...heartAmount)
        {
            var heart:FlxSprite = new FlxSprite(X, Y).loadGraphic("assets/images/hud/heart.png", true, 22, 20);
            heart.ID = i;
            heart.animation.add("normal", [0]);
            heart.animation.add("broken", [1]);

            heart.setGraphicSize(Std.int(heart.width * 2), Std.int(heart.height * 2));
            heart.updateHitbox();

            heart.x += (i * 50);
            add(heart);

            heartArray.push(heart);
        }
    }

    public function updateLives(curLives:Int)
    {
        for (heart in heartArray)
        {
            if (heart.ID >= curLives)
            {
                heart.animation.play("broken");
                heart.visible = false;
            }
            else
            {
                heart.animation.play("normal");
                heart.visible = true;
            }
        }
    }
}