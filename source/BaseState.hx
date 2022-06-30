package;

import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;

class BaseState extends FlxTransitionableState
{
    public var borderBackground:FlxSprite;

    override function create():Void
    {
        borderBackground = new FlxSprite(0, 0).loadGraphic("assets/images/a_background.png");
        insert(0, borderBackground);

        super.create();
    }
}