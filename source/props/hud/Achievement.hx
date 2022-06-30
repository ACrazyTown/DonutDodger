package props.hud;

import flixel.text.FlxText;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class AchievementBox extends FlxSpriteGroup
{
    public function new(X:Float = 0, Y:Float = 0, icon:FlxGraphicAsset)
    {
        super(DP.getX(X), DP.getY(Y));

        var box = new FlxSprite(0, 0).makeGraphic(375, 76, 0xFF000000);
		//box.screenCenter(X);
		add(box);

        if (icon == null || icon == "")
            icon = "assets/images/hud/ngmedals/placeholder.png";

		var boxIcon = new FlxSprite((box.x + 15), (box.y + 11.5)).loadGraphic(icon);
		add(boxIcon);

		var boxText = new FlxText((boxIcon.x + 85), (box.y + 10), 0, "Medal Unlocked:\n [MEDAL]", 20);
		boxText.alignment = FlxTextAlign.CENTER;
		add(boxText);
    }
}