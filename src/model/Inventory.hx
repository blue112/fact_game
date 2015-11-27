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
        for (n in 0...quantity)
        {
            for (i in items)
            {
                if (i.getType() == type)
                {
                    if (i.getQuantity() == 1)
                        items.remove(i);
                    else
                        i.decrease();

                    break;
                }
            }
        }
        dispatchEvent(new InventoryEvent(InventoryEvent.CHANGE));
    }

    public function countItem(type:ItemType)
    {
        var totalQuantity:Int = 0;
        for (i in items)
        {
            if (i.getType() == type)
            {
                totalQuantity += i.getQuantity();
            }
        }

        return totalQuantity;
    }

    public function getItems()
    {
        return items.copy();
    }

    public function addItem(item:Item)
    {
        var added = item.getQuantity();
        while (item.getQuantity() > 0)
        {
            var notFullStackFound = false;
            for (i in items)
            {
                if (i.getType() == item.getType() && i.getQuantity() < i.getStackSize())
                {
                    i.increase();
                    item.decrease();
                    notFullStackFound = true;
                }
            }

            if (!notFullStackFound)
            {
                //Not found
                items.push(item);
                break;
            }
        }

        dispatchEvent(new InventoryEvent(InventoryEvent.CHANGE));

        return {added: added,item:item, totalQuantity: countItem(item.getType())};
        //TODO: Handle inventory limit
    }
}
