package utils;

enum DifficultyType
{
    Easy;
    Normal;
    Hard;
    Insane;
    Custom;
}

typedef DifficultySettings =
{
    donutVelocity:Float,
    donutSpawnTime:Float
}

class Difficulty
{
    static var difficultySettingsMap:Map<DifficultyType, DifficultySettings>;

    public static var currentDifficulty:DifficultyType = Easy;

    public static var bulletMoveVelocity:Float = 75;
    public static var bulletTimerTime:Float = 0.50;
    
    public static var settings:DifficultySettings = 
    {
        donutVelocity: 75,
        donutSpawnTime: 0.5,
    };

    public static var customSettings:DifficultySettings =
    {
        donutVelocity: 75,
        donutSpawnTime: 0.5,
    };

    public static function init(diff:Int = 0)
    {
        difficultySettingsMap.set(Easy, {donutVelocity: 75, donutSpawnTime: 0.5});
        difficultySettingsMap.set(Normal, {donutVelocity: 140, donutSpawnTime: 0.3});
        difficultySettingsMap.set(Hard, {donutVelocity: 175, donutSpawnTime: 0.1});
        difficultySettingsMap.set(Insane, {donutVelocity: 200, donutSpawnTime: 0.05});
        // custom
    }

    public static function updateDiff(diff:DifficultyType, settings:DifficultySettings)
    {
        difficultySettingsMap.set(diff, settings);
    }

    public static function getDifficultyFromInt(diff:Int = 0):DifficultyType
    {
        switch (diff)
        {
            case 0: return Easy;
            case 1: return Normal;
            case 2: return Hard;
            case 3: return Insane;
            default: return Custom;
        }
    }

    public static function getDifficultySettings(diff:DifficultyType):DifficultySettings
    {
        var settings:DifficultySettings = {donutVelocity: 75, donutSpawnTime: 0.5};

        if (difficultySettingsMap.exists(diff))
        {
            settings = difficultySettingsMap.get(diff);
        }

        // not found??? erm... CRINGE!!!!
        return settings;
    }
}