package gui;

import display.AutoTF;
import flash.display.Shape;
import flash.display.Sprite;
import model.Inventory;
import model.Item;

class HungerBar extends Sprite
{
    static private inline var TOTAL_WIDTH:Int = 150;
    static private inline var BAR_HEIGHT:Int = 15;

    var bar:Shape;
    var progressTF:AutoTF;

    public function new()
    {
        super();

        var background = new Shape();
        background.graphics.lineStyle(2, 0x000000);
        background.graphics.beginFill(0x500500);
        background.graphics.drawRect(0, 0, TOTAL_WIDTH, BAR_HEIGHT);

        bar = new Shape();

        progressTF = new AutoTF("100/100", false, 10, 0xFFFFFF);
        progressTF.x = (background.width - progressTF.width) / 2;
        progressTF.y = (background.height - progressTF.height) / 2;

        addChild(background);
        addChild(bar);
        addChild(progressTF);
    }

    public function update(current:Int, max:Int)
    {
        bar.graphics.clear();
        bar.graphics.beginFill(0xB15E00);
        bar.graphics.drawRect(0, 0, TOTAL_WIDTH * (current / max), BAR_HEIGHT);

        progressTF.text = current+"/"+max;
    }

}
