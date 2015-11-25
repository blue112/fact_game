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

    public function new(inv:Inventory, isPlayer:Bool)
    {
        area = new InventoryArea(WINDOW_WIDTH, WINDOW_HEIGHT, inv, isPlayer);
        addChild(area);

        super("Inventory", WINDOW_WIDTH, WINDOW_HEIGHT);
    }

    public function setInventory(inv:Inventory, isPlayer:Bool)
    {
        area.setInventory(inv, isPlayer);
    }

    override public function update()
    {
        area.update();
    }
}
