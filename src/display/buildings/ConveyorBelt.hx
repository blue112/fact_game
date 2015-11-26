package display.buildings;

import display.Building;
import display.ItemOnFloor;
import model.Item;

enum BeltState
{
    WAITING;
    MOVING;
}

class ConveyorBelt extends Building
{
    var skipTick:Bool;

    var counter:Int;
    static private inline var TIME_TO_MOVE:Int = 5; //0.5s

    var item:ItemOnFloor;
    var state:BeltState;

    public function new()
    {
        skipTick = false;

        state = WAITING;
        item = null;

        super(CONVEYOR_BELT);
    }

    override private function work()
    {
        if (skipTick)
        {
            skipTick = false;
            return WORKING;
        }

        switch (state)
        {
            case WAITING:
                var i = map.getFloorItem(posX, posY);
                if (i != null && canPushItem(i.getItem()))
                {
                    item = i;
                    state = MOVING;
                }
            case MOVING:
                if (counter == TIME_TO_MOVE)
                {
                    if (pushItem(item.getItem()))
                    {
                        map.removeFloorItem(posX, posY);
                        item = null;
                        state = WAITING;
                        counter = 0;
                    }
                }
                else
                {
                    switch (rotationState)
                    {
                        case 0: item.y = (item.posY * Map.TILE_HEIGHT) + Map.TILE_HEIGHT * (counter / TIME_TO_MOVE);
                        case 1: item.x = (item.posX * Map.TILE_WIDTH) - Map.TILE_WIDTH * (counter / TIME_TO_MOVE);
                        case 2: item.y = (item.posY * Map.TILE_HEIGHT) - Map.TILE_HEIGHT * (counter / TIME_TO_MOVE);
                        case 3: item.x = (item.posX * Map.TILE_WIDTH) + Map.TILE_WIDTH * (counter / TIME_TO_MOVE);
                    }
                    counter++;
                }
        }

        return WORKING;
    }

    override public function addItem(item:Item):Bool
    {
        skipTick = true;
        map.putFloorItem(posX, posY, item.getType());
        return true;
    }

    override public function acceptItem(_)
    {
        return !map.hasFloorItem(posX, posY);
    }

    override public function isBuildable(tile:Tile)
    {
        return true;
    }
}
