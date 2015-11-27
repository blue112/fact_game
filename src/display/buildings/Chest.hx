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
        inventory = new Inventory(1);

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
        var invClone = Character.getInstance().inventory.clone();
        for (i in inventory.getItems())
        {
            if (invClone.canAddItem(i))
            {
                invClone.addItem(i);
            }
            else
            {
                return false;
            }
        }

        for (i in inventory.getItems())
        {
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, i));
        }

        return true;
    }

    override private function acceptItem(item:ItemType)
    {
        return inventory.canAddItem(new Item(item));
    }

    override public function interact()
    {
        //Opens the chest inventory window
        EventManager.dispatch(new GUIEvent(GUIEvent.OPEN_INVENTORY, inventory));
    }

    override private function addItem(item:Item)
    {
        return inventory.addItem(item) != null;
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
