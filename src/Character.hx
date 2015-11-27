import display.SpriteDisplay;
import events.CharEvent;
import flash.display.Sprite;
import flash.events.Event;
import haxe.Timer;
import model.Inventory;

@:bitmap("assets/char.png") class CharPNG extends flash.display.BitmapData {}

class Character extends Sprite
{
    public var pos_x(default, set):Int;
    public var pos_y(default, set):Int;
    public var inventory:Inventory;
    public var hunger:Int;

    static private var instance:Character;

    public var charSprite:SpriteDisplay;
    private var direction:Int;
    private var animation_state:Int;

    private var map:Map;

    static public inline var DIRECTION_UP:Int = 0;
    static public inline var DIRECTION_RIGHT:Int = 1;
    static public inline var DIRECTION_DOWN:Int = 2;
    static public inline var DIRECTION_LEFT:Int = 3;

    static private inline var FRAME_TIME:Int = 5;

    static public inline var MAX_HUNGER:Int = 100;

    static public function getInstance()
    {
        return instance;
    }

    public function new(m:Map)
    {
        super();

        instance = this;

        this.map = m;

        this.x = 0;
        this.y = 0;

        direction = DIRECTION_DOWN;

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

        charSprite = new display.SpriteDisplay(new CharPNG(0,0), 4, 4);
        charSprite.set(1, 2);
        this.addChild(charSprite);
        //this.graphics.beginFill(0x005F72);
        //this.graphics.drawRect(0, 0, 30, 50);
    }

    public function set_direction(direction:Int)
    {
        if (this.direction != direction)
        {
            this.direction = direction;
            animation_state = 0;
            charSprite.set(1, direction);
        }
    }

    public function set_walking(walking:Bool)
    {
        if (walking)
        {
            addEventListener(Event.ENTER_FRAME, animate);
        }
        else
        {
            charSprite.set(1, direction);
            removeEventListener(Event.ENTER_FRAME, animate);
        }
    }

    private function animate(_)
    {
        animation_state = (animation_state + 1) % (4 * FRAME_TIME);
        charSprite.set(Math.floor(animation_state / FRAME_TIME), direction);
    }

    private function set_pos_x(v:Int):Int
    {
        if (map.isWalkable(v, this.pos_y))
        {
            this.pos_x = v;
            updateChar();
        }
        return this.pos_x;
    }

    private function set_pos_y(v:Int):Int
    {
        if (map.isWalkable(this.pos_x, v))
        {
            this.pos_y = v;
            updateChar();
        }
        return this.pos_y;
    }

    private function updateChar()
    {
        this.dispatchEvent(new CharEvent(CharEvent.CHAR_MOVED, this));
    }
}
