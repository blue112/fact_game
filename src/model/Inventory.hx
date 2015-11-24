package model;

import display.FloatingMessage;
import events.InventoryEvent;
import model.Item.ItemType;

class Inventory
{
    var items:Array<Item>;

    public function new()
    {
        items = [];

        EventManager.listen(InventoryEvent.ADD_ITEM, function(e:InventoryEvent)
        {
            addItem(e.data);
        });
        EventManager.listen(InventoryEvent.REMOVE_ITEM, function(e:InventoryEvent)
        {
            removeItem(e.data.type, e.data.quantity);
        });
    }

    public function removeItem(type:ItemType, quantity:Int)
    {
        for (i in items)
        {
            if (i.getType() == type)
            {
                if (i.getQuantity() <= quantity)
                {
                    items.remove(i);
                    return;
                }
                else
                {
                    i.setQuantity(i.getQuantity() - quantity);
                }
            }
        }
    }

    public function countItem(type:ItemType)
    {
        for (i in items)
        {
            if (i.getType() == type)
            {
                return i.getQuantity();
            }
        }

        return 0;
    }

    public function getItems()
    {
        return items.copy();
    }

    private function addItem(item:Item)
    {
        //Display text

        var totalQuantity = 1;
        for (i in items)
        {
            if (i.getType() == item.getType())
            {
                totalQuantity = i.increase();
            }
        }

        if (totalQuantity == 1)
        {
            //Not found
            items.push(item);
        }

        new FloatingMessage("+"+item.getQuantity()+" "+item.getName()+" ("+totalQuantity+")");
        //TODO: Handle inventory limit
    }
}
