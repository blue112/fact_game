package display.buildings;

import display.Building;
import events.GUIEvent;
import events.InventoryEvent;
import model.Inventory;
import model.Item;

class Chest extends Building
{
    private var inventory:Inventory;

    public function new()
    {
        inventory = new Inventory();

        super(CHEST);
    }

    override public function serialize()
    {
        var d:Dynamic = super.serialize();
        d.inventory = inventory.serialize();
        return d;
    }

    override public function loadData(data:Dynamic)
    {
        if (data.inventory != null)
        {
            inventory.load(data.inventory);
        }
    }

    override private function onDeconstructed()
    {
        for (i in inventory.getItems())
        {
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, i));
        }
    }

    override private function acceptItem(_)
    {
        return true;
    }

    override public function interact()
    {
        //Opens the chest inventory window
        EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_INVENTORY, inventory));
    }

    override private function addItem(item:Item)
    {
        inventory.addItem(item);
        return true;
    }

    override private function work()
    {
        return WORKING;
    }

    override public function isBuildable(tile:Tile)
    {
        return true;
    }
}
