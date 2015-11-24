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

    public function addItem(item:Item)
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

        //TODO: Handle inventory limit
    }
}
