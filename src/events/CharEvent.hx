package events;

import flash.events.Event;

class CharEvent extends Event
{
    var char:Character;

    static public inline var CHAR_MOVED:String = "char_event_char_moved";

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
