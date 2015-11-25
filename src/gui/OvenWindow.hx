package gui;

import display.buildings.Oven;
import events.BuildEvent;
import events.InventoryEvent;
import events.UpdateEvent;
import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import gui.InventoryArea;
import gui.ItemSlot;
import model.Inventory;
import model.Item;

@:bitmap("assets/icon_flame.png") class FlamePNG extends flash.display.BitmapData {}

class OvenWindow extends Window
{
    static private inline var WINDOW_WIDTH:Int = 550;
    static private inline var WINDOW_HEIGHT:Int = 300;
    static private inline var MARGIN:Int = 30;

    static private inline var OVEN_AREA_SIZE:Int = 150;

    var area:InventoryArea;

    public function new(inv:Inventory, oven:Oven)
    {
        area = new InventoryArea(WINDOW_WIDTH - OVEN_AREA_SIZE, WINDOW_HEIGHT, inv, true);
        addChild(area);

        super("Oven", WINDOW_WIDTH, WINDOW_HEIGHT);

        var ovenArea = new Sprite();
        ovenArea.x = WINDOW_WIDTH - OVEN_AREA_SIZE;
        ovenArea.graphics.lineStyle(1);
        ovenArea.graphics.moveTo(0, 0);
        ovenArea.graphics.lineTo(0, WINDOW_HEIGHT);
        addChild(ovenArea);

        var flame = new Bitmap(new FlamePNG(0, 0));
        flame.x = (OVEN_AREA_SIZE - flame.width) / 2;

        var ore_slot = new ItemSlot(oven.ore_slot);
        var fuel_slot = new ItemSlot(oven.fuel_slot);

        for (i in [ore_slot, fuel_slot])
        {
            i.x = (OVEN_AREA_SIZE - i.width) / 2;
            ovenArea.addChild(i);
        }

        var ovenProgressBar = new gui.ProgressBar(100, 10);
        ovenProgressBar.x = (OVEN_AREA_SIZE - ovenProgressBar.width) / 2;
        ovenProgressBar.y = MARGIN;
        ovenArea.addChild(ovenProgressBar);

        oven.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent)
        {
            ovenProgressBar.update(Std.int(e.bytesLoaded), Std.int(e.bytesTotal));
        });
        oven.addEventListener(UpdateEvent.UPDATE, function(e:UpdateEvent)
        {
            ore_slot.update(oven.ore_slot);
            fuel_slot.update(oven.fuel_slot);
        });

        ovenArea.addChild(flame);

        ore_slot.y = ovenProgressBar.y + ovenProgressBar.height + 10;
        flame.y = ore_slot.y + ore_slot.height - 5;
        fuel_slot.y = flame.y + flame.height;
    }

    override public function update()
    {
        area.update();
    }
}
