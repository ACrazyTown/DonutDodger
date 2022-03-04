package;

import openfl.Lib;

import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxState;
import flixel.util.FlxColor;

import utils.GameInfo;

import props.Background;

/*
* Mess, but fuck it
*/

class OptionsSubstate extends FlxSubState
{
    var options:Array<Dynamic> = [
        ["Settings", 
            [
                ["Show FPS ON", "Show FPS OFF"], 
                ["Better Hitbox System", "Old Hitbox System"], 
                ["Autopause ON", "Autopause OFF"], 
                ["\nReturn", "\nReturn"]], 
                [FlxG.save.data.showFPS, FlxG.save.data.altHitboxes, FlxG.save.data.autopause]
            ]
    ];

    var categoryName:String = "";
    var optionDescription:String = "";

    var optionGroup:FlxTypedGroup<FlxText>;

    var curCategory:Int = 0;
    var curSelected:Int = 0;

    public function new(category:Int, circleY:Float)
    {
		super();

		var bg:Background = new Background(-5.5, -25.8, "assets/images/bg/background.png");
		bg.addAdditionalImageAssets([[-11.35, circleY]], [['assets/images/bg/circles.png']]);
		bg.tweenAsset(bg.additionalAssets[0], {y: -836.55}, 35, null, true);
		add(bg);

        optionGroup = new FlxTypedGroup<FlxText>();
        add(optionGroup);

        makeCategory(category);

        changeSelection(0, true);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ENTER)
            doOption();
        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);
        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);

        super.update(elapsed);

        FlxG.save.flush();
    }

    function makeCategory(cat:Int)
    {
        curCategory = cat;

        switch (cat)
        {
            case 0:
            {
                for (i in 0...options[cat][1].length)
                {
					var optionText:FlxText = new FlxText(0, (i * 60), 0, (options[cat][2][i] ? options[cat][1][i][0] : options[cat][1][i][1]), 28);
					optionText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
                    optionText.ID = i;
					optionText.y += 80;
					optionText.screenCenter(X);
					optionGroup.add(optionText);
                }
            }
        }
    }

    function doOption()
    {
        switch (curCategory)
        {
            case 0:
                switch (curSelected)
                {
                    case 0:
                        options[curCategory][2][0] = !options[curCategory][2][0];
                        FlxG.save.data.showFPS = options[curCategory][2][0];

						optionGroup.forEach(function(txt:FlxText)
						{
							if (txt.ID == curSelected)
							{
								txt.text = options[curCategory][2][0] ? options[curCategory][1][0][0] : options[curCategory][1][0][1];
								txt.screenCenter(X);
							}
						});

						(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.showFPS);

                    case 1:
						options[curCategory][2][1] = !options[curCategory][2][1];
						FlxG.save.data.altHitboxes = options[curCategory][2][1];

						optionGroup.forEach(function(txt:FlxText)
						{
							if (txt.ID == curSelected)
							{
								txt.text = options[curCategory][2][1] ? options[curCategory][1][1][0] : options[curCategory][1][1][1];
                                txt.screenCenter(X);
							}
						});

                    case 2:
                        options[curCategory][2][2] = !options[curCategory][2][2];
                        FlxG.save.data.autoPause = FlxG.autoPause = options[curCategory][2][2];

						optionGroup.forEach(function(txt:FlxText)
						{
							if (txt.ID == curSelected)
							{
								txt.text = options[curCategory][2][2] ? options[curCategory][1][2][0] : options[curCategory][1][2][1];
								txt.screenCenter(X);
							}
						});


                    case 3:
                        close();
                }
        }

        FlxG.save.flush();
    }

	function changeSelection(change:Int = 0, ?noSound:Bool = false)
	{
        if (!noSound)
		    FlxG.sound.play("assets/sounds/select" + GameInfo.audioExtension);

		curSelected += change;

		if (curSelected < 0)
			curSelected = Std.int((options[curCategory][1].length - 1));
		if (curSelected > (options[curCategory][1].length - 1))
			curSelected = 0;

		optionGroup.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
			{
				txt.color = FlxColor.YELLOW;
			}
		});
	}
}