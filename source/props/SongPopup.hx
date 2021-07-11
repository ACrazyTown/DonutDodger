package props;

import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SongPopup extends FlxSpriteGroup
{
	public static var song:String = "";
	public static var author:String = "";

	public static var nowPlayingTxt:FlxText;
	var container:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super();

		container = new FlxSprite(x, y).makeGraphic(340, 120, FlxColor.BLACK);
		add(container);

		nowPlayingTxt = new FlxText(container.x + 10, container.y + 10, 0, "", 20);
		add(nowPlayingTxt);
	}
}
