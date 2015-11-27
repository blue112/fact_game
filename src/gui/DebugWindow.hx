package gui;

import display.AutoTF;
import events.InventoryEvent;
import events.UpdateEvent;
import gui.Button;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import gui.InventoryArea;
import model.Inventory;
import model.Item;

class DebugWindow extends Window
{
    static private inline var MARGIN:Int = 30;

    static private inline var WINDOW_WIDTH:Int = 400;
    static private inline var WINDOW_HEIGHT:Int = 300;

    var number:Int;
    var ia:InventoryArea;

    public function new()
    {
        super("Debug Window", WINDOW_WIDTH, WINDOW_HEIGHT);

        number = 1;

        var numberSelect = new gui.NumberSelect();
        numberSelect.addEventListener(UpdateEvent.UPDATE, function(_)
        {
            number = numberSelect.getNumber();
            update();
        });
        numberSelect.x = (WINDOW_WIDTH - numberSelect.width) / 2;
        numberSelect.y = (WINDOW_HEIGHT - numberSelect.height) - 10;
        addChild(numberSelect);
    }

    override public function update()
    {
        if (ia != null)
            removeChild(ia);

        var m = new Inventory();
        for (i in Type.allEnums(ItemType))
        {
            m.addItem(new Item(i, number));
        }

        ia = new InventoryArea(WINDOW_WIDTH, WINDOW_HEIGHT, m, InventoryType.CUSTOM(function(i:Item)
        {
            EventManager.dispatch(new InventoryEvent(InventoryEvent.ADD_ITEM, new Item(i.getType(), number)));
        }));
        ia.update();
        addChild(ia);
    }
}
