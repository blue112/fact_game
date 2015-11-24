package events;

import flash.events.Event;

class InventoryEvent extends Event
{
    public var data:Dynamic;

    static public inline var ADD_ITEM:String = "inventory_event_add_item";
    static public inline var REMOVE_ITEM:String = "inventory_event_remove_item";

    public function new(type:String, data:Dynamic)
    {
        super(type);

        this.data = data;
    }

    override public function clone()
    {
        return new InventoryEvent(this.type, this.data);
    }
}
