package props;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

import utils.HelperFunctions;
import utils.GameInfo;

using StringTools;

class NowPlaying extends FlxGroup
{
	public static var curSong:String = "";
	public static var curAuthor:String = "";
    public var curSongFilename:String = "";

    public var songList:Array<String> = [];
	public var songAuthorList:Array<String> = [];
	public var songFilenameList:Array<String> = [];

    public var randomSongInt:Int;

    public static var activeTimer:Bool = false;
    public static var tweenTimer:FlxTimer;

    public static var playingMusic:Bool = false;

	var popup:SongPopup;

	public function new()
	{
		// 300, 40
		// 640
		super();

		popup = new SongPopup(300, 40);
		popup.alpha = 0;
		add(popup);

        // loads the song list file and sorts the data to the matching arrays
		var songListFile = HelperFunctions.parseTextFile("assets/data/songList.txt");

		for (i in 0...songListFile.length)
		{
			var data:Array<String> = songListFile[i].split(':');

            songList.push(data[0]);
            songAuthorList.push(data[1]);
            songFilenameList.push(data[2]);
        }
	}

	public function showAndHide()
	{
        activeTimer = true;
		FlxTween.tween(popup, {alpha: 0.8}, 1.5);
		tweenTimer = new FlxTimer().start(3.75, function(tmr:FlxTimer)
		{
			FlxTween.tween(popup, {alpha: 0}, 1.5);
            activeTimer = false;
		});
	}

    public function getRandomSong()
    {
        randomSongInt = HelperFunctions.getRandomInt(songList.length);
        trace("Random Song Int: " + randomSongInt);

        curSong = songList[randomSongInt];
        curAuthor = songAuthorList[randomSongInt];
        curSongFilename = songFilenameList[randomSongInt];

        trace("-- SONG DATA --");
        trace("Current Song: " + curSong);
		trace("Author: " + curAuthor);
		trace("Filename: " + curSongFilename);
        trace("---------------");
    }

    public function playSong()
    {
        getRandomSong();

        var songPath = "assets/music/" + curSongFilename + GameInfo.audioExtension;
		var popupTxt:String = "Now Playing:\n\n" + curSong + "\n" + curAuthor;

        SongPopup.nowPlayingTxt.text = popupTxt;

        FlxG.sound.playMusic(songPath, 1, false);
        playingMusic = true;

        showAndHide();
    }
}
