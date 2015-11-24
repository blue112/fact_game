package model;

import display.Tile.TileType;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

@:bitmap("assets/wheat.png") class WheatPNG extends BitmapData {}
@:bitmap("assets/ironore.png") class IronOrePNG extends BitmapData {}
@:bitmap("assets/coal.png") class CoalPNG extends BitmapData {}
@:bitmap("assets/bread.png") class BreadPNG extends BitmapData {}
@:bitmap("assets/ironbar.png") class IronBarPNG extends BitmapData {}
@:bitmap("assets/miningengine.png") class MiningEnginePNG extends BitmapData {}

enum ItemType
{
    COAL;
    IRON;
    WHEAT;
    BREAD;
    IRON_BAR;
    MINING_ENGINE;
}

class Item
{
    var type:ItemType;
    var quantity:Int;
    var numPossessed:Null<Int>;

    static public inline var ITEM_WIDTH:Int = 50;
    static public inline var ITEM_HEIGHT:Int = 50;

    static public inline var ITEM_FLOOR_WIDTH:Int = 20;
    static public inline var ITEM_FLOOR_HEIGHT:Int = 20;

    public function new(type:ItemType, ?quantity:Int = 1)
    {
        this.type = type;
        this.quantity = quantity;
        this.numPossessed = null;
    }

    public function addNumPossessed(n:Int)
    {
        numPossessed = n;
    }

    private function getBitmapData()
    {
        var asset:BitmapData = switch (type)
        {
            case COAL: new CoalPNG(0,0);
            case IRON: new IronOrePNG(0,0);
            case WHEAT: new WheatPNG(0,0);
            case BREAD: new BreadPNG(0,0);
            case IRON_BAR: new IronBarPNG(0,0);
            case MINING_ENGINE: new MiningEnginePNG(0,0);
        };

        return asset;
    }

    public function isBuildable()
    {
        return switch (type)
        {
            case MINING_ENGINE: true;
            case COAL, IRON, WHEAT, BREAD, IRON_BAR: false;
        }
    }

    public function render(?with_number:Bool = true):Sprite
    {
        var asset:BitmapData = getBitmapData();

        var on = new Sprite();
        on.graphics.lineStyle(1, 0);
        on.addChild(new Bitmap(asset));

        var quantityText = Std.string(this.quantity);
        var color = 0xFFFFFF;

        if (numPossessed != null)
        {
            quantityText = numPossessed+" / "+this.quantity;

            if (numPossessed < this.quantity)
                color = 0xFFADAD;
        }

        if (with_number)
        {
            var quantityTF = new display.AutoTF(quantityText, false, 15, color, true);
            quantityTF.x = ITEM_WIDTH - quantityTF.width - 2;
            quantityTF.y = ITEM_HEIGHT - quantityTF.height - 2;
            on.addChild(quantityTF);
        }

        on.graphics.drawRect(0, 0, ITEM_WIDTH, ITEM_HEIGHT);

        return on;
    }

    public function renderFloorItem():Bitmap
    {
        var on = new Bitmap(getBitmapData());
        on.scaleX = on.scaleY = ITEM_FLOOR_WIDTH / ITEM_WIDTH;

        return on;
    }

    static public function tileToItem(type:TileType):ItemType
    {
        return switch (type)
        {
            case COAL: ItemType.COAL;
            case WHEAT: ItemType.WHEAT;
            case IRON: ItemType.IRON;
        }
    }

    public function getName():String
    {
        return switch (type)
        {
            case COAL: "Coal";
            case IRON: "Iron Ore";
            case WHEAT: "Wheat";
            case BREAD: "Bread";
            case IRON_BAR: "Iron Bar";
            case MINING_ENGINE: "Automated Mining Engine";
        };
    }

    public function getType()
    {
        return type;
    }

    public function increase()
    {
        quantity++;
        return quantity;
    }

    public function getQuantity()
    {
        return quantity;
    }

    public function setQuantity(q:Int):Int
    {
        this.quantity = q;
        return quantity;
    }
}
