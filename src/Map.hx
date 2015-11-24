import display.Building;
import display.ItemOnFloor;
import events.BuildEvent;
import events.InventoryEvent;
import model.Item;
import display.Tile;
import display.Tile.TileType;
import events.CharEvent;
import events.MapEvent;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxe.ds.StringMap;

class Map extends Sprite
{
    var character:Character;

    static public inline var TILE_WIDTH:Int = 32;
    static public inline var TILE_HEIGHT:Int = 32;
    static public inline var MAP_WIDTH:Int = 50;
    static public inline var MAP_HEIGHT:Int = 50;
    static public inline var BACKGROUND_COLOR:Int = 0xCCCCCC;

    var tiles:StringMap<Tile>;
    var floorItems:StringMap<Array<ItemOnFloor>>;
    var buildings:StringMap<Building>;

    var currentTile:Null<Tile>;
    var currentBuilding:Building;

    var tile_hl:Sprite;
    var hoveredBuilding:Null<Building>;

    var tile_layer:Sprite;
    var building_layer:Sprite;
    var flooritem_layer:Sprite;
    var character_layer:Sprite;

    public function new()
    {
        super();

        hoveredBuilding = null;
        character = null;

        tile_layer = new Sprite();
        building_layer = new Sprite();
        flooritem_layer = new Sprite();
        character_layer = new Sprite();

        for (i in [tile_layer, building_layer, flooritem_layer, character_layer])
        {
            addChild(i);
        }

        tiles = new StringMap();
        floorItems = new StringMap();
        buildings = new StringMap();

        tile_hl = new Sprite();
        addChild(tile_hl);

        var numField = Std.random(7) + 7;

        tile_layer.graphics.beginFill(0xEEEEEE);
        tile_layer.graphics.drawRect(0, 0, MAP_WIDTH * TILE_WIDTH, MAP_HEIGHT * TILE_HEIGHT);

        tile_layer.graphics.lineStyle(1);

        //Let's draw the grid
        for (x in 0...MAP_WIDTH)
        {
            for (y in 0...MAP_HEIGHT)
            {
                tile_layer.graphics.beginFill(0x000000, Std.random(10) / 100 + 0.1);
                tile_layer.graphics.drawRect(x * TILE_WIDTH, y * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT);
            }
        }

        for (f in 0...numField)
        {
            //Let's add a field
            var choices = Type.allEnums(TileType);
            var field_type = choices[Std.random(choices.length)];
            var field_x = Std.random(Map.MAP_WIDTH);
            var field_y = Std.random(Map.MAP_HEIGHT);
            var field_size_x = Std.random(3) + 3;

            for (i in 0...field_size_x)
            {
                var field_size_y = Std.random(3) + 3;
                for (j in 0...field_size_y)
                {
                    var pos_x = field_x + i;
                    var pos_y = Std.int((field_y + j) - field_size_y / 2);

                    if (getTile(pos_x, pos_y) == null)
                    {
                        var t = new Tile(field_type, pos_x, pos_y);
                        t.draw(tile_layer, true);
                        setTile(pos_x, pos_y, t);
                    }
                }
            }
        }

        putFloorItem(19, 19, MINING_ENGINE);

        addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        addEventListener(MouseEvent.MOUSE_DOWN, onStartInteract);
        addEventListener(MouseEvent.MOUSE_UP, onStopInteract);

        EventManager.listen(BuildEvent.START_BUILDING, onStartBuilding);
        EventManager.listen(BuildEvent.ROTATE_BUILDING, onRotateBuildAsked);
    }

    private function onRotateBuildAsked(_)
    {
        if (currentBuilding != null)
        {
            currentBuilding.rotate();
        }
        else if (hoveredBuilding != null)
        {
            hoveredBuilding.rotate();
        }
    }

    private function onStartBuilding(e:BuildEvent)
    {
        var item:Item = e.data;

        var b = display.Building.fromItem(item.getType());

        currentBuilding = b;
    }

    /*private function renderTo(obj:Graphics, zone:Rectangle)
    {
        obj.beginFill(BACKGROUND_COLOR);
        obj.drawRect(0, 0, zone.width, zone.height);

        for (x in 0...Std.int(zone.width))
        {
            for (y in 0...Std.int(zone.height))
            {
                obj;
            }
        }
    }*/

    public function getTile(x:Int, y:Int)
    {
        return tiles.get(x+";"+y);
    }

    private function setTile(x:Int, y:Int, t:Tile)
    {
        tiles.set(x+";"+y, t);
    }

    public function putFloorItem(x:Int, y:Int, t:ItemType)
    {
        var posX = x;
        var posY = y;
        var floorItem = new display.ItemOnFloor(new Item(t), x, y);
        flooritem_layer.addChild(floorItem);
        addFloorItem(x, y, floorItem);
    }

    private function addFloorItem(x:Int, y:Int, t:ItemOnFloor)
    {
        var key = x+";"+y;

        if (floorItems.exists(key))
        {
            floorItems.get(key).push(t);
        }
        else
        {
            floorItems.set(key, [t]);
        }
    }

    public function hasFloorItem(x:Int, y:Int):Bool
    {
        return floorItems.exists(x+";"+y);
    }

    public function getAllBuildings()
    {
        var a = [];
        for (i in buildings)
            a.push(i);

        return a;
    }

