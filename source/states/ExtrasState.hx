package states;

import utils.Language;
import utils.GameInfo;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import props.Background;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
#if ng
import utils.NGio;
#end

typedef PowerupData = 
{
    id:Int,
    name:String,
    description:String,
    imageName:String,
    price:Int,
    unlocked:Bool,
    equipped:Bool
}

typedef PowerupSave = 
{
    id:Int,
    unlocked:Bool,
    equipped:Bool
}

class ShopItem extends FlxSpriteGroup
{
    public var id:Int = 0;

    public var name:String = "";
	public var description:String = "";
	public var price:Int = 0;
	public var unlocked:Bool = false;
	public var equipped:Bool = false;

    public var targetX:Float = 0;

	var nameText:FlxText;
	public var priceText:FlxText;

    public function new(X:Float, Y:Float, id:Int)
    {
        super(X, Y);

        this.id = id;

        name = ShopState.powerups[id].name;
        description = ShopState.powerups[id].description;
        price = ShopState.powerups[id].price;
        unlocked = ShopState.powerups[id].unlocked;
        equipped = ShopState.powerups[id].equipped;

        var bg:FlxSprite = new FlxSprite(x, y).makeGraphic(380, 330, FlxColor.BLACK); // 375, 325
		add(bg);

		var image:FlxSprite = new FlxSprite(x + 5, y + 75).loadGraphic("assets/images/powerups/" + ShopState.powerups[id].imageName + ".png");
		add(image);

		nameText = new FlxText(x + 50, image.height + 35, 0, this.name, 32);
		nameText.antialiasing = false;
		add(nameText);

		priceText = new FlxText(nameText.x, nameText.y + 45, 0, '${Language.data.ExtrasState.ShopState.price}: ' + price + ' ${Language.data.ExtrasState.ShopState.points.toLowerCase()}', 24);
		add(priceText);

        bg.screenCenter(FlxAxes.Y);

		updateData();
    }

    override function update(elapsed:Float):Void
    {
        x = FlxMath.lerp(x, (targetX * 600) + 135, 0.17);
        super.update(elapsed);
    }

    public function updateData()
    {
        unlocked = ShopState.powerups[id].unlocked;
        equipped = ShopState.powerups[id].equipped;

        if (unlocked)
        {
            if (equipped)
            {
                priceText.text = Language.data.ExtrasState.ShopState.equipped;
            }
            else
            {
                priceText.text = Language.data.ExtrasState.ShopState.equip;
            }
        }
        else
        {
            priceText.text = '${Language.data.ExtrasState.ShopState.price}: ' + price + ' ${Language.data.ExtrasState.ShopState.points.toLowerCase()}';
        }
    }
}

class ShopState extends FlxTransitionableState
{
    // grrr double array access grrr
    public static var powerups:Array<PowerupData> = [];

    public static var saveData:Array<PowerupSave> = [];

    var curSelected:Int = 0;

    var itemGroup:FlxTypedGroup<ShopItem>;
    var pointText:FlxText;

    override function create()
    {
        // powerup initialization
        powerups = [
            {id: 0, name: Language.data.ExtrasState.ShopState.shop_items[0][0], description: Language.data.ExtrasState.ShopState.shop_items[0][1], imageName: "additionalHeart", price: 1000, unlocked: false, equipped: false},
            {id: 1, name: Language.data.ExtrasState.ShopState.shop_items[1][0], description: Language.data.ExtrasState.ShopState.shop_items[1][1], imageName: "speedBoost", price: 2500, unlocked: false, equipped: false}
        ];

        initSaveData();

        for (i in 0...powerups.length)
        {
            powerups[i].unlocked = saveData[i].unlocked;
            powerups[i].equipped = saveData[i].equipped;
        }

        var bg:Background = new Background(-5.5, -25.8, "assets/images/bg/background.png");
		bg.addAdditionalImageAssets([[-11.35, -53.15]], [['assets/images/bg/circles.png']]);
		bg.tweenAsset(bg.additionalAssets[0], {y: -836.55}, 35, null, true);
		add(bg);

        itemGroup = new FlxTypedGroup<ShopItem>();
		add(itemGroup);

        for (i in 0...powerups.length)
        {
			var item:ShopItem = new ShopItem(0, 0, i);
            item.ID = i;
			item.x = i * 60;
			item.targetX = i;

			itemGroup.add(item);
        }

		pointText = new FlxText(0, 5, 0, '${Language.data.ExtrasState.ShopState.points}: ' + FlxG.save.data.points, 20);
		pointText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
		pointText.x = (FlxG.width - pointText.width) - 5;
		add(pointText);

        super.create();
    }

