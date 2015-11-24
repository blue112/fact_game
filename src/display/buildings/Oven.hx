package display.buildings;

import display.Building;
import model.Item;

class Oven extends Building
{
    var fuel_slot:Item;
    var ore_slot:Item;

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
            return true;
        }

        if (fuel_slot != null && ore_slot != null)
        {
            var type = ore_slot.canSmelt();
            if (type != null)
            {
                counter++;
                if (counter >= getSmeltingTime())
                {
                    if (!pushItem(new Item(type, 1)))
                    {
                        return false;
                    }

                    counter = 0;
                    fuel_slot.decrease();
                    if (fuel_slot.getQuantity() == 0)
                        fuel_slot = null;
                    ore_slot.decrease();
                    if (ore_slot.getQuantity() == 0)
                        ore_slot = null;
                }
            }
        }

        return true;
    }

    override public function addItem(item:Item):Bool
    {
        if (item.getType() == COAL && fuel_slot == null)
        {
            fuel_slot = item;
            return true;
        }

        if (item.getType() == IRON && ore_slot == null)
        {
            ore_slot = item;
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