    private function setBuilding(x:Int, y:Int, b:Building)
    {
        buildings.set(x+";"+y, b);
    }

    private function getBuilding(x:Int, y:Int):Null<Building>
    {
        return buildings.get(x+";"+y);
    }

    public function removeFloorItem(x:Int, y:Int):Null<ItemOnFloor>
    {
        var item = pickOneFloorItem(x, y);
        if (item != null)
        {
            flooritem_layer.removeChild(item);
        }

        return item;
    }

    private function pickOneFloorItem(x:Int, y:Int)
    {
        var key = x+";"+y;

        if (floorItems.exists(key))
        {
            var a = floorItems.get(key);
            if (a.length == 1)
            {
                floorItems.remove(key);
            }
            return a.pop();
        }

        return null;
    }

    private function getPosFromMouseEvent(e:MouseEvent)
    {
        var mapX = e.stageX - this.x;
        var mapY = e.stageY - this.y;

        var posX = Math.floor(mapX / TILE_WIDTH);
        var posY = Math.floor(mapY / TILE_HEIGHT);

        return {x:posX, y:posY};
    }

    private function onMouseMove(e:MouseEvent)
    {
        //Translate to map coordinate
        var pos = getPosFromMouseEvent(e);
        var posX = pos.x;
        var posY = pos.y;

        //Highlight tile
        tile_hl.x = posX * TILE_WIDTH;
        tile_hl.y = posY * TILE_HEIGHT;

        drawBuildingGhost(posX, posY);

        hoveredBuilding = getBuilding(posX, posY);

        //Calculate distance from char
        var dist = Math.sqrt((character.pos_x - posX) * (character.pos_x - posX) + (character.pos_y - posY) * (character.pos_y - posY));
        drawTileHL(isReachable(posX, posY));

        var t = getTile(posX, posY);

        EventManager.dispatch(new MapEvent(MapEvent.HOVER_TILE, t));
    }

    private function canPlaceBuilding(posX:Int, posY:Int)
    {
        if (currentBuilding != null)
        {
            if (isReachable(posX, posY))
            {
                var t = getTile(posX, posY);

                if (getBuilding(posX, posY) == null && currentBuilding.isBuildable(t))
                {
                    return true;
                }
            }
        }

        return false;
    }

    private function drawBuildingGhost(posX:Int, posY:Int)
    {
        if (currentBuilding != null)
        {
            if (canPlaceBuilding(posX, posY))
            {
                currentBuilding.x = posX * TILE_WIDTH;
                currentBuilding.y = posY * TILE_HEIGHT;

                if (currentBuilding.parent == null)
                {
                    currentBuilding.alpha = 0.5;
                    building_layer.addChild(currentBuilding);
                }

                currentBuilding.visible = true;
            }
            else
            {
                currentBuilding.visible = false;
            }
        }
    }

    private function onStartInteract(e:MouseEvent)
    {
        var pos = getPosFromMouseEvent(e);
        var posX = pos.x;
        var posY = pos.y;

        if (!isReachable(posX, posY))
            return;

        if (canPlaceBuilding(posX, posY))
        {
            currentBuilding.alpha = 1;
            setBuilding(posX, posY, currentBuilding);
            currentBuilding.build(this, posX, posY);
            EventManager.dispatch(new InventoryEvent(InventoryEvent.REMOVE_ITEM, {type:currentBuilding.toItemType(), quantity:1}));
            currentBuilding = null;
            return;
        }

        //Is there a floor item here ?
        if (hasFloorItem(posX, posY))
        {
            var floorItem = pickOneFloorItem(posX, posY);

            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, floorItem.getItem()));
            flooritem_layer.removeChild(floorItem);
            return;
        }

        var t = getTile(posX, posY);

        if (t != null)
        {
            currentTile = t;
            addEventListener(Event.ENTER_FRAME, onInteracting);
        }
    }

    private function onStopInteract(e:MouseEvent)
    {
        currentTile = null;
        removeEventListener(Event.ENTER_FRAME, onInteracting);
    }

    private function onInteracting(_)
    {
        if (currentTile != null)
        {
            currentTile.interact();
        }
    }

    private function isReachable(posX:Int, posY:Int)
    {
        var dist = Math.sqrt((character.pos_x - posX) * (character.pos_x - posX) + (character.pos_y - posY) * (character.pos_y - posY));
        return dist <= 5;
    }

    private function drawTileHL(reachable:Bool)
    {
        tile_hl.graphics.clear();

        if (!reachable)
            tile_hl.graphics.beginFill(0xFF0000, 0.3);

        tile_hl.graphics.lineStyle(2, if (reachable) 0xFFFFFF else 0xFF0000);
        tile_hl.graphics.drawRect(0, 0, TILE_WIDTH, TILE_HEIGHT);
    }

    public function setCharacter(c:Character)
    {
        this.character = c;

        c.addEventListener(CharEvent.CHAR_MOVED, updateCharPos);

        updateCharPos();
        character_layer.addChild(c);
    }

    private function updateCharPos(?_)
    {
        character.x = (TILE_WIDTH * character.pos_x) + (TILE_WIDTH - character.width) / 2;
        character.y = (TILE_HEIGHT * character.pos_y) - (character.height - TILE_HEIGHT);
    }
}
