import events.CharEvent;
import flash.display.Sprite;
import haxe.Timer;
import model.Inventory;

@:bitmap("assets/char.png") class CharPNG extends flash.display.BitmapData {}

class Character extends Sprite
{
    public var pos_x(default, set):Int;
    public var pos_y(default, set):Int;
    public var inventory:Inventory;
    public var hunger:Int;

    static public inline var MAX_HUNGER:Int = 100;

    public function new()
    {
        super();

        this.x = 0;
        this.y = 0;

        hunger = MAX_HUNGER;

        var hungerTimer = new Timer(10000);
        hungerTimer.run = function()
        {
            hunger--;
            if (hunger == 0)
            {
                //TODO
            }
            EventManager.dispatch(new CharEvent(CharEvent.HUNGER_CHANGED, this));
        };

        this.inventory = new Inventory();

        this.pos_x = 20;
        this.pos_y = 20;

        this.addChild(new flash.display.Bitmap(new CharPNG(0,0)));
        //this.graphics.beginFill(0x005F72);
        //this.graphics.drawRect(0, 0, 30, 50);
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
