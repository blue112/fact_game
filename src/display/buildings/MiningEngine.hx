package display.buildings;

import display.Building;

class MiningEngine extends Building
{
    public function new()
    {
        super(MINING_ENGINE);
    }

    override private function work()
    {
        var c = getFrontCoordinates();
        var itemCoordX = c.x;
        var itemCoordY = c.y;

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

    override public function isBuildable(tile:Tile)
    {
        if (tile == null)
            return false;

        return switch (tile.getType())
        {
            case IRON, WHEAT, COAL: true;
            default: return false;
        }
    }
}
