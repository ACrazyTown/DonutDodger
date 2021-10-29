package props.hud;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

//import io.newgrounds.NG;
//import utils.NGio;
/*
* WIP, WILL BE INCLUDED IN 1.1.1/1.2
*/

class AchievementBox extends FlxSpriteGroup
{
    public var imagePath:String = "";

	public var box:FlxSprite;
	public var boxIcon:FlxSprite;
	public var boxText:FlxText;

    public function new(x:Float, y:Float, imgPath:String)
    {
        imagePath = imgPath;

		super(x, y);

        //y: 72
		box = new FlxSprite(0, 0).makeGraphic(0, 0, FlxColor.BLACK);
		box.screenCenter(X);
		add(box);

		boxIcon = new FlxSprite((box.x + 15), (box.y + 11.5)).loadGraphic(imagePath);
		add(boxIcon);

		boxText = new FlxText((boxIcon.x + 85), (box.y + 10), 0, "Medal Unlocked:\n [MEDAL]", 20);
		boxText.alignment = FlxTextAlign.CENTER;
		add(boxText);
    }
}

class NGAchievement extends FlxSpriteGroup
{
    var filePrefix:String = "assets/images/hud/ngmedals/";

    public var curMedal:Int;
    public var iconPath:String = "";

    var achievementBox:AchievementBox;

    public function new()
    {
        super(0, 0);

        achievementBox = new AchievementBox(384, -72, filePrefix + "placeholder.png");
        add(achievementBox);
    }

    public function updateMedal(medal:Int)
    {
        curMedal = medal;
        iconPath = filePrefix + medal + ".png";

		achievementBox.boxIcon.loadGraphic(iconPath);

        achievementBox.boxText.text = "Medal Unlocked:\n PLACEHOLDER"; //+ NG.core.medals.get(medal).name
		achievementBox.boxText.alignment = FlxTextAlign.CENTER;
    }

    public function unlockMedal(medal:Int)
    {
        /*
        if (NGio.loggedIn)
        {
            updateMedal(medal);
            NGio.unlockMedal(curMedal);

            FlxTween.tween(this, {y: 0}, 1.25, {ease: FlxEase.expoInOut, onComplete: (t:FlxTween) -> {
                new FlxTimer().start(5, function(tmr:FlxTimer)
                {
					FlxG.log.add("UNLOCKED!");
                    FlxTween.tween(this, {y: -64}, 1.25, {ease: FlxEase.expoInOut});
                });
            }});
        }
        else
        {
            FlxG.log.add("COUDLNT UNLOCK! - EPIC FAIL!");
        }
        */
    }

    public function showAchievement()
    {
		FlxTween.tween(achievementBox, {y: 0}, 1.25, {
			ease: FlxEase.expoInOut,
			onComplete: (t:FlxTween) ->
			{
				new FlxTimer().start(5, function(tmr:FlxTimer)
				{
					FlxG.log.add("[NGAchievement] MEDAL UNLOCKED ??");
					FlxTween.tween(achievementBox, {y: -72}, 1.25, {ease: FlxEase.expoInOut});
				});
			}
		});
    }
}