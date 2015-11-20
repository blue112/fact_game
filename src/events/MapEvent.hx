package events;

import flash.events.Event;

class MapEvent extends Event
{
    public var data:Dynamic;

    static public inline var HOVER_TILE:String = "map_event_hover_tile";
    static public inline var GATHERING_PROGRESS:String = "map_event_gathering_progress";

    public function new(type:String, data:Dynamic)
    {
        super(type);

        this.data = data;
    }

    override public function clone()
    {
        return new MapEvent(this.type, this.data);
    }
}
