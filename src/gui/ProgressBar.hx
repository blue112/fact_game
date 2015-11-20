package gui;

import flash.display.Shape;
import flash.display.Sprite;
import model.Inventory;
import model.Item;

class ProgressBar extends Sprite
{
    static private inline var TOTAL_WIDTH:Int = 300;
    static private inline var BAR_HEIGHT:Int = 15;

    var bar:Shape;

    public function new()
    {
        super();

        var background = new Shape();

        background.graphics.lineStyle(2, 0x000000);
        background.graphics.beginFill(0x003C0C);
        background.graphics.drawRect(0, 0, TOTAL_WIDTH, BAR_HEIGHT);

        bar = new Shape();

        addChild(background);
        addChild(bar);
    }

    public function update(current:Int, max:Int)
    {
        bar.graphics.clear();
        bar.graphics.beginFill(0x00A020);
        bar.graphics.drawRect(0, 0, TOTAL_WIDTH * (1 - (current / max)), BAR_HEIGHT);
    }

}
