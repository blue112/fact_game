package display;

import flash.display.Sprite;
import model.Item;

class ItemOnFloor extends Sprite
{
    var posX:Int;
    var posY:Int;
    var item:Item;

    public function new(item:Item, posX:Int, posY:Int)
    {
        super();

        this.item = item;

        var s = item.renderFloorItem();
        s.x = (Map.TILE_WIDTH - Item.ITEM_FLOOR_WIDTH) / 2;
        s.y = (Map.TILE_HEIGHT - Item.ITEM_FLOOR_HEIGHT) / 2;
        addChild(s);

        buttonMode = true;

        this.posX = posX;
        this.posY = posY;

        this.x = this.posX * Map.TILE_WIDTH;
        this.y = this.posY * Map.TILE_HEIGHT;
    }

    public function getItem()
    {
        return item;
    }
}
