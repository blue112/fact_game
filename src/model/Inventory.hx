package model;

import display.FloatingMessage;
import events.InventoryEvent;
import flash.events.EventDispatcher;
import model.Item.ItemType;

class Inventory extends EventDispatcher
{
    var items:Array<Item>;

    public function new()
    {
        super();

        items = [];
    }

    public function serialize()
    {
        var inv = [];

        for (i in items)
        {
            inv.push({type: i.getType(), quantity: i.getQuantity()});
        }

        return inv;
    }

    public function load(data:Dynamic)
    {
        for (i in (data:Array<Dynamic>))
        {
            items.push(new Item(i.type, i.quantity));
        }
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
                    dispatchEvent(new InventoryEvent(InventoryEvent.CHANGE));
                    return;
                }
                else
                {
                    i.setQuantity(i.getQuantity() - quantity);
                    dispatchEvent(new InventoryEvent(InventoryEvent.CHANGE));
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

    public function addItem(item:Item)
    {
        //Display text

        var totalQuantity = 1;
        for (i in items)
        {
            if (i.getType() == item.getType())
            {
                totalQuantity = i.increase(item.getQuantity());
                dispatchEvent(new InventoryEvent(InventoryEvent.CHANGE));
            }
        }

        if (totalQuantity == 1)
        {
            //Not found
            items.push(item);
            dispatchEvent(new InventoryEvent(InventoryEvent.CHANGE));
        }

        //TODO: Handle inventory limit
    }
}
