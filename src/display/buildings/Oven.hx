package display.buildings;

import display.Building;
import events.GUIEvent;
import events.InventoryEvent;
import flash.events.ProgressEvent;
import model.Item;

class Oven extends Building
{
    public var fuel_slot:Item;
    public var ore_slot:Item;

    var counter:Int;
    var skipTick:Bool;

    public function new()
    {
        skipTick = false;

        counter = 0;

        super(OVEN);
    }

    private function getSmeltingTime()
    {
        return 20; //2 sec
    }

    override private function work()
    {
        if (skipTick)
        {
            skipTick = false;
            return WORKING;
        }

        if (fuel_slot == null)
        {
            return FUEL_EMPTY;
        }

        if (ore_slot != null)
        {
            var type = ore_slot.canSmelt();
            if (type != null)
            {
                if (counter >= getSmeltingTime())
                {
                    if (!pushItem(new Item(type, 1)))
                    {
                        return CANNOT_WORK;
                    }

                    counter = 0;

                    fuel_slot.decrease();
                    if (fuel_slot.getQuantity() == 0)
                        fuel_slot = null;

                    ore_slot.decrease();
                    if (ore_slot.getQuantity() == 0)
                        ore_slot = null;

                    updated();
                }
                else
                {
                    counter++;
                    dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, counter, getSmeltingTime()));
                }
            }
        }

        return WORKING;
    }

    override public function interact()
    {
        //Opens the chest inventory window
        EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_OVEN_WINDOW, this));
    }

    override private function onDeconstructed()
    {
        if (fuel_slot != null)
        {
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, fuel_slot));
        }
        if (ore_slot != null)
        {
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, ore_slot));
        }
    }

    override public function addItem(item:Item):Bool
    {
        if (item.getType() == COAL && fuel_slot == null)
        {
            fuel_slot = item;
            updated();
            return true;
        }

        if (item.canSmelt() != null && ore_slot == null)
        {
            ore_slot = item;
            updated();
            return true;
        }

        return false;
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
