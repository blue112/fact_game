package display;

import display.buildings.Chest;
import display.buildings.ConveyorBelt;
import display.buildings.CraftingMachine;
import display.buildings.MiningEngine;
import display.buildings.Oven;
import display.buildings.Rim;
import display.buildings.SRim;
import display.EmptyFuelSign;
import display.NotWorkingSign;
import display.Tile;
import display.Tile.TileType;
import events.MapEvent;
import events.UpdateEvent;
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
    RIM;
    SRIM;
    CRAFTING_MACHINE;
}

enum WorkState
{
    WORKING;
    CANNOT_WORK;
    FUEL_EMPTY;
}

@:bitmap("assets/building_mining_engine.png") class BuildingMiningEnginePNG extends BitmapData {}
@:bitmap("assets/building_conveyor_belt.png") class BuildingConveyorBeltPNG extends BitmapData {}
@:bitmap("assets/building_chest.png") class BuildingChestPNG extends BitmapData {}
@:bitmap("assets/building_oven.png") class BuildingOvenPNG extends BitmapData {}
@:bitmap("assets/building_rim.png") class BuildingRimPNG extends BitmapData {}
@:bitmap("assets/building_srim.png") class BuildingSRimPNG extends BitmapData {}
@:bitmap("assets/building_crafting_machine.png") class BuildingCraftingMachinePNG extends BitmapData {}

class Building extends Sprite
{
    var type:BuildingType;
    public var posX(default, null):Int;
    public var posY(default, null):Int;
    var map:Map;
    var sign:Sprite;

    static private inline var MAX_LIFEPOINT = 25;

    var buildIcon:Sprite;
    var lifepoint:Int;

    var workState:WorkState;
    var rotationState:Int; //0: face south, 1: west, 2: north, 3: east

    private function new(type:BuildingType)
    {
        this.type = type;

        workState = WORKING;
        rotationState = 0;
        lifepoint = MAX_LIFEPOINT;

        var bdata =
        switch (type)
        {
            case MINING_ENGINE: new BuildingMiningEnginePNG(0, 0);
            case CONVEYOR_BELT: new BuildingConveyorBeltPNG(0, 0);
            case CHEST: new BuildingChestPNG(0, 0);
            case OVEN: new BuildingOvenPNG(0, 0);
            case RIM: new BuildingRimPNG(0, 0);
            case SRIM: new BuildingSRimPNG(0, 0);
            case CRAFTING_MACHINE: new BuildingCraftingMachinePNG(0, 0);
        };

        buildIcon = new Sprite();
        var bmp = new Bitmap(bdata);
        bmp.smoothing = true;
        bmp.x = -bmp.width / 2;
        bmp.y = -bmp.height / 2;
        buildIcon.x = bmp.width / 2;
        buildIcon.y = bmp.height / 2;
        buildIcon.addChild(bmp);

        addChild(buildIcon);

        super();
    }

    private function updateWorkingState(w:WorkState)
    {
        if (workState == w)
            return;

        this.workState = w;
        var icon = switch (w)
        {
            case WORKING: null;
            case CANNOT_WORK: new NotWorkingSign();
            case FUEL_EMPTY: new EmptyFuelSign();
        }

        if (sign != null)
        {
            removeChild(sign);
            sign = null;
        }

        if (icon != null)
        {
            sign = icon;
            addChild(icon);
        }
    }

    private function updated()
    {
        dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE));
    }

    public function deconstruct()
    {
        lifepoint--;
        EventManager.dispatch(new MapEvent(MapEvent.DECONSTRUCTING_PROGRESS, {lifepoint: lifepoint, max:MAX_LIFEPOINT}));
        if (lifepoint == 0)
        {
            onDeconstructed();
            return true;
        }

        return false;
    }

    private function onDeconstructed()
    {
        //Handle inventory or slots
    }

    public function resetLP()
    {
        lifepoint = MAX_LIFEPOINT;
    }

    private function acceptItem(type:ItemType)
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

    private function canPushItem(i:Item, ?c:{x:Int, y:Int})
    {
        //Check if there's something on my tile
        if (c == null)
            c = getFrontCoordinates();

        if (!map.hasFloorItem(c.x, c.y))
        {
            var b = map.getBuilding(c.x, c.y);
            if (b != null)
            {
                if (b.acceptItem(i.getType()))
                {
                    if (i != null)
                    {
                        return true;
                    }
                }
                return false;
            }

            //Move it forward
            return true;
        }

        return false;
    }
    /**
    * Push an item to a tile forward
    * @arg i Item to push
    * @returns
    *   - true: if an item has been pushed
    *   - false: if an item couldn't be pushed
    */
    private function pushItem(i:Item, ?c:{x:Int, y:Int})
    {
        //Check if there's something on my tile
        if (c == null)
            c = getFrontCoordinates();

        if (!map.hasFloorItem(c.x, c.y))
        {
            var b = map.getBuilding(c.x, c.y);
            if (b != null)
            {
                if (b.acceptItem(i.getType()))
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

    private function getBackCoordinates()
    {
        var itemCoordX = posX;
        var itemCoordY = posY;

        switch (rotationState)
        {
            case 0: itemCoordY--;
            case 1: itemCoordX++;
            case 2: itemCoordY++;
            case 3: itemCoordX--;
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

    public function setRotationState(rotationState:Int)
    {
        this.rotationState = rotationState;
        buildIcon.rotation = rotationState * 90;
    }

    public function getRotationState()
    {
        return this.rotationState;
    }

    public function tryToWork()
    {
        if (isBuilt())
        {
            var state = work();
            updateWorkingState(state);
        }
    }

    private function work():WorkState
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

    public function isWalkable()
    {
        return switch (this.type)
        {
            case CHEST, CRAFTING_MACHINE, OVEN, RIM, SRIM, MINING_ENGINE: false;
            case CONVEYOR_BELT: true;
        }
    }

    static public function fromItem(type:ItemType)
    {
        return switch (type)
        {
            case ItemType.MINING_ENGINE: new MiningEngine();
            case ItemType.CONVEYOR_BELT: new ConveyorBelt();
            case ItemType.CHEST: new Chest();
            case ItemType.OVEN: new Oven();
            case ItemType.RIM: new Rim();
            case ItemType.SRIM: new SRim();
            case ItemType.CRAFTING_MACHINE: new CraftingMachine();
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
            case RIM: ItemType.RIM;
            case SRIM: ItemType.SRIM;
            case CRAFTING_MACHINE: ItemType.CRAFTING_MACHINE;
        }
    }
}
