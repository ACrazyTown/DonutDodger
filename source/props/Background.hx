package props;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;

/*
* This entire file is somewhat broken, lol!
*/

class Background extends FlxSpriteGroup
{
    public var additionalAssets:Array<FlxSprite> = [];
    public var bg:FlxSprite;

    var moveTween:FlxTween;

    // TWEEN SPECIFIC STUFF
    var _asset:FlxSprite;
    var _tweenValues:Dynamic;
    var _tweenTime:Float;
    var _tweenOptions:TweenOptions;

    public function new(x:Float = 0, y:Float = 0, imagePath:String)
    {
        super(x, y);

        bg = new FlxSprite(DP.getX(x),DP.getY(y)).loadGraphic(imagePath);
        add(bg);
    }

	public function addAdditionalImageAssets(additionalImageXY:Array<Array<Float>>, additionalImagePaths:Array<Array<String>>)
	{
		if (additionalImagePaths != null)
		{
			if (additionalImagePaths.length == additionalImageXY.length)
			{
				for (i in 0...additionalImagePaths.length)
				{
					var bgAsset:FlxSprite = new FlxSprite(additionalImageXY[i][0], additionalImageXY[i][1]).loadGraphic(additionalImagePaths[i][0]);
					add(bgAsset);

					additionalAssets.push(bgAsset); // because I cannot make groups in FlxSpriteGroups
				}
			}
			else
			{
				trace("Not enough XY positions specified!");
				return;
			}
		}
    }

    public function makeAdditionalAssets(assetXY:Array<Array<Float>>, assetWH:Array<Array<Int>>, assetColors:Array<FlxColor>, ?assetAlphas:Array<Float>)
    {
		var sameLengths = assetXY.length == assetWH.length && assetXY.length == assetColors.length && assetWH.length == assetColors.length;
        if (sameLengths)
        {
            for (i in 0...assetXY.length)
            {
                var bgAsset:FlxSprite = new FlxSprite(assetXY[i][0], assetXY[i][1]).makeGraphic(assetWH[i][0], assetWH[i][1], assetColors[i]);

                if (assetAlphas != null && assetAlphas.length == assetXY.length)
                {
                    bgAsset.alpha = assetAlphas[i];
                }
    
                add(bgAsset);
            }
        }
    }

    public function tweenAsset(asset:FlxSprite, tweenValues:Dynamic, tweenTime:Float, ?tweenOptions:TweenOptions, ?looped:Bool = false)
    {
        _asset = asset;
        _tweenValues = tweenValues;
        _tweenTime = tweenTime;

        if (tweenOptions != null)
        {
            _tweenOptions = tweenOptions;
            moveTween = FlxTween.tween(asset, tweenValues, tweenTime, tweenOptions);
        }
        else
        {
			moveTween = FlxTween.tween(asset, tweenValues, tweenTime);
        }

        if (looped != null)
            moveTween.onComplete = (t:FlxTween) ->
            {
                onTweenComplete(looped);
            }
    }

    function onTweenComplete(looped:Bool)
    {
        if (looped)
        {
			FlxG.log.add("AssetTween> Looping");
			resetValues();
			//_asset.y = -53.15;

            if (_tweenOptions != null)
                tweenAsset(_asset, _tweenValues, _tweenTime, _tweenOptions);
            else
				tweenAsset(_asset, _tweenValues, _tweenTime);
        }
    }

    function resetValues()
    {
        _asset.y = -53.15;
        FlxG.log.add("Values reset!");
    }
}