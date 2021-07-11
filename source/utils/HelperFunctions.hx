package utils;

import lime.utils.Assets;

using StringTools;

class HelperFunctions
{
    public static function getRandomInt(max:Int)
    {
        return Math.floor(Math.random() * max);
    }

	// from https://github.com/KadeDev/Kade-Engine
	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	// the FNF source helped me with this one - ninjamuffin is pog af
	public static function parseTextFile(path:String):Array<String>
	{
		var textList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...textList.length)
		{
			textList[i] = textList[i].trim();
		}

		return textList;
	}
}