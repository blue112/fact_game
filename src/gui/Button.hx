package gui;

import display.AutoTF;
import flash.display.Sprite;

class Button extends Sprite
{
    static private inline var BUTTON_WIDTH:Int = 60;
    static private inline var BUTTON_HEIGHT:Int = 20;

    public function new(text:String, cb:Void->Void)
    {
        super();

        graphics.lineStyle(2);
        graphics.beginFill(0xCCCCCC);
        graphics.drawRect(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT);

        buttonMode = true;

        var label = new AutoTF(text, false, 12, 0xFFFFFF, true);
        label.mouseEnabled = false;
        label.x = (BUTTON_WIDTH - label.width) / 2;
        label.y = (BUTTON_HEIGHT - label.height) / 2;
        addChild(label);

        addEventListener(flash.events.MouseEvent.CLICK, function(_)
        {
            cb();
        });
    }
}
