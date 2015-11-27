package gui;

import events.BuildEvent;
import events.InventoryEvent;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import gui.InventoryArea;
import model.Inventory;
import model.Item;

class InventoryWindow extends Window
{
    static private inline var WINDOW_WIDTH:Int = 400;
    static private inline var WINDOW_HEIGHT:Int = 300;
    static private inline var MARGIN:Int = 30;

    var area:InventoryArea;

    public function new(inv:Inventory, type:InventoryType)
    {
        area = new InventoryArea(WINDOW_WIDTH, WINDOW_HEIGHT, inv, type);
        addChild(area);

        super(getName(type), WINDOW_WIDTH, WINDOW_HEIGHT);
    }

    private function getName(type:InventoryType)
    {
        return switch (type)
        {
            case PLAYER: "Inventory";
            case CHEST: "Chest's content";
            case CUSTOM(_): "Items";
        }
    }

    public function setInventory(inv:Inventory, type:InventoryType)
    {
        setTitle(getName(type));

        area.setInventory(inv, type);
    }

    override public function update()
    {
        area.update();
    }
}
