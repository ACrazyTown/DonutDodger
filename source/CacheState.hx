package;

import sys.thread.Thread;
import sys.FileSystem;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

import utils.HelperFunctions;
import utils.GameInfo;

using StringTools;

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
		var imageList = [];

		trace("Caching Graphics...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
		{
			if (!i.endsWith(".png"))
				continue;
			imageList.push(i);
		}

		for (i in imageList)
		{
			FlxG.bitmap.add("assets/images/" + i);
			trace("Cached: " + i);
		}

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