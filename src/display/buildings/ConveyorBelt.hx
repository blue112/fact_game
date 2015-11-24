package display.buildings;

import display.Building;

class ConveyorBelt extends Building
{
    public function new()
    {
        super(CONVEYOR_BELT);
    }

    override private function work()
    {
        //Check if there's something on my tile
        var item = map.removeFloorItem(posX, posY);
        if (item != null)
        {
            //Move it forward
            var c = getFrontCoordinates();
            if (!map.hasFloorItem(c.x, c.y))
            {
                map.putFloorItem(c.x, c.y, item.getItem().getType());
            }
        }

        return true;
    }

    override public function isBuildable(tile:Tile)
    {
        return true;
    }
}
