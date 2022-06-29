package props.hud;

import utils.GameInfo;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

// TODO: Clean up this file & optimize!!!
class ScoreTracker extends FlxSpriteGroup
{
    public var scoreTextArray:Array<FlxText> = [];

	var defaultY:Float = 0;

	public var bonus:String = "";
	public var scoreGranted:Int = 0;

	public var scoreText:FlxText;

	public var textTween:FlxTween;
	public var _active:Bool = false;

	public function new(X:Float, Y:Float)
	{
		x = X;
		y = Y;
		defaultY = y;

        //scoreTextArray = []; // clearing the array to get rid of objects that might've not gotten destroyed

		super(x, y);
	}

    public function showScore(bonusType:String, grantAmount:Int, ?tweenTime:Float = 1.75)
    {
		var sText:FlxText = new FlxText(x, y, 0, "Score: 0", 24);
		sText.color = 0xFF6BC77B;
		sText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
        sText.velocity.set(250, 250);
		add(sText);
        scoreTextArray.push(sText);

        //scoreText.alpha = 0;
        sText.y = defaultY;
        sText.text = bonusType + ": " + "+" + grantAmount + "!"; // what the fuck is this line

		FlxG.sound.play("assets/sounds/xpgain" + GameInfo.audioExtension);

        FlxTween.tween(sText, {y: (defaultY - scoreTextArray.length / 0.15)}, tweenTime, {ease: FlxEase.expoOut, onComplete: function(t:FlxTween) 
        {
            FlxTween.tween(sText, {y: sText.y + 5, alpha: 0}, 1, {onComplete: function(t:FlxTween)
            {
                //active = false;
                sText.y = defaultY;
                scoreTextArray.remove(sText);
				trace("ALL DONE!!!! REMAINING: " + scoreTextArray.length);
            }});
        }});
    }
}