package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import openfl.Lib;
import utils.GameInfo;

class OptionsState extends FlxState
{
	// this entire file is hard coded and shit
	// but there are only like 2 options so i couldnt care less
	// i'll improve it in a later update when there's actualy MORE shit
	var showFPS:Bool = FlxG.save.data.showFPS;

	var fpsTxt:FlxText;

	var optionsArray:Array<String> = ["Show FPS [ON]"];
	var optionsTxtGroup:FlxTypedGroup<FlxText>;

	var curSelected:Int = 0;

	override public function create()
	{
		super.create();

		optionsTxtGroup = new FlxTypedGroup<FlxText>();
		add(optionsTxtGroup);

		var optionTitle:FlxText = new FlxText(0, 80, 0, "OPTIONS", 36);
		optionTitle.screenCenter(X);
		add(optionTitle);

		for (i in 0...optionsArray.length)
		{
			var optionsTxt:FlxText = new FlxText(0, (i * 40), 0, optionsArray[i], 24);
			optionsTxt.ID = i;
			optionsTxt.y += optionTitle.y + 140;
			optionsTxt.screenCenter(X);
			optionsTxtGroup.add(optionsTxt);
		}

		var returnTxt:FlxText = new FlxText(0, (FlxG.height - 40), 0, "(Press ESC to return to the Menu)", 18);
		returnTxt.screenCenter(X);
		returnTxt.alpha = 0.75;
		add(returnTxt);

		changeOption(0, true);
		updateDisplay();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			setOption(curSelected);
		}

		/*
		if (FlxG.keys.anyJustPressed([UP, W]))
			changeOption(-1);

		if (FlxG.keys.anyJustPressed([DOWN, S]))
			changeOption(1);
		*/

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new TitleState());
		}
	}

	function changeOption(change:Int = 0, ?noSound:Bool = false)
	{
		if (!noSound)
			FlxG.sound.play("assets/sounds/select" + GameInfo.audioExtension);

		curSelected += change;

		if (curSelected < 0)
			curSelected = 1;
		if (curSelected > 1)
			curSelected = 0;

		optionsTxtGroup.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
			{
				txt.color = FlxColor.YELLOW;
			}
		});
	}

	function updateDisplay()
	{
		optionsTxtGroup.forEach(function(txt:FlxText)
		{
			switch (txt.ID)
			{
				case 0:
					if (FlxG.save.data.showFPS == true)
						txt.text = "Show FPS [ON]";
					else
						txt.text = "Show FPS [OFF]";
			}
		});
	}

	function setOption(selected:Int)
	{
		switch (selected)
		{
			case 0:
				if (showFPS == true)
					showFPS = false;
				else
					showFPS = true;

				FlxG.save.data.showFPS = showFPS;
				(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.showFPS);
		}

		FlxG.save.flush();
		updateDisplay();
	}
}