package events;

import flash.events.Event;

class GUIEvent extends Event
{
    public var data:Dynamic;

    static public inline var OPEN_INVENTORY:String = "gui_event_open_inventory";
    static public inline var OPEN_CRAFT_WINDOW:String = "gui_event_open_craft_window";
    static public inline var OPEN_DEBUG_WINDOW:String = "gui_event_open_debug_window";
    static public inline var CLOSE_ACTIVE_WINDOW:String = "gui_event_close_active_window";
    static public inline var OPEN_OVEN_WINDOW:String = "gui_event_open_oven_window";
    static public inline var OPEN_MINING_ENGINE_WINDOW:String = "gui_event_open_mining_engine_window";
    static public inline var OPEN_CRAFTING_MACHINE_WINDOW:String = "gui_event_open_crafting_machine_window";

    public function new(type:String, ?data:Dynamic)
    {
        super(type);

        this.data = data;
    }

    override public function clone()
    {
        return new GUIEvent(this.type, this.data);
    }
}
