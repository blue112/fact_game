package events;

import flash.events.Event;

class CharEvent extends Event
{
    var char:Character;

    static public inline var CHAR_MOVED:String = "char_event_char_moved";
    static public inline var HUNGER_CHANGED:String = "char_event_hunger_changed";

    public function new(type:String, char:Character)
    {
        super(type);

        this.char = char;
    }

    override public function clone()
    {
        return new CharEvent(this.type, this.char);
    }
}
