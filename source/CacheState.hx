package;

import sys.thread.Thread;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

import utils.HelperFunctions;
import utils.GameInfo;

class CacheState extends FlxState
{
	var loadingText:FlxText;

    override public function create()
    {
        loadingText = new FlxText(0, 0, 0, "Loading...", 32);
		loadingText.screenCenter();
        add(loadingText);

		Thread.create(() -> {
			cache();
		});
    }

	function cache()
	{
		trace("Caching Music...");

		var songListFile = HelperFunctions.parseTextFile("assets/data/songList.txt");

		for (i in 0...songListFile.length)
		{
			var data:Array<String> = songListFile[i].split(':');
			var file = "assets/music/" + data[2] + GameInfo.audioExtension;

			FlxG.sound.cache(file);
			trace("Cached: " + file);
		}

		trace("Cached all Music!");

		loadingText.destroy();
		FlxG.switchState(new TitleState());
	}
}