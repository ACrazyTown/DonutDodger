package utils;

import openfl.utils.Assets;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

using StringTools;

class GameAssets
{
    public static var defaultAssets:Map<String, FlxGraphicAsset> = [];
    public static var modAssets:Map<String, FlxGraphicAsset> = [];

    static final fallbackAssetFile:String = "player:assets/images/player.png\ndonut0:assets/images/bullet/donut0.png\ndonut1:assets/images/bullet/donut1.png\ndonut2:assets/images/bullet/donut2.png\ndonut3:assets/images/bullet/donut3.png\nbg0:assets/images/bg0.png\nbg1:assets/images/bg1.png\nbg2:assets/images/bg2.png\nbg3:assets/images/bg3.png\nheart:assets/images/hud/heart.png";

    public static function init()
    {
        FlxG.log.add("Initializing default asset map...");

        var assetArray = parseAssetFile("assets/data/assets.txt");
        for (i in 0...assetArray.length)
        {
            defaultAssets.set(assetArray[i][0], assetArray[i][1]);
            FlxG.log.add("Added asset to the asset map with the key: " + assetArray[i][0]);
        }

        FlxG.log.add("Initialized default asset map!");
    }

    public static function getAsset(key:String):FlxGraphicAsset
    {
        var assetMap = defaultAssets;

        if (modAssets.exists(key))
            assetMap = modAssets;

        if (assetMap.get(key) == null)
            return "assets/images/placeholder.png";
        else
            return assetMap.get(key);
    }

    static function parseAssetFile(path:String):Array<Array<String>>
    {
        var parsedAssets = [];
        var assetTextArray = HelperFunctions.parseTextFile(path);

        if (!Assets.exists(path) || !Assets.exists("assets/data/assets.txt"))
        {
            assetTextArray = HelperFunctions.parseTextFile(fallbackAssetFile);
        }

        for (asset in assetTextArray)
        {
            parsedAssets.push(asset.split(":"));
        }

        return parsedAssets;
    }
}