package;

import flixel.FlxSubState;
import flixel.FlxSprite;

class BaseSubState extends FlxSubState
{
    public var borderBackground:FlxSprite;

    public function new():Void
    {
        super();

        borderBackground = new FlxSprite(0, 0).loadGraphic("assets/images/a_background.png");
        add(borderBackground);
    }
}