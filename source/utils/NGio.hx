package utils;

#if ng
import io.newgrounds.NG;

import io.newgrounds.crypto.Cipher;
import io.newgrounds.crypto.EncryptionFormat;

import io.newgrounds.objects.ScoreBoard;
import io.newgrounds.objects.Medal;

import flixel.FlxG;

using StringTools;

class NGio
{
    public static var loggedIn:Bool = false;

    public function new(appID:String, encKey:String, ?sessionID:String)
    {
        trace("[NGio] Connecting to NG...");

        NG.createAndCheckSession(appID, sessionID);
        //NG.core.verbose = true;

        NG.core.initEncryption(encKey, Cipher.RC4, EncryptionFormat.BASE_64);

        attemptLogin();
    }

    function attemptLogin()
    {
		trace("[NGio] NG.core.attemptingLogin status: " + NG.core.attemptingLogin);

		if (NG.core.attemptingLogin)
		{
			trace("[NGio] Attempting to login...");
			NG.core.onLogin.add(onLogin);
		}
		else
		{
			NG.core.requestLogin(onLogin);
		}
    }

    function onLogin():Void
    {
        trace("[NGio] Logged in as: " + NG.core.user.name);
        loggedIn = true;
        
        FlxG.save.data.sessionID = NG.core.sessionId;
        FlxG.save.flush();

        NG.core.requestMedals(onMedalFetch);
		NG.core.requestScoreBoards(onBoardsFetch);
    }

    function onMedalFetch():Void
    {
        for (id in NG.core.medals.keys())
        {
            var medal:Medal = NG.core.medals.get(id);

            trace("-- [NGio] Loaded Medal --");
            trace("ID: " + id);
            trace("Name: " + medal.name);
            trace("Description: " + medal.description);
            trace("-------------------------");

            APIKeys.medals.push(medal);
        }

        if (loggedIn)
        {
            var unlockingMedal = NG.core.medals.get(63897);

            if (!unlockingMedal.unlocked)
                trace("[NGio] Unlocking First Play Medal...");
                unlockingMedal.sendUnlock();
                trace("[NGio] Unlocked!");
        }
    }

    function onBoardsFetch():Void
    {
        for (id in NG.core.scoreBoards.keys())
        {
            var board:ScoreBoard = NG.core.scoreBoards.get(id);
			trace("-- [NGio] Loaded Board --");
			trace("ID: " + id);
			trace("Name: " + board.name);
            trace("-------------------------");
        }
    }

    public static function unlockMedal(id:Int)
    {
        if (loggedIn)
        {
            if (NG.core.medals.exists(id))
            {
                var medal:Medal = NG.core.medals.get(id);
				trace("-- [NGio] Unlocking Medal --");
				trace("ID: " + id);
				trace("Name: " + medal.name);
				trace("Description: " + medal.description);
				trace("-------------------------");

                if (!medal.unlocked)
                {
                    medal.sendUnlock();
                    trace("[NGio] Medal unlocked!");
                }
                else
                {
                    trace("Player already has Medal unlocked - Ignoring!");
                }
            }
        }
    }

    public static function postScore(boardID:Int, scoreFloat:Float)
    {
        if (loggedIn)
        {
            try
            {
                if (NG.core.scoreBoards.exists(boardID))
                    {
                        var scoreboard:ScoreBoard = NG.core.scoreBoards.get(boardID);
                        //var score = Std.parseInt(Std.string(scoreFloat).replace(".", "")) * 1000;
                        var ngScore = scoreFloat * 1000;
                        var score = Std.parseInt(Std.string(ngScore).replace(".", ""));
        
                        trace("-- [NGio] Posting Score --");
                        trace("Score: " + score);
                        trace("--------------------------");
        
                        scoreboard.postScore(score);
                        trace("[NGio] Posted score!");
                    }
            }
            catch (e)
            {
                trace("SHIT!!! I CRASHED!!!!!");
                trace("SEND THIS TO A CRAZY TOWN:");
                trace(e);
            }
        }
    }

    public static function logEvent(event:String)
    {
        NG.core.calls.event.logEvent(event).send();
        trace('should have logged: ' + event);
    }
}
#end