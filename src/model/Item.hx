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
@:bitmap("assets/conveyorbelt.png") class ConveyorBeltPNG extends BitmapData {}
@:bitmap("assets/chest.png") class ChestPNG extends BitmapData {}
@:bitmap("assets/oven.png") class OvenPNG extends BitmapData {}
@:bitmap("assets/rim.png") class RimPNG extends BitmapData {}
@:bitmap("assets/stone.png") class StonePNG extends BitmapData {}
@:bitmap("assets/brick.png") class BrickPNG extends BitmapData {}
@:bitmap("assets/craftingmachine.png") class CraftingMachinePNG extends BitmapData {}
@:bitmap("assets/gear.png") class GearPNG extends BitmapData {}
@:bitmap("assets/srim.png") class SRimPNG extends BitmapData {}

enum ItemType
{
    COAL;
    IRON;
    WHEAT;
    BREAD;
    STONE;
    IRON_BAR;
    MINING_ENGINE;
    CONVEYOR_BELT;
    CHEST;
    OVEN;
    RIM;
    BRICK;
    GEAR;
    CRAFTING_MACHINE;
    SRIM;
}

class Item
{
    var type:ItemType;
    var quantity:Int;
    var numPossessed:Null<Int>;

    static public inline var ITEM_WIDTH:Int = 50;
    static public inline var ITEM_HEIGHT:Int = 50;

    static public inline var ITEM_FLOOR_WIDTH:Int = 80;
    static public inline var ITEM_FLOOR_HEIGHT:Int = 80;


    public function new(type:ItemType, ?quantity:Int = 1)
    {
        this.type = type;
        this.quantity = quantity;
        this.numPossessed = null;
    }

    public function toString()
    {
        return '[Item type="$type" quantity="$quantity"]';
    }

    public function clone():Item
    {
        var i = new Item(this.type, this.quantity);
        if (numPossessed != null)
            i.addNumPossessed(numPossessed);

        return i;
    }

    public function addNumPossessed(n:Int)
    {
        numPossessed = n;
    }

    public function getStackSize()
    {
        return switch (type)
        {
            case STONE, WHEAT, IRON, COAL: 128;
            case IRON_BAR: 256;
            case BREAD: 8;
            case MINING_ENGINE, CHEST, OVEN, RIM, SRIM, CRAFTING_MACHINE: 8;
            case CONVEYOR_BELT: 32;
            case BRICK: 32;
            case GEAR: 128;
        };
    }

    private function getBitmapData()
    {
        var asset:BitmapData = switch (type)
        {
            case COAL: new CoalPNG(0,0);
            case IRON: new IronOrePNG(0,0);
            case WHEAT: new WheatPNG(0,0);
            case BREAD: new BreadPNG(0,0);
            case STONE: new StonePNG(0,0);
            case IRON_BAR: new IronBarPNG(0,0);
            case MINING_ENGINE: new MiningEnginePNG(0,0);
            case CONVEYOR_BELT: new ConveyorBeltPNG(0,0);
            case CHEST: new ChestPNG(0,0);
            case OVEN: new OvenPNG(0,0);
            case RIM: new RimPNG(0,0);
            case BRICK: new BrickPNG(0,0);
            case GEAR: new GearPNG(0,0);
            case CRAFTING_MACHINE: new CraftingMachinePNG(0,0);
            case SRIM: new SRimPNG(0,0);
        };

        return asset;
    }

    public function isBuildable()
    {
        return switch (type)
        {
            case SRIM, MINING_ENGINE, CONVEYOR_BELT, CHEST, OVEN, RIM, BRICK, CRAFTING_MACHINE: true;
            case COAL, IRON, WHEAT, BREAD, IRON_BAR, STONE, GEAR: false;
        }
    }

    public function render(?with_number:Bool = true):Sprite
    {
        var asset:BitmapData = getBitmapData();

        var on = new Sprite();
        on.graphics.lineStyle(1, 0);
        var bmp = new Bitmap(asset);
        bmp.smoothing = true;
        on.addChild(bmp);

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
            case STONE: ItemType.STONE;
        }
    }

    public function getName():String
    {
        return switch (type)
        {
            case COAL: "Coal";
            case IRON: "Iron Ore";
            case BRICK: "Brick";
            case STONE: "Stone";
            case WHEAT: "Wheat";
            case BREAD: "Bread";
            case IRON_BAR: "Iron Bar";
            case MINING_ENGINE: "Automated Mining Engine";
            case CONVEYOR_BELT: "Conveyor Belt";
            case CHEST: "Chest";
            case OVEN: "Oven";
            case RIM: "Rotative Item Mover";
            case SRIM: "Strong RIM";
            case GEAR: "Gear";
            case CRAFTING_MACHINE: "Automated Crafting Machine";
        };
    }

    public function getType()
    {
        return type;
    }

    public function increase(?n:Int = 1)
    {
        quantity += n;
        return quantity;
    }

    public function canSmelt()
    {
        return switch (type)
        {
            case IRON: IRON_BAR;
            case STONE: BRICK;
            default: null;
        }
    }

    public function decrease(?n:Int = 1)
    {
        quantity -= n;
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
