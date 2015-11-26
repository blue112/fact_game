package gui;

import display.buildings.MiningEngine;
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

class MiningEngineWindow extends Window
{
    static private inline var WINDOW_WIDTH:Int = 550;
    static private inline var WINDOW_HEIGHT:Int = 300;
    static private inline var MARGIN:Int = 30;

    static private inline var ME_AREA_SIZE:Int = 150;

    var area:InventoryArea;
    var mining_engine:MiningEngine;
    var inv:Inventory;

    var fuel_slot:ItemSlot;

    public function new(inv:Inventory, mining_engine:MiningEngine)
    {
        area = new InventoryArea(WINDOW_WIDTH - ME_AREA_SIZE, WINDOW_HEIGHT, inv, InventoryType.CUSTOM(onItemClick));
        addChild(area);

        this.mining_engine = mining_engine;
        this.inv = inv;

        var miningEngineArea = new Sprite();
        miningEngineArea.x = WINDOW_WIDTH - ME_AREA_SIZE;
        miningEngineArea.graphics.lineStyle(1);
        miningEngineArea.graphics.moveTo(0, 0);
        miningEngineArea.graphics.lineTo(0, WINDOW_HEIGHT);
        addChild(miningEngineArea);

        fuel_slot = new ItemSlot(mining_engine.fuel_slot);
        fuel_slot.x = (ME_AREA_SIZE - fuel_slot.width) / 2;
        miningEngineArea.addChild(fuel_slot);

        var fuelProgressBar = new gui.ProgressBar(100, 10);
        fuelProgressBar.x = (ME_AREA_SIZE - fuelProgressBar.width) / 2;
        fuelProgressBar.y = MARGIN;
        miningEngineArea.addChild(fuelProgressBar);

        mining_engine.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent)
        {
            fuelProgressBar.update(Std.int(e.bytesLoaded), Std.int(e.bytesTotal));
        });
        mining_engine.addEventListener(UpdateEvent.UPDATE, function(e:UpdateEvent)
        {
            update();
        });

        fuel_slot.y = fuelProgressBar.y + fuelProgressBar.height + 10;

        super(new Item(mining_engine.toItemType()).getName(), WINDOW_WIDTH, WINDOW_HEIGHT);
    }

    private function onItemClick(item:Item)
    {
        if (item.getType() == COAL && mining_engine.fuel_slot == null)
        {
            mining_engine.fuel_slot = new Item(item.getType(), 1);
            inv.removeItem(item.getType(), 1);
            update();
        }
    }

    override public function update()
    {
        fuel_slot.update(mining_engine.fuel_slot);
        area.update();
    }
}
