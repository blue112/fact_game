package events;

import flash.events.Event;

class BuildEvent extends Event
{
    public var data:Dynamic;

    static public inline var START_BUILDING:String = "build_event_start_building";
    static public inline var ROTATE_BUILDING:String = "build_event_rotate_building";

    public function new(type:String, ?data:Dynamic)
    {
        super(type);

        this.data = data;
    }

    override public function clone()
    {
        return new BuildEvent(this.type, this.data);
    }
}
