package display.buildings;

import display.Building;
import events.GUIEvent;
import events.InventoryEvent;
import events.UpdateEvent;
import flash.events.ProgressEvent;
import model.Item;

class MiningEngine extends Building
{
    static private var SPEED:Int = 5;

    public var fuel_slot:Item;
    var coal_life_point:Int;
    static inline var MAX_COAL_LIFE_POINT:Int = 1200; //1200 ticks => 120s => 2m

    public function new()
    {
        super(MINING_ENGINE);

        fuel_slot = null;
        coal_life_point = MAX_COAL_LIFE_POINT;
    }

    override public function interact()
    {
        EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_MINING_ENGINE_WINDOW, this));
    }

    override public function serialize()
    {
        var d:Dynamic = super.serialize();

        if (fuel_slot != null)
        {
            d.fuel_slot = {lifepoint: coal_life_point, item: fuel_slot.getType(), quantity: fuel_slot.getQuantity()};
        }

        return d;
    }

    override public function loadData(data:Dynamic)
    {
        if (data.fuel_slot != null)
        {
            fuel_slot = new Item(data.fuel_slot.item, data.fuel_slot.quantity);
            coal_life_point = data.fuel_slot.lifepoint;
        }
    }

    override private function work()
    {
        var c = getFrontCoordinates();
        var itemCoordX = c.x;
        var itemCoordY = c.y;

        if (map.hasFloorItem(itemCoordX, itemCoordY))
        {
            return CANNOT_WORK;
        }

        //Check fuel
        if (fuel_slot == null)
            return FUEL_EMPTY;

        coal_life_point--;
        dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, coal_life_point, MAX_COAL_LIFE_POINT));
        if (coal_life_point == 0)
        {
            if (fuel_slot.decrease() == 0)
                fuel_slot = null;

            dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE));
            coal_life_point = MAX_COAL_LIFE_POINT;
        }

        var t = map.getTile(posX, posY);

        var type = t.automatedInteract(SPEED);
        if (type != null)
        {
            pushItem(new model.Item(type));
        }

        return WORKING;
    }

    override private function onDeconstructed()
    {
        if (fuel_slot != null)
        {
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, fuel_slot));
        }
    }

    override public function isBuildable(tile:Tile)
    {
        if (tile == null)
            return false;

        return switch (tile.getType())
        {
            case IRON, WHEAT, COAL, STONE: true;
            default: return false;
        }
    }
}
