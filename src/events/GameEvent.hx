package events;

import flash.events.Event;

class GameEvent extends Event
{
    public var data:Dynamic;

    static public inline var SAVE:String = "game_event_save";
    static public inline var ESCAPE:String = "game_event_escape";

    public function new(type:String, ?data:Dynamic)
    {
        super(type);

        this.data = data;
    }

    override public function clone()
    {
        return new GameEvent(this.type, this.data);
    }
}
