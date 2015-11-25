package events;

import flash.events.Event;

class UpdateEvent extends Event
{
    public var data:Dynamic;

    static public inline var UPDATE:String = "update_event_update";

    public function new(type:String, ?data:Dynamic)
    {
        super(type);

        this.data = data;
    }

    override public function clone()
    {
        return new UpdateEvent(this.type, this.data);
    }
}
