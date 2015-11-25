package gui;

import flash.display.Sprite;
import model.Item;

class ItemSlot extends Sprite
{
    public function new(item:Null<Item>)
    {
        super();

        update(item);
    }

    public function update(item:Null<Item>)
    {
        graphics.clear();
        if (numChildren > 0)
            removeChildAt(0);

        if (item == null)
        {
            graphics.lineStyle(1, 0x000000);
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(0, 0, Item.ITEM_WIDTH, Item.ITEM_HEIGHT);
        }
        else
        {
            addChild(item.render(true));
        }
    }
}
