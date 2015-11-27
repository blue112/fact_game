package display;

import events.InventoryEvent;
import events.MapEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import model.Item;

@:bitmap("assets/tile_iron.png") class TileIronPNG extends BitmapData {}
@:bitmap("assets/tile_iron2.png") class TileIron2PNG extends BitmapData {}
@:bitmap("assets/tile_iron3.png") class TileIron3PNG extends BitmapData {}
@:bitmap("assets/tile_coal.png") class TileCoalPNG extends BitmapData {}
@:bitmap("assets/tile_coal2.png") class TileCoal2PNG extends BitmapData {}
@:bitmap("assets/tile_coal3.png") class TileCoal3PNG extends BitmapData {}
@:bitmap("assets/tile_wheat.png") class TileWheatPNG extends BitmapData {}
@:bitmap("assets/tile_stone.png") class TileStonePNG extends BitmapData {}
@:bitmap("assets/tile_stone2.png") class TileStone2PNG extends BitmapData {}

enum TileType
{
    COAL;
    IRON;
    WHEAT;
    STONE;
}

class Tile
{
    var type:TileType;
    public var pos_x:Int;
    public var pos_y:Int;
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
            case STONE: 75;
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
            case STONE: "Stone";
        };
    }

    public function getType():TileType
    {
        return type;
    }

    public function automatedInteract(speed:Int):Null<ItemType>
    {
        if (lifepoint > 0)
        {
            lifepoint -= speed;

            return null;
        }
        else
        {
            lifepoint = getMaxLifePoint();
            //Get one elem and put it into player's inventory
            quantity--;
            checkQuantity();

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
            checkQuantity();
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, new Item(Item.tileToItem(this.type))));
        }
    }

    private function checkQuantity()
    {
        if (quantity <= 0)
        {
            EventManager.dispatch(new MapEvent(MapEvent.REMOVE_TILE, this));
        }
    }

    public function draw(on:Sprite, with_pos:Bool)
    {
        var asset:Array<Class<BitmapData>> = switch (type)
        {
            case COAL: [TileCoalPNG, TileCoal2PNG, TileCoal3PNG];
            case IRON: [TileIronPNG, TileIron2PNG, TileIron3PNG];
            case WHEAT: [TileWheatPNG];
            case STONE: [TileStone2PNG, TileStonePNG];
        };

        var pickedAsset:BitmapData = Type.createInstance(asset[Std.random(asset.length)], [0, 0]);

        on.graphics.lineStyle(1, 0);
        on.graphics.beginBitmapFill(pickedAsset);

        if (with_pos)
            on.graphics.drawRect(this.pos_x * Map.TILE_WIDTH, this.pos_y * Map.TILE_HEIGHT, Map.TILE_WIDTH, Map.TILE_HEIGHT);
        else
            on.graphics.drawRect(0, 0, Map.TILE_WIDTH, Map.TILE_HEIGHT);
    }
}
