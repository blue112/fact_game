package display;

import display.NotWorkingSign;
import display.Tile;
import display.Tile.TileType;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import model.Item.ItemType;

enum BuildingType
{
    MINING_ENGINE;
}

@:bitmap("assets/building_mining_engine.png") class BuildingMiningEnginePNG extends BitmapData {}

class Building extends Sprite
{
    var type:BuildingType;
    var posX:Int;
    var posY:Int;
    var map:Map;
    var not_working_sign:Sprite;

    var buildIcon:Sprite;

    var workState:Bool;
    var rotationState:Int; //0: face south, 1: west, 2: north, 3: east

    public function new(type:BuildingType)
    {
        this.type = type;

        workState = true;
        rotationState = 0;

        var bdata =
        switch (type)
        {
            case MINING_ENGINE: new BuildingMiningEnginePNG(0, 0);
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

    public function rotate()
    {
        rotationState = (rotationState + 1) % 4;
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
        var itemCoordX = posX;
        var itemCoordY = posY;

        switch (rotationState)
        {
            case 0: itemCoordY++;
            case 1: itemCoordX--;
            case 2: itemCoordY--;
            case 3: itemCoordX++;
        }

        if (map.hasFloorItem(itemCoordX, itemCoordY))
        {
            return false;
        }

        var t = map.getTile(posX, posY);

        var type = t.automatedInteract();
        if (type != null)
        {
            map.putFloorItem(itemCoordX, itemCoordY, type);
        }

        return true;
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
        switch (this.type)
        {
            case MINING_ENGINE:
                if (tile == null)
                    return false;

                return switch (tile.getType())
                {
                    case IRON, WHEAT, COAL: true;
                    default: return false;
                }
        }
    }

    static public function fromItem(type:ItemType)
    {
        var t:BuildingType = switch (type)
        {
            case ItemType.MINING_ENGINE: MINING_ENGINE;
            default: throw "Trying to build an unbuildable item type: "+type;
        }

        return new Building(t);
    }

    public function toItemType()
    {
        return switch (type)
        {
            case MINING_ENGINE: ItemType.MINING_ENGINE;
        }
    }
}
