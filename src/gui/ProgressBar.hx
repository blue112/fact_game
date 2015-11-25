package gui;

import flash.display.Shape;
import flash.display.Sprite;
import model.Inventory;
import model.Item;

class ProgressBar extends Sprite
{
    private var totalWidth:Int;
    private var totalHeight:Int;

    var bar:Shape;

    public function new(w:Int, ?h:Int = 15)
    {
        super();

        this.totalWidth = w;
        this.totalHeight = h;

        var background = new Shape();

        background.graphics.lineStyle(2, 0x000000);
        background.graphics.beginFill(0x003C0C);
        background.graphics.drawRect(0, 0, totalWidth, totalHeight);

        bar = new Shape();

        addChild(background);
        addChild(bar);
    }

    public function update(current:Int, max:Int)
    {
        bar.graphics.clear();
        bar.graphics.beginFill(0x00A020);
        bar.graphics.drawRect(0, 0, totalWidth * (current / max), totalHeight);
    }

}
