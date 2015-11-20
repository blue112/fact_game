package display;

import display.AutoTF;
import flash.display.Sprite;
import flash.Lib;

using feffects.Tween.TweenObject;

class FloatingMessage extends Sprite
{
    public function new(text:String)
    {
        super();

        addChild(new AutoTF(text, true, 30, 0xFFFFFF, true));

        this.x = (Lib.current.stage.stageWidth - this.width) / 2;
        this.y = (Lib.current.stage.stageHeight - this.height) / 2;

        this.tween({alpha: 0, y: y - 50}, 1000).onFinish(function()
        {
            Lib.current.stage.removeChild(this);
        }).start();

        Lib.current.stage.addChild(this);
    }
}