    override function update(elapsed:Float)
    {
		if (FlxG.keys.justPressed.ENTER)
		{
			onEnter();
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			changeItem(-1);
		}
		if (FlxG.keys.justPressed.RIGHT)
		{
			changeItem(1);
		}

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new TitleState());

        super.update(elapsed);
    }

    function onEnter()
    {
        if (saveData[curSelected].unlocked)
        {
            powerups[curSelected].equipped = !powerups[curSelected].equipped;

            var equippedPowerups = powerups.filter((powerup)-> powerup.equipped);
            if (equippedPowerups.length >= 1)
            {
                for (powerup in equippedPowerups)
                {
                    if (powerup.id == curSelected)
                        GameInfo.equippedPowerup = powerup.id;

                    powerup.equipped = (powerup.id == curSelected) ? true : false;
                }
            }
            else if (equippedPowerups.length <= 0)
            {
                GameInfo.equippedPowerup = Std.int(Math.NEGATIVE_INFINITY);
            }
        }
        else
        {
            if (powerups[curSelected].price <= Std.int(FlxG.save.data.points))
            {
                FlxG.save.data.points = Std.int(FlxG.save.data.points) - powerups[curSelected].price;
                //pointText.text = '${Language.data.ExtrasState.ShopState.points}: '+ FlxG.save.data.points;
                updatePointsText();

                // ka ching sound should go here
                // Update March 11th 2022: Ka ching is finally real
                FlxG.sound.play("assets/sounds/cashregister" + GameInfo.audioExtension);

                powerups[curSelected].unlocked = true;
            }
            else
            {
                trace("Purchase denied: Insufficient funds");
            }
        }

        for (i in 0...powerups.length)
        {
            saveData[i].equipped = powerups[i].equipped;
            saveData[i].unlocked = powerups[i].unlocked;
        }

        FlxG.save.data.equippedPowerup = GameInfo.equippedPowerup;

        FlxG.save.data.powerupData = saveData;
        FlxG.save.flush();

        #if ng
        var boughtPowerups = powerups.filter((powerup)-> powerup.unlocked);
        if (boughtPowerups.length == powerups.length)
        {
            NGio.unlockMedal(65992);
        }
        #end

        for (item in itemGroup.members)
        {
            item.updateData();
        }
    }

    function changeItem(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected >= powerups.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = powerups.length - 1;

        var posTracker:Int = 0;

        for (item in itemGroup.members)
        {
            item.targetX = posTracker - curSelected;
            posTracker++;

            item.alpha = 0.6;

            if (item.targetX == 0)
            {
                item.alpha = 1;
            }
        }
    }

    function updatePointsText()
    {
        pointText.text = '${Language.data.ExtrasState.ShopState.points}: ' + FlxG.save.data.points;
        pointText.x = (FlxG.width - pointText.width) - 5;
    }

    function initSaveData()
    {
        if (FlxG.save.data.powerupData == null)
        {
            FlxG.save.data.powerupData/*:Array<PowerupSave>*/ = [];

            for (i in 0...powerups.length)
            {
                FlxG.save.data.powerupData.push({id: i, unlocked: false, equipped: false});
            }

            trace("POWERUP DATA CREATED");
        }
        else
        {
            trace("POWERUP DATA EXISTS");
        }

        saveData = FlxG.save.data.powerupData;
    }
}