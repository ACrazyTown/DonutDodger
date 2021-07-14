package;

import openfl.Lib;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

import utils.GameInfo;
import utils.HelperFunctions;
import utils.NGio;
import utils.APIKeys;

class OptionsState extends FlxState
{
	// this entire file is hard coded and shit
	// but there are only like 2 options so i couldnt care less
	// i'll improve it in a later update when there's actualy MORE shit
	var showFPS:Bool = FlxG.save.data.showFPS;
	var altHitbox:Bool = FlxG.save.data.altHitboxes;

	var fpsTxt:FlxText;

	#if ng
	var optionsArray:Array<String> = ["Show FPS [ON]", "Alt Hitbox System [OFF]", "Login to NG", "\nReturn"];
	#else
	var optionsArray:Array<String> = ["Show FPS [ON]", "Alt Hitbox System [OFF]", "\nReturn"];
	#end
	var optionsTxtGroup:FlxTypedGroup<FlxText>;

	var curSelected:Int = 0;
	var maxInt:Int;

	override public function create()
	{
		maxInt = HelperFunctions.lengthToInt(optionsArray.length);

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

		changeOption(0, true);
		updateDisplay();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			setOption(curSelected);
		}

		if (FlxG.keys.anyJustPressed([UP, W]))
			changeOption(-1);

		if (FlxG.keys.anyJustPressed([DOWN, S]))
			changeOption(1);

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
			curSelected = optionsArray.length;
		if (curSelected > optionsArray.length)
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

				case 1:
					if (FlxG.save.data.altHitboxes == true)
						txt.text = "Alt Hitbox System [ON]";
					else
						txt.text = "Alt Hitbox System [OFF]";
				#if ng
				case 2:
					if (NGio.loggedIn)
						txt.text = "Already logged in to NG";
					else
						txt.text = "Login to NG";
				#end
			}
		
			txt.screenCenter(X);
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

			case 1:
				if (altHitbox == true)
					altHitbox = false;
				else
					altHitbox = true;

				FlxG.save.data.altHitboxes = altHitbox;
				trace("Toggled the Alt Hitbox System!");
			
			#if ng
			case 2:
				if (NGio.loggedIn)
					trace("Already logged in with NG!");
				else
					var ng:NGio = new NGio(APIKeys.AppID, APIKeys.EncKey);
			#end

			case maxInt:
				FlxG.switchState(new TitleState());
		}

		FlxG.save.flush();
		updateDisplay();
	}
}