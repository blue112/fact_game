package display;

import display.buildings.Chest;
import display.buildings.ConveyorBelt;
import display.buildings.MiningEngine;
import display.buildings.Oven;
import display.NotWorkingSign;
import display.Tile;
import display.Tile.TileType;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import model.Item;
import model.Item.ItemType;

enum BuildingType
{
    MINING_ENGINE;
    CONVEYOR_BELT;
    CHEST;
    OVEN;
}

@:bitmap("assets/building_mining_engine.png") class BuildingMiningEnginePNG extends BitmapData {}
@:bitmap("assets/building_conveyor_belt.png") class BuildingConveyorBeltPNG extends BitmapData {}
@:bitmap("assets/building_chest.png") class BuildingChestPNG extends BitmapData {}
@:bitmap("assets/building_oven.png") class BuildingOvenPNG extends BitmapData {}

class Building extends Sprite
{
    var type:BuildingType;
    public var posX(default, null):Int;
    public var posY(default, null):Int;
    var map:Map;
    var not_working_sign:Sprite;

    var buildIcon:Sprite;

    var workState:Bool;
    var rotationState:Int; //0: face south, 1: west, 2: north, 3: east

    private function new(type:BuildingType)
    {
        this.type = type;

        workState = true;
        rotationState = 0;

        var bdata =
        switch (type)
        {
            case MINING_ENGINE: new BuildingMiningEnginePNG(0, 0);
            case CONVEYOR_BELT: new BuildingConveyorBeltPNG(0, 0);
            case CHEST: new BuildingChestPNG(0, 0);
            case OVEN: new BuildingOvenPNG(0, 0);
        };

        buildIcon = new Sprite();
        var bmp = new Bitmap(bdata);
        bmp.x = -bmp.width / 2;
        bmp.y = -bmp.height / 2;
        buildIcon.x = bmp.width / 2;
        buildIcon.y = bmp.height / 2;
        buildIcon.addChild(bmp);

        addChild(buildIcon);

        not_working_sign = new NotWorkingSign();
        addChild(not_working_sign);

        super();
    }

    private function acceptItem()
    {
        return false;
    }

    private function addItem(item:model.Item)
    {
        return false;
    }

    public function interact()
    {
        //Nothing to do
    }

    /**
    * Push an item to a tile forward
    * @arg i Item to push
    * @returns
    *   - true: if an item has been pushed
    *   - false: if an item couldn't be pushed
    */
    private function pushItem(i:Item)
    {
        //Check if there's something on my tile
        var c = getFrontCoordinates();
        if (!map.hasFloorItem(c.x, c.y))
        {
            var b = map.getBuilding(c.x, c.y);
            if (b != null)
            {
                if (b.acceptItem())
                {
                    if (i != null)
                    {
                        return b.addItem(i);
                    }
                }
                return false;
            }

            //Move it forward
            map.putFloorItem(c.x, c.y, i.getType());
            return true;
        }

        return false;
    }

    private function getFrontCoordinates()
    {
        var itemCoordX = posX;
        var itemCoordY = posY;

        switch (rotationState)
        {
            case 0: itemCoordY++;
            case 1: itemCoordX--;
            case 2: itemCoordY--;
            case 3: itemCoordX++;
        }

        return {x:itemCoordX, y:itemCoordY};
    }

    public function serialize()
    {
        return {posX:posX, posY:posY, rotationState: rotationState, type: toItemType()};
    }

    static public function load(map:Map, data:Dynamic):Building
    {
        var b = fromItem(data.type);
        b.setRotationState(data.rotationState);
        b.build(map, data.posX, data.posY);
        b.loadData(data);

        return b;
    }

    public function loadData(data:Dynamic)
    {

    }

    public function rotate()
    {
        this.setRotationState((rotationState + 1) % 4);
    }

    private function setRotationState(rotationState:Int)
    {
        this.rotationState = rotationState;
        buildIcon.rotation = rotationState * 90;
    }

    public function tryToWork()
    {
        if (isBuilt())
        {
            if (!work())
            {
                not_working_sign.visible = true;
            }
            else
            {
                not_working_sign.visible = false;
            }
        }
    }

    private function work():Bool
    {
        throw "Should be overwritten";
    }

    public function build(map:Map, x:Int, y:Int)
    {
        this.posX = x;
        this.posY = y;
        this.map = map;
    }

    public function destroy()
    {
        map = null;
    }

    public function isBuilt()
    {
        return this.map != null;
    }

    public function isBuildable(tile:Tile)
    {
        return false;
    }

    static public function fromItem(type:ItemType)
    {
        return switch (type)
        {
            case ItemType.MINING_ENGINE: new MiningEngine();
            case ItemType.CONVEYOR_BELT: new ConveyorBelt();
            case ItemType.CHEST: new Chest();
            case ItemType.OVEN: new Oven();
            default: throw "Trying to build an unbuildable item type: "+type;
        }
    }

    public function toItemType()
    {
        return switch (type)
        {
            case MINING_ENGINE: ItemType.MINING_ENGINE;
            case CONVEYOR_BELT: ItemType.CONVEYOR_BELT;
            case CHEST: ItemType.CHEST;
            case OVEN: ItemType.OVEN;
        }
    }
}
