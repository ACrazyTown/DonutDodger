package states;

import flixel.group.FlxSpriteGroup;
import utils.GameAssets;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import utils.mods.ModManager;
import flixel.FlxG;
import utils.GameInfo;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import props.Background;

class ModMenuState extends BeatState
{
    public static var items:Array<String> = ["Edit Mods", "Manage Mods", "\nRETURN"];
    var itemGroup:FlxTypedGroup<FlxText>;

    var curSelected:Int = 0;

    var modAmount:FlxText;

    override function create()
    {
        ModManager.refresh();
        FlxG.mouse.enabled = false;

        var bg:Background = new Background(-5.5, -25.8, "assets/images/bg/background.png");
		bg.addAdditionalImageAssets([[-11.35, -53.15]], [['assets/images/bg/circles.png']]);
        bg.tweenAsset(bg.additionalAssets[0], {y: -836.55}, 35, null, true);
        add(bg);

        var title:FlxText = new FlxText(0, 60, 0, "MODS", 36);
        title.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
        title.screenCenter(X);
        add(title);

        itemGroup = new FlxTypedGroup<FlxText>();
        add(itemGroup);

        for (i in 0...items.length)
        {
            var item:FlxText = new FlxText(0, (i * 60), 0, items[i], 28);
            item.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
            item.ID = i;
            item.y += title.y + 120;
            item.screenCenter(X);
            itemGroup.add(item);
        }

        modAmount = new FlxText(0, 0, 0, "Loaded Mods: " + ModManager.loadedMods, 14);
        modAmount.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
        modAmount.setPosition(5, (FlxG.height - modAmount.height) - 5);
        modAmount.antialiasing = false;
        add(modAmount);

        changeSelection();
        super.create();
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ENTER)
        {
            onEnter();
        }

        if (FlxG.keys.anyJustPressed([UP, W]))
			changeSelection(-1);
		if (FlxG.keys.anyJustPressed([DOWN, S]))
			changeSelection(1);

        super.update(elapsed);
    }

    function onEnter()
    {
        switch (curSelected)
        {
            case 0:
                FlxG.switchState(new ModdingState());

            case 1:
                FlxG.switchState(new ModManageState());

            case 2:
                FlxG.switchState(new OptionsState());
        }
    }

    function changeSelection(change:Int = 0)
    {
        if (change > 0 || change < 0)
            FlxG.sound.play("assets/sounds/select" + GameInfo.audioExtension);

        curSelected += change;

        if (curSelected < 0)
            curSelected = (items.length - 1);
        if (curSelected > (items.length - 1))
            curSelected = 0;

        itemGroup.forEach(function(txt:FlxText)
        {
            txt.color = FlxColor.WHITE;

            if (txt.ID == curSelected)
            {
                txt.color = FlxColor.YELLOW;
            }
        });
    }
}

class ModManageState extends BeatState
{
    var items = [];
    var modData = [];

    var itemGroup:FlxTypedGroup<FlxText>;

    var curSelected:Int = 0;

    override function create()
    {
        for (mod in ModManager.mods) 
        {
            items.push(mod.manifest.name);
            modData.push(mod);
        }

        var bg:Background = new Background(-5.5, -25.8, "assets/images/bg/background.png");
		bg.addAdditionalImageAssets([[-11.35, -53.15]], [['assets/images/bg/circles.png']]);
        bg.tweenAsset(bg.additionalAssets[0], {y: -836.55}, 35, null, true);
        add(bg);

        itemGroup = new FlxTypedGroup<FlxText>();
        add(itemGroup);

        var title:FlxText = new FlxText(0, 60, 0, "Manage Mods", 36);
        title.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
        title.screenCenter(X);
        add(title);

        for (i in 0...items.length)
        {
            var item:FlxText = new FlxText(0, 0, 0);
        }

        super.create();
    }

    function changeSelection(change:Int = 0)
    {
        if (change > 0 || change < 0)
            FlxG.sound.play("assets/sounds/select" + GameInfo.audioExtension);

        curSelected += change;

        if (curSelected < 0)
            curSelected = (items.length - 1);
        if (curSelected > (items.length - 1))
            curSelected = 0;

        itemGroup.forEach(function(txt:FlxText)
        {
            txt.color = FlxColor.WHITE;

            if (txt.ID == curSelected)
            {
                txt.color = FlxColor.YELLOW;
            }
        });
    }
}

class ModdingState extends BeatState
{
    var playStateGroup:FlxGroup;
    var donuts:FlxTypedGroup<FlxSprite>;

    var bg:FlxSprite;

    var curStyle:Int = 0;

    override function create()
    {
        FlxG.mouse.enabled = true;

        playStateGroup = new FlxGroup();
        add(playStateGroup);

        donuts = new FlxTypedGroup<FlxSprite>();
        add(donuts);

        bg = new FlxSprite().loadGraphic(GameAssets.getAsset("bg0"));
        playStateGroup.add(bg);

        var ding:FlxSprite = new FlxSprite().loadGraphic(GameAssets.getAsset("player"), true, 36, 36);
        ding.animation.add('idle', [0]);
        ding.animation.play("idle");
        ding.screenCenter();
        ding.y += 150;
        playStateGroup.add(ding);

        for (i in 0...36)
        {
            var d:FlxSprite = new FlxSprite(FlxG.random.int(0, 640), FlxG.random.int(0, 480)).loadGraphic(GameAssets.getAsset("donut0"));
            donuts.add(d);
        }

        var backText:FlxText = new FlxText(10, 10, 0, "<< EXIT (ESC)", 18);
        backText.setBorderStyle(OUTLINE, 0xFF000000, 2);
        add(backText);

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.anyJustPressed([A, LEFT]))
            switchStyle(-1);
        if (FlxG.keys.anyJustPressed([D, RIGHT]))
            switchStyle(1);

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new ModMenuState());

        super.update(elapsed);
    }

    function switchStyle(change:Int = 0)
    {
        curStyle += change;

        if (curStyle > 3)
            curStyle = 0;
        if (curStyle < 0)
            curStyle = 3;

        switch (curStyle)
        {
            case 0:
                bg.loadGraphic(GameAssets.getAsset("bg0"));
                for (d in donuts)
                {
                    d.loadGraphic(GameAssets.getAsset("donut0"));
                }

            case 1:
                bg.loadGraphic(GameAssets.getAsset("bg1"));
                for (d in donuts)
                {
                    d.loadGraphic(GameAssets.getAsset("donut1"));
                }

            case 2:
                bg.loadGraphic(GameAssets.getAsset("bg2"));
                for (d in donuts)
                {
                    d.loadGraphic(GameAssets.getAsset("donut2"));
                }

            case 3:
                bg.loadGraphic(GameAssets.getAsset("bg3"));
                for (d in donuts)
                {
                    d.loadGraphic(GameAssets.getAsset("donut3"));
                }

        }
    }
}