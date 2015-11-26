package display.buildings;

import display.Building;
import events.GUIEvent;
import flash.events.ProgressEvent;
import model.Item;

enum RimState
{
    WAITING_FOR_ITEM;
    MOVING_ITEM;
    WAIT_PUSH_ITEM;
    RETURN_TO_POSITION;
}

class Rim extends Building
{
    public var item_slot(default, null):Item;

    var state:RimState;
    var initial_rotation:Float;

    public function new()
    {
        state = WAITING_FOR_ITEM;

        super(RIM);
    }

    override private function work()
    {
        //TODO : Should take items from building

        switch (state)
        {
            case WAITING_FOR_ITEM:
                var c = getFrontCoordinates();
                if (map.hasFloorItem(c.x, c.y))
                {
                    item_slot = map.removeFloorItem(c.x, c.y).getItem();
                    initial_rotation = buildIcon.rotation;
                    state = MOVING_ITEM;
                }

            case MOVING_ITEM:
                buildIcon.rotation += 15; //12 ticks half turn => 1.2s => 2.4s + 0.1s to move an item and be back to original position
                if (buildIcon.rotation == (initial_rotation + 180) % 360)
                {
                    state = WAIT_PUSH_ITEM;
                }

            case WAIT_PUSH_ITEM:
                if (!pushItem(item_slot, getBackCoordinates()))
                {
                    return CANNOT_WORK;
                }

                state = RETURN_TO_POSITION;

            case RETURN_TO_POSITION:
                buildIcon.rotation += 10;
                if (buildIcon.rotation == initial_rotation)
                {
                    state = WAITING_FOR_ITEM;
                }
        }

        return WORKING;
    }

    override public function rotate()
    {
        if (state == WAITING_FOR_ITEM)
            super.rotate();
    }

    override private function acceptItem()
    {
        return state == WAITING_FOR_ITEM;
    }

    override private function addItem(item:model.Item)
    {
        if (state == WAITING_FOR_ITEM)
        {
            item_slot = item;
            initial_rotation = buildIcon.rotation;
            state = MOVING_ITEM;
            return true;
        }

        return false;
    }

    override public function isBuildable(tile:Tile)
    {
        return true;
    }
}
