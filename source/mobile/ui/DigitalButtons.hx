package mobile.ui;

import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;

class DigitalButtons extends FlxSpriteGroup
{
    private var _layout:DigitalLayout;

    public var buttons:Array<FlxButton>;

    public function new(X:Float = 0, Y:Float = 0, Layout:DigitalLayout = Menu):Void 
    {
        super(X, Y);
        _layout = Layout;

        createButtons();        
    }
    
    public function createButtons():Void
    {
        switch (_layout)
        {
            case Play:
                trace("New");
            case Menu:
                trace("New");
            default:
                trace("New");
        }
    }
}

enum DigitalLayout
{
    Play;
    Menu;
}