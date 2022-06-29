package states;

import sys.thread.Thread;
import sys.FileSystem;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;

import utils.GameInfo;

using StringTools;

class CacheState extends FlxState
{
	var toLoad:Int = 0;
	var loaded:Int = 0;

	var loadingText:FlxText;
	var loadingBar:FlxBar;

    override public function create()
    {
		super.create();

        loadingText = new FlxText(0, 0, 0, "Loading...", 32);
		loadingText.screenCenter();
        add(loadingText);

		Thread.create(() -> {
			cache();
		});
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (loaded != toLoad)
		{
			loadingText.text = "Loading... (" + loaded + "/" + toLoad + ")";
			loadingText.screenCenter();
		}
	}

	function cache()
	{
		var imageList = [];
		var bgImageList = [];
		var musicList = [];

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
		{
			if (!i.endsWith(".png"))
				continue;
			imageList.push(i);
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/bg")))
		{
			if (!i.endsWith(".png"))
				continue;
			bgImageList.push(i);
		}

		/*
		var songListFile = HelperFunctions.parseTextFile("assets/data/songList.txt");

		for (i in 0...songListFile.length)
		{
			var data:Array<String> = songListFile[i].split(':');
			var file = data[2] + GameInfo.audioExtension;

			musicList.push(i);
		}
		*/
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/music")))
		{
			if (!i.endsWith(GameInfo.audioExtension))
				continue;
			musicList.push(i);
		}

		toLoad = Lambda.count(imageList) + Lambda.count(musicList) + Lambda.count(bgImageList);

		//loadingBar = new FlxBar(0, (loadingText.y + 180), FlxBarFillDirection.LEFT_TO_RIGHT, 125, 10, this, "loaded", 0, toLoad);
		//loadingBar.screenCenter(X);
		var loadingBar = new FlxBar(20, (loadingText.y + 180), FlxBarFillDirection.HORIZONTAL_INSIDE_OUT, FlxG.width - 40, 10, this, "loaded", 0, toLoad);
		loadingBar.createFilledBar(0xFF000000, 0xFF3b26de);
		add(loadingBar);

		trace("Caching Graphics...");

		for (i in imageList)
		{
			FlxG.bitmap.add("assets/images/" + i);
			trace("Cached: " + i);
			
			loaded++;
		}

		for (i in bgImageList)
		{
			FlxG.bitmap.add("assets/images/bg" + i);
			trace("Cached: " + i);

			loaded++;
		}

		trace("Caching Music...");

		for (i in musicList)
		{
			FlxG.sound.cache("assets/music/" + i);
			trace("Cached: " + i);

			loaded++;
		}

		/*
		for (i in 0...songListFile.length)
		{
			var data:Array<String> = songListFile[i].split(':');
			var file = "assets/music/" + data[2] + GameInfo.audioExtension;

			FlxG.sound.cache(file);
			trace("Cached: " + file);
		}
		*/

		trace("Cached all Music!");

		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			FlxG.switchState(new TitleState());
		});
	}
}