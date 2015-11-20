package gui;

import display.AutoTF;
import flash.display.Sprite;
import model.Inventory;

class Window extends Sprite
{
    static private inline var WINDOW_WIDTH:Int = 400;
    static private inline var WINDOW_HEIGHT:Int = 300;
    static private inline var TITLE_BAR_HEIGHT:Int = 20;

    var titleTF:AutoTF;

    public function new(title:String, w:Int, h:Int)
    {
        super();

        graphics.lineStyle(1, 0x000000);
        graphics.beginFill(0x999999);
        graphics.drawRect(0, -TITLE_BAR_HEIGHT, w, TITLE_BAR_HEIGHT);

        titleTF = new AutoTF(title, false, 12, 0xFFFFFF, true);
        titleTF.x = (w - titleTF.width) / 2;
        titleTF.y = -TITLE_BAR_HEIGHT + (TITLE_BAR_HEIGHT - titleTF.height) / 2;
        addChild(titleTF);

        graphics.beginFill(0xEEEEEE);
        graphics.drawRect(0, 0, w, h);
        update();
    }

    private function clear()
    {
        while (numChildren > 0)
            removeChildAt(0);

        addChild(titleTF);
    }

    public function show()
    {
        update();
        this.visible = true;
    }

    public function update()
    {
        throw "Must be overwritten.";
    }

    public function close()
    {
        this.visible = false;
    }
}
