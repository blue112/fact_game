package display;

import flash.display.Sprite;
import model.Item;

class ItemOnFloor extends Sprite
{
    public var posX:Int;
    public var posY:Int;
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

        filters = [new flash.filters.GlowFilter(0xFFFFFF, 0.8, 2, 2, 10)];

        this.x = this.posX * Map.TILE_WIDTH;
        this.y = this.posY * Map.TILE_HEIGHT;
    }

    public function serialize()
    {
        return {posX: posX, posY: posY, item:item.getType()};
    }

    public function getItem()
    {
        return item;
    }
}
