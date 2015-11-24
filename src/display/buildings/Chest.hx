package display.buildings;

import display.Building;
import events.GUIEvent;
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

    override private function acceptItem()
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
        return true;
    }

    override public function isBuildable(tile:Tile)
    {
        return true;
    }
}
