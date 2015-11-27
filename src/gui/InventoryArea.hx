package gui;

import events.BuildEvent;
import events.InventoryEvent;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import model.Inventory;
import model.Item;

enum InventoryType
{
    PLAYER;
    CHEST;
    CUSTOM(cb:Item->Void);
}

class InventoryArea extends Sprite
{
    static private inline var MARGIN:Int = 30;

    var inventoryModel:Inventory;
    var inventoryType:InventoryType;

    var h:Int;
    var w:Int;

    public function new(w:Int, h:Int, inv:Inventory, inventoryType:InventoryType)
    {
        this.inventoryModel = inv;
        this.inventoryType = inventoryType;

        this.w = w;
        this.h = h;

        inv.addEventListener(InventoryEvent.CHANGE, onInventoryChange);

        super();
    }

    public function setInventory(inv:Inventory, inventoryType:InventoryType)
    {
        inv.removeEventListener(InventoryEvent.CHANGE, onInventoryChange);
        this.inventoryModel = inv;
        this.inventoryType = inventoryType;
        inv.addEventListener(InventoryEvent.CHANGE, onInventoryChange);
    }

    private function onInventoryChange(_)
    {
        update();
    }

    public function clear()
    {
        while (numChildren > 0)
            removeChildAt(0);
    }

    public function update()
    {
        clear();

        var numPerLine = Math.floor((w - MARGIN * 2) / Item.ITEM_WIDTH);
        var numLine = Math.floor((h - MARGIN * 2) / Item.ITEM_HEIGHT);

        var n = 0;
        for (i in inventoryModel.getItems())
        {
            var itemSprite = i.render();
            itemSprite.buttonMode = true;
            itemSprite.addEventListener(MouseEvent.CLICK, onItemClick.bind(i));
            itemSprite.x = MARGIN + (n % numPerLine) * (itemSprite.width + 5);
            itemSprite.y = MARGIN + Math.floor(n / numPerLine) * (itemSprite.height + 5);
            addChild(itemSprite);

            n++;
        }

        var i = 0;
        for (x in 0...numPerLine)
        {
            for (y in 0...numLine)
            {
                if (n <= i)
                {
                    var empty = new Shape();
                    empty.graphics.lineStyle(1, 0x000000);
                    empty.graphics.beginFill(0xFFFFFF);
                    empty.graphics.drawRect(0, 0, Item.ITEM_WIDTH, Item.ITEM_HEIGHT);
                    empty.x = MARGIN + (i % numPerLine) * (empty.width + 5);
                    empty.y = MARGIN + Math.floor(i / numPerLine) * (empty.height + 5);
                    addChild(empty);
                }

                i++;
            }
        }
    }

    private function onItemClick(item:Item, _)
    {
        switch (inventoryType)
        {
            case PLAYER:
                if (item.isBuildable())
                {
                    EventManager.dispatch(new BuildEvent(BuildEvent.START_BUILDING, item));
                }
            case CHEST:
                var toAdd = new Item(item.getType(), item.getQuantity());
                if (Character.getInstance().inventory.canAddItem(toAdd))
                {
                    EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, toAdd));
                    inventoryModel.removeItem(item.getType(), item.getQuantity());
                }
            case CUSTOM(cb):
                cb(item);
        }
    }

}
