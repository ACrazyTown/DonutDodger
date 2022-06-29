package utils;

import flixel.FlxG;
import openfl.utils.Assets;
import haxe.Json;

class Language
{
    private static var defaultLang:String = "en_us";

    private var fallbackData:Dynamic = {};
    public static var data:Dynamic;

    public static function init(?language:String)
    {
        var lang:String = defaultLang;

        if (verifyLanguage(language))
        {
            lang = language;
        }

        data = Json.parse(Assets.getText("assets/data/locale/" + lang + ".json"));
        FlxG.log.add("Successfully loaded language? " + lang);
    }

    /**
     * Returns a string from the language file.
     * @param string The name of the string in the JSON file.
     * @param state The "State" the string is located in (eg. PlayState/TitleState).
    **/
    public static function getString(string:String, ?state:String)
    {
        // TODO: perhaps scan the json for the string if there's no state?
    }

    static function verifyLanguage(language:String):Bool
    {
        if (language != null) 
        {
            if (!Assets.exists("assets/data/locale/" + language + ".json")) 
            { 
                return false;
            }
            else
            {
                return true;
            }
        }
        else
        {
            return false;
        }
    }
}