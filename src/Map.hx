import events.CharEvent;
import flash.display.Sprite;
import flash.events.MouseEvent;

class Map extends Sprite
{
    var character:Character;

    static public inline var TILE_WIDTH:Int = 32;
    static public inline var TILE_HEIGHT:Int = 32;

    var tile_hl:Sprite;

    public function new()
    {
        super();

        character = null;

        tile_hl = new Sprite();
        tile_hl.graphics.lineStyle(2, 0xFFFFFF);
        tile_hl.graphics.drawRect(0, 0, TILE_WIDTH, TILE_HEIGHT);
        tile_hl.x = 0;
        tile_hl.y = 0;
        addChild(tile_hl);

        this.graphics.beginFill(0xCCCCCC);
        this.graphics.drawRect(0, 0, 5000, 5000);

        flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    private function onMouseMove(e:MouseEvent)
    {
        //Translate to map coordinate
        var mapX = e.stageX - this.x;
        var mapY = e.stageY - this.y;

        var posX = Math.floor(mapX / TILE_WIDTH);
        var posY = Math.floor(mapY / TILE_HEIGHT);

        //Highlight tile
        tile_hl.x = posX * TILE_WIDTH;
        tile_hl.y = posY * TILE_HEIGHT;
    }

    public function setCharacter(c:Character)
    {
        this.character = c;

        c.addEventListener(CharEvent.CHAR_MOVED, updateCharPos);

        addChild(c);
    }

    private function updateCharPos(_)
    {
        character.x = TILE_WIDTH * character.pos_x;
        character.y = TILE_HEIGHT * character.pos_y;
    }
}
