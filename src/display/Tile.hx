package display;

import events.InventoryEvent;
import events.MapEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import model.Item;

@:bitmap("assets/tile_iron.png") class TileIronPNG extends BitmapData {}
@:bitmap("assets/tile_coal.png") class TileCoalPNG extends BitmapData {}
@:bitmap("assets/tile_wheat.png") class TileWheatPNG extends BitmapData {}

enum TileType
{
    COAL;
    IRON;
    WHEAT;
}

class Tile
{
    var type:TileType;
    var pos_x:Int;
    var pos_y:Int;
    var quantity:Int;
    var lifepoint:Int;

    public function new(type:TileType, x:Int, y:Int)
    {
        this.type = type;
        this.pos_x = x;
        this.pos_y = y;
        this.quantity = Std.random(200) + 100;

        this.lifepoint = getMaxLifePoint();
    }

    public function serialize()
    {
        return {type: type, pos_x: pos_x, pos_y: pos_y, quantity: quantity, lifepoint:lifepoint};
    }

    static public function load(data:Dynamic):Tile
    {
        var t = new Tile(data.type, data.pos_x, data.pos_y);
        t.quantity = data.quantity;
        t.lifepoint = data.lifepoint;
        return t;
    }

    private function getMaxLifePoint()
    {
        return switch (type)
        {
            case COAL: 100;
            case IRON: 200;
            case WHEAT: 30;
        }
    }

    public function getQuantity():Int
    {
        return quantity;
    }

    public function getName():String
    {
        return switch (type)
        {
            case COAL: "Coal";
            case IRON: "Iron";
            case WHEAT: "Wheat";
        };
    }

    public function getType():TileType
    {
        return type;
    }

    public function automatedInteract():Null<ItemType>
    {
        if (lifepoint > 0)
        {
            lifepoint -= 10;

            return null;
        }
        else
        {
            lifepoint = getMaxLifePoint();
            //Get one elem and put it into player's inventory
            quantity--;

            return Item.tileToItem(this.type);
        }
    }

    public function interact()
    {
        if (lifepoint > 0)
        {
            lifepoint--;
            EventManager.dispatch(new MapEvent(MapEvent.GATHERING_PROGRESS, {lifepoint: lifepoint, max: getMaxLifePoint()}));
        }
        else
        {
            lifepoint = getMaxLifePoint();
            //Get one elem and put it into player's inventory
            quantity--;
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, new Item(Item.tileToItem(this.type))));
        }
    }

    public function draw(on:Sprite, with_pos:Bool)
    {
        var asset = switch (type)
        {
            case COAL: new TileCoalPNG(0,0);
            case IRON: new TileIronPNG(0,0);
            case WHEAT: new TileWheatPNG(0,0);
        };

        on.graphics.lineStyle(1, 0);
        on.graphics.beginBitmapFill(asset);

        if (with_pos)
            on.graphics.drawRect(this.pos_x * Map.TILE_WIDTH, this.pos_y * Map.TILE_HEIGHT, Map.TILE_WIDTH, Map.TILE_HEIGHT);
        else
            on.graphics.drawRect(0, 0, Map.TILE_WIDTH, Map.TILE_HEIGHT);
    }
}
