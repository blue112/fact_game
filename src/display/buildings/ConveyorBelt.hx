package display.buildings;

import display.Building;
import model.Item;

class ConveyorBelt extends Building
{
    var skipTick:Bool;

    public function new()
    {
        skipTick = false;

        super(CONVEYOR_BELT);
    }

    override private function work()
    {
        if (skipTick)
        {
            skipTick = false;
            return true;
        }

        var i = map.getFloorItem(posX, posY);
        if (i != null)
        {
            if (pushItem(i.getItem()))
            {
                map.removeFloorItem(posX, posY);
            }
        }

        return true;
    }

    override public function addItem(item:Item):Bool
    {
        skipTick = true;
        map.putFloorItem(posX, posY, item.getType());
        return true;
    }

    override public function acceptItem()
    {
        return !map.hasFloorItem(posX, posY);
    }

    override public function isBuildable(tile:Tile)
    {
        return true;
    }
}
