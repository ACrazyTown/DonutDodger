package utils.mods;

import sys.FileSystem;
import flixel.FlxG;
import haxe.Json;
import openfl.utils.Assets;

class ModFile
{
    /**
     * Parses a ModFile and returns a dynamic object.
     * @param path Path to the ModFile.
     * @return A dynamic object to access the ModFile's contents.
    **/
    public static function parse(path:String):Dynamic
    {
        if (!Assets.exists(path))
            return {};

        var data:Dynamic = Json.parse(path);
        return data;
    }

    public static function generate()
    {
        
    }
}

class ModManager
{
    public static var mods:Map<String, Dynamic>;

    static final API_VERSION:String = "1.0";
    static final MOD_PATH:String = "assets/mods/";
    static final REQ_FILE:String = "mod.json";

    static var curSubfolder:String = "";

    public static var loadedMods:Int = 0;

    public static function init()
    {
        mods = new Map<String, Dynamic>();
        loadedMods = 0;

        refresh();
    }

    public static function refresh()
    {
        loadedMods = 0;

        for (file in FileSystem.readDirectory(MOD_PATH))
        {
            if (FileSystem.isDirectory(MOD_PATH + file))
            {
                curSubfolder = file + "/";

                for (file in FileSystem.readDirectory(MOD_PATH + file))
                {
                    if (file == REQ_FILE)
                    {
                        var data = Json.parse(Assets.getText(MOD_PATH + curSubfolder + file));

                        loadedMods++;
                        mods.set(data.id, data);
                        FlxG.log.add("Loaded Mod: " + data.manifest.name);
                    }
                }
            }
        }

        FlxG.log.add("Loaded " + loadedMods + " mods!");
    }
}