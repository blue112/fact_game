import events.CharEvent;
import flash.display.Sprite;

class Character extends Sprite
{
    public var pos_x(default, set):Int;
    public var pos_y(default, set):Int;

    public function new()
    {
        super();

        this.x = 0;
        this.y = 0;

        this.graphics.beginFill(0x005F72);
        this.graphics.drawRect(0, 0, 30, 50);
    }

    private function set_pos_x(v:Int):Int
    {
        this.pos_x = v;
        updateChar();
        return this.pos_x;
    }

    private function set_pos_y(v:Int):Int
    {
        this.pos_y = v;
        updateChar();
        return this.pos_y;
    }

    private function updateChar()
    {
        this.dispatchEvent(new CharEvent(CharEvent.CHAR_MOVED, this));
    }
}
