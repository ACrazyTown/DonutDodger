package;

import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

import utils.GameInfo;
import utils.NGio;

import props.Background;

class OptionsState extends BeatState
{
    var optionCategories:Array<String> = ["SETTINGS", "\nRETURN"];
    var optionCategoryGroup:FlxTypedGroup<FlxText>;

	var curSelected:Int = 0;

    var isCategory:Bool = false;

    var bg:Background;

    override function create()
    {
        #if ng
        if (NGio.loggedIn)
		    optionCategories = ["SETTINGS", "LOGOUT", "\nRETURN"];
        else
            optionCategories = ["SETTINGS", "LOGIN", "\nRETURN"];
        #end

        trace(optionCategories);

        //FlxG.camera.zoom = 0.1;

        bg = new Background(-5.5, -25.8, "assets/images/bg/background.png");
		bg.addAdditionalImageAssets([[-11.35, -53.15]], [['assets/images/bg/circles.png']]);
        //bg.makeAdditionalAssets([[0,0]], [[FlxG.width, FlxG.height]], [FlxColor.BLACK], [0.15]);
		//bg.tweenAsset(0, {bg.additionalAssets[0].y: -836.55}, 75, null, true);
        //bg.tweenAsset(0, {bg.y: 1;}, 1, {ease: FlxEase.expoIn}, true);
        bg.tweenAsset(bg.additionalAssets[0], {y: -836.55}, 35, null, true);
        add(bg);

        optionCategoryGroup = new FlxTypedGroup<FlxText>();
        add(optionCategoryGroup);

		var optionTitle:FlxText = new FlxText(0, 60, 0, "OPTIONS", 36);
		optionTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
		optionTitle.screenCenter(X);
		add(optionTitle);

        for (i in 0...optionCategories.length)
        {
            var optionText:FlxText = new FlxText(0, (i * 60), 0, optionCategories[i], 28);
			optionText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
            optionText.ID = i;
            optionText.y += optionTitle.y + 120;
            optionText.screenCenter(X);
            optionCategoryGroup.add(optionText);
        }

        changeSelection();

		super.create();
    }  

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

		if (FlxG.keys.anyJustPressed([UP, W]))
			changeSelection(-1);

		if (FlxG.keys.anyJustPressed([DOWN, S]))
			changeSelection(1);

        if (FlxG.keys.justPressed.ENTER)
        {
            doOption();
        }
    }

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play("assets/sounds/select" + GameInfo.audioExtension);

		curSelected += change;

		if (curSelected < 0)
			curSelected = (optionCategories.length - 1);
		if (curSelected > (optionCategories.length - 1))
			curSelected = 0;

		optionCategoryGroup.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
			{
				txt.color = FlxColor.YELLOW;
			}
		});
    }

    function doOption()
    {
        #if ng
        switch (curSelected)
        {
            case 1:
                trace("ATTEMPTING LOGIN/LOGOUT!");

            case 2:
                FlxG.switchState(new TitleState());
        }
        #else
		switch (curSelected)
		{
			case 0:
				super.openSubState(new OptionsSubstate(curSelected, bg.additionalAssets[0].y));

			case 1:
				FlxG.switchState(new TitleState());
		}
        #end
    }

    function switchToCategory()
    {
        isCategory = true;

        optionCategoryGroup.clear();
    }
}