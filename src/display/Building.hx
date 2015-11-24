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


    public function new(type:BuildingType)
    {
        this.type = type;

        var bdata =
        switch (type)
        {
            case MINING_ENGINE: new BuildingMiningEnginePNG(0, 0);
        };

        addChild(new Bitmap(bdata));

        super();
    }

    public function work()
    {
        if (isBuilt())
        {
            var t = map.getTile(posX, posY);
            t.automatedInteract();
        }
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
