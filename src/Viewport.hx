import events.CharEvent;
import flash.display.Sprite;

class Viewport extends Sprite
{
    var map:Map;
    var character:Character;

    var vp_height:Int;
    var vp_width:Int;

    public function new(w:Int, h:Int, map:Map, char:Character)
    {
        super();

        this.vp_width = w;
        this.vp_height = h;

        this.character = char;
        this.map = map;

        this.addChild(map);

        char.addEventListener(CharEvent.CHAR_MOVED, updateMapPos);
        updateMapPos(null);
    }

    public function updateMapPos(_)
    {
        map.x = this.vp_width / 2 - (character.pos_x * Map.TILE_WIDTH);
        map.y = this.vp_height / 2 - (character.pos_y * Map.TILE_HEIGHT);
    }
}
